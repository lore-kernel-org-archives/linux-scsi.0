Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4F415ECD7
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 17:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722880581; cv=none; b=TDZRt5mitWIIgYKIJbbGbeIGyEgE7L8LLdq8Kl8AiAQQJZUTtSL5r7RWdEornEuUiXak5vcMT0cY4MgxrfjTYDG4Jxez/zzlua0LaAOH+EUmIv3CNIyVpcIcgD9rQPt4yVRz1MNF5K+cTpXdjLYytYcH8hgozJBkTIKrBRFxARg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722880581; c=relaxed/simple;
	bh=wklGR4P6llnlwJAEM1kJVRqoMPK7VOcmulp7AgFLPME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SuIR3gmN1oGe5und5+TqOtqFr7uywfEcS8Q/mbrZ9p1KiFk1z4vLvf2YqjIInIXlHgzSwdzvdYcrXt92aTVYkqUBYUIzx4GPE0veAMKYoHB8TZJqXj5JcuEWDMy6a5kQPAZysBEdtwLguwQNU0WMSBIMgo+sZ8TypDtAQvTtm6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=f56vJK3+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="f56vJK3+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wd3yp6lYPzlgVnF;
	Mon,  5 Aug 2024 17:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722880575; x=1725472576; bh=g/qh65m3PMTGMgodY8MaiWre
	oPFbZM5PAMepSOE01QE=; b=f56vJK3+3QC66cyCD7qODxS+p/wWET/xjjgNtmZ9
	E5dM1E6t6RYCVRquZl+/GcfF6oSC5zBsLHdWTX4PNaihzyMYk6ies+/26PnCoubE
	Ia7mqwoz4g1fL1Kp6pCgFBKU/MvN7QKbr+wWDFuHt1RXyebe8LMEdNd1se8UC6ow
	f08t8FaVUBkMweIrSEhXyf8CVJisrBIYfghCCqNtYRJ4s2P2Gfpf6e5YAPzMQNuX
	uuz4ZabonhI+npHuBRbVKw3TKxvLSUmnIKr8B6P6uMUahxtl0OMMPaf+QDsLcBEH
	C/UZCo18iLk03F6ed/TReIM9kz9ow6aUHrmhtW5S/VJgIQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Y-lpCBYAMYpi; Mon,  5 Aug 2024 17:56:15 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wd3yl0ZW1zlgTGW;
	Mon,  5 Aug 2024 17:56:14 +0000 (UTC)
Message-ID: <c749f7f5-dafc-485b-8c7e-d0453f05dc27@acm.org>
Date: Mon, 5 Aug 2024 10:56:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RFC: Retrying SCSI pass-through commands
To: Damien Le Moal <dlemoal@kernel.org>,
 Mike Christie <michael.christie@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <b0f92045-d10f-4038-a746-e3d87e5830e8@acm.org>
 <2addecad-bad3-41e2-a8c7-ee68f3c471bf@oracle.com>
 <f931edd1-ca89-461f-b242-b5d33fe6ca37@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f931edd1-ca89-461f-b242-b5d33fe6ca37@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/5/24 10:47 AM, Damien Le Moal wrote:
> On 2024/08/03 13:42, Mike Christie wrote:
>> Do you just want to retry UAs or all internal passthrough command
>> errors that go through here?
> 
> I think that we definitely do *not* want to retry all internal commands. E.g. I
> do not see the point in retrying INQUIRY or VPD page accesses failing on device
> scan.
> 
>>
>> For just the specific UA or NOT_READY/0x04/0x01 case for an example.
>> Does every scsi core passthrough caller want that retried? If so, then
>> I can see where you are coming from where you feel it's a bug. I would
>> agree we would normally want to retry that in general. Maybe others know
>> about some specific old case though.
> 
> I think the command Bart had a problem with is START_STOP_UNIT. If that is the
> only case causing problems, then we should probably improve
> sd_start_stop_device() to allow retries. But if there are more commands that
> needs the same, then the patch that Bart is proposing makes sense I think, but
> it will require an audit of all REQ_OP_DRV_XXX internal users to make sure that
> they all use that command with -> allowed set to 0. But hopefully, most cases go
> through scsi_execute_cmnd(), which should simplify this audit.

Thanks Mike and Damien for having shared your thoughts. I only need the
START STOP UNIT command to be retried. So the lowest risk approach is to
introduce a mechanism that only causes that command to be retried. I
plan to look into this and prepare a patch.

Bart.

