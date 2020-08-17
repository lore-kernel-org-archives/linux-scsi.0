Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25455C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00DDB20758
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qY0wk6y6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgHQIyw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgHQIyl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 04:54:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD78C061389;
        Mon, 17 Aug 2020 01:54:41 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x6so7784771pgx.12;
        Mon, 17 Aug 2020 01:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q36TS0sUnDMWUt2GWNB4ozlnAPMkx3+GdsGrlLJvyUA=;
        b=qY0wk6y66ZaeR4Ik6lL6VtoLZmgBgtp5nin3lqqytvLvmbT9wsAyhbO8E4OpD5B+Nm
         1hkMXEiwWtCCsIHI4AmpbwM33MJZbtpAqQYksbiZvj1dQyEtlWBvtF+4GTjDDKh3m75s
         8on/Xsvkp/Y2IDYryebzXgdHix+mFb5mAoSIoQvgIWC9m8u6CfEOGcW71BOewmaU7dtx
         FDKnYtF2A4SItoNphG0VIEHJScBwAcjZbHrTQKQKp2294Sg9iQxp1vR4MYm8XbtyeMJ1
         hQz7opO6/6DnjhdN76BL+Shs/7lnEJrpVmxNeTJ3gLQb+JMPNYwwF/nZyF4zmipK3Ej7
         J+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q36TS0sUnDMWUt2GWNB4ozlnAPMkx3+GdsGrlLJvyUA=;
        b=IF1cbngHWeohNNfeHDajk5M0JlNfcuQr3K4V3Icf3lBzkVswQ20rxn6yqCrOHBZYrr
         r3te5jY0cx/Twgi8++yFJiGngHSf+jLOh1GNehGiEvIk8fDcc6DHTGtbqp2dWHr6NZto
         eAWJwclIAVgsZmUEfIjWoV59aZfFSlLJaYvpDxjRxaXNPKczFJ42eMPwh1cGRo8CMNjR
         7UeGSBFv1PRcjnV1VSDC4rlUUZ0lvJMU555EJlPEw/fAHFl5QgALUwkNdhx5xnWyUkJD
         8fIx+qFRQ6Fi+MIvyuu+VuSDii34ssMdTOv8DfxmNNn9/9Ttk2STPwAkoIoPuCJebdU4
         DAIA==
X-Gm-Message-State: AOAM532nz0ine7KIOg6aVrVbFK0HNz9nL0PBqVtrdNxBI8avsLb7m7jF
        Ys/nMwWFmACY9wn5ltp+JBI=
X-Google-Smtp-Source: ABdhPJwugm3uTp6xVlvRewYLNL21rtoTNfXQQpwjA6HA2B4WYeL3q8Y+n9+Tf0JfjsAOk1YejRXuaA==
X-Received: by 2002:a63:4621:: with SMTP id t33mr4926312pga.32.1597654481179;
        Mon, 17 Aug 2020 01:54:41 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id x12sm18236990pff.48.2020.08.17.01.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:54:40 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Cc:     keescook@chromium.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 3/8] scsi: ibmvscsi: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:24:04 +0530
Message-Id: <20200817085409.25268-4-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085409.25268-1-allen.cryptic@gmail.com>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c           | 6 +++---
 drivers/scsi/ibmvscsi/ibmvscsi.c         | 8 ++++----
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 7 +++----
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 77f4d37d5bd6..50f025cdabbd 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3204,9 +3204,9 @@ static irqreturn_t ibmvfc_interrupt(int irq, void *dev_instance)
  * Returns:
  *	Nothing
  **/
-static void ibmvfc_tasklet(void *data)
+static void ibmvfc_tasklet(struct tasklet_struct *t)
 {
-	struct ibmvfc_host *vhost = data;
+	struct ibmvfc_host *vhost = from_tasklet(vhost, t, tasklet);
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_crq *crq;
 	struct ibmvfc_async_crq *async;
@@ -4676,7 +4676,7 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
 
 	retrc = 0;
 
-	tasklet_init(&vhost->tasklet, (void *)ibmvfc_tasklet, (unsigned long)vhost);
+	tasklet_setup(&vhost->tasklet, (void *)ibmvfc_tasklet);
 
 	if ((rc = request_irq(vdev->irq, ibmvfc_interrupt, 0, IBMVFC_NAME, vhost))) {
 		dev_err(dev, "Couldn't register irq 0x%x. rc=%d\n", vdev->irq, rc);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index b1f3017b6547..46b818daa957 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -208,9 +208,10 @@ static int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata,
  * ibmvscsi_task: - Process srps asynchronously
  * @data:	ibmvscsi_host_data of host
  */
-static void ibmvscsi_task(void *data)
+static void ibmvscsi_task(struct tasklet_struct *t)
 {
-	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)data;
+	struct ibmvscsi_host_data *hostdata = from_tasklet(hostdata, t,
+							   srp_task);
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 	struct viosrp_crq *crq;
 	int done = 0;
@@ -366,8 +367,7 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
 	queue->cur = 0;
 	spin_lock_init(&queue->lock);
 
-	tasklet_init(&hostdata->srp_task, (void *)ibmvscsi_task,
-		     (unsigned long)hostdata);
+	tasklet_setup(&hostdata->srp_task, ibmvscsi_task);
 
 	if (request_irq(vdev->irq,
 			ibmvscsi_handle_event,
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index d9e94e81da01..e62fd6c67001 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3328,9 +3328,9 @@ static int ibmvscsis_rdma(struct ibmvscsis_cmd *cmd, struct scatterlist *sg,
  *
  * Note: this is an edge triggered interrupt. It can not be shared.
  */
-static void ibmvscsis_handle_crq(unsigned long data)
+static void ibmvscsis_handle_crq(struct tasklet_struct *t)
 {
-	struct scsi_info *vscsi = (struct scsi_info *)data;
+	struct scsi_info *vscsi = from_tasklet(vscsi, t, work_task);
 	struct viosrp_crq *crq;
 	long rc;
 	bool ack = true;
@@ -3541,8 +3541,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	dev_dbg(&vscsi->dev, "probe hrc %ld, client partition num %d\n",
 		hrc, vscsi->client_data.partition_number);
 
-	tasklet_init(&vscsi->work_task, ibmvscsis_handle_crq,
-		     (unsigned long)vscsi);
+	tasklet_setup(&vscsi->work_task, ibmvscsis_handle_crq);
 
 	init_completion(&vscsi->wait_idle);
 	init_completion(&vscsi->unconfig);
-- 
2.17.1

