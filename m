Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB136C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 13:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiB1Nrd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 08:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiB1Nrc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 08:47:32 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625647A99C
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 05:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646056013; x=1677592013;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=386RINW1W5Sx1CWAzRdG3luktZ4lfwAIrM0VkCvMJd4=;
  b=BND+5YDGUEl0UIJXNyp3RzzEBjzqv1YYrQszNJx2sawMyQw6XVOGGOjR
   BsEXkdG0l9Kdm8IgW88v7kj9iDtACGafxNRldFxqXqW64EGDYcqsx3Qlr
   4xRE/ojqF3R9S3FKG6Wn2TKy67CMAwvxvOvnHwfFOq2SHihBfnWf4oTBC
   Cspno+kaoMNNjCZ4Is2IT7pGUUTZB5F9pMgP7sY6jofmUylEM3DGKY2vu
   Pp+1YShPu2qQJnoIkMkoJod/BaxpCCUCQXIU51cb3hQ4BGf7MUsMYPd8+
   aM5gc/pLylndRK6OGwwPhHXnqGjvZNGBn/olIDfVpFzrKtH6Jj8gjowG2
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,142,1643644800"; 
   d="scan'208";a="298233208"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2022 21:46:52 +0800
IronPort-SDR: HSm8Kjl2JfhygX4JNQOVbpIzp9WIIbKnmdwkvlJJNF+47ZbN90610l1evcqjRWMV+OrAno8yRM
 w8vZpEkw5lRGv4mEDD38/p63v5TT5MBCVq0DvJ3aBZEdqVgpLynaq1ySr3LESA0E8/oLzTYD5h
 SsIegvFewLBtb95cqID1uSffqdnyNyukqkZBoI/ccwOtWoNwLRf1n9r1+B28nLk/dkDT6BRAxN
 IVFaHUQcXpEyKZ/V82nKSXwJ6M51TVijC3Mvn1yeAXW/3bUe1Ufh6hMifdI0jr/YajApQau9ln
 SnZtIMau9sGgWFDok038pd8V
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 05:19:21 -0800
IronPort-SDR: 0P5erhqtj1MmARAzMrfe+I4sU+z3hdha6vfy1xvwoN8goHb1TwVaMwoC7tjRnojYf/Mw1hBoEj
 cGnw9FiuWkpAS55936uMwjTtqi1Ul2RqjgRMHPh9LevjS5q+j/XS7SdI8njwuVT6tscdYB4Dip
 5aS/GNq1x8Hw9DdxnNOKXMaH6q82JjPA623ADqiOkKR8aCh1+WBxRJew4R45cksHE0w96dXIxt
 uB/NspQmzmrf7svqtWs30IYx9D/6sp56ra5rY7ltgBUuHq53Xtj5jc5BqTskBgF6MpSZBKhZrS
 /h0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 05:46:52 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K6hWH4VgRz1Rwrw
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 05:46:51 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1646056011; x=1648648012; bh=386RINW1W5Sx1CWAzRdG3luktZ4lfwAIrM0
        VkCvMJd4=; b=EwzwmMOGksLdEb1Lp8UL9bI1T13ESN2akv//9iRHYLvN5qTQE+0
        NKbS9uNIZlqV+4th3V3IShVvBqtxycBBdpgMMid+/+nhjMaJEhsb1ODG63/FQ2OH
        uo7QbX/+ko5n+FgC17FBthPwhx6e6ERdOte5jsBXbJH84wXzMES+pdB4spSV8V4/
        96EqdTIZoGQE1tqtRxERP6dlrb66n1Lf1tTY/Obg2FnpPocIBkyW8KQhh7E5oE5O
        fRshZNEgf55oNFZAMYEVV9HpmhsewsZpX6ZbxUzj63HQTq5NjF7NqUwySNwRjziY
        lo+kioc4EHIOk47+2rEPHWKlDVAD7m4kmLg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NvU_0Y_qHjNB for <linux-scsi@vger.kernel.org>;
        Mon, 28 Feb 2022 05:46:51 -0800 (PST)
Received: from [10.112.1.94] (c02drav6md6t.wdc.com [10.112.1.94])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K6hWG0rvJz1Rvlx;
        Mon, 28 Feb 2022 05:46:49 -0800 (PST)
Message-ID: <2dda2a2a-dc54-e335-e0eb-574868397277@opensource.wdc.com>
Date:   Mon, 28 Feb 2022 15:46:47 +0200
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

Rechecking this, there is one point that is bothering me: is it OK to have the
find_first_bit() outside of the sqp lock ? If not, then this is a bug and the
extra lock/unlock that my patch add is a fix...

> 
> Sparse could be taken as a comment on the amount of grey matter that tool has.
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
> 
> Doug Gilbert
> 
> 


-- 
Damien Le Moal
Western Digital Research
