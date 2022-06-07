Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C16C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 09:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbiFGJxX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 05:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbiFGJxW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 05:53:22 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113C043ED5
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 02:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654595598; x=1686131598;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mMX4JSPbl9MTACbffFFECePMnrhemtQ3y7nWClE0gGM=;
  b=TFeTXd/JmXn9TbgkuRR1/eSPeFrkezKtmEgrOvlmUc4ClcFTn/0MoS82
   w2vAzIyZPc4ohDQHqzkVS6VSU0Spd26jsOSA3rhUz47DP/81+ba+rq81d
   re8jVt77ys/uAWhWMvCbGTRwOb7gGRezlWr0B1UkJNjA2Kpk3uG1cH35C
   tfkqC2NgnhWPOT5vBKdNidcpzKW/ArVCzM2jZW0dHWZSaR+Jp1+BVzapH
   Y7e/kyxOKQSQqL/ZKBXAbNgYx65xdiXZFiq4RuBcXN8MdHBCw9N8BgMrJ
   N5uVHxeHOYbE4f2VKyPiJS31i/fgFht4HHjeno3zzPE7DnXTTxH+XkkRG
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,283,1647273600"; 
   d="scan'208";a="201205848"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2022 17:53:17 +0800
IronPort-SDR: MRsY/gQ3MXqdlvwKem1SbPdTp4qg6BNhdHwC+S/ivHlKtChbixijEFNJS8gfktLgo0juszdy8y
 vCLEj57O9MXbH7ng123jVHWdg7LafIrcfz7lWgYUFsTSc9gTQZg0+utF+YVBPG8KIKt5FSjyvB
 kTqp7IHwGl/q2F4wn9jemuWVwDRWi82UP3u0Ee7lW+4WNnnCMA6GBQ28VYqK6XlTWBj55U6Jii
 pjvr4txWWYLUvMGrJ+u4iKmgkDfL828i1reCoSpmpjPrpRtcdXjaJxCFG4dGI6c2gafIksl71i
 J6cBKXoMSDCUzH845gmo58D8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2022 02:16:33 -0700
IronPort-SDR: YFFAosq2s8ZSt9Wj36QCagrrMA7jc+5+10gOyFvY3obiMM9t78cxJmLTDmbNNcgjVlAa26wLDP
 oxoPK3iDYQBsmDk1ZOcAgM548ILAYnsIPvtn/lkGp2rsoZ3rb5MIegt43HCVgeuRNhXm9kuv5/
 VACtroGLahr6npgplI9sEi6RX0Uj1qLacoWTphyagcdbr3PmJivEfjOMb3RBW+xdIJaAWG7Ppn
 1mawVtgAgow0cuh3zcJqeuKMyua5cmF2+QZepsx+3kY1j2pbS0csS6kptJf2M00K9vcaPXZQWi
 LRU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2022 02:53:18 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LHQM50jsjz1Rvlx
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 02:40:17 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654594816; x=1657186817; bh=mMX4JSPbl9MTACbffFFECePMnrhemtQ3y7n
        WClE0gGM=; b=Xy7tt+Y2E800eRjf9e7X6KhNTc0ObDEmmHWSTTPjTds2l+ljH6N
        KoQ1mM13X9IWzzFixFRI4CnOVCN6uyc4RBnc8EZTD72kKmdUzDmrlruhxreVessl
        hoe/ret3U07ES8/O11zOlsTJMb+YhJx1RFJT7JvmQmYdFSrqFC4q671Bnu6bNI3t
        BNaVUQ1WZJ1Cql5pXHDDIt0GtU28vd3zHDq0oXnwuUpUrfLn/BGmNBp+nlXEFuHX
        IyIPvhmZ79sGxGvgbBakBI87IilVWsTOhmvqan1/R7E1SA1gkwyVOG9ovwpbZZud
        w9Xf3jQmfL5efitfUqSTsPyxcG/Wauu4OyQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id IOXbIl9LlTk3 for <linux-scsi@vger.kernel.org>;
        Tue,  7 Jun 2022 02:40:16 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LHQM35sr8z1Rvlc;
        Tue,  7 Jun 2022 02:40:15 -0700 (PDT)
Message-ID: <65a28eb4-31ea-486b-2f77-a7d11418169c@opensource.wdc.com>
Date:   Tue, 7 Jun 2022 18:40:14 +0900
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
 <a2ca3cc1-f948-e9bd-c335-3b75190fac49@opensource.wdc.com>
 <Yp8cRb77m3f7zZTH@x1-carbon>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Yp8cRb77m3f7zZTH@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/22 18:37, Niklas Cassel wrote:
> On Tue, Jun 07, 2022 at 06:25:45PM +0900, Damien Le Moal wrote:
>> On 6/7/22 18:16, Niklas Cassel wrote:
>>> On Tue, Jun 07, 2022 at 10:49:42AM +0900, Damien Le Moal wrote:
>>>> When a write command to a sequential write required or sequential write
>>>> preferred zone result in the zone write pointer reaching the end of the
>>>> zone, the zone condition must be set to full AND the number of
>>>> implicitly or explicitly open zones updated to have a correct accounting
>>>> for zone resources. However, the function zbc_inc_wp() only sets the
>>>> zone condition to full without updating the open zone counters,
>>>> resulting in a zone state machine breakage.
>>>>
>>>> Factor out the correct code from zbc_finish_zone() to transition a zone
>>>> to the full condition and introduce the helper zbc_set_zone_full(). Use
>>>> this helper in zbc_finish_zone() and zbc_inc_wp() to correctly
>>>> transition zones to the full condition.
>>>>
>>>> Fixes: 0d1cf9378bd4 ("scsi: scsi_debug: Add ZBC zone commands")
>>>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>>> ---
>>>>    drivers/scsi/scsi_debug.c | 27 +++++++++++++++++----------
>>>>    1 file changed, 17 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>>>> index 1f423f723d06..6c2bb02a42d8 100644
>>>> --- a/drivers/scsi/scsi_debug.c
>>>> +++ b/drivers/scsi/scsi_debug.c
>>>> @@ -2826,6 +2826,19 @@ static void zbc_open_zone(struct sdebug_dev_info *devip,
>>>> 	}
>>>>    }
>>>>
>>>> +static inline void zbc_set_zone_full(struct sdebug_dev_info *devip,
>>>> +				     struct sdeb_zone_state *zsp)
>>>> +{
>>>> +	enum sdebug_z_cond zc = zsp->z_cond;
>>>> +
>>>> +	if (zc == ZC2_IMPLICIT_OPEN || zc == ZC3_EXPLICIT_OPEN)
>>>> +		zbc_close_zone(devip, zsp);
>>>> +	if (zsp->z_cond == ZC4_CLOSED)
>>>> +		devip->nr_closed--;
>>>> +	zsp->z_wp = zsp->z_start + zsp->z_size;
>>>> +	zsp->z_cond = ZC5_FULL;
>>>> +}
>>>> +
>>>>    static void zbc_inc_wp(struct sdebug_dev_info *devip,
>>>> 		       unsigned long long lba, unsigned int num)
>>>>    {
>>>> @@ -2838,7 +2851,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
>>>> 	if (zsp->z_type == ZBC_ZTYPE_SWR) {
>>>> 		zsp->z_wp += num;
>>>> 		if (zsp->z_wp >= zend)
>>>> -			zsp->z_cond = ZC5_FULL;
>>>> +			zbc_set_zone_full(devip, zsp);
>>>> 		return;
>>>> 	}
>>>>
>>>> @@ -2857,7 +2870,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
>>>> 			n = num;
>>>> 		}
>>>> 		if (zsp->z_wp >= zend)
>>>> -			zsp->z_cond = ZC5_FULL;
>>>> +			zbc_set_zone_full(devip, zsp);
>>>
>>> Hello Damien,
>>>
>>> In the equivalent function (null_zone_write()) in null_blk,
>>> we instead do this:
>>>
>>> 	if (zone->wp == zone->start + zone->capacity) {
>>> 		null_lock_zone_res(dev);
>>> 		if (zone->cond == BLK_ZONE_COND_EXP_OPEN)
>>> 			dev->nr_zones_exp_open--;
>>> 		else if (zone->cond == BLK_ZONE_COND_IMP_OPEN)
>>> 			dev->nr_zones_imp_open--;
>>> 		zone->cond = BLK_ZONE_COND_FULL;
>>> 		null_unlock_zone_res(dev);
>>> 	}
>>>
>>> Isn't it more clear to do the same here?
>>> i.e. set the state to FULL, like before, and simply decrease the
>>> imp/exp open counters.
>>>
>>> zbc_set_zone_full() does some things that are not applicable in
>>> the write path, specifically this:
>>>> +     if (zc == ZC2_IMPLICIT_OPEN || zc == ZC3_EXPLICIT_OPEN)
>>>> +             zbc_close_zone(devip, zsp);
>>>> +     if (zsp->z_cond == ZC4_CLOSED)
>>>> +             devip->nr_closed--;
>>>
>>> e.g. with this new helper, if we are in e.g. IMP OPEN, we will now
>>> set the zone state first to CLOSED, increase the nr_closed counter,
>>> decrease the nr_closed counter, and then set the zone state to FULL.
>>
>> Yes. I am aware of this. It is indeed a bit inefficient, but this makes for
>> a simple bug fix by covering all call sites (finish and write). If you look
>> at zbc_rwp_zone() for zone reset, something similar end up being done, the
>> closed condition is used as an intermediate one. So that one should be
>> cleaned up too.
>>
>> We should improve this, but I think this should be done in a followup
>> patch(es) and I prefer to keep this bug fix patch small.
>> Unless you insist :)
> 
> I just saw that zbc_rwp_zone() does the same after sending my email.
> 
> I also saw that zbc_close_zone() does a:
> 
> 	if (!zbc_zone_is_seq(zsp))
> 		return;
> 
> (Although I don't see a similar check in zbc_finish_zone())
> 
> So one has to ensure that both SWR and SWP are still handled correctly
> when doing this cleanup, so considering that this fix solves the problem,
> it is probably better to leave the cleanup to remove the extra (and at
> least in my opinion, confusing) state transition in a follow up series.
> 
> Therefore:
> Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>

Thanks. Could do a fix like this which avoids the closed intermediate state:

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1f423f723d06..6ff4e03ad521 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2826,6 +2826,27 @@ static void zbc_open_zone(struct sdebug_dev_info 
*devip,
  	}
  }

+static void zbc_set_zone_full(struct sdebug_dev_info *devip,
+			      struct sdeb_zone_state *zsp)
+{
+	switch (zsp->z_cond) {
+	case ZC2_IMPLICIT_OPEN:
+		devip->nr_imp_open--;
+		break;
+	case ZC3_EXPLICIT_OPEN:
+		devip->nr_exp_open--;
+		break;
+	case ZC4_CLOSED:
+		devip->nr_closed--;
+		break;
+	default:
+		break;
+	}
+
+	zsp->z_wp = zsp->z_start + zsp->z_size;
+	zsp->z_cond = ZC5_FULL;
+}
+
  static void zbc_inc_wp(struct sdebug_dev_info *devip,
  		       unsigned long long lba, unsigned int num)
  {
@@ -2838,7 +2859,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
  	if (zsp->z_type == ZBC_ZTYPE_SWR) {
  		zsp->z_wp += num;
  		if (zsp->z_wp >= zend)
-			zsp->z_cond = ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
  		return;
  	}

@@ -2857,7 +2878,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
  			n = num;
  		}
  		if (zsp->z_wp >= zend)
-			zsp->z_cond = ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);

  		num -= n;
  		lba += n;
@@ -4731,14 +4752,8 @@ static void zbc_finish_zone(struct 
sdebug_dev_info *devip,
  	enum sdebug_z_cond zc = zsp->z_cond;

  	if (zc == ZC4_CLOSED || zc == ZC2_IMPLICIT_OPEN ||
-	    zc == ZC3_EXPLICIT_OPEN || (empty && zc == ZC1_EMPTY)) {
-		if (zc == ZC2_IMPLICIT_OPEN || zc == ZC3_EXPLICIT_OPEN)
-			zbc_close_zone(devip, zsp);
-		if (zsp->z_cond == ZC4_CLOSED)
-			devip->nr_closed--;
-		zsp->z_wp = zsp->z_start + zsp->z_size;
-		zsp->z_cond = ZC5_FULL;
-	}
+	    zc == ZC3_EXPLICIT_OPEN || (empty && zc == ZC1_EMPTY))
+		zbc_set_zone_full(devip, zsp);
  }

  static void zbc_finish_all(struct sdebug_dev_info *devip)

Can send a v2 with that. Tested. It works fine too.


-- 
Damien Le Moal
Western Digital Research
