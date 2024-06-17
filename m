Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A3A18C356
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 21:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658608; cv=none; b=O+tC3L+1zOlQ9Qq1/3Q7qCfpht+M9XfD8WpG3jGum72cerdYv6vInLh3qFQ0Dn0dmOIv/243lgfAQ0QrfhlDsKq4ipVZA5y/fvZnwTRtNrnjezcu3UDfPkgQ5m53/jfaHe7smGHdO88leWeWdrY/d6k7st0IMLm47m4CkYpjWg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658608; c=relaxed/simple;
	bh=yb0McD41g0o0HCK3QhnzrK3mBzf73/2CNyLyHjfHosA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M8e45e71s3ritgaakWg+M+FqDkEe7e7LUtC37WlqOW2fttqRAv2W7L0tBwfUroYzlRQJvjlXyKWXAs2ZSMcgIHEjG+NnnqGqiWrCJxXum0Ewu3GXSjNQ8PC7IFlJ9bQJFGQCvTZjdmT7UnIXYiHXCiOr7vcCqEA4PG/FgtzxzQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rNI14ai3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rNI14ai3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W32b24Z7fz6Cnk9B;
	Mon, 17 Jun 2024 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:references:in-reply-to:x-mailer:message-id:date:date:subject
	:subject:from:from:received:received; s=mr01; t=1718658601; x=
	1721250602; bh=tQEsiqrH6OPSOAxgYaULeIt/dsptPbFpcFz+UiujRzw=; b=r
	NI14ai3PTVSHVFiCuGeOmtKiB9mHT3n3axPHgXmzt8oAmzzvn2Ab7UcWqLniKRg6
	2L9qUVE8MHAOTV8NZmE3iS6asBNTg38mvu0ONOl0aAc2K7d3fDUNsSNjslXkUulq
	DHyFdvwJHkIi+TLHDt2fGiD0cFu1QgStMnCP7OyimVwZiQca01O5zFsCr/Q2mCCa
	CKjdyjvBlLQA/TEdO3oULJajeFiYB9SpHmjhb7vSDEHRaxNMwcsItPN29UNxY0Tb
	q18LfbTv0BSV0SbPoHB50DrRNtksXzguzCWoo9CQAGp1+0YqH7ga+FGKN32McDof
	gw5MB0vM4zxM7sMALRu7g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id x5-e__vOByqT; Mon, 17 Jun 2024 21:10:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W32Zw63Ykz6Cnk98;
	Mon, 17 Jun 2024 21:10:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 8/8] scsi: ufs: Check for completion from the timeout handler
Date: Mon, 17 Jun 2024 14:07:47 -0700
Message-ID: <20240617210844.337476-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
In-Reply-To: <20240617210844.337476-1-bvanassche@acm.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

If ufshcd_abort() returns SUCCESS for an already completed command then
that command is completed twice. This results in a crash. Prevent this by
checking whether a command has completed without completion interrupt fro=
m
the timeout handler. This CL fixes the following kernel crash:

Unable to handle kernel NULL pointer dereference at virtual address 00000=
00000000000
Call trace:
=C2=A0dma_direct_map_sg+0x70/0x274
=C2=A0scsi_dma_map+0x84/0x124
=C2=A0ufshcd_queuecommand+0x3fc/0x880
=C2=A0scsi_queue_rq+0x7d0/0x111c
=C2=A0blk_mq_dispatch_rq_list+0x440/0xebc
=C2=A0blk_mq_do_dispatch_sched+0x5a4/0x6b8
=C2=A0__blk_mq_sched_dispatch_requests+0x150/0x220
=C2=A0__blk_mq_run_hw_queue+0xf0/0x218
=C2=A0__blk_mq_delay_run_hw_queue+0x8c/0x18c
=C2=A0blk_mq_run_hw_queue+0x1a4/0x360
=C2=A0blk_mq_sched_insert_requests+0x130/0x334
=C2=A0blk_mq_flush_plug_list+0x138/0x234
=C2=A0blk_flush_plug_list+0x118/0x164
=C2=A0blk_finish_plug()
=C2=A0read_pages+0x38c/0x408
=C2=A0page_cache_ra_unbounded+0x230/0x2f8
=C2=A0do_sync_mmap_readahead+0x1a4/0x208
=C2=A0filemap_fault+0x27c/0x8f4
=C2=A0f2fs_filemap_fault+0x28/0xfc
=C2=A0__do_fault+0xc4/0x208
=C2=A0handle_pte_fault+0x290/0xe04
=C2=A0do_handle_mm_fault+0x52c/0x858
=C2=A0do_page_fault+0x5dc/0x798
=C2=A0do_translation_fault+0x40/0x54
=C2=A0do_mem_abort+0x60/0x134
=C2=A0el0_da+0x40/0xb8
=C2=A0el0t_64_sync_handler+0xc4/0xe4
=C2=A0el0t_64_sync+0x1b4/0x1b8

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e3835e61e4b1..47cc0802c4f4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8922,7 +8922,28 @@ static void ufshcd_async_scan(void *data, async_co=
okie_t cookie)
=20
 static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *sc=
md)
 {
-	struct ufs_hba *hba =3D shost_priv(scmd->device->host);
+	struct scsi_device *sdev =3D scmd->device;
+	struct ufs_hba *hba =3D shost_priv(sdev->host);
+	struct scsi_cmnd *cmd2 =3D scmd;
+	const u32 unique_tag =3D blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+
+	WARN_ON_ONCE(!scmd);
+
+	if (is_mcq_enabled(hba)) {
+		struct request *rq =3D scsi_cmd_to_rq(scmd);
+		struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
+
+		ufshcd_mcq_poll_cqe_lock(hba, hwq, &cmd2);
+	} else {
+		__ufshcd_poll(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT,
+			      &cmd2);
+	}
+	if (cmd2 =3D=3D NULL) {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: cmd with tag %#x has already been completed\n",
+			    __func__, unique_tag);
+		return SCSI_EH_DONE;
+	}
=20
 	if (!hba->system_suspending) {
 		/* Activate the error handler in the SCSI core. */
