Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AFCC43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 17:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3AFD214DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 17:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Ec0dqc9E";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="clbtaX41"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfKKRIk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:08:40 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48434 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726871AbfKKRIk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Nov 2019 12:08:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 0260C8EE0EA;
        Mon, 11 Nov 2019 09:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1573492120;
        bh=+Yg/2jPdCK9r7LUFp9lf3LC20PR2r7b13Z6eUeXo5fI=;
        h=Subject:From:To:Cc:Date:From;
        b=Ec0dqc9Eke3jRGhrYb0AiGUL/pUxCL/34BHchrx7/A0d3J7Bx0IQPXBW83GtC/3KP
         ZQV1BQZIkCjmkr4io+/gSKt/opUHgYkIqulElpvAz2J61kSC5BQ80vyWu76Q1l5/mc
         3Loq6PmfJNVUyGTtGuc8H0utq96BqL2tRqTAAJmA=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2NXRgvZTG6vd; Mon, 11 Nov 2019 09:08:39 -0800 (PST)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 5B5778EE0CE;
        Mon, 11 Nov 2019 09:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1573492119;
        bh=+Yg/2jPdCK9r7LUFp9lf3LC20PR2r7b13Z6eUeXo5fI=;
        h=Subject:From:To:Cc:Date:From;
        b=clbtaX41kDCW2jTMcrcN3te4zV1v4hja8JaHJneYvJs3eVypoG10F++KzmzpxvV6a
         m3N8UO8ovWUhXa1ko5QiNuvp12bhe8xgsf+7yGXgcuuyNmI89wc0fZJfzFEmzngEWc
         egl9bXXJdWZE2gKcS79qA2Jy+pjY1Y5pAnFTWp2c=
Message-ID: <1573492117.6865.5.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.4-rc7
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Mon, 11 Nov 2019 09:08:37 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three small changes: two in the core and one in the qla2xxx driver. The
sg_tablesize fix affects a thinko in the migration to blk-mq of certain
legacy drivers which could cause an oops and the sd core change should
only affect zoned block devices which were wrongly suppressing error
messages for reset all zones. 

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Damien Le Moal (1):
      scsi: sd_zbc: Fix sd_zbc_complete()

Martin Wilck (1):
      scsi: qla2xxx: fix NPIV tear down process

Michael Schmitz (1):
      scsi: core: Handle drivers which set sg_tablesize to zero

And the diffstat:

 drivers/scsi/qla2xxx/qla_mid.c |  8 +++++---
 drivers/scsi/qla2xxx/qla_os.c  |  8 +++++---
 drivers/scsi/scsi_lib.c        |  3 ++-
 drivers/scsi/sd_zbc.c          | 29 ++++++++++-------------------
 4 files changed, 22 insertions(+), 26 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 6afad68e5ba2..238240984bc1 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -76,9 +76,11 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	 * ensures no active vp_list traversal while the vport is removed
 	 * from the queue)
 	 */
-	for (i = 0; i < 10 && atomic_read(&vha->vref_count); i++)
-		wait_event_timeout(vha->vref_waitq,
-		    atomic_read(&vha->vref_count), HZ);
+	for (i = 0; i < 10; i++) {
+		if (wait_event_timeout(vha->vref_waitq,
+		    !atomic_read(&vha->vref_count), HZ) > 0)
+			break;
+	}
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	if (atomic_read(&vha->vref_count)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3568031c6504..e6ff17f38178 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1119,9 +1119,11 @@ qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
 
 	qla2x00_mark_all_devices_lost(vha, 0);
 
-	for (i = 0; i < 10; i++)
-		wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha),
-		    HZ);
+	for (i = 0; i < 10; i++) {
+		if (wait_event_timeout(vha->fcport_waitQ,
+		    test_fcport_count(vha), HZ) > 0)
+			break;
+	}
 
 	flush_workqueue(vha->hw->wq);
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dc210b9d4896..3a352a4601b1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1882,7 +1882,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size;
 
-	sgl_size = scsi_mq_inline_sgl_size(shost);
+	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
+				scsi_mq_inline_sgl_size(shost));
 	cmd_size = sizeof(struct scsi_cmnd) + shost->hostt->cmd_size + sgl_size;
 	if (scsi_host_get_prot(shost))
 		cmd_size += sizeof(struct scsi_data_buffer) +
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index de4019dc0f0b..1efc69e194f8 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -263,25 +263,16 @@ void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 	int result = cmd->result;
 	struct request *rq = cmd->request;
 
-	switch (req_op(rq)) {
-	case REQ_OP_ZONE_RESET:
-	case REQ_OP_ZONE_RESET_ALL:
-
-		if (result &&
-		    sshdr->sense_key == ILLEGAL_REQUEST &&
-		    sshdr->asc == 0x24)
-			/*
-			 * INVALID FIELD IN CDB error: reset of a conventional
-			 * zone was attempted. Nothing to worry about, so be
-			 * quiet about the error.
-			 */
-			rq->rq_flags |= RQF_QUIET;
-		break;
-
-	case REQ_OP_WRITE:
-	case REQ_OP_WRITE_ZEROES:
-	case REQ_OP_WRITE_SAME:
-		break;
+	if (req_op(rq) == REQ_OP_ZONE_RESET &&
+	    result &&
+	    sshdr->sense_key == ILLEGAL_REQUEST &&
+	    sshdr->asc == 0x24) {
+		/*
+		 * INVALID FIELD IN CDB error: reset of a conventional
+		 * zone was attempted. Nothing to worry about, so be
+		 * quiet about the error.
+		 */
+		rq->rq_flags |= RQF_QUIET;
 	}
 }
 
