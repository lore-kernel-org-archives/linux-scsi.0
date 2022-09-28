Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB02C04A95
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 05:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiI1Fiz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 01:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiI1Fix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 01:38:53 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE9E11ADDA
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 22:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664343532; x=1695879532;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dsGUSlKQY83yG8ByJzOzvwk4eDnzcHhajDUYsIpFHEE=;
  b=SiN1TBUVNm4LP4cNblRlbwfJAuJOd/nZuABDMwbvfeKnpHj7hXVXeemI
   6cIebl07Fns4dhm7jRFypaJmiTQIS0lAasZ3Hr8L5drzAtjdBXUt7Uoyq
   nJxJzGy/jMPRtgcNo1UiCKwE7uTSsPokY9oWrhLiU6WuJZAHtseBQz7in
   UO/ELM9HquzhycME8xcHtfFh5lxXmwc5vEFb/hku3T3X1pKJJXFBhmcYn
   G/K5JyM/XFJ72cIroZIEKCp03wjearK2DZ/CwymYatuJ7JRS81Qak3GUO
   gdSbIySk/k3U2WXfOoSjVmnU9Os6aI28PWrFVp73u8SqGdwalOa3pQJT2
   A==;
X-IronPort-AV: E=Sophos;i="5.93,351,1654531200"; 
   d="scan'208";a="212460818"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2022 13:38:51 +0800
IronPort-SDR: tX5AAXfr51yZBAO785wuaDCW6AzK6cCz4hNpN/lzZJskUmKVQ26g9S8O4d/sjenNcgbCdCUAUw
 oDN2e8wN1EeAjkP49IT5wj+jM/fqUWwExGaZ/A5LxaDfFc8ywLfQBbCbiLaqdwYdnQs735en5Q
 E546aRN/jq3HmmBcsxu1yl05buPdrAk5cguJxgOQNq8AduvvfStpTyhz302qEaa3dO4BtDnANo
 sR/HGX1ME1RvRCpz4YU7v1B63va7qmDpV1yqywELiyaPEd27QvSvrRuIAdAOEMze5EJJ3xzI3D
 PjWmcXOAk2VPOBrvCfnrCjpD
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2022 21:58:47 -0700
IronPort-SDR: t+b9C4sJ/oNQLkgiIY88+LF52szV94BykwkfVQXkwHYIfJ31e7oZjqPoqlrFsFgsx3wGuEvugX
 wNtdWsI6UmwsfdfVS9OH/9ebxGWeuzDaA/b6gP1zV1NsjsIa4uNTky+EGY14HPAlSBEQs6zRjL
 pZ6uyTrAOkwnX0knUEiZ56lkZxTcR/P5G0UGiA4t1JiIZuNqlDeBnbdc8Pr0fhg89jupHhkdQw
 3r2lPdwxpCfD36sq6XT8WfqCgUA3+nCokznKb36u6JrySsOI207Eg7+lMMPp23XUpyzbqCCfPL
 SCc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2022 22:38:51 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MclfL551Kz1Rwtl
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 22:38:50 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664343529; x=1666935530; bh=dsGUSlKQY83yG8ByJzOzvwk4eDnzcHhajDU
        YsIpFHEE=; b=g6ywg/DZQJ/ytCHfq8Tt8rr36ttuTYuVlZu6WAw2PpV6QG6B2Yn
        8t7SNSxY3ju3vz9LEPxOQd2XykEUaPN205Krk7jC+wFnnDBpp0M/jwSCNvvsjMcZ
        bZ3la47t3mUo6MEiRJL4UkLsjNI8f9v/mz57V5mOYzGUc0QHYk390h7cv4grSbR6
        DD/+lczqMBKJdjGg1hrUxWHrylE8KhMFfbt658ZVWHMCSRksWWNqar7uaSXNca69
        16dYRkarCRbnOVCVNe3DkUg9pFLF9q4yhLdvVXN1Xy8ojRTSBvaVABTDfItVxlKs
        nRq51NhWz0WKTQ17VHRTwE5lgPNS8s4bLiQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hX1xomTvoSWv for <linux-scsi@vger.kernel.org>;
        Tue, 27 Sep 2022 22:38:49 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MclfH6X7zz1RvLy;
        Tue, 27 Sep 2022 22:38:47 -0700 (PDT)
Message-ID: <b3bae3fd-a04c-3674-c4bf-9ddc6a0a9ad0@opensource.wdc.com>
Date:   Wed, 28 Sep 2022 14:38:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v5 3/8] scsi: pm8001: use sas_find_attached_phy_id()
 instead of open coded
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com,
        Jack Wang <jinpu.wang@ionos.com>
References: <20220927123926.953297-1-yanaijie@huawei.com>
 <20220927123926.953297-4-yanaijie@huawei.com>
 <caa8552b-3bb4-5824-aa99-82386d367479@opensource.wdc.com>
 <b58846fa-5c1c-ad73-a363-68ddf99d4da5@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <b58846fa-5c1c-ad73-a363-68ddf99d4da5@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 11:17, Jason Yan wrote:
> 
> On 2022/9/28 6:57, Damien Le Moal wrote:
>> On 9/27/22 21:39, Jason Yan wrote:
>>> The attached phy id finding is open coded. Now we can replace it with
>>> sas_find_attached_phy_id(). To keep consistent, the return value of
>>> pm8001_dev_found_notify() is also changed to -ENODEV after calling
>>> sas_find_attathed_phy_id() failed.
>>>
>>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>>> Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
>>> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>> ---
>>>   drivers/scsi/pm8001/pm8001_sas.c | 18 ++++++------------
>>>   1 file changed, 6 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
>>> index 8e3f2f9ddaac..042c0843de1a 100644
>>> --- a/drivers/scsi/pm8001/pm8001_sas.c
>>> +++ b/drivers/scsi/pm8001/pm8001_sas.c
>>> @@ -645,22 +645,16 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
>>>   	pm8001_device->dcompletion = &completion;
>>>   	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
>>>   		int phy_id;
>>> -		struct ex_phy *phy;
>>> -		for (phy_id = 0; phy_id < parent_dev->ex_dev.num_phys;
>>> -		phy_id++) {
>>> -			phy = &parent_dev->ex_dev.ex_phy[phy_id];
>>> -			if (SAS_ADDR(phy->attached_sas_addr)
>>> -				== SAS_ADDR(dev->sas_addr)) {
>>> -				pm8001_device->attached_phy = phy_id;
>>> -				break;
>>> -			}
>>> -		}
>>> -		if (phy_id == parent_dev->ex_dev.num_phys) {
>>> +
>>> +		phy_id = sas_find_attached_phy_id(&parent_dev->ex_dev, dev);
>>> +		if (phy_id == -ENODEV) {
>>>   			pm8001_dbg(pm8001_ha, FAIL,
>>>   				   "Error: no attached dev:%016llx at ex:%016llx.\n",
>>>   				   SAS_ADDR(dev->sas_addr),
>>>   				   SAS_ADDR(parent_dev->sas_addr));
>>> -			res = -1;
>>> +			res = phy_id;
>>
>> Nit:
>>
>> res = -ENODEV would be a lot clearer.
>> Or do:
>>
>> 		if (phy_id < 0) {
>> 			...
>> 			ret = phy_id;
>> 		} ...
>>
> 
> This boils down to personal preferences. I'd like to change to the 
> latter one if no objections.

Either work for me. The point is to preferably have something consistent
with the return value from sas_find_attached_phy_id() and not playing
games with it. So yes, the second one is fine.

> 
> Thanks,
> Jason
> 
>> No ?
>>
>>> +		} else {
>>> +			pm8001_device->attached_phy = phy_id;
>>>   		}
>>>   	} else {
>>>   		if (dev->dev_type == SAS_SATA_DEV) {
>>

-- 
Damien Le Moal
Western Digital Research

