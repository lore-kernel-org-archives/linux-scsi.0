Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2181E86C;
	Thu, 11 Apr 2024 23:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712879254; cv=none; b=gNllT8hJlJ36vm7Wg83erDdRJxiTKIahDHn7d6kGbooZoD5XRgOS+VNR1wvL/oJmsCtvM3T1SsRWbVMDKMaz3j1ilGdxVF4SsycgHWsB2T0TPhtAGn8zPYx4c/SKpZP/EYEs4s7TtF8wS2AF4jFZg5DUqsZnqTYS0zFp0XqMrmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712879254; c=relaxed/simple;
	bh=WYWIOF4+UKBux37fzbwdxrl6iRDTQmh3x094K2FkBDs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CuCHjGFRIkrRswydAm8qV1W1ZOp6nYTrg0tXaTS+5Q5OvxzwvmPGX8iCcjMETkeF6Uir7MM/ucYB+a7WgfCwzQehYwEjYzrem4r40+egZkCBF/ZLt4xIJdoncr/Q5+SOX9f0KuvVmj87DrrXR1B95Yad+MaXHIJj1iBpteIKWvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlOAgRlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlOAgRlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2E9C072AA;
	Thu, 11 Apr 2024 23:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712879253;
	bh=WYWIOF4+UKBux37fzbwdxrl6iRDTQmh3x094K2FkBDs=;
	h=From:To:Cc:Subject:Date:From;
	b=TlOAgRlNpvL/4QDY0VRF2QHw2MRWGsOjo6cKKdVEAvcWndLFX1uC5nWe+isUTA+SD
	 NREHUQVcgKBmFWVtMYuSa0s2DhnFC5pyK15a6AwDXBjklpRa1ICDn97jY1dymAx9TQ
	 gMcy6GI8QtuNUbLHXJE4KvZyCb5Wmwrpxv/Qqmr+32W/EaH/iuB6i7bzwatMqVpjjF
	 yVwKw9TAd2Pz4jGT5D3ZlvCf4CN+fULYHngH91KWS++T6ceXwfZSD749eSDO1fKVV+
	 F6QUpB+FNRQKkgPYflM9aIXbskxN+Td4RSvAirXhCJHCNMbyWlt6DJbnuhLHdMq1xo
	 kA1mGsEgoAHgA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] ata: libata-scsi: Fix ata_scsi_port_error_handler() error path
Date: Fri, 12 Apr 2024 08:47:31 +0900
Message-ID: <20240411234731.810968-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
incorrectly handles scsi_resume_device() errors, leading to a double
call to spin_unlock_irqrestore() to unlock a device port. Fix this by
redefining the goto labels used in case of error and only unlock the
port scsi_scan_mutex when scsi_resume_device() fails.

Bug found with the Smatch static checker warning:

	drivers/ata/libata-scsi.c:4774 ata_scsi_dev_rescan()
	error: double unlocked 'ap->lock' (orig line 4757)

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2f4c58837641..e954976891a9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4745,7 +4745,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 			 * bail out.
 			 */
 			if (ap->pflags & ATA_PFLAG_SUSPENDED)
-				goto unlock;
+				goto unlock_ap;
 
 			if (!sdev)
 				continue;
@@ -4758,7 +4758,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 			if (do_resume) {
 				ret = scsi_resume_device(sdev);
 				if (ret == -EWOULDBLOCK)
-					goto unlock;
+					goto unlock_scan;
 				dev->flags &= ~ATA_DFLAG_RESUMING;
 			}
 			ret = scsi_rescan_device(sdev);
@@ -4766,12 +4766,13 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 			spin_lock_irqsave(ap->lock, flags);
 
 			if (ret)
-				goto unlock;
+				goto unlock_ap;
 		}
 	}
 
-unlock:
+unlock_ap:
 	spin_unlock_irqrestore(ap->lock, flags);
+unlock_scan:
 	mutex_unlock(&ap->scsi_scan_mutex);
 
 	/* Reschedule with a delay if scsi_rescan_device() returned an error */
-- 
2.44.0

