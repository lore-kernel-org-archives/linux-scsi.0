From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v3 1/9] ufs: sysfs: device descriptor
Date: Tue, 2 Jan 2018 17:44:00 -0800
Message-ID: <20180103014400.GA3995@jaegeuk-macbookpro.roam.corp.google.com>
References: <1514467754-24499-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514467754-24499-2-git-send-email-stanislav.nijnikov@wdc.com>
 <20171228193717.GA47637@jaegeuk-macbookpro.roam.corp.google.com>
 <DM2PR0401MB0975DB9535FFBCFB9B61BF949A190@DM2PR0401MB0975.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM2PR0401MB0975DB9535FFBCFB9B61BF949A190@DM2PR0401MB0975.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Alex Lemberg <Alex.Lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 01/02, Stanislav Nijnikov wrote:
> 
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Thursday, December 28, 2017 9:37 PM
> > To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
> > Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> > gregkh@linuxfoundation.org; Alex Lemberg <Alex.Lemberg@wdc.com>
> > Subject: Re: [PATCH v3 1/9] ufs: sysfs: device descriptor
> > 
> > On 12/28, Stanislav Nijnikov wrote:
> > > This patch introduces a sysfs group entry for the UFS device
> > > descriptor parameters. The group adds "device_descriptor" folder under
> > > the UFS driver sysfs entry (/sys/bus/platform/drivers/ufshcd/*). The
> > > parameters are shown as hexadecimal numbers. The full information
> > > about the parameters could be found at UFS specifications 2.1.
> > >
> > > Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-driver-ufs | 223
> > +++++++++++++++++++++++++++++
> > >  drivers/scsi/ufs/Makefile                  |   3 +-
> > >  drivers/scsi/ufs/ufs-sysfs.c               | 170 ++++++++++++++++++++++
> > >  drivers/scsi/ufs/ufs-sysfs.h               |  25 ++++
> > >  drivers/scsi/ufs/ufs.h                     |   8 ++
> > >  drivers/scsi/ufs/ufshcd.c                  |  12 +-
> > >  drivers/scsi/ufs/ufshcd.h                  |   4 +
> > >  7 files changed, 439 insertions(+), 6 deletions(-)  create mode
> > > 100644 Documentation/ABI/testing/sysfs-driver-ufs
> > >  create mode 100644 drivers/scsi/ufs/ufs-sysfs.c  create mode 100644
> > > drivers/scsi/ufs/ufs-sysfs.h
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> > > b/Documentation/ABI/testing/sysfs-driver-ufs
> > > new file mode 100644
> > > index 0000000..17cc4aa
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> > 
> > [snip]
> > 
> > > diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> > > index 9310c6c..918f579 100644
> > > --- a/drivers/scsi/ufs/Makefile
> > > +++ b/drivers/scsi/ufs/Makefile
> > > @@ -3,6 +3,7 @@
> > >  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-
> > dwc.o
> > > tc-dwc-g210.o
> > >  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o
> > > ufshcd-dwc.o tc-dwc-g210.o
> > >  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
> > > -obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
> > > +obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o ufshcd-core-objs :=
> > > +ufshcd.o ufs-sysfs.o
> > 
> > Why not just adding ufs-sysfs.o in the existing configuration?
> 
> The kernel build robot compiles the UFS driver as a separate module. 
> The existing configuration doesn't allow to add a new file to be compiled 
> as a part of this module. The line like " obj-$(CONFIG_SCSI_UFSHCD) += 
> ufshcd.o ufs-sysfs.o" in the makefile will actually create 2 modules.
> This was the reason why I used EXPORT_SYMBOL in the first version.

Is there a reason to drop the first version?

> 
> > 
> > >  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
> > >  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o diff --git
> > > a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c new file
> > > mode 100644 index 0000000..1c685f3
> > > --- /dev/null
> > > +++ b/drivers/scsi/ufs/ufs-sysfs.c
> > > @@ -0,0 +1,170 @@
> > > +/*
> > > +* UFS Device Management sysfs
> > > +*
> > > +* Copyright (C) 2017 Western Digital Corporation
> > > +*
> > > +* This program is free software; you can redistribute it and/or
> > > +* modify it under the terms of the GNU General Public License version
> > > +* 2 as published by the Free Software Foundation.
> > > +*
> > > +* This program is distributed in the hope that it will be useful, but
> > > +* WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > GNU
> > > +* General Public License for more details.
> > > +*
> > > +*/
> > > +
> > > +#include <linux/err.h>
> > > +#include <linux/string.h>
> > > +
> > > +#include "ufs.h"
> > > +#include "ufs-sysfs.h"
> > > +/* collision between the device descriptor parameter and the
> > > +definition */ #undef DEVICE_CLASS
> > 
> > Does this make sense? How about attaching "_" for all the macro like
> > _DEVICE_CLASS below?
> > 
> 
> It's not just changing the one line that uses "DEVICE_CLASS" to use 
> "_DEVICE_CLASS". It's will be necessary to add "_" to all descriptor
> parameters macros in all patches.

You should be able to do that by moving ufs_sysfs_read_desc_param() into
ufshcd.c, and remaining only the necessary header files for sysfs stuffs.

> 
> > > +
> > > +enum ufs_desc_param_size {
> > > +	UFS_PARAM_BYTE_SIZE	= 1,
> > > +	UFS_PARAM_WORD_SIZE	= 2,
> > > +	UFS_PARAM_DWORD_SIZE	= 4,
> > > +	UFS_PARAM_QWORD_SIZE	= 8,
> > > +};

Must be in header file.

> > > +
> > > +static inline ssize_t ufs_sysfs_read_desc_param(
> > > +	struct ufs_hba *hba, u8 desc_idn, u8 index, char *buf, u8 off,
> > > +	enum ufs_desc_param_size param_size) {
> > > +	int desc_len;
> > > +	int ret;
> > > +	u8 *desc_buf;
> > > +
> > > +	if (ufshcd_map_desc_id_to_length(hba, desc_idn, &desc_len) ||
> > > +		off >= desc_len)
> > > +		return -EINVAL;
> > > +	desc_buf = kzalloc(desc_len, GFP_ATOMIC);
> > > +	if (!desc_buf)
> > > +		return -ENOMEM;
> > > +	ret = ufshcd_query_descriptor_retry(hba,
> > UPIU_QUERY_OPCODE_READ_DESC,
> > > +		desc_idn, index, 0, desc_buf, &desc_len);
> > > +	if (ret)
> > 
> > Should free desc_buf here.
> > 
> > > +		return -EINVAL;

BTW, the existing ufshcd_read_desc_param() seems the right function for the
above work.

> > > +	switch (param_size) {
> > > +	case UFS_PARAM_BYTE_SIZE:
> > > +		ret = sprintf(buf, "0x%02X\n", desc_buf[off]);
> > > +		break;
> > > +	case UFS_PARAM_WORD_SIZE:
> > > +		ret = sprintf(buf, "0x%04X\n",
> > > +			be16_to_cpu(*((u16 *)(desc_buf + off))));
> > > +		break;
> > > +	case UFS_PARAM_DWORD_SIZE:
> > > +		ret = sprintf(buf, "0x%08X\n",
> > > +			be32_to_cpu(*((u32 *)(desc_buf + off))));
> > > +		break;
> > > +	case UFS_PARAM_QWORD_SIZE:
> > > +		ret = sprintf(buf, "0x%016llX\n",
> > > +			be64_to_cpu(*((u64 *)(desc_buf + off))));
> > > +		break;
> > > +	}
> > > +	kfree(desc_buf);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +#define ufs_sysfs_desc_param_show(_name, _puname, _duname,

Not a good macro definition. In addition, the patch has some coding style
errors, which requires to pass script/checkpatch.pl.

I didn't test the below fully tho, could you take a look at this change?
IMO, still, making a default group with existing sysfs entries should be done
in prior to this.

diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 918f579..1fa74c1 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -3,7 +3,6 @@
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
-obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
-ufshcd-core-objs := ufshcd.o ufs-sysfs.o
+obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o ufs-sysfs.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 1c685f3..226eb44 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -19,71 +19,22 @@
 
 #include "ufs.h"
 #include "ufs-sysfs.h"
-/* collision between the device descriptor parameter and the definition */
-#undef DEVICE_CLASS
 
-enum ufs_desc_param_size {
-	UFS_PARAM_BYTE_SIZE	= 1,
-	UFS_PARAM_WORD_SIZE	= 2,
-	UFS_PARAM_DWORD_SIZE	= 4,
-	UFS_PARAM_QWORD_SIZE	= 8,
-};
-
-static inline ssize_t ufs_sysfs_read_desc_param(
-	struct ufs_hba *hba, u8 desc_idn, u8 index, char *buf, u8 off,
-	enum ufs_desc_param_size param_size)
-{
-	int desc_len;
-	int ret;
-	u8 *desc_buf;
-
-	if (ufshcd_map_desc_id_to_length(hba, desc_idn, &desc_len) ||
-		off >= desc_len)
-		return -EINVAL;
-	desc_buf = kzalloc(desc_len, GFP_ATOMIC);
-	if (!desc_buf)
-		return -ENOMEM;
-	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
-		desc_idn, index, 0, desc_buf, &desc_len);
-	if (ret)
-		return -EINVAL;
-	switch (param_size) {
-	case UFS_PARAM_BYTE_SIZE:
-		ret = sprintf(buf, "0x%02X\n", desc_buf[off]);
-		break;
-	case UFS_PARAM_WORD_SIZE:
-		ret = sprintf(buf, "0x%04X\n",
-			be16_to_cpu(*((u16 *)(desc_buf + off))));
-		break;
-	case UFS_PARAM_DWORD_SIZE:
-		ret = sprintf(buf, "0x%08X\n",
-			be32_to_cpu(*((u32 *)(desc_buf + off))));
-		break;
-	case UFS_PARAM_QWORD_SIZE:
-		ret = sprintf(buf, "0x%016llX\n",
-			be64_to_cpu(*((u64 *)(desc_buf + off))));
-		break;
-	}
-	kfree(desc_buf);
-
-	return ret;
-}
-
-#define ufs_sysfs_desc_param_show(_name, _puname, _duname, _size)             \
-static ssize_t _name##_show(struct device *dev,                               \
-	struct device_attribute *attr, char *buf)                             \
-{                                                                             \
-	struct ufs_hba *hba = dev_get_drvdata(dev);                           \
-	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,       \
-		0, buf, _duname##_DESC_PARAM_##_puname,                       \
-		UFS_PARAM_##_size##_SIZE);                                    \
-}
-
-#define UFS_DESC_PARAM(_pname, _puname, _duname, _size)                       \
-	ufs_sysfs_desc_param_show(_pname, _puname, _duname, _size)            \
-	static DEVICE_ATTR_RO(_pname)
-
-#define UFS_DEVICE_DESC_PARAM(_name, _uname, _size)                           \
+#define UFS_DESC_PARAM_SHOW(_name, _puname, _duname, _size)		\
+static ssize_t _name##_show(struct device *dev,				\
+		struct device_attribute *attr, char *buf)		\
+{									\
+	return ufshcd_sysfs_read_desc_param(dev,			\
+		QUERY_DESC_IDN_##_duname,				\
+		0, _duname##_DESC_PARAM_##_puname, buf,			\
+		UFS_PARAM_##_size##_SIZE);				\
+}									\
+static DEVICE_ATTR_RO(_name)
+
+#define UFS_DESC_PARAM(_pname, _puname, _duname, _size)			\
+	UFS_DESC_PARAM_SHOW(_pname, _puname, _duname, _size)
+
+#define UFS_DEVICE_DESC_PARAM(_name, _uname, _size)			\
 	UFS_DESC_PARAM(_name, _uname, DEVICE, _size)
 
 UFS_DEVICE_DESC_PARAM(device_type, DEVICE_TYPE, BYTE);
@@ -153,18 +104,21 @@ static const struct attribute_group *ufs_sysfs_groups[] = {
 	NULL,
 };
 
-void ufs_sysfs_add_device_management(struct ufs_hba *hba)
+void ufs_sysfs_add_device_management(struct device *dev)
 {
 	int ret;
 
-	ret = sysfs_create_groups(&hba->dev->kobj, ufs_sysfs_groups);
+	ret = sysfs_create_groups(&dev->kobj, ufs_sysfs_groups);
 	if (ret)
-		dev_err(hba->dev,
+		dev_err(dev,
 			"%s: sysfs groups creation failed (err = %d)\n",
 			__func__, ret);
 }
 
-void ufs_sysfs_remove_device_management(struct ufs_hba *hba)
+void ufs_sysfs_remove_device_management(struct device *dev)
 {
-	sysfs_remove_groups(&hba->dev->kobj, ufs_sysfs_groups);
+	sysfs_remove_groups(&dev->kobj, ufs_sysfs_groups);
 }
+
+EXPORT_SYMBOL(ufs_sysfs_add_device_management);
+EXPORT_SYMBOL(ufs_sysfs_remove_device_management);
diff --git a/drivers/scsi/ufs/ufs-sysfs.h b/drivers/scsi/ufs/ufs-sysfs.h
index a1fc9dc..c857e20 100644
--- a/drivers/scsi/ufs/ufs-sysfs.h
+++ b/drivers/scsi/ufs/ufs-sysfs.h
@@ -16,10 +16,23 @@
 #ifndef __UFS_SYSFS_H__
 #define __UFS_SYSFS_H__
 
+#include <linux/device.h>
 #include <linux/sysfs.h>
 
-#include "ufshcd.h"
+enum ufs_desc_param_size {
+	UFS_PARAM_BYTE_SIZE	= 1,
+	UFS_PARAM_WORD_SIZE	= 2,
+	UFS_PARAM_DWORD_SIZE	= 4,
+	UFS_PARAM_QWORD_SIZE	= 8,
+};
 
-void ufs_sysfs_add_device_management(struct ufs_hba *hba);
-void ufs_sysfs_remove_device_management(struct ufs_hba *hba);
+extern void ufs_sysfs_add_device_management(struct device *dev);
+extern void ufs_sysfs_remove_device_management(struct device *dev);
+
+extern ssize_t ufshcd_sysfs_read_desc_param(struct device *dev,
+				enum desc_idn desc_id,
+				u8 desc_index,
+				u8 param_offset,
+				u8 *sysfs_buf,
+				u8 param_size);
 #endif
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c1c45c1..7d38e1b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2895,7 +2895,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
  * The buf_len parameter will contain, on return, the length parameter
  * received on the response.
  */
-int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
+static int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 				  enum query_opcode opcode,
 				  enum desc_idn idn, u8 index, u8 selector,
 				  u8 *desc_buf, int *buf_len)
@@ -3079,6 +3079,46 @@ static int ufshcd_read_desc_param(struct ufs_hba *hba,
 	return ret;
 }
 
+ssize_t ufshcd_sysfs_read_desc_param(struct device *dev,
+				enum desc_idn desc_id,
+				u8 desc_index,
+				u8 param_offset,
+				u8 *sysfs_buf,
+				u8 param_size)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u8 desc_buf[UFS_PARAM_QWORD_SIZE] = {0};
+	int ret;
+
+	if (param_size > UFS_PARAM_QWORD_SIZE)
+		return -EINVAL;
+
+	ret = ufshcd_read_desc_param(hba, desc_id, desc_index,
+				param_offset, desc_buf, param_size);
+	if (ret)
+		return ret;
+
+	switch (param_size) {
+	case UFS_PARAM_BYTE_SIZE:
+		ret = sprintf(sysfs_buf, "0x%02X\n", *desc_buf);
+		break;
+	case UFS_PARAM_WORD_SIZE:
+		ret = sprintf(sysfs_buf, "0x%04X\n",
+			be16_to_cpu(*((u16 *)desc_buf)));
+		break;
+	case UFS_PARAM_DWORD_SIZE:
+		ret = sprintf(sysfs_buf, "0x%08X\n",
+			be32_to_cpu(*((u32 *)desc_buf)));
+		break;
+	case UFS_PARAM_QWORD_SIZE:
+		ret = sprintf(sysfs_buf, "0x%016llX\n",
+			be64_to_cpu(*((u64 *)desc_buf)));
+		break;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(ufshcd_sysfs_read_desc_param);
+
 static inline int ufshcd_read_desc(struct ufs_hba *hba,
 				   enum desc_idn desc_id,
 				   int desc_index,
@@ -7701,12 +7741,12 @@ static inline void ufshcd_add_sysfs_nodes(struct ufs_hba *hba)
 {
 	ufshcd_add_rpm_lvl_sysfs_nodes(hba);
 	ufshcd_add_spm_lvl_sysfs_nodes(hba);
-	ufs_sysfs_add_device_management(hba);
+	ufs_sysfs_add_device_management(hba->dev);
 }
 
 static inline void ufshcd_remove_sysfs_nodes(struct ufs_hba *hba)
 {
-	ufs_sysfs_remove_device_management(hba);
+	ufs_sysfs_remove_device_management(hba->dev);
 	device_remove_file(hba->dev, &hba->rpm_lvl_attr);
 	device_remove_file(hba->dev, &hba->spm_lvl_attr);
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6a0ec4b..1332e54 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -841,10 +841,6 @@ static inline bool ufshcd_is_hs_mode(struct ufs_pa_layer_attr *pwr_info)
 }
 
 /* Expose Query-Request API */
-int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
-				  enum query_opcode opcode,
-				  enum desc_idn idn, u8 index, u8 selector,
-				  u8 *desc_buf, int *buf_len);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
 int ufshcd_hold(struct ufs_hba *hba, bool async);
