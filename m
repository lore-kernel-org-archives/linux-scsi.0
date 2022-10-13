Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215EFC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Oct 2022 07:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiJMHOT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Oct 2022 03:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJMHOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2022 03:14:17 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72081FF8D9
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2022 00:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665645256; x=1697181256;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/H86QmdHmNqw9rbRkUgsYpbYqQK00hT21Dz7RUHM52A=;
  b=dMCxMD9YOgar0WBujSzrScYs7xLbYM5vuJDWtwYrHGfB1wbTlxWdMvjf
   3693ifU1DuAJEWXv2ocRmN+jvfPtwCpXnbcj/4ClqxIxYZ3xCxa0RNGdB
   vKB+eqXrXenmEVElVr2LppQKBtuhRFouENO3GAq4G8dfkHRAciEpmmFJ2
   nelXF09q+Mc9ePhjTo7b7w8sukHbTBI36NXGDoPP4FKfmedvYPfyZ/X0X
   A4FWcduaTCnu2SHQkCH79ZL05REB4LN9JSZvbfs5KJwWhaRj6GIekr8oZ
   m9iSkuSa6BEusvJhP7ToAh5PXegRAOk6IPxZjnucKEE+1v2rwaIZaRmWM
   A==;
X-IronPort-AV: E=Sophos;i="5.95,180,1661788800"; 
   d="scan'208";a="218864038"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2022 15:14:16 +0800
IronPort-SDR: +pF5+076Ac3yzYpjOhfFAXgjw36Aspj81n8Y+SEaMWvy9S0ZJzRJaLvAjxwI8BefcSh0Zz/mpG
 uR2mKxFtFphBjoomeiuP1DR24idVSKLwJCdbx+oVuwflsZonrxOzwH4ZF7/K36MwAp97xbLsNX
 3D/wLeleIgQvAb+rUVmdU5KOY0yyOAZb09UGOYeJSo6qum+708Wt4umOxp2nD00CE9ROzi+piU
 qdgkSNJhk5AOTiA3VTENNIPxvHo/EFlzE3AI8emn0GDruwHV6c4JFqnP8I4WhzvHtsUmpkZIZC
 JEox/Aaqf9NReTDUGRZa6mHO
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Oct 2022 23:28:16 -0700
IronPort-SDR: h2jYoupyt55j3b6uDWuCbT5RW9pqt/zl4ZkpndpFRXnK4iXDWIf4fC29ifAjEfHmZHHSQrWTBy
 M3+OYbWCP4fN3VBL+BfCVs9rF6jef8UmWyM0EidxhrpEKjGriBvK/n8lEDvJjiEwrcnCrLWdkb
 Ke6L+NvunHhZi2dUsgPlla8R8DPvcpRHHENFBHKehegq1IpZdbxZUlsp/f53m+wIB7AAw32TZ/
 Y/GnhYvH0pZAPpIjjCNP0rlSq/wAMafE7sIgQjsAbJTBQJacMuN8255BBmBV9XIA0uMV5qAG03
 B1U=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2022 00:14:15 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mp13W3xNQz1RwtC
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2022 00:14:15 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1665645254; x=1668237255; bh=/H86QmdHmNqw9rbRkUgsYpbYqQK00hT21Dz
        7RUHM52A=; b=PP/cd2e5X+uSfh7pqBtFW9X+DlWKKF3owepGazTqGjnpaxH3CwN
        u2ahcALZ3BXEIrnixNLL7wwXAVd4+j4aQGlcD8E7j4dR2lj9N1j/FgX801wxeJ3d
        7+kwrBX/w4eg9j9/L7Gv9KxFndH/hDe4JTMEGfoyDFJTGoaSujvM3gtYsGLV9n6i
        2XK5u2vckt4tF8Tqe7/TXCoqXa/tSmL76YCHzTAK7C61TWg+ETgLjBiYJEmUxoTa
        04iYubo+9/KdQ52mV7OacD9ijl2xgWg4FTHBsfIzJnupedfC844OeLc1tHjfJnJj
        +M7BFRXuKD3m0eUQNXzNZ8ZMD7g92qDq4uQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RUecVIHuDy9b for <linux-scsi@vger.kernel.org>;
        Thu, 13 Oct 2022 00:14:14 -0700 (PDT)
Received: from [10.89.85.169] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.85.169])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mp13T5f0Tz1RvLy;
        Thu, 13 Oct 2022 00:14:13 -0700 (PDT)
Message-ID: <4fc8207d-0851-3b38-339d-de1452f6ee4d@opensource.wdc.com>
Date:   Thu, 13 Oct 2022 16:14:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 4.19] scsi: sd: Fix 'sdkp' in sd_first_printk
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, Li kunyu <kunyu@nfschina.com>
Cc:     jejb@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <0e67aa4d-f66e-f392-5950-31b1c90c287b@opensource.wdc.com>
 <20221013044927.278854-1-kunyu@nfschina.com>
 <badf255f-df60-fbc7-0f61-c69b99ebbaa6@huawei.com>
 <45f33e3e-c1a7-7183-bf04-83649af8ac04@opensource.wdc.com>
 <7baa5eb6-95f7-a0cb-6aef-157cf43866e7@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <7baa5eb6-95f7-a0cb-6aef-157cf43866e7@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/10/13 16:02, Jason Yan wrote:
> 
> On 2022/10/13 14:39, Damien Le Moal wrote:
>> On 2022/10/13 15:26, Jason Yan wrote:
>>>
>>> On 2022/10/13 12:49, Li kunyu wrote:
>>>>
>>>> This is defined in the 4.19 kernel:
>>>>
>>>> #define sd_printk(prefix, sdsk, fmt, a...)                              \
>>>>           (sdsk)->disk ?                                                  \
>>>>                 sdev_prefix_printk(prefix, (sdsk)->device,                \
>>>>                                    (sdsk)->disk->disk_name, fmt, ##a) :   \
>>>>                 sdev_printk(prefix, (sdsk)->device, fmt, ##a)
>>>>
>>>> #define sd_first_printk(prefix, sdsk, fmt, a...)                        \
>>>>           do {                                                            \
>>>>                   if ((sdkp)->first_scan)                                 \
>>>>                           sd_printk(prefix, sdsk, fmt, ##a);              \
>>>>           } while (0)
>>>>
>>>>
>>>>
>>>> Most of the sdsk used in the macro definition has only one sdkp.
>>>>
>>>>
>>>> This is defined in the v6.0-rc7 kernel:
>>>>
>>>> #define sd_printk(prefix, sdsk, fmt, a...)                              \
>>>>           (sdsk)->disk ?                                                  \
>>>>                 sdev_prefix_printk(prefix, (sdsk)->device,                \
>>>>                                    (sdsk)->disk->disk_name, fmt, ##a) :   \
>>>>                 sdev_printk(prefix, (sdsk)->device, fmt, ##a)
>>>>
>>>> #define sd_first_printk(prefix, sdsk, fmt, a...)                        \
>>>>           do {                                                            \
>>>>                   if ((sdsk)->first_scan)                                 \
>>>>                           sd_printk(prefix, sdsk, fmt, ##a);              \
>>>>           } while (0)
>>>>
>>>> Use sdsk in macro definition.
>>>>
>>>>
>>>> I did report an error when compiling sd. o in the 4.19 kernel. It was modified to say that no more errors were reported in sdsk. Can I continue the 6.0-rc7 writing method here.
>>>>
>>>
>>> You should backport the mainline patch to 4.19, not create a new one.
>>
>> Yes, but since the mainline patch has a typo, better fix it and backport the fix
>> too with a "Fixes" tag.
>>
> 
> What typo in the patch? I did not see it.

I meant the weird variable name sdsk in the original patch instead of the more
natural sdkp.

> 
>> My point about the proposed patch was to make the reverse change to fix the
>> macro: use sdkp instead of sdsk since the former is used everywhere and clear.
>> But sure, since this is not causing any issue, no strong need to fix the macro.
>> It is really ugly as-is though :)
>>
> 
> I agree that there is no need to backport it.

Yes. Beside using that strange variable name, no problem.

> 
> Thanks,
> Jason
> 
>>>
>>> commit df46cac3f71c57e0b23f6865651629aaa54f8ca9
>>> Author: Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
>>> Date:   Tue Feb 5 11:10:48 2019 +0100
>>>
>>>       scsi: sd: Fix typo in sd_first_printk()
>>>
>>>       Commit b2bff6ceb61a9 ("[SCSI] sd: Quiesce mode sense error messages")
>>>       added the macro sd_first_printk(). The macro takes "sdsk" as argument
>>>       but dereferences "sdkp". This hasn't caused any real issues since all
>>>       callers of sd_first_printk() have an sdkp. But fix the typo.
>>>
>>>       [mkp: Turned this into a real patch and tweaked commit description]
>>>
>>>       Signed-off-by: Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
>>>       Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>>>
>>> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
>>> index 1080c85d97f8..5796ace76225 100644
>>> --- a/drivers/scsi/sd.h
>>> +++ b/drivers/scsi/sd.h
>>> @@ -132,7 +132,7 @@ static inline struct scsi_disk *scsi_disk(struct
>>> gendisk *disk)
>>>
>>>    #define sd_first_printk(prefix, sdsk, fmt, a...)                       \
>>>           do {                                                            \
>>> -               if ((sdkp)->first_scan)                                 \
>>> +               if ((sdsk)->first_scan)                                 \
>>>                           sd_printk(prefix, sdsk, fmt, ##a);              \
>>>           } while (0)
>>>
>>>
>>>
>>>>
>>>> .
>>>>
>>

-- 
Damien Le Moal
Western Digital Research

