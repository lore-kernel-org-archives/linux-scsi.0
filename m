Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B684C9E12
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 08:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792052397; cv=none; b=rFm9ifc7svbUGPlrOIGU6p0U3FrbHCjydQs8XYbwbzV5cUptuJnbHzI6pyNvTDxiJg5IaF3hDA/2blj985F0qvQPnwtxIuq9lQoXz6k0F1LxORvVxjCAm4jkTW2+hINuGuFRmVkbJljzdz70z8tkQY4h2NuP0hDodSabTxu0AYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792052397; c=relaxed/simple;
	bh=uslEExDEGp6pVGpAloBoNX7J+MmR0/ayHNO1yyTZjEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmybaSq/BCId/GIpBTmEsrtkzyDC+EC69+ZrtfyjK4QiJKwAfHFbsgj3KdTQoAKvreHWV9r1xvifzevM/8kiGU0lIoq6yPKqEcy87C8hb+z0qK6bc2Ato/C80DwWCdLyyuerJRhy3a1qSFyHc5y/WhZWUfAA/Vfw3B7CKP0VdHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=HtzPVSzk; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="HtzPVSzk"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3a0aaa0fd13so3678396a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 01:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792052393; x=1792657193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E2BxYeiKObMcw2aJTTx5HIivwKcuO9GkYsdXsOu0i4Q=;
        b=HtzPVSzkSnKkmb1L8rmMrRmR9z3OVbcEsyPo5nVuKEpwiB8D7xNE/MPlKXejdfmSP7
         cXVuHNiaUHIXvfwbvRI5kebrFayWvmFSHG8hFLJmJMnbQHAXiKAp7yMIa6mTa/j38TJV
         SfECgKkwoortZKvRF1ToAmyJDRvwHNRn1QjEXsknxXkZX11X9Xj83zx8E5XyvD4/ezKE
         xXf7i5CJHz445U6z16K1cb0J1D/ofio2NDsvkOWM6borpnaDwwGlbLsaX7EopvDWynIk
         PITf0DkYOGlxUrt6ie/x072ZG4j0HlMUjY4n0fJk2OQLesn0nEIvVgpET8mHx1xHp9EG
         e9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792052393; x=1792657193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E2BxYeiKObMcw2aJTTx5HIivwKcuO9GkYsdXsOu0i4Q=;
        b=XEue/3nRNnkY3g69oEG/YKI5tdxKo9GhzDNogkpr/m3BTj46p9/ZSWix914206kS/B
         Q5/thtj2lhPV6t4v8joYFnqp0asPDRbolXManGvf92WNiHMLmWZtlatEs7WlLl72aBT5
         qjp9zU5NM2AqKwNLWmr4SDdry84ZY62ZYy54o+GVpgYUU/KB0AWwdHpn6ao9NQzz2rRb
         mPlYajCv0h6uMl+AXptBXfiYybi8OHlZTTeV8PYxEh2UEcxE53gtm/VAUiktFKhhLz4O
         aIye8WysSKKYa9Cu6yu1NLkOmSvba3blVOYDiH/3r9zz7nusr0a07t5lNeqmnkyvtX4K
         aVPA==
X-Gm-Message-State: AFq9FYKJ9fOMK21X3quONUz2B5hTOtSjKWjMbqyQc/8sh41Mbc1DahNT
	UX/AABv1lOc0Kb8yQD4y0jjGv9bMtEfj2czy79zwsglGI/GoO0i8Fbeq2ecVlRIiM1Y=
X-Gm-Gg: AYBFou37L30npXZrO6ALDPSwzOwFsQe8Q1u/fu7qvm7KX1qNG7HHctNYF6CP1gssbGT
	h41TNuai49TGEltuEY2xlQXkMqS42hoOUZfavQW04Wi1R6VOP4OIxfsbjB+heZHbczLvi7x7UEh
	MgbGDCeZal1N92ot1skYSRZrHZOeLUi/KpjvToSqzCCnTpp7s7Nwi63eS8v5nu0xgGAWjaRmxsN
	QWJWzHchNSzRdB9Psbh1c/mZWttjgbHFTsIxGkqdua8kkbAAemgGPagO+M8ElzxL+IuWlPfQETd
	PAd0/AvYnADDkp6vdT6dukvFmmB75IJ9M/ZXtXe2+5RMH6s6HRMby7H4aLalO2O0scuO3IW+xmz
	nzak/m0uJ9Vx3z+ShJO0yvcQdHNRPMPKdVrqk2n+2977eM7L566Ct+/ZP6fs2uuhWy99ldUKWnV
	H95bNjzNYtZrYs0ocf7OWUJDbxfMb2DK1isI3drEY/IPTBe+kcfeqT6f60xULNsugL3utNFWx9u
	KTLIg==
X-Received: by 2002:a17:90b:4d88:b0:3a4:a850:6982 with SMTP id 98e67ed59e1d1-3ab3a7786e4mr16481456a91.26.1792052393278;
        Thu, 15 Oct 2026 01:19:53 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac943e755bsm3319784a91.2.2026.10.15.01.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 01:19:53 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 2/5] scsi: aic94xx: validate the EDB index in asd_get_response_tasklet()
Date: Thu, 15 Oct 2026 17:19:31 +0900
Message-ID: <20261015081935.4168771-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>
References: <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>
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

Reject an index outside [0, ASD_EDBS_PER_SCB) and return, and set
ts->stat on the way out, because returning without touching it reports
the command as a success.

asd_task_tasklet_complete() sets ts->resp and ts->stat before it calls
this function:

	case TC_SSP_RESP:
	case TC_ATA_RESP:
		ts->resp = SAS_TASK_COMPLETE;
		ts->stat = SAS_PROTO_RESPONSE;
		asd_get_response_tasklet(ascb, dl);

SAS_PROTO_RESPONSE is a promise that this function will go on to put the
real status there, from the response IU for SSP or the ending FIS for
STP. Returning early breaks that promise and leaves the promise in place.
For SSP, sas_end_task() starts from DID_OK and SAS_SAM_STAT_GOOD, and its
SAS_PROTO_RESPONSE case only prints a notice, so the command completes as
a success. For STP, sas_ata_task_done() takes SAS_PROTO_RESPONSE as "the
ending FIS has the status" and copies ATA_RESP_FIS_SIZE out of ts->buf,
which this function never filled, then derives err_mask from it.

So the bail reports SAS_INTERRUPTED, which is what this driver already
uses for a response that arrived but could not be used -- TI_BREAK,
TI_PROTO_ERR, TI_NAK, TI_ACK_NAK_TO, TF_SMP_XMIT_RCV_ERR and
TC_ATA_R_ERR_RECV all map to it. sas_end_task() turns it into
DID_NO_CONNECT, and sas_to_ata_err() into AC_ERR_ATA_BUS, so neither path
mistakes it for a completed command.

The lookup failure above it had the same problem and gets the same line.
Nothing changes on the path where the index is in range.

Whether the sequencer can really report zero in that field is not
something the tree answers. It is firmware loaded with
request_firmware(), status_block[] is an opaque four bytes in
aic94xx_sas.h whose layout is described only by a struct declared locally
in this function and again in aic94xx_tmf.c, and there is no
Documentation/ file or MAINTAINERS entry for this driver. This is not a
claim of a reachable out-of-bounds access. It makes the driver consistent
with itself: asd_bytes_dmaed_tasklet() in aic94xx_scb.c clamps a
device-supplied length a few lines after indexing seq->edb_arr[] with a
device-supplied index and no bound of its own.

As with the preceding patch, a response dropped here leaves its ESCB
uninvalidated and so not reposted, since the repost happens inside
asd_invalidate_edb(). The alternative is to index the array with a value
the driver cannot place.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/aic94xx/aic94xx_task.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index b26a468ddc981..bb5094ca5de15 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -166,6 +166,14 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 
 	if (!escb) {
 		ASD_DPRINTK("Uh-oh! No escb for this dl?!\n");
+		ts->stat = SAS_INTERRUPTED;
+		return;
+	}
+
+	if (edb_id < 0 || edb_id >= ASD_EDBS_PER_SCB) {
+		ASD_DPRINTK("edb_id is %d! resp_sb->flags is 0x%x\n",
+			    edb_id, resp_sb->flags);
+		ts->stat = SAS_INTERRUPTED;
 		return;
 	}
 
-- 
2.43.0

