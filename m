Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F11F4C70
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 00:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712880213; cv=none; b=McTPNu+jCJaFTYbh2gYav/JHsGicc6CT2edncy8cgcbGat4JX7/fq/xBu8oCCYYtL/ejtPX3oKxA+XqySqhLA33rVo9e8YhWM0NXxwnm2YoFQp9tjUP6OojN2WaT2LdOeiQ7sC8kGddty4jIlelVdf3xVLZrV0zaBTOMaOlH9eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712880213; c=relaxed/simple;
	bh=WcxWPMo00MFwO8E8aZ3yGjE2YafWMvZBn2w2oAY2Pok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TzUGm21i+7+H8okSBcr1wb0ctvbsg/KgOhuv1sHpkZoU6NCFg/Eie5ZYyi1E+4mnAE0uIvAxBWryzSwiXu2hISJ8cnDbn7QZQ3VU6kfcd6tQAX70C5/bgwB70m2dAi/xxE7rwme0pmIJtZNrDtUazLzbS8MXd1cQP3FPmw6RmK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rnkW8AXA; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rnkW8AXA"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VFxc25hZ4z6Cnk8y;
	Fri, 12 Apr 2024 00:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:references:in-reply-to:x-mailer:message-id:date:date:subject
	:subject:from:from:received:received; s=mr01; t=1712880204; x=
	1715472205; bh=9IuSH1YaIUPTgPJI7q/c41AePG3xK0BVVdglZ64w0p8=; b=r
	nkW8AXAklTBYpcpvLaW8Rir2SU2Hpi/xzY+4n/FcKFlXqrFk7GAjLsSCoPkZ5mZQ
	j785fXJBwi+Yli1VMuLRRGor97OtE2TXNzTGFZ1p8rHyEH4UsWQf8pI+KH7Vf9T7
	LzgA6ZXZrIGJq3q7xoHixc+77PVg3OF5rTLpt9PqwNWeIqfoini4tg3ypnFPW0D7
	UIN09i7Qjc1gnPRut1iEsZ3Gk3VAWWmfKmbJtXt/mKlKkNpmlpZImyrt4N24qD3L
	jAmHrvuSV06PsCeHlaVs8rSi/SBjEQgwXTsGYv/YRjekcUgOffbCN1M50kNTAHuQ
	wd2Fr5823r5S5ynm41umw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dNN9Cy6wdJyp; Fri, 12 Apr 2024 00:03:24 +0000 (UTC)
Received: from bvanassche-glaptop2.roam.corp.google.com (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VFxbv0Xqrz6Cnk8t;
	Fri, 12 Apr 2024 00:03:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Avri Altman <avri.altman@wdc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH 4/4] scsi: ufs: Check for completion from the timeout handler
Date: Thu, 11 Apr 2024 17:02:24 -0700
Message-ID: <20240412000246.1167600-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
In-Reply-To: <20240412000246.1167600-1-bvanassche@acm.org>
References: <20240412000246.1167600-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufshcd.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 08abdd763c51..98b14623317f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9022,6 +9022,25 @@ static void ufshcd_async_scan(void *data, async_co=
okie_t cookie)
 static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *sc=
md)
 {
 	struct ufs_hba *hba =3D shost_priv(scmd->device->host);
+	struct scsi_cmnd *cmd2 =3D scmd;
+
+	WARN_ON_ONCE(!scmd);
+
+	if (is_mcq_enabled(hba)) {
+		struct ufs_hw_queue *hwq =3D
+			ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(scmd));
+
+		ufshcd_mcq_poll_cqe_lock(hba, hwq, &cmd2);
+	} else {
+		__ufshcd_poll(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT,
+			      &cmd2);
+	}
+	if (cmd2 =3D=3D NULL) {
+		sdev_printk(KERN_INFO, scmd->device,
+			    "%s: cmd with tag %#x has already been completed\n",
+			    __func__, blk_mq_unique_tag(scsi_cmd_to_rq(scmd)));
+		return SCSI_EH_DONE;
+	}
=20
 	if (!hba->system_suspending) {
 		/* Activate the error handler in the SCSI core. */
