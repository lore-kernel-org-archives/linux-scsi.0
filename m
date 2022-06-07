Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F60C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 09:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbiFGJZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 05:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239044AbiFGJZv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 05:25:51 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36021CE5DA
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 02:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654593949; x=1686129949;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TrZ06grO6DzkXeBfuTvfX63qjjtdq53CsHlq9M5tVOs=;
  b=BRfbl8ZKs1Ge/nHnh47FGXRz3bFU/X/m1Nst+c/JthvBPPbERzqKZxmN
   f5ap5yIWwjDUf5PiH0to3u3OEP6rVDQVxKmasbecNFTXC2M8Qta7pfcUL
   Y0p12QGt9GkQ7b8LT5lfO8AhaJK+zUzqfs0yYCoejz5ekLdJcmMBPXEaP
   1W64vZv/ZzQQcNvevvWEpvxb+eQEKkxzx//1uwCgK+nwbv12mdwL4rlxF
   DFP1PQrdI4VYoQ3x+UubyDBTw1t43R9Sj/TnhC70JBfUEg7LPYXJ9hcMO
   g5H1jpplfty0kLlTJW43GLw848cIq5S6IwwEOlxRBXHkcipkzwnKpyTCG
   w==;
X-IronPort-AV: E=Sophos;i="5.91,283,1647273600"; 
   d="scan'208";a="201204173"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2022 17:25:48 +0800
IronPort-SDR: 2UFobRSs4F4Swj9+EfufhqVHDD8vSs8f3LMthfiXuW1DXej5RUAH5BKrdkYrwGYxRJ0DHs4aw9
 iQnQjB9kAJgGNVEAjTN3hzwqSKWDbSM94Bhr5ueOE9iQ2k11JfguVcDqmqs8/JW/O4qKB+eV2u
 B5fAXy/TNcqbsKx4c6tUoUqk3zFwls71asY9QO2EpQP7UNxbKNu3VrLJ80u5iOBAQ6Jt1is/3X
 FW37vvG26JS/eNeYasAxZI6DbftlTHTB5s+nf4thwSgvERF1FoL5O7pHoZNUOsxa3gZ6egh0yl
 zEt8nrbMQ6dAydD/r0OBKrde
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2022 01:44:37 -0700
IronPort-SDR: hUMYyO0m535xd5hUJHoFksY/rH1G7RSEqwIXkjhuFDsW+mhVimejKkOwZyx92pVv+JVxuIBmeg
 HZC0p+11FRKcVg7Qaq/lzsaCtzygTMieVReUE0B1W8Nqtfh6UlSgekkM3G0zv30wsxwgEjfWfW
 PV3NcsmREnLp0awxiDWGHFGMlDNLRy5EsG+2O6rEKGQXFtaBarNA13an+sdvhxZnuNz8XcmWIO
 dKhPi5cqtw3jka6j5mlqA8s+fA9dkmCCzfBdtIIU42cz2YUsYXAXSwxODS1wk1sPsUc0BnX35l
 adI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2022 02:25:48 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LHQ2N02nRz1Rwrw
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 02:25:47 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654593947; x=1657185948; bh=TrZ06grO6DzkXeBfuTvfX63qjjtdq53CsHl
        q9M5tVOs=; b=YtrfXFbMN376u9syRjFZzUIT8RFdEcYZ4mCZF7DdknLrVB+4ZcL
        Kf5fQmjywV+2OKbxLTLmRVqlzGlRFm1aTVw8Vr2+zYk2WRjAftjgvXvfmLJh2Jkh
        I+NP5tz5omerRwRV7iXmsgcmJavP60PrOS+GgtlDe1Zt9QCLiJD0dzVqxud2QhuN
        H3yJ+CaZZQVm/BktDKBBPtsSKsyaU0t29A0Lf002LHnMm196jDsHsF9IAxxpMJjn
        eAwpoRrusMho+6jn2DR2VaUzkwKXL3AzJ62F0MIBPMjLbNXi9GGHRUY49ZopofDt
        CYJnM03vw9jg53l4kJrYKtTk7gUPWmSUO1A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RxT4hYMao2RP for <linux-scsi@vger.kernel.org>;
        Tue,  7 Jun 2022 02:25:47 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LHQ2L4Xbbz1Rvlc;
        Tue,  7 Jun 2022 02:25:46 -0700 (PDT)
Message-ID: <a2ca3cc1-f948-e9bd-c335-3b75190fac49@opensource.wdc.com>
Date:   Tue, 7 Jun 2022 18:25:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: scsi_debug: fix zone transition to full condition
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
References: <20220607014942.38384-1-damien.lemoal@opensource.wdc.com>
 <Yp8XXXX/vYKvuvSS@x1-carbon>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Yp8XXXX/vYKvuvSS@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/22 18:16, Niklas Cassel wrote:
> On Tue, Jun 07, 2022 at 10:49:42AM +0900, Damien Le Moal wrote:
>> When a write command to a sequential write required or sequential write
>> preferred zone result in the zone write pointer reaching the end of the
>> zone, the zone condition must be set to full AND the number of
>> implicitly or explicitly open zones updated to have a correct accounting
>> for zone resources. However, the function zbc_inc_wp() only sets the
>> zone condition to full without updating the open zone counters,
>> resulting in a zone state machine breakage.
>>
>> Factor out the correct code from zbc_finish_zone() to transition a zone
>> to the full condition and introduce the helper zbc_set_zone_full(). Use
>> this helper in zbc_finish_zone() and zbc_inc_wp() to correctly
>> transition zones to the full condition.
>>
>> Fixes: 0d1cf9378bd4 ("scsi: scsi_debug: Add ZBC zone commands")
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>>   drivers/scsi/scsi_debug.c | 27 +++++++++++++++++----------
>>   1 file changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index 1f423f723d06..6c2bb02a42d8 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -2826,6 +2826,19 @@ static void zbc_open_zone(struct sdebug_dev_info *devip,
>> 	}
>>   }
>>
>> +static inline void zbc_set_zone_full(struct sdebug_dev_info *devip,
>> +				     struct sdeb_zone_state *zsp)
>> +{
>> +	enum sdebug_z_cond zc = zsp->z_cond;
>> +
>> +	if (zc == ZC2_IMPLICIT_OPEN || zc == ZC3_EXPLICIT_OPEN)
>> +		zbc_close_zone(devip, zsp);
>> +	if (zsp->z_cond == ZC4_CLOSED)
>> +		devip->nr_closed--;
>> +	zsp->z_wp = zsp->z_start + zsp->z_size;
>> +	zsp->z_cond = ZC5_FULL;
>> +}
>> +
>>   static void zbc_inc_wp(struct sdebug_dev_info *devip,
>> 		       unsigned long long lba, unsigned int num)
>>   {
>> @@ -2838,7 +2851,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
>> 	if (zsp->z_type == ZBC_ZTYPE_SWR) {
>> 		zsp->z_wp += num;
>> 		if (zsp->z_wp >= zend)
>> -			zsp->z_cond = ZC5_FULL;
>> +			zbc_set_zone_full(devip, zsp);
>> 		return;
>> 	}
>>
>> @@ -2857,7 +2870,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
>> 			n = num;
>> 		}
>> 		if (zsp->z_wp >= zend)
>> -			zsp->z_cond = ZC5_FULL;
>> +			zbc_set_zone_full(devip, zsp);
> 
> Hello Damien,
> 
> In the equivalent function (null_zone_write()) in null_blk,
> we instead do this:
> 
> 	if (zone->wp == zone->start + zone->capacity) {
> 		null_lock_zone_res(dev);
> 		if (zone->cond == BLK_ZONE_COND_EXP_OPEN)
> 			dev->nr_zones_exp_open--;
> 		else if (zone->cond == BLK_ZONE_COND_IMP_OPEN)
> 			dev->nr_zones_imp_open--;
> 		zone->cond = BLK_ZONE_COND_FULL;
> 		null_unlock_zone_res(dev);
> 	}
> 
> Isn't it more clear to do the same here?
> i.e. set the state to FULL, like before, and simply decrease the
> imp/exp open counters.
> 
> zbc_set_zone_full() does some things that are not applicable in
> the write path, specifically this:
>> +     if (zc == ZC2_IMPLICIT_OPEN || zc == ZC3_EXPLICIT_OPEN)
>> +             zbc_close_zone(devip, zsp);
>> +     if (zsp->z_cond == ZC4_CLOSED)
>> +             devip->nr_closed--;
> 
> e.g. with this new helper, if we are in e.g. IMP OPEN, we will now
> set the zone state first to CLOSED, increase the nr_closed counter,
> decrease the nr_closed counter, and then set the zone state to FULL.

Yes. I am aware of this. It is indeed a bit inefficient, but this makes 
for a simple bug fix by covering all call sites (finish and write). If 
you look at zbc_rwp_zone() for zone reset, something similar end up 
being done, the closed condition is used as an intermediate one. So that 
one should be cleaned up too.

We should improve this, but I think this should be done in a followup 
patch(es) and I prefer to keep this bug fix patch small.
Unless you insist :)

> 
> Isn't it more clear to just set it to FULL directly, like before,
> and simply add:
> 		if (zone->cond == BLK_ZONE_COND_EXP_OPEN)
> 			dev->nr_zones_exp_open--;
> 		else if (zone->cond == BLK_ZONE_COND_IMP_OPEN)
> 			dev->nr_zones_imp_open--;
> 
> Just like the equivalent code in null_blk.
> 
>>
>> 		num -= n;
>> 		lba += n;
>> @@ -4731,14 +4744,8 @@ static void zbc_finish_zone(struct sdebug_dev_info *devip,
>> 	enum sdebug_z_cond zc = zsp->z_cond;
>>
>> 	if (zc == ZC4_CLOSED || zc == ZC2_IMPLICIT_OPEN ||
>> -	    zc == ZC3_EXPLICIT_OPEN || (empty && zc == ZC1_EMPTY)) {
>> -		if (zc == ZC2_IMPLICIT_OPEN || zc == ZC3_EXPLICIT_OPEN)
>> -			zbc_close_zone(devip, zsp);
>> -		if (zsp->z_cond == ZC4_CLOSED)
>> -			devip->nr_closed--;
>> -		zsp->z_wp = zsp->z_start + zsp->z_size;
>> -		zsp->z_cond = ZC5_FULL;
>> -	}
>> +	    zc == ZC3_EXPLICIT_OPEN || (empty && zc == ZC1_EMPTY))
>> +		zbc_set_zone_full(devip, zsp);
> 
> In the equivalent function (null_finish_zone()) in null_blk,
> we instead do this:
> 
> 	switch (zone->cond) {
> 	case BLK_ZONE_COND_FULL:
> 		/* finish operation on full is not an error */
> 		goto unlock;
> 	case BLK_ZONE_COND_EMPTY:
> 		ret = null_check_zone_resources(dev, zone);
> 		if (ret != BLK_STS_OK)
> 			goto unlock;
> 		break;
> 	case BLK_ZONE_COND_IMP_OPEN:
> 		dev->nr_zones_imp_open--;
> 		break;
> 	case BLK_ZONE_COND_EXP_OPEN:
> 		dev->nr_zones_exp_open--;
> 		break;
> 	case BLK_ZONE_COND_CLOSED:
> 		ret = null_check_zone_resources(dev, zone);
> 		if (ret != BLK_STS_OK)
> 			goto unlock;
> 		dev->nr_zones_closed--;
> 		break;
> 	default:
> 		ret = BLK_STS_IOERR;
> 		goto unlock;
> 	}
> 
> This might be a bit more verbose, but isn't it more clear to implement it in
> this way, since the spec (ZBC) defines the transition for each zone state.
> That way, it is easier to follow that each zone transition follows the spec.
> 
> I realize that the equivalent for null_check_zone_resources() in scsi debug,
> is check_zbc_access_params().
> 
> So for scsi debug, the equivalent call to null_check_zone_resources() has
> already been done elsewhere, and can be skipped, but other than that, the
> code should be able to look the same as null_blk.
> 
> Doing so also avoids the unnecessary temporary transition to CLOSED, and
> increasing + decreasing the nr_closed counter, before transitioning to FULL.
> 
> The reason why I don't really like this, is that ZBC does not mention that
> finishing a zone temporarily transitions to close, so why should the scsi
> debug code do so, especially when the the null_blk code shows that it is
> not needed.

Agree. That use of closed condition as an intermediate state is useless. 
It does make the code much shorter, but not more efficient. We should 
clean this in followup patches.

> 
> 
> Kind regards,
> Niklas


-- 
Damien Le Moal
Western Digital Research
