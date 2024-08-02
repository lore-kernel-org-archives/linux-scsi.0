Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B540D16BE0E
	for <linux-scsi@vger.kernel.org>; Fri,  2 Aug 2024 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722617541; cv=none; b=vCWX90zeinB20CeACS1VEt2A3YcWpujHlsWGTpDuWu+jL8C7ZiMlez2+z0+mSotl2wtnU6somQwR4ESEb+FVMGS1QCKIPDLIIGMk5g3QXXEhF3Dp6lE4+V1cZJsz5nN/dv4jJRvzp85dow1YwLLFU44jhrHQsEpw2uqu2iPKN7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722617541; c=relaxed/simple;
	bh=dIGJvOjX3XzidEMXQgJqREOcC6BM3HfYTpbsD5GkgKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lQ31N2jAspu7Azwvv6rc8D/aCx6h+aMxz2GP3LYwOJ4X/dXRxAJzfqpvJARv6f3Bqg4Sa5EhwmyDVMzqBQaC/yqffxmoXNfEFrQUbt/7bjXWbiBvMWY0Ef5ODXkTbfXq+/8+Owl8ry9EGTq+LMFz6JWqM2GpYg75NWPDCbn0mRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=f0q9nV5u; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="f0q9nV5u"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WbBhF1TzHzlgMVQ;
	Fri,  2 Aug 2024 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722617530; x=1725209531; bh=uYNscFeAs7euOOaaAwulbKix
	LwPrxztSKLkrzRJs6Ck=; b=f0q9nV5udWw1NxzRB+Bp294gNx28eEkss5ySkskD
	NcwmqjngfuR1+EDNRNiiLFsBV/zhEdQFRBiLM+xNQpQt+aJLjjNFTRtX2GTUSHRE
	YOcaY5s//1G3byFH72Wlzk5NInr9uxKTN1BbeUbVVZXj9/IUvE7H6oZ77iZOGiEC
	a62CwkwAbSJqHMTCGgbtitqJjIDS7pAN2H7S7arq0h8zxoMyPhfJDXUqX1mJZlXE
	JyMq8Chap+fqQtUje7rFkF8ahA2qceqye06Yl3ASFabPuqroKG1fxW7pJFrMeqYe
	ZX34e09L9S3AVQ657AYJ6A0o3FhiiafnWnI56qkIDJSq7w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZghlWoO0E_6c; Fri,  2 Aug 2024 16:52:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WbBh742bRzlgVnN;
	Fri,  2 Aug 2024 16:52:07 +0000 (UTC)
Message-ID: <cd825c7b-0e29-4120-bc0d-2b89bbe8e401@acm.org>
Date: Fri, 2 Aug 2024 09:52:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RFC: Retrying SCSI pass-through commands
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>, Mike Christie <michael.christie@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <b0f92045-d10f-4038-a746-e3d87e5830e8@acm.org>
 <a23d7a8c-4a4a-4687-ae18-87b2b2fb9fcb@kernel.org>
 <1e79816d-02eb-4997-81d2-4b6ec0201dd5@acm.org>
 <30b1d857-8172-497c-b482-d49af8463029@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <30b1d857-8172-497c-b482-d49af8463029@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/24 5:47 PM, Damien Le Moal wrote:
> On 8/2/24 05:12, Bart Van Assche wrote:
>> [PATCH] scsi: core: Retry commands submitted by the SCSI core
>>
>> Pass-through commands either come from user space (SG_IO ioctl,
>> SCSI_IOCTL_*, BSG), from the SCSI core or from a SCSI driver (ch,
>> cxlflash, pktcdvd, scsi_scan, scsi_dh_*, scsi_transport_spi, sd,
>> sg, st, virtio_scsi). All this code sets scsi_cmnd.allowed to the
>> maximum number of allowed retries. Hence, removing the
>> blk_rq_is_passthrough() check from scsi_noretry_cmd() has the
>> effect that scsi_cmnd.allowed is respected for pass-through
>> commands.
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 612489afe8d2..c09f65cfa898 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -1855,7 +1855,7 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>>    	 * assume caller has checked sense and determined
>>    	 * the check condition was retryable.
>>    	 */
>> -	if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
>> +	if (req->cmd_flags & REQ_FAILFAST_DEV)
>>    		return true;
> 
> But that will cause *all* passthrough requests to be retried, including those
> issued from userspace, no ? I do not think that such change would be acceptable
> as that can break userspace using passthrough and expecting to deal with errors
> and handling them however they see fit, which may not be retrying commands.

In the SG_IO ioctl implementation I found the following assignment:

	scmd->allowed = 0;

In drivers/scsi/sg.c I found the following (SG_DEFAULT_RETRIES == 0):

	scmd->allowed = SG_DEFAULT_RETRIES;

Isn't that sufficient to prevent retries in the scsi_noretry_cmd() callers that
check scmd->allowed? The only scsi_noretry_cmd() that does not check
scmd->allowed is scsi_io_completion(). I propose to add an explicit
blk_rq_is_passthrough() check in that function next to the scsi_noretry_cmd()
call.

Thanks,

Bart.
