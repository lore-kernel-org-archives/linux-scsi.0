Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF192116F6
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 17:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767503; cv=none; b=G7VV2rPYHm8fA6f0GtxNdSNw6gH9XVFP/8QMofcMT+Wi+kNyjjRvCLg6dQ83sf4n30qrfRdTtSC6vFNEXnvMIjRhSBKRRmuIpZeOH9kP/V/Bhey3OY07J+N5gbMS9VuF/+9viJWJCFElHtNJXy0U1lUOoJFEqGwAsZqvaeY2wXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767503; c=relaxed/simple;
	bh=J/mSSwMRYTqeHmWoVcc8xSG1NZGKnjUHpOwCNvyb2oY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=Ax4uFC4wGoMPXxL2WTkKW2f6mEOWSEzyYCRz+KW7X2TCky0sYKYOFpsFfCjJ3r8zFqUsrW/G3ZXKXG+eKeuYf+k8vSjIVNulHX/NL3gCEVmta9MR989lt1qIzD42/pRRDOvOaW43mtIX4RaGSuBgWq5vc4L3p9pneX9gtAyFUpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MYWnpHbE; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MYWnpHbE"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260317171132euoutp01bbdbfd5aca8cbb94ec1283e082d12b03~dsCLku-jy1291112911euoutp01_
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 17:11:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260317171132euoutp01bbdbfd5aca8cbb94ec1283e082d12b03~dsCLku-jy1291112911euoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773767492;
	bh=pwQ1Tj/5fxwXOKenXlPq85WoWCXbsQhDWZrqEkDauDM=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=MYWnpHbEr3ciYUqKxZ6yIU+QrhAKa00vRYesIqH3QOFrGXdKqb5MUJooCBD0goO1m
	 oOEgWYGxbL95r4onomXj8ywWt125YhIj4aMN+9SUCW5sIzaFIPUe82ZVZfqzLBReV0
	 ukglRzTlXeJTuKeksp2cf5xbS+Ewwbv1jF4h7W1c=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a~dsCLI5OAD2221222212eucas1p2N;
	Tue, 17 Mar 2026 17:11:31 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260317171130eusmtip2df6d625da7072fe080e4a257996d4b9f~dsCJurUtG1242212422eusmtip2P;
	Tue, 17 Mar 2026 17:11:30 +0000 (GMT)
Message-ID: <1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
Date: Tue, 17 Mar 2026 18:11:29 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, avri.altman@sandisk.com,
	alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
	chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
	chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
	eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
	bvanassche@acm.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260306054419.3816557-1-peter.wang@mediatek.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a
X-EPHeader: CA
X-CMS-RootMailID: 20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
	<CGME20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a@eucas1p2.samsung.com>

Hi

On 06.03.2026 06:43, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
>
> Only return IRQ_WAKE_THREAD when MCQ and ESI are not enabled
> and no UIC command is active. The default UIC command timeout
> is 500ms, Using threaded IRQs during an active UIC command
> increases the risk of timeout due to possible preemption
> by other system IRQs.
>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>

This patch landed in linux-next as commit 6475cfb81fc4 ("scsi: ufs: 
core: Avoid IRQ thread wakeup during active UIC command"). In my tests I 
found that it causes the following regression on QCom RB5 board 
(arch/arm64/boot/dts/qcom/qrb5165-rb5.dts):

=============================
[ BUG: Invalid wait context ]
7.0.0-rc4-next-20260316 #16535 Not tainted
-----------------------------
swapper/0/0 is trying to lock:
ffff000089f58048 (shost->host_lock){....}-{3:3}, at: 
ufshcd_sl_intr+0x3c0/0x6b4
other info that might help us debug this:
context-{2:2}
no locks held by swapper/0/0.
stack backtrace:
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.0.0-rc4-next-20260316 
#16535 PREEMPT
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
Call trace:
  show_stack+0x18/0x24 (C)
  dump_stack_lvl+0x90/0xd0
  dump_stack+0x18/0x24
  __lock_acquire+0xa40/0x2254
  lock_acquire+0x1c4/0x3fc
  _raw_spin_lock_irqsave+0x60/0x88
  ufshcd_sl_intr+0x3c0/0x6b4
  ufshcd_intr+0x7c/0x90
  __handle_irq_event_percpu+0xa0/0x4c4
  handle_irq_event+0x4c/0xf8
  handle_fasteoi_irq+0x108/0x198
  handle_irq_desc+0x40/0x58
  generic_handle_domain_irq+0x18/0x24
  gic_handle_irq+0x4c/0x110
  call_on_irq_stack+0x30/0x48
  do_interrupt_handler+0x80/0x84
  el1_interrupt+0x3c/0x60
  el1h_64_irq_handler+0x18/0x24
  el1h_64_irq+0x6c/0x70
  cpuidle_enter_state+0xf8/0x41c (P)
  cpuidle_enter+0x38/0x50
  do_idle+0x170/0x2ac
  cpu_startup_entry+0x34/0x3c
  rest_init+0xf8/0x188
  start_kernel+0x818/0x8ec
  __primary_switched+0x88/0x90
scsi host0: ufshcd


Reverting $subject on top of linux-next fixes this issue.

> ---
>   drivers/ufs/core/ufshcd.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 9908375b2f98..6554e1db3343 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7200,8 +7200,12 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
>   	struct ufs_hba *hba = __hba;
>   	u32 intr_status, enabled_intr_status;
>   
> -	/* Move interrupt handling to thread when MCQ & ESI are not enabled */
> -	if (!hba->mcq_enabled || !hba->mcq_esi_enabled)
> +	/*
> +	 * Handle interrupt in thread if MCQ or ESI is disabled,
> +	 * and no active UIC command.
> +	 */
> +	if ((!hba->mcq_enabled || !hba->mcq_esi_enabled) &&
> +	    !hba->active_uic_cmd)
>   		return IRQ_WAKE_THREAD;
>   
>   	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

