Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E4BC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Oct 2022 21:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiJEVgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Oct 2022 17:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiJEVgL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2022 17:36:11 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF8080483
        for <linux-scsi@vger.kernel.org>; Wed,  5 Oct 2022 14:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665005770; x=1696541770;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ktz8tDfnp0zJ/uEQE1L0r1FZfkFQaxNTK01YLZAUUsg=;
  b=n0gT5oa91bLWDhIORhT8u3aHH+pNNx2MyB+Ha4MMDFXvHSw2Myla0OrD
   r4gmg2ZykLXlOC2w77uSMddpxD3gjJpoSN6d+nwVDH/62fNnliVLtg1Pn
   4+cbmjJEHqFpP90OZPgzls3x3B7ULnPb3f0LlenjCHR4BCi557re0Ac0U
   ndixw0LvQxAOe6XXoekMl9f1cuIat1XEPAcUdPcEGKtnYf0XskwJTsXUh
   1S9RObpnhlERlDSwaWy4tT2SiMw2BhSmxu2oewGBIkWz36BZXMGJFHWFr
   UaobedsdhK6JAGVjgXk67rs2b+o+R02PhNUw/5ZfbUGoWp7fQ9KkusAiM
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,162,1661788800"; 
   d="scan'208";a="218256938"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Oct 2022 05:36:09 +0800
IronPort-SDR: jzJJAMdJ/ZnhVDDEg0ci5XA9DbWw5C5e6Jhyes7TCyDczMvXo5dWTNltskedPKIxiuyoCrmmQb
 OJjew/3kKPPDS3YODkR3eWqDi47H4T0dxGSbU62G3tnUZMcKWasx5Qg1xgxLfyydCi1MLMqKqR
 f9EV8xVO/i/NQyFr1rQ7IdIKZjT2JInW4/rzbQPYMVYaYfndDfr49EAXAVaE0+up9ZlSQB+q6y
 5xFaLw8epdtxKlqc/UoCBSCufRsv/8eNps1wyKQtdSaWQfL/nJLmQH90XGcx5inW3/zFI31XXG
 f/+kH6VBGhVbY6DnvvwHymdT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Oct 2022 13:55:55 -0700
IronPort-SDR: FZBHCTrV1gXdSY44PuR1vgtbNYGplBE6h8shXZ6TaXtnSyG04IehiZcrtJltxY9aNFfFRLRKyj
 yAGYtE/PIUHqeDGJ/wEHnYTXi/kgzUwMIxbCxYoMtczdotrhXZQdDr3gyt6zklommz4WpjmSxH
 2qptGlbU4gDcurelRqXECVenLjMqhOvC5sZCIWul1VP4TTh1ntJGFGP7K9GVfDdcxGqNdbE8VV
 shUjV0MtZrmKqcBzmsTS4mzsQhZsvUbFzNalRgPZ7JTLl/kOb63yyERLUXviwoWovf0Q7j+mBy
 DNc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Oct 2022 14:36:09 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MjSYh5wGnz1Rwtl
        for <linux-scsi@vger.kernel.org>; Wed,  5 Oct 2022 14:36:08 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1665005767; x=1667597768; bh=Ktz8tDfnp0zJ/uEQE1L0r1FZfkFQaxNTK01
        YLZAUUsg=; b=ij9uF493PVWY4wLhPyEEdNP9HnayAxUtXUqQr/fy0ENQGC4tCrD
        QJ3JO960AnKGnl6QUSdUowyUbDy9xKFuhftR0XjNBP9vik5Ad2y366WtNYh9ZBiG
        nxYvkogJ0Ys6vE+h25r0EW4Q8odrz4ljVNRwQXKFHXlVK0CvsADRj6kN0iLJghcG
        IyBbGfVf6waJDBudjYK03V2wHRyCuC0NIXRfT4ndcqZ6T7XGHYa2ODYObdulCdYP
        k3koRXVeSIXkaiC0/vqk8zAfhFyXfhXsG5RXTresp6KNvEmbXBb7YMTAW2CWR2mG
        f5VnjEoPeBa6I79zg7T9YE9Aq3lMcyD+Yqg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yHnLfGuJwPt1 for <linux-scsi@vger.kernel.org>;
        Wed,  5 Oct 2022 14:36:07 -0700 (PDT)
Received: from [10.225.163.106] (unknown [10.225.163.106])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MjSYf1yWDz1RvLy;
        Wed,  5 Oct 2022 14:36:06 -0700 (PDT)
Message-ID: <5db6a7bc-dfeb-76e1-6899-7041daa934cf@opensource.wdc.com>
Date:   Thu, 6 Oct 2022 06:36:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v5 0/7] libsas and drivers: NCQ error handling
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        John Garry <john.garry@huawei.com>
Cc:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        yangxingui <yangxingui@huawei.com>,
        yanaijie <yanaijie@huawei.com>
References: <1664262298-239952-1-git-send-email-john.garry@huawei.com>
 <YzwvpUUftX6Ziurt@x1-carbon>
 <cfa52b91-db81-a179-76c2-8a61266c099d@huawei.com>
 <27148ec5-d1ae-d9a2-1b00-a4c34d2da198@huawei.com>
 <Yz33FGwd3YvQUAqT@x1-carbon>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Yz33FGwd3YvQUAqT@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/22 06:28, Niklas Cassel wrote:
> On Wed, Oct 05, 2022 at 09:53:52AM +0100, John Garry wrote:
>> On 04/10/2022 15:04, John Garry wrote:
>>
>> Hi Niklas,
>>
>> Could you try a change like this on top:
>>
>> void sas_ata_device_link_abort(struct domain_device *device, bool
>> force_reset)
>> {
>> 	struct ata_port *ap = device->sata_dev.ap;
>> 	struct ata_link *link = &ap->link;
>>
>> +	device->sata_dev.fis[2] = ATA_ERR | ATA_DRDY;
>> +	device->sata_dev.fis[3] = 0x04;
>>
>> 	link->eh_info.err_mask |= AC_ERR_DEV;
>> 	if (force_reset)
>> 		link->eh_info.action |= ATA_EH_RESET;
>> 	ata_link_abort(link);
>> }
>> EXPORT_SYMBOL_GPL(sas_ata_device_link_abort);
>>
>> I tried it myself and it looked to work ok, except I have a problem with my
>> arm64 system in that the read log ext times-out and all TF show "device
>> error", like:
> 
> Do you know why it fails to read the log?
> Can you read the NCQ Command Error log using ATA16 passthrough commands?
> 
> sudo sg_sat_read_gplog -d --log=0x10 /dev/sdc
> 
> The first byte is the last NCQ tag (in hex) that failed.

libata issues read log as a non-ncq command under EH. So the NCQ error log
will not help.

> 
> 
> I tried your patch, and it looks good:
> 
> [ 6656.228131] ata5.00: exception Emask 0x0 SAct 0x460000 SErr 0x0 action 0x0
> [ 6656.252759] ata5.00: failed command: WRITE FPDMA QUEUED
> [ 6656.271554] ata5.00: cmd 61/00:00:00:d8:8a/04:00:ce:03:00/40 tag 17 ncq dma 524288 out
>                         res 41/04:00:00:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
> [ 6656.309308] ata5.00: status: { DRDY ERR }
> [ 6656.316403] ata5.00: error: { ABRT }
> [ 6656.322300] ata5.00: failed command: WRITE FPDMA QUEUED
> [ 6656.330871] ata5.00: cmd 61/00:00:00:dc:8a/04:00:ce:03:00/40 tag 18 ncq dma 524288 out
>                         res 41/04:00:00:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
> [ 6656.356295] ata5.00: status: { DRDY ERR }
> [ 6656.362931] ata5.00: error: { ABRT }
> [ 6656.368897] ata5.00: failed command: WRITE FPDMA QUEUED
> [ 6656.377471] ata5.00: cmd 61/00:00:00:d4:8a/04:00:ce:03:00/40 tag 22 ncq dma 524288 out
>                         res 43/04:00:ff:d7:8a/00:00:ce:03:00/40 Emask 0x400 (NCQ error) <F>
> [ 6656.403149] ata5.00: status: { DRDY SENSE ERR }
> [ 6656.410624] ata5.00: error: { ABRT }
> 
> However, since this is a change from the existing behavior of this driver,
> this could go as a separate patch, and does not need to delay this series.
> 
> 
> 
> I also think that we should do a similar patch for sas_ata_task_done():
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index d35c9296f738..648d0693ceee 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -140,7 +140,7 @@ static void sas_ata_task_done(struct sas_task *task)
>                         }
>  
>                         dev->sata_dev.fis[3] = 0x04; /* status err */
> -                       dev->sata_dev.fis[2] = ATA_ERR;
> +                       dev->sata_dev.fis[2] = ATA_ERR | ATA_DRDY;
>                 }
>         }
> 
> To avoid all SAS errors from being reported as HSM errors.
> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

