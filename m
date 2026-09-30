Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126AF37F72D
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 02:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790736311; cv=none; b=fefhmBk4hQ8evgdJpvK73tTFob6KI/zUNv/40snX/KpZshLrUpY3Ser4Ln8kKhj4d3+rQnd4NPopuf4GZYuP8YihNQyLQjD2jcdWPOg+8AaWCj12Af/ydoWjFWLXbenp+OUb1+C6PLuTZ21Wgf8aSYyiXcOO6lgr83jD0RWt77U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790736311; c=relaxed/simple;
	bh=hrBH1QIQ2pSMbHr2BXWFst1TbSqN9LubV9voRb7uN6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GHki2EQD5mSr6icXYAK8Ks5nyCBPWQNEt1AHpc7982cu5mS3Yg2+4Iw2n/PRFPlfldPOGGio4wQGkFItupJCSd4VZh3Je+mHMA2s1IxOeVdGWtR3874yjcUGDCqAxZY+plvt2kZwPOvJVzK6wlN1SV9mvV/JpSRrrA2oAsXoDRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=PPCBF8sS; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="PPCBF8sS"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3411e0ace58so6196049eec.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 19:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790736309; x=1791341109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3YbMCtgudffwKDOMbrCPqhD3Y7d7u5CsmzxzRhdQzOQ=;
        b=PPCBF8sS7uFpgHr1pcm/qCxahrt4/amFFcxRlfSNRKUDUPHRARZhY5HmXevtsJr3aJ
         PZAY57ULrYNMyyyWaXz2P27IZ1KuAAezS4ELvmlUId3F+ZAqCWARdDIawjZj3zxMlle1
         Z/rgIrSBGThMXoITGHaR/fwiYSUTJ1DWY5hEkLXF19cc4MCRBcjooMNAb21O8u1KcsLv
         /4VoquW85A6P0abF6uxJLcLR7e2xH47PHxlJBUWRs1xLainfRerI5WwGx6Yix00qJMP0
         6N8vESV5y4MiDEZeCsKeADmkxONDgNoi/bGqrP2bys0rxUrOnoaZDbo8Q1GTcO5rbrwy
         E0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790736309; x=1791341109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3YbMCtgudffwKDOMbrCPqhD3Y7d7u5CsmzxzRhdQzOQ=;
        b=KECtfxOoHXOQCplv+iAvfTrv4RP9iMSDPR14fW128zzOw1+bEpOoSGf1OlIlFDdGh+
         Ybu9ugkootyRTXTa+UyUe8JUpawHgktPzEtX2sE3dkMu53/aLS3KX/bL6Xp7OG0/9Emn
         jeqsHnLeOHKDIFuHSeTTwXAOY6nAF6g0kNG6KlkVPcCggKmRI+yqOGNcOD2nO458hl/5
         GDlo9itjSR4RUMYegsaiJZj8zSC3YW99pJ2qFy4+IXynKAsy1BNvlOFqsrrc/sm0yUMz
         v32TOAMuXfsUBOiycpgVAk7PoTvVZ9wxJs6najUAaAZU14PfgY81EVVIsON1xXg5VEdz
         LhMw==
X-Forwarded-Encrypted: i=1; AKwUvBx7X9vsfo11bhlsjYJNrBNLg3H0KAt+xI6M1bkzz88vZeokyatlQ9dxnipQksOQ4kMsC6YbpJly+Rr9@vger.kernel.org
X-Gm-Message-State: AFq9FYJxor1JkBB3zCzXXpGDV1GtwImm308rxZZE11wW8U6Ix9AIkIaa
	5zJAyr6uq0MBiUiV618GoXAHw4upQNFc2xKM+AuSzkhqKES1oNzmretR8et7dPJohGc=
X-Gm-Gg: AYBFou0vmqG+hZnR5JEWU/yCFCzvFnnK0lNiSSuHa5IwJ4b4bGutvRP316z4KnwGLMD
	PcZ0hX4Yo74uCMR63ZzRjCIZ9r5H60arCxPC8DtNBdP3CmpCrmrZ0Xfrl5aNRxM2HFRHaEXh5Sg
	9mpVmsWOH4jzeLBlP/m0k6WebAMT2uqtCwdPlJoDFVfQif2wZfhu9EQI6pLi9ZdWGbU7RtxX40p
	yusYAj4Uqujpy5rliBCMv2BfXOXufaLdi9tbE7T8jfmGQPodAiF3H7/zX2GIV/xeTeDzdZBICSw
	NWPcWwvsH9JxPWqpz00sgEGWlUIRXkHY9c75XExJi+CQV88JAtDzTzjLXkV0KsTiohJAF6ze5QF
	kykt8wNMlWgTuEAj3EdsnLbRsYGERvpbXxlT4uM8xk47sYmNgoXchrodeYZ/wvZj/h37N/e7CeG
	VmtyuN0ztdeZ+TZeJbEDLj/fSBUMgmV+Y6cqIhG7iVYt6UBMwCAwRnfAUtj52hFVrpUYF+lEfxC
	oYtnSUTsMzLrNuU0H5xQDBNraI84w3jAd/B5AE3ba9nzynsBNiz22KLty8k27QU+eMdy4w=
X-Received: by 2002:a05:693c:894e:20b0:343:f1fc:9006 with SMTP id 5a478bee46e88-34cdcfaa1e5mr178243eec.30.1790736308846;
        Tue, 29 Sep 2026 19:45:08 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:3481:cbb6:f339:9e4e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34c391d97a0sm2663523eec.29.2026.09.29.19.45.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Sep 2026 19:45:08 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paul Ely <paul.ely@broadcom.com>,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com
Subject: [PATCH 6.6.y] scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info
Date: Tue, 29 Sep 2026 22:45:03 -0400
Message-ID: <20260930024505.96440-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit ede596b1434b57c0b3fd5c02b326efe5c54f6e48 ]

The MBX_TIMEOUT return code is not handled in lpfc_get_sfp_info and the
routine unconditionally frees submitted mailbox commands regardless of
return status.  The issue is that for MBX_TIMEOUT cases, when firmware
returns SFP information at a later time, that same mailbox memory region
references previously freed memory in its cmpl routine.

Fix by adding checks for the MBX_TIMEOUT return code.  During mailbox
resource cleanup, check the mbox flag to make sure that the wait did not
timeout.  If the MBOX_WAKE flag is not set, then do not free the resources
because it will be freed when firmware completes the mailbox at a later
time in its cmpl routine.

Also, increase the timeout from 30 to 60 seconds to accommodate boot
scripts requiring longer timeouts.

[ Backport to 6.6.y: v6.6 predates ext_buf and uses ctx_buf for the SLI3
  raw payload. Restore ctx_buf to the saved struct lpfc_dmabuf before
  testing LPFC_MBX_WAKE so a timed-out mailbox's late default completion
  sees the DMA descriptor rather than payload bytes. ]

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240628172011.25921-6-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi Greg, Sasha, and scsi lpfc maintainers,

I am working through the small CVE backports still missing from 6.6.y.
This one addresses CVE-2024-46842. It leaves timed-out mailbox storage
alive for the eventual firmware completion.

The fix is already present in 6.12.y, 6.18.y, and 7.2.y, but not in 6.6.y.
The target-specific adjustment is recorded in the bracketed note above.
Unlike mainline, 6.6.y temporarily stores the SLI3 mailbox payload in
ctx_buf. Restoring the saved DMA descriptor before returning after a timeout
keeps the eventual firmware completion on the expected cleanup path.

Could you please queue it for 6.6.y?

CVE: CVE-2024-46842
Upstream: ede596b1434b57c0b3fd5c02b326efe5c54f6e48

AI assistance: An LLM helped identify, adapt, and validate this backport; I
reviewed the resulting code and validation evidence.

Thanks,
Artem Dinaburg

 drivers/scsi/lpfc/lpfc_els.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2e9972a5878103..d319df7d36137c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7310,12 +7310,13 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 	mbox->vport = phba->pport;
 	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
 
-	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
 	if (rc == MBX_NOT_FINISHED) {
 		rc = 1;
 		goto error;
 	}
-
+	if (rc == MBX_TIMEOUT)
+		goto error;
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		mp = (struct lpfc_dmabuf *)(mbox->ctx_buf);
 	else
@@ -7367,9 +7368,11 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->u.mqe.un.mem_dump_type3.addr_lo = putPaddrLow(mp->phys);
 		mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
 	}
-
 	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
-	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
+
+	if (rc == MBX_TIMEOUT)
+		goto error;
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe)) {
 		rc = 1;
 		goto error;
@@ -7380,8 +7383,9 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 			     DMP_SFF_PAGE_A2_SIZE);
 
 error:
 	mbox->ctx_buf = mpsave;
-	lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	if (mbox->mbox_flag & LPFC_MBX_WAKE)
+		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
 
 	return rc;
 
-- 
2.39.5
