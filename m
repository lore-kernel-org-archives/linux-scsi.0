From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 35/37] cxlflash: Fix to avoid corrupting port selection mask
Date: Wed, 21 Oct 2015 15:16:15 -0500
Message-ID: <1445458575-62688-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:38076 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbbJUURp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:17:45 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 16:17:44 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 8E49438C8026
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:17:42 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKHgJB62259314
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:17:42 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKGsHh015808
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:17:01 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

The port selection mask of a LUN can be corrupted when the manage LUN
ioctl (DK_CXLFLASH_MANAGE_LUN) is issued more than once for any device.

This mask indicates to the AFU which port[s] can be used for a data
transfer to/from a particular LUN. The mask is critical to ensuring the
correct behavior when using the virtual LUN function of this adapter.
When the mask is configured for both ports, an I/O may be sent to either
port as the AFU assumes that each port has access to the same physical
device (specified by LUN ID in the port LUN table).

In a situation where the mask becomes incorrectly configured to reflect
access to both ports when in fact there is only access through a single
port, an I/O can be targeted to the wrong physical device. This can lead
to data corruption among other ill effects (e.g. security leaks).

The cause for this corruption is the assumption that the ioctl will only
be called a second time for a LUN when it is being configured for access
via a second port. A boolean 'newly_created' variable is used to
differentiate between a LUN that was created (and subsequently configured
for single port access) and one that is destined for access across both
ports. While initially set to 'true', this sticky boolean is toggled to
the 'false' state during a lookup on any next ioctl performed on a device
with a matching WWN/WWID. The code fails to realize that the match could
in fact be the same device calling in again. From here, an assumption is
made that any LUN with 'newly_created' set to 'false' is configured for
access over both ports and the port selection mask is set to reflect this.
Any future attempts to use this LUN for hosting a virtual LUN will result
in the port LUN table being incorrectly programmed.

As a remedy, the 'newly_created' concept was removed entirely and replaced
with code that always constructs the port selection mask based upon the
SCSI channel of the LUN being accessed. The bits remain sticky, therefore
allowing for a device to be accessed over both ports when that is in fact
the correct physical configuration.

Also included in this commit are a few minor related changes to enhance
the fix and provide better debug information for port selection mask and
port LUN table bugs in the future. These include renaming refresh_local()
to lookup_local(), tracing the WWN/WWID as a big-endian entity, and
tracing the port selection mask, SCSI channel, and LUN ID each time the
port LUN table is programmed.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/lunmgt.c    | 36 ++++++++++++++++++------------------
 drivers/scsi/cxlflash/superpipe.h |  1 -
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/cxlflash/lunmgt.c b/drivers/scsi/cxlflash/lunmgt.c
index 8c372fc..a0923ca 100644
--- a/drivers/scsi/cxlflash/lunmgt.c
+++ b/drivers/scsi/cxlflash/lunmgt.c
@@ -41,7 +41,6 @@ static struct llun_info *create_local(struct scsi_device *sdev, u8 *wwid)
 	}
 
 	lli->sdev = sdev;
-	lli->newly_created = true;
 	lli->host_no = sdev->host->host_no;
 	lli->in_table = false;
 
@@ -74,24 +73,19 @@ out:
 }
 
 /**
- * refresh_local() - find and update local LUN information structure by WWID
+ * lookup_local() - find a local LUN information structure by WWID
  * @cfg:	Internal structure associated with the host.
  * @wwid:	WWID associated with LUN.
  *
- * When the LUN is found, mark it by updating it's newly_created field.
- *
  * Return: Found local lun_info structure on success, NULL on failure
- * If a LUN with the WWID is found in the list, refresh it's state.
  */
-static struct llun_info *refresh_local(struct cxlflash_cfg *cfg, u8 *wwid)
+static struct llun_info *lookup_local(struct cxlflash_cfg *cfg, u8 *wwid)
 {
 	struct llun_info *lli, *temp;
 
 	list_for_each_entry_safe(lli, temp, &cfg->lluns, list)
-		if (!memcmp(lli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN)) {
-			lli->newly_created = false;
+		if (!memcmp(lli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN))
 			return lli;
-		}
 
 	return NULL;
 }
@@ -143,7 +137,7 @@ static struct llun_info *find_and_create_lun(struct scsi_device *sdev, u8 *wwid)
 	if (unlikely(!wwid))
 		goto out;
 
-	lli = refresh_local(cfg, wwid);
+	lli = lookup_local(cfg, wwid);
 	if (lli)
 		goto out;
 
@@ -239,8 +233,8 @@ int cxlflash_manage_lun(struct scsi_device *sdev,
 	mutex_lock(&global.mutex);
 	lli = find_and_create_lun(sdev, manage->wwid);
 	pr_debug("%s: ENTER: WWID = %016llX%016llX, flags = %016llX li = %p\n",
-		 __func__, get_unaligned_le64(&manage->wwid[0]),
-		 get_unaligned_le64(&manage->wwid[8]),
+		 __func__, get_unaligned_be64(&manage->wwid[0]),
+		 get_unaligned_be64(&manage->wwid[8]),
 		 manage->hdr.flags, lli);
 	if (unlikely(!lli)) {
 		rc = -ENOMEM;
@@ -248,20 +242,26 @@ int cxlflash_manage_lun(struct scsi_device *sdev,
 	}
 
 	if (flags & DK_CXLFLASH_MANAGE_LUN_ENABLE_SUPERPIPE) {
-		if (lli->newly_created)
-			lli->port_sel = CHAN2PORT(chan);
-		else
-			lli->port_sel = BOTH_PORTS;
-		/* Store off lun in unpacked, AFU-friendly format */
+		/*
+		 * Update port selection mask based upon channel, store off LUN
+		 * in unpacked, AFU-friendly format, and hang LUN reference in
+		 * the sdev.
+		 */
+		lli->port_sel |= CHAN2PORT(chan);
 		lli->lun_id[chan] = lun_to_lunid(sdev->lun);
 		sdev->hostdata = lli;
 	} else if (flags & DK_CXLFLASH_MANAGE_LUN_DISABLE_SUPERPIPE) {
 		if (lli->parent->mode != MODE_NONE)
 			rc = -EBUSY;
-		else
+		else {
 			sdev->hostdata = NULL;
+			lli->port_sel &= ~CHAN2PORT(chan);
+		}
 	}
 
+	pr_debug("%s: port_sel = %08X chan = %u lun_id = %016llX\n", __func__,
+		 lli->port_sel, chan, lli->lun_id[chan]);
+
 out:
 	mutex_unlock(&global.mutex);
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 06a805a..bede574 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -63,7 +63,6 @@ struct llun_info {
 	u32 lun_index;		/* Index in the LUN table */
 	u32 host_no;		/* host_no from Scsi_host */
 	u32 port_sel;		/* What port to use for this LUN */
-	bool newly_created;	/* Whether the LUN was just discovered */
 	bool in_table;		/* Whether a LUN table entry was created */
 
 	u8 wwid[16];		/* Keep a duplicate copy here? */
-- 
2.1.0

