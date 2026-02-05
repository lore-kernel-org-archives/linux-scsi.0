Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AEC2BE657
	for <linux-scsi@vger.kernel.org>; Thu,  5 Feb 2026 08:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770280248; cv=none; b=h5JlJtYOhWNRGrCMG5TD88JhEGzw7Qn+ZG5QTza90px4hNBIkuJ7X8wTNJVARzbQbFz4SHpIFLd7t3OuAeQxV5jT3Eb0yjlHSimK91K5+YOSnNu2tlFCrhZHP5BOfz7vhahqm3KIl/KSkpGgvGcdLyZfwy08ecrCd0NymqqcMRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770280248; c=relaxed/simple;
	bh=8TkSK1/eLLlEVbEUY1UAY3c1MAi4HPwAonjpncHyMTA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=V7Ro+tfvcUZRemsNdgmPJ5DRJDiAt9Ktr2rTrYdUtWD1NyUPLsE6QI3PFNvUW8qW7rQNfUSMWqFnC7cOejoyzGDKVNjXAvK5I096x3s79Ckkq6mhb5fX8QKqLCY3fJQyGuoXSMKHBbI7l7rDoTTumbXwCCz9VHuqIEFZ0f7WyP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=odK4S9yX; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="odK4S9yX"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48068127f00so5852285e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Feb 2026 00:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1770280247; x=1770885047; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sLD8F90NSsK4m8gb1uKCwFT9oVIxctOBS6noDdmTvjE=;
        b=odK4S9yXCtu6j0iZkKLkQynTMAgNTwHIsH+pYiLgW+sD2EpRliwr2Bl3HnYFmKrjt3
         mUpZLOqWTjPiogH0bqc581esAs2pdZzI03+Cko/rYVMff1BvT0nbev3rqMZ96VBnFrZR
         lMVQ9Ctze97Jb5a+xQSHX2YxbivvtCr0+U98grTSBw4KFrESKPTiTP4KS+eMGB19mSUc
         rf2dVSda0kyhY9VMUd5Q7m2o0nsyvTeFO4835GrEpFnk/C17EIBsbuQPnJS56vu9rERD
         tay1AiU+rXki4EH9/L9oczNIR1i3OIIn99uk7xh2Gdi8ziIry+4okpJ6UD/JbLwp0qCZ
         l4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770280247; x=1770885047;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLD8F90NSsK4m8gb1uKCwFT9oVIxctOBS6noDdmTvjE=;
        b=w4Sd4/DNaK3uwX02d94S5BtafYeLgRTSXDXN1AzIKickyiNyQ5AW/J3CqDow27jNRM
         RglkRXmMHNwZJKI4wec59Oa8qFTeNJpQxCEZ8xC7LVH5RP4SPpT9byBrYYVHjIw9k/8B
         t4Faiqm+2q+fOWLyGT+qYrmwElRmK3fVaFQX1Vp6rbLmXIUUzRfZCTgZqFXQ5DFBNSdH
         W2ekUsH8HjnyJqUJzcIDuXatMk39ogMYNVujOCh9fe232lFcLM0Y6nf5FGO0C0qBYjlb
         WStYFEklwQXgrVwI4KMqPw0Pq+GjyDkFDBbYVzRyNkP46avdoz/OR0aS3BV6PG/TA+H0
         jn1w==
X-Gm-Message-State: AOJu0YzWXpBjdXCBmnMsdg6KvyRFh+rBQS7wCfx+iDBsdpY1bQn24Rt9
	XAzveQaahHBL8L3J+Vv1qI7LZFn0StT36noS2idiUQCCehV49R2eqGD8i5OIHkFv8zs=
X-Gm-Gg: AZuq6aKhJNJXFCR99ud+ub7rJXHsDjNJHOb6FlGXPhiAhTLGUYY8aZVYDLxoKavPKkA
	u89QF7M6tiC9IH4qM7QdjQXlMpE0oUnC/0NxBfZrK8Ipd2TtisD/5ibuG+bfMXZngNcH3QTSqfL
	/u6fbrdL4cCTDdD1Omf7eg4iNlX+u8y2H49NqU7Z9AaCihBcn2yoLayVgUMmgoMRqFCFvcjhBV0
	X+ONm1dbW3d2FnWPOHBZyjXTR2r84Gh3Sna23nA/13gsDdbStO3DEDFlMfg0umN83n8hJCwoI5X
	UAK7zr6DSqI+yn+VvTF7qYQ2FGUFvO7kJdAmdpHeCbdzKxpjzV6lkQNwp38CbWv8Q1I56gvf22a
	CwZy3ZXt9CecqZOqIt+eS42vd8k5H+NF9xq95Yqd0PhdcttKptnzL/Di5fvnw1LoGyp1g7ow76u
	+GQoKXC875HpGjOkp7LBQU3aW6hyL8ckf20pqonw5idobCzFU7YXVCNos9PAt2hIE=
X-Received: by 2002:a05:600c:6383:b0:477:54cd:200e with SMTP id 5b1f17b1804b1-4830e92293dmr71737305e9.1.1770280246826;
        Thu, 05 Feb 2026 00:30:46 -0800 (PST)
Received: from alchark-surface.localdomain (bba-94-59-44-101.alshamil.net.ae. [94.59.44.101])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48317d35684sm41516915e9.7.2026.02.05.00.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 00:30:46 -0800 (PST)
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 05 Feb 2026 12:30:23 +0400
Subject: [PATCH v2] scsi: ufs: core: Fix RPMB region size detection for UFS
 2.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260205-ufs-rpmb-v2-1-5e1572ee52bf@flipper.net>
X-B4-Tracking: v=1; b=H4sIAB5VhGkC/23MQQ7CIBCF4as0sxYDtKK48h6mCyqDnURbMlSia
 bi72LXL/+XlWyEhEyY4NyswZko0TzX0roHb6KY7CvK1QUttpNJWvEISHJ+D8MqenLHWddJDvUf
 GQO+Nuva1R0rLzJ9Nzuq3/kGyEkoYqw5t54ajbsMlPChG5P2EC/SllC9W8524ogAAAA==
X-Change-ID: 20260129-ufs-rpmb-d198a699a40d
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Alexey Charkov <alchark@flipper.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2586; i=alchark@flipper.net;
 h=from:subject:message-id; bh=8TkSK1/eLLlEVbEUY1UAY3c1MAi4HPwAonjpncHyMTA=;
 b=owGbwMvMwCW2adGNfoHIK0sZT6slMWS2hJp8PTdJ+ducVMnvS8uYVBdJ7DFwv3BfyrSFXf6aR
 nzFTDPPjoksDGJcDJZiiixzvy2xnWrEN2uXh8dXmDmsTCBDpEUaGICAhYEvNzGv1EjHSM9U21DP
 0FDHWMeIgYtTAKb64COGv9K/l35jkl/4OejOy5sbXf77heVpn9l2mn2HqNG7b17RpQaMDL/69xw
 6yyQxI078adSENTG2E7MzgtKPd+Tqma3LyWg15QUA
X-Developer-Key: i=alchark@flipper.net; a=openpgp;
 fpr=9DF6A43D95320E9ABA4848F5B2A2D88F1059D4A5

Older UFS spec devices (2.2 and earlier) do not expose per-region RPMB
sizes, as only one RPMB region is supported. In such cases, the size of
the single RPMB region can be deduced from the Logical Block Count and
Logical Block Size fields in the RPMB Unit Descriptor.

Add a fallback mechanism to calculate the RPMB region size from these
fields if the device implements an older spec, so that the RPMB driver
can work with such devices - otherwise it silently skips the whole RPMB.

        Section 14.1.4.6 (RPMB Unit Descriptor)

Link: https://www.jedec.org/system/files/docs/JESD220C-2_2.pdf
Cc: stable@vger.kernel.org
Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
---
Changes in v2:
- Comment on the expected size of the RPMB partition on UFS 2.2 (thanks Bean)
- Use a standard define for size instead of a magic number (thanks Bean)
- Link to v1: https://lore.kernel.org/r/20260129-ufs-rpmb-v1-1-691534ab723f@flipper.net
---
 drivers/ufs/core/ufshcd.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 52ffd0c3aa4c..32da8ecdba72 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -24,6 +24,7 @@
 #include <linux/pm_opp.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sched/clock.h>
+#include <linux/sizes.h>
 #include <linux/iopoll.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
@@ -5249,6 +5250,20 @@ static void ufshcd_lu_init(struct ufs_hba *hba, struct scsi_device *sdev)
 		hba->dev_info.rpmb_region_size[1] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION1_SIZE];
 		hba->dev_info.rpmb_region_size[2] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION2_SIZE];
 		hba->dev_info.rpmb_region_size[3] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION3_SIZE];
+
+		if (hba->dev_info.wspecversion <= 0x0220) {
+			/* These older spec chips have only one RPMB region,
+			 * sized between 128 kB minimum and 16 MB maximum.
+			 * No per region size fields are provided, so get it
+			 * from the logical block count and size fields for
+			 * compatibility
+			 */
+			hba->dev_info.rpmb_region_size[0] =
+				(get_unaligned_be64(desc_buf
+					+ RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_COUNT)
+				<< desc_buf[RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_SIZE])
+				/ SZ_128K;
+		}
 	}
 
 

---
base-commit: 5c009020744fe129e4728e71c44a6c7816c9105e
change-id: 20260129-ufs-rpmb-d198a699a40d

Best regards,
-- 
Alexey Charkov <alchark@flipper.net>

