Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C118C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 07:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiEWHeH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 03:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiEWHdR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 03:33:17 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2459FE4
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 00:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653291194; x=1684827194;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LJ8/2FSDHURz0Zuhe/Qx3SaImInSLYq6abN68q4sCnc=;
  b=XVZoe77aA6Il9y+RMkR8XmvuC1hkG3MFuhJeb323/FBkwq7z2eia81zV
   LZx94PH3aPyGNbI1bWFjZ2qPEYjR/WWle2m7bcX9AAwwNw41S0ojS4QBP
   Sdag8J6PAe8n2luomdrOGJDOBn1JjWbUSYfBu6kwFlnC/0GMYjrPWKFMI
   O627AT9i0Fie4IPRxlt7MCu0+/nXss5KAPtIS+JiPisc9nq92vOMZVkZ+
   rAn6hTL8tY5fYKOBK0HhTcEjDtSyanYkD6mpisq/lr4s3wrhK+aec0M0n
   vA8/IgB36iKEIqA3MVsuPE0aYvYZK4gz6PufOS1nWo99ScIVU9toMCb2I
   w==;
X-IronPort-AV: E=Sophos;i="5.91,245,1647273600"; 
   d="scan'208";a="313121550"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2022 15:33:13 +0800
IronPort-SDR: M4QJs3Ho2luL/LOSpVfSA9JVixIhNJxH1g0rwMho6zuWzgGnJacJ+R3se4bkoluZEHKgltn7aZ
 I9oV+hnFzw2k/UpUL3eiwibYQ1lyHlwInF5Q2pFAxWrKqeQHR07Xh8L877f6GJ4yFNqFOFno4f
 RQKWtJuTUw+sss3cdVQeuTQ2XTuMEq+Pah0NM09i1sJJZW0OasbqmLazZN0jly+Jd7N1MfY6nI
 I4kzX7TBm4wvmTj1EffgS0jy0H4AnUGht4CO4U2fiuHsgv/49Ll4tCxvCABB6VS4yMVqPb0IqS
 Kb36X8rzl6WBSmIxYk93m9Aa
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2022 23:57:12 -0700
IronPort-SDR: LAX551Tuqk87hceZKW5kz6pm5pWdLsA2YqnSg1TvkkkdnrJIzEBVy+MqkxAFU5Io8nStEi/gor
 v4cdederVt7r/OcSjZbCROwBFFWHeg7jZSUDpO47fTtJxENOTqgol2+kvhktL4s5TGxWvFlLfq
 EMtN4gemCzkye9nHl4uCgzCKU1V9aO6+TxkfLJgRK0rejXEskel4YD7Ygcp8p5xFBs1RS34gxn
 V6AQfd+dhTO1ben1pmBSckFP8HJeYbt6vf9YnvHhYIfAhdxloFMrpHs05lFoaB5dg9+xv86yKg
 6/c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 May 2022 00:33:12 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L68FM68FVz1SVp8
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 00:33:11 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1653291190; x=1655883191; bh=LJ8/2FSDHURz0Zuhe/Qx3SaImInSLYq6abN
        68q4sCnc=; b=fbzRa9DHE20CwXRkfGCjdgl4Zx6hwQ1fI7gSJy9Vj9vrbyA+aoA
        Rw4pr+X1sm88OhK0n/MDZUOKzRM6+1XUPow3v38BNiuuWUVEjPBAs9JimtP0J1oa
        5enJzvjcWir1XMEjtGp0JTqRmXwbjRULL5fIoXkiLjsspkVa4jgTQ05LmTmyHnhR
        tAowXU1Vzw58oSBt7G62IYzQ0lpP7zWaJj51+rCw1WCpuu18fMc5yugLgsQ/CeJU
        id9aSljXegV2ggC4TO5fIgUiEHK+NcWIdCLYtpiMwg5m/PynMdAGy7CWYAxCpc+z
        CjoJdVpQWLUB4jwo/6+Bk7Cb0jybiv+eikw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OFLqDeiQ91Cc for <linux-scsi@vger.kernel.org>;
        Mon, 23 May 2022 00:33:10 -0700 (PDT)
Received: from [10.89.85.73] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.85.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L68FJ4nptz1Rvlc;
        Mon, 23 May 2022 00:33:08 -0700 (PDT)
Message-ID: <6175fe49-f3e2-bfcb-2b97-b58763f1cf0e@opensource.wdc.com>
Date:   Mon, 23 May 2022 16:33:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 3/4] scsi: core: Cap shost max_sectors according to DMA
 optimum mapping limits
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, liyihang6@hisilicon.com,
        chenxiang66@hisilicon.com, thunder.leizhen@huawei.com
References: <1653035003-70312-1-git-send-email-john.garry@huawei.com>
 <1653035003-70312-4-git-send-email-john.garry@huawei.com>
 <e65e7329-67e3-016f-e213-86e51b8021d6@opensource.wdc.com>
 <d5a31b82-4134-a7fb-1a51-446e32db2fd0@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <d5a31b82-4134-a7fb-1a51-446e32db2fd0@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/05/23 15:53, John Garry wrote:
> On 21/05/2022 00:30, Damien Le Moal wrote:
>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>> index f69b77cbf538..a3ae6345473b 100644
>>> --- a/drivers/scsi/hosts.c
>>> +++ b/drivers/scsi/hosts.c
>>> @@ -225,6 +225,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>>>   	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>>>   				   shost->can_queue);
>>>   
> 
> Hi Damien,
> 
>>> +	if (dma_dev->dma_mask) {
>>> +		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
>>> +				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
>>> +	}
>> Nit: you could drop the curly brackets here.
> 
> Some people prefer this style - multi-line statements have curly 
> brackets, while single-line statements conform to the official coding 
> style (and don't use brackets).

OK.

> 
> I'll just stick with what we have unless there is a consensus to change.
> 
> Thanks,
> John
> 
>>
>>> +
>>>   	error = scsi_init_sense_cache(shost);
>>>   	if (error)
>>>   		goto fail;
> 


-- 
Damien Le Moal
Western Digital Research
