Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC07AC3F2D2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 07:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89DBD2467B
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 07:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgB1Hx2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 02:53:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:59834 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727011AbgB1HxZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 02:53:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5BFC1B1EC;
        Fri, 28 Feb 2020 07:53:21 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/13] aacraid: use scsi_host_(block,unblock) to block I/O
Date:   Fri, 28 Feb 2020 08:53:14 +0100
Message-Id: <20200228075318.91255-10-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200228075318.91255-1-hare@suse.de>
References: <20200228075318.91255-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_block() and scsi_host_unblock() instead of
scsi_block_requests()/scsi_unblock_requests() to block and unblock I/O.
This has the advantage that the block layer will stop sending I/O
to the adapter instead of having the SCSI midlayer requeueing I/O
internally.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Balsundar P < Balsundar.P@microchip.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/aacraid/commsup.c | 14 ++------------
 drivers/scsi/aacraid/linit.c   | 15 ++++++---------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 0d8c1ee40759..9c227eefd14c 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1477,7 +1477,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	int index, quirks;
 	int retval;
 	struct Scsi_Host *host = aac->scsi_host_ptr;
-	struct scsi_device *dev;
 	int jafo = 0;
 	int bled;
 	u64 dmamask;
@@ -1605,16 +1604,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 */
 	scsi_host_complete_all_commands(host, DID_RESET);
 
-	/*
-	 * Any Device that was already marked offline needs to be marked
-	 * running
-	 */
-	__shost_for_each_device(dev, host) {
-		if (!scsi_device_online(dev))
-			scsi_device_set_state(dev, SDEV_RUNNING);
-	}
 	retval = 0;
-
 out:
 	aac->in_reset = 0;
 
@@ -1655,7 +1645,7 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 * target (block maximum 60 seconds). Although not necessary,
 	 * it does make us a good storage citizen.
 	 */
-	scsi_block_requests(host);
+	scsi_host_block(host);
 
 	/* Quiesce build, flush cache, write through mode */
 	if (forced < 2)
@@ -1666,7 +1656,7 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	retval = _aac_reset_adapter(aac, bled, reset_type);
 	spin_unlock_irqrestore(host->host_lock, flagv);
 
-	scsi_unblock_requests(host);
+	retval = scsi_host_unblock(host, SDEV_RUNNING);
 
 	if ((forced < 2) && (retval == -ENODEV)) {
 		/* Unwind aac_send_shutdown() IOP_RESET unsupported/disabled */
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 4d5b34e0d3a9..877464e9d520 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1894,7 +1894,7 @@ static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
-	scsi_block_requests(shost);
+	scsi_host_block(shost);
 	aac_cancel_rescan_worker(aac);
 	aac_send_shutdown(aac);
 
@@ -1930,7 +1930,7 @@ static int aac_resume(struct pci_dev *pdev)
 	* aac_send_shutdown() to block ioctls from upperlayer
 	*/
 	aac->adapter_shutdown = 0;
-	scsi_unblock_requests(shost);
+	scsi_host_unblock(shost, SDEV_RUNNING);
 
 	return 0;
 
@@ -1945,7 +1945,8 @@ static int aac_resume(struct pci_dev *pdev)
 static void aac_shutdown(struct pci_dev *dev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(dev);
-	scsi_block_requests(shost);
+
+	scsi_host_block(shost);
 	__aac_shutdown((struct aac_dev *)shost->hostdata);
 }
 
@@ -1991,7 +1992,7 @@ static pci_ers_result_t aac_pci_error_detected(struct pci_dev *pdev,
 	case pci_channel_io_frozen:
 		aac->handle_pci_error = 1;
 
-		scsi_block_requests(aac->scsi_host_ptr);
+		scsi_host_block(shost);
 		aac_cancel_rescan_worker(aac);
 		scsi_host_complete_all_commands(shost, DID_NO_CONNECT);
 		aac_release_resources(aac);
@@ -2044,7 +2045,6 @@ static pci_ers_result_t aac_pci_slot_reset(struct pci_dev *pdev)
 static void aac_pci_resume(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct scsi_device *sdev = NULL;
 	struct aac_dev *aac = (struct aac_dev *)shost_priv(shost);
 
 	if (aac_adapter_ioremap(aac, aac->base_size)) {
@@ -2071,10 +2071,7 @@ static void aac_pci_resume(struct pci_dev *pdev)
 	aac->adapter_shutdown = 0;
 	aac->handle_pci_error = 0;
 
-	shost_for_each_device(sdev, shost)
-		if (sdev->sdev_state == SDEV_OFFLINE)
-			sdev->sdev_state = SDEV_RUNNING;
-	scsi_unblock_requests(aac->scsi_host_ptr);
+	scsi_host_unblock(shost, SDEV_RUNNING);
 	aac_scan_host(aac);
 	pci_save_state(pdev);
 
-- 
2.16.4

