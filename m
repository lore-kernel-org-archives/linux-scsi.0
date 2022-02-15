Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB721C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 23:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240129AbiBOXlb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 18:41:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiBOXla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 18:41:30 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986C29DD53
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 15:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644968479; x=1676504479;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=fju2+GXQeOEuM4kWm9bpOZFc/KGpl6YJHywCzH/HUd8=;
  b=U2gTvdscu9PbLWUihNEDrxxvJBcCdXBOfagPVBHRvhQjk/tAMJcHV1kZ
   9EdarSFulBm4xS6ZCPoU+DpYXAMI+VOGeTHWx5J7QJEwXrRX+NZshjyjL
   tSVuRceWUQz/M2DTc495/XYS/cGVFXvHShRFVciO6mUHU0ce584nfny7c
   wdedkYHAA9RkMmTNYb7CjsDQU37dL1F7dz/u/EXZbyRBTnaxjLDTZt6WX
   XX1hB4NgVz0xyRlYMYaPixOcNm/EAIqGkjLHqfqbgusTLMfrBmt6RfjC+
   hjPqN1XjnQsiLcpYmRARzgk+ed0klpjAhnslM98+sCj/6pCPHRKSvu98x
   A==;
X-IronPort-AV: E=Sophos;i="5.88,371,1635177600"; 
   d="scan'208";a="191978034"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2022 07:41:19 +0800
IronPort-SDR: iHxCb0MH081RgYSwmYuZsGhhAeoT5U0uzwIGk+fD77UwAfP5ai3S41T8Xz41OtlLzpvZ36hkfg
 2U8Gf+i0g5/eAdM5+TVA1Z08BTZ7hqvNQyquT2qZuhdpq0dVWcjII5jlfx70zcfyTwJre8W53n
 GKFBtNMTuAZ0bAfGp7B11KIQh0ZdtVCA0JuBsimkF/s/79Ve98KDIMzE8iKqawlB76DUyknQPg
 JGcUbqP5cwepzXomLxEwmPV2I7kAqckSiOR7r15Bq90SuaZGVg0xxzrzJrzkg3NMSCFVW5ko2g
 M97IDYBWo0URlrKvbJ8gRjzH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 15:13:00 -0800
IronPort-SDR: SEmArUsoqapBobt/YYX1auX8tCSMdF9YyVfylzYNP5XGFBl3HZ38NFK8u8Shh5v+70Tc3ewLAo
 eBMEvvc2QQkgzVU42dNVDnoM70kBOR3TYLfgN8XdFxIa/RVk+22gz1tvso4t9RhpdiBBSBXxx7
 3Eo6mTw6F5Sr6kiDCOkAPAhaLLM4mGUwwTHi1Kmuzxgpc35b6Mi+Hu07xln5awVfRmATTHPB+T
 QExVMYLs2Kk40bvadkuTtHA2D8+CKwIBnFU+SBP1AREF8+17p1s0/wL9PfuBFTzv64KylKnZQ0
 9Gk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 15:41:19 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JyyKB5tmNz1SHwl
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 15:41:18 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644968478; x=1647560479; bh=fju2+GXQeOEuM4kWm9bpOZFc/KGpl6YJHyw
        CzH/HUd8=; b=AWYSJn+sa0LJL2BMlZJIxRl42qwnZeTVdTAspvWh2ZZ5zMycTiJ
        RhPpA6P3POXWHDLN4XbzUY1IpvpyVe1CuRMX0K6N2hJMmQMWu+hByFVJEn+MyVkw
        BrNUHPz6Hbvc0Wq6L14cGHopzsadhEvmOFfRPCqR1a2HgZ5B+oZDNRMPczFw+Icj
        QIMmh8DWAGK5x5UrmXOCZWLADOUoDjeweQTf6jXOa4QaFDCUnRKtNK5UO8QeHUra
        p1+wzj84DC65PYG5ZJ9FgMnn/HFWgm5acRLwSX4TnEHPzV8JaFOXcoPfzOEXz95q
        Tk8QSDVaClYmSQynTni0YeTXvisKeGQuuvQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id P7TCmpmGH67O for <linux-scsi@vger.kernel.org>;
        Tue, 15 Feb 2022 15:41:18 -0800 (PST)
Received: from [10.225.163.73] (unknown [10.225.163.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JyyK90PScz1Rwrw;
        Tue, 15 Feb 2022 15:41:16 -0800 (PST)
Message-ID: <dbcb628c-faed-c696-ff53-cf9f30593038@opensource.wdc.com>
Date:   Wed, 16 Feb 2022 08:41:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 28/31] scsi: pm8001: Introduce ccb alloc/free helpers
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-29-damien.lemoal@opensource.wdc.com>
 <0a0006af-2878-3e6f-dc27-be04d2866fc3@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <0a0006af-2878-3e6f-dc27-be04d2866fc3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/22 20:07, John Garry wrote:
> On 14/02/2022 02:17, Damien Le Moal wrote:
>> Introduce the pm8001_ccb_alloc() and pm8001_ccb_free() helpers to
>> replace the typical code patterns:
>>
>> 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
>> 	if (res)
>> 		...
>> 	ccb = &pm8001_ha->ccb_info[ccb_tag];
>> 	ccb->device = pm8001_ha_dev;
>> 	ccb->ccb_tag = ccb_tag;
>> 	ccb->task = task;
>> 	ccb->n_elem = 0;A
> 
> nit: stray 'A' character

Weird... How did this pass compile & test ? Will fix that in v4.

> 
>>
>> and
>>
>> 	ccb->task = NULL;
>> 	ccb->ccb_tag = PM8001_INVALID_TAG;
>> 	pm8001_tag_free(pm8001_ha, tag);
> 
> Isn't it possible to do a "memset struct members", such that we order 
> the members specifically that we can memset(0) a known region? The 
> advantage is that adding/removing a member does not require much code to 
> be touched and possibly missed.

Hmmm. I guess we can by moving the buf_prd field at the end of the
struct. We would still need the ccb_tag initialization though, so I am
not entirely sure if this is worse it... Will try to see how it looks.

> 
>>
>> With the simpler function calls:
>>
>> 	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
>> 	if (!ccb)
>> 		...
>>
>> and
>>
>> 	pm8001_ccb_free(pm8001_ha, ccb);
>>
>> The pm8001_ccb_alloc() helper ensures that all fields of the ccb info
>> structure for the newly allocated tag are all initialized, except the
>> buf_prd field. The pm8001_ccb_free() helper clears the initialized
>> fields and the ccb tag to ensure that iteration over the adapter
>> ccb_info array detects ccbs that are in use.
> 
> 
>>
>> All call site of the pm8001_tag_alloc() function that use a ccb info
>> associated with an allocated tag are converted to use the new helpers.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
> 
> The comments are not a show stopper, so:
> Reviewed-by: John Garry <john.garry@huawei.com>
> 


-- 
Damien Le Moal
Western Digital Research
