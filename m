Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6FDC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 23:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242889AbiE3XPm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 19:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242787AbiE3XPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 19:15:40 -0400
Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC70719C4
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 16:15:38 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 678BBC0ADB;
        Mon, 30 May 2022 23:15:37 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id D6CABC0249;
        Mon, 30 May 2022 23:15:36 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1653952537; a=rsa-sha256;
        cv=none;
        b=H//RckYQq5UvXkhrkV7LTsKfLc1HzdOuB9WkbQBpWd7o2gu2D3mpvkVMFoEImwq+CYPM0R
        DEL0jbpWwW1rwFW3TneQsl6IlXrMeiN8/gMPAXa8bYAxzOcCYHS+gEVtYCwtKr0SRgxplr
        m3hwzC946osLsv4E48l8IbyZGusZJKE2U3jHdTTG9dymrvRVvKo7aeXAd7OKPZpXmyFzPA
        DjMYmysnrz+6NBScYiXtsNb90FAy9L89uK0X2aKRMyR7APfBrOyZIS2xr45W4VaWYwuYZF
        0VmbIC9b7sAcnjUkGA6ekdsqf/mgJ9zXrsBELzIq1XXi+goZ8BPsKX1koDT7uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1653952537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=gjWDDeJAYGuSQUYvY7rPie1Lt934CZzCvlxupbtLAfA=;
        b=qqr3yfYZuX95TNt+2ENFYdFCtVhjH5NrRcQCw0qYeJeEFqIUIiGXE4QawWDpXJ17MG8uW8
        1Xup9ZMPkzbXjYE00ggQ2Eky0SIR2EB2jq2Twps3IObhSECptVULLJkEd+yJUffC0XVH/4
        hq5X53ECKw7+y9t5A6Whhn3+EEMbK9oxXGqN+1N0JYX/b9SzXSDkCRpAANEGB3yD00Newz
        se6m06kMgkOHGHm8EUm2mF498A4hSgTj3YzsEOWKheQkohC/i4j628kcddtlpfxBU/NI6l
        EekO4U915razx7kuBOVzPwrTg8unxjNwyUb8Lz8h+yoFooY6G3n4/5MBjCFU1w==
ARC-Authentication-Results: i=1;
        rspamd-54ff499d4f-n6vbx;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Madly-Absorbed: 1fec91ef01aa13f4_1653952537221_3194783024
X-MC-Loop-Signature: 1653952537221:1767497567
X-MC-Ingress-Time: 1653952537221
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.101.255.183 (trex/6.7.1);
        Mon, 30 May 2022 23:15:37 +0000
Received: from localhost.localdomain (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LBrqW705qz4C;
        Mon, 30 May 2022 16:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1653952536;
        bh=gjWDDeJAYGuSQUYvY7rPie1Lt934CZzCvlxupbtLAfA=;
        h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
        b=W7QbRHPQS4mzzdzqlvLqNAEmNu781pDRkfjRI0Qytg1lXRl06WeMopPV/51+Beai3
         cEcUJ19s/Gj+b4REGeB0WS8y1DXDpNov7MY12yEYe4nr27WonFPO/GNdeCFdrQ8qG3
         YN1rW2pMcy4clHQ9MVl8XUOiimUmm1loCP6mivBEJP+aQXfrQqni6w6WBHsFm018KC
         6xoEti13disQYV5cbRlIHq1X7s843cz3jtU5sqLHP/kAyG39Tf3EFWLtWrOcD5U1sP
         T+Oi9WjuDKlGiODWPw3bKIW5PrfyiCMcWNyTRnD4sWEWt9Ibubp04iEJYGn3sC/WPd
         7e6LNmS9YQcyg==
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, ejb@linux.ibm.com,
        bigeasy@linutronix.de, tglx@linutronix.de, dave@stgolabs.net,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Subject: [PATCH 02/10] scsi/megaraid: Replace adapter->dpc_h tasklet with threaded irq
Date:   Mon, 30 May 2022 16:15:04 -0700
Message-Id: <20220530231512.9729-3-dave@stgolabs.net>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530231512.9729-1-dave@stgolabs.net>
References: <20220530231512.9729-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tasklets have long been deprecated as being too heavy on the system
by running in irq context - and this is not a performance critical
path. If a higher priority process wants to run, it must wait for
the tasklet to finish before doing so. A more suitable equivalent
is to converted to threaded irq instead and do the ack sequence
in task context.

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: megaraidlinux.pdl@broadcom.com
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 drivers/scsi/megaraid/mega_common.h   |  2 --
 drivers/scsi/megaraid/megaraid_mbox.c | 52 ++++++++++-----------------
 2 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index 2ad0aa2f837d..3e56f74061b4 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -95,7 +95,6 @@ typedef struct {
 
 /**
  * struct adapter_t - driver's initialization structure
- * @aram dpc_h			: tasklet handle
  * @pdev			: pci configuration pointer for kernel
  * @host			: pointer to host structure of mid-layer
  * @lock			: synchronization lock for mid-layer and driver
@@ -149,7 +148,6 @@ typedef struct {
 #define VERSION_SIZE	16
 
 typedef struct {
-	struct tasklet_struct	dpc_h;
 	struct pci_dev		*pdev;
 	struct Scsi_Host	*host;
 	spinlock_t		lock;
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 2a339d4a7e9d..b76f67887592 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -118,8 +118,7 @@ static void megaraid_mbox_prepare_epthru(adapter_t *, scb_t *,
 		struct scsi_cmnd *);
 
 static irqreturn_t megaraid_isr(int, void *);
-
-static void megaraid_mbox_dpc(unsigned long);
+static irqreturn_t megaraid_mbox_dpc(int, void *);
 
 static ssize_t megaraid_mbox_app_hndl_show(struct device *, struct device_attribute *attr, char *);
 static ssize_t megaraid_mbox_ld_show(struct device *, struct device_attribute *attr, char *);
@@ -764,9 +763,8 @@ megaraid_init_mbox(adapter_t *adapter)
 	 */
 
 	/* request IRQ and register the interrupt service routine */
-	if (request_irq(adapter->irq, megaraid_isr, IRQF_SHARED, "megaraid",
-		adapter)) {
-
+	if (request_threaded_irq(adapter->irq, megaraid_isr, megaraid_mbox_dpc,
+				 IRQF_SHARED, "megaraid", adapter)) {
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: Couldn't register IRQ %d!\n", adapter->irq));
 		goto out_alloc_cmds;
@@ -879,10 +877,6 @@ megaraid_init_mbox(adapter_t *adapter)
 		}
 	}
 
-	// setup tasklet for DPC
-	tasklet_init(&adapter->dpc_h, megaraid_mbox_dpc,
-			(unsigned long)adapter);
-
 	con_log(CL_DLEVEL1, (KERN_INFO
 		"megaraid mbox hba successfully initialized\n"));
 
@@ -917,8 +911,6 @@ megaraid_fini_mbox(adapter_t *adapter)
 	// flush all caches
 	megaraid_mbox_flush_cache(adapter);
 
-	tasklet_kill(&adapter->dpc_h);
-
 	megaraid_sysfs_free_resources(adapter);
 
 	megaraid_free_cmd_packets(adapter);
@@ -2027,7 +2019,7 @@ megaraid_mbox_prepare_epthru(adapter_t *adapter, scb_t *scb,
  *
  * Returns:	1 if the interrupt is valid, 0 otherwise
  */
-static int
+static irqreturn_t
 megaraid_ack_sequence(adapter_t *adapter)
 {
 	mraid_device_t		*raid_dev = ADAP2RAIDDEV(adapter);
@@ -2036,7 +2028,7 @@ megaraid_ack_sequence(adapter_t *adapter)
 	uint8_t			nstatus;
 	uint8_t			completed[MBOX_MAX_FIRMWARE_STATUS];
 	struct list_head	clist;
-	int			handled;
+	int			ret = IRQ_NONE;
 	uint32_t		dword;
 	unsigned long		flags;
 	int			i, j;
@@ -2048,7 +2040,6 @@ megaraid_ack_sequence(adapter_t *adapter)
 	INIT_LIST_HEAD(&clist);
 
 	// loop till F/W has more commands for us to complete
-	handled = 0;
 	spin_lock_irqsave(MAILBOX_LOCK(raid_dev), flags);
 	do {
 		/*
@@ -2056,9 +2047,10 @@ megaraid_ack_sequence(adapter_t *adapter)
 		 * interrupt line low.
 		 */
 		dword = RDOUTDOOR(raid_dev);
-		if (dword != 0x10001234) break;
+		if (dword != 0x10001234)
+			break;
 
-		handled = 1;
+		ret = IRQ_WAKE_THREAD;
 
 		WROUTDOOR(raid_dev, 0x10001234);
 
@@ -2124,12 +2116,7 @@ megaraid_ack_sequence(adapter_t *adapter)
 
 	spin_unlock_irqrestore(COMPLETED_LIST_LOCK(adapter), flags);
 
-
-	// schedule the DPC if there is some work for it
-	if (handled)
-		tasklet_schedule(&adapter->dpc_h);
-
-	return handled;
+	return ret;
 }
 
 
@@ -2144,29 +2131,27 @@ static irqreturn_t
 megaraid_isr(int irq, void *devp)
 {
 	adapter_t	*adapter = devp;
-	int		handled;
+	int		ret;
 
-	handled = megaraid_ack_sequence(adapter);
+	ret = megaraid_ack_sequence(adapter);
 
 	/* Loop through any pending requests */
 	if (!adapter->quiescent) {
 		megaraid_mbox_runpendq(adapter, NULL);
 	}
 
-	return IRQ_RETVAL(handled);
+	return ret;
 }
 
 
 /**
- * megaraid_mbox_dpc - the tasklet to complete the commands from completed list
- * @devp	: pointer to HBA soft state
+ * megaraid_mbox_dpc - complete the commands from completed list
  *
  * Pick up the commands from the completed list and send back to the owners.
  * This is a reentrant function and does not assume any locks are held while
- * it is being called.
+ * it is being called. Runs in process context.
  */
-static void
-megaraid_mbox_dpc(unsigned long devp)
+static irqreturn_t megaraid_mbox_dpc(int irq, void *devp)
 {
 	adapter_t		*adapter = (adapter_t *)devp;
 	mraid_device_t		*raid_dev;
@@ -2188,7 +2173,8 @@ megaraid_mbox_dpc(unsigned long devp)
 	uioc_t			*kioc;
 
 
-	if (!adapter) return;
+	if (!adapter)
+		goto done;
 
 	raid_dev = ADAP2RAIDDEV(adapter);
 
@@ -2361,8 +2347,8 @@ megaraid_mbox_dpc(unsigned long devp)
 		// send the scsi packet back to kernel
 		scsi_done(scp);
 	}
-
-	return;
+done:
+	return IRQ_HANDLED;
 }
 
 
-- 
2.36.1

