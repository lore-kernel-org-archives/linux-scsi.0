Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DA8244661
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 17:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773854019; cv=none; b=YSro/Pxrhm1ckJKrnuGxJWxmiQbc9caMIsCSnqKWI1hbVhHpHg1RpqXWEYWP0lOt62Vq5NbR8Bn42wzgL/dQWkOhHoMmD3bnGlY7R1FPx4lqleCfZnwDtlg6TMKErNISHVeHqqHckWaqUEzBDcEwe17D7Tvi5DTSRQ3iGOPrba4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773854019; c=relaxed/simple;
	bh=dFzFqKxpP0mALllupjzgpV2ZD6PJMlxsCoah7hdMjZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=WaVqOI8RZO7q5Sg99dKpNVyVtOHaINpL0FjpGrtHqHdSvi07maYxdAbh3sKMYHIQkKQUl3SPglyTAcNS0qEhyGsgMCbkWtXG8KuNDuSBqYOUb/+g4t0hGDKbnLFC1vifM2lg44Z3yye8K7X4tOs/aU4fqFFjFhdwDOqcm4n9UQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GlzcAZ9R; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GlzcAZ9R"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260318171329euoutp01787125c052fc187204569e504a300579~d-tKy7gdr1589515895euoutp01R
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 17:13:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260318171329euoutp01787125c052fc187204569e504a300579~d-tKy7gdr1589515895euoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773854009;
	bh=DjGYqWhafNt4JL8pxv2BfMAtvUGx8XCJbBr9eCwrEnI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=GlzcAZ9RtGudSxVLJL7zq506li31c3D/EcOFiWfq9FfSOIvbQAqZBVzvAYP9HO7xu
	 7ZMr2u8f6vD3METpxCzY9ue3LtV+Ees6y3rTdTtPkmFpgHs7f5fsDjepNeG7qp4aiC
	 ChKRfgckGG48Bnw4ipNbJBp0E+ihuBeHZSBrgPDg=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260318171328eucas1p13f8bd42ec036e724893ac8d2492380da~d-tKJxfGz2951829518eucas1p1h;
	Wed, 18 Mar 2026 17:13:28 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260318171326eusmtip19d9c14ed6d24b0fbcafe8e935194384f~d-tIxnPBK2725627256eusmtip1S;
	Wed, 18 Mar 2026 17:13:26 +0000 (GMT)
Message-ID: <1b9db59c-f736-4c59-b37a-15a60cfa4f3e@samsung.com>
Date: Wed, 18 Mar 2026 18:13:26 +0100
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
In-Reply-To: <df1d0b3f-6822-4c49-aeea-fc513e2b05cb@acm.org>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260318171328eucas1p13f8bd42ec036e724893ac8d2492380da
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a
X-EPHeader: CA
X-CMS-RootMailID: 20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
	<CGME20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a@eucas1p2.samsung.com>
	<1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
	<df1d0b3f-6822-4c49-aeea-fc513e2b05cb@acm.org>

On 18.03.2026 16:50, Bart Van Assche wrote:
> On 3/17/26 10:11 AM, Marek Szyprowski wrote:
>> This patch landed in linux-next as commit 6475cfb81fc4 ("scsi: ufs:
>> core: Avoid IRQ thread wakeup during active UIC command"). In my tests I
>> found that it causes the following regression on QCom RB5 board
>> (arch/arm64/boot/dts/qcom/qrb5165-rb5.dts):
>>
>> =============================
>> [ BUG: Invalid wait context ]
>> 7.0.0-rc4-next-20260316 #16535 Not tainted
>> -----------------------------
>> swapper/0/0 is trying to lock:
>> ffff000089f58048 (shost->host_lock){....}-{3:3}, at:
>
> This line is a mystery to me. Are there perhaps any local changes in
> your kernel tree on top of linux-next? I haven't been able to find the
> text "shost->host_lock" in the UIC completion path.

I don't have any local changes, code is at commit 6475cfb81fc4. After 
looking at the code this 'shost' indeed looks a bit mysterious, but 
maybe it got that name after some inlining or code optimization.

> Instead, this is
> what I found:
>
>     guard(spinlock_irqsave)(hba->host->host_lock);
>
>> ufshcd_sl_intr+0x3c0/0x6b4
>
> Can you please help with translating this information into a line
> number? Tools like addr2line, llvm-addr2line or llvm-objdump -d -l -S
> can be used to perform such a conversion.

ufshcd_clk_scaling_allow() in drivers/ufs/core/ufshcd.c:6492 (code 
checkout at git commit 6475cfb81fc4)


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

