Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059D3C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 01:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344374AbhK0BVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 20:21:09 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:31208 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344734AbhK0BTJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 20:19:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637975755; x=1669511755;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=utQLa83hwo/LT3g1aLDWo1eI0/DqR7aayg7wMGJqu70=;
  b=PaM00NptkjtmrALS5KbAG6C90/qhBS5TJqCyH7cjw9F+chJIwodT6LHQ
   a/EbVrk1gqBm4AhBfFfskB1GTVxEvoMnDY91CvH+DI9XedkdtmYwUUwkQ
   3VKOErqH+bPjSX8MnQDFP0FnziybB/EOffY+wjnRqDI9XD702QxbRMkut
   tKa3hEFDv/u4kRSnC+ejhzgfJOAfwZxKVry42GHdXXiFaIWkEV8YqzyB7
   ZVsMcUYisgJVeQLCJ5qhNIprDdKutJxLqynZbxv1ipk6O5+kcUqAww1xF
   JNIuC+cS1FO2NsITAH3EctNyEp0VNEvzTpBWPxbOC/BKGCPeB8hwS2K0A
   w==;
X-IronPort-AV: E=Sophos;i="5.87,267,1631548800"; 
   d="scan'208";a="185778781"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2021 09:15:55 +0800
IronPort-SDR: RJdAn8+W4LCPx1FWTTXIdpvK9YvT4cIANWmh2IeUc7bCXNJCMmaGXtdrv1mIhDNYink04QCg0o
 /wVH6YGk5L3EeAzJOrpfNCsU+fbVUgkaOhXxC0BWkxZ9BPgk+8rS6QgcJUuf0b0O0XhrBxpLLj
 82/ZG3DzC81Vc65HFTclvWu4uT1mzGLmlYiFJIEK9Sv6Kz8yKVpwZM0oeYhaNGbyM7HDYf4i5h
 Ljbcr51ssCcxqd1RJz1pFrWVZMxFbH2Ew5ACLlZbNl6/mQfGO+WPVKBOEn1U/PJz5nOcQUh6qC
 ukhWD4GJwGKVRmryYeZ6eHH1
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 16:49:12 -0800
IronPort-SDR: 4Km/JKF3RnylIBXV17seHhmsbWej2RHXCiF2oBdh4J8Vp8f+ip83g/I+xUQjKlUA0rMDHbCKzy
 etfexprn85g8Ctq/6yV+W+luWC2eyJ3ronuMvbm7Z+KH2waOeZgiR/6SowaNxrIOZeRNZOUKFZ
 kxs/tHj0/uqfLanM2ZWdIoIy0anx4lhgXaPuySdoEkcg9mAwED63zP1SV4PZEsCJkKIsl68g0j
 jRcLjxv/gE8TNuvIgSKoWk7OZpHE/MdRJHiiEyoWPUHb2r+6jPIeUK/x5Hn3ciImFEPC0xUDNE
 5ts=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 17:15:55 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J1DFk6R59z1RtVn
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 17:15:54 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637975754; x=1640567755; bh=utQLa83hwo/LT3g1aLDWo1eI0/DqR7aayg7
        wMGJqu70=; b=Xuo7PYG1tXSUDqz8aNP4JV/uYIPuHQF4yk9dy8GhY9SpAaSJ82G
        KrB3oIiVJXJpi7AP3LbCGaluD0UpqJU1loHZfF17eMxg6wxR3t2UubnAhCMAAI0c
        l9Fcaok+yRsVwsuzapM0UTrAKbt3QbcbqBKXqxLPKoBGllu0Lh2wEbXPsfFq1b+b
        oEoLQFDpkpo7VCgf1MJ6KtBLfJzuqySOU6jWxQXX1ay8Tpy2GziOow03s2fzWOPB
        Tp1gZM0l5hTpTYdkw0BhrWH9Park2jEocDbEZRVYBQm9ZfTTfoasxNkJPPSzn5/W
        bP2OCBJ2mEPuqcjElnDjQMP8vyrFVFsqfNA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DzfKX1DGc1hv for <linux-scsi@vger.kernel.org>;
        Fri, 26 Nov 2021 17:15:54 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J1DFj1ZRdz1RtVl;
        Fri, 26 Nov 2021 17:15:52 -0800 (PST)
Message-ID: <92cc74fd-ce93-b844-830f-71e744e0c084@opensource.wdc.com>
Date:   Sat, 27 Nov 2021 10:15:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [Regression][Stable] sd use scsi_mode_sense with invalid param
Content-Language: en-US
To:     Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org,
        damien.lemoal@wdc.com, martin.petersen@oracle.com,
        sashal@kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
References: <CAGnHSE=uOEiLUS=Sx5xhSVrx-7kvdriC=RZxuRasZaM2cLmDeQ@mail.gmail.com>
 <CAGnHSEmFoAS-ZY6u=ar=O0UU=FPgEuOx5KLcBWkboEVdeFXbGg@mail.gmail.com>
 <CAGnHSEmkTyq_QqP9S6TemsHOKxj2Gzq3R7X6+PxbQs_R-iBB7Q@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <CAGnHSEmkTyq_QqP9S6TemsHOKxj2Gzq3R7X6+PxbQs_R-iBB7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/27 6:33, Tom Yan wrote:
> Hi Greg,
> 
> Could you help pulling c749301ebee82eb5e97dec14b6ab31a4aabe37a6 into
> the stable branches in which 17b49bcbf8351d3dbe57204468ac34f033ed60bc
> has been pulled? Thanks!

Yeah, in retrospect, these 2 patches should really have been squashed together.
Sorry about that. Note that none of these were marked for stable though. I think
that Sasha's bot picked-up automatically
17b49bcbf8351d3dbe57204468ac34f033ed60bc for stable because of the "Fix" in the
commit title. But c749301ebee82eb5e97dec14b6ab31a4aabe37a6 also has "Fix" in its
title but was not picked-up. Weird.

Greg, Martin,

To fix this, c749301ebee82eb5e97dec14b6ab31a4aabe37a6 is needed in stable !

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=215137

Thanks.

> 
> Regards,
> Tom
> 
> On Sat, 27 Nov 2021 at 05:21, Tom Yan <tom.ty89@gmail.com> wrote:
>>
>> Ahh, looks like the required change to sd
>> (c749301ebee82eb5e97dec14b6ab31a4aabe37a6) has been added to upstream
>> but somehow got missed when 17b49bcbf8351d3dbe57204468ac34f033ed60bc
>> was pulled into stable...
>>
>> On Sat, 27 Nov 2021 at 05:11, Tom Yan <tom.ty89@gmail.com> wrote:
>>>
>>> Hi,
>>>
>>> So with 17b49bcbf8351d3dbe57204468ac34f033ed60bc (upstream),
>>> scsi_mode_sense now returns -EINVAL if len < 8, yet in sd, the first mode
>>> sense attempted by sd_read_cache_type() is done with (first_)len being
>>> 4, which results in the failure of the attempt.
>>>
>>> Since the commit is merged into stable, my SATA drive (that has
>>> volatile write cache) is assumed to be a "write through" drive after I
>>> upgraded from 5.15.4 to 5.15.5, as libata sets use_10_for_ms to 1.
>>>
>>> Since sd does not (get to) determine which mode sense command to use,
>>> should scsi_mode_sense at least accept a special value 0 (which
>>> first_len would be set to), which is use to refers to the minimum len
>>> to use for mode sense 6 and 10 respectively (i.e. 4 or 8)?
>>>
>>> Regards,
>>> Tom


-- 
Damien Le Moal
Western Digital Research
