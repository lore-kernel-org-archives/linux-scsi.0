Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310F9375F8B
	for <linux-scsi@vger.kernel.org>; Wed,  1 Apr 2026 15:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775058703; cv=none; b=Y/m8tYu1xjacDpV2ktPmdVmeig3QE9JhPOSZvFqy++uBTYFLQOd6r+HmT1D8i15vGvU4Uw9sDCoxWXydAK5WnDMOagx5LSsxpBd4rfuzZa6PADhg3uscSscVWZiRSlkh6uqigDHhNgVcWH5UXLkvc3F8fwYKWnmCpprUuBWf5fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775058703; c=relaxed/simple;
	bh=TbadTCMy1uYaO0hk/VFF0nDHgPs6EKwMUoe/HyP89iE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C0mfNuGjSisSnV/N1iQ2UszO4geF8GrpM+s8xg8L/5Ze6KbqKwhDoJhY/hb3/DqIWlZtfQG51lifRc+j/TC/lrRPuOEEwIEqRSxkj2jqArov7CFRA6xTTNPlqBXc0mt/ilLFFtpgpzDTD0vMYMZO3q2IT4FdicYG2r7z/u55BM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QHXRYF+H; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QHXRYF+H"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fm8cF4YhLz1XM5kW;
	Wed,  1 Apr 2026 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1775058694; x=1777650695; bh=TbadTCMy1uYaO0hk/VFF0nDH
	gPs6EKwMUoe/HyP89iE=; b=QHXRYF+HPURY72M7uFTDic+jECiFMJ5eUXhu59xb
	BaNRyhulu7rN0TwfLRwrW8Gz+pUmDrrnx0cyjG8Cib/WlZWBJ1uHqpCUd1Qm0/wn
	1lvAyoO0eZEcXZjqZSGuLfwKwQWVt0nGO8umsTgksFrFRmooHPgsSM9gRjJuqSnW
	8O/+xKoPjZlehXnT6iHXgCJFHaUdXIvf+lmKRNVY+1Qdom5LRpsgktdJRflPMx1V
	GePnXdWJDH8XHZBf7BtPRAms4rHsQk4kes/iQj/pU96T3Uhhy3DL7tRtcnTTdcC8
	MV/fPw9dKR2Tv5c/qwEA9ZqJZuo238QzUynAM15omR/v/g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 65yfnuVZyJZQ; Wed,  1 Apr 2026 15:51:34 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fm8c074BQz1XMFk2;
	Wed,  1 Apr 2026 15:51:28 +0000 (UTC)
Message-ID: <7e700ec6-3c91-4afe-ad1f-1769c23f8c6b@acm.org>
Date: Wed, 1 Apr 2026 08:51:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ufs: core: Fix ufshcd_mcq_force_compl_one()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>,
 "vamshigajjela@google.com" <vamshigajjela@google.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
 "ping.gao@samsung.com" <ping.gao@samsung.com>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
 <20260330183311.1941942-2-bvanassche@acm.org>
 <4685d17dbf09397aef70c2e2b84ee13f1c48d4cd.camel@mediatek.com>
 <6f4d9e81-b300-4603-9032-e2604c0b099f@acm.org>
 <4a4f2054634ca20195467c0869ba88251b13e107.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4a4f2054634ca20195467c0869ba88251b13e107.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/1/26 6:10 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Yes, but I'm curious, will processing all entries,
> although inefficient, really cause any problems?

I will drop this patch because I realized that it is too risky.
ufshcd_mcq_compl_all_cqes_lock() is called after the host controller has
been disabled. ufshcd_mcq_poll_cqe_lock() reads the CQ tail pointer=20
while ufshcd_mcq_compl_all_cqes_lock() does not read the CQ tail=20
pointer. I'm not sure that it is safe to read the CQ tail pointer while
the host controller is disabled.

Processing all CQ entries in ufshcd_mcq_compl_all_cqes_lock() should be
safe because ufshcd_mcq_process_cqe() marks a CQE as invalid after it
has been processed.

Thanks,

Bart.
