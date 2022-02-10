Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866FBC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 12:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241455AbiBJMNT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 07:13:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiBJMNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 07:13:18 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7F5116D
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 04:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644495198; x=1676031198;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=8i4SKfs3q/yXdjsjw8bRmcq+MYLofYf2w6FZ/jOLU+w=;
  b=kKgwl59bZd5AH6Hi50BNf2GRaNfASIyvd5yGH3w3ZBxCysnW1Qge0T82
   XxKxnMt51OxEMRxk4TRlG1rKD0QD/ZngyI3iSoG3+XY6xjJFRzuoMHO+Z
   ubRXSUtvhu/tMjvcpm1hxFxDYhEvnI34dPXpMOhLtCPUMmk9Yl+jb/qBU
   3sDqDz9FcvtOY+Cgpkg/6rZZE2cIN0byqE2vmaLW6Lhtfn4d9W4Q0VQBp
   KCGGZ1MzOOzO2O7GgEFTQxIjXRtxmtBnTQu7l1aNVJuW4cRnrjawk+Bvb
   dYUVF6wyl9ijBvjj6vdpzhVG14UUJbCmjBFJTJEI80zcCxNM9UnbWqsiP
   g==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="296697354"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 20:13:18 +0800
IronPort-SDR: GZ4vGOXLsT1eQtOM3VAR//V66xPLhPK/8Aclaj+csB/JGq/p9u/pn/OK4aWXhbqoboJd/cwsuk
 0HutDwjUlyvtVMWxGw14MbWouxEnKQTuCHVaRkdMuDyzF059GK7j/WTgU+GOaAgGVGLGuGmtmx
 umhIUK6Dw/i+V4aa9JMt8YjSwMB2OIYZZ86QBS6Pbd3YO77BkkK2x/lGugJD/LWtxXw3xhkbXx
 8nuCV+5as4iaDxPIjnHjenNaFNMae10m67ywZB2n2pjwKcPbI3JWmIRSlohBaRr5vKHeWT9lEU
 xZWrUbVq73XPqSHq+pJ5owWa
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:45:05 -0800
IronPort-SDR: Gf0JRhW+y7NLCodMXeSXKyh2KdmPy0OLC2ZZ0XyZyvscJOa27nmhnIiKjB3+CQ2SgDZuRS05bp
 82ZaLghKrQdRSZForp47YQ9lOF8LpuuTnz0m/+UAPXKHTgBGDOuYfsJM1AzOyafb+6Gf63o8r/
 OHF+Apn7aeUqc6DwQO0X0duI3uKeJOeSM0eTGeCvYzt3dmLO7z+hID8Z9UnxByb1J9aji8m8mV
 LilwZypte00d9QvyFubNmdWdj9ynfEL4TUxISchhuNcg6A8CjH+Nya9jSisLhhq/FbjoaGSUzf
 VcM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 04:13:18 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvbHd6M1kz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 04:13:17 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644495197; x=1647087198; bh=8i4SKfs3q/yXdjsjw8bRmcq+MYLofYf2w6F
        Z/jOLU+w=; b=StkHQg+0gBzDwbY8HJ6b8oasQY5nIcAROMqOKaNvFoQJ4bwGrPF
        ammtFIBzq5KtTWQ2apYVUVunJPdLf7fwg3fyZWZoS4yuXcNL/q1JpW5wwiabv/C/
        1rCV7GYsxacVfu1kELmo5pa7ezeGNUE2pBZ1RG9IQJvNvgCsEMcvKhvoLyFbJUTD
        dfz1+gwawbA2cmW2f52v38fxYJsk53JumYSBHJI9762PlK+BOvKfHkyJT++Tc2XS
        9jAvddNKHta1c2md5E49QbBt7YMoklkWJvvvHYfkyKQbLfQkG4KYgpjWOTaIr9H0
        pqdhtlDYnxxa8oO72cQM2ykBEMN+cBw0PPQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PKeldK46VCD9 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 04:13:17 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvbHc4Jvyz1Rwrw;
        Thu, 10 Feb 2022 04:13:16 -0800 (PST)
Message-ID: <1438ac19-44d3-511d-cdda-33bf8c322904@opensource.wdc.com>
Date:   Thu, 10 Feb 2022 21:13:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 05/20] scsi: pm8001: Remove local variable in
 pm8001_pci_resume()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-6-damien.lemoal@opensource.wdc.com>
 <47237ea4-4c86-d1f6-aec6-747bf305b2c2@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <47237ea4-4c86-d1f6-aec6-747bf305b2c2@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/10/22 21:04, John Garry wrote:
> On 10/02/2022 11:42, Damien Le Moal wrote:
>> In pm8001_pci_resume(), the use of the u32 type for the local variable
>> device_state causes a sparse warning:
>>
>> warning: incorrect type in assignment (different base types)
>>      expected unsigned int [usertype] device_state
>>      got restricted pci_power_t [usertype] current_state
>>
>> Since this variable is used only once in the function, remove it and
>> use pdev->current_state directly. While at it, also add a blank line
>> after the last local variable declaration.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Regardless of a couple of comments:
> Reviewed-by: John Garry <john.garry@huawei.com>
> 
>> ---
>>   drivers/scsi/pm8001/pm8001_init.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
>> index d8a2121cb8d9..4b9a26f008a9 100644
>> --- a/drivers/scsi/pm8001/pm8001_init.c
>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>> @@ -1335,13 +1335,13 @@ static int __maybe_unused pm8001_pci_resume(struct device *dev)
>>   	struct pm8001_hba_info *pm8001_ha;
>>   	int rc;
>>   	u8 i = 0, j;
>> -	u32 device_state;
>>   	DECLARE_COMPLETION_ONSTACK(completion);
>> +
>>   	pm8001_ha = sha->lldd_ha;
>> -	device_state = pdev->current_state;
>>   
>> -	pm8001_info(pm8001_ha, "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",
>> -		      pdev, pm8001_ha->name, device_state);
>> +	pm8001_info(pm8001_ha,
>> +		    "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",
> 
> I think that we may put this on the same line as pm8001_info
> 
> Feel free to ignore this: if we're ok with changing logs, I am not sure 
> on the "slot" value - it is already printed with pm8001_info. And 
> printing pdev is suspect, since we should really be using dev_info or 
> pci_info() and friends - but that is a bigger job.

Yeah... This driver debug messages are a nightmare: hard to read format
and not-so-useful information. Not to mention that the default log level
is way too verbose... We should revisit the messages once we have
flushed out all know bugs :)

Thanks for the review.


> 
> Thanks,
> John
> 
>> +		    pdev, pm8001_ha->name, pdev->current_state);
>>   
>>   	rc = pci_go_44(pdev);
>>   	if (rc)
> 


-- 
Damien Le Moal
Western Digital Research
