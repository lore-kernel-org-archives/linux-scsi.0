Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1225DC4742C
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 01:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CADE62063A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 01:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604366587;
	bh=3cwa2+oW48qbbKajQym3cjbPzZISxKfmoExe6aZKujk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lCjnOhho6umJ2MWCzligS/D0nQFgruhPs4M22U2TsmKq5zbehTLb69L9Ni9jC05cR
	 gZd4e39OxtkPIfLFOxFHKg4Qm2p8jhxDgSAHQEgMpz6sCqpe4vDivgwn3/ARd4EKO4
	 kc4Hl9+TdCjGK73/FtEKKdSL49qG3VgLwklyx1kU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgKCBXD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 20:23:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728223AbgKCBUt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Nov 2020 20:20:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 194B422400;
        Tue,  3 Nov 2020 01:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366449;
        bh=3cwa2+oW48qbbKajQym3cjbPzZISxKfmoExe6aZKujk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n821X1d07vJ0M8NP3BZW0Ys8udRQ5yScEDf9aV1i6o3wJAww1l2vB7UrP99XCM1sJ
         77P7jvbwzDtxf2rHOYn94Ulyi6CUgmq1jr+Bn907YFC6lvMSTqnmLz8Aeo9Kgbo1TH
         3XSOP16QNzBil2XJvo5Ce3TPWYCOej3wRRlFEcL0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/11] scsi: core: Don't start concurrent async scan on same host
Date:   Mon,  2 Nov 2020 20:20:35 -0500
Message-Id: <20201103012039.183672-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103012039.183672-1-sashal@kernel.org>
References: <20201103012039.183672-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 831e3405c2a344018a18fcc2665acc5a38c3a707 ]

The current scanning mechanism is supposed to fall back to a synchronous
host scan if an asynchronous scan is in progress. However, this rule isn't
strictly respected, scsi_prep_async_scan() doesn't hold scan_mutex when
checking shost->async_scan. When scsi_scan_host() is called concurrently,
two async scans on same host can be started and a hang in do_scan_async()
is observed.

Fixes this issue by checking & setting shost->async_scan atomically with
shost->scan_mutex.

Link: https://lore.kernel.org/r/20201010032539.426615-1-ming.lei@redhat.com
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9a7e3a3bd5ce8..009a5b2aa3d02 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1722,15 +1722,16 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
  */
 static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 {
-	struct async_scan_data *data;
+	struct async_scan_data *data = NULL;
 	unsigned long flags;
 
 	if (strncmp(scsi_scan_type, "sync", 4) == 0)
 		return NULL;
 
+	mutex_lock(&shost->scan_mutex);
 	if (shost->async_scan) {
 		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
-		return NULL;
+		goto err;
 	}
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
@@ -1741,7 +1742,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		goto err;
 	init_completion(&data->prev_finished);
 
-	mutex_lock(&shost->scan_mutex);
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->async_scan = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1756,6 +1756,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 	return data;
 
  err:
+	mutex_unlock(&shost->scan_mutex);
 	kfree(data);
 	return NULL;
 }
-- 
2.27.0

