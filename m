Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5953931ED93
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681520; cv=none; b=mR+mKW3B6ys2krATWJUMk0tqK3E75P1H6mi4dxpZ4JPN94unF8ZsSXk0v4qI2h1oBVzgTg9ndA70HubMSjKpRaJpq6O1a9jKfQxrXttZrfbYgKJMjOGU5MlVPwxydNdPc/b0yMWHFGt/TaAiTeKWAB4jntKsHlBEi7KARCPZTPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681520; c=relaxed/simple;
	bh=kMpwQhPqju4oCrvzV8XzrSkHCfWHp71p9nPZ/6qzfqw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TphN2qwAnd/cuMQuUo/ZshnFbjen6Cvvriaxv/NTDggZwvyz9J6FS9p7LXJV7zSr70nGD0tPiqDHbqDEF4vdWrR6jorA27ZQNMCvyE6MDGNy5XoP532gkPq4wXfYYZezDTi5pyS0bPOU7PStJYlBarwgizFlTzb1Rf+gEItwrD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GGWORXqW; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GGWORXqW"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ce9ddeddefso22933466d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681513; x=1781286313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Meq+S3sUis9q5hh4b+PS0TDRjT62KvcCqdUR4XGhqzQ=;
        b=GGWORXqWKq9c7mnwoIsRDk+O6brwfy6UgzbnN22NHDkSquPlo4wMjrl+uesw1ya0Sk
         QZfeNbOPIoiE5YzbSreaqkbX29uOo5qk98oZI7GzScAE7Cs6tL4CEIATefio9TMCp0fd
         w4PSGbZDnGPHrfjEARArDn/Q1w5hwqR7rdUgv/g1iDrjXtNldf1Uyld99WoF9EddW6o/
         aJ8gTsOQhgygdGdWBvvT89hELPEb2JCmov+JViWj+zGhTFxc+QmZfgEzdUAbskN8mI8y
         hJg1w/JR9zE8paDJW5ugKNy3i/eUPTCJnFrJF7DHS9K0NE0Dpy4kJ5CN/U+LE8B4kkha
         Sy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681513; x=1781286313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Meq+S3sUis9q5hh4b+PS0TDRjT62KvcCqdUR4XGhqzQ=;
        b=EXdaxXrtlHY8FjBlDa7v6eIgvDBzquIGy0ArlySUC/P4bmIKzF+v1BWl1+NjnLonFZ
         i503tZsAWR7DAR/nDS51P5SXc4QtaZQcdLMRw7if1Us1f2gVjCqM+wPc/6RZGHB4ct4d
         Xi6HEgKzp5GAQWtexHiKxou7EEyGMq003IIAcdvNgxrP3GixWbhvHuMWCs3nHNhi0XJ4
         y6OxR6DTF0f5/jhkGeDvMAfe8lUjnaRlTHC9UDJ6qYVhL+YQAnSefLmwN0gn37WQdIrQ
         r8ja/+NaF13d3LjkTy09YnsTW3Xo8cdut4q7dyCyAeuDjGKAcXzTSs8Wr1/gUCbgBw+z
         +n7A==
X-Gm-Message-State: AOJu0YwFu5n+bXZJdGLL0cRV1SpI7U+KqojbaQuG93Vg/1sl6iHm7yfu
	qoAVpQCIV8rPXOy5mUyljmSheFZIPtHLYIKzkSUe8MvObPQRKrk/H/JDMISqZQXy
X-Gm-Gg: Acq92OFCuXdBb7AtdE8BxMoR52M5LEHhTpL42I9HcSUHPOnGgAVy71VcUQjOI8yRdaP
	YygiIlCCvUNNdjFKgZ45pHiqpDQ9LCwDQvvwLh/xEPEzMvPkc/IViCBcnq7aiSDPO8LEgBFYIsm
	jQ+hJ8OucA6wNh9/dnRSDt3dlROs3Etoayty4EIlLnRYVFlPH81oK22+7sW9K6jmF9RfKkrCFQV
	jdTBukY9HgRF4uBl8zB6bPz7lpTOmtBGHI8EVUWzo5O9D32n6qzEAfSFMMYch21h0OsKgFNlnZS
	/6LRIwQ3+eHOdV0sHLj5eWazjFdP5hm+80gMBkokR1gVLb9vWCyu1SF9u+u2Sxs/QgFOjoiMycd
	HGlx8dOcYFBod/nn+0WCdg5x+2REUfmd2KezJIW8eeOsVGgTGSXC4wViREYL0fg9ipEkdcXuE+L
	0ua9VFLYpGzja73eYrLBVejRujxhdw5gn5xuamT6U+K9bdGzyTd9IuSDDebYZNmdz0MmPtr45wG
	6zHfueVcoWn3bSeRpMsbCsC/aNGM4Vi+qCEAt7XlQCP9eCXH91x5A==
X-Received: by 2002:a05:622a:291:b0:517:61d5:2f7b with SMTP id d75a77b69052e-51795bfe545mr65914971cf.56.1780681513197;
        Fri, 05 Jun 2026 10:45:13 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.45.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:45:12 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 13/14] lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
Date: Fri,  5 Jun 2026 11:23:35 -0700
Message-Id: <20260605182336.134919-14-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260605182336.134919-1-justintee8345@gmail.com>
References: <20260605182336.134919-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The lpfc_set_disctmo routine is not used for all cases when the driver
needs to restart discovery on the fc_disctmo timer.  Not doing so, makes
discovery timer actions invisible in some cases as they do not get logged.
This patch substitutes calls on fc_disctmo to use lpfc_set_disctmo in
lpfc_els_rcv_rscn.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 27ccd3ad4b7a..c5f3fae0ccb4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8383,7 +8383,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t payload_len, length, nportid, *cmd;
 	int rscn_cnt;
 	int rscn_id = 0, hba_id = 0;
-	int i, tmo;
+	int i;
 
 	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
@@ -8462,11 +8462,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb,
 				ndlp, NULL);
 			/* Restart disctmo if its already running */
-			if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
-				tmo = ((phba->fc_ratov * 3) + 3);
-				mod_timer(&vport->fc_disctmo,
-					  jiffies + secs_to_jiffies(tmo));
-			}
+			if (test_bit(FC_DISC_TMO, &vport->fc_flag))
+				lpfc_set_disctmo(vport);
 			return 0;
 		}
 	}
@@ -8497,11 +8494,9 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		set_bit(FC_RSCN_DEFERRED, &vport->fc_flag);
 
 		/* Restart disctmo if its already running */
-		if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
-			tmo = ((phba->fc_ratov * 3) + 3);
-			mod_timer(&vport->fc_disctmo,
-				  jiffies + secs_to_jiffies(tmo));
-		}
+		if (test_bit(FC_DISC_TMO, &vport->fc_flag))
+			lpfc_set_disctmo(vport);
+
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !test_bit(FC_RSCN_DISCOVERY, &vport->fc_flag)) {
 			set_bit(FC_RSCN_MODE, &vport->fc_flag);
-- 
2.38.0

