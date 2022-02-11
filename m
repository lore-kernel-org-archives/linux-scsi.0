Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2392FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 12:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344501AbiBKMiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 07:38:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbiBKMiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 07:38:02 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB421A4
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 04:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644583081; x=1676119081;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=kEh0jTHXxmBNlE41aV6VQVBYtoDqoc9X6I4sxM/aIwc=;
  b=DQ1mJQvM/XUQRUwBTMhMSKh8Pj9ufWI4vU1U6en/Ixe9RK+H6B2EtcF1
   X1+l0G99xX9AbpM7pMD5JqAwsemHRLo+PLDEJU573MBHmdOopxKyLNo/l
   NdaGvqNjQFliUj+fLIGWInXTwOKLOyYRY40eos1YB1bPdYNbyrnnzELsz
   cndJAdoOl44UE8oXlcuN0FH1HpT2HdZ7LP8wh+WvvONR36Ck7VaI3+XeP
   iKqZ5rGQUMeo8S30M0xL1tVTvjg2Bm9jUgRB4ygLTkpDYcWJoHSPjF2Ne
   1KjsWYsonB0fsmVDIGEmLVAG8y/w+6Pw/rUd90VTPuXm+jtY4Ot5YTV4G
   g==;
X-IronPort-AV: E=Sophos;i="5.88,360,1635177600"; 
   d="scan'208";a="191632644"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 20:38:00 +0800
IronPort-SDR: IIU1kh8niSci61itpjeWaXstnBkScbnZ7YlYBpmcNq2lsYAGVChGV5bGryuAd6X4iBeIlsRtjQ
 QX1epgQfjhKznFeS3zZthpHDXWDpDeDQpzIWdrXT7UyQX3WjTc2Lcxj8Ged0EmYOpPDe6gx3uW
 QMqaZDjH3cadZ2tEJZaPPsNplcFRslrDuh4vENqDAzohQcFvLxm5TRlU0T+Ddzu3kkUMSNtEte
 8rS10PnbheItYIEXfvdWWqj0M7hdMjm2b2bK1UUdp+nkZd3OPet8ZcccNxwS5l6Yn9Xkx6P48t
 TboZCeEMwxqgJO2h0Ra4XbJi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 04:09:46 -0800
IronPort-SDR: Bw4RBAWgtc1VO5G4uSG36W7w1F7sdMV3f5R+kX0XnISBIXUqB8kSOuoBHhuCBHndkEIGlKBuul
 2KLVKCScRAnZ4EBai+cv73IdZGJBkYtm8KDZ4IV6Z0NxwdB4gJEXr7Zfx8tV61t4/xvkZs+TfS
 9o9bks0j1U3pgva2ErdjsQZGDcIYKQkrwVALNo2KdfepE2QPt0ZOK9dYCb7Vecz9cZfT7RvI5j
 SGcYRRxH97y2rZuI8wXeiWF2lmoZiSb+71kdt6KC022rUKN8Jmdj1sHi0PhWjpgCXaB3+K3GzR
 Yuk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 04:38:01 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JwCnh1sLqz1SVp1
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 04:38:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644583079; x=1647175080; bh=kEh0jTHXxmBNlE41aV6VQVBYtoDqoc9X6I4
        sxM/aIwc=; b=lwCifWAEDBAY4yn/4Ac6wnoSx/L73KWIKjilo3mXAvyV8s63XUI
        ZVnLIE2Z8Ylj0FI1fGC/uL7hYj9rIf6H9zEpgVfLxrCeR3yfuJBebSvfA2SkuM2O
        zs4WKep0ayzY/n+rSTqeU0wPWnj5cTUYbCcNShX8E3M9fVVLLbK7HhMVTTSlZz8F
        nCpf2FoFnd9AYxXRNHDGcxE8aRh2Q0WmI6TFg5e41EQ/LdF00oHlpWWFjwqw2RbC
        Hg1yNZVvvVwQAeE2nkznyJB3h9J8buur2i5LcXlyc/ohxCt2qubgMWjWA0Xs5AQW
        /CwNY1TRJpWYGGkdlrSFJ8WGoRTWp+jn36w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id h-mplCCMfGE9 for <linux-scsi@vger.kernel.org>;
        Fri, 11 Feb 2022 04:37:59 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JwCnf70zCz1Rwrw;
        Fri, 11 Feb 2022 04:37:58 -0800 (PST)
Message-ID: <db9c1fb7-bc0b-5742-c856-4b739bdfec39@opensource.wdc.com>
Date:   Fri, 11 Feb 2022 21:37:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 00/20] libsas and pm8001 fixes
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <b3efd3cf-e36b-9594-06b8-9772bb525e00@huawei.com>
 <ea6b25db-d4da-bab5-8bf2-ec5024c95f89@opensource.wdc.com>
 <af3b0aff-3e43-5a1f-0d98-f68b9100090e@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <af3b0aff-3e43-5a1f-0d98-f68b9100090e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 18:24, John Garry wrote:
> On 10/02/2022 22:44, Damien Le Moal wrote:
> 
> Hi Damien,
> 
>>>> Note that without these patches, libzbc test suite result in the
>>>> controller hanging, or in kernel crashes.
>>> Unfortunately I still see the hang on my arm64 system with this series:(
>> That is unfortunate. Any particular command sequence triggering the hang
>> ? Or is it random ? What workload are you running ?
>>
> 
> mount/unmount fails mostly even after as few as one attempt, but then 
> even fdisk -l fails sometimes:

Try with patch 21 of my v2. It does fix a bug for scsi/sas case. That
problem would likely lead to a crash though, but never know...

> root@(none)$ fdisk -l
> [   97.924789] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
> [   97.930652] sas: sas_scsi_find_task: aborting task 0x(____ptrval____)
> [   97.937149] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
> [   97.943232] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
> Failure Drive:5000c500a7babc61
[...]
> 
> Sometimes I get TMF timeouts, which is a bad situation. I guess it's a 
> subtle driver bug, but where ....?

What is the command failing ? Always the same ? Can you try adding scsi
trace to see the commands ?

If you are "lucky", it is always the same type of command like for the
NCQ NON DATA in my case. Though on mount, I would only expect a lot of
read commands and not much else. There may be some writes and a flush
too, so there will be "data" commands and "non data" commands. It may be
an issue with non-data commands too ?

> BTW, this following log needs removal/fixing at some stage by someone:
> 
> [   98.480629] pm80xx: rc= -5
> 
> It's from pm8001_query_task().
> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
