Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978BDC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 01:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiAVBF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:05:57 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:54330 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiAVBF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jan 2022 20:05:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642813556; x=1674349556;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EDoVUzoPk8PC+ApM1Npwb6pZfkhTGMrnB+qYUCbCh6s=;
  b=YPT0XhAABkITaVRozsC9zmxYNh+clXOps1v5HEZaAaYYfcFaXgFu3Bro
   QzuJ73can1ikRi/QrO0goL4ZFrG0HA6ljl6bZNWCSAF3yDWE8ARaanR2u
   nzOJOuTJInfsvdnH5QzTYqgezcpg2SaXIrPDl6PMj7s1IplbvblZMTXCH
   6JyI5wQgLnaPaUszodFLSbh64Ipqnj+cmGw5+iszCaWc51JrWNCwk8Dh9
   YQHqeqZtiyWv5vZkGkRWbehdsTjfyyFWSc7s89qkGpXzomXhLML8qgW0W
   YBHOL7wm7hvwTa6NaVaGPdBx0RYFajjWF3GLw0AU/YSI2dFVtqN0FB6RW
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,306,1635177600"; 
   d="scan'208";a="190039949"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2022 09:05:55 +0800
IronPort-SDR: MgT7NB7EGYpZNM7zBnImtP/Fh7zHp1M3rXwClb3j6XwV3K3Qwu1WuYbvuyoVNTCWPyvXw0h/VY
 grYC16Ael/oDv4nOfTkvMPV4sTD4X1W5LK5WxhervWFdnkpv7SsKJ3K7mnvIUNCxk8SG9v3UuB
 +DVRk4ZKUioWkHlGPCGQbslmnKFazuSn5bW3Inua8/nCpbkPaQ+8JnA/n56qVlGwdcdIGoTOow
 WTwSu9qS10vgl+wvuLQL3e0ZdIOIDEqdHuoJUrz0yz43YCgXSpuwFwKrMS3eXQ8SpKSpNuTunF
 PgT9n5Pds+5GANJ1DalybGOJ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 16:39:22 -0800
IronPort-SDR: 6qIgSMQ7y8+AO4Zrt4V7T5u5F4qGW3Ex/dRk8ELaHKqDB2ykj0eKImHiS5C56gW1LtWAdNt5Ub
 3grdlQZzL4drTeqjo3ks0++rcJA7bgR82vP5SbxwG+i9gpl24I/4/B4WoDh8xQ+CrdqiFk23Ft
 bwY/0hFzokAks7AvyS1ub4XKAQE2uZJcgg4iHfX8vIG6LcNwAs5PNt6L8gaKFyzaK1hJZZuhLA
 M1P1Xz85ElzGJQxKMZCOfOlJa8xxth4luoEkIS/JgYzSsOJpF5pqHPpbCoDPeut4Jjuojc/HI1
 yms=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 17:05:55 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JgdNM3mQSz1Rwrw
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2022 17:05:55 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1642813555; x=1645405556; bh=EDoVUzoPk8PC+ApM1Npwb6pZfkhTGMrnB+q
        YUCbCh6s=; b=laqvH3n5ulQIA2iOM3LMA7j2qDazU0fx/aaCyZ973EU+7ajr9IR
        r9Ine3bAOJIvg+5pL5m7G0Av7/3hljRayn04HEchl6pQ4gcXDfmH/Es1B+gb+5Ab
        NNv1B9HMv9B79EPCMfEBKZ+EpkdYf0ST47ObPufP/KDu4tTu8LfNlV4HyYHIcYNh
        cTorKfEFB8YzyLW8T1SRO1N5ljZVyHKISAVVQ8jnkUFnWI6kBPZUANHeRsLC+Fjm
        j6Pi3zC4MJ/S/ktgQQ3bNQ3fhdvwxSjD+Qk/aT51AoJ/zkLo3eNyFgpKcUX2Ltkq
        7yajzA8K+1z3PWrABn/FIJxMEZ0dLIgvWOQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id pdifK8J3Htsd for <linux-scsi@vger.kernel.org>;
        Fri, 21 Jan 2022 17:05:55 -0800 (PST)
Received: from [10.225.163.53] (unknown [10.225.163.53])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JgdNL1bNJz1RvlN;
        Fri, 21 Jan 2022 17:05:54 -0800 (PST)
Message-ID: <b10a0396-8f38-d388-f914-b36178408953@opensource.wdc.com>
Date:   Sat, 22 Jan 2022 10:05:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Samsung t5 / t3 problem with ncq trim
Content-Language: en-US
To:     Sven Hugi <hugi.sven@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
 <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com>
 <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
 <yq1lezbk7v7.fsf@ca-mkp.ca.oracle.com>
 <CAFrqyV5O5u3_BsrOY_E2qfSNWfz5CS0-bymMDGPx00y-f5SezA@mail.gmail.com>
 <yq1tudzidng.fsf@ca-mkp.ca.oracle.com>
 <CAFrqyV6hhTDW9m+azsLGth+Jok=KFc+pkoGnTrsr5qDCazY-Kg@mail.gmail.com>
 <CAFrqyV4n8r6TwNsETfVTv+F_nn8Hg=HuZ6OHgmG_HxPVcvfPzA@mail.gmail.com>
 <yq1wnithm6g.fsf@ca-mkp.ca.oracle.com>
 <CAFrqyV5Pd8LY_wbNOiwjehSURHHmwidW11zjDdRHNBenXrNVaw@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CAFrqyV5Pd8LY_wbNOiwjehSURHHmwidW11zjDdRHNBenXrNVaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/22/22 02:23, Sven Hugi wrote:
> Hello Martin
> 
> I just don't get it, why i get the same problems, as reported with the
> 850 on the t5...
> I mean it's the 2nd t5 i used and i used it on 4 different devices (+
> on the school computer).
> The t5 i currently have, runs really slow on linux and more or less
> without problem on windows, the one i had before behaved really
> similar, till it started to corrupt vm's and then also slow down on
> windows...
> Do you have an idea, what that could be?, or does it sound like i just
> got 2 defective disks?

It may be a drive firmware bug. Note that this article:

https://www.tomshardware.com/reviews/samsung-t5-portable-ssd,5163-3.html

mentions a similar performance problems with older versions of the T5
that do not have TRIM support. It is mentioned that newer versions have
TRIM support though.

So it may be worthwhile to check if a firmware update is available for
your drive.


> 
> Best regards
> 
> Sven Hugi
> 
> Am Fr., 21. Jan. 2022 um 03:15 Uhr schrieb Martin K. Petersen
> <martin.petersen@oracle.com>:
>>
>>
>> Sven,
>>
>>>  -> sudo sg_readcap -l sda
>>> Read Capacity results:
>>>    Protection: prot_en=0, p_type=0, p_i_exponent=0
>>>    Logical block provisioning: lbpme=0, lbprz=0
>>>    Last LBA=976773167 (0x3a38602f), Number of logical blocks=976773168
>>>    Logical block length=512 bytes
>>
>>> lbpme=0...
>>> so, i guess it's not because of trim...
>>
>> Correct, Linux wouldn't be sending trims to that drive.
>>
>> --
>> Martin K. Petersen      Oracle Linux Engineering
> 
> 
> 


-- 
Damien Le Moal
Western Digital Research
