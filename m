Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A9D1F192E
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 20:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773866321; cv=none; b=lRTuTyoHP2lCInfUWnpoExDDlUo4j2rLZwS11pn5Z0X5hlc51yE/jgooP1N3hNAtw5rh/m4uGGy9+HaB/yW0X5PnmXvbG11q4D/hzp4SGaj26oyxCdjyQBC1Q34C3YwKBMP0ea1WzYL+FqevEvaN5E9ZOHcerSjwsX+D8NibWZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773866321; c=relaxed/simple;
	bh=AsWLoma/4tPp2w3j03uERj3jS8Q9FkMvLrAKtru25q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GNVUxuSP+zT/6j7V5JU1uu+QCWrbtkeWQteyaOTlWpzN9xppSLi/Hg4q6ypvb1BE9ZY/ripRaOLNM5+tQOKMSRIHCpg4VLUyYny47dDqRITs12OZLUL/gxPUV+TZKbmn+j1SKQlYTL5mhMMQ0RCxV3WedTR9IqX8unEPOamamZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=q4HQRJ/u; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="q4HQRJ/u"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fbgdr0L0ZzlfvpK;
	Wed, 18 Mar 2026 20:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773866308; x=1776458309; bh=ebwoX899bJ3/ex4ykPxG3lBE
	QEBrM4+wRsWvTjTwu5M=; b=q4HQRJ/u+U7QpQQLtsSuVwHRxpJh96vDHeu97jSS
	eR8ih9rBrAUTfzVd7owZKflZ8n9G0UQHsMiiuZOsvS0kb9mVbviw+8DUtl+MZr0B
	CiiO/YlhiU843CBxvHoGK0X9Mfu1lZfUWWQk9ql6IKPJWROPcKHtoQ/9J5oVAGMj
	+SIafgRxf8qIci5zDYSJumdqwLvx9s1KrSiuJXy85VdGBZyzsNVzRIkvK1UP7RfS
	i8HLACzpoQCBxlmms+n+eBC0RPU+3OKDmTe1QFa/s6BBS6Dv9GErBU1sYekhH6q0
	/6WABozyqX14qlEe8bGJGwOIU6WizZA4NucDfDdA3nO7WQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Qqv9L-rhe8XI; Wed, 18 Mar 2026 20:38:28 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fbgdP5gRHzlfvpG;
	Wed, 18 Mar 2026 20:38:17 +0000 (UTC)
Message-ID: <606f995b-642e-41e3-8c3b-a9f02ef425e7@acm.org>
Date: Wed, 18 Mar 2026 13:38:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
To: Marek Szyprowski <m.szyprowski@samsung.com>, peter.wang@mediatek.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 avri.altman@sandisk.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
 <CGME20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a@eucas1p2.samsung.com>
 <1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
 <df1d0b3f-6822-4c49-aeea-fc513e2b05cb@acm.org>
 <1b9db59c-f736-4c59-b37a-15a60cfa4f3e@samsung.com>
 <364d15bf-8d11-46af-bbc6-b4ae45618bf5@acm.org>
 <c9b421aa-baa7-4609-b665-226f894f5114@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c9b421aa-baa7-4609-b665-226f894f5114@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/26 12:32 PM, Marek Szyprowski wrote:
> I must have mixed something while calculating offsets for addr2line. I
> checked again and I found that there is already a script doing that.
> I've recompiled kernel with -Os (assuming that this way less code will
> be inlined) and this is the result:
> 
> [ ... ]
> 
> # ./scripts/faddr2line vmlinux "ufshcd_sl_intr+0x50/0x598"
> ufshcd_sl_intr+0x50/0x598:
> ufshcd_uic_cmd_compl at drivers/ufs/core/ufshcd.c:5570
> (inlined by) ufshcd_sl_intr at drivers/ufs/core/ufshcd.c:7144

Thanks! So it's the guard(spinlock_irqsave)(hba->host->host_lock)
statement. Not sure why it triggers an "invalid wait context" complaint.
Is CONFIG_PREEMPT_RT perhaps enabled in your kernel configuration?

Thanks,

Bart.
