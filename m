Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B897432ABC3
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765302684; cv=none; b=VqMAjRJNC7o1Atjkcv37Q2ENsqPBXC+IIjTUxFSlS7hMilQ6ij3vj5hcJCGGD2xKlMNV19LCLd1aAjp8IPTBfOONLwa23TORdgdkyMEVaCEBJdv7g9a4qiJsi1fkPFgxYnkZq4EI2mdaFQsH4JW0TgjBTCXOxhV4ysSW657D1r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765302684; c=relaxed/simple;
	bh=A4GE0kBzfhXALQx3+m3YSlIUWt9OdW0Zh+uceuIPjYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oO1fEPP0sDf7LHxf5JY7lZF2RlOwuJhRGYZk1wbNiifwBwg8hvLs4fNCuVDBT2WCAllB+9+MihRNoEM2OCqLqWAcVFfK9Grjr/7Tqt3KpClvNNWFuwOmhNO3+LGn9/6eWPPgoYxp7WScAThLUVz5l48JXTqr6iK5s/t0RjSe9eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bU9mRjfG; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bU9mRjfG"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dQmcV1BbPzllCmP;
	Tue,  9 Dec 2025 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765302679; x=1767894680; bh=BQcQ2tbj6yXzC6rVxjdmT9th
	RrCh55iMxFtJJnNXPws=; b=bU9mRjfG5st0PW945a8pPXj1gIJULzEM45LlS7qZ
	9Vd9j+EuNw/bLIVFrOt3PPLhQU0TD0uCwc6GPbDtDkZu3QxQDySXNIzhVTrHJu/0
	1uZNEdE6thWxmxsaVO7kQwF+CurW3BzIf2+aToq1QsSAOvIBwH60aPHRyEBv5CHz
	s2v9L1aDL7rj7cTAUelLyEeAl7d7UmpuxW9p9T0HI7m/Z9tJP4DhRwR5BvSVvNFk
	vJujs3GoiAEBnITsBOVbaEnIlC8eVlgiXQfsbAA9Q7nYjsaqFGl1shp46TiGTyDJ
	EaKP6Q6Bn9BanvBE4FJ8eyjNAg8vx9bItAyPjOfKboOVqQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pWFtVnCSdcTy; Tue,  9 Dec 2025 17:51:19 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dQmcM3gWBzllCX2;
	Tue,  9 Dec 2025 17:51:15 +0000 (UTC)
Message-ID: <d6eaf149-a3c8-44d2-bab0-4e7c965e3ebc@acm.org>
Date: Tue, 9 Dec 2025 09:51:13 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Fix a deadlock in the frequency scaling code
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Roger Shimizu <rosh@debian.org>,
 Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20251204181548.1006696-1-bvanassche@acm.org>
 <cem2gv6cz6bxz3i7eogqnbruzbts5jn4ijlu43bt5g2rl5or5p@evrj4kyqovrk>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cem2gv6cz6bxz3i7eogqnbruzbts5jn4ijlu43bt5g2rl5or5p@evrj4kyqovrk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/25 3:33 AM, Manivannan Sadhasivam wrote:
> Thanks for the quirk fix. While it seems to have fixed the boot hang, I'm
> quite skeptical about the fix. What is the guarantee that another device
> management command won't be submitted before blk_mq_unquiesce_tagset() in the
> future? IOW, the developer would have no idea that doing such will result in a
> deadlock as nothing in the UFS code makes it clear, like using the same lock and
> such.
I think that the recent changes can be considered as a bug fix. With 
previous kernel versions, only SCSI commands were paused during clock
frequency transitions but device management commands not. With the
approach that landed in Linus' master branch, device management commands
are also paused during clock frequency transitions. Device management
commands should also be paused because these also use the communication
link between host controller and UFS device.

Regarding debugging potential future deadlocks caused by submitting a
device management command while the tag set is quiesced, a call trace
is sufficient to discover the root cause (echo w > /proc/sysrq-trigger).

Regarding future changes in ufshcd_clock_scaling_unprepare(), I think
there are two cases: changes made by developers who have access to a
test setup that supports frequency scaling and changes made by
developers who don't have access to a test setup that supports frequency
scaling. Has it already been considered to insert calls to
ufshcd_clock_scaling_prepare() and ufshcd_clock_scaling_unprepare() near
the end of ufshcd_async_scan() to make sure that this code gets executed
on test setups that do not support frequency scaling?

Thanks,

Bart.
