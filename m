Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B731CC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 02:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbiCGCs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 21:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiCGCs1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 21:48:27 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038B21274A
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 18:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646621252; x=1678157252;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S3CNHgFgY3oCg1DWvQns4vK6LhLi6oQDlgq0N5RP9R8=;
  b=NohL5PZetnhP8DIWFXzRDzM6Otk6QdxR3B0+MHp3GZd8SZnV/WaucUgO
   TTfOw8Zj9u616jEeuH7zOm+ncQqCxcrmCXkwxEemZwNFURpg0AUVU2aqp
   FR5t9R3fFh5cWk9eul1AZNFjfaXogynIIASb1UfPEjy/y5ugG6G9rvrQY
   pXY8SDYACexhfi3a+V5PC0MlcMrqZUEluY8qrZC23OGL+sqn98q3jPRoU
   MSc+Km2c7qQhZ3yBiUL8rNtT0LanV4Jpn+bSwNeAVNhoONARCTaYqADFf
   1Qxdog72PW+TM1LlbLGkLnM4vK7NAK79NM0x5tBrWq5EgcbEQNmLltG21
   w==;
X-IronPort-AV: E=Sophos;i="5.90,160,1643644800"; 
   d="scan'208";a="193559018"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Mar 2022 10:47:30 +0800
IronPort-SDR: aHamKBmHobcw2+aOOwlz72voYzhegNZi5DZlsI/wKaQfWrDOKb2CWFltzUgtchbZNeBEqI9QUe
 UnVRxYY8XQHjvYcY+2+ejwx4nux5t8OlN0cXDiiujuntxXoyTTruJOa+Ez//uVdVFTZC+Sb7ne
 zPxSxeqdbcOU8KfJebNt0eFu9OIkEugo9Ki977yNB17LDMunriBgeE00HtXY1QEg2GBzIMG43X
 aBoB2fFLL6Ae3vjQo6rxw3EzkBf1WLGERCoOt/PFdKpIUhHdyUePsxn2T53kQ7/BVphsTXQMTO
 4Zjezi/6PS0J5zsZoYBw5++Q
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2022 18:19:49 -0800
IronPort-SDR: R/CJDBNE2Yf1wGvR+OCw5UIh6701Ohe2Y05hCpTxawzp4UPaG7yLQbrMP0QVcFhpCkTzD33n2x
 9ukBxER12QSWV09ZWBflPX7XGCiUiW7lTWNEMOAM1tZGrOCkmolu+lUkLh0vHaSa6obzbPOgHn
 y+ggh9R9vONejp3380myBW3Xw3OoY5JNo27MjkZovYLfE8FE2gsqC0WS9vYRAZZclOxgyjZRLA
 82wQ3v9E4rNV+KyarlaHwZ4tJJKUh03ik2m7YAR/dBsAkx6asKjdxGKs9XXEFXGjarcUkqL53A
 Nts=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2022 18:47:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KBjYF3tKbz1SVp2
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 18:47:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1646621248; x=1649213249; bh=S3CNHgFgY3oCg1DWvQns4vK6LhLi6oQDlgq
        0N5RP9R8=; b=dxjJpj6a+u8iQNILv9GEd1qZqkHYkR1HHziK+B65hLiPi/K/gV2
        70uAsCZZf/6BcxgvJ6pVUqgKkSv9GcaPKoSAuYI0/TKABmhijB7pY3+nnHfr9lRq
        ocyGupyR0QUsam6lGlxrtjCkOk0YM+lnUyVNUflXmps1r2CrEWPALh9DLNjihRtj
        qQXAuLspmS20zKv52PHcNxieBAZKCfOiroNXc1jQepc2BP3roNqR71vZ7+DGGr5x
        9SYKN0rWitWWmqLiuwMs9AG6Vs3Tgar+dSTLXrVR/WrBLtGOA9UPKaU28GfGPH2u
        kcBRD/V6ct018NCvNmNiPaQpl9gxzyABIew==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kFDHKczQMDWy for <linux-scsi@vger.kernel.org>;
        Sun,  6 Mar 2022 18:47:28 -0800 (PST)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KBjYB6btGz1Rvlx;
        Sun,  6 Mar 2022 18:47:26 -0800 (PST)
Message-ID: <d5145a6b-0985-030a-0288-1f7853b518d4@opensource.wdc.com>
Date:   Mon, 7 Mar 2022 11:47:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 3/4] scsi: pm8001: Use libsas internal abort support
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ajish.Koshy@microchip.com, linuxarm@huawei.com,
        Viswas.G@microchip.com, hch@lst.de, liuqi115@huawei.com,
        chenxiang66@hisilicon.com
References: <1646309930-138960-1-git-send-email-john.garry@huawei.com>
 <1646309930-138960-4-git-send-email-john.garry@huawei.com>
 <85a33515-043d-00f4-3bd3-ecb9a1349a68@opensource.wdc.com>
 <966a1048-cd14-d796-8b9d-734605796652@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <966a1048-cd14-d796-8b9d-734605796652@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 18:41, John Garry wrote:
>>>   /**
>>>     * pm8001_queue_command - register for upper layer used, all IO commands sent
>>>     * to HBA are from this interface.
>>> @@ -379,16 +428,15 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
>>>   	enum sas_protocol task_proto = task->task_proto;
>>>   	struct domain_device *dev = task->dev;
>>>   	struct pm8001_device *pm8001_dev = dev->lldd_dev;
>>> +	bool internal_abort = sas_is_internal_abort(task);
>>>   	struct pm8001_hba_info *pm8001_ha;
>>>   	struct pm8001_port *port = NULL;
>>>   	struct pm8001_ccb_info *ccb;
>>> -	struct sas_tmf_task *tmf = task->tmf;
>>> -	int is_tmf = !!task->tmf;
>>>   	unsigned long flags;
>>>   	u32 n_elem = 0;
>>>   	int rc = 0;
>>>   
>>> -	if (!dev->port) {
>>> +	if (!internal_abort && !dev->port) {
>>>   		ts->resp = SAS_TASK_UNDELIVERED;
>>>   		ts->stat = SAS_PHY_DOWN;
>>>   		if (dev->dev_type != SAS_SATA_DEV)
>>> @@ -410,7 +458,8 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
>>>   	pm8001_dev = dev->lldd_dev;
>>>   	port = &pm8001_ha->port[sas_find_local_port_id(dev)];
>>>   
>>> -	if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
>>> +	if (!internal_abort && (DEV_IS_GONE(pm8001_dev) ||
>>> +				!port->port_attached)) {
>> Wrapping the line after "&&" would make this a lot cleaner and easier to read.
> 
> Agreed, I can do it.
> 
> But if you can see any neater ways to skip these checks for internal 
> abort in the common queue command path then I would be glad to hear it.

Would need to check the locking context, but if there is no race
possible with the context setting the device as gone, libata should
already be aware of it and not issuing the command in the first place.
So these checks should not be needed at all.

Will try to have a look when I have some time.

There are several things that needs better integration with libata
anyway, like the "manual" read log on error. We should try to address
these for 5.19.


-- 
Damien Le Moal
Western Digital Research
