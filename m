Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716D6C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 18:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbhKVSsW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 13:48:22 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:58695 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239598AbhKVSsV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 13:48:21 -0500
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 6A9A52EA7E6;
        Mon, 22 Nov 2021 13:45:12 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id SfAv9z5ZKphY; Mon, 22 Nov 2021 13:45:12 -0500 (EST)
Received: from [192.168.48.23] (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id B103D2EA7AB;
        Mon, 22 Nov 2021 13:45:11 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2] scsi: scsi_debug: Zero clear zones at reset write
 pointer
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20211122061223.298890-1-shinichiro.kawasaki@wdc.com>
 <a307f2c2-12fc-a193-6438-fc44c653657b@opensource.wdc.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <3058c488-996f-2f07-d9bd-4384bd4f7ba6@interlog.com>
Date:   Mon, 22 Nov 2021 13:45:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a307f2c2-12fc-a193-6438-fc44c653657b@opensource.wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-11-22 1:32 a.m., Damien Le Moal wrote:
> On 2021/11/22 15:12, Shin'ichiro Kawasaki wrote:
>> When reset write pointer is requested to scsi_debug devices with zoned
>> model, positions of write pointers are reset, but the data in the target
>> zones are not cleared. Read to the zones returns data written before the
>> reset write pointer. This unexpected left data is confusing and does not
>> allow using scsi_debug for stale page cache test of the BLKRESETZONE
>> ioctl. Hence, zero clear the written data in the zones at reset write
>> pointer.
>>
>> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
>> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>> ---
>> Changes from v1:
>> * Zero clear only the written data area in non-empty zones
>>
>>   drivers/scsi/scsi_debug.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index 1d0278da9041..1ef9907c479a 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -4653,6 +4653,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
>>   			 struct sdeb_zone_state *zsp)
>>   {
>>   	enum sdebug_z_cond zc;
>> +	struct sdeb_store_info *sip = devip2sip(devip, false);
>>   
>>   	if (zbc_zone_is_conv(zsp))
>>   		return;
>> @@ -4664,6 +4665,10 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
>>   	if (zsp->z_cond == ZC4_CLOSED)
>>   		devip->nr_closed--;
>>   
>> +	if (zsp->z_wp > zsp->z_start)
>> +		memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
>> +		       (zsp->z_wp - zsp->z_start) * sdebug_sector_size);
>> +
>>   	zsp->z_non_seq_resource = false;
>>   	zsp->z_wp = zsp->z_start;
>>   	zsp->z_cond = ZC1_EMPTY;
>>
> 
> Looks good.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Thanks.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
