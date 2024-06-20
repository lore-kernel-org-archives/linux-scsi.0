Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B816BB58;
	Thu, 20 Jun 2024 20:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917084; cv=none; b=tcJlkAtaJd1BqdHEg/gYoV14Eo4whVf46d1Lpt/tQEpwsAfocncvEM6PMMw10E1qg/xWWxG737eNLZ75ca3MYcjdfg0fIDDKxSRPCq9lRVt0EPgXYnT1quOs8shpmkbpnL6w1Am9lW7XAPN6edrqazKvhYdsN9e+FfvSbqp0eA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917084; c=relaxed/simple;
	bh=CiMBSZOyuLHrUqec/82xEYZGcql4vMHVk8hqY07tcUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqJ7mAPiM6o4CQkraHdFvrQJGerCdoE5Na7oVKi3CMoFzOwteZxkGIovQDEmShNbLTUitOlq7kDBQjSeqH7k3fLt+po3QuqfDqrnC5jARClDsE2Q6QkBr14Xoauj1Ps4kzueVrrsQ1V+BzZ9EzUjW3MWCSe72CZhpKMUj/y1vb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Jz/V6NB4; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Jz/V6NB4"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W4t9c2jSYzlgMW9;
	Thu, 20 Jun 2024 20:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718917068; x=1721509069; bh=goE+6pf4oOgxwPVA4XIt9Lhz
	UgDEl294xqk2zr+ORlo=; b=Jz/V6NB4IGhdt60PadlfJcv6R+YAQ/JuWfp1PMIC
	RgDpFDVk8IAuQaoqOCIRLCrgE+j6eI9fRDQGthTXD2ZkdhmgJ9KVeft6wjITPNql
	knzRJOtnMCwlhvVnlYPjMv3yXR1bo6I5ApIab35iGm36r+UNPv+bdCAlp5dwu+N0
	9si8tGykn3ymp6tC1owiMQdWRZ6ccbDhi0pDaYxCIqYb8OeIT+d5SprnEA3de38D
	z3EB/IEIdsn4gIFFJMLqBtv+5TcGLEpFEUwGpahZsCwijsOt5B8vDtO7yu/x6R6s
	jM1inZO11Iuyu+Y6IcYy3wgaoLXp6RwvYgXdSDtFBVg8Cg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0FV-odNXuSQN; Thu, 20 Jun 2024 20:57:48 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W4t9N4ljKzlgMW8;
	Thu, 20 Jun 2024 20:57:44 +0000 (UTC)
Message-ID: <d3fc4d2b-81b0-4ab2-9606-5f4a5fb8b867@acm.org>
Date: Thu, 20 Jun 2024 13:57:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_cang@quicinc.com,
 mani@kernel.org, beanhuo@micron.com, avri.altman@wdc.com,
 junwoo80.lee@samsung.com, martin.petersen@oracle.com,
 quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
 quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>,
 open list <linux-kernel@vger.kernel.org>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/24 3:06 AM, Ziqi Chen wrote:
> Fix this race condition by quiescing the request queues before calling
> ufshcd_pending_cmds() so that block layer won't touch the budget map
> when ufshcd_pending_cmds() is working on it. In addition, remove the
> scsi layer blocking/unblocking to reduce redundancies and latencies.

Can you please help with testing whether the patch below would be a good
alternative to your patch (compile-tested only)?

Thanks,

Bart.

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index aa00978c6c0e..1d981283b03c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -332,14 +332,12 @@ static void ufshcd_configure_wb(struct ufs_hba *hba)

  static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
  {
-	if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
-		scsi_unblock_requests(hba->host);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
  }

  static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
  {
-	if (atomic_inc_return(&hba->scsi_block_reqs_cnt) == 1)
-		scsi_block_requests(hba->host);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
  }

  static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -10590,7 +10588,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)

  	/* Hold auto suspend until async scan completes */
  	pm_runtime_get_sync(dev);
-	atomic_set(&hba->scsi_block_reqs_cnt, 0);
+
  	/*
  	 * We are assuming that device wasn't put in sleep/power-down
  	 * state exclusively during the boot stage before kernel.
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 443afb97a637..58705994fc46 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -889,7 +889,6 @@ enum ufshcd_mcq_opr {
   * @wb_mutex: used to serialize devfreq and sysfs write booster toggling
   * @clk_scaling_lock: used to serialize device commands and clock scaling
   * @desc_size: descriptor sizes reported by device
- * @scsi_block_reqs_cnt: reference counting for scsi block requests
   * @bsg_dev: struct device associated with the BSG queue
   * @bsg_queue: BSG queue associated with the UFS controller
   * @rpm_dev_flush_recheck_work: used to suspend from RPM (runtime power
@@ -1050,7 +1049,6 @@ struct ufs_hba {

  	struct mutex wb_mutex;
  	struct rw_semaphore clk_scaling_lock;
-	atomic_t scsi_block_reqs_cnt;

  	struct device		bsg_dev;
  	struct request_queue	*bsg_queue;

