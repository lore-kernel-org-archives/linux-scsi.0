Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA4AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C67C61108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241376AbhJGUbi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:38 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:35723 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbhJGUbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:37 -0400
Received: by mail-pf1-f173.google.com with SMTP id c29so6326087pfp.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+6ZGNI+XMycnAMLbDue6xTWxM3zEGm/8Al4sgJdh2T8=;
        b=nwMV/iR9IzRy7l7R4uL9W+t4xKph77PEKrpVcIlQxLtgdRrH9yMswI1hXC7NfXA0en
         L7TXjcXNeSP6tzLFB2lcSbNVJftzxn/SXjIaelIlbymHC1Rwlr4C1fTp078Sa7JvSvfw
         /F+4HevCM+bWd4wx+2ciMWQvjcaJH4JdNNTEx2GkJHr1fUCJv4TtCWE87PO6sidjPYcE
         W6SAEHyobTiKhdk3teU60dsu7iSSyXZ9wjxTcOx+wA16yAKDlUPU+RTZ+QAncGMVF8hQ
         Q+s5sXCBYQwYqlFLIvZbHVY6mufTstsG6IlcK3Gbln/B4Y+dE1e4Grt1wTNtVjU7yNxf
         MOaA==
X-Gm-Message-State: AOAM530NtUXbYfAX2Rdu8b5jfMvqO8YK/Q5G6uSweUj5SkJ1hSpxrssi
        Ehd6ZDDZeOAVoBbOhw9k34w=
X-Google-Smtp-Source: ABdhPJy+xWm4zeIkOBynSVIKMhhE7Ald1irUB53ynaPFfobsWc8gZ4Q0NCTn60cM+c1dbIKf9+kjlQ==
X-Received: by 2002:a63:c045:: with SMTP id z5mr1349578pgi.374.1633638583515;
        Thu, 07 Oct 2021 13:29:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 06/88] message: fusion: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:01 -0700
Message-Id: <20211007202923.2174984-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/message/fusion/mptfc.c    |  6 +++---
 drivers/message/fusion/mptsas.c   |  2 +-
 drivers/message/fusion/mptscsih.c | 10 +++++-----
 drivers/message/fusion/mptspi.c   |  4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 572333fadd68..7a6278ae71d2 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -649,14 +649,14 @@ mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 
 	if (!vdevice || !vdevice->vtarget) {
 		SCpnt->result = DID_NO_CONNECT << 16;
-		SCpnt->scsi_done(SCpnt);
+		scsi_done(SCpnt);
 		return 0;
 	}
 
 	err = fc_remote_port_chkready(rport);
 	if (unlikely(err)) {
 		SCpnt->result = err;
-		SCpnt->scsi_done(SCpnt);
+		scsi_done(SCpnt);
 		return 0;
 	}
 
@@ -664,7 +664,7 @@ mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 	ri = *((struct mptfc_rport_info **)rport->dd_data);
 	if (unlikely(!ri)) {
 		SCpnt->result = DID_IMM_RETRY << 16;
-		SCpnt->scsi_done(SCpnt);
+		scsi_done(SCpnt);
 		return 0;
 	}
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 85285ba8e817..38a7cb0a3ecc 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1929,7 +1929,7 @@ mptsas_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 
 	if (!vdevice || !vdevice->vtarget || vdevice->vtarget->deleted) {
 		SCpnt->result = DID_NO_CONNECT << 16;
-		SCpnt->scsi_done(SCpnt);
+		scsi_done(SCpnt);
 		return 0;
 	}
 
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index ce2e5b21978e..ab9611e775d3 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1009,7 +1009,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 	/* Unmap the DMA buffers, if any. */
 	scsi_dma_unmap(sc);
 
-	sc->scsi_done(sc);		/* Issue the command callback */
+	scsi_done(sc);			/* Issue the command callback */
 
 	/* Free Chain buffers */
 	mptscsih_freeChainBuffers(ioc, req_idx);
@@ -1054,7 +1054,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 		dtmprintk(ioc, sdev_printk(KERN_INFO, sc->device, MYIOC_s_FMT
 		    "completing cmds: fw_channel %d, fw_id %d, sc=%p, mf = %p, "
 		    "idx=%x\n", ioc->name, channel, id, sc, mf, ii));
-		sc->scsi_done(sc);
+		scsi_done(sc);
 	}
 }
 EXPORT_SYMBOL(mptscsih_flush_running_cmds);
@@ -1118,7 +1118,7 @@ mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
 			   "fw_id %d, sc=%p, mf = %p, idx=%x\n", ioc->name,
 			   vdevice->vtarget->channel, vdevice->vtarget->id,
 			   sc, mf, ii));
-			sc->scsi_done(sc);
+			scsi_done(sc);
 			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 		}
 	}
@@ -1693,7 +1693,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	 */
 	if ((hd = shost_priv(SCpnt->device->host)) == NULL) {
 		SCpnt->result = DID_RESET << 16;
-		SCpnt->scsi_done(SCpnt);
+		scsi_done(SCpnt);
 		printk(KERN_ERR MYNAM ": task abort: "
 		    "can't locate host! (sc=%p)\n", SCpnt);
 		return FAILED;
@@ -1710,7 +1710,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		    "task abort: device has been deleted (sc=%p)\n",
 		    ioc->name, SCpnt));
 		SCpnt->result = DID_NO_CONNECT << 16;
-		SCpnt->scsi_done(SCpnt);
+		scsi_done(SCpnt);
 		retval = SUCCESS;
 		goto out;
 	}
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index af0ce5611e4a..44b7ce124ae1 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -782,14 +782,14 @@ mptspi_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 
 	if (!vdevice || !vdevice->vtarget) {
 		SCpnt->result = DID_NO_CONNECT << 16;
-		SCpnt->scsi_done(SCpnt);
+		scsi_done(SCpnt);
 		return 0;
 	}
 
 	if (SCpnt->device->channel == 1 &&
 		mptscsih_is_phys_disk(ioc, 0, SCpnt->device->id) == 0) {
 		SCpnt->result = DID_NO_CONNECT << 16;
-		SCpnt->scsi_done(SCpnt);
+		scsi_done(SCpnt);
 		return 0;
 	}
 
