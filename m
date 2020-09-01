Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEBFC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 21:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B1D0207D3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 21:05:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="n31IY9+1";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="MQVRwKN0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgIAVFB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 17:05:01 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48922 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726355AbgIAVFA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 17:05:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 254838EE112;
        Tue,  1 Sep 2020 14:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1598994299;
        bh=3yQ8KCRSQAxpdGZ/cPAEMssmlgc5FoQPkt68+FhXhxM=;
        h=Subject:From:To:Cc:Date:From;
        b=n31IY9+1uutwxiqCR+Tn4Q7rdAWPoY4rda8bR1HpKjiKLQ71Pjq5paIXO9dU/qqWH
         h2+cln0tPXpxCNBL2bFq8WOBg02oM594M1bap9MPIIF+6ktR4mm0Z4UOIdY+oDQUVa
         L+5lYiuklSFGaQtWVi4vTBRdDgGDr9S75cmbSo+g=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lm76zS-PMhPO; Tue,  1 Sep 2020 14:04:58 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 19FB08EE0F5;
        Tue,  1 Sep 2020 14:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1598994298;
        bh=3yQ8KCRSQAxpdGZ/cPAEMssmlgc5FoQPkt68+FhXhxM=;
        h=Subject:From:To:Cc:Date:From;
        b=MQVRwKN0KxlkwKC6kn2YW9+cq2JmRRS8FKN/tYXwjUfniwiPB10V7c5WRUPuTpvz1
         L3Q1S1yNsCSNfRwFmaBfLO538PQvBryfNrOv8kQXgXvVjJiewjOltdF/93XBYBAE0T
         K7l2BURG6KZRQmJSXWENJChxKci82+hNAOlo45lU=
Message-ID: <1598994296.4238.30.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.8-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 01 Sep 2020 14:04:56 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three minor fixes, all in drivers.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Carpenter (1):
      scsi: libcxgbi: Fix a use after free in cxgbi_conn_xmit_pdu()

Niklas Cassel (1):
      scsi: scsi_debug: Remove superfluous close zone in resp_open_zone()

Ye Bin (1):
      scsi: qedf: Fix null ptr reference in qedf_stag_change_work

With the diffstat:

 drivers/scsi/cxgbi/libcxgbi.c | 2 +-
 drivers/scsi/qedf/qedf_main.c | 2 +-
 drivers/scsi/scsi_debug.c     | 2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

And full diff below.

James

---

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 71aebaf533ea..0e8621a6956d 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2457,10 +2457,10 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 		return err;
 	}
 
-	__kfree_skb(skb);
 	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
 		  "itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
 		  task->itt, skb, skb->len, skb->data_len, err);
+	__kfree_skb(skb);
 	iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
 	iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
 	return err;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 3f04f2c81366..5ca424df355c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3863,7 +3863,7 @@ void qedf_stag_change_work(struct work_struct *work)
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
 	if (!qedf) {
-		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		QEDF_ERR(NULL, "qedf is NULL");
 		return;
 	}
 	QEDF_ERR(&qedf->dbg_ctx, "Performing software context reset.\n");
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 139f0073da37..1ad7260d4758 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4482,8 +4482,6 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto fini;
 	}
 
-	if (zc == ZC2_IMPLICIT_OPEN)
-		zbc_close_zone(devip, zsp);
 	zbc_open_zone(devip, zsp, true);
 fini:
 	write_unlock(macc_lckp);
