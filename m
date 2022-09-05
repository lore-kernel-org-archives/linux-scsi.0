Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE11ECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Sep 2022 23:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiIEXYB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Sep 2022 19:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIEXYA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Sep 2022 19:24:00 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7875564F6
        for <linux-scsi@vger.kernel.org>; Mon,  5 Sep 2022 16:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1662420239; x=1693956239;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xzJjcEQ6nwbRfcAe2RWK+6911ZZFQnH0zlriKMmSkiM=;
  b=kjXIEO51ezSzN2W77vF2xB7YcO1N9BdQuWtzaboDt6Kdxbxb0gKctHeg
   UKcAN5jks2yC4UnnpJjq+7RSxIknTRQ5N1exjqCncO/XJcD6HWG14KV0M
   +ee/5x1u75xRf036+DYoQe77n3zsBz04AnAhv6oFad4BLmQKu0qKvqrGn
   fHPGco4A5ga2TfOXv6EJknta6Ws+lfv5vChpoKjrQxc3kh9Xl+mnKCFxu
   yvuGl9r1Vexyxy3ngDYQNHTNBHpYhyUXNgPovOh/15sKqvHEc5pb5D0il
   ftptWeS8hqwSDnBduc36uXL64HQTAONSa7Don2wSIhc9aYt6OZPjxad8y
   w==;
X-IronPort-AV: E=Sophos;i="5.93,292,1654531200"; 
   d="scan'208";a="210560219"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2022 07:23:58 +0800
IronPort-SDR: XblYLJcr07z45xke7k2tp0+B/bBBNjMyVdTD+RNdrNR2Hft04wTqbqz2th60TVjtMrr7i0dZd3
 ujD9F3mdKvhSGfEgImRDpN61CCp1gKTkRzjJuqgXcFM3HHjvhwG1GE0ikwpdVAT/NBhPCllGpE
 q5t2fq5ARvAWP8u9YbEC6aVNSC1ZC98b+B95ZV7HTxUqAXYq2s14ZJY7ffyEfiW1nN8e9WtNXM
 ydBnVb7hSfkYJTYrp5F4YjmMbwSqjRdS0rPRvooavbOg64yURBvJ9iGUgBWWnHZ//CAKTBgqdz
 UivWxdcc71bU9IJRdQzAN4KW
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2022 15:38:57 -0700
IronPort-SDR: Rvd+rQa3Obucq1fOjuZWEUBCGRa1dE7iGgSF62u7HKLZWbvh+Z6p+uLx8rac2Uh6P2r1vkkeL/
 NsxjhJxM/4eEtZ4AXC0MYMHZejm4Rg3UiQkoNksPh+kNAufQA6xZUEPK2idtJwF+k04H0dOMAr
 iBkf/Yxv3LhP3yEoBaqXl+qHhZ+raYG1TGUTwAOw1MWZ2oLub9XUu8kXWRxyG/cDx3PfAHD1XC
 y963QOTXo+J1wO7HYC6JaCr6fYECEJY/+qgjfyQaBsOWF26cisfftChGHmwDpUOKWmU2E4WwCE
 /ss=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2022 16:23:58 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MM4My0Rmjz1Rwtm
        for <linux-scsi@vger.kernel.org>; Mon,  5 Sep 2022 16:23:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1662420237; x=1665012238; bh=xzJjcEQ6nwbRfcAe2RWK+6911ZZFQnH0zlr
        iKMmSkiM=; b=U7NOAUKosav0Z5e6Kn6yvqKSnUNNEOvf+ZEsYOoS6p0/DdzlF4o
        wgCd/7PsDo4I5opwebI54VL1+MyL0qdXBE8z1MCBaoC3XgLdUH4JH6jNml7FtDaO
        g12gpLrPMoL4ozuP0LRTGoHPsOYdFxY9+cWdulNUZC9VAXrSmu8mZM7s/hntkyNa
        Ge12dbuReoLEQs2XrCO2oKdbec+1r77I51GyW3aSMDw45cgahjvlX9B5Q2DjeTgU
        RHJ56+vNzg8YZ8s7BlmSrxbpwSBkyrG/G6a6Mhps8tOElxh1s3jebQV9IKQz4U/C
        GKEh/f8U3AFxUfDSPRm9hrtDf3PVB+26cSg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZhJa2Uz-9iP4 for <linux-scsi@vger.kernel.org>;
        Mon,  5 Sep 2022 16:23:57 -0700 (PDT)
Received: from [10.225.163.60] (unknown [10.225.163.60])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MM4Mv5lg0z1RvLy;
        Mon,  5 Sep 2022 16:23:55 -0700 (PDT)
Message-ID: <3105a674-f976-95c8-f1d9-35034d91c5d4@opensource.wdc.com>
Date:   Tue, 6 Sep 2022 08:23:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 2/6] scsi: libsas: Add sas_ata_device_link_abort()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com,
        yangxingui@huawei.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, hare@suse.de
References: <1660747934-60059-1-git-send-email-john.garry@huawei.com>
 <1660747934-60059-3-git-send-email-john.garry@huawei.com>
 <0bb6b134-7bad-7c39-ad6d-25d57bd343eb@opensource.wdc.com>
 <018080d5-fbc4-7f04-0d3f-587f2397cd20@huawei.com>
 <baf63982-810c-85eb-b28f-99ab0517c6ba@opensource.wdc.com>
 <eb3465a2-335e-a605-ba8a-4cce790b5b02@huawei.com>
 <4b471300-a912-c3c0-ead4-7165c57cbbf8@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <4b471300-a912-c3c0-ead4-7165c57cbbf8@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/3/22 01:19, John Garry wrote:
> Hi Damien,
> 
>>>>
>>>> But the pm8001 manual and current driver indicate that the
>>>> OPC_INB_SATA_ABORT command should be sent after read log ext when
>>>> handling NCQ error, regardless of an autopsy. I send OPC_INB_SATA_ABORT
>>>> in ata_eh_reset() -> pm8001_I_T_nexus_reset() -> pm8001_send_abort_all()
>>> You lost me: ata_eh_recover() will call ata_eh_reset() only if the 
>>> ATA_EH_RESET
>>> action flag is set. So are you saying that even though it is not 
>>> needed, you
>>> still need to set ATA_EH_RESET for pm8001 ?
>>
>> As below, it was the only location I found suitable to call 
>> pm8001_send_abort_all().
>>
>> However I am not really sure it is required now. For pm8001 NCQ error 
>> handling we require 2x steps:
>> - read log ext
>> - Send OPC_INB_SATA_ABORT - we do this in pm8001_send_abort_all()
>>
>> pm8001_send_abort_all() sends OPC_INB_SATA_ABORT in "device abort all" 
>> mode, meaning any IO in the HBA is aborted for the device. But we are 
>> also earlier in EH sending OPC_INB_SATA_ABORT for individual IOs in 
>> sas_eh_handle_sas_errors() -> sas_scsi_find_task() -> 
>> pm8001_abort_task() -> sas_execute_internal_abort_single() -> ... 
>> send_abort_task()
>>
>> So I don't think that the pm8001_send_abort_all() call has any effect, 
>> as we're already aborting any outstanding IO earlier.
>>
>> Admittedly the order of the 2x steps is different, but 
>> OPC_INB_SATA_ABORT does not send any protocol message to the disk, so 
>> would not affect anything subsequently read with read log ext.
>>
>> Having said all that, it may be wise to still send 
>> pm8001_send_abort_all()..
> 
> Have you had a chance to consider all this yet?
> 
> I am now starting to think that it is not necessary to call 
> pm8001_send_abort_all(), and instead rely only on 
> sas_eh_handle_sas_errors() -> sas_scsi_find_task() -> 
> pm8001_abort_task() -> sas_execute_internal_abort_single() -> ... -> 
> send_abort_task() to abort each outstanding IO. Then we would not have 
> the issue of forcing the reset in $subject (to lead to calling 
> pm8001_send_abort_all()).
> 
> This idea could simply be tested by stubbing pm8001_send_abort_all()
> (and dropping the |= ATA_EH_RESET in $subject).

Send a re-spinned patch and I will test :)

> 
> Thanks,
> John
> 

-- 
Damien Le Moal
Western Digital Research

