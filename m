Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3D8C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAAE724954
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:31:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="taRppZsM";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="IXmO1A7e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgEHRbk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:31:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42800 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726746AbgEHRbi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:31:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 5FFF58EE269;
        Fri,  8 May 2020 10:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1588959098;
        bh=ccfPUMPOZrwzfliVDDgWfLincd4TIFff8Vt2wm+HZWI=;
        h=Subject:From:To:Cc:Date:From;
        b=taRppZsMBhJyjIpGxGtMyRmZk/Cy6my59uQ0VNQGBN/tPuM1/0+dSSL6xg9UaaSzU
         +2Xn9w8uWYP0lXZn5WP9rplrQAt19vv0Oq8XpG2VS8B3aQ5PHz4L9xnHmsXiLNPDqN
         ivbPPmJ2U44N/Gql0vyNIYY4Rmw3MAy0jVl5uXY8=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 98BeorSCoWdG; Fri,  8 May 2020 10:31:38 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id A1F918EE0F8;
        Fri,  8 May 2020 10:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1588959097;
        bh=ccfPUMPOZrwzfliVDDgWfLincd4TIFff8Vt2wm+HZWI=;
        h=Subject:From:To:Cc:Date:From;
        b=IXmO1A7ebfLJ64cSREZLl5ap6rP85YReGhnMDZYGahMHFE68uBSgmTKK4OQfX6g8c
         DFCjhABQKgVJqr4Utplx6NLWWOHFQj4oTxg2lin2hU7UIiIeJbOeOu10u4uPeaKGQ8
         RDCkQ/x7g2EUXOISVFIhF8WvwZKeURb1jJN3mgaE=
Message-ID: <1588959096.3837.12.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.7-rc4
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 08 May 2020 10:31:36 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Four minor fixes, all in drivers (qla2xxx, ibmvfc, ibmvscsi)

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arun Easi (1):
      scsi: qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV

Brian King (1):
      scsi: ibmvfc: Don't send implicit logouts prior to NPIV login

Quinn Tran (1):
      scsi: qla2xxx: Delete all sessions before unregister local nvme port

Tyrel Datwyler (1):
      scsi: ibmvscsi: Fix WARN_ON during event pool release

And the diffstat:

 drivers/scsi/ibmvscsi/ibmvfc.c   | 5 +++++
 drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ----
 drivers/scsi/qla2xxx/qla_attr.c  | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c   | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

With full diff below

James

---

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 7da9e060b270..635f6f9cffc4 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3640,6 +3640,11 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
 	struct ibmvfc_host *vhost = tgt->vhost;
 	struct ibmvfc_event *evt;
 
+	if (!vhost->logged_in) {
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+		return;
+	}
+
 	if (vhost->discovery_threads >= disc_threads)
 		return;
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 7f66a7783209..59f0f1030c54 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2320,16 +2320,12 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 static int ibmvscsi_remove(struct vio_dev *vdev)
 {
 	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
-	unsigned long flags;
 
 	srp_remove_host(hostdata->host);
 	scsi_remove_host(hostdata->host);
 
 	purge_requests(hostdata, DID_ERROR);
-
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	release_event_pool(&hostdata->pool, hostdata);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 
 	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
 					max_events);
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 97cabd7e0014..33255968f03a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3031,11 +3031,11 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
 		msleep(1000);
 
-	qla_nvme_delete(vha);
 
 	qla24xx_disable_vp(vha);
 	qla2x00_wait_for_sess_deletion(vha);
 
+	qla_nvme_delete(vha);
 	vha->flags.delete_progress = 1;
 
 	qlt_remove_target(ha, vha);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4ed90437e8c4..d6c991bd1bde 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3153,7 +3153,7 @@ qla24xx_abort_command(srb_t *sp)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
 	    "Entered %s.\n", __func__);
 
-	if (vha->flags.qpairs_available && sp->qpair)
+	if (sp->qpair)
 		req = sp->qpair->req;
 	else
 		return QLA_FUNCTION_FAILED;
