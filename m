Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDA731BC92
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 20:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758055123; cv=none; b=X5VUU3x+ugCec59VGrpSg8k3QnwtfJhA4MdGv0UPgT12DaAaQGtrFTv6lpv8LQiMRR9raztquUQr+QQssWP6If3qYXSN2T+IoRfMPDdLDgQ56ZeaCdy+ObS4nU8V/jOsPb7d/nIuy9guGtEZJm/aMjsbh1XWjA0xuaOSH8p/dNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758055123; c=relaxed/simple;
	bh=Qmkr4PameRO6Gj0BhyEO9IBW1PlDni9y50GtpXgGVcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y+ftb1Wy/NL+51Ff94uGvbp6EvB70Xgk3BwMPLmDiu4DYCVHNVC18EnYdd18Prrog13sK2Jd/3PFSkKLd3MUkTwLh5ml9JXgLDp5Q0Ov0Uz0td1EijJhSYbFut41MvfflRDS95dP8X+/jYadw4PQpI2uKrxy8NasFEZnF1I/7WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=u54iwdLs; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="u54iwdLs"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cRDJJ2ybMzm0yVk;
	Tue, 16 Sep 2025 20:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758055119; x=1760647120; bh=JuzGTlY4Jc9N4NWm26N/d7dE
	Qtmyk28Fxl26dy3t/1w=; b=u54iwdLs0mSxlat4WRcXRjvoJxXkOmoX/pU+LKRA
	APmO3j1s3z4mXSbbBdFm3oGT1arZsIF/iPJpsbZwyHoh8XcqlDeYevgsbt+7EQp1
	LGkQIbbdH2S8mLMyNW5mE5CsoGv0mNGL2vsVxnb8RZrkyqvuyg60qPz0iwJL4X7o
	BQxJ+BWHuYsjOub+ohsUBrn1ARYbZzYrl1LpetzhIJvVu8pDlgmCtiPu/BZRuGhQ
	qfAcNeklfZ4DbccuxALHTxKTczAbYMo6KQOjjzef3IvHkjhZk4CaJpwI1V6ooyiz
	wR3EmJe484GYzttH0le/d7jAbh4lLyl1Sl5mUNOPggUQYg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id z6Pno4jsO7HL; Tue, 16 Sep 2025 20:38:39 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cRDJC4Ntdzm0ySc;
	Tue, 16 Sep 2025 20:38:34 +0000 (UTC)
Message-ID: <6a572ec0-0b28-4b76-b782-ee1f304ad0cd@acm.org>
Date: Tue, 16 Sep 2025 13:38:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/29] scsi: core: Make the budget map optional
To: Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-4-bvanassche@acm.org>
 <aabc487c-ced6-499a-8231-6fc4866c12f9@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aabc487c-ced6-499a-8231-6fc4866c12f9@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/25 1:34 AM, Hannes Reinecke wrote:
> On 9/12/25 20:21, Bart Van Assche wrote:
>> Prepare for not allocating a budget map for pseudo SCSI devices by
>> checking whether a budget map has been allocated before using a budget
>> map.
>
> Strictly speaking it's not related to reserved commands, but rather to 
> cmd_per_lun. Wouldn't it be better to introduce a way to disable 
> cmd_per_lun (eg by setting it to INT_MAX or somesuch), and then disable
> the budget map when cmd_per_lun is disabled?
> 
> Other than that I really like the idea of being able to disable the
> budget map. I always wondered if we won't be better off with dropping
> the budget map for HBAs with a shared host tagset.

Hi Hannes,

There is a cmd_per_lun member in struct scsi_host_template and also in
struct Scsi_Host but not in struct scsi_device. I think we need a
mechanism per SCSI device rather than a host-wide mechanism.

Although adding a new member in struct scsi_device is easy, I prefer to
add a new function that checks whether or not a budget map is necessary.
Even if a new member would be added in struct scsi_device, such a new 
function would be necessary anyway to decide what value to store in that
new structure member.

Thanks,

Bart.
