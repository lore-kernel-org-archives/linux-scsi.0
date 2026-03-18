Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766B92989B5
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 19:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773862337; cv=none; b=O4YYox0VtMGXq3++dKZLZOuIVtDEzdt+dK/nNPc4LhRLueDa27CKrCB7XFuWS+Ayp1lhHcqcCBV7YLhtEbNBiCJpkhd26p2txyQced2nXkVHNQQ/ENchKWJfqqSrGoEkUiKzrgxwZffkJlUY8epRhvEmV5B2qxT0pNoTG0/PzlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773862337; c=relaxed/simple;
	bh=WduISqynjejyd0zgAdLZ/2Mv0FyVh61p9YdsXJW+PiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=LWha0bwq9pRwrv9a9EPuF90y4cKKJsn+v6fPzvJkvJR90yHu7JwzgWQMqVKIxA+K4MRnqGaR94Nv4UN8g4vpiM9tWT1OqpFLz9GqYvM5I1n+8eea6Vc4WHlUpwLHlT9R5Y/4oZloBU+U88Roy9Xaj6x+g/CuS0lT7My1LNag9HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=o1zs8GrK; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="o1zs8GrK"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260318193212euoutp0263af4b3c2e6d6c1ae1a1cda963914c66~eBmSnQSDg1474114741euoutp02G
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 19:32:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260318193212euoutp0263af4b3c2e6d6c1ae1a1cda963914c66~eBmSnQSDg1474114741euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773862332;
	bh=6IFXzogKubWdLI3XWVv4ALzt88W3L4Gj8JjMLCnR0Ro=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=o1zs8GrKWY/zERyfeKXWrRacdfChFmR26NnCgvzDRgCbVVN5CovGgVq3jjMQKfxHR
	 4FcIpuLIqLQMowGXvrTEdT+d0JdfJXgDuEdqN0ECHdzJzf7k+E1scI9Au0NomkgiAg
	 EKn0TOW7J8HXXOlgw9DPJRrsIREXjz0A5qKGDHEA=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260318193211eucas1p15a3ea20acd532ad8553948323b0eb96c~eBmRmVbY71058410584eucas1p1e;
	Wed, 18 Mar 2026 19:32:11 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260318193210eusmtip2a4bf1016c544542de84a481a384d1e86~eBmQ2K1rY0576205762eusmtip2b;
	Wed, 18 Mar 2026 19:32:10 +0000 (GMT)
Message-ID: <c9b421aa-baa7-4609-b665-226f894f5114@samsung.com>
Date: Wed, 18 Mar 2026 20:32:09 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
To: Bart Van Assche <bvanassche@acm.org>, peter.wang@mediatek.com,
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	avri.altman@sandisk.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
	chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
	chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
	eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <364d15bf-8d11-46af-bbc6-b4ae45618bf5@acm.org>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260318193211eucas1p15a3ea20acd532ad8553948323b0eb96c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a
X-EPHeader: CA
X-CMS-RootMailID: 20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
	<CGME20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a@eucas1p2.samsung.com>
	<1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
	<df1d0b3f-6822-4c49-aeea-fc513e2b05cb@acm.org>
	<1b9db59c-f736-4c59-b37a-15a60cfa4f3e@samsung.com>
	<364d15bf-8d11-46af-bbc6-b4ae45618bf5@acm.org>

On 18.03.2026 18:32, Bart Van Assche wrote:
> On 3/18/26 10:13 AM, Marek Szyprowski wrote:
>> On 18.03.2026 16:50, Bart Van Assche wrote:
>>> On 3/17/26 10:11 AM, Marek Szyprowski wrote:
>>>> This patch landed in linux-next as commit 6475cfb81fc4 ("scsi: ufs:
>>>> core: Avoid IRQ thread wakeup during active UIC command"). In my 
>>>> tests I
>>>> found that it causes the following regression on QCom RB5 board
>>>> (arch/arm64/boot/dts/qcom/qrb5165-rb5.dts):
>>>>
>>>> =============================
>>>> [ BUG: Invalid wait context ]
>>>> 7.0.0-rc4-next-20260316 #16535 Not tainted
>>>> -----------------------------
>>>> swapper/0/0 is trying to lock:
>>>> ffff000089f58048 (shost->host_lock){....}-{3:3}, at:
>>>
>>> This line is a mystery to me. Are there perhaps any local changes in
>>> your kernel tree on top of linux-next? I haven't been able to find the
>>> text "shost->host_lock" in the UIC completion path.
>>
>> I don't have any local changes, code is at commit 6475cfb81fc4. After
>> looking at the code this 'shost' indeed looks a bit mysterious, but
>> maybe it got that name after some inlining or code optimization.
>>
>>> Instead, this is
>>> what I found:
>>>
>>>      guard(spinlock_irqsave)(hba->host->host_lock);
>>>
>>>> ufshcd_sl_intr+0x3c0/0x6b4
>>>
>>> Can you please help with translating this information into a line
>>> number? Tools like addr2line, llvm-addr2line or llvm-objdump -d -l -S
>>> can be used to perform such a conversion.
>>
>> ufshcd_clk_scaling_allow() in drivers/ufs/core/ufshcd.c:6492 (code
>> checkout at git commit 6475cfb81fc4)
>
> Hi Marek,
>
> I haven't been able to find any call chain from ufshcd_sl_intr() into
> ufshcd_clk_scaling_allow(). Am I perhaps overlooking something?

I must have mixed something while calculating offsets for addr2line. I 
checked again and I found that there is already a script doing that. 
I've recompiled kernel with -Os (assuming that this way less code will 
be inlined) and this is the result:

=============================
[ BUG: Invalid wait context ]
7.0.0-rc1+ #16537 Not tainted
-----------------------------
swapper/0/0 is trying to lock:
ffff000080a04048 (shost->host_lock){....}-{3:3}, at: 
ufshcd_sl_intr+0x50/0x598
other info that might help us debug this:
context-{2:2}
no locks held by swapper/0/0.
stack backtrace:
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.0.0-rc1+ #16537 PREEMPT
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
Call trace:
  show_stack+0x18/0x24 (C)
  dump_stack_lvl+0x6c/0x94
  dump_stack+0x18/0x24
  __lock_acquire+0x3f8/0x10ac
  lock_acquire+0x29c/0x2ec
  _raw_spin_lock_irqsave+0x58/0x78
  ufshcd_sl_intr+0x50/0x598
  ufshcd_intr+0x64/0x78
  __handle_irq_event_percpu+0x1d4/0x354
  handle_irq_event_percpu+0x18/0x4c
  handle_irq_event+0x48/0x90
  handle_fasteoi_irq+0xc4/0xe8
  handle_irq_desc+0x48/0x58
  generic_handle_domain_irq+0x18/0x24
  gic_handle_irq+0xa4/0x108
  call_on_irq_stack+0x30/0x48
  do_interrupt_handler+0x88/0x94
  el1_interrupt+0x3c/0x60
  el1h_64_irq_handler+0x18/0x24
  el1h_64_irq+0x6c/0x70
  cpuidle_enter_state+0x1c0/0x2f0 (P)
  cpuidle_enter+0x38/0x50
  do_idle+0x23c/0x260
  cpu_startup_entry+0x34/0x38
  kernel_init+0x0/0x12c
  start_kernel+0x7e4/0x7f0
  __primary_switched+0x88/0x90


# ./scripts/faddr2line vmlinux "ufshcd_sl_intr+0x50/0x598"
ufshcd_sl_intr+0x50/0x598:
ufshcd_uic_cmd_compl at drivers/ufs/core/ufshcd.c:5570
(inlined by) ufshcd_sl_intr at drivers/ufs/core/ufshcd.c:7144


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

