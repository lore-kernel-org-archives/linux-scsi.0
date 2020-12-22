Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C906C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 109AD23159
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgLVKOJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgLVKOI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:14:08 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196F6C0617A6
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:12 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id j1so7203419pld.3
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lYUMeUyOwDdIF4uxTHEIj67s6zZwFJTjfnqhBWtL5QU=;
        b=EYE+v1C7yIhbL2qViLREeWb/RycZZm278rdmCj37EluZbFgUyixH8lZrhEJmwnWNrr
         CdGQwiYrJ9xc8rRUnv2ovgz7pPnmXPtDXeji2Y5fhhkBvpiht8VOdUjT6Xs9W1sFEjyc
         wTgkmMriyb06PWuB1NRh38DgLwWkfRrb1YU/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=lYUMeUyOwDdIF4uxTHEIj67s6zZwFJTjfnqhBWtL5QU=;
        b=Mb6wfX7BbgzghqrDfvDS4dKyBv4wEQwbt/YwgsFOkmr1dXepZtJuZpq6lLQB9W0yDD
         nYf15cbNsXELm2JCz8wyp8oyyB7jD4A6M4SyhYnhlO8uzC1wfG5Kjlljh7cfummr9a04
         Yf4Yxlr7QSgGWnQVJiyij6yG7yKAriE3BI4f/LqoMGTPVSjFul/WKAuo063+aqdXWsu4
         9vWqZyRLC1zYsT95SPK3x5xg3l/UmjI+apWQ1UA2OeXOSt8SwmIrgwxWG4TdAkkIxRDF
         rVuDkLPuqXVnTu/+Z9FVkHpzAm7uCFIloAfbIlBd4CdBOO6z0/l1orUEezS1ASX/CsdP
         P9uQ==
X-Gm-Message-State: AOAM532EMUVV1qYqw54CjdrC/AswOFMLKIjQv7X7oIonmhhUlcjUbBwc
        1h8rblz9uCSKbdiVyK8NPbOUkCdxubkplsi0HoiBegkE1hj7Q8pZ5VLLcsEBNdnHzwZrOfAm+ek
        X+pesFRfb4+UO+gUqCYiFFKB7UwVLP0wq7lThLMifNmeK9WKaL9l+/dfWyCTbQ5w1zg48OJyz+Z
        3MkoBQoem4
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJzkB+DLQr4Cp12fLTQtsbgPGNAs7XNzCZiRMHUp2ATnzFOL5QlcKFd+aq7+rydQ2II97vhGgg==
X-Received: by 2002:a17:90b:2317:: with SMTP id mt23mr21673783pjb.2.1608631991106;
        Tue, 22 Dec 2020 02:13:11 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:13:10 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 17/24] mpi3mr: add support of threaded isr
Date:   Tue, 22 Dec 2020 15:41:49 +0530
Message-Id: <20201222101156.98308-18-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006da2a205b70ad210"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000006da2a205b70ad210
Content-Type: text/plain; charset="US-ASCII"

Register driver for threaded interrupt.

By default, driver will attempt io completion from interrupt context
(primary handler). Since driver tracks per reply queue outstanding ios,
it will schedule threaded ISR if there are any outstanding IOs expected
on that particular reply queue. Threaded ISR (secondary handler) will loop
for IO completion as long as there are outstanding IOs
(speculative method using same per reply queue outstanding counter)
or it has completed some X amount of commands (something like budget).

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 12 ++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 75 +++++++++++++++++++++++++++++++--
 2 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 74b6b4b6e322..41a8689b46c9 100644
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
@@ -559,6 +569,7 @@ struct scmd_priv {
  * @shost: Scsi_Host pointer
  * @id: Controller ID
  * @cpu_count: Number of online CPUs
+ * @irqpoll_sleep: usleep unit used in threaded isr irqpoll
  * @name: Controller ASCII name
  * @driver_name: Driver ASCII name
  * @sysif_regs: System interface registers virtual address
@@ -660,6 +671,7 @@ struct mpi3mr_ioc {
 	u8 id;
 	int cpu_count;
 	bool enable_segqueue;
+	u32 irqpoll_sleep;
 
 	char name[MPI3MR_NAME_LENGTH];
 	char driver_name[MPI3MR_NAME_LENGTH];
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index ba4bfcc17809..4c4e21fb4ef3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -346,12 +346,16 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 
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
 
@@ -364,6 +368,7 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 
 		mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma,
 		    reply_qidx);
+		atomic_dec(&op_reply_q->pend_ios);
 		if (reply_dma)
 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
 		num_op_reply++;
@@ -378,6 +383,14 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
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
 
@@ -386,6 +399,7 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ConsumerIndex);
 	op_reply_q->ci = reply_ci;
 	op_reply_q->ephase = exp_phase;
+	atomic_dec(&op_reply_q->in_use);
 
 	return num_op_reply;
 }
@@ -395,7 +409,7 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 	struct mpi3mr_intr_info *intr_info = privdata;
 	struct mpi3mr_ioc *mrioc;
 	u16 midx;
-	u32 num_admin_replies = 0;
+	u32 num_admin_replies = 0, num_op_reply = 0;
 
 	if (!intr_info)
 		return IRQ_NONE;
@@ -409,8 +423,10 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 
 	if (!midx)
 		num_admin_replies = mpi3mr_process_admin_reply_q(mrioc);
+	if (intr_info->op_reply_q)
+		num_op_reply = mpi3mr_process_op_reply_q(mrioc, intr_info);
 
-	if (num_admin_replies)
+	if (num_admin_replies || num_op_reply)
 		return IRQ_HANDLED;
 	else
 		return IRQ_NONE;
@@ -431,7 +447,20 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
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
@@ -446,6 +475,36 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
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
 
@@ -1161,6 +1220,9 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 	op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
 	op_reply_q->ci = 0;
 	op_reply_q->ephase = 1;
+	atomic_set(&op_reply_q->pend_ios, 0);
+	atomic_set(&op_reply_q->in_use, 0);
+	op_reply_q->enable_irq_poll = false;
 
 	if (!op_reply_q->q_segments) {
 		retval = mpi3mr_alloc_op_reply_q_segments(mrioc, qidx);
@@ -1482,6 +1544,10 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 		pi = 0;
 	op_req_q->pi = pi;
 
+	if (atomic_inc_return(&mrioc->op_reply_qinfo[reply_qidx].pend_ios)
+	    > MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT)
+		mrioc->op_reply_qinfo[reply_qidx].enable_irq_poll = true;
+
 	writel(op_req_q->pi,
 	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ProducerIndex);
 
@@ -2783,6 +2849,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 	u32 ioc_status, ioc_config, i;
 	Mpi3IOCFactsData_t facts_data;
 
+	mrioc->irqpoll_sleep = MPI3MR_IRQ_POLL_SLEEP;
 	mrioc->change_count = 0;
 	if (!re_init) {
 		mrioc->cpu_count = num_online_cpus();
@@ -3068,6 +3135,8 @@ static void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		mrioc->op_reply_qinfo[i].ci = 0;
 		mrioc->op_reply_qinfo[i].num_replies = 0;
 		mrioc->op_reply_qinfo[i].ephase = 0;
+		atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
+		atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
 		mpi3mr_memset_op_reply_q_buffers(mrioc, i);
 
 		mrioc->req_qinfo[i].ci = 0;
-- 
2.18.1


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--0000000000006da2a205b70ad210
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgCVQBOHFn
RH3POQIFDpAf4bYp+bBZrb/y7NivuKnSwhwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMzExWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKR/vlqA40k+bCE2IMmvGHb7NBhp
Re1GgH3EUyEVyCEGTyqAaNxXdUgKpMAadAnBmNosEhuXGuuavAyUZH9trQSwGaC5DHv3Hk+BM2W0
2EiSq2YzaZIXXP3Sv0r0X9rx7kuzF3EIZ3fkaPejzfWHlAUEv0YtLvAwWXQIxVd7fvS1X/GsnsZ7
qUwor9m1SHSSWbL4dZqNm0er9u1P3Bw6ktBfRcBcNsBGpnwqpxJG/J19ElsTxS/sKV7xds9WT85L
gxZYvV8+9+sNpsz4nsj38XwpT/NjV/RXfwx1Ekpnm9RxHvkzRIBF0citv4TyREMEKuayzHEs7hxj
B+UpguJGN5Y=
--0000000000006da2a205b70ad210--
