Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CD918A6CF
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 15:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753716917; cv=none; b=SXo6RUpuy4FaYi0r/jgUjbQVwlObqTZCNyTh6s36jOMgrs8HseNpQz2CBE6jX2Ph5NiLwk20XiMXvgKT82RwhDM5o1E+23d5kmUv/W9HN1o3XfH0NmC5M01oG3NtJyp1C6vBPegLVs6hdDzTemy8fv1yrvKeBFxbg7IMwB93FgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753716917; c=relaxed/simple;
	bh=+QjAd91vpUVG8XtawGyub1dar+Gsf65UZz7UWO3lRg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=M0yPOowHswXZdPhLgDFgUERw5QsWpUu0KREKVYiu9QPqxOydJP1MWnaP2nnIw3ChwzNC3sD40D0FHTihuOHXPtkkradO6K3+B4lJi5Qj+0/TdwJc7sx7o7QBj9bntHG2/g8maAkJkXjH4cPJe4s3tir/1Xq24u6LIxvEuNoARV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Grq7mAkP; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Grq7mAkP"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4brMxG1mT0zm0yt1;
	Mon, 28 Jul 2025 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753716913; x=1756308914; bh=qU5aXWssd6xUuf2MR4MV44CQ
	zdmfJc0Jl5ab2n6IZp0=; b=Grq7mAkPimKuOyxfAsHlS395rKXY00MO8/AIehoU
	Wpm4jeojCmCYDHK3nkYKdIGUSI4qpHkZR5LUEHiBQ65g/8ZJfF/j5OlDp1+EOZ9u
	YqjAL4TTTBEmJvnhdznZ/2hS+EXbEk1ByatduKqg6YR6t4Vxbuuo2Y/7Buppg/sn
	5Y4BAujMbD1ZotExT3XDYg40wcGMKkN77d0iZ9f+R32+cnOv3bm0dLUQZWmxiteT
	UHnuf+Q2AjYBZuQwrtbglDh24b+BPLmEtBhG+/ecQcCYse8jlV4cAMjcbeI5ZqLh
	B0jpkjJax+NovV4qFy3qKKX8CXwayG0JaRXHo1oMRcLJog==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id n_cfH4jGiw-X; Mon, 28 Jul 2025 15:35:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4brMxD1m4Qzm0ytb;
	Mon, 28 Jul 2025 15:35:11 +0000 (UTC)
Message-ID: <23ca2980-d097-4f1e-80b4-ca383ea47118@acm.org>
Date: Mon, 28 Jul 2025 08:35:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Patch [0/3] Support eager_unmap for non ldpme sd devs
To: Kurt Garloff <kurt@garloff.de>, linux-scsi@vger.kernel.org
References: <936a460e-eacd-40a8-834a-76021bf3ce8c@garloff.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <936a460e-eacd-40a8-834a-76021bf3ce8c@garloff.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 7/27/25 11:06 AM, Kurt Garloff wrote:
> Hi,
>=20
> (Resent, the original message was not text/plain only. It's too long
> that I have interacted with linux MLs, sorry.)
>=20
> I had to do some rearrangement of NVMe drives over several of my
> machines recently. I was using a few USB NVMe enclosures for this.
> One of the things that was annoying was that I had no way to discard
> free space using fstrim (or with blkdiscard or mkfs / mkswap options).
>=20
> The SCSI disk driver (sd_mod) would just claim that discard is not
> supported. It's not true. The NVMes support it as do the enclosures.
> I have a few, though all have variants of RTL9210 chips.
>=20
> But sd was too conservative to let me do it.
>=20
> Attached series of patches address this. (Patches are against 6.16.0-rc=
7.)
>=20
> 1/3: Introduces an eager_unmap module parameter which lets the sd drive=
r
>  =C2=A0=C2=A0=C2=A0=C2=A0 unmap/ws16/ws10 capabilities and issue these =
commands even for
>  =C2=A0=C2=A0=C2=A0=C2=A0 devices without ldpme support (thin provision=
ing). The VPD pages are
>  =C2=A0=C2=A0=C2=A0=C2=A0 being queried for all devices advertising SBC=
 >=3D 3 to avoid breaking
>  =C2=A0=C2=A0=C2=A0=C2=A0 old hardware that might barf of being asked f=
or VPDs.
> 2/3: Makes the approach more conservative by guarding the requesting of
>  =C2=A0=C2=A0=C2=A0=C2=A0 VPD pages also on eager_unmap being set. With=
 this patch, the default
>  =C2=A0=C2=A0=C2=A0=C2=A0 behavior is the same as before the eager_unma=
p patches unless the
>  =C2=A0=C2=A0=C2=A0=C2=A0 parameter is set to non-zero.
> 3/3: This changes the default of eager_unmap to 1. It should be safe ba=
sed
>  =C2=A0=C2=A0=C2=A0=C2=A0 on the SBC >=3D 3 protection, but it's hard t=
o know for sure with all
>  =C2=A0=C2=A0=C2=A0=C2=A0 the possible broken hardware out there. So le=
ave the parameter for
>  =C2=A0=C2=A0=C2=A0=C2=A0 admins that need to set it to 0. In case we h=
ave significant fallout,
>  =C2=A0=C2=A0=C2=A0=C2=A0 this is the one patch that would need to get =
reverted.
>=20
> I have been running kernels with variants of these patches for over a y=
ear
> now.
>=20
> PS: Please copy me one responses, I have stopped being subscribed to
> LKML and linux-scsi a long time ago. Sorry!

Please use git format-patch --cover-letter ... and git send-email ... to
publish a patch series. Nobody looks at patches included in email
attachments. Please also make sure that your ~/.gitconfig settings match
what is expected for posting patches on Linux kernel mailing lists.

Thanks,

Bart.
