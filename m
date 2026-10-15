Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200DF36F8EF
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031273; cv=none; b=YfRSj7k+XNkWFTAC95MGCqI749btyOfJp8rzHN9AtrB8RY00ozkAOYH1t/a7ZFVXLbe5KpBfdC9KPlZ+TpH+lKAGGgLRKc4YG7EhaL4O2nuub+TUo5YD4Mq9+f9WHGdiAByyK9r43/jbaeop3iZ5v1UeFp2l/6Q5+E6aoPlpH8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031273; c=relaxed/simple;
	bh=A9dZqNlJD9WYs+GSLH29AUnwq+8L5IzDDOZ0LYgLQg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTw5EgNIMd4PQ0AY5v/rNXgtho2oc1zs3mNRKqxpF1TFngzuttnWWQ604d71O+toyKZkScnxtxHZSvjRJKZNOF30F/4ejsQsLogwuNDTqvbbVqrUVIRla3eUYKRJT7pn9m9kKRd029OPF9kV5kbCIq6XmZrLu/NXSb2+Sbt/b0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=NzL24OO8; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="NzL24OO8"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-398a5aad413so754848a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 19:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792031271; x=1792636071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qB5u2eAth6kclTEDr0WUXrH+pdbrWwKcjOH4XM8d050=;
        b=NzL24OO8emW12kmHzjg6k0YfSYCndAilvAThXG8JgdEpTkVfeMOhRIyOXFxka/fEsc
         M2F1lpUwZmc8LQIX0ui4s39WpCMRgwBb06OBIxiTadniK7UkuuuYSbS9O1zzUTxkKhRn
         1Bjzo2ghDCj7vwUmDJcozEJVYCaqdlWFdevN0nC/k0671eL76TkI6/I58p+8HIOR0Y/j
         lziLGZtOq//DN5eMNWLLTSo8Wsod1I4gkSYcq1Wa8wmAkuZBNruCALAiaXMt2ZUcmcrv
         cavWrjaVR0YlEXqkh5TKrd592gLuakQmjmpuEDS750nyuW+wTcuC8HXMloWUrLI6TTHT
         0jLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792031271; x=1792636071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qB5u2eAth6kclTEDr0WUXrH+pdbrWwKcjOH4XM8d050=;
        b=UFtKR+5/CpJuSF5eQrrWr7M7LDTbjtzTAxjdf9rj9/EZYsjQLDTqv71ZHJCeEiOaZl
         rDOGx4KMjoKXaU9s72JxAi5+2hvrgE5gblKlpVp8rI8AJXsaT2DoiBcDK7LU7V0uuPuC
         Hs/8ZFqokctk3O450TrE1+3zyxtV0IVT3dcaekPprWIFCky6j6TH5GMy2NYsfm8meTbE
         9QZL7vDapbHzcGJIej1XyehC4rA6qIBVJd01rfJtZ9kd6LUWAjWcqiw3MHQMxXuG7RI8
         B2L3qogEvzhJkHV2T+84nc1li13RprVginXg+p6zcOrPuJdgstmHd4qL9R2GufVMFgZ5
         S17g==
X-Gm-Message-State: AFq9FYIvTO/0mvQoWQIVU60rJTrRc6dpbMCeqhw1E7EJbkmM+wUZ/Ec/
	0HWma4x1jMWJQ201JHeFbHQChiG7zNWPFMmgFOluwWMx1MILDz0IRCMZVqtMs4F+4zY=
X-Gm-Gg: AYBFou2thHB/8u4ho51Awbs5+/gKtTav6sQcEtBF/kOgyD/VjRvQcsKP/4tGdDJQG60
	vd73Ckf/6dIZr4bJR3HbX3IppSbpcJnQ3cDehFxqGjvrKhM4/NvWucgBT2nbUbwaGmQGX7Ug96p
	3hCG+Oj3iH6oBJ0t5kIVO70cs/cVvsMmO+Ac4oBzRUh8dh9YV8t4QEVSJQ3WNrRPEUQittLnMHE
	kv1dsYHG6LXpw3qTQyN/3HHuDMh8IRWAv1ppLmHVA8wZY9oXqKoARL4J+3wfMAp72gBUDeRaYD/
	2E6pekp/shH128dDux2XJgclQX67ljBez1TRSJDqcNMDne/TRp113ToBtQG4VRVU0xT0cHnFW4u
	2GRM8znFfSM4wlz2Dw1i3CVa3BcLCqydnDvwHTeH9sEKevvIqN2pEsRhCluUBPBh0uJgkaFDO+c
	PBmsBLzaJ+8k7lIS6DpxqbbWnzeHPKTwwVn2Vy0jgQxDLimFgjuARXvQ1veCgSB2yJ5qKLlBjmZ
	CSUbQ==
X-Received: by 2002:a17:90a:d006:b0:3aa:fc22:8aac with SMTP id 98e67ed59e1d1-3ab3a9325f8mr15833691a91.51.1792031271477;
        Wed, 14 Oct 2026 19:27:51 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94375f3fsm1997383a91.4.2026.10.14.19.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:27:51 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v8 4/8] scsi: mvumi: walk the hotplug event bitmap a byte at a time
Date: Thu, 15 Oct 2026 11:27:24 +0900
Message-ID: <20261015022728.3936714-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
References: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_proc_msg() casts param->bitmap to unsigned long * and hands it to
find_next_zero_bit().  bitmap sits four bytes into struct
mvumi_hotplug_event, so on a 64-bit host the pointer is four-byte aligned
where the bitmap API expects long alignment.  On an architecture that
traps unaligned loads that faults, and the second bitmap, which starts at
an arbitrary byte offset derived from size, can be misaligned on any host.

Walk the bitmap bytes instead.  The driver reads every other
firmware-supplied field natively, so bit n of the bitmap is already byte
n / 8 bit n % 8 in practice; writing that out keeps the device numbering
this driver has always used, needs no alignment from the buffer, and drops
the long-at-a-time reads the earlier bound had to allow for.  That bound
stays as it is, which is now more conservative than the walk needs.

Fixes: bd756ddea18e ("[SCSI] mvumi: Add support for Marvell SAS/SATA RAID-on-Chip(ROC) 88RC9580")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 9a3dde53dea97..18964e860ac8e 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1653,16 +1653,15 @@ static void mvumi_proc_msg(struct mvumi_hba *mhba,
 					struct mvumi_hotplug_event *param)
 {
 	u16 size = READ_ONCE(param->size);
-	const unsigned long *ar_bitmap;
-	const unsigned long *re_bitmap;
+	const u8 *ar_bitmap;
+	const u8 *re_bitmap;
 	int index;
 
 	/*
-	 * The second bitmap starts size bits into the event buffer and
-	 * find_next_zero_bit() reads it a long at a time, so that is the
-	 * furthest the two scans reach.  Bound it by the length the firmware
-	 * was told it may write, not by the buffer: the bytes past that are
-	 * still zero, and a zero bit here means a device is present.
+	 * The second bitmap starts size bits into the event buffer, so that
+	 * is the furthest the two walks reach.  Bound it by the length the
+	 * firmware was told it may write, not by the buffer: the bytes past
+	 * that are still zero, and a zero bit here means a device is present.
 	 */
 	if (sizeof(*param) + (size >> 3) + BITS_TO_LONGS(size) * sizeof(long) >
 			sizeof(struct mvumi_event_req)) {
@@ -1672,25 +1671,19 @@ static void mvumi_proc_msg(struct mvumi_hba *mhba,
 	}
 
 	if (mhba->fw_flag & MVUMI_FW_ATTACH) {
-		index = -1;
-		ar_bitmap = (const unsigned long *) param->bitmap;
-		re_bitmap = (const unsigned long *) &param->bitmap[size >> 3];
+		ar_bitmap = param->bitmap;
+		re_bitmap = &param->bitmap[size >> 3];
 
 		mutex_lock(&mhba->sas_discovery_mutex);
-		do {
-			index = find_next_zero_bit(ar_bitmap, size, index + 1);
-			if (index >= size)
-				break;
-			mvumi_handle_hotplug(mhba, index, DEVICE_ONLINE);
-		} while (1);
-
-		index = -1;
-		do {
-			index = find_next_zero_bit(re_bitmap, size, index + 1);
-			if (index >= size)
-				break;
-			mvumi_handle_hotplug(mhba, index, DEVICE_OFFLINE);
-		} while (1);
+		for (index = 0; index < size; index++)
+			if (!(ar_bitmap[index >> 3] & (1 << (index & 7))))
+				mvumi_handle_hotplug(mhba, index,
+						     DEVICE_ONLINE);
+
+		for (index = 0; index < size; index++)
+			if (!(re_bitmap[index >> 3] & (1 << (index & 7))))
+				mvumi_handle_hotplug(mhba, index,
+						     DEVICE_OFFLINE);
 		mutex_unlock(&mhba->sas_discovery_mutex);
 	}
 }
-- 
2.43.0

