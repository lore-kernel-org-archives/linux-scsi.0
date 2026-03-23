Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030833C73E1;
	Mon, 23 Mar 2026 17:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286971; cv=none; b=NJBEzUbrt6kbIzvSSHSjIYc/cwnQx8O0efqKQ4xvbO9oKO2SvFOei1bVEaaQERaaPBgNEImi6Kgm/hV7jHQsw1qhdTvL/OCowgbDuiBoaWdgKNoFbXk/UDsrbc2elpxQUWQkBt2aEUwPbQ31GLF54/vdwnmLG0WwaXy73bknOQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286971; c=relaxed/simple;
	bh=tE/nW885Fta9ChR/sCQ5sRJTBK+uCULLDZeYFW86k74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kxlGD7XYKW6GhDDMmYkXo8rCOiKRMWZPUVa6/e5i0EafHmBE0ZMuqpOzfPMsTiIZMOp2wAxLhj6KMcSKyX2EqinJHhnxLCNQNevtmpp4J9SVf8epzaMn3r8I2gQhol8vmxyVoXz3QUoVYBE0gZa+ilfkvY5iCNvXRni9p+h/Tes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3j1XwN1P; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3j1XwN1P"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4ffgCF3LC9zlfpM9;
	Mon, 23 Mar 2026 17:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1774286965; x=1776878966; bh=tE/nW885Fta9ChR/sCQ5sRJT
	BK+uCULLDZeYFW86k74=; b=3j1XwN1PMOjxAqF1umTrHWiJSNCChKatORHGjjBX
	g6M8k50Wlkg9WjpbcH/bY3p7dRtYwimWfxIyMTa43vfTz2Lmgkul9JcGkQ8hxRTA
	lQiwRQpVlw6kskYIoKYgnhbdhUZqnH5Ml38VQ27EpasilQJHDoTdQ/0mHNqE/YiK
	fLmzG2RzpqQ2j2krcSKKe5HY3NId7M9mQC6yOMLChBnFRH3GBN0SFwBJpXjSsKx/
	pR90xxMy1XDWe/oLxuayEl5gdJ6+DQcd8VwhVta7ajbaZsCkXFKLOUTeBuq3AJCF
	ueSl7JuzHjuhsvKBFnUjNAba7jG5AFO0/YVJvwU7nQWp6Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TGYs-ByuMFAE; Mon, 23 Mar 2026 17:29:25 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4ffgC727CdzlfvpM;
	Mon, 23 Mar 2026 17:29:23 +0000 (UTC)
Message-ID: <29da71fc-b371-4869-9635-3b8d9b88fcfc@acm.org>
Date: Mon, 23 Mar 2026 10:29:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Add a vop to handle vendor specific ops
To: =?UTF-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= <hongjiefang@asrmicro.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20260319093839.1854051-1-hongjiefang@asrmicro.com>
 <64cc22ec-4d43-45c0-b63f-0401776f79a7@acm.org>
 <dc22d720deba4ce1b1c7aa229a685911@exch02.asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <dc22d720deba4ce1b1c7aa229a685911@exch02.asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/20/26 8:34 PM, Fang Hongjie(=E6=96=B9=E6=B4=AA=E6=9D=B0) wrote:
>> On 3/19/26 2:38 AM, Hongjie Fang wrote:
>>> add a vop to allow some vendors to do some additional ops
>>> for some interrupts if necessary.
>>
>> UFS patches should be sent to Martin K. Petersen and should be Cc-ed t=
o
>> the linux-scsi mailing list. Additionally, a patch description should
>> not only explain what has been changed but also why a change is being
>> mode. "to do some additional ops for some interrupts if necessary" is
>> too vague.
>=20
> Given that some UFS controllers have private or extended interrupt stat=
us
> registers, the purpose of this patch is to facilitate the handling of
> proprietary registers within the host driver during the interrupt handl=
ing.

The above makes it clear that this patch is intended for a UFS host
controller that does not comply to the JEDEC UFSHCI standard. The Linux
kernel is standards based and the upstream Linux kernel UFS
driver is for UFS host controllers that comply to the JEDEC UFSHCI
standard.

Thanks,

Bart.
