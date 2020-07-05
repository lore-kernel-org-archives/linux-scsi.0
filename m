Return-Path: <SRS0=7Ct3=AQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8197C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 15:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E33E2075D
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 15:22:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="TCJdhGoj";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="TCJdhGoj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgGEPWx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 11:22:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47330 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726833AbgGEPWx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 11:22:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C5C7E8EE1FC;
        Sun,  5 Jul 2020 08:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1593962572;
        bh=OLhaHU/vz2Tng4cyS8WmDVBZm28HLgOU760RKdtZ1I8=;
        h=Subject:From:To:Cc:Date:From;
        b=TCJdhGojJOQBMHe45VrBwizRGOzSBroMT2eYHdrtrbAzes6PsWgkg4soKhKWaApj+
         pWLXvKebJcAfMoQMa3bIdkHq2jhJUuZc3/tpN7G5sf5X2EHsrm2t+Eqd9trCBMNZJk
         zZLELaDqxgdLOeXqmF3AyV2GHzTsgDohDZsPe2t0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id znkL1FObznCV; Sun,  5 Jul 2020 08:22:52 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 066E78EE116;
        Sun,  5 Jul 2020 08:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1593962572;
        bh=OLhaHU/vz2Tng4cyS8WmDVBZm28HLgOU760RKdtZ1I8=;
        h=Subject:From:To:Cc:Date:From;
        b=TCJdhGojJOQBMHe45VrBwizRGOzSBroMT2eYHdrtrbAzes6PsWgkg4soKhKWaApj+
         pWLXvKebJcAfMoQMa3bIdkHq2jhJUuZc3/tpN7G5sf5X2EHsrm2t+Eqd9trCBMNZJk
         zZLELaDqxgdLOeXqmF3AyV2GHzTsgDohDZsPe2t0=
Message-ID: <1593962570.4657.5.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.8-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sun, 05 Jul 2020 08:22:50 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Four small fixes in three drivers.  The mptfusion one has actually
caused use visible issues in certain kernel configurations.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (1):
      scsi: mptfusion: Don't use GFP_ATOMIC for larger DMA allocations

Dan Carpenter (1):
      scsi: qla2xxx: Fix a condition in qla2x00_find_all_fabric_devs()

Javed Hasan (2):
      scsi: libfc: Skip additional kref updating work event
      scsi: libfc: Handling of extra kref

And the diffstat:

 drivers/message/fusion/mptbase.c | 41 ++++++++++++++++++++--------------------
 drivers/scsi/libfc/fc_rport.c    | 13 ++++++++-----
 drivers/scsi/qla2xxx/qla_init.c  |  2 +-
 3 files changed, 29 insertions(+), 27 deletions(-)

With full diff below.

James

---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 68aea22f2b89..5216487db4fb 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1324,13 +1324,13 @@ mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init)
 			return 0; /* fw doesn't need any host buffers */
 
 		/* spin till we get enough memory */
-		while(host_page_buffer_sz > 0) {
-
-			if((ioc->HostPageBuffer = pci_alloc_consistent(
-			    ioc->pcidev,
-			    host_page_buffer_sz,
-			    &ioc->HostPageBuffer_dma)) != NULL) {
-
+		while (host_page_buffer_sz > 0) {
+			ioc->HostPageBuffer =
+				dma_alloc_coherent(&ioc->pcidev->dev,
+						host_page_buffer_sz,
+						&ioc->HostPageBuffer_dma,
+						GFP_KERNEL);
+			if (ioc->HostPageBuffer) {
 				dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				    "host_page_buffer @ %p, dma @ %x, sz=%d bytes\n",
 				    ioc->name, ioc->HostPageBuffer,
@@ -2741,8 +2741,8 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 		sz = ioc->alloc_sz;
 		dexitprintk(ioc, printk(MYIOC_s_INFO_FMT "free  @ %p, sz=%d bytes\n",
 		    ioc->name, ioc->alloc, ioc->alloc_sz));
-		pci_free_consistent(ioc->pcidev, sz,
-				ioc->alloc, ioc->alloc_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz, ioc->alloc,
+				ioc->alloc_dma);
 		ioc->reply_frames = NULL;
 		ioc->req_frames = NULL;
 		ioc->alloc = NULL;
@@ -2751,8 +2751,8 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 
 	if (ioc->sense_buf_pool != NULL) {
 		sz = (ioc->req_depth * MPT_SENSE_BUFFER_ALLOC);
-		pci_free_consistent(ioc->pcidev, sz,
-				ioc->sense_buf_pool, ioc->sense_buf_pool_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz, ioc->sense_buf_pool,
+				ioc->sense_buf_pool_dma);
 		ioc->sense_buf_pool = NULL;
 		ioc->alloc_total -= sz;
 	}
@@ -2802,7 +2802,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 			"HostPageBuffer free  @ %p, sz=%d bytes\n",
 			ioc->name, ioc->HostPageBuffer,
 			ioc->HostPageBuffer_sz));
-		pci_free_consistent(ioc->pcidev, ioc->HostPageBuffer_sz,
+		dma_free_coherent(&ioc->pcidev->dev, ioc->HostPageBuffer_sz,
 		    ioc->HostPageBuffer, ioc->HostPageBuffer_dma);
 		ioc->HostPageBuffer = NULL;
 		ioc->HostPageBuffer_sz = 0;
@@ -4497,7 +4497,8 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 			 	ioc->name, sz, sz, num_chain));
 
 		total_size += sz;
-		mem = pci_alloc_consistent(ioc->pcidev, total_size, &alloc_dma);
+		mem = dma_alloc_coherent(&ioc->pcidev->dev, total_size,
+				&alloc_dma, GFP_KERNEL);
 		if (mem == NULL) {
 			printk(MYIOC_s_ERR_FMT "Unable to allocate Reply, Request, Chain Buffers!\n",
 				ioc->name);
@@ -4574,8 +4575,8 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 		sz = (ioc->req_depth * MPT_SENSE_BUFFER_ALLOC);
-		ioc->sense_buf_pool =
-			pci_alloc_consistent(ioc->pcidev, sz, &ioc->sense_buf_pool_dma);
+		ioc->sense_buf_pool = dma_alloc_coherent(&ioc->pcidev->dev, sz,
+				&ioc->sense_buf_pool_dma, GFP_KERNEL);
 		if (ioc->sense_buf_pool == NULL) {
 			printk(MYIOC_s_ERR_FMT "Unable to allocate Sense Buffers!\n",
 				ioc->name);
@@ -4613,18 +4614,16 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 
 	if (ioc->alloc != NULL) {
 		sz = ioc->alloc_sz;
-		pci_free_consistent(ioc->pcidev,
-				sz,
-				ioc->alloc, ioc->alloc_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz, ioc->alloc,
+				ioc->alloc_dma);
 		ioc->reply_frames = NULL;
 		ioc->req_frames = NULL;
 		ioc->alloc_total -= sz;
 	}
 	if (ioc->sense_buf_pool != NULL) {
 		sz = (ioc->req_depth * MPT_SENSE_BUFFER_ALLOC);
-		pci_free_consistent(ioc->pcidev,
-				sz,
-				ioc->sense_buf_pool, ioc->sense_buf_pool_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz, ioc->sense_buf_pool,
+				ioc->sense_buf_pool_dma);
 		ioc->sense_buf_pool = NULL;
 	}
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 773c45af9387..278d15ff1c5a 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -133,8 +133,10 @@ struct fc_rport_priv *fc_rport_create(struct fc_lport *lport, u32 port_id)
 	lockdep_assert_held(&lport->disc.disc_mutex);
 
 	rdata = fc_rport_lookup(lport, port_id);
-	if (rdata)
+	if (rdata) {
+		kref_put(&rdata->kref, fc_rport_destroy);
 		return rdata;
+	}
 
 	if (lport->rport_priv_size > 0)
 		rport_priv_size = lport->rport_priv_size;
@@ -481,10 +483,11 @@ static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
 
 	fc_rport_state_enter(rdata, RPORT_ST_DELETE);
 
-	kref_get(&rdata->kref);
-	if (rdata->event == RPORT_EV_NONE &&
-	    !queue_work(rport_event_queue, &rdata->event_work))
-		kref_put(&rdata->kref, fc_rport_destroy);
+	if (rdata->event == RPORT_EV_NONE) {
+		kref_get(&rdata->kref);
+		if (!queue_work(rport_event_queue, &rdata->event_work))
+			kref_put(&rdata->kref, fc_rport_destroy);
+	}
 
 	rdata->event = event;
 }
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4576d3ae9937..2436a17f5cd9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5944,7 +5944,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 			break;
 		}
 
-		if (NVME_TARGET(vha->hw, fcport)) {
+		if (found && NVME_TARGET(vha->hw, fcport)) {
 			if (fcport->disc_state == DSC_DELETE_PEND) {
 				qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
 				vha->fcport_count--;
