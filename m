Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55862AE95
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 17:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722880076; cv=none; b=RcTINDh2onW4nGnWXTUOTQ5rwnqO4+xhSWgW/uvqKTZY95xLylHSyX6N5bMO9Ikna1j+ZvGqxmRUw7cVuRhhZX8lYN5iDKxXajhNpS1Yk7UnK0Iv5fa28seo/PCSw25B2cAH4RFUaqqAT+QDXCuKdHu48KnHbhh8wbdqx8Ybf20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722880076; c=relaxed/simple;
	bh=N2AwCyY/FSoBjGFqFYlomy9JwH/DvUrnRpwtinOsp2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BH5OqfXTFEbYHiDNnfe3Z1ixHBf7lIWRvpyMesWBGUQPv8fRQePYlK6jGtIjB5hkzhf9/DmabNHAESbDkyrzFKN5LNPv1W6iy6bYMd+ceknZvDCqVN1Gh9QNvxxDEDZ4Mvtr1nKlM24k//Uwv1g6lYPd7CvNbx8K/Fg0WxFACFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FEHd0b3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEHd0b3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12961C32782;
	Mon,  5 Aug 2024 17:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722880076;
	bh=N2AwCyY/FSoBjGFqFYlomy9JwH/DvUrnRpwtinOsp2o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FEHd0b3G9jQY2YC7/J5F5PPgoUPknFuQMN0NR684XZqa8KwDEzoTE39RPEFg+qSbh
	 74YOLEWIrkxRYj1uOL3CqHToD4Cw1Y8pwcmdWwdMTtwZ3365mBOiLirH/oKJrirsbD
	 V4/VS+NKXHeudvQB9rd/aiFlGz82ZciuMh1y9Ly5stD16hto3HxFkhU2cicgQahgjw
	 d4Sw4TlaWpA0ZTy8pSxJ2yPmcKWnnOSlovRn5HL7atXuc06qMahq9G9rhR7cF8uRup
	 tunZHsCLfu65EzAWTvdSclAiOXiIJmp5rV9KUUU1wyRJGAdwYeAKjyvo6Ewl+HSoP1
	 x8PdERQdJrP8w==
Message-ID: <f931edd1-ca89-461f-b242-b5d33fe6ca37@kernel.org>
Date: Mon, 5 Aug 2024 10:47:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RFC: Retrying SCSI pass-through commands
To: Mike Christie <michael.christie@oracle.com>,
 Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <b0f92045-d10f-4038-a746-e3d87e5830e8@acm.org>
 <2addecad-bad3-41e2-a8c7-ee68f3c471bf@oracle.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <2addecad-bad3-41e2-a8c7-ee68f3c471bf@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024/08/03 13:42, Mike Christie wrote:
> On 7/31/24 3:22 PM, Bart Van Assche wrote:
>>
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index da7dac77f8cd..e21becc5bcf9 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -1816,6 +1816,12 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>>          * assume caller has checked sense and determined
>>          * the check condition was retryable.
>>          */
>> -       if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
>> -               return true;
>> +       if (req->cmd_flags & REQ_FAILFAST_DEV)
>> +               return true;
>> +       if (/* submitted by the SCSI core */)
>> +               return false;
>> +       if (blk_rq_is_passthrough(req))
>> +               return true;
> 
> Do you just want to retry UAs or all internal passthrough command
> errors that go through here?

I think that we definitely do *not* want to retry all internal commands. E.g. I
do not see the point in retrying INQUIRY or VPD page accesses failing on device
scan.

> 
> For just the specific UA or NOT_READY/0x04/0x01 case for an example.
> Does every scsi core passthrough caller want that retried? If so, then
> I can see where you are coming from where you feel it's a bug. I would
> agree we would normally want to retry that in general. Maybe others know
> about some specific old case though.

I think the command Bart had a problem with is START_STOP_UNIT. If that is the
only case causing problems, then we should probably improve
sd_start_stop_device() to allow retries. But if there are more commands that
needs the same, then the patch that Bart is proposing makes sense I think, but
it will require an audit of all REQ_OP_DRV_XXX internal users to make sure that
they all use that command with -> allowed set to 0. But hopefully, most cases go
through scsi_execute_cmnd(), which should simplify this audit.

> 
> However, I'm not sure for MEDIUM_ERROR or ABORTED_COMMAND.
> I think MEDIUM_ERROR probably would not come up for the cases we are
> talking about though.
> 
> I don't think we want to always retry DID_TIME_OUT though. The funny
> thing is that I think Martin just wanted to retry one specific case
> for that error. We had to do the scsi_check_passthrough patches so
> we could retry just for scsi_probe_lun.

-- 
Damien Le Moal
Western Digital Research

