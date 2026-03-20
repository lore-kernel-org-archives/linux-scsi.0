Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10851FECAB
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 04:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773980304; cv=none; b=UQ8akOzzqSkFuIgbFBqbvUKGLsUwW0j4txAg6YuIPMEttrOmByYjv33Ajo+fjpwcEmR6TU4YyQVCUn2D2doJwcqjP1TPHmDzhNQJ6FepQ54YUT72+u1tK22rH0Y11V9SASmwc+ug4xdpDYOkZtoo8D2cEOjBs1XReoaK9lffIrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773980304; c=relaxed/simple;
	bh=ER5vK4+NTw2y05vI8zpF+Yhy3gyTmavPIyw0rJSITHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L3HKCW35HEiz0ifmUCKtpSK9MDkyzIrna2a/BlyzQQw/tLt3RKFVSDzfWL++LqTkJJiB3cubKf9A5IGHoOh39OdYZPZv7qpinKPRCm9Wgn8yI2m4LXeCMUx2neM17tI1XKlf9XT3+IRCyCzhHsDh+DTeiNHgxOypfFtuq3lo9vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NNalC5Z8; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NNalC5Z8"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79a75818937so2130797b3.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 21:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773980301; x=1774585101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qGshJ8AiMplsM5THsVdJSa3m8dAqKP3aABE+cxU81cg=;
        b=NNalC5Z8EpfLPYb0TPv6bX7Mnc0OWdJ1z8bCFy0jfV0fMdN24M+rkjByyzd4yfiwLj
         3DVbbiG0cmyTuCH4IdGzU60LpGNmMdyKy5OBih9m/SaSSKQ/tHt2lflSV0EjRrxdqaGG
         UdhITODHvwA/52c6kuQXxMn6jwcdsJnRKEr0qMILq1Fe6rD6zEmtSmnSA8zRdkIGbK3z
         GHkcWGGNaTJNzfDZ0Z2hXS2kddcyd2rxMX6kkWEm2e8W30hSfm0ReyDzCBfK0xlsOzXg
         k1d3fCJdiTqQLviXCp4PnYcTHuk5jjjjahEVi21MhhdTgE40FgLEXmWgUklcs52JSKCE
         +ZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773980301; x=1774585101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qGshJ8AiMplsM5THsVdJSa3m8dAqKP3aABE+cxU81cg=;
        b=FXZIlhQ8QrbC/SvYFOrSLBOxdnfhtbwUe+YSio392g7HmcZAYUTXDTWTU8aE5V08kM
         EX4w2ruu5XKBhFppayj6Kaog3B1x+zuUz+gkE0oeQwonvWbdleunoMFVj4mQ/V/7RIhH
         dyn4Q8Te1xbktMv4aNr1peIOAUvVbZpK842KmhVFq8Jt+n/VUKGqk5rikenfMfUZRtfu
         Nlp66+d/eEJSXZpG4hHZgUI3wQfCMB/xRqneT1EKnM74f+Vj/Yc6jTp6QQgRwihNlRMQ
         crpsmUuZQklZrks/IvQ8jg4/wQlWPiNneT8w+TgmefEJf5TLKQBscwk0Sn5dUDnBwjx1
         iA8w==
X-Gm-Message-State: AOJu0Yw6eOlBuKRvM09B6WiXsfxkutUKQB7j+tHVg3t0u2HfoYi3MICN
	dppY+0+Dj+lm3T7Rh13H7WolPtmS4/8SmV5fQtodOi8jx8dRSrJkn0u2xsCNxvvp
X-Gm-Gg: ATEYQzyuCZIjkJi1QhgBcYS/PdimIT5Q0ZWgubilk3Z5pCxTvMvVtj2tIvSn9cwwX8j
	4EatIqaVMnQizLnzIlcpwL2fGz2WZa7kj2sKMP0ftdK89xObs1gawEruGhTv3scShTUTEYnbN6N
	n8L802sUcXbSWMchewremCL4pblZsjgW1AUDzMMnD0lM8amvWGB4b8RfjS4GDAzjvYCZ1PU9m27
	ePRVoqB5F0feq8O2nw1vxFZycwPMNr+WmD03GomsdyflIZyfzZD1xuMO1MYl41WR1Pfk1OL00JD
	20ZN63nGnTADI/yIlhRIaGR8fWPbccR2RbcCVvrihtnyyKKvKsYjH9gPHjX7sHYKEkyb5UHPLws
	9FSRhH19SBE6/vufBuTwMsFmGhNiNhi7m2uXVLVgvcLmx11m/EPInqet39xcfI3q+6EKDuciQ33
	1+wU3Xtidi0sTP8T/DN9m2no2cho7sp8eyTIOrNwQBGModdbTgtx00coI=
X-Received: by 2002:a05:690c:101:b0:798:1b2d:4bb7 with SMTP id 00721157ae682-79a90af1892mr16526087b3.25.1773980301475;
        Thu, 19 Mar 2026 21:18:21 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a905b9f55sm9225657b3.45.2026.03.19.21.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 21:18:20 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	storagedev@microchip.com (open list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: hpsa: kzalloc + kcalloc to kzalloc_flex
Date: Thu, 19 Mar 2026 21:18:02 -0700
Message-ID: <20260320041802.47611-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplifies allocation and freeing the struct.

Removed hpda_free_ctlr_info as it's now just a single kfree.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/hpsa.c | 17 +++--------------
 drivers/scsi/hpsa.h |  2 +-
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a1b116cd4723..608c45f4f749 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8621,25 +8621,14 @@ static struct workqueue_struct *hpsa_create_controller_wq(struct ctlr_info *h,
 	return wq;
 }
 
-static void hpda_free_ctlr_info(struct ctlr_info *h)
-{
-	kfree(h->reply_map);
-	kfree(h);
-}
-
 static struct ctlr_info *hpda_alloc_ctlr_info(void)
 {
 	struct ctlr_info *h;
 
-	h = kzalloc_obj(*h);
+	h = kzalloc_flex(*h, reply_map, nr_cpu_ids, GFP_KERNEL);
 	if (!h)
 		return NULL;
 
-	h->reply_map = kcalloc(nr_cpu_ids, sizeof(*h->reply_map), GFP_KERNEL);
-	if (!h->reply_map) {
-		kfree(h);
-		return NULL;
-	}
 	return h;
 }
 
@@ -8909,7 +8898,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		destroy_workqueue(h->monitor_ctlr_wq);
 		h->monitor_ctlr_wq = NULL;
 	}
-	hpda_free_ctlr_info(h);
+	kfree(h);
 	return rc;
 }
 
@@ -9093,7 +9082,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	free_percpu(h->lockup_detected);		/* init_one 2 */
 	h->lockup_detected = NULL;			/* init_one 2 */
 
-	hpda_free_ctlr_info(h);				/* init_one 1 */
+	kfree(h);					/* init_one 1 */
 }
 
 static int __maybe_unused hpsa_suspend(
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 99b0750850b2..935c2e1a840d 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -162,7 +162,6 @@ struct bmic_controller_parameters {
 #pragma pack()
 
 struct ctlr_info {
-	unsigned int *reply_map;
 	int	ctlr;
 	char	devname[8];
 	char    *product_name;
@@ -311,6 +310,7 @@ struct ctlr_info {
 	u8 reset_in_progress;
 	struct hpsa_sas_node *sas_host;
 	spinlock_t reset_lock;
+	unsigned int reply_map[];
 };
 
 struct offline_device_entry {
-- 
2.53.0

