Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD3B171A5
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2024 20:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718914401; cv=none; b=gXgMKGBLbe8HIP+KgEDnsX8w0kxbxHKzr7EMJ0TiE+KODroH9iLasrvMnsxBylosM+QgMinpfTkWP8uryEGFiTgxjduAkixUkTrPz9k0MZxq/mIbVOFzA/ls6m/i6vpImv3OJgaHpU8GowHBd0+BM/x17e4uLNtzPEz8lQ8VdmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718914401; c=relaxed/simple;
	bh=NVLvwP3+TfSDJnMBBCpPLHAdKULVPqBRGM9enjX/u9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZEaeSRGpaG5x8S1ZSKJMH4LJCwS3vu+doCNHR6t/4yKqPeM4pUhEown7fD5prQKq4xEUpKvm/rYNNS9Zu+a1xwBHF76/DPRhOxuLCDA0vFMV74B0+xkPeHg9mPjlJKLUyYRxK5mIXtE5i3TxfYzcXbV/efGCtgpNebST2WUsB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fJpL1tk9; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fJpL1tk9"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W4sB71Mf4z6Cnk9V;
	Thu, 20 Jun 2024 20:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718914395; x=1721506396; bh=6FExkeBgc5UTt2qcAAgE5lWx
	O+DfR/tMlCnKyVrwO+g=; b=fJpL1tk9O5/9+MP8tRZgjmR28FFdfGfVJTanTtsg
	IiQtKKfPDs5aDApDndd9teKmSkeZrCuL0qAK/GvsDJVgSkAbw9u1rVu8bqksp70T
	JcfLodW+wTHYCq3oUIW/uy+VKsPFm2NB1A6Mcr5RklO3z5MDmUnLGCPYEiVA8SBK
	QPMtRbJvIyXs20DDcQvQ8Y+KErz0dL20EF/VFJoOuFpm1fQB0deJxRzwbJDZsnW1
	vBmusJBjX+kCVzdzYB0qbK8pq3a3P/eXsFv94U51IDhJPZXrbnUqwGArFXupifFE
	3hHvPO6RGTbOzIK/LIVnXEsP+mY4ixLvy+0M+dg++M1Vgg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id h0osfgIBl7m4; Thu, 20 Jun 2024 20:13:15 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W4sB11v1kz6Cnk8t;
	Thu, 20 Jun 2024 20:13:12 +0000 (UTC)
Message-ID: <d88fcbfa-eb05-4b46-a452-2cd9e7897797@acm.org>
Date: Thu, 20 Jun 2024 13:13:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] scsi: ufs: Make ufshcd_poll() complain about
 unsupported arguments
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>,
 Bean Huo <beanhuo@micron.com>, Andrew Halaney <ahalaney@redhat.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-7-bvanassche@acm.org> <20240619073210.GE6056@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240619073210.GE6056@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/24 12:32 AM, Manivannan Sadhasivam wrote:
> On Mon, Jun 17, 2024 at 02:07:45PM -0700, Bart Van Assche wrote:
>> The ufshcd_poll() implementation does not support queue_num ==
>> UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode. Hence complain
>> if queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/ufs/core/ufshcd.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 7761ccca2115..db374a788140 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -5562,6 +5562,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
>>   	struct ufs_hw_queue *hwq;
>>   
>>   	if (is_mcq_enabled(hba)) {
>> +		WARN_ON_ONCE(queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
> 
> So what does the user has to do if this WARN_ON gets triggered? Can't we use
> dev_err()/dev_warn() and return instead if the intention is to just report the
> error or warning.
> 
> I know that UFS code has WARN_ON sprinkled all over, but those should be audited
> at some point and also the new additions.
> 
> Also, this is a bug fix as it essentially fixes array out of the bounds issue.
> So should have a fixes tag and CC stable list for backporting.

No, this is not a bug fix. There is only one caller that passes the value
UFSHCD_POLL_FROM_INTERRUPT_CONTEXT as the 'queue_num' argument and it is a code
path that supports legacy mode (single queue mode). Since the above WARN_ON_ONCE()
is in an MCQ code path, it will never be triggered. The above WARN_ON_ONCE() can
be seen as a form of documentation and also as defensive programming. I think
using WARN_ON_ONCE() to document which code paths will never be triggered is fine.

Thanks,

Bart.

