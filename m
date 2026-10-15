Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618DA4718D3
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 07:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792049196; cv=none; b=EHLU/IcKv/p+MjKndrWXegZX39gZvuFnIPZGCRT+8ybfl6EgzwEh3+RE98RmTW4irjvp7SWy9Dd05bV1o6bcITCfoI/+FBMzgO0GD4j8dJxWI7MynRDtncPzNbf4yyL2pATcdvn0A5x36fGUu3soiDCzTV8Bb6zO7rK/NDvZwYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792049196; c=relaxed/simple;
	bh=cGUUH63o5s/1u2PafCjlXAA/0SaXTgwRF1yp66SvIyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5+OUBKEqKF+a4tGgComZ3j5CBI5oOPLCmVNa390hNQF3qVGU0lcGU6YnEjhe4EESppGmVVCb3+x9rKf8wT8sz1As/L+42t6lq2J+Au8IerT9LNlvvDgeDBxzECuhBeUq7+FZUUZd0Y2G8FjbvKHHu5vSX93NmXv6QGsgsvnwVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=NHxodhlB; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="NHxodhlB"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3a8adb68d8bso3571464a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792049187; x=1792653987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uh0z9KlLSWC0E5K2v3qq0IG5YnWBPRtiWrGTJuWPQy0=;
        b=NHxodhlB1HvZ0n/CxK9q+DvGYkzZmdxHjxBOal3jx1asBcQ7rB4/ap4f6ag4I2/xGe
         gLWai+1WDW5n1/E7KEUC2HK3AIg8AqZEGRNRJ2EjklETKv0yKdtzOPxeN1O/cLXuMceZ
         /rHaHPsVux9MxJPWCqASWA7Nk61yNBnqGXyGVo5bt/kM436mhirZLj3ZXbbtBVyZ/92u
         8h0l7BvOzEGbTBoAKjhzxLsYa7PqXOVpI517Fdk3GIwfSPZkSF0QQWfQ4XD0AvxKSn84
         q22S5f7vHz5GyaJWJgu/BLGgvK+orB5rPoBJMW0rT6oOflts/mK/kwViOjaOy3H7VBMj
         Upug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792049187; x=1792653987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uh0z9KlLSWC0E5K2v3qq0IG5YnWBPRtiWrGTJuWPQy0=;
        b=McJY4QaTRb2Dh7M/qn6hgEAEVjDDUE19zsUE05D1b0dYGRZnwhkpjG1tkPIei5oTk3
         J8/0rJc1GyXV5oQ7HNG6zh+Basw5cHCeCWEq0v4B3aIHOF8ddLZh2YNocczVEpaxVrKP
         mNxx8tKOEOT38euRMWVWKSQeHrOt0/qNy/+WKj+MAfi8elVykmT0F0xFSvxBUR6QzULz
         cs9LZAOxCl9FyPJ2YNghlD12NmDzRGsYVRTH3c+O7I/L/I0XxV0uaWsOsQjXTD8FqSog
         G068s5aRbrFso1i7pfgoIdczsZtC/jAhrsGBa0lkDB6M8eaxrXDt4g4NvOzLTuDXBBa6
         i5Hw==
X-Gm-Message-State: AFq9FYKeNoi99K9iSTYhZjIYuRIgJ4gM1pperLK9+CHAygTgA9yYK1Ls
	E/EYjpX6FUKHEwo3Vi4TOr8+C/G1THDZZIDTk7QoV1+0fosyPtvTZgqtkg3/WIZoqOk=
X-Gm-Gg: AYBFou1E72nnewjRACpAkWZHWdM9VdyzEx4rh4hX6AvsOpknOoojJOcjmliTks1yf4i
	EERcrAjUHpUh+xJEuYi1Pt3Ts75YdIIA6Z0J5CtuVEUxM8wyPl7/txiy9nd8OVN8G2ej3aQlhxL
	eD224ms3qgU2Dj/p+pSpnFeI/PxgQ4uO4PXJMhNrTmJd6XxktBdcJdrpnc+m3jgIltoj/aMqfdm
	JmkrBmPTL66Zw1vlmTsY9Vf5aTnnnvWYZ8z3LSfHN03gf2tGNjMrCAtWUsEN502kP39a3S/wzTk
	kjdA600/KfFjjFM4WiHlgkkdK9EaujBLpFClLueiFfHwyA4rMD6j8PFnKErB/cDyU8FawIwCY7/
	wwmWrAu9nEkrgdS8IT4Ed1l9OERkqUG4U4LTE6rPvk4X7lxqxIk/2ihITfhsP7FXYCJqjg0zgx4
	GFb5TrZhFOfOMnRY0ipFb3pkddeNpugdnh7LFQun6o0UgPYb9b2LnE/Mr/I9+0z+6CF51PR7ISH
	Eh4pw==
X-Received: by 2002:a17:90b:4d08:b0:3ac:8fff:5a1b with SMTP id 98e67ed59e1d1-3ac8fff5fefmr2498686a91.34.1792049187499;
        Thu, 15 Oct 2026 00:26:27 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac937c4e7asm1754279a91.3.2026.10.15.00.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 00:26:27 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 2/3] scsi: aic94xx: validate the EDB index in asd_get_response_tasklet()
Date: Thu, 15 Oct 2026 16:26:11 +0900
Message-ID: <20261015072612.4144043-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
References: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

asd_get_response_tasklet() takes the empty data buffer index out of the
done list status block the sequencer wrote, with the same arithmetic
escb_tasklet_complete() uses on its own copy:

	int  edb_id = ((resp_sb->flags & 0x70) >> 4)-1;

The extracted field is three bits, so the subtraction yields -1 through
6, and the function indexes seq->edb_arr[] with it without looking:

	edb = asd_ha->seq.edb_arr[edb_id + escb->edb_index];
	r = edb->vaddr;

asd_assign_edbs2escbs() gives the first ESCB edb_index 0, so for that one
edb_id == -1 reads seq->edb_arr[-1], one pointer before the kmalloc'd
array, and the next line dereferences it. asd_invalidate_edb() at the end
of the function would index escb->eb[] and seq->edb_arr[] with the same
value.

Reject an index outside [0, ASD_EDBS_PER_SCB) and return, the way the
lookup failure just above it already returns. That check stays as it is;
this is about the other value taken from the same status block.

The preceding patch added the missing return to the check
escb_tasklet_complete() already had. This is that check in a function
that never had one. It is written against ASD_EDBS_PER_SCB rather than
the literal 6 that function uses, because the constant is what sizes
escb->eb[] and, through asd_assign_edbs2escbs(), the stride within
seq->edb_arr[]; the existing condition is left alone.

Whether the sequencer can really report zero in that field is not
something the tree answers. It is firmware loaded with
request_firmware(), status_block[] is an opaque four bytes in
aic94xx_sas.h whose layout is described only by a struct declared locally
in this function and again in aic94xx_tmf.c, and there is no
Documentation/ file or MAINTAINERS entry for this driver. This is not a
claim of a reachable out-of-bounds access. It makes the driver consistent
with itself: asd_bytes_dmaed_tasklet() in aic94xx_scb.c clamps a
device-supplied length,

	size = min(size, (u16) sizeof(phy->frame_rcvd));

a few lines after indexing seq->edb_arr[] with a device-supplied
index and no bound of its own.

As with the preceding patch, a response dropped here leaves its ESCB
uninvalidated and so not reposted, since the repost happens inside
asd_invalidate_edb(). The alternative is to index the array with a value
the driver cannot place.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/aic94xx/aic94xx_task.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index b26a468ddc981..35cf61f541d1b 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -169,6 +169,12 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 		return;
 	}
 
+	if (edb_id < 0 || edb_id >= ASD_EDBS_PER_SCB) {
+		ASD_DPRINTK("edb_id is %d! resp_sb->flags is 0x%x\n",
+			    edb_id, resp_sb->flags);
+		return;
+	}
+
 	ts->buf_valid_size = 0;
 	edb = asd_ha->seq.edb_arr[edb_id + escb->edb_index];
 	r = edb->vaddr;
-- 
2.43.0

