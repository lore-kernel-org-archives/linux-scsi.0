Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA40C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F3C61211
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240901AbhJOPQi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 11:16:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50798 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240877AbhJOPQh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 11:16:37 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634310869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xuQ9dlseb8QSm1Z1qmlP/P61CRYzuxuhzN+uy8YQa4c=;
        b=VbRC6g75nsEgTp52bSLZb1bvKlYsvT0DUQhp1nvTPv2mvoJplXXFrkUa92NGhfnlofU43n
        NGagCYRNmkgvONMRTAO96OD8D+5kLEE8qvx25X7eWFIawKriuSGnZ+t2BdzlelL6bYDvn1
        7x6qHhY2NreivGd4RN0r2Gh2+Om8wzHN28E9IsMni1tpBzSsT7ZwHqQ3kgmzsLORMxc8Du
        x25+8lPDdmtMW0PBynZqucU69zjr2I4DF4g03QmuRtiecj4fK9Ubs0/wkLbnn33i6Zwd4F
        TQxdT0o/2LESVyw3Xfxh7MjiW0DVf7Zg6oTAQ0kOMVZN7GJraBVMJUF1iwq6Ug==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634310869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xuQ9dlseb8QSm1Z1qmlP/P61CRYzuxuhzN+uy8YQa4c=;
        b=8/q4h8aY2eTLusekixdaiKwfo4eGZ7DKaSQD54mcFKcjcfWh0qDtQn4ySYovt4Iu0f2WvW
        JSPKlU4ShcrIwtAg==
To:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Cc:     Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH 3/3] scsi, usb: storage: Complete the blk-request directly.
Date:   Fri, 15 Oct 2021 17:14:12 +0200
Message-Id: <20211015151412.3229037-4-bigeasy@linutronix.de>
In-Reply-To: <20211015151412.3229037-1-bigeasy@linutronix.de>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The usb-storage driver runs in a thread and completes its request from
that thread. Since it is a single queued device it always schedules
ksoftirqd for its completion.

The completion is performed in the SCSI stack. Add
scsi_done_preemptible() which inlines most of scsi_mq_done() and
completes the request directly via blk_mq_complete_request_direct().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/scsi_lib.c   | 17 ++++++++++++++++-
 drivers/usb/storage/usb.c |  2 +-
 include/scsi/scsi_cmnd.h  |  7 +++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 572673873ddf8..f0eeedce6b081 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1575,16 +1575,31 @@ static blk_status_t scsi_prepare_cmd(struct request=
 *req)
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
=20
-static void scsi_mq_done(struct scsi_cmnd *cmd)
+static void _scsi_mq_done(struct scsi_cmnd *cmd)
 {
 	if (unlikely(blk_should_fake_timeout(scsi_cmd_to_rq(cmd)->q)))
 		return;
 	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
 		return;
 	trace_scsi_dispatch_cmd_done(cmd);
+}
+
+static void scsi_mq_done(struct scsi_cmnd *cmd)
+{
+	_scsi_mq_done(cmd);
 	blk_mq_complete_request(scsi_cmd_to_rq(cmd));
 }
=20
+void scsi_done_preemptible(struct scsi_cmnd *scmd)
+{
+	if (scmd->scsi_done !=3D scsi_mq_done) {
+		scmd->scsi_done(scmd);
+		return;
+	}
+	_scsi_mq_done(scmd);
+	blk_mq_complete_request_direct(scsi_cmd_to_rq(scmd));
+}
+
 static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
 {
 	struct scsi_device *sdev =3D q->queuedata;
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 90aa9c12ffac5..6ceedd1e14ce7 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -417,7 +417,7 @@ static int usb_stor_control_thread(void * __us)
 		if (srb) {
 			usb_stor_dbg(us, "scsi cmd done, result=3D0x%x\n",
 					srb->result);
-			srb->scsi_done(srb);
+			scsi_done_preemptible(srb);
 		}
 	} /* for (;;) */
=20
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index eaf04c9a1dfcb..e992f2f74dd69 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -396,4 +396,11 @@ static inline unsigned scsi_transfer_length(struct scs=
i_cmnd *scmd)
 extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
 			     u8 key, u8 asc, u8 ascq);
=20
+static inline void scsi_done(struct scsi_cmnd *scmd)
+{
+	scmd->scsi_done(scmd);
+}
+
+extern void scsi_done_preemptible(struct scsi_cmnd *scmd);
+
 #endif /* _SCSI_SCSI_CMND_H */
--=20
2.33.0

