Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AAF2907;
	Mon, 27 Jan 2025 00:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737937641; cv=none; b=n/+J9XYzo818crgFBHaftyUAd7YWbjFDXGoWxkMMAbLqN1KGHJV3TnXn/6lbQyNj37xdPOjcMcUz3OFCJ1GZuBcfZyjO5ZxD1789x5apZmLmNRZARP2bvRR50UzMqqb7bDvq28RdCRPkc5Bh1NGawJ727pvlvDMWsBdn71+3T5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737937641; c=relaxed/simple;
	bh=BEJybrIIEgHvIMoObl6RIWTD6BjcQ4QJ76PwXv6EtfU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IuBFWA6CoIVsY02haWAFWQd4A2fOSOfJs5oCQllGdw5R9C+KS43WqVklhN4NSZb3XT9GZhqmecDh9+YcHThoEgUs/lPgRITnjv7mr11GNQMRgq7JMUiRN5rUfqUybJCtD3oylKrMfktAWJk+OJbb8RAQqh8W3mkZmCII+qNhxT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=RRgJegkp; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="RRgJegkp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=a9Iwuv2f0Cmw7lrIZoks3WMz0lwqvW7hrY4Go569ZIo=; b=RRgJegkpCRQpqpm7
	T5Db0aQhbrwAhZ06hGA4i1UHuDkrkwl2/M0YCXMbFF38fIKWUynjuViG7Pn64YwpzzZDrFn+2ggF+
	UsVLJXCPL+A/v3Cf3m+rMmLqO0lrS3k+3trjg+vlxZ+khSK2ZdHbeXZZDJqZ6xLXDqwQO0+xlczmv
	CXWm1amTdVsj+frfJKgLbtnOuMW+uhwwS2XQJIQv1sPphb2p5MhdkS0ZyPlUAjUmyw2gJ/s7w0D1h
	DbN1pB2uKCbp9BHxHXT27EH4xnEDlYvzbhHa/pvLJD5IXyhyY8Fs03/5KxOsBAZlaos+KvDNn0hbG
	6vff4ELK5Jm63hPVYA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tcCyD-00CDva-0H;
	Mon, 27 Jan 2025 00:27:17 +0000
From: linux@treblig.org
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: message: fusion: Remove unused mptscsih_target_reset
Date: Mon, 27 Jan 2025 00:27:16 +0000
Message-ID: <20250127002716.113641-1-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

mptscsih_target_reset() was added in 2023 by
commit e6629081fb12 ("scsi: message: fusion: Correct definitions for
mptscsih_dev_reset()")
but never used.

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/message/fusion/mptscsih.c | 60 -------------------------------
 drivers/message/fusion/mptscsih.h |  1 -
 2 files changed, 61 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 6c3f25cc33ff..86f113d98d3e 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1843,65 +1843,6 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 		return FAILED;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_target_reset - Perform a SCSI TARGET_RESET!
- *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
- *
- *	(linux scsi_host_template.eh_target_reset_handler routine)
- *
- *	Returns SUCCESS or FAILED.
- **/
-int
-mptscsih_target_reset(struct scsi_cmnd * SCpnt)
-{
-	MPT_SCSI_HOST	*hd;
-	int		 retval;
-	VirtDevice	 *vdevice;
-	MPT_ADAPTER	*ioc;
-
-	/* If we can't locate our host adapter structure, return FAILED status.
-	 */
-	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
-		printk(KERN_ERR MYNAM ": target reset: "
-		   "Can't locate host! (sc=%p)\n", SCpnt);
-		return FAILED;
-	}
-
-	ioc = hd->ioc;
-	printk(MYIOC_s_INFO_FMT "attempting target reset! (sc=%p)\n",
-	       ioc->name, SCpnt);
-	scsi_print_command(SCpnt);
-
-	vdevice = SCpnt->device->hostdata;
-	if (!vdevice || !vdevice->vtarget) {
-		retval = 0;
-		goto out;
-	}
-
-	/* Target reset to hidden raid component is not supported
-	 */
-	if (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
-		retval = FAILED;
-		goto out;
-	}
-
-	retval = mptscsih_IssueTaskMgmt(hd,
-				MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-				vdevice->vtarget->channel,
-				vdevice->vtarget->id, 0, 0,
-				mptscsih_get_tm_timeout(ioc));
-
- out:
-	printk (MYIOC_s_INFO_FMT "target reset: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
-
-	if (retval == 0)
-		return SUCCESS;
-	else
-		return FAILED;
-}
-
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
@@ -3306,7 +3247,6 @@ EXPORT_SYMBOL(mptscsih_slave_destroy);
 EXPORT_SYMBOL(mptscsih_slave_configure);
 EXPORT_SYMBOL(mptscsih_abort);
 EXPORT_SYMBOL(mptscsih_dev_reset);
-EXPORT_SYMBOL(mptscsih_target_reset);
 EXPORT_SYMBOL(mptscsih_bus_reset);
 EXPORT_SYMBOL(mptscsih_host_reset);
 EXPORT_SYMBOL(mptscsih_bios_param);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index e3d92c392673..a22c5eaf703c 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -120,7 +120,6 @@ extern void mptscsih_slave_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
-extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_host_reset(struct scsi_cmnd *SCpnt);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
-- 
2.48.1

