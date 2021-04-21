Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86ECC43461
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 08:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91C2161433
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 08:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhDUIDU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 04:03:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234160AbhDUIDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 04:03:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618992153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5O/1WT/nJmCgZV1GTGTm/Hp3TOh6bWTc8vjsZOKmgZM=;
        b=LXc1YXViJ8Cujeyct8Lg751KoVn157j6cYhtpSgQl/izz5zeKf5AiiCNjybDs7k2zRVHON
        CsYVnlPo4HlkMB5ciXvuf86S6/mNR5B3FiHyfXM1rguF6uBpYDgWwYcU4FKCfClETZxjjY
        AxhUXMRpH8ReQr6oVVTOBbD8ZXFJF/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-abXYSjNbN2m_j3-jKdcYPg-1; Wed, 21 Apr 2021 04:02:24 -0400
X-MC-Unique: abXYSjNbN2m_j3-jKdcYPg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10A021087FEB;
        Wed, 21 Apr 2021 07:57:35 +0000 (UTC)
Received: from localhost (ovpn-13-15.pek2.redhat.com [10.72.13.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B39935C1A1;
        Wed, 21 Apr 2021 07:57:30 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        David Jeffery <djeffery@redhat.com>
Subject: [PATCH 5/5] scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in fnic_is_abts_pending
Date:   Wed, 21 Apr 2021 15:55:43 +0800
Message-Id: <20210421075543.1919826-6-ming.lei@redhat.com>
In-Reply-To: <20210421075543.1919826-1-ming.lei@redhat.com>
References: <20210421075543.1919826-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So far, scsi_host_find_tag() is supposed to use in fast path and the
passed tag should be active.

Convert the scsi command walking into blk_mq_tagset_busy_iter(), which has been one
common pattern for handling failure.

Cc: Satish Kharat <satishkh@cisco.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: David Jeffery <djeffery@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 96 ++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index ecbf4f5c5a07..af8e860f488e 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2814,58 +2814,72 @@ void fnic_exch_mgr_reset(struct fc_lport *lp, u32 sid, u32 did)
 
 }
 
-/*
- * fnic_is_abts_pending() is a helper function that
- * walks through tag map to check if there is any IOs pending,if there is one,
- * then it returns 1 (true), otherwise 0 (false)
- * if @lr_sc is non NULL, then it checks IOs specific to particular LUN,
- * otherwise, it checks for all IOs.
- */
-int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
+struct fnic_is_abts_pending_data {
+	struct scsi_cmnd *lr_sc;
+	int ret;
+};
+
+static bool __fnic_is_abts_pending(struct request *req, void *data,
+		bool reserved)
 {
-	int tag;
+	struct fnic_is_abts_pending_data *pdata = data;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
-	int ret = 0;
-	struct scsi_cmnd *sc;
 	struct scsi_device *lun_dev = NULL;
+	struct scsi_cmnd *sc = blk_mq_rq_to_pdu(req);
+	struct fc_lport *lp = shost_priv(sc->device->host);
+	struct fnic *fnic = lport_priv(lp);
 
-	if (lr_sc)
-		lun_dev = lr_sc->device;
+	if (pdata->lr_sc)
+		lun_dev = pdata->lr_sc->device;
 
-	/* walk again to check, if IOs are still pending in fw */
-	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
-		/*
-		 * ignore this lun reset cmd or cmds that do not belong to
-		 * this lun
-		 */
-		if (!sc || (lr_sc && (sc->device != lun_dev || sc == lr_sc)))
-			continue;
+	/*
+	 * ignore this lun reset cmd or cmds that do not belong to
+	 * this lun
+	 */
+	if (!sc || (pdata->lr_sc && (sc->device != lun_dev ||
+					sc == pdata->lr_sc)))
+		return true;
 
-		io_lock = fnic_io_lock_hash(fnic, sc);
-		spin_lock_irqsave(io_lock, flags);
+	io_lock = fnic_io_lock_hash(fnic, sc);
+	spin_lock_irqsave(io_lock, flags);
 
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
+	io_req = (struct fnic_io_req *)CMD_SP(sc);
 
-		if (!io_req || sc->device != lun_dev) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
+	if (!io_req || sc->device != lun_dev)
+		goto unlock;
 
-		/*
-		 * Found IO that is still pending with firmware and
-		 * belongs to the LUN that we are resetting
-		 */
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-			      "Found IO in %s on lun\n",
-			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
+	/*
+	 * Found IO that is still pending with firmware and
+	 * belongs to the LUN that we are resetting
+	 */
+	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+		      "Found IO in %s on lun\n",
+		      fnic_ioreq_state_to_str(CMD_STATE(sc)));
 
-		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
-			ret = 1;
-		spin_unlock_irqrestore(io_lock, flags);
-	}
+	if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
+		pdata->ret = 1;
+ unlock:
+	spin_unlock_irqrestore(io_lock, flags);
+	return true;
+}
 
-	return ret;
+/*
+ * fnic_is_abts_pending() is a helper function that
+ * walks through tag map to check if there is any IOs pending,if there is one,
+ * then it returns 1 (true), otherwise 0 (false)
+ * if @lr_sc is non NULL, then it checks IOs specific to particular LUN,
+ * otherwise, it checks for all IOs.
+ */
+int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
+{
+	struct fnic_is_abts_pending_data data = {
+		.lr_sc	=	lr_sc,
+		.ret	=	0,
+	};
+
+	blk_mq_tagset_busy_iter(&fnic->lport->host->tag_set,
+			__fnic_is_abts_pending, &data);
+	return data.ret;
 }
-- 
2.29.2

