Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD454D90D5
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 17:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784050076; cv=none; b=MIc1uJaB/ZfF3/0RMg+dtSP9tC6xu/dwMmvAzEtq0LWm+sNcKjSDv8aFBVyYqzGSKjd8hE23vtVCzq+/CTaDtmljp0FVsMXRC+At+n9tlnqSL2mHS0uZWZTYxeyvbdioVqHPKO9THrMnxS+Sz2f2YYuu5/HFaZAk8bnbo4KaS3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784050076; c=relaxed/simple;
	bh=f4gRRdyAk0SYh/aGqpacFBqr8KjG0ILqdRvv9QEbvHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EJPQqujFWjshBj8tKA08PtSZZe0O7FbcqOGTe28mnPXjRGf2Iup7H+Wj2/o8a1Z87gF2oZaIs+P0HD/h+0lGHrGY7Na2hBZtsM9hg9CR04fvUeh4XE1oc1lfVbXJCtNdUUyibcqOWncLsmkUhHf6qK1Pjc9LTz/cDXnBbcpJZKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HSGIiyI0; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HSGIiyI0"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ce7d2adef4so16985105ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 10:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784050072; x=1784654872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hgCzlBG6lq6b/rCZWmhMuZKJx8BuNSqfyPONIcSDu8U=;
        b=HSGIiyI0sBpo4B2k5vZlWmmeNnwslAFVpFp+zHDEuyu0iNkS48ehg4uWM4wT5ZHCnb
         P7vlF2dgRXz7DxSFqKiTy88Z8bOH6k4fTDTf5njOIUE8AZ+h++1w2jQBZWq/X6/cGVeP
         co4KXKDHwrCr0pmaX8l+ZfhpWGx6GLlzgLYE0ep+JGbobaO0FVcGzDtjcofhPaXRb9xz
         4vUh2krmWfid2TG69be4jv7K/YLWZQJUNMvkit73zS08scu1Q3OLhL0+WXA13C8TEV9t
         7RBdizmLUhsvwltVOVuzIuRkHH618NCJMuopqxxq3HB8pftbFkeOj/PWWfV6zzNyqKCI
         o/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784050072; x=1784654872;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hgCzlBG6lq6b/rCZWmhMuZKJx8BuNSqfyPONIcSDu8U=;
        b=aUZrQprAxHjw5DTGTPECi4PLLy2UsF33cZNBxKKfjVdLFzS0ZdfrL0nsgRz482eF15
         lY7A+rbB0sskt7t2H2eRVqhK5xt11xlFEhZYHrUc5GcAG0MWY58iy6ZhDW4o1aePSUYm
         iZftCoeYwcYUlcTjVbOZReWY3j/LeeSAcFwcxYYcgjp1fouQxBmLScYM/Pgf0pcL/OhI
         n3t72zA6PSFiyaPacC97NAeSenjKiuxH9H/trOzkxZG/15icBncMmJ0f5P/8NqE4f/Dk
         abV5c3xrsIOIJ3kBGO+FNKv1HshP8XypNPXKt6qo5N41iv9Aa9w4w6hffk64Lf5cVSq0
         mX1A==
X-Forwarded-Encrypted: i=1; AHgh+RqfpwWW3yp+6Iy5v2Tv3MGqx2Y37boFekzrmo61X5iXQ8AQWdB1TU4O5bcaMDiB1CrL5FF1uIRaEbQ+@vger.kernel.org
X-Gm-Message-State: AOJu0YylUtY43ShgvOJSZkiZC/gclGbvq9trqXmFfb0JTnT4QKRLgv36
	oEZ0Pe4mCH/+/oVfMm3SoSoRJwnFu+W8hQh1CLR9v6P4DOq+cGcBo8fe
X-Gm-Gg: AfdE7cmsz0WrNe0Cogf9krtXi812qafNkL+mTbWThTUdTo4bzsisNFcbFltMellq6FR
	Blf5F7Y2ReGIS8n6pQGZoNdTiiNp6XNGQaebFzAnZKRjruo6NEN7aczQiLlN12ouakIfqneycnW
	RoX3HdaIG7BVa62xa0ec1CGl1Trux64uVczhLv87pzGZY3p9HHtS/rHJffxbk5uBhk4Q09Ifl/D
	9ptzVl9RMcrmL3ZUAKGcspNorNCpgWr4Sx6mH52Tj8ywekHry3MQv1jrWRabO0Gcqqvccba+MW5
	4SOXoqZK01zwCWJW2TUPz4UtXK3xnu5u29eP7B6N9vSbSuoTCEBucDBoop7Zdku60tX8RoIkWSP
	demMicIjcE+wZ7NbocNhRXF8y1tNnvjjsVwe4KJg0JHcR1nBNDWHbdIlr8+lvRLzvoUtdve7QVo
	5kTTeUjPXFQg==
X-Received: by 2002:a05:6a20:7346:b0:3b9:545d:c006 with SMTP id adf61e73a8af0-3c110009a30mr16747753637.15.1784050072006;
        Tue, 14 Jul 2026 10:27:52 -0700 (PDT)
Received: from lgs.. ([101.76.249.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3643399sm10684428a12.22.2026.07.14.10.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 10:27:51 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Wang Shuaiwei <wangshuaiwei1@xiaomi.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH v2] scsi: ufs: core: cancel RTC work in active-active suspend
Date: Wed, 15 Jul 2026 01:27:26 +0800
Message-ID: <20260714172726.1736967-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

UFS RTC support schedules ufs_rtc_update_work to periodically update the
device RTC. The work can issue query commands and access the UFS host
controller.

A previous change moved the RTC work cancellation before the PRE_CHANGE
vendor suspend callback to close a race in the common suspend path.
However, the active-active path jumps directly to vops_suspend after
flushing exception handling work and therefore bypasses the
cancellation.

If the RTC work runs while the vendor suspend callback is gating or
otherwise changing hardware state, it can access the controller during
suspend and trigger an SError.

Cancel the RTC work before entering the vendor suspend callback in the
active-active path. Since this path now cancels the work, move the RTC
work scheduling outside the device and link state restoration block in
the resume path. This restarts RTC updates after an active-active
suspend and resume cycle.

Fixes: b0bd84c39289 ("scsi: ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v2:
  - Correct the Fixes tag.
  - Restart the RTC update work from the common resume path.

 drivers/ufs/core/ufshcd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d3044a3089b5..c3b105b2678e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10269,6 +10269,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
 		ufshcd_disable_auto_bkops(hba);
 		flush_work(&hba->eeh_work);
+		cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 		goto vops_suspend;
 	}
 
@@ -10478,10 +10479,11 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		if (ret)
 			goto set_old_link_state;
 		ufshcd_set_timestamp_attr(hba);
-		schedule_delayed_work(&hba->ufs_rtc_update_work,
-				      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
 	}
 
+	schedule_delayed_work(&hba->ufs_rtc_update_work,
+			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
+
 	if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
 		ufshcd_enable_auto_bkops(hba);
 	else
-- 
2.43.0

