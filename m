Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2FB33F394
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 03:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790651641; cv=none; b=KJRjqW8YrO+HaaNemwT6rLj+hkeSJbZCdToXoW5bQqIPnuzqb/J+hw2LZkJYpyF5TaLTTOVUEVwHM5/jMUQi1NQs2g2tOeeqXv3yBCnHAcjqvpEHIldoU6iGUNhnBH53e16rge2mTshgHrVMI0j5/R6rLiJktjDRzMjDCZGAk+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790651641; c=relaxed/simple;
	bh=2vfPUlJ9QuD5zVqreMFjCUsWeeE/7HPHd4gRkma4Hyw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Rv0kvzOBXO/pHHskR4ePOAwLnhID6n6A0oMGd+G1n9Icug/VBDRBEFl0lkmSMBjOv5nmfrBjRzrXTzFZMF/0TR+npqoQGk5ake7/X1hWzI0/tprnGzG1Z5qxW3gMgEZSRE5Crc3sTIZISwtxHF1tKQGQvnLz/w8H+LVwBKz1wRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IkjVMT5k; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IkjVMT5k"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc7695f6a30so3914028a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 20:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790651635; x=1791256435; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d06E3RJ83rKJqFl5RbOdW9hfiekgl+b6M3WlzGTpcCo=;
        b=IkjVMT5k5kZzGVSUKa8bYAmFmyfKE55dzMV7Pl3C6ZhlxC4dPYbDA5t8bSjF2ErpPx
         IyZ70WlSnteZumAidFdsWVXY2k/U8Nj194JtjPyJrHF0b2By326dTM//o/UGo/VqHQY7
         2lNsFA4KvCD2Dt/Ba/0F7kTG0ORw45tSptDw6YLiXjYzHt4zJajpsrq9tO2tU4TlSgd6
         vmKjMcsWyn0+Cn2Jw2m7ITptsse9kpX9fqocIx4YbCPcQOMF/UVdLY1eBouaFUkfZRhd
         i25ULDU+hj9+Ulp9BtY379G3ZtEDcT8ohtgnYIry+NwVVWB2UIE54YiJ2C19k+Ksskw6
         b4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790651635; x=1791256435;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d06E3RJ83rKJqFl5RbOdW9hfiekgl+b6M3WlzGTpcCo=;
        b=kMgEZKm38HMA/poHrgf2dXIXsFQl2tNyr8USdcGRMpiTMoaeJFO3+NmlRTALEf0gvt
         vHKnLEJZW60ZBup2X1Y2IlBgNP4wHaV/D1wS842mXcc6Q8KobWDhE3dfQ3cIPFeF+gKu
         RhpeQs+NiR/B+dmZiwuwSK4umRgKeunKdQqLW2Ln2mw3PW0ik/od65N+K6mZyrM7mnnG
         KLA4iY5oJ4tiaFuh6KHHuisWan/+ZMuQEN6lKMn/A4I5Rpz6Y78bX4OtCnqAsmAxpzqy
         issE4r+wbVLb+zUKklowqGFMN1/i/OwWOML9Hea9pJIOxQEaMcuKJ2UnkeVIk59WKZ3i
         YWZQ==
X-Forwarded-Encrypted: i=1; AKwUvBy+gLRuxqfowVWmeWSxxO1N+ARCkcNfUd3Av5YHGOqdOUaPwvFj01yOKK37f5FlBE/PgF8WiELbUgRC@vger.kernel.org
X-Gm-Message-State: AFuF++lDXMhUlqrgU9xaPbs9mG5+jJwR1L+8JxtkyMhMxl2HgClz37AY
	kia7xXwKAgc1sSNeW6C/qiKutQnJ30OragbxVYCosBij5eJ8YqG9QhEo3Cdai19X3pmDLa6BLGx
	mQkqz1BVQSqbAdnPBuRwG9g==
X-Received: from pfhc1.prod.google.com ([2002:a05:6a00:cbc1:b0:883:a484:b2de])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4eab:b0:3dd:a196:539c with SMTP id adf61e73a8af0-3de0e960800mr13032389637.62.1790651635019;
 Mon, 28 Sep 2026 20:13:55 -0700 (PDT)
Date: Tue, 29 Sep 2026 11:13:52 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929031352.1355691-1-stanleyjhu@google.com>
Subject: [PATCH] scsi: ufs: rpmb: Fix power-on UNIT ATTENTION retry
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

A merge conflict resolution dropped SCMD_FAILURE_ASCQ_ANY from the
retry added by commit a8a34238e5e6 ("scsi: ufs: rpmb: Retry power-on
UNIT ATTENTION on the RPMB WLUN"), so only 29h/00h is retried, not
the other 29h ASCQs.

Link: https://lore.kernel.org/linux-scsi/yq1jyo4onqe.fsf@mail.kernel.org/
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
Tested in QEMU on top of "scsi: ufs: rpmb: Drop the unregistered
ufs_rpmb bus" (RPMB v5 3/3).

 drivers/ufs/core/ufs-rpmb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 50ef63afd528..7b9b59c9e968 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -47,7 +47,8 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
 		{
 			.sense_key = UNIT_ATTENTION,
 			.sense_code =
-				POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED,
+				POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED |
+				SCMD_FAILURE_ASCQ_ANY,
 			.allowed = UFS_RPMB_UA_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},

base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

