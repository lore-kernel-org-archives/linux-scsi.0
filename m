Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A3F3F54A4;
	Tue, 26 May 2026 11:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779796247; cv=none; b=CwgaYD507qVqAi4fWkKfEVGzdP5YDgHLdK1MLQLZeDre46fNEV92dyIbBeHsAfGcd6w8/v7lpoc38Bzu5kbLVagP+gPdI92Afhp2nVttGqGPoOyPlFK//bVGnA6Gh1dW281yao71rGv52TrcuEd+mYlR2ezmf1SVi08yIdcNmRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779796247; c=relaxed/simple;
	bh=yZXDEb6EWEsuRdAucQrCcsmAK0Pw4tKr7EwMvRtfSrA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gz2utWd3Oik6xmPt9AANp6BT3bdzmIgUqU0uu/kkFW8ElYBxS24V100yCHdwrL0uoxzCatqBqGCkanRcmBXW/182LFTu0RE5jLvbaQwVQkVt1bR3pJGF9NiCTv/SyhpRyKKv3R4VzqFWWWZG2OepEm4UBjei8Uzr7LWx4uBUkrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 64QBnbN5092149
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Tue, 26 May 2026 19:49:37 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Tue, 26 May 2026 19:49:41
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <peter.wang@mediatek.com>, <beanhuo@micron.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1] ufs: core: complete wl runtime resume after SCSI EH
Date: Tue, 26 May 2026 19:49:41 +0800
Message-ID: <20260526114941.667477-1-hongjiefang@asrmicro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch01.asrmicro.com (10.1.24.121) To exch02.asrmicro.com
 (10.1.24.122)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 64QBnbN5092149

A PM START STOP sent from the UFS well-known LU resume path can race with
SCSI EH.

The "wl resume" task flow is:
  __ufshcd_wl_resume()
    ufshcd_set_dev_pwr_mode(UFS_ACTIVE_PWR_MODE)
      ufshcd_execute_start_stop()
        scsi_execute_cmd()
          blk_execute_rq           <-- wait
          scsi_check_passthrough() <-- may retry START STOP

If the first START STOP time out, SCSI EH may already recover the link and
reset the device before scsi_execute_cmd() returns:
  scsi_timeout()
    scsi_eh_scmd_add()
      scsi_error_handler()
        scsi_unjam_host()
          scsi_eh_ready_devs()
            scsi_eh_host_reset()
              ufshcd_eh_host_reset_handler()
                if (hba->pm_op_in_progress)
                  ufshcd_link_recovery()
                    ufshcd_device_reset()
                    ufshcd_host_reset_and_restore()
          ...
          scsi_eh_flush_done_q()   <-- wakeup "wl resume" task
        ...                        <-- host still in SHOST_RECOVERY
        scsi_restart_operations()

A later passthrough retry can then run while the host is still in
SHOST_RECOVERY and hit the SCMD_FAIL_IF_RECOVERING path:
  scsi_queue_rq()
    if (scsi_host_in_recovery(shost) &&
        cmd->flags & SCMD_FAIL_IF_RECOVERING)
      return BLK_STS_OFFLINE

That retry completes with DID_ERROR or DID_NO_CONNECT even though EH may
already have restored the device to an operational ACTIVE state.

In this case __ufshcd_wl_resume() can return -EIO even though recovery
has already restored the device to an operational ACTIVE state. This is
especially harmful for runtime PM because callback errors other than
-EAGAIN and -EBUSY are latched by the PM core as runtime_error.

After a runtime-PM START STOP returns -EIO, wait for any ongoing SCSI EH
round to finish and treat the resume as successful if recovery has
already restored:

  - an online device
  - UFSHCD_STATE_OPERATIONAL
  - an active link
  - cached ACTIVE device power mode

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
---
 drivers/ufs/core/ufshcd.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179..e7517cf23f06 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10368,6 +10368,22 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 }
 
 #ifdef CONFIG_PM
+static int ufshcd_wl_resume_pm_recovered(struct ufs_hba *hba)
+{
+	int ret = 0;
+	struct scsi_device *sdp = hba->ufs_device_wlun;
+
+	if (!sdp || !scsi_block_when_processing_errors(sdp))
+		return 0;
+
+	if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL &&
+	    ufshcd_is_link_active(hba) &&
+	    ufshcd_is_ufs_dev_active(hba))
+		ret = 1;
+
+	return ret;
+}
+
 static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int ret;
@@ -10422,6 +10438,9 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (!ufshcd_is_ufs_dev_active(hba)) {
 		ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
+		if (pm_op == UFS_RUNTIME_PM && ret == -EIO &&
+		    ufshcd_wl_resume_pm_recovered(hba))
+			ret = 0;
 		if (ret)
 			goto set_old_link_state;
 		ufshcd_set_timestamp_attr(hba);
-- 
2.25.1

