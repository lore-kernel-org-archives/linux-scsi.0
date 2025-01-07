Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4912D42A94
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 02:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215499; cv=none; b=hZghKDz8478D/arGJF1WP+LxRX/n3EI6ZyTLPbLUlYUgUvY0oME+D76fbNRAd5CeEb44hoi0nyPYpq7LGFTihjXhE/rb1q5Btgrwqgyq7Sn1kE2i0U0tXT1Riz2WnbuiL2tghlBnfQbyaw5uQIC/Y68s4wNCKhd3IGXwDaMqzDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215499; c=relaxed/simple;
	bh=XraR6Z9N/Bx6G/jVgxPfOx+QLNClxV6pkZ+lhEnqr0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LTCf3Ae2pjsRYg2sAKH01zqPFtV4LwGmpj0wZIS5u+pJX7Mxc0MaatBjLk9FXQXvYTwE/+pbGGbyGZBbmXkTiWXB/h7NswEN6cnGOONmsjUCAv3qGChfQUC02D4MuWlrhrFmA3ETHBl6d7XVmdJ0S8mD+Y6VutKxtjg923a5/nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=d85rx8S+; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="d85rx8S+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736215487; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=I2O1P0M17rdebul9v4qC9/45I2/kWDCyEoqMwQ4boVY=;
	b=d85rx8S+o/Od6swB3x2HIPv4to83vypU+9EdlRou7i8pacQAvNzQxLnOtazAxsX+LuLcwuCl/dval6EHR85Okn1B5zpMqfRdtoQ+LezjXr/caLboFWufeYaAN5Zs+QcXZXUVSkttmQOi08Mk7vB8yfMbYFxGm3Quut1D5OWce9U=
Received: from 30.178.82.232(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WN8tfCE_1736215485 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jan 2025 10:04:46 +0800
Message-ID: <2ed732a2-e317-4b75-b3fb-f1e4657b0368@linux.alibaba.com>
Date: Tue, 7 Jan 2025 10:04:45 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH v3] scsi: mpi3mr: fix possible crash when setup bsg fail
To: Bart Van Assche <bvanassche@acm.org>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <20241226121808.46396-1-kanie@linux.alibaba.com>
 <3e87b69b-38aa-413f-a2bf-388da21afaa0@acm.org>
From: Guixin Liu <kanie@linux.alibaba.com>
In-Reply-To: <3e87b69b-38aa-413f-a2bf-388da21afaa0@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/1/7 02:30, Bart Van Assche 写道:
> On 12/26/24 4:18 AM, Guixin Liu wrote:
>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c 
>> b/drivers/scsi/mpi3mr/mpi3mr_app.c
>> index 10b8e4dc64f8..7589f48aebc8 100644
>> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
>> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
>> @@ -2951,6 +2951,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
>>           .max_hw_sectors        = MPI3MR_MAX_APP_XFER_SECTORS,
>>           .max_segments        = MPI3MR_MAX_APP_XFER_SEGMENTS,
>>       };
>> +    struct request_queue *q;
>>         device_initialize(bsg_dev);
>>   @@ -2966,14 +2967,17 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
>>           return;
>>       }
>>   -    mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), 
>> &lim,
>> +    q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
>>               mpi3mr_bsg_request, NULL, 0);
>> -    if (IS_ERR(mrioc->bsg_queue)) {
>> +    if (IS_ERR(q)) {
>>           ioc_err(mrioc, "%s: bsg registration failed\n",
>>               dev_name(bsg_dev));
>>           device_del(bsg_dev);
>>           put_device(bsg_dev);
>> +        return;
>>       }
>> +
>> +    mrioc->bsg_queue = q;
>>   }
>
> Next time, when including a call stack in the patch description, please
> clean it up. This means removing the timestamps, the register dumps and
> also the stack frames that start with " ? ". Anyway:
>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thanks, I will send a v4 to clean up the stack, sorry for the trouble.

Best Regards,

Guixin Liu

