Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FC7C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiBRDNM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:13:12 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiBRDNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:13:11 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB49387AC
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645153975; x=1676689975;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=VnJd2o5itS/4TPuSd4ZcOr19TSk4abFVlw5aIt3z+1I=;
  b=jst5ttb+rlzlIxZa8/i1dl6HH62lmCGz1JRLmiEVTKZ3clKnPth0+gOq
   mP2bfSJrC/5XeTgbFwPgukXvmaeGzV9yXQf09m6HBvKdyFHonHpkX/Toa
   rMZxFZIbmRWQBxi+fjzl7eJOJ0/9klM21afCvxJBUIQF2zPFmh+5zRG3V
   c5QUFzNcNLZ4/0SpDR/T4LVykCZQXUICM4q2JLoSBeLK6/KpAl2lXZ49D
   ws5+RSPRFW/u4N4uPQ5jnxno9r1uq9UfC6z1l+XkksZBO/NCD1JeNE2bO
   p2XVGNfR5JJh108atPM42QBYtWPFDyi1Xt8do38WoGqI4Bcp92XYMqvR5
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="305149289"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:12:54 +0800
IronPort-SDR: 1ohBqAVRC61yWIYyUQkJVovXK6PkhwJ28LxzCTs+v79OFRaCWYykMxSQgv+24O1fbsceofV3Ng
 VuyX/AfSdMbVmfaEc4DgDpSk34TPtLs7yHFOHLdjrfGCUAt/18sOres9vJJDmDG7KbzCodIwMw
 mNK4lHZPwS2heWaSXBF3fYJuUxJwGus+0Qid6VCy03cZNQxnW8qHQDREWNc3xx3IWq9JgpqjyY
 YZRxvOK98vG1uUeTUVtoI004w/1CnqCioOgKQ8J/MhecluirjexSO6ZxjgPBg3U88s7rMWmR/L
 5OcecmGzIyYRx6FHR5FTls2n
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:45:39 -0800
IronPort-SDR: G+Uk/myGmORnMeZP73PljvTpua3xdDwDXuZ8isGoEn0ELsLbyWbEDKt9MNl3oviFAOPF9Xuohu
 brDmuSaaHD9bu0yxNKdLHP4ujjAED+8aRqKZHYwuuG1H28rIV22qR6DQvvfRKd7A4yCuwI5BtX
 H2ybl9N2n2/Gpqt1z71IHXQxEWGsh9OlPNUsYx0UdvlMXhMUloIu9ZtZaHyyiiGEYfADfC07U3
 E9RXwmpGN2aUdIbIyrKAlB9T8ixC/vWKDEl25knLl/4IKB9l5zbZr0V70NsG8FZbQl6b6t5bSB
 wHM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:12:54 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0GwQ1MFFz1SHwl
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:12:54 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645153973; x=1647745974; bh=VnJd2o5itS/4TPuSd4ZcOr19TSk4abFVlw5
        aIt3z+1I=; b=HWE8GomcT6squzgGRBk0J7Kxq1VbQvyhc8vcT1JbDfEbH8NV2dE
        7U91VqOeCQiiBtPVcrQJ9tv+yCy5YA4YHDseJvWjgudwDiHk5zZX8BKKNmNmwOjW
        85DGZVvJJEPTi1i1nVhFihWa2tIQrHo5Ny5P41ltGwgfhsyIkO8IgMGISR8x/otJ
        3zJaiLGX73GMnGyry+lcolqXVmglM04ZW3Ni9jCuc38qSny6b+Z8gtiiqWWD+ij0
        J1CVQoPNQ0HZXfqgd0DUoVZwl0uja/2eOrptWf23wBVgsFaTdOn4IBt9Di1lueMJ
        MjT5R4TeUaezlGBBJLQmZWikkNoFlAV6Abg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hlj0r1o0xI_U for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:12:53 -0800 (PST)
Received: from [10.225.163.78] (unknown [10.225.163.78])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0GwN4LZJz1Rwrw;
        Thu, 17 Feb 2022 19:12:52 -0800 (PST)
Message-ID: <04a7d878-f5dc-6058-fc29-c72139d13aa3@opensource.wdc.com>
Date:   Fri, 18 Feb 2022 12:12:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 27/31] scsi: pm8001: Cleanup pm8001_queue_command()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-28-damien.lemoal@opensource.wdc.com>
 <51d7c127-f975-14e9-a036-c37416ed8679@huawei.com>
 <32efd519-3485-ee34-84e2-34a0d8c27e17@opensource.wdc.com>
 <38090771-ad24-1b20-9b79-f7f89d42ea66@huawei.com>
 <37df3c92-c28e-72d4-76d8-33356829af5a@opensource.wdc.com>
 <5a5481af-e975-c6fb-2d48-961769eae551@huawei.com>
 <9c22abeb-1b22-4613-66bc-276aaa4a639c@opensource.wdc.com>
 <e7b5c48b-4217-7247-8bc9-e5f8ae9411ce@huawei.com>
 <e9b40eaf-7aa5-798b-1bde-1a2ce8d83433@opensource.wdc.com>
 <712a4702-8534-fad2-2679-cc5cf62e4a9e@huawei.com>
 <ba58ea9e-430a-ec22-e67a-ceb632e99f33@opensource.wdc.com>
 <28cfcd43-e006-ab26-2d58-47384ae49146@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <28cfcd43-e006-ab26-2d58-47384ae49146@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/17/22 21:49, John Garry wrote:
>>>>
>>>
>>> I figured out what is happening here and it does not help solve the
>>> mystery of my hang.
>>>
>>> Here's the steps:
>>> a. scsi_cmnd times out
>>> b. scsi error handling kicks in
>>> c. libsas attempts to abort the task, which fails
>>> d. libsas then tries IT nexus reset, which passes
>>>    - libsas assumes the scsi_cmnd has completed with failure
>>> e. error handling concludes
>>> f. scsi midlayer then retries the same scsi_cmnd
>>> g. since we did not "free" associated ccb earlier or dma unmap at d.,
>>> the dma unmap on the same scsi_cmnd causes the warn
>>>
>>> So the LLD should really free resources and dma unmap at point IT nexus
>>> reset completes, but it doesn't. I think in certain conditions dma map
>>> should not be done twice.
>>>
>>> Anyway, that can be fixed, but I still have the hang :(
>>
>> I guess (a) (cmd timeout) is only the symptom of the hang ? That is, the
>> hang is causing the timeout ?
> 
> Right
> 
>> It may be good to turn on scsi trace to see if the command was only
>> partially done, or not at all, or if it is a non-data command.
>>
> 
> I could do that. But I think that the command just does not complete. Or 
> maybe it is missed.
> 
>> And speaking of errors, I am currently testing v4 of my series and
>> noticed some weird things in the error handling. E.g., with one of the
>> test executing a report zones command with an LBA out of range, I see this:
>>
>> [23962.027105] pm80xx0:: mpi_sata_event  2788:SATA EVENT 0x23
>> [23962.036099] pm80xx0:: pm80xx_send_read_log  1863:Executing read log end
>>
> 
> I don't know why the driver even does this, but the implementation of 
> pm80xx_send_read_log() is questionable. It would be nice to not see ATA 
> code in the driver like this.

I have been thinking about this one. We should be able to avoid this
read log and rely on libata-eh to do it. All we should need to do is an
internal abort all without completing the commands. libata will do the
read log and resend the retry for the failed command (if appropriate)
and all the other aborted NCQ commands.

Need to look at how other libsas drivers are handling this. But the
above should work, I think.

Not adding this to the current series though :) That will be for another
patch series.

-- 
Damien Le Moal
Western Digital Research
