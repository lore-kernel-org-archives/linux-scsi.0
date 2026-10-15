Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA2849DBB1
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 09:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792055884; cv=none; b=bS3abk5OHs9nQondChEz2s1m/QxSnXWWRLZDw0x7bJ4oxAtzCHsCUw4Lnoxjo56ua03co/gTBPfPbHe9QPpksK1kpiJOo/x1KC3PbENohyUzWzfvMWrY6aQ98TGCNkHc8GLnq/baRQ3kjsWGZepong13QWP2xxDWnsxViVlwcpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792055884; c=relaxed/simple;
	bh=55fngw8U7i276yUTXQntdbIZF4Wd6ep68zhxSVkxCO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gf2udiNQuvko+mBvyR+Bk+tyIV01A8fOvuvaaNbcZgsSNcyVp4HWCyj2VZULGa4erOVJZ1XNQB0nhsX3GovTgeV9g2O1VQK56T34LZHd0MwWlAI90Ftz+L070csUgG4Eoth1MnWWIPnFSFfg8CTHkF7s63vSpuGyxhVD/cowZUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=cNZdEKm0; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="cNZdEKm0"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ab3260b2cdso2253305a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792055883; x=1792660683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i6VprNe7yjepyKxDyWl/GS5n+61wlhCAhAo3qvs5zaA=;
        b=cNZdEKm0Sun4QtQPY3T6MRQmDXVMmXP+97zO2TRkRZBu3w2oS+74+UG/Bako9WhrmU
         bK8Z/4U8ErsAE5QowX0CMokDBSLxU3ee6bC//Nls4gZ+A7ih6IFzcgOVoCjU0JfIGaKb
         bXTi9rlpez/difjkSyiOULzNPu6w7/KzLBy0Cvp/JE+4HX9HviCM5PdPs2XP8XoHngvL
         ZiDjhiwcglrrKFIs9r5kAkykcznd2Gki8oKrbGmu5DFFYkf7VBWfjZLJswufGFqweee6
         q9lcdKs7jyZfa7nxGy8D8z3NLdFryLLgq4Y/5j9CF1Wuo6v8QA4ItIRteKQ87QCUvkVD
         /azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792055883; x=1792660683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i6VprNe7yjepyKxDyWl/GS5n+61wlhCAhAo3qvs5zaA=;
        b=rrZ+U/lu/FCQnXuid7YKh3bHcNbJkcPK5nRVkF748dEANvuMLA+tFSZFRnVD398GiO
         lPl7CnBkKr0Nd8U5+jRZHBgIH5SLqxwSXY+N1spWGcdfSddSBSaW55nWyzSgoDx6ubrS
         NWmbp3rpSp+is1ZCewc3HsMycwJ0zlGY/LcIVQIYTxfEJEocvhImcFKvqYc3uGwnb8CV
         PKwsHeXBi/YGk/wVyLUy7On3nxG1m0E9oMn0Y4vq7KF8ctsE/p1HvzJAcNAbmCBIyXTD
         CUZA50LDApO2orMlh+ZHr7ohuPyvNm+LeT3SiqHb0pNa/sSutwmSdMcO4xmFt86ZFHIH
         aITQ==
X-Gm-Message-State: AFq9FYILZdxRRJC3NIo7Rx1sZ5KuMfMvZXo8ay71XJY6hnSHLU8eBFry
	HrQj1huODwQag9vIIJwOCcyJfN9tuD1jtmIRU7i2G5qQc7QjIB6zBLoSpVpq1MPaYUc=
X-Gm-Gg: AYBFou3yxsvEinDY2lCjsrhZpUhJu2MpHTiEZgwHlIPRPKhI/eH0aZVWIjo0wejMEWk
	JHMM6e7iyZRf6tRWHLsEAo41iIKsn2r9/yrkAEmApGdXvOdbdybYnTuhTttX/JRPA7+LLt1igvA
	U631KSgeyWPQpshanOq0qhG/vvjWNMVyAB2p76q3CGTB5mhtyQDe69MmrU53Irqqo/klDDXLSrD
	i+gOCgP5NDPsqTGBUliEQCmc3sVhUrRM+a5c3E3gZzOVQtE+rd/vaRWlSoNg6cul+xufHq5jvCu
	RoYd+tNsDarlK2muAf7VnnbkG8IPc5msqchgVohR3B3OA86MGTbbaRBmEY8JbFRJt9rKH7eU0jt
	HmW/N3AxhT577LB5NyMmqvVMrxSfVMzzatXZGKoa4ceTP0wYDZWR0gGMgqtWtzFpvrCKdcd9F/2
	FZ4GeTeXOqlAIZOOsrO/W1qa6DXY6lwViBXIKiDDwFBUFJjO567oP8GAqEMkBpM9ITBdgV8JT7i
	DWxBA==
X-Received: by 2002:a17:90b:398c:b0:3ac:9f00:3bb5 with SMTP id 98e67ed59e1d1-3ac9f003c2emr937231a91.38.1792055882973;
        Thu, 15 Oct 2026 02:18:02 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac943e821csm3412408a91.8.2026.10.15.02.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:18:02 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 1/5] scsi: aic94xx: bail out of escb_tasklet_complete() on a bad EDB index
Date: Thu, 15 Oct 2026 18:17:43 +0900
Message-ID: <20261015091747.4184349-2-yhlee@isslab.korea.ac.kr>
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

escb_tasklet_complete() derives the empty data buffer index from the done
list opcode the sequencer wrote:

	int edb = (dl->opcode & DL_PHY_MASK) - 1; /* [0xc1,0xc7] -> [0,6] */

DL_PHY_MASK is 7, so the subtraction yields -1 through 6, and the
function already says that anything outside [0,6] is wrong:

	if (edb > 6 || edb < 0) {
		ASD_DPRINTK("edb is 0x%x! dl->opcode is 0x%x\n", ...);
		...
	}

The block reports the problem and then falls through to let it happen.
edb is used twice afterwards: asd_bytes_dmaed_tasklet() adds
ascb->edb_index to it to index seq->edb_arr[], and the out: label at the
end of the function hands the same value to asd_invalidate_edb(), which
indexes both escb->eb[] and seq->edb_arr[]. asd_assign_edbs2escbs() gives
the first ESCB edb_index 0, so for that one edb == -1 reads
seq->edb_arr[-1], one pointer before the array, and dereferences whatever
it finds.

Finish the check the way it reads: return instead of falling through.

Whether the sequencer can really report an opcode that makes this zero is
not something the tree answers. It is firmware loaded with
request_firmware(), the done list opcode is described only by the comment
above, and there is no Documentation/ file and no MAINTAINERS entry for
this driver. This is not a claim of a reachable out-of-bounds access,
only that the driver goes on to index an array with a value it has just
decided is invalid. The intent to bound what the sequencer supplies is
already in the same file, in asd_bytes_dmaed_tasklet():

	size = min(size, (u16) sizeof(phy->frame_rcvd));

which clamps a device-supplied length a few lines after indexing
seq->edb_arr[] with a device-supplied index and no bound.

One consequence worth naming: an ESCB dropped this way is not invalidated
and so is not reposted to the sequencer, because the repost happens
inside asd_invalidate_edb(). That takes one empty buffer out of
circulation per malformed opcode. It is the lesser of the two, and
recovering the ESCB instead would mean choosing some other buffer to
invalidate, which this index cannot tell us.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/aic94xx/aic94xx_scb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 08c8dad9ad621..d050e5325b943 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -421,6 +421,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 			    le64_to_cpu(ascb->scb->header.next_scb),
 			    le16_to_cpu(ascb->scb->header.index),
 			    ascb->scb->header.opcode);
+		return;
 	}
 
 	/* Catch these before we mask off the sb_opcode bits */
-- 
2.43.0

