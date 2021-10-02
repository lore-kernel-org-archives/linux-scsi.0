Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A98C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Oct 2021 19:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1AE061AFD
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Oct 2021 19:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhJBTJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Oct 2021 15:09:23 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:55272 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230319AbhJBTJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Oct 2021 15:09:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1633201656;
        bh=aHW4aWw7fGsb/NHI3qvvcLyqssODh13ZaVjFV+VIdGM=;
        h=Message-ID:Subject:From:To:Date:From;
        b=MK+8RA1FYWXQGrUjHIF34NlRPU9a0+UxQkddE0ivT35pNOxP/e/XR1x3Exq58CF+p
         OL25dNeYPYf2FTTKp7B9jMtlEaasuW6Ei9ygop01mn3yrkAEF1sFSZ8KTO9cZ9YJ9Y
         GJrpMLOoFBkFDKj+UN0szub1yaveirg3XLY+EPCw=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 5C8D91280576;
        Sat,  2 Oct 2021 12:07:36 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id l0yPjkJRarhM; Sat,  2 Oct 2021 12:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1633201656;
        bh=aHW4aWw7fGsb/NHI3qvvcLyqssODh13ZaVjFV+VIdGM=;
        h=Message-ID:Subject:From:To:Date:From;
        b=MK+8RA1FYWXQGrUjHIF34NlRPU9a0+UxQkddE0ivT35pNOxP/e/XR1x3Exq58CF+p
         OL25dNeYPYf2FTTKp7B9jMtlEaasuW6Ei9ygop01mn3yrkAEF1sFSZ8KTO9cZ9YJ9Y
         GJrpMLOoFBkFDKj+UN0szub1yaveirg3XLY+EPCw=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id F0EAD128052A;
        Sat,  2 Oct 2021 12:07:35 -0700 (PDT)
Message-ID: <e75a06121ea5b2934045c6c71943babba7f3f390.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.15-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 02 Oct 2021 12:07:34 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Five fairly minor fixes and spelling updates, all in drivers.  Even
though the ufs fix is in tracing, it's a potentially exploitable use
beyond end of array bug.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arun Easi (1):
      scsi: qla2xxx: Fix excessive messages during device logout

Colin Ian King (1):
      scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Jiapeng Chong (1):
      scsi: ses: Fix unsigned comparison with less than zero

Jonathan Hsu (1):
      scsi: ufs: Fix illegal offset in UPIU event trace

Rahul Lakkireddy (1):
      scsi: csiostor: Add module softdep on cxgb4

And the diffstat:

 drivers/scsi/csiostor/csio_init.c | 1 +
 drivers/scsi/qla2xxx/qla_isr.c    | 4 ++--
 drivers/scsi/ses.c                | 2 +-
 drivers/scsi/ufs/ufshcd.c         | 3 +--
 drivers/scsi/virtio_scsi.c        | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 390b07bf92b9..ccbded3353bd 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1254,3 +1254,4 @@ MODULE_DEVICE_TABLE(pci, csio_pci_tbl);
 MODULE_VERSION(CSIO_DRV_VERSION);
 MODULE_FIRMWARE(FW_FNAME_T5);
 MODULE_FIRMWARE(FW_FNAME_T6);
+MODULE_SOFTDEP("pre: cxgb4");
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ece60267b971..b26f2699adb2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2634,7 +2634,7 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 
 	if (unlikely(logit))
-		ql_log(ql_log_warn, fcport->vha, 0x5060,
+		ql_log(ql_dbg_io, fcport->vha, 0x5060,
 		   "NVME-%s ERR Handling - hdl=%x status(%x) tr_len:%x resid=%x  ox_id=%x\n",
 		   sp->name, sp->handle, comp_status,
 		   fd->transferred_length, le32_to_cpu(sts->residual_len),
@@ -3491,7 +3491,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 out:
 	if (logit)
-		ql_log(ql_log_warn, fcport->vha, 0x3022,
+		ql_log(ql_dbg_io, fcport->vha, 0x3022,
 		       "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
 		       comp_status, scsi_status, res, vha->host_no,
 		       cp->device->id, cp->device->lun, fcport->d_id.b.domain,
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 43e682297fd5..0a1734f34587 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -118,7 +118,7 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 static int ses_send_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
-	u32 result;
+	int result;
 
 	unsigned char cmd[] = {
 		SEND_DIAGNOSTIC,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 029c9631ec2b..188de6f91050 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -318,8 +318,7 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	int off = (int)tag - hba->nutrs;
-	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[off];
+	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[tag];
 
 	if (!trace_ufshcd_upiu_enabled())
 		return;
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c25ce8f0e0af..07d0250f17c3 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -300,7 +300,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 		}
 		break;
 	default:
-		pr_info("Unsupport virtio scsi event reason %x\n", event->reason);
+		pr_info("Unsupported virtio scsi event reason %x\n", event->reason);
 	}
 }
 
@@ -392,7 +392,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 		virtscsi_handle_param_change(vscsi, event);
 		break;
 	default:
-		pr_err("Unsupport virtio scsi event %x\n", event->event);
+		pr_err("Unsupported virtio scsi event %x\n", event->event);
 	}
 	virtscsi_kick_event(vscsi, event_node);
 }

