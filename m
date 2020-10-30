Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D734C55178
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 17:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D207D20936
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 17:28:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Ak0Ng3HY";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ZIx9TQgU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgJ3R2l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 13:28:41 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:44638 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726491AbgJ3R2k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 13:28:40 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 18EFF1280E76;
        Fri, 30 Oct 2020 10:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604078920;
        bh=lj+KONZ4I+w3XheO3CXxtBVadfPLMATA9vF6xJgMjfM=;
        h=Message-ID:Subject:From:To:Date:From;
        b=Ak0Ng3HYGt5I0Sd67ks+ZvjR2V7hASUoByMK7qi12U39PM0tFYHRaq762OrtkjLZ+
         8MYazovDVOvrqLLqMA1UyLAw0C/QYEgr6KJB6j9fh5SUf3KPx9ZUd5y1DUFO8CCAPY
         jj3n8qvi7cJ7t6VuJzy3phUOswtzOfp2RkrWJaqE=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id B6A-uv44Vqdr; Fri, 30 Oct 2020 10:28:40 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id A8A661280E51;
        Fri, 30 Oct 2020 10:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604078919;
        bh=lj+KONZ4I+w3XheO3CXxtBVadfPLMATA9vF6xJgMjfM=;
        h=Message-ID:Subject:From:To:Date:From;
        b=ZIx9TQgUIh87iYb0ATBMo4WrbY4+oBNhz1izuRSEKz1cnuV8kZKXiEe+99t2dvoSy
         iFJvSYA8bpAqfqa6GFsQPZKe9EAaK5PPkHTqgWW/ewDtZEUquCBLZgeo7NgTWJ5ac8
         MgfOEeLy4NkU3yQBV8gVpQ2fk7xZABKpQwCtqHcs=
Message-ID: <86563422e11735ab7ec6cf0edbd8a7863e46a96a.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.10-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 30 Oct 2020 10:28:38 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Four driver fixes and one core fix.  The core fix closes a race window
where we could kick off a second asynchronous scan because the test and
set of the variable preventing it isn't atomic.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Daniel Wagner (1):
      scsi: qla2xxx: Return EBUSY on fcport deletion

Helge Deller (1):
      scsi: mptfusion: Fix null pointer dereferences in mptscsih_remove()

John Garry (1):
      scsi: hisi_sas: Stop using queue #0 always for v2 hw

Ming Lei (1):
      scsi: core: Don't start concurrent async scan on same host

Tyrel Datwyler (1):
      scsi: ibmvscsi: Fix potential race after loss of transport

And the diffstat:

 drivers/message/fusion/mptscsih.c     | 13 ++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_main.c |  2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c      | 36 +++++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_nvme.c       |  6 ++++--
 drivers/scsi/scsi_scan.c              |  7 ++++---
 5 files changed, 43 insertions(+), 21 deletions(-)

With full diff below.

James

---

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index a5ef9faf71c7..e7f0d4ae0f96 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1176,8 +1176,10 @@ mptscsih_remove(struct pci_dev *pdev)
 	MPT_SCSI_HOST		*hd;
 	int sz1;
 
-	if((hd = shost_priv(host)) == NULL)
-		return;
+	if (host == NULL)
+		hd = NULL;
+	else
+		hd = shost_priv(host);
 
 	mptscsih_shutdown(pdev);
 
@@ -1193,14 +1195,15 @@ mptscsih_remove(struct pci_dev *pdev)
 	    "Free'd ScsiLookup (%d) memory\n",
 	    ioc->name, sz1));
 
-	kfree(hd->info_kbuf);
+	if (hd)
+		kfree(hd->info_kbuf);
 
 	/* NULL the Scsi_Host pointer
 	 */
 	ioc->sh = NULL;
 
-	scsi_host_put(host);
-
+	if (host)
+		scsi_host_put(host);
 	mpt_detach(pdev);
 
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 128583dfccf2..c8dd8588f800 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -445,7 +445,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		}
 	}
 
-	if (scmd) {
+	if (scmd && hisi_hba->shost->nr_hw_queues) {
 		unsigned int dq_index;
 		u32 blk_tag;
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index b1f3017b6547..29fcc44be2d5 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -806,6 +806,22 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 }
 
+/**
+ * ibmvscsi_set_request_limit - Set the adapter request_limit in response to
+ * an adapter failure, reset, or SRP Login. Done under host lock to prevent
+ * race with SCSI command submission.
+ * @hostdata:	adapter to adjust
+ * @limit:	new request limit
+ */
+static void ibmvscsi_set_request_limit(struct ibmvscsi_host_data *hostdata, int limit)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	atomic_set(&hostdata->request_limit, limit);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+}
+
 /**
  * ibmvscsi_reset_host - Reset the connection to the server
  * @hostdata:	struct ibmvscsi_host_data to reset
@@ -813,7 +829,7 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 static void ibmvscsi_reset_host(struct ibmvscsi_host_data *hostdata)
 {
 	scsi_block_requests(hostdata->host);
-	atomic_set(&hostdata->request_limit, 0);
+	ibmvscsi_set_request_limit(hostdata, 0);
 
 	purge_requests(hostdata, DID_ERROR);
 	hostdata->action = IBMVSCSI_HOST_ACTION_RESET;
@@ -1146,13 +1162,13 @@ static void login_rsp(struct srp_event_struct *evt_struct)
 		dev_info(hostdata->dev, "SRP_LOGIN_REJ reason %u\n",
 			 evt_struct->xfer_iu->srp.login_rej.reason);
 		/* Login failed.  */
-		atomic_set(&hostdata->request_limit, -1);
+		ibmvscsi_set_request_limit(hostdata, -1);
 		return;
 	default:
 		dev_err(hostdata->dev, "Invalid login response typecode 0x%02x!\n",
 			evt_struct->xfer_iu->srp.login_rsp.opcode);
 		/* Login failed.  */
-		atomic_set(&hostdata->request_limit, -1);
+		ibmvscsi_set_request_limit(hostdata, -1);
 		return;
 	}
 
@@ -1163,7 +1179,7 @@ static void login_rsp(struct srp_event_struct *evt_struct)
 	 * This value is set rather than added to request_limit because
 	 * request_limit could have been set to -1 by this client.
 	 */
-	atomic_set(&hostdata->request_limit,
+	ibmvscsi_set_request_limit(hostdata,
 		   be32_to_cpu(evt_struct->xfer_iu->srp.login_rsp.req_lim_delta));
 
 	/* If we had any pending I/Os, kick them */
@@ -1195,13 +1211,13 @@ static int send_srp_login(struct ibmvscsi_host_data *hostdata)
 	login->req_buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
 					 SRP_BUF_FORMAT_INDIRECT);
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	/* Start out with a request limit of 0, since this is negotiated in
 	 * the login request we are just sending and login requests always
 	 * get sent by the driver regardless of request_limit.
 	 */
-	atomic_set(&hostdata->request_limit, 0);
+	ibmvscsi_set_request_limit(hostdata, 0);
 
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, login_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	dev_info(hostdata->dev, "sent SRP login\n");
@@ -1781,7 +1797,7 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 		return;
 	case VIOSRP_CRQ_XPORT_EVENT:	/* Hypervisor telling us the connection is closed */
 		scsi_block_requests(hostdata->host);
-		atomic_set(&hostdata->request_limit, 0);
+		ibmvscsi_set_request_limit(hostdata, 0);
 		if (crq->format == 0x06) {
 			/* We need to re-setup the interpartition connection */
 			dev_info(hostdata->dev, "Re-enabling adapter!\n");
@@ -2137,12 +2153,12 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
 	}
 
 	hostdata->action = IBMVSCSI_HOST_ACTION_NONE;
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 
 	if (rc) {
-		atomic_set(&hostdata->request_limit, -1);
+		ibmvscsi_set_request_limit(hostdata, -1);
 		dev_err(hostdata->dev, "error after %s\n", action);
 	}
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 
 	scsi_unblock_requests(hostdata->host);
 }
@@ -2226,7 +2242,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	init_waitqueue_head(&hostdata->work_wait_q);
 	hostdata->host = host;
 	hostdata->dev = dev;
-	atomic_set(&hostdata->request_limit, -1);
+	ibmvscsi_set_request_limit(hostdata, -1);
 	hostdata->host->max_sectors = IBMVSCSI_MAX_SECTORS_DEFAULT;
 
 	if (map_persist_bufs(hostdata)) {
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 1f9005125313..b7a1dc24db38 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -554,10 +554,12 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 
 	fcport = qla_rport->fcport;
 
-	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
-	    (fcport && fcport->deleted))
+	if (!qpair || !fcport)
 		return -ENODEV;
 
+	if (!qpair->fw_started || fcport->deleted)
+		return -EBUSY;
+
 	vha = fcport->vha;
 
 	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2437a7570ce..9af50e6f94c4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1714,15 +1714,16 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
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
@@ -1733,7 +1734,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		goto err;
 	init_completion(&data->prev_finished);
 
-	mutex_lock(&shost->scan_mutex);
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->async_scan = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1748,6 +1748,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 	return data;
 
  err:
+	mutex_unlock(&shost->scan_mutex);
 	kfree(data);
 	return NULL;
 }

