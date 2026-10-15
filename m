Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C6B4FC329
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792055895; cv=none; b=m7nh8+ZwoPEIdGxNGMJtxOexAsptdjYsyBJ4aLdAcwBEoo+7g4Kyf/b0rME9zC2jURZUCMkObyZx4Dje+gDfgvBteXHuDWVk78HjD6ThjigF4jbVrXwEAZeog6eyKlKwh0JZntgT5wsES9qItXM1LQOGZb+Uhn8FX9GoLoc58p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792055895; c=relaxed/simple;
	bh=ugWuCtrEQC0vxyuWPSfQu7GnfazNqdWELj9G5aX8bcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRQalFCEwU7y+GdWr8myVjEXymLh3h3gLLIm68yvkeHXi/dEiLJphZN08xSPW6EW3vhZD1itdOaIwQ2SboYDzT+oYh1xqFA5WFmshmteUyGbSWkEDo/sHF4K3ks5+RGfVDaB9ZE+IucbFDPVE491mu1KsrBrvu0WszTGNAtq/Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=k9i/6T0p; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="k9i/6T0p"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ab98332238so2846411a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792055893; x=1792660693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ljLnSjqF2Nc7+ZmdD8FWQqLarCoKAOUufd8P3m6PY0E=;
        b=k9i/6T0pzWbGPKCkQTXFDtFtU1XfJUDCsG/TxG9S7TNZkH+1VLE0KBjwLaUW8CF/mK
         SI3osZ61yyL3qybxaNRxW8I6hh4YZZ2rJ/RrmsqTLQN5DbFNrluLy0yJpChxucGSGwtN
         /8ynSrI5mKXbmhSa/zOvc0/07zr+oHaNPZklf1G7j9WJm6HMd15TX5sIhiOl0+AWbzNL
         jbmzWTPVYh4YzSpTilN0hJrp73pk7YTPTJBmRKauwsWTEpMFIQ+JOYpEpzDY5TuJlfqd
         GAVxs1mR77r0K4cix+eAJIvUJXuPtTxDxtFA12YC926ZvQSNqU7qo+RRu4jHI3A/1Jc7
         2lmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792055893; x=1792660693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ljLnSjqF2Nc7+ZmdD8FWQqLarCoKAOUufd8P3m6PY0E=;
        b=fL01mPVLIRSLMjG3jLTusy0PRSwkphOiU8l+rfxkGMObldI4/je8Xk+dlMXizXUd/5
         IQLX0D07we6ecqM/ZoaUhfHPV1CR96Q90RYUvCyNVtvbflq5tcrCF19fb58BhQncr46g
         QI9yhwEE7LmnfeRbAoy0F3Z45F+pcTyjmK9dHyxMXRDtngFEL2rVjsqvAKqzF+n7Mkss
         5eqXirCXjqukfAnqJQnRtc6ltBok3J3dh3OHEnU+91+VDKD18ZY98qvUBMS+wcxsZLmk
         /naCRrG5pkpiAU+LoOCeYd8aJOLyLHiIDNDa8e6dgG2peIoza+ZwZqLMXPGf5ND5y5AN
         xB+A==
X-Gm-Message-State: AFq9FYKMiKhgx6WDWV9Hf1Z72oGmr+494OUI/RlqNpIgQLvRncTwmI2k
	LQt1yFRBth6OZw/hiegskMfZF/LRROS7878stfCNbF45aXIy4J7Jt8xlIYoPo3XWeA/3rVTTWB2
	IZAZM
X-Gm-Gg: AYBFou2LjuV5EXeOLSvju2Wwa5DIWWUYYCNd5TfANsSp/8NqMzReaIZDkdemo+f3vOV
	uYCFRpkiCJMW3mqtUbi0Muqnsozpmg0qr8sqXi9D6Uf72lUvrkDCofLz/fKqagZcsOTQj34T3xM
	1RYqNiwSodtS6CLdpDLz3v6aKdgtT0XtjDemTmV0Yfab5kt81N1UcGjnbjzHpBJyaRvmElUV5Id
	m/OZgAtTpPzVFHMAVWOjz9ZJK4ua4R5gABdSygCuLNDAkWnn8sYgkvPlDxoiodvyy1h4CDi10/X
	gXMtBu+Xd9N4y3Of5xnS1SF+TtONMfnBaN83NvCTR25z09t/hub8umYbWYR4sI9W+tIng6bLHjf
	6mij2w9wD65hLdaWSieZ21w/ZumlyjuNlXLk0pA4pm/wvuEcaMScG5oj+Kf8D61NInR7rVNE1n+
	UfTCnZA41ulHItENs0hwv1dfJD4dwvKrx3Eekgdoq/Jj58PI1D2MDn9Nj7CCWheMAhvrDrTSfms
	ptmbA==
X-Received: by 2002:a17:90b:1dcb:b0:3a4:fa1a:2b1d with SMTP id 98e67ed59e1d1-3ab3b028c7emr14927131a91.62.1792055893242;
        Thu, 15 Oct 2026 02:18:13 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac943e821csm3412408a91.8.2026.10.15.02.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:18:12 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 5/5] scsi: aic94xx: check that an ESCB lookup returned an ESCB
Date: Thu, 15 Oct 2026 18:17:47 +0900
Message-ID: <20261015091747.4184349-6-yhlee@isslab.korea.ac.kr>
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

asd_get_response_tasklet() and asd_get_tmf_resp_tasklet() look an Empty
SCB up by the index_escb field of the done list status block and then use
it as one:

	escb = asd_tc_index_find(&asd_ha->seq,
				 (int)le16_to_cpu(resp_sb->index_escb));
	...
	edb = asd_ha->seq.edb_arr[edb_id + escb->edb_index];
	...
	asd_invalidate_edb(escb, edb_id);

Nothing checks that what came back is an Empty SCB. There is one index
space for every aSCB the driver allocates -- asd_ascb_alloc() is the only
caller of asd_tc_index_get() -- so an in-range index can just as well
name a live task, a control phy SCB or an internal command.

That matters because struct scb is a union, and asd_invalidate_edb()
reads its escb member without looking at the opcode:

	struct empty_scb *escb = &ascb->scb->escb;
	struct sg_el     *eb   = &escb->eb[edb_id];
	...
	eb->flags |= ELEMENT_NOT_VALID;
	escb->num_valid--;

On an SCB that is not an Empty SCB those two stores land in whichever
union member it really is -- for an initiate_ssp_task that region holds
the SSP frame header and the scatter-gather elements of a command that is
still in flight.

Check the opcode, the way asd_dl_tasklet_handler() already does when it
decides whether a done list entry belongs to an Empty SCB:

	} else if (ascb->scb->header.opcode == EMPTY_SCB) {

Do it inside the critical section that already holds tc_index_lock for
the lookup, and clear escb on a mismatch so that the existing "no escb
for this dl" path handles it. Reading the opcode after the unlock would
be reading an aSCB the lookup no longer pins: asd_ascb_free() clears the
array slot under tc_index_lock and only then calls dma_pool_free() on
ascb->dma_scb.vaddr, which is ascb->scb, and kmem_cache_free() on the
aSCB itself. So a slot seen non-NULL while the lock is held belongs to an
aSCB whose free has not reached its own critical section yet, and the
opcode is safe to read; the same read after the unlock is not.
asd_tc_index_find() is documented as needing that lock anyway.

Empty SCBs themselves are not freed while the adapter is up --
asd_free_escbs() runs from the teardown path -- so this only concerns an
index that names something other than an ESCB, which is the case the
check is for.

Both callers already bail on a NULL lookup, so neither needs a new exit:
asd_get_response_tasklet() reports SAS_INTERRUPTED there as of the
earlier patch in this series, and asd_get_tmf_resp_tasklet() returns the
TMF_RESP_FUNC_FAILED that res already holds. The non-ESCB case shares
that diagnostic rather than adding one.

This is not a claim of a reachable type confusion. The index originates
with the driver and the sequencer echoes it back, and whether it can echo
a different one is not something the tree answers. The check is cheap and
the idiom is already in the driver.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/aic94xx/aic94xx_task.c | 2 ++
 drivers/scsi/aic94xx/aic94xx_tmf.c  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index bb5094ca5de15..00addeef1230a 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -162,6 +162,8 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 	spin_lock_irqsave(&asd_ha->seq.tc_index_lock, flags);
 	escb = asd_tc_index_find(&asd_ha->seq,
 				 (int)le16_to_cpu(resp_sb->index_escb));
+	if (escb && escb->scb->header.opcode != EMPTY_SCB)
+		escb = NULL;	  /* the index landed on something else */
 	spin_unlock_irqrestore(&asd_ha->seq.tc_index_lock, flags);
 
 	if (!escb) {
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 1ee6009d83051..c05446d66b7bb 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -275,6 +275,8 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
 	spin_lock_irqsave(&asd_ha->seq.tc_index_lock, flags);
 	escb = asd_tc_index_find(&asd_ha->seq,
 				 (int)le16_to_cpu(resp_sb->index_escb));
+	if (escb && escb->scb->header.opcode != EMPTY_SCB)
+		escb = NULL;	  /* the index landed on something else */
 	spin_unlock_irqrestore(&asd_ha->seq.tc_index_lock, flags);
 
 	if (!escb) {
-- 
2.43.0

