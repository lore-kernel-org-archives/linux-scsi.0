Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9DE39ADB
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 17:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287679; cv=none; b=X5tNcW4egI9ye4fi3patf5afGlMjJvxtTi+KPvOp9p5T2Yh21dJ98VJajgXoc58rW7EI2Q9a7DrL6xoCODe3ZL8ykSyMrvgpUIg/XpVZ3MggXtVZEiKOei96g0TshnnsIPpxsTxVywfoSwqqRuAz7sfnYnDi+pQzM9iVUqNw1B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287679; c=relaxed/simple;
	bh=q4V0l+H+VKbLbn5Gvi+M9UWiRAawqFeoc1Pa/+Tx0ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IaeqrFgqQnls5kid9S4J0z8NaN5FGRDVV91jMd9Ja/hRY/OW+/K6sB81CQsT2tezTemA387QFy7eE8mBWlp8gKXzOLcMZRLMlWLU+5dk0DhTB0PP5L3QSEam5APjpFcU+iMGeWOEy/AlrmuEoWjb7X4vBLa/v6g3PN6Hs/tyciQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GihWwyhW; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GihWwyhW"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VJrHy1gxrz6Cnk8s;
	Tue, 16 Apr 2024 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:references:in-reply-to:x-mailer:message-id:date:date:subject
	:subject:from:from:received:received; s=mr01; t=1713287671; x=
	1715879672; bh=23HYz2m1XT5SSkG1fV63l1pc14rDh/T3Ec+21GcUxd0=; b=G
	ihWwyhWznT5Ml5mqu/RCG874QZ8R3tI0bkm6xmYZ3Mseq8Xm7pSbR+B3wl0K/7j2
	gAZTqNSdP8HeV1TdXaJqJbJSeUlA3SLeT6rPiy3msGtBZLARBgFDd34QAbqJELuO
	NNls+1wTFPpg0IyhDSjYCPZWl3xqBD/HztPcfGSkITz3cHh76pGWngFIZqDQg8Pe
	qU3HwpuK3QcUag+n87DWecG8pvYqZjJ6vy56FALRP0Mbg6LGJuveNSZ/y6hOREQn
	9VJXu6hUF1b+96cdVOPA+uT62qBv25FFCokkQuNPF6UGvuXbYLtrfQsVMh5hMHJL
	NCDjAg6vVGpccXMoupfiA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qH751M1jMlXP; Tue, 16 Apr 2024 17:14:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VJrHp5lrbz6Cnk8t;
	Tue, 16 Apr 2024 17:14:30 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Avri Altman <avri.altman@wdc.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Can Guo <quic_cang@quicinc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 4/4] scsi: ufs: Check for completion from the timeout handler
Date: Tue, 16 Apr 2024 10:13:31 -0700
Message-ID: <20240416171357.1062583-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
In-Reply-To: <20240416171357.1062583-1-bvanassche@acm.org>
References: <20240416171357.1062583-1-bvanassche@acm.org>
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
index c552bf391f79..c44515605031 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8880,6 +8880,25 @@ static void ufshcd_async_scan(void *data, async_co=
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
+		struct request *rq =3D scsi_cmd_to_rq(scmd);
+		struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
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
