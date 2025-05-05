Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802FB338C15;
	Mon,  5 May 2025 22:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484622; cv=none; b=j08kN4SE2UxfRB+3XLZJgm6A3CphvtLAzeA5HBPwn1JoG0pqt5eV5Toj9bNRuWdWabAPPixRcnS3JaeLmS1nRTVCiqwfPGqmjQBTPlN3FboO18XA+zqjycUk+T6JyffBI1T275H98diLwbJEbjxYdPNGI0hepdVUOo7OrXQVGlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484622; c=relaxed/simple;
	bh=1zpcV/PUT6iBVKp2a3L4dxp129Pujb4a124Bj+BZYnM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lViasYu7Pud8c10XSj4LcjdvBURsiJ3BjhfCTxwO9ETR8F0eD1ZyYZw8qhZa8dI/RVxHEhOczUAtpEiAsQ5nk+KvMw44W7LO4F8HfKIvGzIpUzAQ07dbwMBjgrfvtcMHGepHEX/bD8kms5fpanvs6Co7GrOfhYcoVoz7nuq17Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVsz/gYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVsz/gYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BEAC4CEE4;
	Mon,  5 May 2025 22:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484622;
	bh=1zpcV/PUT6iBVKp2a3L4dxp129Pujb4a124Bj+BZYnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVsz/gYmWuA3/jx2vR1QYby1JKFB189q8nvI3Ex/9OmmZHcUbsb+vj4lYfFnVbyNz
	 jNVjp7e1TS50E9b0eTw2aQmsYdOXqQswyWNaa6FXlCsdtDqHY9SpWuaMkm1DeHmwDb
	 AOnx/g5j6pMJ+IfSx8XUY0k9xSxA57C9aMCY+gcnphSsT00P4clCOy+ClF4gRFiqPG
	 r1KIC6Me+eVbU90rAj9C3i5F9NUJJAz0tQPpeaGP2c1qZdbtavskJEyUZH4YPghsQj
	 9OT7WfsYTSF+DSUb9ohHxNjxEOR3usvHzBbvyIZ62zvX8nZ1Ybszb6HsrX7YZZqV/8
	 Hzzz78Zj2S19Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 567/642] scsi: lpfc: Reduce log message generation during ELS ring clean up
Date: Mon,  5 May 2025 18:13:03 -0400
Message-Id: <20250505221419.2672473-567-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 8eccc58d71eafbd2635077916b68fda15791d270 ]

A clean up log message is output from lpfc_els_flush_cmd() for each
outstanding ELS I/O and repeated for every NPIV instance.  The log message
should only be generated for active I/Os matching the NPIV vport.  Thus,
move the vport check to before logging the message.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250131000524.163662-2-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1d7db49a8fe45..318dc83e9a2ac 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9569,18 +9569,16 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	mbx_tmo_err = test_bit(MBX_TMO_ERR, &phba->bit_flags);
 	/* First we need to issue aborts to outstanding cmds on txcmpl */
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
+		if (piocb->vport != vport)
+			continue;
+
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "2243 iotag = 0x%x cmd_flag = 0x%x "
-				 "ulp_command = 0x%x this_vport %x "
-				 "sli_flag = 0x%x\n",
+				 "ulp_command = 0x%x sli_flag = 0x%x\n",
 				 piocb->iotag, piocb->cmd_flag,
 				 get_job_cmnd(phba, piocb),
-				 (piocb->vport == vport),
 				 phba->sli.sli_flag);
 
-		if (piocb->vport != vport)
-			continue;
-
 		if ((phba->sli.sli_flag & LPFC_SLI_ACTIVE) && !mbx_tmo_err) {
 			if (piocb->cmd_flag & LPFC_IO_LIBDFC)
 				continue;
-- 
2.39.5

