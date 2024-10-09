Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E18D17BB0C
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 22:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511437; cv=none; b=fzPCmwQz9ywA/+P7X1UClEkh/MtMVNYQCQvs8Nteu0KddEAIhY1GpDzjLvUbgJehmjG2oaS4LzpI9HJgQ8vk5CpiLXGYhvW0UPaDtE6UmJPkO+in4CAWyxiKv8naw8aHEQyTzy817uy7BT27dZ1obnOtueVjBprDWs3i4KarU14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511437; c=relaxed/simple;
	bh=o7LxpT57A+pT2FPYJChmw9k2SpgcJXrLdWqsU7je6eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R0kvUSAiaIv4sFNO+uczO28BsGanqXc6yDVUThiVn0lxbHzBOQCiRWeaCiZV+xOWa2tX94SW29sSa9hb/3s4MUA/QrsMkDqLufR9sCFbQmnCOC/P0VaKCqyWK1AtukdCh7yvx19LemA1U1Eys1pPpAW+PrKSU6onCkJ+wI+aJkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OO/r2PPo; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OO/r2PPo"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XP6NW2dyTz6ClSqw;
	Wed,  9 Oct 2024 22:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728511430; x=1731103431; bh=o7LxpT57A+pT2FPYJChmw9k2
	SpgcJXrLdWqsU7je6eU=; b=OO/r2PPond8AwE+7ZYPtkSAY0Jnhcmk7LigGhfAv
	WdLHM1yoTR6XbCo0aKEESnfdWHLzxoGHDh9sBYUpraDuwjECq9nBbD/WldlDB/MQ
	k+pAkWa5hQKnGVM9DKOZ2PmhwbiTHOeOxvpny8BNi/UWZJJ2sPVKxvlQdnSvSrFd
	OsKjSY7ajZGFiQ3B+G7XNhReMxZLAdV3ASQFLokm3GrHajIyyHICvrU7R6BZYjcH
	Ua4s6QqFEcFt87T0ITKFhDBf1UACJYvubwq9znBxlV73fztoP/JiugDCmpPIWGI7
	eyX98BUsT18/cGUObEcZhDZhEkI/kDQABbJyXOqxOsQaHA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3iG6zEIK79RI; Wed,  9 Oct 2024 22:03:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XP6NM62LMz6ClY9y;
	Wed,  9 Oct 2024 22:03:47 +0000 (UTC)
Message-ID: <97669592-3dd5-44d2-aa95-582cc53d5f7c@acm.org>
Date: Wed, 9 Oct 2024 15:03:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/10] scsi: ufs: core: Move the
 ufshcd_device_init(hba, true) call
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Eric Biggers <ebiggers@google.com>,
 Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240910215139.3352387-1-bvanassche@acm.org>
 <20240910215139.3352387-7-bvanassche@acm.org>
 <7b1e932c-45e5-29bd-5361-e88642b27e86@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7b1e932c-45e5-29bd-5361-e88642b27e86@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/12/24 10:29 PM, Bao D. Nguyen wrote:
> On 9/10/2024 2:50 PM, Bart Van Assche wrote:
() plus the time wait for
> async_schedule(ufshcd_async_scan, hba).

The above comment is not clear to me. I'm not aware of any code in the
UFS driver that waits for the asynchronously called ufshcd_async_scan()
function to finish? It's not clear to me either how the time spent in
ufshcd_add_scsi_host() would be included in the trace print?

>> +=C2=A0=C2=A0=C2=A0 ktime_t device_init_start;
>=20
> IMO, it's kinda overkill to add this device_init_start member for the=20
> purpose of trace print the time spent in the first probe_hba() only.
> How about print the time spent in probe_hba() outside of the=20
> ufshcd_process_device_init_result() function so that you don't need to=20
> pass device_init_start into ufshcd_process_device_init_result()?

I will remove the above struct ufs_hba member again.

Thanks,

Bart.

