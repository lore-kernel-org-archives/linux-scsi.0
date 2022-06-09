Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12FBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 23:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiFIXhW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 19:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiFIXhV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 19:37:21 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6806C37BD6
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 16:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654817837; x=1686353837;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=fdKUhG3vflWOsIW1z3UYSe01yR1TwPZ57DzZTZGJ3HE=;
  b=mNtA0G0b57+U5ZADgmSNZt13o3F997aad9yX2/V/0HLdWM6x2pC9qV1G
   skcN4lB1gKg9Ao1VS1gH1rbxDczxhsrNP6u8WaShrcThWIobjXQYDLZSp
   OcAJLF9+eiv1lCY1cL20dCGGISiN/y5YSHxqqtlpohlNylsUqCdpIuZU7
   IPd7snsGDI+n/hEFuzEpSb3L4x2964Xa1NrrztI+mL8a9G/0YDefI9o0T
   t0XgM1XwzjerNPA4v/BmMcqT6PE1H5Iz8damaSlOK+AQJTfTXZgNxTJai
   /6t7O9x54Incb84wfxwMUShODSl2Rj3BdHkKa/nvGv6JJC7bQQgFvsN1w
   w==;
X-IronPort-AV: E=Sophos;i="5.91,288,1647273600"; 
   d="scan'208";a="207599177"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jun 2022 07:37:16 +0800
IronPort-SDR: ezUhoX4ElmtQ/Bf1YvWVsmssu7sFhORphQ0PisY4B1+n7D8rcBJ9pqjiiFb7UVyC7L3OnkpKxO
 KpmS3kZBAX2UEcWxd8UlAZu3RT0XDNm6duaT1d3i1hc+dD2j/AhdI2SCBNyetf2Mq2iQLmLytp
 ZThA6UX1S1UxQk9wWAcA15BhnvkanLOnIKpFGvxexpmjJ1UlGBZ/9Anxn5DOcNa/ae+f21zRR7
 SLIeQdkBda2vlybVjEKj32QNnszc1ckGQUIu7MYxBd3ehJtcXZXKae8I3QcRuV/Py2/TDNESc8
 J8X5J2MkjEkx+nmnBq8YzIIf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jun 2022 15:56:03 -0700
IronPort-SDR: b83pCI12Z3UOyxjBAQgAkAD3bwrN6U8B+Mc3zLK0vyhbdp4Q3SdE/y9GX0byRi585nTlAaHVSn
 VnrYIhFVBHrGrLOZN9Uq19ld4Y0CPfPiTy/Mx8pJUF/zY/jd7o6BOPvO2fm7wLFg77XU8lHDli
 4vQuq0r7JKNsPELGipKvwC/Ss19q/cZNQYIzlRtlwHfCHpGYedIi2iRW/x4PUw5sFOnFgs1buw
 +BadfVVHLfgnirwc+kbvLxfVaiqo4psPg4EdGO7jjGAg400gnA3mrs1jA6RRmVUgKCCUjVi9Pu
 z4M=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jun 2022 16:31:17 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LK0j05Bhpz1Rvlx
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 16:31:16 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654817475; x=1657409476; bh=fdKUhG3vflWOsIW1z3UYSe01yR1TwPZ57Dz
        ZTZGJ3HE=; b=DsIqyab8CYTiCW17ICixhob54+HKKNkcVGJqfQz7ItdmasvHM+I
        OhHxUMF8O20vD191i+0NgTSTa5+zlfuz0Uk1+2qjSX9C9DmnoNZQ2Pz03J0yJ0fR
        BFczMtcWQvXEhQdIg8/ht52REeK+dMQBWMAxgVHYQ4h3NDE/UsTfEnAPNSp6Xyu6
        vZCPz6aG81fFc7muyCc1M1iB/p40V3luOACS1CRnY21pVsk0hif6S3eFvMT3JoXI
        08bgj9I2YatuTUyyhYybKKkGjOJxQyfp3Vm14X0vsQF27v+WtkebqMBAOnzv4yUS
        Dv4DplUHED8Qo7o1M2RFtqevQbNidyv/Djg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id X7ztfstPINwy for <linux-scsi@vger.kernel.org>;
        Thu,  9 Jun 2022 16:31:15 -0700 (PDT)
Received: from [10.225.163.77] (unknown [10.225.163.77])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LK0hz2F63z1Rvlc;
        Thu,  9 Jun 2022 16:31:15 -0700 (PDT)
Message-ID: <c25c9b47-3cf6-abb8-9c36-e02d1a83364f@opensource.wdc.com>
Date:   Fri, 10 Jun 2022 08:31:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 3/3] scsi: libsas: introduce struct smp_rps_resp
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
 <20220609022456.409087-4-damien.lemoal@opensource.wdc.com>
 <bacd4a39-7098-ccc6-b6c3-560b3f63e8f8@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <bacd4a39-7098-ccc6-b6c3-560b3f63e8f8@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/22 21:19, John Garry wrote:
> On 09/06/2022 03:24, Damien Le Moal wrote:
>> Similarly to sas report general and discovery responses, define the
>> structure struct smp_rps_resp to handle SATA PHY report responses
> 
> nit: name smp_rps_resp is a bit cryptic to me. Is 
> smp_report_phy_sata_resp just too long? I always come up with verbatim 
> names ....

Yes, I think so too. I went for the minimal changes here, reusing the name
of the main field. All of the resp structs have bad names I thing. the
"rg" one is cryptic too and the "disc" one makes me think "disk" all the
time...

Luckily, the function names were these are used are not bad so the code is
still easy to follow, I think.

Together with the req side rework, I will rename all this.

> 
>> using a structure with a size that is exactly equal to the sas defined
>> response size.
>>
>> With this change, struct smp_resp becomes unused and is removed.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: John Garry <john.garry@huawei.com>

Thanks.

> 
>> ---
>>   drivers/scsi/aic94xx/aic94xx_dev.c | 2 +-
>>   drivers/scsi/libsas/sas_expander.c | 4 ++--
>>   drivers/scsi/libsas/sas_internal.h | 2 +-
>>   include/scsi/libsas.h              | 2 +-
>>   include/scsi/sas.h                 | 8 ++------
>>   5 files changed, 7 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/scsi/aic94xx/aic94xx_dev.c b/drivers/scsi/aic94xx/aic94xx_dev.c
>> index 73506a459bf8..91d196f26b76 100644
>> --- a/drivers/scsi/aic94xx/aic94xx_dev.c
>> +++ b/drivers/scsi/aic94xx/aic94xx_dev.c
>> @@ -159,7 +159,7 @@ static int asd_init_target_ddb(struct domain_device *dev)
>>   		flags |= OPEN_REQUIRED;
>>   		if ((dev->dev_type == SAS_SATA_DEV) ||
>>   		    (dev->tproto & SAS_PROTOCOL_STP)) {
>> -			struct smp_resp *rps_resp = &dev->sata_dev.rps_resp;
>> +			struct smp_rps_resp *rps_resp = &dev->sata_dev.rps_resp;
>>   			if (rps_resp->frame_type == SMP_RESPONSE &&
>>   			    rps_resp->function == SMP_REPORT_PHY_SATA &&
>>   			    rps_resp->result == SMP_RESP_FUNC_ACC) {
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index 78a38980636e..fa2209080cc2 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -676,10 +676,10 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
>>   #ifdef CONFIG_SCSI_SAS_ATA
>>   
>>   #define RPS_REQ_SIZE  16
>> -#define RPS_RESP_SIZE 60
>> +#define RPS_RESP_SIZE sizeof(struct smp_rps_resp)
>>   
>>   int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
>> -			    struct smp_resp *rps_resp)
>> +			    struct smp_rps_resp *rps_resp)
>>   {
>>   	int res;
>>   	u8 *rps_req = alloc_smp_req(RPS_REQ_SIZE);
>> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
>> index 13d0ffaada93..8d0ad3abc7b5 100644
>> --- a/drivers/scsi/libsas/sas_internal.h
>> +++ b/drivers/scsi/libsas/sas_internal.h
>> @@ -83,7 +83,7 @@ struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
>>   struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
>>   int sas_ex_phy_discover(struct domain_device *dev, int single);
>>   int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
>> -			    struct smp_resp *rps_resp);
>> +			    struct smp_rps_resp *rps_resp);
>>   int sas_try_ata_reset(struct asd_sas_phy *phy);
>>   void sas_hae_reset(struct work_struct *work);
>>   
>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>> index ff04eb6d250b..2dbead74a2af 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -145,7 +145,7 @@ struct sata_device {
>>   
>>   	struct ata_port *ap;
>>   	struct ata_host *ata_host;
>> -	struct smp_resp rps_resp ____cacheline_aligned; /* report_phy_sata_resp */
>> +	struct smp_rps_resp rps_resp ____cacheline_aligned; /* report_phy_sata_resp */
>>   	u8     fis[ATA_RESP_FIS_SIZE];
>>   };
>>   
>> diff --git a/include/scsi/sas.h b/include/scsi/sas.h
>> index a8f9743ed6fc..71b749bed3b0 100644
>> --- a/include/scsi/sas.h
>> +++ b/include/scsi/sas.h
>> @@ -712,16 +712,12 @@ struct smp_disc_resp {
>>   	struct discover_resp disc;
>>   } __attribute__ ((packed));
>>   
>> -struct smp_resp {
>> +struct smp_rps_resp {
>>   	u8    frame_type;
>>   	u8    function;
>>   	u8    result;
>>   	u8    reserved;
>> -	union {
>> -		struct report_general_resp  rg;
>> -		struct discover_resp        disc;
>> -		struct report_phy_sata_resp rps;
>> -	};
>> +	struct report_phy_sata_resp rps;
>>   } __attribute__ ((packed));
>>   
>>   #endif /* _SAS_H_ */
> 


-- 
Damien Le Moal
Western Digital Research
