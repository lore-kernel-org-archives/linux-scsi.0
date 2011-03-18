From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] firmware/efi: export a routine to retrieve efi-variables by
	GUID
Date: Fri, 18 Mar 2011 15:16:22 -0700
Message-ID: <20110318221606.26841.92271.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939Ab1CRWMp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2011 18:12:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@suse.de
Cc: Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, linux-kernel@vger.kernel.org, dmilburn@redhat.com, edmund.nadolski@intel.com

From: Dave Jiang <dave.jiang@intel.com>

The efivars module already scans all available variables, normalizes the
variable names, and stores them in a list.  Rather than duplicate this
to efi runtime services interface let drivers query variable data by
GUID.

This is needed by the isci driver which relies on an efi variable to
store critical platform parameters like gloablly unique sas addresses
and phy configuration parameters.  This is similar to the
pci_map_biosrom() enabling that allows the isci driver to retrieve the
same data in the non-efi case.

For the built-in case efivars is moved to subsys_initcall.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Not sure who looks after efivars.c, but get_maintainer.pl and git shortlog
fingered Greg as a likely target.

We are currently targeting a late merge of the isci driver through the
staging tree into 2.6.39.  This is a pre-requisite to be able to use the
driver on an efi enabled platform.

--
Dan

 drivers/firmware/efivars.c |   59 ++++++++++++++++++++++++++++++--------------
 include/linux/efi.h        |   22 ++++++++++++++++
 2 files changed, 62 insertions(+), 19 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 2a62ec6..e139dac 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -100,23 +100,6 @@ MODULE_VERSION(EFIVARS_VERSION);
 static DEFINE_SPINLOCK(efivars_lock);
 static LIST_HEAD(efivar_list);
 
-/*
- * The maximum size of VariableName + Data = 1024
- * Therefore, it's reasonable to save that much
- * space in each part of the structure,
- * and we use a page for reading/writing.
- */
-
-struct efi_variable {
-	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
-	efi_guid_t    VendorGuid;
-	unsigned long DataSize;
-	__u8          Data[1024];
-	efi_status_t  Status;
-	__u32         Attributes;
-} __attribute__((packed));
-
-
 struct efivar_entry {
 	struct efi_variable var;
 	struct list_head list;
@@ -169,6 +152,45 @@ utf8_strsize(efi_char16_t *data, unsigned long maxlength)
 	return utf8_strlen(data, maxlength/sizeof(efi_char16_t)) * sizeof(efi_char16_t);
 }
 
+efi_status_t
+efivar_get_data_from_guid(struct efi_variable *evar)
+{
+	struct efivar_entry *search_efivar;
+	unsigned long strsize;
+	efi_status_t status;
+	int found = 0;
+
+	spin_lock(&efivars_lock);
+
+	/* make sure this EFI variable is there */
+	list_for_each_entry(search_efivar, &efivar_list, list) {
+		if (!efi_guidcmp(search_efivar->var.VendorGuid,
+				 evar->VendorGuid)) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		spin_unlock(&efivars_lock);
+		return EFI_NOT_FOUND;
+	}
+
+	strsize = utf8_strsize(search_efivar->var.VariableName, 1024);
+	memcpy(evar->VariableName, search_efivar->var.VariableName, strsize);
+
+	evar->DataSize = 1024;
+	status = efi.get_variable(evar->VariableName,
+				  &evar->VendorGuid,
+				  &evar->Attributes,
+				  &evar->DataSize,
+				  evar->Data);
+	spin_unlock(&efivars_lock);
+
+	return status;
+}
+EXPORT_SYMBOL(efivar_get_data_from_guid);
+
 static efi_status_t
 get_var_data(struct efi_variable *var)
 {
@@ -757,6 +779,5 @@ efivars_exit(void)
 	kobject_put(efi_kobj);
 }
 
-module_init(efivars_init);
+subsys_initcall(efivars_init);
 module_exit(efivars_exit);
-
diff --git a/include/linux/efi.h b/include/linux/efi.h
index fb737bc..4230bc5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -243,6 +243,19 @@ struct efi_memory_map {
 	unsigned long desc_size;
 };
 
+/* The maximum size of VariableName + Data = 1024 Therefore, it's
+ * reasonable to save that much space in each part of the structure, and
+ * we use a page for reading/writing.
+ */
+struct efi_variable {
+	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
+	efi_guid_t    VendorGuid;
+	unsigned long DataSize;
+	__u8          Data[1024];
+	efi_status_t  Status;
+	__u32         Attributes;
+} __attribute__((packed));
+
 #define EFI_INVALID_TABLE_ADDR		(~0UL)
 
 /*
@@ -326,6 +339,15 @@ static inline int efi_range_is_wc(unsigned long start, unsigned long len)
 extern int __init efi_setup_pcdp_console(char *);
 #endif
 
+#if defined(CONFIG_EFI_VARS) || defined(CONFIG_EFI_VARS_MODULE)
+extern efi_status_t efivar_get_data_from_guid(struct efi_variable *evar);
+#else
+static inline efi_status_t efivar_get_data_from_guid(struct efi_variable *evar)
+{
+	return EFI_NOT_FOUND;
+}
+#endif
+
 /*
  * We play games with efi_enabled so that the compiler will, if possible, remove
  * EFI-related code altogether.

