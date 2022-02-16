Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256EEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 11:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiBPLn4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 06:43:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbiBPLny (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 06:43:54 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46CCB822B
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 03:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645011822; x=1676547822;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=edVsh6qrpYqWrODfcZw5Wb10hzvozweR3brVP45i7GU=;
  b=oTIZIjGdzqRl9qq64mAqFijJgbngTkyZqB3D6OhHb4j77VGMOZ7i2Jr6
   xm8iJOTaO0SdxSdaE2f9wU0pfbHL3RJ59uRx+0YiM+0psXsnWAaRmQD5t
   n66i082mA4n4mXXmJcK8OMj7BaoAikMTnYP4fyoty0VQ4VxWcoL08k2p/
   WX+nA8tcKxp8PtKSLfTtC+WKyZG9u2xxI8IV91TgJOS72RRIe0BXqYKAd
   TNwN5KwKdQduZn/Ft3EJRr38XRdC0BSY+XQOoxH1feP/VIoqGbUBNTYp0
   uvwlVWF3kcyOLivaw/oVpeJ9vCRzQVr1On1g1lVc7o1jLD6YsJlUgUi57
   w==;
X-IronPort-AV: E=Sophos;i="5.88,373,1635177600"; 
   d="scan'208";a="193092388"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2022 19:43:42 +0800
IronPort-SDR: hB+GnTJR7qs8+6st/FDQqB/WGjCUATzJ2nFFWbSSou8JJENNqKP87i1HfnIi8K72Hj0cVveRks
 dchW/Ue5kBU1r2bI2GbYV+JPEoNx7+7VBjRNKbA4O3+bULMX2bzlFQnGvS+veNxghLIl3bflub
 TCg1Q+KazUB1oeFv25BDAWHNW9uh4NbDta6giCLe/N2ykMgfc0W/Fd5kf+sm3uTClC05buuWmW
 dmMy7kIjw4YD1ftP8MD+HBZX739XqxTHkQi7tXBq1sJOcroRjKqpoGSFppD/DUcaKvuegng8C/
 WclMRmKTnR1V+4we3wfEiV3V
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 03:16:30 -0800
IronPort-SDR: qkTtyCswz/uYIc4XMxbzbLD691EKQZgsrKnOoN0MpPjxawW62SF1SRXGtu7E/eLHMbQVsGlxSK
 UYhLQ2KwWEJ659ddCEjrZLJcyaJ3DQSSGbHPz0kLtrHWrEu2g3t5RiWOAo4pxdgGKqVjaD1C7P
 BMbwfQhgavIcGK1X/nA2wb74W7lYTokqKu7BZpzge7rOdfh+D8GOqg3f/J0mCOj33w81aqhTZB
 kiye4RJmNnQZfo+0U3pEqUzzckMVeKvx69MfK+krAcbKRzRX3W678DehllKhIfvZaXGpEXVDhV
 6m8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 03:43:43 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzGLk2FP3z1SVp1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 03:43:42 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645011821; x=1647603822; bh=edVsh6qrpYqWrODfcZw5Wb10hzvozweR3br
        VP45i7GU=; b=LM/QkslLrZKErbJpEM57kv4gnsB6ctgilfOmPCRCKvm+4tDc11t
        CUK9RStKn1plLoOQ57KQENWSjdzRbmxhvGgy9azWf6FbZq1GR/oXLd1/zm7iEXme
        78H9Dy9FGBhpjAMb0y93EbkQN8Wz5bLxffZ10EFO74HP33CPF8IKkLLtpEG1chXh
        TvcHnRQQdNEyhJazTayC5jxyBd0EY69S774cwJ2IT9HYzZV26Aa++KxJL73HE18L
        tF9WiNAHwUbp7/SfuarStIQLRs4Xc8GJXbhMBqlnwlaOz6VjzTKP9dskdM0ouorD
        KIpUs8auLUtz1xxDZW4KPD52R+PUcGjeXbw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QI64fa-bLlBJ for <linux-scsi@vger.kernel.org>;
        Wed, 16 Feb 2022 03:43:41 -0800 (PST)
Received: from [10.225.163.73] (unknown [10.225.163.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzGLh6ll2z1Rwrw;
        Wed, 16 Feb 2022 03:43:40 -0800 (PST)
Message-ID: <4a1cdee3-76fc-0135-16d8-e28d90967dfe@opensource.wdc.com>
Date:   Wed, 16 Feb 2022 20:43:39 +0900
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

Thanks. I left the patch as-is and did not try the memset() thing. Let's
do that later.

> 


-- 
Damien Le Moal
Western Digital Research
