Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1F2C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 07:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiB1HIA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 02:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbiB1HHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 02:07:55 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDC5673D7
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 23:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646032037; x=1677568037;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=Nydg5osWEKJ1vCu575qaHuLk5j/t7XOmPiiTKKd9D7A=;
  b=g/H/Hq/b6VmexpmNfepHPYjua3D4RBJEzbGF0TGQK0i9vWGx5GEwScpE
   0f67t1mEe8xBqgT3Ut896UJ9yQCK8NQ1RN9b8YpieDgmjZv+XRhXuRyQr
   eMDhSuB52tJG04K8XQVDykG+2PY9KTR4R4BvDCIdUoBsY7wADNKkbRTU0
   PVI49Yn8MiKRMSnwfxwdEHu6pOgQ1unyTbJOu/43zt+zld+YmmBX8vVzf
   fhjZenhSJnMwKX2X7T0SuW0m/HdE2qZqHjlcVwspNthlaE2uBiJfE4A/7
   wHFCPsHMNxMvY2wa/CQAJT8iktiUo3y6Ah/v1nETqbsk9IhBdAhxKxkwF
   A==;
X-IronPort-AV: E=Sophos;i="5.90,142,1643644800"; 
   d="scan'208";a="193009833"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2022 15:07:16 +0800
IronPort-SDR: ydcGwafqfknm0Zju07AudwpIvHEtwdOAfTCExnMUSAu7TvIDHvEVHLrdHiH2lLzocw6L02OCSs
 3VPCkdEXMy2K+NGTCstyKkYSavtUKwxw9G+TwZs+syqwyp3AnZaxOCnc0R6GNwhXNQdF8grgcA
 IG5lWLaxxIBRAwsrkPoNONYJZQEm+j4a2Ewu19v3URXIV9/y1DClzIE6gd0JfeeI9sknSCnXn0
 p36wn7uuYzh7h477rCm0tzV6gqptON7eud6chi370LkSiaLe6w68fyPU1/4fuvyChILbVQfV+o
 CMPcxWdSnumXmy6OycguuHv6
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 22:39:46 -0800
IronPort-SDR: UUatjK6w0k5cHaNOQuIXQOyt3mkMGY3oTAgW9nqE6F1Zje4bOg52M3OBafM1W+VSXCwp4PIV+d
 Ru96PwuthNe71FYgYaKz42WRZ+FOMfCK5SqxGuBehVmkwECkdjO+G1mHS1fJ8pHzFFqtQx4SrF
 CkUJRhSlXBD6S5Ko9UM8PZwV19Xh7AY7ce5Y4Ucr17SingjBWwZmwYDDtaFYeqYvlUfx5Auf7i
 RuCSvGZ1fHbdpyB6x1TD6fz9Avuje4gAhi6qN1wngIAHC9qO56nAr7uHJ0p6gzZ+Xj1Oo7xMv/
 Zio=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 23:07:16 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K6WfD3bNPz1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 23:07:16 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1646032036; x=1648624037; bh=Nydg5osWEKJ1vCu575qaHuLk5j/t7XOmPii
        TKKd9D7A=; b=bjmljnHqFR7DgG2I6eZ5mVnREYjrG6Npu/549zc+OdGQ/EDGYiH
        TO5gTDWFj1FcXmXwMQ8yKFSe609AGMrLjDqyVRn0PmyswQRYNMT0N+e73m3HoXIP
        bwG1HR3Ay37ldGODciFHK1SBvGgPZkhkf6FR+8+x8PRJe25UaUyP9H8YsE3sK/I9
        Vq7MvEx7BmMvneoW8CRJ4KrvC0xXQjygT7Rj7gsyfYQ3w1T3qsI4QBxE2xCQ1fqZ
        iHELFXtVRVreiiq98G+suPa1y/Mp0MnZ+bwv4FiCRFgU1/2VKKBsOqHR/5l+9l3a
        0kVOw53SaHpKHEpIDVY+pmA4H9xQzZ5Rx+g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id B_b4R4vTAT5U for <linux-scsi@vger.kernel.org>;
        Sun, 27 Feb 2022 23:07:16 -0800 (PST)
Received: from [10.225.33.67] (unknown [10.225.33.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K6WfB4K37z1Rvlx;
        Sun, 27 Feb 2022 23:07:14 -0800 (PST)
Message-ID: <c8ac38d5-04d3-71be-bc27-16e5aa4ac355@opensource.wdc.com>
Date:   Mon, 28 Feb 2022 09:07:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 2/2] scsi: scsi_debug: fix sparse lock warnings in
 sdebug_blk_mq_poll()
Content-Language: en-US
To:     dgilbert@interlog.com, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220225084527.523038-1-damien.lemoal@opensource.wdc.com>
 <20220225084527.523038-3-damien.lemoal@opensource.wdc.com>
 <fbfa587b-94fc-9431-bb74-56c50a89767e@interlog.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <fbfa587b-94fc-9431-bb74-56c50a89767e@interlog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/02/28 4:05, Douglas Gilbert wrote:
> On 2022-02-25 03:45, Damien Le Moal wrote:
>> The use of the locked boolean variable to control locking and unlocking
>> of the qc_lock of struct sdebug_queue confuses sparse, leading to a
>> warning about an unexpected unlock. Simplify the qc_lock lock/unlock
>> handling code of this function to avoid this warning by removing the
>> locked boolean variable.
> 
> See below.
> 
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>>   drivers/scsi/scsi_debug.c | 19 +++++++++----------
>>   1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index f4e97f2224b2..acb32f3e38eb 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -7509,7 +7509,6 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
>>   {
>>   	bool first;
>>   	bool retiring = false;
>> -	bool locked = false;
>>   	int num_entries = 0;
>>   	unsigned int qc_idx = 0;
>>   	unsigned long iflags;
>> @@ -7525,18 +7524,17 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
>>   	if (qc_idx >= sdebug_max_queue)
>>   		return 0;
>>   
>> +	spin_lock_irqsave(&sqp->qc_lock, iflags);
>> +
>>   	for (first = true; first || qc_idx + 1 < sdebug_max_queue; )   {
>> -		if (!locked) {
>> -			spin_lock_irqsave(&sqp->qc_lock, iflags);
>> -			locked = true;
>> -		}
>>   		if (first) {
>>   			first = false;
>>   			if (!test_bit(qc_idx, sqp->in_use_bm))
>>   				continue;
>> -		} else {
>> -			qc_idx = find_next_bit(sqp->in_use_bm, sdebug_max_queue, qc_idx + 1);
>>   		}
>> +
>> +		qc_idx = find_next_bit(sqp->in_use_bm, sdebug_max_queue,
>> +				       qc_idx + 1);
> 
> The original logic is wrong or the above line is wrong. find_next_bit() is not
> called on the first iteration in the original, but it is with this patch.

Good catch. Indeed I should not have touched that. Will fix this in V2.

> 
>>   		if (qc_idx >= sdebug_max_queue)
>>   			break;
>>   
>> @@ -7586,14 +7584,15 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
>>   		}
>>   		WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_NONE);
>>   		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
>> -		locked = false;
>>   		scsi_done(scp); /* callback to mid level */
>>   		num_entries++;
>> +		spin_lock_irqsave(&sqp->qc_lock, iflags);
>>   		if (find_first_bit(sqp->in_use_bm, sdebug_max_queue) >= sdebug_max_queue)
>>   			break;	/* if no more then exit without retaking spinlock */
> 
> See that comment on the line above? That is the reason for the guard variable.
> Defying that comment, the modified code does a superfluous spinlock irqsave
> and irqrestore.

It does, and I should have removed the comment. Without this extra lock/unlock,
I could not find a way to shut-up sparse. Do you think this is too much of an
overhead ?

> Sparse could be taken as a comment on the amount of grey matter that tool has.

When it comes to conditional locking, most of the time, sparse does not get it
and generates warnings. In this case, I tried the acquire/release annotations,
but the loop+locked variable are too much for sparse.

I really would like to suppress *all* sparse warnings in scsi. There are way too
many right now, which makes this tool nearly useless as new warnings get drowned
in the sea of old ones...

> 
> 
>>   	}
>> -	if (locked)
>> -		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
>> +
>> +	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
>> +
>>   	if (num_entries > 0)
>>   		atomic_add(num_entries, &sdeb_mq_poll_count);
>>   	return num_entries;
> 
> Locking issues are extremely difficult to analyze via a unified diff of
> the function. A copy of the original function is required to make any
> sense of it.

Sorry, but I do not understand what you are trying to say here...

> 
> Doug Gilbert
> 
> 


-- 
Damien Le Moal
Western Digital Research
