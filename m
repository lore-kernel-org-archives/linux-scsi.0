Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDDDC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 12:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344817AbiBKMc2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 07:32:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiBKMc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 07:32:26 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCF8F71
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 04:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644582745; x=1676118745;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=0D/8AI6dxgaxgiB9itzzUYFnMD981Ssy/ASExLETdWA=;
  b=RzBFFgeI963hpLiysNmdFloETte3Qr9YFhKGhQO+zi1pP9k1IA8/cjt/
   iG3mhkGs3VMx+P0O2KvQ2RbQp5eQgm/VGqlSsUUZUGRYEWsl7gBBUq6UV
   q8rTnUpTpeyY3OEB+LCxyZZBKA/psif/PUKvesa8FR51QXTuiVA3zWFS9
   Lrh2JUJPKZol8zQOlh9JHpaaSiDPiF2tFoNS98WSAk9YNpjDkpGhQjYL5
   wuHRhIwDgGZlCEzHzvcQXuRjtf1JrtwRakKB/9FzqO/wuxVZpd9jWRy4o
   IEX/AoL7F0twW9TUaOBq9eHU2wATru1xuvW+uyUa6JG3k+urXYo8F0vh5
   g==;
X-IronPort-AV: E=Sophos;i="5.88,360,1635177600"; 
   d="scan'208";a="193673156"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 20:32:24 +0800
IronPort-SDR: XJjm7n8zEUY/Bs62dd3ZJb9iYvbmWx3ZX41S0gI3aSVQaNea0AofIIH5DQ/19urWkygpo6bBnp
 Gr/alla0rpwZbs9zAs2hHKWeD3TnqeOYK5p//shuspIsAVbI9w+AAR0eK5XQdMe6q+hBACFuo6
 lnICB99iHnw6zxwbIlW96gNiWbJfYBJPKFCjrzJ82xsJu7kYn+CrBCarnQLj2/6RsihrwLAh1k
 d9efiCmJujS9MpeYS75N3LTNGBbx/8kDdARGuXPVuUKcTCDrw2x+z0UhRDkP48qL4rua1hH0tr
 Zke0fpTjogRylN60+NXEi5tk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 04:05:19 -0800
IronPort-SDR: I750LiDYPb3TrX24ciY8T9MrQofrVVHD1Ji0wh9KrtvCtB10MQaeRnBXDJ64GhYseTujVVl4Tu
 w6UEmGIzvXCadAsJe5xInLU7vHpRu9gkyn6+UE++CL2ToXCajl/mUgjomUWKep+BxGXK1ukgNw
 ZOYxv/2TeZVAXO5utKpNTbM1bKktqbEt99wpRgg4Jl4jgr6NHZB4HRb/wZJQmJb1KdxOSIya0P
 Ac5ExfFUCYtw4LovTkj57MksR1fgh/u03KklThB6CRgyUywoDWnXG38tbGQ2e1hJ7qYT6WPr0Y
 /bY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 04:32:24 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JwCgC4hnfz1SVny
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 04:32:23 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644582743; x=1647174744; bh=0D/8AI6dxgaxgiB9itzzUYFnMD981Ssy/AS
        ExLETdWA=; b=GjR/E9RdkTpIqDvjt74pWWOFROLsepxToLboyjUdy7VXP0Z7a7E
        HItmItFaKN/q0D2/iB7nvCTPb6Blxf2wTYeCc2Ffaln+9NCpdp4ip1ZHeg1QxQoP
        SvGKmWWJFlBgUrn5TBnEUt5Uvg9GXeKog+3Na+ppNlzBI49ukJMGoKJAgiom7XfY
        ctRV+ZGbiPnsxI10TVdrwlgC12P50mDPSwFDB+wYlr6Y3uzUG4om4PLYsRhehaSq
        ALEcDDPcwX2+EnyBhxUyMpbxYgo4NNAeW+oTJhntsuPhWGaMGCATXpDRdURpby/u
        tYlG8IO5BWc9faZCEgY0XO9kFXYAdPx4SQA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id crVJLixCK3kE for <linux-scsi@vger.kernel.org>;
        Fri, 11 Feb 2022 04:32:23 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JwCgB0vX8z1Rwrw;
        Fri, 11 Feb 2022 04:32:21 -0800 (PST)
Message-ID: <0b8d471a-3520-7f45-66cc-1b29872392c9@opensource.wdc.com>
Date:   Fri, 11 Feb 2022 21:32:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 23/24] scsi: pm8001: Introduce ccb alloc/free helpers
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
 <20220211073704.963993-24-damien.lemoal@opensource.wdc.com>
 <df7b31cc-557d-ce12-dbb7-a2873100a587@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <df7b31cc-557d-ce12-dbb7-a2873100a587@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 21:25, John Garry wrote:
> On 11/02/2022 07:37, Damien Le Moal wrote:
>> Introduce the pm8001_ccb_alloc() and pm8001_ccb_free() helpers to
>> replace the typical code pattern:
>>
>> 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
>> 	...
>> 	ccb = &pm8001_ha->ccb_info[ccb_tag];
>> 	ccb->device = pm8001_ha_dev;
>> 	ccb->ccb_tag = ccb_tag;
>> 	ccb->task = task;
>> 	ccb->n_elem = 0;
>>
>> With a simpler single function call:
>>
>> 	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
>>
>> The pm8001_ccb_alloc() helper ensures that all fields of the ccb info
>> structure for the newly allocated tag are all initialized, except the
>> buf_prd field. All call site of the pm8001_tag_alloc() function that
>> use the ccb info associated with the allocated tag are converted to use
>> the new helpers.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>>   drivers/scsi/pm8001/pm8001_hwi.c | 153 ++++++++++++++-----------------
>>   drivers/scsi/pm8001/pm8001_sas.c |  37 +++-----
>>   drivers/scsi/pm8001/pm8001_sas.h |  33 +++++++
>>   drivers/scsi/pm8001/pm80xx_hwi.c |  66 ++++++-------
>>   4 files changed, 141 insertions(+), 148 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
>> index d853e8d0195a..8c4cf4e254ba 100644
>> --- a/drivers/scsi/pm8001/pm8001_hwi.c
>> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
>> @@ -1757,8 +1757,6 @@ int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha, void *data,
>>   static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>>   		struct pm8001_device *pm8001_ha_dev)
>>   {
>> -	int res;
>> -	u32 ccb_tag;
>>   	struct pm8001_ccb_info *ccb;
>>   	struct sas_task *task = NULL;
>>   	struct task_abort_req task_abort;
>> @@ -1780,28 +1778,26 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>>   
>>   	task->task_done = pm8001_task_done;
>>   
>> -	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
>> -	if (res)
>> +	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
>> +	if (!ccb) {
>> +		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
> 
> Should we print this always and move it into pm8001_ccb_alloc()?

Good idea. Will do.

[...]
>> @@ -4433,7 +4424,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>>   	u32 stp_sspsmp_sata = 0x4;
>>   	struct inbound_queue_table *circularQ;
>>   	u32 linkrate, phy_id;
>> -	int rc, tag = 0xdeadbeef;
>> +	int rc;
>>   	struct pm8001_ccb_info *ccb;
>>   	u8 retryFlag = 0x1;
>>   	u16 firstBurstSize = 0;
>> @@ -4444,13 +4435,11 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
> 
> I think that this needs to be fixed to release the ccb when 
> pm8001_mip_build_cmd() fails (not shown).

OK. Will do.

[...]
>> +/*
>> + * Allocate a new tag and return the corresponding ccb after initializing it.
>> + */
>> +static inline struct pm8001_ccb_info *
>> +pm8001_ccb_alloc(struct pm8001_hba_info *pm8001_ha,
>> +		 struct pm8001_device *dev, struct sas_task *task)
>> +{
>> +	struct pm8001_ccb_info *ccb;
>> +	u32 tag;
>> +
>> +	if (pm8001_tag_alloc(pm8001_ha, &tag))
>> +		return NULL;
>> +
>> +	ccb = &pm8001_ha->ccb_info[tag];
>> +	ccb->task = task;
>> +	ccb->n_elem = 0;
>> +	ccb->ccb_tag = tag;
>> +	ccb->device = dev;
>> +	ccb->fw_control_context = NULL;
>> +	ccb->open_retry = 0;
> 
> I'd just memset the whole thing to be sure (paranoid). And I think that 
> we are also missing clearing the ccb_dma_handle.

Can't do that. The ccb buf_prd is allocated on controller init and stays
until teardown. I know, i did that first and got a crash :)

> 
>> +
>> +	return ccb;
>> +}
>> +
>> +/*
> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
