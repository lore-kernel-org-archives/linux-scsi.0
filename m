Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85712C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 22:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiBNWXa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 17:23:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiBNWXa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 17:23:30 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FF613CA3C
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 14:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644877402; x=1676413402;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=aVi3hoNdXKVh7plXFyvNd723IA9EdmkL3oV6P77sGqQ=;
  b=LZ6qVpzd6psU6rJcBg89V7RQxIhqEi1sEfj3aYe6Wr4Vbif0GX70UTEe
   u5TMB0HgnVoUx5zNS+JJRJDjG2y0ZLxteSagSoXt6jA5UNN/9kKWbAjaR
   Za2PE+a65pLZ9OE89oVL8Ku1z33v/y4cVwAoS4uMma3pOSzbYMw6BiBOn
   sHETrggjQ/JqoGHLc8Y0JgvKX/Dq5eWoskrNs7DIabd6JteI+tdNxT0bo
   BhBUAMI39yqVYLx25b71G6XJbAzfOqEzyBArLc+wW4SkwkM/HPQzkQoD5
   xxGteDXvfo5Y0a0FB9KoM+FSLxXPBIa7wDzvQ93s92wvHQ3UrnHAs7pMZ
   w==;
X-IronPort-AV: E=Sophos;i="5.88,368,1635177600"; 
   d="scan'208";a="193876055"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2022 06:23:22 +0800
IronPort-SDR: 5yb3tjOZSxVZkO+lqGsfxri0AegKOcuRmIqfQDfNiUNYAYO3nvELhPQHyhLzJdsRzKO7E7+lr0
 X1y+yB+9eeWXNVX0MV8ARKIvXwa1hvXq2Cfj0Iq3F+MVR/n68AmyF7a9NxgVcCtCEFCqHaEcAO
 E07URmiJah6y3wkf/DHkc9ZUwmDrotRe/A3gCDWr2h5AQ/dDfGF3GsqoMxETBAU6G8hSuG09x/
 T35WFt4vdBQfitOvGh8CkFIZF8TNgiVZUJK45S8HkORr3wzSVKhq3L3MXLuv7RLI7So2HObCEi
 E6qPldEAjJzo5TWbBKiE9oMK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 13:56:11 -0800
IronPort-SDR: XZZ8ntOY2bq6sT0tNZhUoQ/P+YfPZqj39PVap560JglE8sDNqQulGol940A98kK0X8zDekt2x2
 GzbULumCT8FD2FvUKZdwX0EK9P8VY718rSkapa5NwQa60ItsshFr+oSsmimo8/b17bZHFpS6/w
 uvGPPNI8wFjdrOfqWcTJ+GyXhRQjr6Uw2oWswLKNwDT+h7/GQn3920DKnbOhqTVECheY5e3Mak
 t4CgdWvLIxCKtACGwjj4uE5g1uCGUmIe5vNiZLjITTYOlU8pwieiTXZjxUHDTffp5ookxtVe0s
 L8g=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 14:23:21 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JyJdh66Gzz1SHwl
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 14:23:20 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644877400; x=1647469401; bh=aVi3hoNdXKVh7plXFyvNd723IA9EdmkL3oV
        6P77sGqQ=; b=j3wyG48tx+1YfVUm7tC1nGmDOBMUSQ4PDNfd23rRtDpaK+4J2SV
        N60SI16+Gu7YuwDF8gKQhWKKmqHwwQWTiMTI4d4D06eAlUUDhCk0nte2ZtljMkKK
        kcjjLfzKUTMUQNBCLRhy+NqkP3LVzPBGtbtY1WICqYjNeTApGhD1NmhkN9zAMLcI
        LdafqB8idrrSbkEvJ4SGxJ/JR+ZX88bYSk2mhXqAtC9lCWocC9hXhpzpibj2PB96
        qOn+Opr0z+9T3x6CxA1FBBcbVCTWb5NWTxrU2LQ2MisHQT/HiYlUwj2WiP0v5hOO
        ehp4IIp78X08P/Bd0y98enuPEZwLpAySTlA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id lP3a0l-CJmQ4 for <linux-scsi@vger.kernel.org>;
        Mon, 14 Feb 2022 14:23:20 -0800 (PST)
Received: from [10.225.163.73] (unknown [10.225.163.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JyJdg3SPpz1Rwrw;
        Mon, 14 Feb 2022 14:23:19 -0800 (PST)
Message-ID: <614d13c2-f3cc-262b-cbac-345d295fa2d9@opensource.wdc.com>
Date:   Tue, 15 Feb 2022 07:23:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 01/31] scsi: libsas: Fix sas_ata_qc_issue() handling of
 NCQ NON DATA commands
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-2-damien.lemoal@opensource.wdc.com>
 <f9ed7215-81df-7ab6-eec9-c8c0cd7830cf@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <f9ed7215-81df-7ab6-eec9-c8c0cd7830cf@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/22 02:56, John Garry wrote:
> On 14/02/2022 02:17, Damien Le Moal wrote:
>> To detect for the DMA_NONE (no data transfer) DMA direction,
>> sas_ata_qc_issue() tests if the command protocol is ATA_PROT_NODATA.
>> This test does not include the ATA_CMD_NCQ_NON_DATA command as this
>> command protocol is defined as ATA_PROT_NCQ_NODATA (equal to
>> ATA_PROT_FLAG_NCQ) and not as ATA_PROT_NODATA.
>>
>> To include both NCQ and non-NCQ commands when testing for the DMA_NONE
>> DMA direction, use "!ata_is_data()".
>>
>> Fixes: 176ddd89171d ("scsi: libsas: Reset num_scatter if libata marks qc as NODATA")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Regardless of comment below:
> Reviewed-by: John Garry <john.garry@huawei.com>
> 
>> ---
>>   drivers/scsi/libsas/sas_ata.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
>> index e0030a093994..50f779088b6e 100644
>> --- a/drivers/scsi/libsas/sas_ata.c
>> +++ b/drivers/scsi/libsas/sas_ata.c
>> @@ -197,7 +197,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>>   		task->total_xfer_len = qc->nbytes;
>>   		task->num_scatter = qc->n_elem;
>>   		task->data_dir = qc->dma_dir;
>> -	} else if (qc->tf.protocol == ATA_PROT_NODATA) {
>> +	} else if (!ata_is_data(qc->tf.protocol)) {
> 
> I was thinking ata_is_dma() would be more appropiate, but I suppose we 
> don't have to use DMA.

That was my first thought, but using ata_is_dma() would not include PIO
case, so that would not work.

> 
>>   		task->data_dir = DMA_NONE; >   	} else {
>>   		for_each_sg(qc->sg, sg, qc->n_elem, si)
> 


-- 
Damien Le Moal
Western Digital Research
