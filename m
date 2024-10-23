Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DB01CDFD1;
	Wed, 23 Oct 2024 19:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729712673; cv=none; b=e6na9nCFIjn0rh1jMHSS74rtOi1pcETvh1+HkIE+U7SQvOQs2+Y5nxNFTmFk/Z9XMu4bupPCdPox/6mVWxUgaMG3oo/3eeKEsC7rX0qXNg/tLnK85x8Ab+E377l0FaVAb217I0kP9emQSb8RLdnICn3qUoOapAGp6wsGhNyzWl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729712673; c=relaxed/simple;
	bh=i0lI73iil8ai/SCafkzDPzPhpUu6N0PKolJNRG/Z0FA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ORveRAgLacy/mI1S8nylL+0xMPZz2H6LmMKYZYZVb4TsEVcJOPgwuP1boL7JQPIlzZu8hZ5E9XdWhZanx88VSozV2SnRQ2qmcuLgnDL02+Qzgq5bjZUzlIj343enjy+R6RDZL1XQ1kWNO+qIX+IPViRmtrqv9hFIx7GBS+zeQeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eptLBLIn; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eptLBLIn"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XYfd519PyzlgMVS;
	Wed, 23 Oct 2024 19:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729712663; x=1732304664; bh=96ePSPWif+56Vmt2ETfS76GZ
	7t4oDpkBU2CMla5nUaM=; b=eptLBLIn3cvG7l4UZYDzytI/hw0Ovn2gNGbPSvEC
	dZDiHH9wcEC+pPM9hgeBW4Xa75aP5pF3iQ/fMxJw90+aOMGpD7Lmiw1HObbGgudZ
	bor0K3D6lLuzGputK2dtP8C4M0pOY69ZHHk7ERHj+yzbBnsfyiqDvCI4brU1Mq+w
	oxr0C6PbcDjyKsi+nKwd8AGcrK1vuppbHe7jf4MYoBUaKdlR3z5IdWwb0MId58JJ
	+xb+fESD5CBw14JGsVPB7qNyBdq4sFFfHMyEGuN6e3ajEQh0JVvKKKGhV5y1qzX+
	bc2KtmCXqwFxZWuZ0Y9I9pCUGbGSsTrf5FebjejI0ytE5A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EVPabAS382gS; Wed, 23 Oct 2024 19:44:23 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XYfd33DBPzlgT1K;
	Wed, 23 Oct 2024 19:44:23 +0000 (UTC)
Message-ID: <b43d5e01-cafe-4133-9873-68897439bf5f@acm.org>
Date: Wed, 23 Oct 2024 12:44:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: ufs: core: Remove redundant host_lock calls
 around UTMRLDBR.
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20241022074319.512127-1-avri.altman@wdc.com>
 <20241022074319.512127-2-avri.altman@wdc.com>
 <8e1ec6a0-38db-414e-90da-4d04ea8d6be2@acm.org>
 <DM6PR04MB65750DBFE520C0DDE075146EFC4D2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65750DBFE520C0DDE075146EFC4D2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/24 11:47 PM, Avri Altman wrote:
>> On 10/22/24 12:43 AM, Avri Altman wrote:
>>>        for_each_set_bit(tag, &issued, hba->nutmrs) {
>>>                struct request *req = hba->tmf_rqs[tag];
>>>                struct completion *c = req->end_io_data;
>>
>> Would it be sufficient to hold the SCSI host lock around the
>> hba->outstanding_tasks read only? I don't think that the
>> for_each_set_bit() loop needs to be protected with the SCSI host lock.
 >
> That may cause concurrent access to tmf_rqs?

Right, the host_lock serializes hba->tmf_rqs[] accesses. Without having
analyzed whether or not removing locking from around the hba->tmf_rqs[]
accesses, let's keep this locking.

> So better withdraw from changing ufshcd_tmc_handler() and just leave
> the whole function as it is?
That sounds good to me.

Thanks,

Bart.
