Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8784F5DE8
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 09:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792055892; cv=none; b=MlQ/mhb9kjO3w5OECvxgEbPtDcES2XWFcG+T93lq1dbdP+6sVCPL+8DX4vhvtIzXKXcluKgJiykDzOUSFMoYd0N31BxW+BgY3g36URFO2Dqi8YV9dEhu20qbDZhPKZypD1vuHfPXai6Lg2srnpaW4v6YVN0G8stZ941Nrtb5DTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792055892; c=relaxed/simple;
	bh=jPr6aHaLpG8Cv9vSXXtGXXrD3GWFGv3J7yyXdkKzLjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdFKOTm32bv+ZsylQoa5QxcHbnOtOrROmy/aRcNp1uE3ksVHdsA+GM4FbAKlEQjejrsFbdhMl2RDknc3q9TmrcVFpylTuOs3Arq/SFSd1yHGDXGAFCrA0Ws3r+P8rGCnEnnuP39G9LUYdk9OjViRGZCQv+DhJ/p5zyhEadgXBzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=KRvTqxrq; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="KRvTqxrq"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso2069512a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792055891; x=1792660691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qvbV2vy5EWHtCEzvAlTZKYV1AJ/f2e538Rv/grJak3I=;
        b=KRvTqxrqa0fhAOcX8Ka6qFo77GkglV4mwL3QJnSiPE906tL8QEfYm/Z+D0yc3/6hFH
         B+IOIqnmmjHA6Ff+Ab3DrRM4aTh2m6eoS0xLJrRS5Pcnoq8aRHSiM6PMaNM917OWpzza
         1P7RJYoGS1unuAuV9mhlb+y4tofRWP69mkgZxWOG0OdnQMikw9wbmSC+afuLBzDUx/sb
         p9n9npJxDaPC1PdhizMVIaHVFtTGgGKz+knAkGvNgES4cAKR0uG8gK+WTGnbpUEw1I4P
         56xAh7bE8OtuDcbTF2psT9kLF4K/yE2/PDwJHvm78Z9US9cWJnt3UK0KNB94KalMicRz
         yM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792055891; x=1792660691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qvbV2vy5EWHtCEzvAlTZKYV1AJ/f2e538Rv/grJak3I=;
        b=YmF5+0aN1OmNGixeNH7OCurSPkKrKcVua28vXG9krad1eO6uBU8nebkbY6/zD8WQ2m
         T0YlvuVIRbdAwp2UM9gTA0rXm8BLrPWsnV9ctqZH0gmT61CWdEwJ/XmJMQWAKjWflPFx
         L3xRXa06+t9K/LtyC6xgmaHUJklLyMAoGOi4p5PmXYRv3A6mdcSzzW8jfWQNBBOcqyb6
         5ZKbXMIRF9iWRewLDK96vLMLryHMPm52a0dMsCpXObyfoiVLvDPzlBkw/C4Dk00BI+Y6
         xfESLqva/fpLaB1c5yFvKITF6qzT7bj1ea5GlXGcDet6I06GnPjZtRHzMXzuRRD5lfnt
         iT0w==
X-Gm-Message-State: AFq9FYIt1Xv1/RHHjNjxfUUex1W8vUDdm7XpIKs8JtjU7EL4pv6nljjJ
	FS/ITIiRJ5laG+zIJT/MF9dYcDZpT7kh0lhoTBvnWbWDGB4kvMAg9tbOlwrski6wTIA=
X-Gm-Gg: AYBFou1YGwT+NXk3RzGslZFBimIrZJ0NT6vR7Dm31cU9tIfyR6iT/sXquonXJtt+YqR
	xSXzPdV+uNE48dtNiZraISiQTpYPomlfE6cooiP4pvHoAKwDZdEKvdS2mPYhjb2TBx0UOClwShP
	y+m4shN6/rWlOlVvDrox3R+C+hbl2CaNzjTEO3+6GqXr1IXbbw/2a7zqb80ehN8oGNACngmCF2w
	jZmeQx3NCIC0oUAjmGEwulnq/ufytDZ6LsskRTXDEYxWeTKBw2bnvBmz+7L/Qs4goNUbpW6AsFe
	zldA9gQoBoi4j8hG8BY0QHj3iqzkA4iuixUAKl0YchO11sDZ647D78zTNeXPdIfFwLZY0oVaH6F
	vp2aaIrjTlZQleKPz3YrJH8oAB5z4zQACIdnAA7bFBI3VqWgf85SODngVIE1UnocB4bXm1ENahi
	DgxE7Fpic+FKa1cZDsceTgqVwBl1gB0RalAWh4OqGv69EC9dc/2VTHzNglgjB/kVe1J1UKk6zu8
	aqMcQ==
X-Received: by 2002:a17:90b:574c:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3ac83c10467mr2921470a91.64.1792055890770;
        Thu, 15 Oct 2026 02:18:10 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac943e821csm3412408a91.8.2026.10.15.02.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:18:10 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 4/5] scsi: aic94xx: bound the transaction context index from the sequencer
Date: Thu, 15 Oct 2026 18:17:46 +0900
Message-ID: <20261015091747.4184349-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015091747.4184349-1-yhlee@isslab.korea.ac.kr>
References: <20261015091747.4184349-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every aSCB the driver allocates takes a slot in one shared index array,
and the driver tells the sequencer which slot it used:

	/* asd_ascb_alloc() */
	ascb->tc_index = asd_tc_index_get(seq, ascb);
	...
	ascb->scb->header.index = cpu_to_le16((u16)ascb->tc_index);

The sequencer hands that number back in the done list, and the driver
looks the aSCB up again with it in three places: asd_dl_tasklet_handler()
uses dl->index, and asd_get_response_tasklet() and
asd_get_tmf_resp_tasklet() use the index_escb field of the status block.
All three go through

	static inline void *asd_tc_index_find(struct asd_seq_data *seq, int index)
	{
		return seq->tc_index_array[index];
	}

which does not look at index at all.

The array is kcalloc()ed with tc_index_bitmap_bits entries, which is
hw_prof.max_scbs, which is asd_get_cmdctx_size() divided by sizeof(struct
scb). The two values asd_get_cmdctx_size() can return are 32768 and
65536, and struct scb starts with an 11-byte scb_header, so max_scbs
cannot exceed 5957. Both numbers the sequencer supplies are __le16, so
either one can name a slot past the end of the array, and the pointer
read from there is then dereferenced.

Check the index where it is used. The three callers already handle a NULL
return -- "Uh-oh! No escb for this dl?!" in the two status block paths
and "BUG:sequencer:dl:no ascb?!" in the done list handler -- so none of
them needs to change.

This is not a claim of a reachable out-of-bounds access: the index
originates with the driver and comes back echoed, and whether the
sequencer can echo something else is not something the tree answers,
since it is firmware loaded with request_firmware() and there is no
Documentation/ file or MAINTAINERS entry for this driver. It is a bound
on a number that arrives from outside, in the one place all three users
share.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/aic94xx/aic94xx_hwi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
index 930e192b1cd41..841769a8130a9 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -306,6 +306,8 @@ static inline int asd_tc_index_get(struct asd_seq_data *seq, void *ptr)
  */
 static inline void *asd_tc_index_find(struct asd_seq_data *seq, int index)
 {
+	if (index < 0 || index >= seq->tc_index_bitmap_bits)
+		return NULL;
 	return seq->tc_index_array[index];
 }
 
-- 
2.43.0

