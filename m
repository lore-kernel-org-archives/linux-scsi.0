Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED81C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 06:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbiB1G66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 01:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiB1G64 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 01:58:56 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E90649FA6
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 22:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646031498; x=1677567498;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=JwI15+J5tIEE90Bb8lbRkM3TdMbujXWpmsiRAFFM7Dc=;
  b=M/Rfq8zMmVthH3xhwpBho1G6mj2uRp7QR3MqtCzHkTgV/mc87fK1TPFK
   LKf0j3QZ5jFW2fjwmv4V5lpv0tVwTnkq9VEKVMmUlFZqZQtzukxsM6hLC
   tOwaPbs3wl4E3FxGjQ5NqGE50UHbN94cYJ9vWr955n739+TftU7RK6/Hr
   SLSFnpoXqkiCHwzgu5v+DuRpes3+bQiEAmJEo5FsVq2bswc/CNK5Jzrxr
   48K+j/oXFrw8LGG31FgSHv2LgoulahmkLbVuxMdmWaSLQGfAXzncUi4SE
   w7yBvA2Ks96SvZf6uOCMl1KXLb8ILcYMDK1vwqzbEet1tdE21Xri0Cega
   g==;
X-IronPort-AV: E=Sophos;i="5.90,142,1643644800"; 
   d="scan'208";a="305986615"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2022 14:58:17 +0800
IronPort-SDR: PspCHbYZxwHrIE8xR/uNGjo23f8d8nkoN56zgpGafMhy12BVU6P24qvw6WBQvxV+CGaaPm/1q8
 Y8KPsoP7mhtpmvuBC7jeH7aXnPcJ2aD+zHoPAzWkSs/pzJMmgOcPe5seL7ll+VL7UWkvUV008C
 dn874Cs/wbAx1BZEz0Cvce9iASlvaPU89CKvWfmxCTy4yJOIwAcnWQbeEFj7DeAXJ0O8zRJR8E
 /C4OLyFm8znEI71fU6Dkzn2JPXnoe8F36OxR/qgYTW+6vcYxmf8++lrZZI6FPmirWDlckJQ6s1
 vtoAl+cXIlJE5xoLcr5uUmVN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 22:29:43 -0800
IronPort-SDR: 2dh5lUmrmBrk78Z5cjWYjgz3NMVBRuDng5zS3FXsuzjKawTj1ewKzH4YLWgNSpUYwoIZg/ihnV
 ugot39he0EVyLNU5BO9ffz332zcKRQM/9PCFYV/peuKas6Qa3FieAYFITfpH8O1zFtkmzI0mZk
 2uM2C1AoC3KG32W3AMODjnnAa8ALzkqABfNN1frA6JQweWYsLEyKuwLaRjm7HW+b/m+zQhtBAs
 h6ghweIzGboG5/voo5I6vGAh10RALz+ADLyU1aRt67d3JlST3qdAccbYclABydUJwovc0DdRr+
 HoA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 22:58:18 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K6WRs2H3dz1Rwrw
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 22:58:17 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1646031496; x=1648623497; bh=JwI15+J5tIEE90Bb8lbRkM3TdMbujXWpmsi
        RAFFM7Dc=; b=UZr1IePUxCk0NcFbsbZpwJnj+U5xf1wuUUr7ipsUHPE3nqfXkaZ
        qf/cNh4OKIzK47AEo4ddaxUTPwxZzbP5kxJW9ve0ZQ9vkv2BTORCqmbiz/juGq4/
        txsS//AqWx84+2sVzCAOr8IKmvSku8pZ26HclSG87emJcobeL6EdqbB4at+OeYI5
        xWnSFRgfSCSXqF93NH9H9KL9up43FrnlRYP5gshcWQqapfSr5UlVpDhbdMOZrsfr
        pTHkexgGYMMXhPX75xhUVXXEQov7Xep/eCXezw/orcnbeUNqUtGU5e0rRkkJcCfM
        aqPV0khDowIevvTui1f7pIVSRLf6m8jdo1Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VtJmUTA_5UzU for <linux-scsi@vger.kernel.org>;
        Sun, 27 Feb 2022 22:58:16 -0800 (PST)
Received: from [10.225.33.67] (unknown [10.225.33.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K6WRp5vQZz1Rvlx;
        Sun, 27 Feb 2022 22:58:14 -0800 (PST)
Message-ID: <146bfd4a-a863-cfd4-6054-1c44439caea9@opensource.wdc.com>
Date:   Mon, 28 Feb 2022 08:58:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 1/2] scsi: scsi_debug: silence sparse unexpected unlock
 warnings
Content-Language: en-US
To:     dgilbert@interlog.com, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220225084527.523038-1-damien.lemoal@opensource.wdc.com>
 <20220225084527.523038-2-damien.lemoal@opensource.wdc.com>
 <86e4fafa-f834-6fb5-2337-314a6078a480@interlog.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <86e4fafa-f834-6fb5-2337-314a6078a480@interlog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/02/28 3:39, Douglas Gilbert wrote:
> On 2022-02-25 03:45, Damien Le Moal wrote:
>> The return statement inside the sdeb_read_lock(), sdeb_read_unlock(),
>> sdeb_write_lock() and sdeb_write_unlock() confuse sparse, leading to
>> many warnings about unexpected unlocks in the resp_xxx() functions.
>>
>> Modify the lock/unlock functions using the __acquire() and __release()
>> inline annotations for the sdebug_no_rwlock == true case to avoid these
>> warnings.
> 
> I'm confused. The idea with sdebug_no_rwlock was that the application
> may know that the protection afforded by the driver's rwlock is not
> needed because locking is performed at a higher level (e.g. in the
> user space). Hence there is no need to use a read-write lock (or a
> full lock) in this driver to protect a read (say) against a co-incident
> write to the same memory region. So this was a performance enhancement.
> 
> The proposed patch seems to be replacing a read-write lock with a full
> lock. That would be going in the opposite direction to what I intended.

Not at all. The __acquire() and __release() calls are not locking functions.
They are annotations for sparse so that we get a correct +/-1 counting of the
lock/unlock calls. So there is no functional change here and no overhead added
when compiling without C=1 since these macros disappear without sparse.

> 
> If this is the only solution, a better idea might be to drop the
> patch (in staging I think) that introduced the sdebug_no_rwlock option.
> 
> The sdebug_no_rwlock option has been pretty thoroughly tested (for over
> a year) with memory to memory transfers (together with sgl to sgl
> additions to lib/scatterlist.h). Haven't seen any unexplained crashes
> that I could trace to this lack of locking. OTOH I haven't measured
> any improvement of the copy speed either, that may be because my tests
> are approaching the copy bandwidth of the ram.
> 
> 
> Does sparse understand guard variables (e.g. like 'bool lock_taken')?
>  From what I've seen with sg3_utils Coverity doesn't, leading to many false
> reports.
> 
> Doug Gilbert
> 
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>>   drivers/scsi/scsi_debug.c | 68 +++++++++++++++++++++++++--------------
>>   1 file changed, 44 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index 0d25b30922ef..f4e97f2224b2 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -3167,45 +3167,65 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
>>   static inline void
>>   sdeb_read_lock(struct sdeb_store_info *sip)
>>   {
>> -	if (sdebug_no_rwlock)
>> -		return;
>> -	if (sip)
>> -		read_lock(&sip->macc_lck);
>> -	else
>> -		read_lock(&sdeb_fake_rw_lck);
>> +	if (sdebug_no_rwlock) {
>> +		if (sip)
>> +			__acquire(&sip->macc_lck);
>> +		else
>> +			__acquire(&sdeb_fake_rw_lck);
>> +	} else {
>> +		if (sip)
>> +			read_lock(&sip->macc_lck);
>> +		else
>> +			read_lock(&sdeb_fake_rw_lck);
>> +	}
>>   }
>>   
>>   static inline void
>>   sdeb_read_unlock(struct sdeb_store_info *sip)
>>   {
>> -	if (sdebug_no_rwlock)
>> -		return;
>> -	if (sip)
>> -		read_unlock(&sip->macc_lck);
>> -	else
>> -		read_unlock(&sdeb_fake_rw_lck);
>> +	if (sdebug_no_rwlock) {
>> +		if (sip)
>> +			__release(&sip->macc_lck);
>> +		else
>> +			__release(&sdeb_fake_rw_lck);
>> +	} else {
>> +		if (sip)
>> +			read_unlock(&sip->macc_lck);
>> +		else
>> +			read_unlock(&sdeb_fake_rw_lck);
>> +	}
>>   }
>>   
>>   static inline void
>>   sdeb_write_lock(struct sdeb_store_info *sip)
>>   {
>> -	if (sdebug_no_rwlock)
>> -		return;
>> -	if (sip)
>> -		write_lock(&sip->macc_lck);
>> -	else
>> -		write_lock(&sdeb_fake_rw_lck);
>> +	if (sdebug_no_rwlock) {
>> +		if (sip)
>> +			__acquire(&sip->macc_lck);
>> +		else
>> +			__acquire(&sdeb_fake_rw_lck);
>> +	} else {
>> +		if (sip)
>> +			write_lock(&sip->macc_lck);
>> +		else
>> +			write_lock(&sdeb_fake_rw_lck);
>> +	}
>>   }
>>   
>>   static inline void
>>   sdeb_write_unlock(struct sdeb_store_info *sip)
>>   {
>> -	if (sdebug_no_rwlock)
>> -		return;
>> -	if (sip)
>> -		write_unlock(&sip->macc_lck);
>> -	else
>> -		write_unlock(&sdeb_fake_rw_lck);
>> +	if (sdebug_no_rwlock) {
>> +		if (sip)
>> +			__release(&sip->macc_lck);
>> +		else
>> +			__release(&sdeb_fake_rw_lck);
>> +	} else {
>> +		if (sip)
>> +			write_unlock(&sip->macc_lck);
>> +		else
>> +			write_unlock(&sdeb_fake_rw_lck);
>> +	}
>>   }
>>   
>>   static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
> 


-- 
Damien Le Moal
Western Digital Research
