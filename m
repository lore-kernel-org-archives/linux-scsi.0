Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3F6C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 10:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiGRKiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 06:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiGRKiJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 06:38:09 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881031E3CC
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 03:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1658140688; x=1689676688;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xgDweaqwjGUysEECMRUqriZmy2u4jS4ab5O4RgakWtI=;
  b=Qa+vtsCwWfAZcqjJimnCs0IfjgKWukLayHyyr1wgzWoVTMzsW52rj9JD
   8l4Jbb0gUj8iBCC1vnVRQ+oXFcPAD+5+tgDvFsKrWFFfJ+UwDNc98Irfm
   0vNmxrHTuIPHJWi6Fk1x9m+6f6rZHu86YXdJBkRyYDL41ovcAYDaK33DR
   D2M/FT2O9z+MUzvPpHiaGEv4Ko5FhdLueuYmG7OiIKej6X3el30DhRloV
   +m5tFPywA3D4AGn3VXmDoOO5GcJZBKXiJ/P3Fa32aELee4/+DA3KVdPQW
   VKBLICXB4hYFnrOToeIR27HUndAQFDWX3+/R6TyRESAehsR2IL10QNAaM
   w==;
X-IronPort-AV: E=Sophos;i="5.92,280,1650902400"; 
   d="scan'208";a="206713533"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2022 18:38:07 +0800
IronPort-SDR: V/39qDUe4HD2GePwXzdbNL9HsVgx01+ToTObpL6zolRiME2O48xKKByfdYtd5c5zv7N6UWvBk7
 KACfd9RV0+px/IrH0/Iypaw0j4IfwyeL9JXXYCZDucR023a4bw5hHz3fGAN92i3/TDZo4mJ5+z
 rZBq/kARToSyS/5v9hCFF4vr18Z7pav5dQqgEVRLKwx4lc3AZMPqcHCE6qD8m7VCKWwzvVpkSd
 J8IZC+hWGdVdRYoZKPO6b8Xt7DqPwGljtdmxVYrD1ZIP4s4vxUzvSvlSxKg+EOLLt2C8e1wt01
 Y2kT3ZKptWp1u/XDZ4Mk7Rli
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jul 2022 02:54:51 -0700
IronPort-SDR: 9IW7gM8lvEZ00GF6HX3iNKaDPKh4ciltqE3/+ARlSZzEyL9lGufBZJT4FVKvEc4mNsWJh5lrPu
 W4rtacxxPp1mho14XBN09/bvFoj2xP0g9icMt2Dk+uWByUR+xpnKtc3zwdJ6J6ozIljDIj6/y5
 TQHl6vTPMkM667XuX8BXVh1ydg5zyuvcEQJAafIz9uGjT0qjh9lRJxAiq6MyogQkRAEOw4JPNy
 PvhA+kIbxmPv4l3A2LZ3gt56cVObexxXM9hDoKDx+MmCTxxot5FQ9HSCZDYRmtArklNI/LVxG8
 cYY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jul 2022 03:38:08 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Lmdhv2cRRz1Rwqy
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 03:38:07 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1658140686; x=1660732687; bh=xgDweaqwjGUysEECMRUqriZmy2u4jS4ab5O
        4RgakWtI=; b=LEH1+2RUN/bJXe3q39TQQCBwyW9DcE6FJBp9iWhBoh16S168f7T
        jxYGt7li+vorxylifIdeaJKoCiWS90oMC1StXaIGRqRZ+a+xzpSj+8HgMK4DjyRv
        rsgxTz6qlY1/WcYu9G3U3b+3sykraW5DYiHUHgF3vDfAMfWPXEX2WCcQcRFJDsDB
        VLXhPiUGMYX5w+fXXRjiHMPrgQiz/Uy2x4agKjdL8SitTfdctuPdC9fxrq8jJ2zQ
        5peMav8Ay58Qo7pg+qe3YSmx7PeNL51T0vKHzgizhGhklepgOYRBCPf7jflpvF++
        ThxxeqS2h41WTYAk72YSAmao5RV1cHM924A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QSNp4k-b3CIa for <linux-scsi@vger.kernel.org>;
        Mon, 18 Jul 2022 03:38:06 -0700 (PDT)
Received: from [10.225.163.120] (unknown [10.225.163.120])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Lmdhr4K4pz1RtVk;
        Mon, 18 Jul 2022 03:38:04 -0700 (PDT)
Message-ID: <11a23d81-b949-15de-11d3-426d2fd45db9@opensource.wdc.com>
Date:   Mon, 18 Jul 2022 19:38:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-4-bvanassche@acm.org>
 <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
 <95f2f1d5-3e32-bb6f-b8e4-df0c232ed6eb@opensource.wdc.com>
 <7f58e047-8fa8-7300-3062-ab1d22495b2d@acm.org>
 <6d228185-1ce3-b0c8-71b8-badfe78505b7@opensource.wdc.com>
 <01cac097-1420-2142-c701-2542bf437656@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <01cac097-1420-2142-c701-2542bf437656@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/16/22 05:53, Bart Van Assche wrote:
> On 7/12/22 15:08, Damien Le Moal wrote:
>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>> index 6acc4f406eb8..32da54e7b68a 100644
>> --- a/drivers/scsi/sd_zbc.c
>> +++ b/drivers/scsi/sd_zbc.c
>> @@ -716,17 +716,15 @@ static int sd_zbc_check_capacity(struct scsi_disk
>> *sdkp, unsigned char *buf,
>>          if (ret)
>>                  return ret;
>>
>> -       if (sdkp->rc_basis == 0) {
>> -               /* The max_lba field is the capacity of this device */
>> -               max_lba = get_unaligned_be64(&buf[8]);
>> -               if (sdkp->capacity != max_lba + 1) {
>> -                       if (sdkp->first_scan)
>> -                               sd_printk(KERN_WARNING, sdkp,
>> -                                       "Changing capacity from %llu to
>> max LBA+1 %llu\n",
>> -                                       (unsigned long long)sdkp->capacity,
>> -                                       (unsigned long long)max_lba + 1);
>> -                       sdkp->capacity = max_lba + 1;
>> -               }
>> +       /* The max_lba field is the capacity of this device */
>> +       max_lba = get_unaligned_be64(&buf[8]);
>> +       if (sdkp->capacity != max_lba + 1) {
>> +               if (sdkp->first_scan)
>> +                       sd_printk(KERN_WARNING, sdkp,
>> +                               "Changing capacity from %llu to max LBA+1 %llu\n",
>> +                               (unsigned long long)sdkp->capacity,
>> +                               (unsigned long long)max_lba + 1);
>> +               sdkp->capacity = max_lba + 1;
>>          }
>>
>>          if (sdkp->zone_starting_lba_gran == 0) {
>>
>> That is, always check the reported capacity against max_lba of report
>> zones reply, regardless of rc_basis (and we can even then drop the
>> rc_basis field from struct scsi_disk).
> 
> I like the above patch because it simplifies the existing code.
> 
>> But I would argue that any problem with the current code would mean a
>> buggy device firmware. For such case, the device FW should be fixed or we
>> should add a quirk for it.
> 
> My question was which approach should be followed for devices with a 
> buggy firmware? Use the zones up to the LBA reported in the READ 
> CAPACITY response or reject these devices entirely?

We should not try to write code for buggy devices. These should be handled
with quirks, or even better, ignored to give incentives to the device
vendor to fix their bugs.

Even the above code (removing the "sdkp->rc_basis == 0" test) is
borderline in my opinion. The code with the test is per specs, so correct.

If you really insist on changing the code as above, we should add
something like this under the "if (sdkp->capacity != max_lba + 1) {":

	if (sdkp->rc_basis != 0)
		sd_printk(KERN_WARNING, sdkp,
			  "ZBC device reported an invalid capacity\n");

To signal that the drive is wrong.

> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research
