Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EA615D1
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 17:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718990620; cv=none; b=QdWAqqnqm+qem5YkRUGm6jsh/63s7/R4/HLEkFQ3ultlk7fpyTYSp0hBPWdrr15VfIYtn9nFCGQywMRgLj63QpuVyulnLkor+NaTUjkxTpv5tvz+Uxfjugyef13wrQHo4m912RpR0HSW2zWLbmvOWgOazBwAk+CkQekFLJNnfN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718990620; c=relaxed/simple;
	bh=Zpi0wh+tWrYNHthaMTYNJKPPZxb5w9cCXftLqol1XNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t86ncZavDm47oILX82EvdxpNWb6aEGGn/eiXhjiuvOC6v+Xt1STYDS2n35uKBxHqNJJDbIblazMFkBIcnMxh7GGmlKzzhl+x6M9RctFX3yJE5QjlDlj47XKoxGKfHqehv0QocXTk2YNaqa6SXxE9GQeOnSClrOH1UakfUez0HTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4nsA0Wyw; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4nsA0Wyw"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W5PMs6Q9Bzlg9gS;
	Fri, 21 Jun 2024 17:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718990615; x=1721582616; bh=cp66MC6Ub4lCJqmycW2qYCzS
	kvRxyQ88YIlZ/a7y/MQ=; b=4nsA0WywUwG3xHSwxhB4MtjVzzjfCZpb2L2DS2ib
	EG7xIBSQUNK3z4ch/lG+7zM01Fhwoafnoa+nWfHJGc6+CZY3CfQeCHRSSKM3EpTL
	69u4D6Os2QBSGR+uFNBgKHC6WmpUR+kGE/ZKs52wLt3n58Ox3qCU/sJoQ21XaVve
	DDYN5hsZU8MOOWRa5Qyn49aU4AdK2OmacY5bIsH0czVrZ8WDzfc7WwGTnMg/3hhc
	ONY1zhmT/mZY2zblw9HXmFBxxMeultJGnAasEKzxNOKA1iK5FmoCHJtjpsD8hA3l
	LYD16JkdqmgGleT+6uvdH/o55hyeiGsrBSGlaNO57F1Ehw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id P_DRjePoHo7k; Fri, 21 Jun 2024 17:23:35 +0000 (UTC)
Received: from [192.168.137.167] (29.sub-174-194-195.myvzw.com [174.194.195.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W5PMn6B9dzlg9fv;
	Fri, 21 Jun 2024 17:23:33 +0000 (UTC)
Message-ID: <1f7dc4e4-2e8f-4a2e-afbb-8dad52a19a41@acm.org>
Date: Fri, 21 Jun 2024 10:23:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-9-bvanassche@acm.org>
 <054eef8dec43e51aec02997ad3573250b357bee2.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <054eef8dec43e51aec02997ad3573250b357bee2.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/20/24 11:54 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
>    Unable to handle kernel NULL pointer dereference at virtual address
> 0000000000000194
>    pc : [0xffffffddd7a79bf8] blk_mq_unique_tag+0x8/0x14
>    lr : [0xffffffddd6155b84] ufshcd_mcq_req_to_hwq+0x1c/0x40
> [ufs_mediatek_mod_ise]
>     do_mem_abort+0x58/0x118
>     el1_abort+0x3c/0x5c
>     el1h_64_sync_handler+0x54/0x90
>     el1h_64_sync+0x68/0x6c
>     blk_mq_unique_tag+0x8/0x14
>     ufshcd_err_handler+0xae4/0xfa8 [ufs_mediatek_mod_ise]
>     process_one_work+0x208/0x4fc
>     worker_thread+0x228/0x438
>     kthread+0x104/0x1d4
>     ret_from_fork+0x10/0x20

Hi Peter,

The above backtrace can only occur with MCQ enabled. The backtrace I
posted was triggered on a system with a UFSHCI 3.0 controller (no MCQ).
So I think that the backtraces have different root causes and hence that
different patches are required to fix both crashes.

Thanks,

Bart.

