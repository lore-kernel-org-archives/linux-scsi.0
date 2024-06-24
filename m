Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF38C1A2C0E
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jun 2024 18:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719252771; cv=none; b=eYrr5N/tZXqrveAd3i6G8se9KBKex+ohxRKNEBDhdzP4kHaq61jvK7Nf+x2cFkvxWdmZRH//08g2peoFFJHHE1gyLovD0VRc5CEqryvH9sIJ9UpYFwRl/XL2TBJ0ZpoDu9j9EENIi1NSyO7RPsv1Us3BMCQzBLnhbRJF6DtO4hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719252771; c=relaxed/simple;
	bh=F6TZnXcDgXrf7yGGO95czmlNbi8NDRGhQAqY1tEiGKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FfFOobuPkX8hj49PxG6jXRYR3KJ7s64LbXNFErlX+XP3/v9Fip4nnlLZu3ZPsoJU0Z6QzjGYYwwVQXGwTHOEbBE2yvB2RHoO4WNDB96hlhG9ROX1leXuAYSZilxFpvb8mMJZmkqbqImLRUhrQBvSNpgMbEfa9qMjuIF3FKeZhWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hnsSR/Xc; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hnsSR/Xc"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W7GKD6lqczllBdk;
	Mon, 24 Jun 2024 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719252766; x=1721844767; bh=Oc3FZTTG9yOooigM0FoFM3lr
	z0pUvKSgqDVCaL55aJY=; b=hnsSR/XcST669n1Vg/41fucgNhgK69yoG2rZzG5i
	KBOuerzekb5nfxelVRhPIQRl6nb7wWXM0R0a/CQgoFBt8zSPFXyxhjZqkmcUXcy+
	Gnz6MSLVBIsl6wXnro/xdIDdpdAvPUsKebsc/EHXKzLJ7A5IvMN6IrRJsDhObMyn
	lUuwbbIf5WYLvWfeRE7FSZD1BGJBCMkO0mBZScqDeaOiiMpjyPnDXYhzVa2w7GFy
	CFQEKoDOCfm8ZQ6CAXWaaT9kMnTmYYBbWc5vel1qJig2hXmE/0uxv3/0mgxwPI6x
	QMAL/oO94wXs7j6Hzp6uXgb/0nxXeEG7byT4LcSi8VGvRg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SfoDSW-JQHR7; Mon, 24 Jun 2024 18:12:46 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W7GK83wB2zll9c9;
	Mon, 24 Jun 2024 18:12:44 +0000 (UTC)
Message-ID: <671bb45f-22a1-4f81-ae93-65bd5a86f374@acm.org>
Date: Mon, 24 Jun 2024 11:12:42 -0700
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
 <1f7dc4e4-2e8f-4a2e-afbb-8dad52a19a41@acm.org>
 <d6d329a3d822cb34c8a5bee36403c59ceab015a0.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d6d329a3d822cb34c8a5bee36403c59ceab015a0.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/24/24 1:54 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Your backtrace is Single doorbell mode. But I am curious that
> how could it happen if complete a cmd twice and get null pointer
> next time queuecommand? could you describe the exactly flow?

SCSI commands are completed only once. See also the code in the SCSI
core that sets the SCMD_STATE_COMPLETE bit:

$ git grep -nH 'test_and_set_bit(SCMD_STATE_COMPLETE'
drivers/scsi/scsi_error.c:362:	if (test_and_set_bit(SCMD_STATE_COMPLETE,=20
&scmd->state))
drivers/scsi/scsi_lib.c:1716:	if=20
(unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))

In other words, either the regular completion code is executed by
scsi_done_internal() or error handling is initiated by scsi_timeout().
Only one of the two happens.

The only exception is that .eh_timed_out() may be called concurrently
with the regular completion handler. Hence this patch for
ufshcd_eh_timed_out().

Bart.
