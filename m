Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E55C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Jan 2023 12:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbjADMiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Jan 2023 07:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbjADMhs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2023 07:37:48 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A8113F0C
        for <linux-scsi@vger.kernel.org>; Wed,  4 Jan 2023 04:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672835862; x=1704371862;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FnrCvyGU8eSnbHP81ntl0TkHG/Rndm8KPRS5Mzaqcrg=;
  b=O9kKtEAvAMIog5llAG9u5TE5iHO7Sfou6ROzaeZ98UBiq1APpTfdONbq
   0w/UR8cgL5XreFW9LCzHQodPWT7wBH5p5nItPUbAvfFkkQHsqL81L0yeO
   XbE9OtxA+cRaxIgY7C1QaCcyUqCZYrmMW3zZZX5c6cuhlNNZcbNAT3Y+h
   O75Nh/3QnOs09t5agPu5upyGiK6xREmsoSQLrYn+6LsVVQlGEQHhiIqWA
   dK8KFGbAE9hVYUToKzCLxLrKWxxkzpWevqqJIQeeOYtUrF51pY4mYx4Nb
   WzYmcalOhuwdsUDM2NFzezuUJEEYEQ2ukItuAbVU6fw+k24jWedH29vas
   A==;
X-IronPort-AV: E=Sophos;i="5.96,299,1665417600"; 
   d="scan'208";a="332005533"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2023 20:37:41 +0800
IronPort-SDR: hoMfL/HGFAfOFuHMYMCY6B5XzRve2lRzP3VEed6LQyTLsPYZdkjf3Lxxw5T5quGEI9LEWXGGhb
 x0BUM78TEpCR5bGcK5KJyUYfSEZO3pJyyJ3Y0WpZ4Skr0ZQ7j54o5gyiLN2DI360jltObCwD1z
 igwCEpqs6vkUZczyZWPmlRlUv2HtHfkU0WJQzZVZZ3g9ExchmdUHf5vCyQoaDWvQC5j+yaWKiq
 BRhnQnkIR9sCySe2tS0NhfAQgA+OOmrop6enZ9vpSh7PveSmuY5STv9DUUoRyvTgE+8EXtfB+M
 8f8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jan 2023 03:55:38 -0800
IronPort-SDR: eP7DDWWOsVUjjjNjANuEDW+9O9vpj+AgxIMB4hl8PnEVAEIxYZTXA2b9cyF5T9QMLxBf3pLkRZ
 /FNQj9HOfnk5w3ZN5wdp/xdIq7ZGhjdaPvdk0aWWFix/cA48vLdp/qSbrjhAdVuJVgtVayEG5R
 xFxZhS56Ox8Vm5SbIOI3MNXHNbre7gq1KJxxFB+AWoPwV/9kGJOZBhGTwjjGyX8Uc20S9iHEcl
 P1dwwcZzszMIV1sOct847k5BMu4l4OJtNx5J21ensLDQ+PwYx04AH/m/9zdaFIWmz2qrm1Az/5
 FWw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jan 2023 04:37:42 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Nn8JP2VSjz1Rwrq
        for <linux-scsi@vger.kernel.org>; Wed,  4 Jan 2023 04:37:41 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1672835860; x=1675427861; bh=FnrCvyGU8eSnbHP81ntl0TkHG/Rndm8KPRS
        5Mzaqcrg=; b=S3Oa2SKPsXtscIo1kzIO1m8vSr9fg+0g0MBrhfUGdO6XRuYXqQZ
        5OHQTiL9g0BhY0GpZ41iJ6fcIOk9UMaClrfRJE32NzajeLysMdWEfDxLRJj/33x6
        eZrzrkdinp8OKRHc1vj3rwvWKw3Fg2EnEY0pVDOrngSNsUTPz1j/Rmd0lmhk0fWj
        pH5jqVfliWAa2Aeg4enaFfobotZPkQld35eerZOzuf9q+dDGxg724A+8C6BGJigQ
        +j2y+HHEycpyHe3D0el/kEhBKknPnBXu5LZY/nlefpIGWSXgLa9jb/0Tsu5cM1FL
        vOYx1Fxz/3j0TGbGz0r9nobDQCnIe2SlN9w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fPUpajPs4JyD for <linux-scsi@vger.kernel.org>;
        Wed,  4 Jan 2023 04:37:40 -0800 (PST)
Received: from [10.225.163.5] (unknown [10.225.163.5])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Nn8JM3jKgz1RvLy;
        Wed,  4 Jan 2023 04:37:39 -0800 (PST)
Message-ID: <3fa9835f-62d3-70f0-d4a2-57dd429029d9@opensource.wdc.com>
Date:   Wed, 4 Jan 2023 21:37:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 0/7] misc libata improvements
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Mikael Pettersson <mikpelinux@gmail.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20221229170005.49118-1-niklas.cassel@wdc.com>
 <49c92e50-5452-8c3e-1517-a0bb1e4e72a0@opensource.wdc.com>
 <Y7VRDQX4fvB2CyZ/@x1-carbon> <Y7VSAR6FmaO+f9RL@x1-carbon>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y7VSAR6FmaO+f9RL@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/4/23 19:16, Niklas Cassel wrote:
> On Wed, Jan 04, 2023 at 11:12:29AM +0100, Niklas Cassel wrote:
>> On Wed, Jan 04, 2023 at 01:43:54PM +0900, Damien Le Moal wrote:
>>> On 12/30/22 01:59, Niklas Cassel wrote:
>>>> Hello there,
>>>>
>>>> This series contains misc libata improvements.
>>>>
>>>> These improvements were identified while developing support for Command
>>>> Duration Limits (CDL). All patches in this series (i.e. V1 of these
>>>> patches) were orignally sent out as part of the CDL series, found here:
>>>> https://lore.kernel.org/linux-scsi/510732e0-7962-cf54-c22c-f1d7066895f5@opensource.wdc.com/T/
>>>>
>>>> However, as these improvements are completely unrelated to CDL, they can
>>>> be merged independently, and should not need to wait for other patches.
>>>
>>> Applied the series to for-6.3. Patch 1 had a small conflict that I fixed
>>> up. Thanks !
>>
>> I had a look at the SHA1 for this patch in your tree, and it looks good.
>>
>> However, patches 2/7, 3/7, 4/7, 7/7 seem to miss your chain sign-off.
> 
> Is this perhaps because checkpatch complains if the same sign-off exists
> twice on the same patch?
> 
> Not sure if this should be ignored or not...
> To me, it seems more important to keep a record of the chain,
> than to keep checkpatch happy, but I could be wrong here..

I do not sign again patches that already have my SoB. linux-next build bot
will complain if I forget signing patches I apply, but it does not seem
that the order matters... Not entirely certain about the correct practice
with that though.

> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

