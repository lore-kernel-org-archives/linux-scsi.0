Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10E0201006
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 09:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739438846; cv=none; b=Pk7nsFQDfOXVkK+BoKjPSpHUBCTHb9PZpVImmLaKguSMHhheKSU/2QyH0av6TkbHlUlzAD4dSZcxLWvOlJtNtThFtOSrBf831EadcT2A+VVPAyM3StrwhEThf6rGwGBTVyfuZ8hYyXR9hVlrYK5AeZWM2keTaPBr4OfCcIYyv6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739438846; c=relaxed/simple;
	bh=Fw0sUHhie0bRmvvOmOiCUzDEi+C+jByu+9eNH7QErm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DC5Ka5KysYRhDB/Ad2XWjVvpafVmRH25KDEfpHyD8Wh0WMntUNpFWFAuVmmUHHMH0bYjMyJmg2uKOvyW4/KSWDjxY5djPI0B4vZNah5K+IcBK4KlQtTa6/vrOXw+PoHFaeCyU7EyG55J5eimEBG5XTH4HTztFFUBcchTUmi4r/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=lH91IUnb; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="lH91IUnb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=nxXiln1h6m2Qx8N76JSLWWB4KMe1xSPllRDrx0UPHNE=;
	b=lH91IUnb5VTkA7LirGDYTbirw/MJGtprMfZ3EmnrBHlLxwZAigasEG9EzP3J2++JMs5K5qMPT6x12
	 ssVw2+DzGqIZz5csElT2AfIXtUryYKFgv6pRYDF2u745lPlUoLJewMVVJwaxGegPdl3E6Bzxj8jWIK
	 i9Av3GAoApNvnyUoOZ9osxEsGWyi9D7T8aopB7UiY5DC4Z20vN859Y8SVhPwo/RJX5U82nzoRYJv//
	 CYja3SIWtxJntKDyikLzV8NpAw24uxYWXzmxiZcqS39yrKbHlcw8V/hhWqyBgNl88RSfkjlJzAvosK
	 R+yWBtESvuAn8oqWvcVdCYsWE7JaiLg==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id af56be38-e9ec-11ef-838a-005056bdf889;
	Thu, 13 Feb 2025 11:27:03 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 6/7] scsi: scsi_debug: Reset tape setting at device reset
Date: Thu, 13 Feb 2025 11:26:35 +0200
Message-ID: <20250213092636.2510-7-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Set tape block size, density and compression to default values when the
device is reset (either directly or via target, bus or host reset).

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_debug.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0a5cd35c41de..7da1758da3f5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6772,6 +6772,20 @@ static int sdebug_fail_lun_reset(struct scsi_cmnd *cmnd)
 	return 0;
 }
 
+static void scsi_tape_reset_clear(struct sdebug_dev_info *devip)
+{
+	if (sdebug_ptype == TYPE_TAPE) {
+		int i;
+
+		devip->tape_blksize = TAPE_DEF_BLKSIZE;
+		devip->tape_density = TAPE_DEF_DENSITY;
+		devip->tape_partition = 0;
+		devip->tape_dce = 0;
+		for (i = 0; i < TAPE_MAX_PARTITIONS; i++)
+			devip->tape_location[i] = 0;
+	}
+}
+
 static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
 {
 	struct scsi_device *sdp = SCpnt->device;
@@ -6785,8 +6799,10 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
 		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
 
 	scsi_debug_stop_all_queued(sdp);
-	if (devip)
+	if (devip) {
 		set_bit(SDEBUG_UA_POR, devip->uas_bm);
+		scsi_tape_reset_clear(devip);
+	}
 
 	if (sdebug_fail_lun_reset(SCpnt)) {
 		scmd_printk(KERN_INFO, SCpnt, "fail lun reset 0x%x\n", opcode);
@@ -6824,6 +6840,7 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		if (devip->target == sdp->id) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+			scsi_tape_reset_clear(devip);
 			++k;
 		}
 	}
@@ -6855,6 +6872,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
 
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+		scsi_tape_reset_clear(devip);
 		++k;
 	}
 
@@ -6878,6 +6896,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 		list_for_each_entry(devip, &sdbg_host->dev_info_list,
 				    dev_list) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+			scsi_tape_reset_clear(devip);
 			++k;
 		}
 	}
-- 
2.43.0

