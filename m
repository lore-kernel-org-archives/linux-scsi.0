From: Michael Reed <mdr@sgi.com>
Subject: REPOST: [PATCH 1/1] Fusion SAS and Fibre Channel: target missing
 after resetting external raid
Date: Wed, 21 May 2008 15:05:34 -0500
Message-ID: <4834808E.2010603@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.171.29]:36970 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937088AbYEUUFi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:05:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Repost of original version of a patch posted on March 04, 2008.
Patch has been adjusted to apply to 2.6.26-rc3-git3.  The final version
of the patch (March 13, 2008) modified mptscsih.c with a somewhat related
mod which I'm separating into a new patch.

This patch will also apply on top of Sathya's recent patch set.

--

Following a hard reset of a SAS raid, one of the raid targets is occasionally
missing.  I tracked this down to a pretty obscure little bug.

The LSI fusion drivers for SAS and Fibre Channel both use their respective
transport layers.  Those transport layers increment the target number
assigned to new targets.

The routine __scsi_scan_target uses the "this_id" element of the Scsi_Host
structure to avoid scanning the scsi host adapter.  Both fusion drivers set
"this_id" from a value returned in a firmware PortFacts response.  For my
particular test case (SAS) the firmware id assigned to the initiator was
173.  After enough raid resets to cause the raid targets to go and come a
sufficient number of times, the id assigned by the transport to a raid
target would match the id assigned by the host adapter to the "this_id"
field, resulting in that target not being scanned.

static void __scsi_scan_target(struct device *parent, unsigned int channel,
                unsigned int id, unsigned int lun, int rescan)
{
        struct Scsi_Host *shost = dev_to_shost(parent);
        int bflags = 0;
        int res;
        struct scsi_target *starget;

        if (shost->this_id == id)
                /*
                 * Don't scan the host adapter
                 */
                return;


The fix is simple.  Fusion SAS and Fibre Channel should just leave "this_id"
initialized to "-1".

Applies to 2.6.26-rc3-git3

Signed-off-by: Michael Reed <mdr@sgi.com>


--- linux-2.6.26-rc3-git3.orig/drivers/message/fusion/mptfc.c	2008-05-21 14:28:31.116809458 -0500
+++ linux-2.6.26-rc3-git3/drivers/message/fusion/mptfc.c	2008-05-21 14:28:48.408577749 -0500
@@ -1238,8 +1238,6 @@ mptfc_probe(struct pci_dev *pdev, const 
 	sh->max_id = ioc->pfacts->MaxDevices;
 	sh->max_lun = max_lun;
 
-	sh->this_id = ioc->pfacts[0].PortSCSIID;
-
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;
--- linux-2.6.26-rc3-git3.orig/drivers/message/fusion/mptsas.c	2008-05-21 14:28:31.116809458 -0500
+++ linux-2.6.26-rc3-git3/drivers/message/fusion/mptsas.c	2008-05-21 14:28:48.432577428 -0500
@@ -3193,8 +3193,6 @@ mptsas_probe(struct pci_dev *pdev, const
 
 	sh->transportt = mptsas_transport_template;
 
-	sh->this_id = ioc->pfacts[0].PortSCSIID;
-
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;
