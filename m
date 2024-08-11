Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C8E613D;
	Sun, 11 Aug 2024 08:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723364580; cv=none; b=TgPyR+GofQkJQbj/4vdq0XLu40sOp2hu5Z1CSdjNfdVF6f8Z6TSfHpNICs+sChwe85f5k+q7DgTHcZBdPmG/Pv1C3VfjhfM/sWAPfhyEv+Ev+S5C1y3J9Z5HvSDlIffeZPB2VVZPgjsRDyzonGdrU/BS9T1hBJdgzcgyfIdZGyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723364580; c=relaxed/simple;
	bh=hN8Oh44lZxQ/h5jy7JrCn8EZc4lCq58CYL8f93KN1L8=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=cu3a9OPdYQK9vubeEnhoZLzt0TdQOPIfsUvwUiyxE5sPtM8TIyZfAIA/qYNm2Xd926mNXgB1C4WqoA4EUWi2lPVyVoTdPzAwIX7DkAF3fAI+JFGjYq1u3ndPRK7umpIz3wlFDOkct+041BS6xS/mYy+IamGgP1SOc3CTjrn0dQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=d6lj7iei; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=d6lj7iei; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="d6lj7iei";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="d6lj7iei"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1723364575;
	bh=hN8Oh44lZxQ/h5jy7JrCn8EZc4lCq58CYL8f93KN1L8=;
	h=Message-ID:Subject:From:To:Date:From;
	b=d6lj7ieibF7NGm8O+Bgtmw3BPb6G6gKATR+Vf9TtiA/+q5kWSmbDA8lQm6At+W3NY
	 oTVokSaqp3YThO6zKI64yVEGNz4kSoN1B0gLBSDC3h3s/mzWK1GQi/gMA6ppewehNz
	 u35LffQPi4HiBUE1sU4dmdN8FbIQs7wWaSc/6bk0=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id DA9CC1287323;
	Sun, 11 Aug 2024 04:22:55 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id NnBw0NOmL-MG; Sun, 11 Aug 2024 04:22:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1723364575;
	bh=hN8Oh44lZxQ/h5jy7JrCn8EZc4lCq58CYL8f93KN1L8=;
	h=Message-ID:Subject:From:To:Date:From;
	b=d6lj7ieibF7NGm8O+Bgtmw3BPb6G6gKATR+Vf9TtiA/+q5kWSmbDA8lQm6At+W3NY
	 oTVokSaqp3YThO6zKI64yVEGNz4kSoN1B0gLBSDC3h3s/mzWK1GQi/gMA6ppewehNz
	 u35LffQPi4HiBUE1sU4dmdN8FbIQs7wWaSc/6bk0=
Received: from [IPv6:2a00:23c8:1007:7701:19d1:8255:2991:876d] (unknown [IPv6:2a00:23c8:1007:7701:19d1:8255:2991:876d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 8039C128730B;
	Sun, 11 Aug 2024 04:22:54 -0400 (EDT)
Message-ID: <cf2e36dcab26d1a1e2137897f28d41c59ee501a1.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.11-rc2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sun, 11 Aug 2024 09:22:51 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Two core fixes: one to prevent discard type changes (seen on iSCSI)
during intermittent errors and the other is fixing a lockdep problem
caused by the queue limits change. One driver fix in ufs.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Li Feng (1):
      scsi: sd: Keep the discard mode stable

Shin'ichiro Kawasaki (1):
      scsi: sd: Move sd_read_cpr() out of the q->limits_lock region

Vamshi Gajjela (1):
      scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp updating logic

And the diffstat:

 drivers/scsi/sd.c         | 15 ++++++++++-----
 drivers/ufs/core/ufshcd.c | 11 ++++++++---
 2 files changed, 18 insertions(+), 8 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8bb3a3611851..699f4f9674d9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2711,8 +2711,6 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
-
-		sd_config_discard(sdkp, lim, SD_LBP_WS16);
 	}
 
 	sdkp->capacity = lba + 1;
@@ -3365,8 +3363,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp,
 			sdkp->unmap_alignment =
 				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
 
-		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
-
 config_atomic:
 		sdkp->max_atomic = get_unaligned_be32(&vpd->data[44]);
 		sdkp->atomic_alignment = get_unaligned_be32(&vpd->data[48]);
@@ -3753,9 +3749,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 			sd_read_block_limits_ext(sdkp);
 			sd_read_block_characteristics(sdkp, &lim);
 			sd_zbc_read_zones(sdkp, &lim, buffer);
-			sd_read_cpr(sdkp);
 		}
 
+		sd_config_discard(sdkp, &lim, sd_discard_mode(sdkp));
+
 		sd_print_capacity(sdkp, old_capacity);
 
 		sd_read_write_protect_flag(sdkp, buffer);
@@ -3808,6 +3805,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (err)
 		return err;
 
+	/*
+	 * Query concurrent positioning ranges after
+	 * queue_limits_commit_update() unlocked q->limits_lock to avoid
+	 * deadlock with q->sysfs_dir_lock and q->sysfs_lock.
+	 */
+	if (sdkp->media_present && scsi_device_supports_vpd(sdp))
+		sd_read_cpr(sdkp);
+
 	/*
 	 * For a zoned drive, revalidating the zones can be done only once
 	 * the gendisk capacity is set. So if this fails, set back the gendisk
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5e3c67e96956..0b3d0c8e0dda 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4100,11 +4100,16 @@ static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
 			min_sleep_time_us =
 				MIN_DELAY_BEFORE_DME_CMDS_US - delta;
 		else
-			return; /* no more delay required */
+			min_sleep_time_us = 0; /* no more delay required */
 	}
 
-	/* allow sleep for extra 50us if needed */
-	usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
+	if (min_sleep_time_us > 0) {
+		/* allow sleep for extra 50us if needed */
+		usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
+	}
+
+	/* update the last_dme_cmd_tstamp */
+	hba->last_dme_cmd_tstamp = ktime_get();
 }
 
 /**


