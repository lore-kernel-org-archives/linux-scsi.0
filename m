Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDC64690
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2025 22:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742596412; cv=none; b=iEgKYp1USRIObMrg2liIXhvh7PMrFq3A2b6CFzPmRmy/zKksI4a5eSlRzAe6+QtE1GSJQ0/huCWNfn/mEkkU+065gkXZ8peOdEesKjhXnHcShF/eHToJoBMfXRANYK81vTO+jwYoJMMfHW5rMLA3d4NTplX1+S8QcejVEww+sXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742596412; c=relaxed/simple;
	bh=S3rvlJ5+DtF8Jo1xR0d4w3lvxKNOTvkMZ5BWDkfzBW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bc5iW9X5pIdeZmQzpcfXpgPsO9N+KHHE3ho8r1vN/y7ShL4arFaLkrKLAcAKWqrOwMESGRCl00rZdu6HmWEWvr2D20cVCRBKYeZT30m+s59IW9NQvhyxfYUPumuC0BL6zB5OfJJnowv+4ymluDLBKn0n/yuf4bPSW4nf2Nk7ADw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ssv8GFgH; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ssv8GFgH"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso26175035e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2025 15:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742596408; x=1743201208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b1emwUBCauGHN0o9nLbJW2p5eY2Gkbl1ohSVNXozEkY=;
        b=Ssv8GFgHWK+3jxUJl+HJoaBRp1bSrSTicCPK7Jq9c33lMlfRvGJzHfMrfMGrPE/++8
         ynzL84vFYCl011OJ7wsX+jwy40VUZkQz+O9JWD7ytcM2YlWoI38dcU89J5Iz3uBS4lM9
         2nOS11Gch1BVIfACYg4uNG5vZH6u2rj+lpR4B1abne6jMJQOYgvHEUn+oQtEfu8EKNP5
         erWOYXZ4NjQn3VTUpX0FfQGc1p6ID4VDy2m4zNolw8o3e8t7BrtSbLl0Ebb9EDFY9TjW
         vlpIRV4ZHTZA1nSxE7nZnVobR2D+/KNr4nNSw61VZVOExCChMR+drK3m3/M1Ckw0N9q3
         Akxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742596408; x=1743201208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b1emwUBCauGHN0o9nLbJW2p5eY2Gkbl1ohSVNXozEkY=;
        b=fH3L4RKDFX9Cb6cOldomGDX30KwhIfXs8OVbrXP2ndth5jk+dfU6XLEz7Nxm/QuhEL
         5vuMATrsKBvHlp7zIkcmsASHgbiWmVMeuUv1FCVniQP1lHB+nelsdVDcKc/zVwcn/Dm9
         DWHsoOJJ7aZ5L50yrpGjuwfjz8lj5P74iXd/+NwEotfYbs5KsSARX/G2rN+RkJWyUzC5
         5mlwLANBi2KgE1q2fPel9P4Zznk/j648Gk7Yckmy9FB5NEdxLb5L9YzA/Hfr4l4LijJL
         VBG0OlkCVmEbpgooRqpMyTViHL124oxBqTx/m8J4rnQJ+rBSw0kx1h/3t1RtgEk3ImG/
         1uHA==
X-Forwarded-Encrypted: i=1; AJvYcCWUSlFDlk4LXezT+aFPatQoJHXg8mKPHQJgq/8DlJ3AHGH/REJlXqywQIgkuvL3lF+nE2rHowC6NtFM@vger.kernel.org
X-Gm-Message-State: AOJu0YxRPic0FN/4+EGRT3CzU+nMgkqkPoEUkyKT4lrekWio3FlPpcCK
	Z8r9R5LboaQBK1VD8a9JN+1Qw1ZPXEvfcRZGs1ewpFIaxtgZWsyZ3RaoZodj2w0=
X-Gm-Gg: ASbGncv4ElY2Zki5VXA5xfC+Zk2cJ9FfFBUoRprJyx0sI/1epAJUYxRvb1JcDbh30M9
	f/hO5LHGr3iFsLBWLz3c0ij+FFlh+sEzVYT/07M3rJMOdnTFaRsmcDgTbg0lhUE2Geuj4nGuUKt
	ww2CdLOse2+S8rITbR9qY9XTw9wQSR4I7tCYjXMciKXEPzal1T+izFhTYGiWyzZ9adD2D7A0iLw
	L55S1etKp7LnNxQWVBUVh5qxh0/zIb3Whw2ICH3eGdHU/OhSS5Q20L7jrMaaidwZqLekM+66xIZ
	SfFMo3ZevU0wBPaXiYNN94+Xxh8CKddu1fjqO+xCZ2P34uzjQJ5VFVXE5qDZqqxyvpuosPuSac6
	qpd/BRbPsuyRKkC7ZtCGiaCy2viTyfI54
X-Google-Smtp-Source: AGHT+IFN+X8avfDKNezMXVZLmikCUGiSCsbhf9cDfJ2ztN/T/Zx/7s0xRQmqg2wGyTxxJ4tMRJB17A==
X-Received: by 2002:a05:600c:1d9f:b0:43d:83a:417d with SMTP id 5b1f17b1804b1-43d509ec5d7mr47267695e9.12.1742596407504;
        Fri, 21 Mar 2025 15:33:27 -0700 (PDT)
Received: from localhost (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43d43fdaca8sm91825445e9.28.2025.03.21.15.33.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 15:33:27 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Don Brace <don.brace@microchip.com>,
	James Bottomley <jejb@linux.vnet.ibm.com>
Cc: storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Martin Wilck <mwilck@suse.com>,
	Don Brace <con.brace@microchip.com>,
	Randy Wright <rwright@hpe.com>
Subject: [PATCH] scsi: smartpqi: use is_kdump_kernel() to check for kdump
Date: Fri, 21 Mar 2025 23:33:19 +0100
Message-ID: <20250321223319.109250-1-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The smartpqi driver checks the reset_devices variable to determine whether
special adjustments need to be made for kdump. This has the effect that
after a regular kexec reboot, some driver parameters such as
max_transfer_size are much lower than usual. More importantly, kexec reboot
tests have revealed memory corruption caused by the driver log being
written to system memory after a kexec.

Fix this by testing is_kdump_kernel() rather than reset_devices where
appropriate.

Fixes: 058311b72f54 ("scsi: smartpqi: Add fw log to kdump")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Acked-by: Don Brace <don.brace@microchip.com>
Tested-by: Don Brace <con.brace@microchip.com>
Cc: Randy Wright <rwright@hpe.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0da7be40c925..e790b5d4e3c7 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -19,6 +19,7 @@
 #include <linux/bcd.h>
 #include <linux/reboot.h>
 #include <linux/cciss_ioctl.h>
+#include <linux/crash_dump.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -5246,7 +5247,7 @@ static void pqi_calculate_io_resources(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->error_buffer_length =
 		ctrl_info->max_io_slots * PQI_ERROR_BUFFER_ELEMENT_LENGTH;
 
-	if (reset_devices)
+	if (is_kdump_kernel())
 		max_transfer_size = min(ctrl_info->max_transfer_size,
 			PQI_MAX_TRANSFER_SIZE_KDUMP);
 	else
@@ -5275,7 +5276,7 @@ static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 	u16 num_elements_per_iq;
 	u16 num_elements_per_oq;
 
-	if (reset_devices) {
+	if (is_kdump_kernel()) {
 		num_queue_groups = 1;
 	} else {
 		int num_cpus;
@@ -8288,12 +8289,12 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	u32 product_id;
 
 	if (reset_devices) {
-		if (pqi_is_fw_triage_supported(ctrl_info)) {
+		if (is_kdump_kernel() && pqi_is_fw_triage_supported(ctrl_info)) {
 			rc = sis_wait_for_fw_triage_completion(ctrl_info);
 			if (rc)
 				return rc;
 		}
-		if (sis_is_ctrl_logging_supported(ctrl_info)) {
+		if (is_kdump_kernel() && sis_is_ctrl_logging_supported(ctrl_info)) {
 			sis_notify_kdump(ctrl_info);
 			rc = sis_wait_for_ctrl_logging_completion(ctrl_info);
 			if (rc)
@@ -8344,7 +8345,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->product_id = (u8)product_id;
 	ctrl_info->product_revision = (u8)(product_id >> 8);
 
-	if (reset_devices) {
+	if (is_kdump_kernel()) {
 		if (ctrl_info->max_outstanding_requests >
 			PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
 				ctrl_info->max_outstanding_requests =
@@ -8480,7 +8481,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	if (rc)
 		return rc;
 
-	if (ctrl_info->ctrl_logging_supported && !reset_devices) {
+	if (ctrl_info->ctrl_logging_supported && !is_kdump_kernel()) {
 		pqi_host_setup_buffer(ctrl_info, &ctrl_info->ctrl_log_memory, PQI_CTRL_LOG_TOTAL_SIZE, PQI_CTRL_LOG_MIN_SIZE);
 		pqi_host_memory_update(ctrl_info, &ctrl_info->ctrl_log_memory, PQI_VENDOR_GENERAL_CTRL_LOG_MEMORY_UPDATE);
 	}
-- 
2.49.0

