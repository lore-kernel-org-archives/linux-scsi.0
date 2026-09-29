Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D23A263F4A
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 16:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790700139; cv=none; b=CGPHOfRB1p2r3uMD4FLPP1YVNNe8teQKphYRl5DC4ez13u+lkNBfY9uLlDebqyplhMYslmd5Por+PqvpeI5wpUFsyDMJvxrLIqDC27M9P6yw9/dU1noa0Re0Gw8gclXzJsGIiDCgybWc1q1PkcHl5qb+3SWGTfEbpzn6C/OeKCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790700139; c=relaxed/simple;
	bh=4oNNBVrx7iWlKCs0k9aLCLQO+dCsFhb60Z7Vs+mKWdk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YR6EfqLOc4EdhPK7IFoU4Wv0ZtlpoALNiahIvSbLxjHE6HA3WgZ5DT7SbRcRKHrU5e02gTItTiP6CcbkTEK1OV1VACY2ZxmzeWVSX6lTO+yoN55PDh4v9X9mkFRQEd6Bq6mzj6Ik73jymejxV9MVPlX1P8QuooAR9Q5Jmhkhuss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu; spf=pass smtp.mailfrom=cs.unc.edu; dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.b=TIAigef5; arc=none smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.b="TIAigef5"
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb766bfd3so38835631cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 09:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1790700135; x=1791304935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qkmc9HSMYXuGuOTX21xyysxiwNQV626wcdXoxNjH/r4=;
        b=TIAigef5/fRo3DQh1ApmGh8ZNqLC/2sdOW/k1yVBYRMU8FzToEKFWJBY7+Xk8DU8r0
         6ke/fHBgWWjPDPMyzGymFLnEKdVbzwSQKGbfpHf8r1mJKYDGCj60TZBOSwg7/qg7bxRW
         ZN4/h785w6evL1B6sqc4K1A7MdkZ6aEdQirN0J3QnU8EnWriS1DDWxKoUjApAL7Zmwxk
         JDD98ViSGpLHdC2z16UbA8jTdtFBQBl1RFTnWVdiaaqyPHbr2P2wFr2lU8jCBzCZw9hs
         FdqPDrHyqX3RQqSHIJYGajaFFzgsGS6rTNwsfh7r7D4a9u55d9Gdh7ng6u6SBpJUCiCg
         aQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790700135; x=1791304935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qkmc9HSMYXuGuOTX21xyysxiwNQV626wcdXoxNjH/r4=;
        b=0TmbESbhKEI7O0oAeA1YUR3UmTO5Zw5qLxDDkAnBxWXaqILnQ9SkSCEHawsFk5S/Fh
         /1Yz0cFCk5mj58X+fP1iNgkozpcKJ6smfLmA0IOyeyC4T03J8KNJpOzgsamsOlbKATk0
         VmbPHqAADOLKKrTsKh9yOoLOMSoPbbcR4hd0thDZqrQKsPplvp3LiLoir9I4l8ydPRhO
         f7wYLmIrwT3uB+rYTYaEC+xJsI/ICqcvoypfdy/Bu9tBOzwzw9YBYwNCA5509rKhVxWO
         ZARuJFWTHYKcHwYi3IUIN/OUGg0YNTNMm2T7YfonBZNX5WA09aBFOJ426nZet8d6gHpk
         AaBA==
X-Forwarded-Encrypted: i=1; AKwUvBwLdoTiUe9S39YDYDGDRZ7L7rUdUClA9HljQkBFLGsKq64EeHtm+qHhFfkXw4yZyC+45nO6ld2G924R@vger.kernel.org
X-Gm-Message-State: AFuF++lzGLs6CxFLfKdoVOXhOxVtniTNPrnYJ9vY/o2Q+a44pCg/6vqE
	+XVLhfa84OhgGv0zJA1zRgnwtqKCXeJUJtJdBJK9Y8OUVB0kE/lu/QmeVJz+gp+eBA==
X-Gm-Gg: AYBFou3XiFMybOQXYsBOnr4jcdBNVy0nSU+TTdctoDDWBc9x1ek+SSAL/VijxxYnc0x
	13BEY4+QHt1OBXbtEHVjr343rdgnFE1A1jZ4TUwGQSs6pecZJrUi+4cm3VL3gbw4ptLnfZ7T96f
	Br4TaR/gJS4ecteVIXgjulER1ZUAs5J30xhI/SRaD9iHtjHhn0iSadCyMp04MpURqs1FpGAYSxy
	RcGDF4eyNXceHGukcBa1fmc88ldqKBAddKdyLTuSUs0PnMpl8zxbqYYmPs/SNko3PcW8zC0yyBq
	b8Nyx89fmdZFqFA6FERWBIXqWINklk5J4p7XLKxtN/7qFeISOwVtmSw3CYVJtYMqjVaj30Rsc8a
	Q83acDaKYpwKe87M8JylkWl1OYieCVRHOeM8BuV/5Hqinb46Fjj/cFxU8sk2rSpTccnKXpJUoov
	qpCPdl/Do+JKgn8u/PGKKQEHAh4hFYUy6HMUeUsYjXRSH8ejDNfdbB/VeQRWqyi+kvRXqEB1gLO
	Vv8TMYPjFixR7Wzzy09Yg==
X-Received: by 2002:a05:622a:2d6:b0:533:360f:e753 with SMTP id d75a77b69052e-533360ff66cmr172909001cf.35.1790700134841;
        Tue, 29 Sep 2026 09:42:14 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-533223efcc4sm90377781cf.25.2026.09.29.09.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 09:42:14 -0700 (PDT)
From: hengyul@cs.unc.edu
To: dlemoal@kernel.org,
	cassel@kernel.org
Cc: mkp@kernel.org,
	ipylypiv@google.com,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hengyu Liang <hengyul@cs.unc.edu>,
	stable@vger.kernel.org
Subject: [PATCH v2] ata: libata-scsi: do not lose CHECK CONDITION for failed ATAPI commands
Date: Tue, 29 Sep 2026 12:41:35 -0400
Message-ID: <20260929164135.266708-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hengyu Liang <hengyul@cs.unc.edu>

Since commit 2e1d2e65e773 ("ata: libata-scsi: terminate deferred commands
on time out"), atapi_qc_complete() sets SAM_STAT_CHECK_CONDITION for a
failed command only if cmd->result is zero, so that the DID_TIME_OUT or
DID_REQUEUE host byte of a terminated command is preserved.

However, cmd->result can also be non-zero for a regular failed ATAPI
command completed through libata EH: ata_eh_analyze_tf() calls
ata_eh_decide_disposition(), that is, scsi_check_sense(), on the sense
data obtained with REQUEST SENSE, and scsi_check_sense() sets the SCSI
midlayer internal byte of the result for some sense codes, e.g.
SCSIML_STAT_TGT_FAILURE for ILLEGAL REQUEST with ASC 0x20 (INVALID
COMMAND OPERATION CODE) or 0x24 (INVALID FIELD IN CDB), or
SCSIML_STAT_MED_ERROR for MEDIUM ERROR with ASC 0x11 (UNRECOVERED READ
ERROR). For such commands, atapi_qc_complete() keeps the result as is and
the command completes with a GOOD status byte, even though it failed and
valid sense data is available.

As a result, passthrough users see these failed ATAPI commands as
successful. For example, with the emulated IDE CD-ROM drive of QEMU and
no medium loaded, a PLAY AUDIO MSF command issued with SG_IO completes
with status 0x00 (and no DRIVER_SENSE) instead of 0x02 (CHECK CONDITION)
with sense key ILLEGAL REQUEST, ASC/ASCQ 0x20/0x00, and the CDROM ioctls
CDROMPLAYTRKIND, CDROMSUBCHNL, CDROMPAUSE, CDROMRESUME, CDROMPLAYMSF and
CDROM_GET_MCN return 0 instead of -ENOMEDIUM or -EOPNOTSUPP.

Fix this by setting the status byte to SAM_STAT_CHECK_CONDITION whenever
the host byte is not set. Use set_status_byte() rather than overwriting
the whole result, so that the SCSI midlayer internal byte set by
scsi_check_sense() is preserved, as ata_scsi_qc_complete() already does
for ATA commands.

Fixes: 2e1d2e65e773 ("ata: libata-scsi: terminate deferred commands on time out")
Cc: stable@vger.kernel.org
Suggested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
Changes in v2:
- Only set the status byte with set_status_byte() instead of overwriting
  cmd->result, so that the SCSI midlayer internal byte set by
  scsi_check_sense() is preserved (suggested by Niklas).
- Link to v1: https://lore.kernel.org/r/20260924180414.2102946-1-hengyul@cs.unc.edu

 drivers/ata/libata-scsi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8f9aa97a519d..fb5517d51095 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3059,10 +3059,15 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
 			qc->dev->sdev->locked = 0;
 
-		if (cmd->result)
-			ata_scsi_qc_done(qc, false, 0);
-		else
-			ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
+		/*
+		 * Report CHECK CONDITION unless the command was terminated
+		 * with a host byte set. Only set the status byte, so that the
+		 * SCSI midlayer internal byte, which scsi_check_sense() may
+		 * have set from the sense data, is preserved.
+		 */
+		if (get_host_byte(cmd) == DID_OK)
+			set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
+		ata_scsi_qc_done(qc, false, 0);
 		goto schedule_deferred;
 	}
 
-- 
2.53.0

