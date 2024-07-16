Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875B41DDCE;
	Tue, 16 Jul 2024 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146322; cv=none; b=IWJV72gSSlDrI2UyyBljHySVUaHmXHzSarAh1DmKcrU7/JR54MO9M/LtgMkegVIelVr7Zn46IsXnUKNGSO7nNeCbOhMzrUvnWbsptBPwSE6JdouqVOM3SR9Zyhkh8lsGXUWTdBEenCentMnKDSnbq9e8p4Idl65hESz8QNUhQbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146322; c=relaxed/simple;
	bh=223TOiKAn8QnCVka2DNtxw3AZnBBCexiX1pgPf1xvxA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=idctbNFNdaalQPbcYQAnZ9/+OX/f2Vef2YzKQImXa8cLZNTWud6bJCOomkk7Zyihrv48L6kJQ0V5jIfJaEiLiXS86pH0mO2zBlM6pHj/yFVerFWxd13JrTNB7AWEgCXIkRalFgDCoIYp8PsjmswcTw8Oi4TDm09Haam6MfWtVx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWOrx56i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWOrx56i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429ECC116B1;
	Tue, 16 Jul 2024 16:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721146322;
	bh=223TOiKAn8QnCVka2DNtxw3AZnBBCexiX1pgPf1xvxA=;
	h=From:To:Cc:Subject:Date:From;
	b=gWOrx56ilTw0HLduJfVEGyZuoTT+SMCI8lqDcP88CcrSc4vZ1vK063vdpC2kgFCvM
	 NccTUrTQH7HGoxX51nef5kM+enb7lcResJWb4nnln0xbGf2NdnbrcE8FOGVT4Ikqb+
	 tZEOlZmzl36f36PNp9CxKJi57+jmlKalLyPvgOS7FKxVCpwS0i1MgJCKFO1gr3bgfg
	 7DGE1phsnjhuDX+O8M0gL+ob7bUKmMK/RUTFPHN7GRBGaX17XuZmn5pfGyC+xFvHYJ
	 hF4l9vHRHGS/8FuehRrDZpRg1cu8+gAM3+sk6x3PJqAte3bNFqfbUG77PmrYEBFRqi
	 Xlc9eFL3LpwFw==
Received: from johan by xi.lan with local (Exim 4.97.1)
	(envelope-from <johan+linaro@kernel.org>)
	id 1sTkmZ-00000000804-1kS8;
	Tue, 16 Jul 2024 18:12:03 +0200
From: Johan Hovold <johan+linaro@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan+linaro@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] Revert "scsi: sd: Do not repeat the starting disk message"
Date: Tue, 16 Jul 2024 18:11:01 +0200
Message-ID: <20240716161101.30692-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4.

The offending commit tried to suppress a double "Starting disk" message
for some drivers, but instead started spamming the log with bogus
messages every five seconds:

	[  311.798956] sd 0:0:0:0: [sda] Starting disk
	[  316.919103] sd 0:0:0:0: [sda] Starting disk
	[  322.040775] sd 0:0:0:0: [sda] Starting disk
	[  327.161140] sd 0:0:0:0: [sda] Starting disk
	[  332.281352] sd 0:0:0:0: [sda] Starting disk
	[  337.401878] sd 0:0:0:0: [sda] Starting disk
	[  342.521527] sd 0:0:0:0: [sda] Starting disk
	[  345.850401] sd 0:0:0:0: [sda] Starting disk
	[  350.967132] sd 0:0:0:0: [sda] Starting disk
	[  356.090454] sd 0:0:0:0: [sda] Starting disk
	...

on machines that do not actually stop the disk on runtime suspend (e.g.
the Qualcomm sc8280xp CRD with UFS).

Let's just revert for now to address the regression.

Fixes: 7a6bbc2829d4 ("scsi: sd: Do not repeat the starting disk message")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/scsi/sd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


Hi,

I just noticed this regression that snuck into 6.10-final and tracked it
down to 7a6bbc2829d4 ("scsi: sd: Do not repeat the starting disk
message").

I wanted to get this out ASAP to address the immediate regression while
someone who cares enough can work out a proper fix for the double start
message (which seems less annoying).

Note that the offending commit is marked for stable.

Johan


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1b7561abe05d..6b64af7d4927 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4119,6 +4119,8 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
 	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
 		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
 		return -EIO;
@@ -4135,13 +4137,12 @@ static int sd_resume_common(struct device *dev, bool runtime)
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-
 	if (!sd_do_start_stop(sdkp->device, runtime)) {
 		sdkp->suspended = false;
 		return 0;
 	}
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
 		sd_resume(dev);
-- 
2.44.2

