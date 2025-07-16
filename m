Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA371B394F
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752678153; cv=none; b=N/0ZxEO365g54CIq9F66EpZw3msziTibsIpVwnYUm7tjdsVKCxlxQkkbV+6w9D/XNVdHP+nHLCxgWY8C5TdZ3vjzdrle+Iusly7G4/weCfXQJqy5YTvTovo2XBXZ/Iy1gBMgaIE4rkb7QotYJpvE/wb6JdpgCpQPytwnwpBmk6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752678153; c=relaxed/simple;
	bh=2RQvjwEXVO+1IpIKg7Zo8FR75v7tXkozLfJ856+crIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=d2K6uA9RyXnxv+/wRlLDZALO/QxrchIbDF1WmXDAbP35PY//hRMZY/puIf9GpSkrfdfDAhb794bVVVyJjfxfshzdvQ5062QOTB6G8YtxFYE6hNE0lrY2SET3FCqdy2RMfvS3uNmim+1UbThRnUzPI348yH7cqAiI8MEsGMhBdFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g+apPgQS; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g+apPgQS"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bhzn15ThmzlgqVP;
	Wed, 16 Jul 2025 15:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752678147; x=1755270148; bh=G1f0VSQCWl8cPd1KFbOKW0E9
	eSPmYLyNxp4EZBEGCy8=; b=g+apPgQS+D3EqXGDBSwX7kGTQk65tjWAAberaAJt
	Nv7DQEKO1iBhC8xnBEja78pBsSiGl0eCEy7+9meewfv4QeWGKLhgxXPMpaPvhmf/
	yOwrfii7kw6GeEGYNirPTMYdjQPy4VG5BN+KwPpF9s3t4eWjoBc5rsFSLIF02UqJ
	ELqu4f1cGKlSaEycoJpHh2Z6GSuWwVcPF9ww3NALGX2zvXw2zoB11OYgEES85+xh
	Vn8kowLIleboh0L9ep67YSCnAUTHMPg6Bk48DHM3odjjP2xfuSmkqUtZM79/5pex
	L9I3T0NgT2SUSVMdou8WpfL7HWVTkrUIiEJdOz5ErhDRww==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LCYG4Dm2wd0j; Wed, 16 Jul 2025 15:02:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bhzmt3CmjzlgqVd;
	Wed, 16 Jul 2025 15:02:21 +0000 (UTC)
Message-ID: <17855171-b7d2-43ff-ac09-955966563b4a@acm.org>
Date: Wed, 16 Jul 2025 08:02:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
To: Bean Huo <huobean@gmail.com>, Seunghui Lee <sh043.lee@samsung.com>,
 alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, sdriver.sec@samsung.com
References: <CGME20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b@epcas1p2.samsung.com>
 <20250714090617.9212-1-sh043.lee@samsung.com>
 <b8fa773234058e68e6006127b3cd848046b75e6f.camel@gmail.com>
 <000901dbf52f$63a69090$2af3b1b0$@samsung.com>
 <cd0959939d2fefe927b66ca12620c094c4cfb7a2.camel@gmail.com>
 <005801dbf61f$7287e7d0$5797b770$@samsung.com>
 <00f301dbf626$2b2a1550$817e3ff0$@samsung.com>
 <ff93d49524dd1b79968b690753a3727e695f852d.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ff93d49524dd1b79968b690753a3727e695f852d.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/25 6:35 AM, Bean Huo wrote:
> But, the problem is dd11376b9f1b ("scsi: ufs: Split the drivers/ 
> scsi/ufs directory") reorganzied the UFS code layout, it is true
> that not easy to add a proper tag,
Full history of the UFS driver can be obtained as follows:

git log -p -- drivers/ufs include/ufs drivers/scsi/ufs

The above command shows the UFS driver history back up to the commit
that introduced the UFS driver, namely commit 7a3e97b0dc4b ("[SCSI]
ufshcd: UFS Host controller driver") from 2012.

The double hyphen suppresses complaints about paths that do not exist in
git HEAD.

Bart.
