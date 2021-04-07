Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDD7C433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13E3F613B8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344331AbhDGCFI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 22:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344327AbhDGCFB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 22:05:01 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1204C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 19:04:52 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id n38so2119226pfv.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 19:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UI5Zp09ANEkig+RK5CiKy9zoEuApUAORGWIXOo5PnZE=;
        b=IGz4dFVFxsnWqTRgVdSXtml1sAqywMlI4B+RK5a5MwvruYO3sUxjYgS73FHUrYELpz
         XJdnhy4WfS7VU/9DbfT3HB41ZGAQCUR3W7M7IEO9RnOU6bacGS75+KzgqBgSIlM7Irdl
         NDIoEcFLsrg3LlXEG5g3H5J8C1rMRem9/uXgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UI5Zp09ANEkig+RK5CiKy9zoEuApUAORGWIXOo5PnZE=;
        b=Xar6bQg2LQLCAIf99QPpkUddZEfUT8Av8XIDRt3V/wLVqBdlwOQq36TKWmK8GEEaaR
         snsPv8SCwSc1jq/7yFXWvV1FZIRuSn91+Ad1QO89Z6mS7nMnIWZBmPfmbe8TEk5X0bWV
         BrrAijmMZGQUQTxFqw4rqSx5/K0J1vYA+bdOSLj1NQYIXL4iDoWk3zXntDRydZWWOBip
         8greZ3g53pxAIzoHm1U/HbWBcYw+ySLZ3Qs/5/vLOdtPvmAXoW1r1vKNBRAWf3N9ug2a
         yfSGtfN5UBGRzMeF1dJeKMhjrqcwadww0tvBT+31b34qNRpsZ/1OiYU1x2mq5GL9Ed0x
         sZtw==
X-Gm-Message-State: AOAM530lYMjN4pDaZlwc3g8RETfP11utBD68wg75rk5StppzavCnCeMU
        GM2ysZaSyoSNO+1+C1WXDrMGphZYcPiMqPmHuM5xdo1ALnoXvZklNoo4BXNdVv4rmvQBwcE6mZe
        cwTitrDpbWbURVDhtchthaPXulR7qdA5S1Xba7oOzSGOlw01Iy1M7RSl7RqSkpdT3JiZ7v9txl6
        LKVFD8VQ==
X-Google-Smtp-Source: ABdhPJyKMhqy4RqF9F+gDIh+cRaBA1yktgF9GXhZmFKrwyoDsU83mtxU2OO99E5BuEllG09MLzFT7g==
X-Received: by 2002:a63:4547:: with SMTP id u7mr1027471pgk.351.1617761091878;
        Tue, 06 Apr 2021 19:04:51 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y9sm3435858pja.50.2021.04.06.19.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 19:04:51 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v2 17/24] mpi3mr: add support of threaded isr
Date:   Wed,  7 Apr 2021 07:34:44 +0530
Message-Id: <20210407020451.924822-18-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210407020451.924822-1-kashyap.desai@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003d1f6f05bf585bd1"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003d1f6f05bf585bd1

Register driver for threaded interrupt.

By default, driver will attempt io completion from interrupt context
(primary handler). Since driver tracks per reply queue outstanding ios,
it will schedule threaded ISR if there are any outstanding IOs expected
on that particular reply queue. Threaded ISR (secondary handler) will loop
for IO completion as long as there are outstanding IOs
(speculative method using same per reply queue outstanding counter)
or it has completed some X amount of commands (something like budget).

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 12 ++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 75 +++++++++++++++++++++++++++++++--
 2 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index e3ce54f877fa..3ac7b0f119bb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -144,6 +144,10 @@ extern struct list_head mrioc_list;
 /* Default target device queue depth */
 #define MPI3MR_DEFAULT_SDEV_QD	32
 
+/* Definitions for Threaded IRQ poll*/
+#define MPI3MR_IRQ_POLL_SLEEP			2
+#define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
+
 /* SGE Flag definition */
 #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
@@ -295,6 +299,9 @@ struct op_req_qinfo {
  * @q_segment_list: Segment list base virtual address
  * @q_segment_list_dma: Segment list base DMA address
  * @ephase: Expected phased identifier for the reply queue
+ * @pend_ios: Number of IOs pending in HW for this queue
+ * @enable_irq_poll: Flag to indicate polling is enabled
+ * @in_use: Queue is handled by poll/ISR
  */
 struct op_reply_qinfo {
 	u16 ci;
@@ -306,6 +313,9 @@ struct op_reply_qinfo {
 	void *q_segment_list;
 	dma_addr_t q_segment_list_dma;
 	u8 ephase;
+	atomic_t pend_ios;
+	bool enable_irq_poll;
+	atomic_t in_use;
 };
 
 /**
@@ -557,6 +567,7 @@ struct scmd_priv {
  * @shost: Scsi_Host pointer
  * @id: Controller ID
  * @cpu_count: Number of online CPUs
+ * @irqpoll_sleep: usleep unit used in threaded isr irqpoll
  * @name: Controller ASCII name
  * @driver_name: Driver ASCII name
  * @sysif_regs: System interface registers virtual address
@@ -658,6 +669,7 @@ struct mpi3mr_ioc {
 	u8 id;
 	int cpu_count;
 	bool enable_segqueue;
+	u32 irqpoll_sleep;
 
 	char name[MPI3MR_NAME_LENGTH];
 	char driver_name[MPI3MR_NAME_LENGTH];
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 58ebac2125f6..32b79876f0d2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -345,12 +345,16 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 
 	reply_qidx = op_reply_q->qid - 1;
 
+	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1))
+		return 0;
+
 	exp_phase = op_reply_q->ephase;
 	reply_ci = op_reply_q->ci;
 
 	reply_desc = mpi3mr_get_reply_desc(op_reply_q, reply_ci);
 	if ((le16_to_cpu(reply_desc->ReplyFlags) &
 	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase) {
+		atomic_dec(&op_reply_q->in_use);
 		return 0;
 	}
 
@@ -361,6 +365,7 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->RequestQueueCI));
 		mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma,
 		    reply_qidx);
+		atomic_dec(&op_reply_q->pend_ios);
 		if (reply_dma)
 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
 		num_op_reply++;
@@ -375,6 +380,14 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		if ((le16_to_cpu(reply_desc->ReplyFlags) &
 		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
 			break;
+		/*
+		 * Exit completion loop to avoid CPU lockup
+		 * Ensure remaining completion happens from threaded ISR.
+		 */
+		if (num_op_reply > mrioc->max_host_ios) {
+			intr_info->op_reply_q->enable_irq_poll = true;
+			break;
+		}
 
 	} while (1);
 
@@ -383,6 +396,7 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ConsumerIndex);
 	op_reply_q->ci = reply_ci;
 	op_reply_q->ephase = exp_phase;
+	atomic_dec(&op_reply_q->in_use);
 
 	return num_op_reply;
 }
@@ -392,7 +406,7 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 	struct mpi3mr_intr_info *intr_info = privdata;
 	struct mpi3mr_ioc *mrioc;
 	u16 midx;
-	u32 num_admin_replies = 0;
+	u32 num_admin_replies = 0, num_op_reply = 0;
 
 	if (!intr_info)
 		return IRQ_NONE;
@@ -406,8 +420,10 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 
 	if (!midx)
 		num_admin_replies = mpi3mr_process_admin_reply_q(mrioc);
+	if (intr_info->op_reply_q)
+		num_op_reply = mpi3mr_process_op_reply_q(mrioc, intr_info);
 
-	if (num_admin_replies)
+	if (num_admin_replies || num_op_reply)
 		return IRQ_HANDLED;
 	else
 		return IRQ_NONE;
@@ -428,7 +444,20 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
 	/* Call primary ISR routine */
 	ret = mpi3mr_isr_primary(irq, privdata);
 
-	return ret;
+	/*
+	 * If more IOs are expected, schedule IRQ polling thread.
+	 * Otherwise exit from ISR.
+	 */
+	if (!intr_info->op_reply_q)
+		return ret;
+
+	if (!intr_info->op_reply_q->enable_irq_poll ||
+	    !atomic_read(&intr_info->op_reply_q->pend_ios))
+		return ret;
+
+	disable_irq_nosync(pci_irq_vector(mrioc->pdev, midx));
+
+	return IRQ_WAKE_THREAD;
 }
 
 /**
@@ -443,6 +472,36 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
  */
 static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 {
+	struct mpi3mr_intr_info *intr_info = privdata;
+	struct mpi3mr_ioc *mrioc;
+	u16 midx;
+	u32 num_admin_replies = 0, num_op_reply = 0;
+
+	if (!intr_info || !intr_info->op_reply_q)
+		return IRQ_NONE;
+
+	mrioc = intr_info->mrioc;
+	midx = intr_info->msix_index;
+
+	/* Poll for pending IOs completions */
+	do {
+		if (!mrioc->intr_enabled)
+			break;
+
+		if (!midx)
+			num_admin_replies = mpi3mr_process_admin_reply_q(mrioc);
+		if (intr_info->op_reply_q)
+			num_op_reply +=
+			    mpi3mr_process_op_reply_q(mrioc, intr_info);
+
+		usleep_range(mrioc->irqpoll_sleep, 10 * mrioc->irqpoll_sleep);
+
+	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
+	    (num_op_reply < mrioc->max_host_ios));
+
+	intr_info->op_reply_q->enable_irq_poll = false;
+	enable_irq(pci_irq_vector(mrioc->pdev, midx));
+
 	return IRQ_HANDLED;
 }
 
@@ -1158,6 +1217,9 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 	op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
 	op_reply_q->ci = 0;
 	op_reply_q->ephase = 1;
+	atomic_set(&op_reply_q->pend_ios, 0);
+	atomic_set(&op_reply_q->in_use, 0);
+	op_reply_q->enable_irq_poll = false;
 
 	if (!op_reply_q->q_segments) {
 		retval = mpi3mr_alloc_op_reply_q_segments(mrioc, qidx);
@@ -1479,6 +1541,10 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 		pi = 0;
 	op_req_q->pi = pi;
 
+	if (atomic_inc_return(&mrioc->op_reply_qinfo[reply_qidx].pend_ios)
+	    > MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT)
+		mrioc->op_reply_qinfo[reply_qidx].enable_irq_poll = true;
+
 	writel(op_req_q->pi,
 	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ProducerIndex);
 
@@ -2804,6 +2870,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 	u32 ioc_status, ioc_config, i;
 	Mpi3IOCFactsData_t facts_data;
 
+	mrioc->irqpoll_sleep = MPI3MR_IRQ_POLL_SLEEP;
 	mrioc->change_count = 0;
 	if (!re_init) {
 		mrioc->cpu_count = num_online_cpus();
@@ -3089,6 +3156,8 @@ static void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		mrioc->op_reply_qinfo[i].ci = 0;
 		mrioc->op_reply_qinfo[i].num_replies = 0;
 		mrioc->op_reply_qinfo[i].ephase = 0;
+		atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
+		atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
 		mpi3mr_memset_op_reply_q_buffers(mrioc, i);
 
 		mrioc->req_qinfo[i].ci = 0;
-- 
2.18.1


--0000000000003d1f6f05bf585bd1
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICqDR4mSzCMttCzGcSI7kopXFgO2
b2JI8w/gXHeF8CzlMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQwNzAyMDQ1MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAiJEf68OAUfOWOlUm1n0Ye7372qeJd38C7qodZT6ReUrVE
FN+omOz3817UpVK8CUuCT3IeaigHmbeuyCgTG997orTdBavuVYxutJiMSy/BRlRPE8ZVWdlrTNcr
8RARpYmMvpzwxcqG9uR1/beYkCjQ/Nsr0a8Z1A3da3Kn7EjfTkruOef33nQF95AnIGV8j+dPZyWo
V3+vJJz5KKiywtXqSEKgwS3qluMRsmeqr0tfgh7x9GfrRfYqZichCBJD+gncoWsBuuyla5jLCZTr
SxxygUGlA9n6o64nBpjubAhDiUC8TqgQsclxTCiSuoHfepDeY1S7iS8mCp9Ojo/28Hx1
--0000000000003d1f6f05bf585bd1--
