From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] be2iscsi: check before destroy
Date: Wed, 13 Apr 2011 16:45:08 -0500
Message-ID: <4DA61964.2080903@cs.wisc.edu>
References: <1301088242-29477-1-git-send-email-jayamohan.kallickal@emulex.com> <f790abc7-bcb9-49d2-8a6d-1cb7cd976ce0@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020206090400030305050500"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58157 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906Ab1DMVpQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2011 17:45:16 -0400
In-Reply-To: <f790abc7-bcb9-49d2-8a6d-1cb7cd976ce0@exht1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohan.kallickal@emulex.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020206090400030305050500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/25/2011 04:24 PM, jayamohan.kallickal@emulex.com wrote:
> From: Jayamohan Kallickal<jayamohan.kallickal@emulex.com>
>
>       This patch checks if boot_kset is created before
> 	 attempting to destroy it.
>
> Signed-off-by: Jayamohan Kallickal<jayamohan.kallickal@emulex.com>
> ---
>   drivers/scsi/be2iscsi/be_main.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 7fe38a4..91b354d 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -420,7 +420,8 @@ static int beiscsi_setup_boot_info(struct beiscsi_hba *phba)
>   	return 0;
>
>   free_kset:
> -	iscsi_boot_destroy_kset(phba->boot_kset);
> +	if (phba->boot_kset)
> +		iscsi_boot_destroy_kset(phba->boot_kset);

This check is not needed, because in this path it is always set.

I fixed this up for you and made it so iscsi_boot_destroy_kset checks 
for null for the caller like how kfree does.


--------------020206090400030305050500
Content-Type: text/plain;
 name="be2iscsi-fix-rmmod-due-to-mem-issues.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="be2iscsi-fix-rmmod-due-to-mem-issues.patch"

be2iscsi: Fix boot_kset destruction

This patch has iscsi_boot_destroy_kset check for NULL boot_ksets,
before destroying them. This fixes a bug in be2iscsi's rmmod
path where it was passing in a NULL boot_kset when boot was
not setup.

This also fixes a bug where be2iscsi was accessing memory that
was freed. It was calling iscsi_boot_destroy_kset and
accessing the phba after calling iscsi_host_free which could
free the phba.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 24e20ba..d01f2fe 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4144,10 +4144,10 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 			    phba->ctrl.mbox_mem_alloced.size,
 			    phba->ctrl.mbox_mem_alloced.va,
 			    phba->ctrl.mbox_mem_alloced.dma);
+	iscsi_boot_destroy_kset(phba->boot_kset);
 	iscsi_host_remove(phba->shost);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
-	iscsi_boot_destroy_kset(phba->boot_kset);
 }
 
 static void beiscsi_msix_enable(struct beiscsi_hba *phba)
diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index df6bff7..0d8b0cd 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -472,6 +472,9 @@ void iscsi_boot_destroy_kset(struct iscsi_boot_kset *boot_kset)
 {
 	struct iscsi_boot_kobj *boot_kobj, *tmp_kobj;
 
+	if (!boot_kset)
+		return;
+
 	list_for_each_entry_safe(boot_kobj, tmp_kobj,
 				 &boot_kset->kobj_list, list)
 		iscsi_boot_remove_kobj(boot_kobj);

--------------020206090400030305050500--
