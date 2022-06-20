Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0981AC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 06:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiFTGHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 02:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiFTGHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 02:07:12 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3C064C0
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jun 2022 23:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655705231; x=1687241231;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jCVW2VD3p3E4Ofb+bvcuspH3xYyQy+8SWjIJiqR2b4M=;
  b=CtMcFLEubAVb0Rk8IeaqOnm9ri7h4Avi9GXjlCU3i11hgt+LCha9VgJC
   VuPLSBHLNk2QXJKJhurS8lbcA0C6VeQZgwTqvkqThTFCbTbTj1+17LYzN
   +lPa2y1TiOe7YSCx3RKiOoYwBDHmXZM8uq805QRz/RGuQDO00qxeosEzJ
   xhRCy/Q7s0hZysdB9fOUIG0eyzJ6rvxV+4/FC0vZtQcj+0AThHfclcGnh
   9nxbAayGcEHlzc/110+HaZs5z4JMSklMy+LcpywpfZNYqzfm04XEs2MMi
   XioMHSvg9YNvxrOaGAuZ2oMvtYMWzUWaLEZgspanD2+ITPyO/VwqcbkNW
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650902400"; 
   d="scan'208";a="307912571"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jun 2022 14:07:10 +0800
IronPort-SDR: SOvCee/ijJszJSUn182ziAiwgedHyYI5HA3OOZFJQuT9Tua1bHTSYAXpbqb/KI3DXJvb3mClDL
 saPG+fd/LGjDl+iF9g5TQrSg4XgEo2pNIY+lh7MwflC7moISMXqOHhaIjtQced5bukBfbCfimg
 e6dq4Bd7G13k9je+VAgbicPgmE2AmwtrHEGNXxlXmTdSYEvtvA8K6RGzbMUz8Gn29QgNuyLMG7
 7EPg9ysys0e8zA4s0GTvEwgXv61tCXnZ6ZouCyqRpJ3u+yKXF4Ah9nac9GD/r/uXe+L7R6kotl
 Xmwn/HxjXGl+RAL8PrwaNZlh
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2022 22:29:42 -0700
IronPort-SDR: 19NsucuDfuKhw7ZVbH8ff1z6+y9evs9fecIdkpfWpCf95YwNpyf9ARJ0lfHpb1y9nve+PT/BP9
 B+DJtlwKiu4V9XlyT5wGmw+OpuwQyuoYBfuIMv4ooqU8mDVzoHBRVCcelYGRuV6QQLDBt3e5uW
 JOBVe9wjhzSKYrSMeOt4Ypd8EStY1wjstxUV70d9uePKk0dCO5phwZ1WTgwS9dTeYjQFDU6w/O
 PRTM533nd/HoDPmgPEL9uqBJyaPk25xaY+a+rV/7yGHv4lkxmMlImyRrFW8dwCqE+K1e2OBR68
 iNk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2022 23:07:11 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LRK196rMyz1SVp1
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jun 2022 23:07:09 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1655705229; x=1658297230; bh=jCVW2VD3p3E4Ofb+bvcuspH3xYyQy+8SWjI
        JiqR2b4M=; b=q3eZULXz9zGyoqnyr9s7mb/E5slOyE0yiAfnO3ioxojdfjrLpS2
        ftX2RJ+A/SkBChLaHGQrlzoGrkbLCtOoS11b2TzN+esm+4U39V/fTgPJdZgmj2a1
        frFphEFvyXCkgZhsUr8v8BAwDdGE8i5e6OE3vZhPDNSJ1pl1iv5SGQ2AUREyK+j0
        SxThN0R7nEL26MqextyVaPYFUSO/63gjjv8/NvCUTIBAvfyfHkiOuvHhXaVfwBXD
        5+zULVMWxOuX0CPBdaRDoidYpIvEIWQAE3dC08m35C7oC9Dw4u162G8tPUvcPZLy
        TE0InorKFCsTpiGNkjfgIlQLIjJcXiv12qg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cZ0VgycghNAx for <linux-scsi@vger.kernel.org>;
        Sun, 19 Jun 2022 23:07:09 -0700 (PDT)
Received: from [10.225.163.87] (unknown [10.225.163.87])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LRK180Gdwz1Rvlc;
        Sun, 19 Jun 2022 23:07:07 -0700 (PDT)
Message-ID: <594ac0c9-a55b-bec7-77e3-a6c7e9525f6b@opensource.wdc.com>
Date:   Mon, 20 Jun 2022 15:07:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 3/4] scsi: pm8001: Use non-atomic bitmap ops for tag alloc
 + free
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        jinpu.wang@cloud.ionos.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ajish.Koshy@microchip.com
References: <1654879602-33497-1-git-send-email-john.garry@huawei.com>
 <1654879602-33497-4-git-send-email-john.garry@huawei.com>
 <303bbfad-edde-1197-679e-4a09175fb1f3@suse.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <303bbfad-edde-1197-679e-4a09175fb1f3@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/20/22 15:00, Hannes Reinecke wrote:
> On 6/10/22 18:46, John Garry wrote:
>> In pm8001_tag_alloc() we don't require atomic set_bit() as we are already
>> in atomic context. In pm8001_tag_free() we should use the same host
>> spinlock to protect clearing the tag (and then don't require the atomic
>> clear_bit()).
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>>   drivers/scsi/pm8001/pm8001_sas.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
>> index 3a863d776724..8e3f2f9ddaac 100644
>> --- a/drivers/scsi/pm8001/pm8001_sas.c
>> +++ b/drivers/scsi/pm8001/pm8001_sas.c
>> @@ -66,7 +66,11 @@ static int pm8001_find_tag(struct sas_task *task, u32 *tag)
>>   void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag)
>>   {
>>   	void *bitmap = pm8001_ha->tags;
>> -	clear_bit(tag, bitmap);
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&pm8001_ha->bitmap_lock, flags);
>> +	__clear_bit(tag, bitmap);
>> +	spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
>>   }
>>   
> This spin lock is pretty much pointless; clear_bit() is always atomic.

But __clear_bit() is not atomic. I think it was the point of this patch,
to not use atomics and use the spinlock instead to protect bitmap.

Before the patch, pm8001_tag_alloc() takes the spinlock *and* use the
atomic set_bit(), which is an overkill. pm8001_tag_free() only clears the
bit using the the atomic clear_bit().

After the patch, spinlock guarantees atomicity for both alloc and free.

Not sure there is any gain from this.

> 
> Cheers,
> 
> Hannes


-- 
Damien Le Moal
Western Digital Research
