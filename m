From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/1] Fusion SAS and Fibre Channel: target missing after resetting
 external raid
Date: Tue, 04 Mar 2008 10:50:38 -0600
Message-ID: <47CD7DDE.7030907@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.171.29]:52793 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751320AbYCDQuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 11:50:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: Michael Reed <mdr@sgi.com>, Jeremy Higdon <jeremy@sgi.com>

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

....

The fix is simple.  Fusion SAS and Fibre Channel (subject to same bug) should
just leave "this_id" initialized to "-1".

Applies to 2.6.25-rc3-git5.

Signed-off-by: Michael Reed <mdr@sgi.com>

--

--- kou/drivers/message/fusion/mptfc.c	2008-01-24 16:58:37.000000000 -0600
+++ ko/drivers/message/fusion/mptfc.c	2008-03-04 09:01:18.428176326 -0600
@@ -1238,8 +1238,6 @@ mptfc_probe(struct pci_dev *pdev, const 
 	sh->max_id = ioc->pfacts->MaxDevices;
 	sh->max_lun = max_lun;
 
-	sh->this_id = ioc->pfacts[0].PortSCSIID;
-
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;
--- kou/drivers/message/fusion/mptsas.c	2008-03-04 08:38:58.000000000 -0600
+++ ko/drivers/message/fusion/mptsas.c	2008-03-04 09:01:04.284807301 -0600
@@ -3176,8 +3176,6 @@ mptsas_probe(struct pci_dev *pdev, const
 
 	sh->transportt = mptsas_transport_template;
 
-	sh->this_id = ioc->pfacts[0].PortSCSIID;
-
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;

