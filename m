Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040F0C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 05:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiLLFqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 00:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLLFqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 00:46:22 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764C9BE1F
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 21:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670823981; x=1702359981;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=FBuL/f+SfIP+JeApVo5isNeQh7i9IaA86HrNllFL0nA=;
  b=VuqM2s4Hdjog6HWkA7Vim79vASD5L92ZS4YSUA5In2kmTqQ6yz7ua28f
   ajock+frqoxH5mjlaDqgBvyyCUTzSkVoZYjxTbk2agIoWLGEck0lYU9WR
   evlbYkqY83aprgNeoe0PQoUDLEUkSMJVYQrU+sq+Lj+163cy9k467oSeX
   aMLUcHGj63f7XVBZ5xf79DKveWaOa1p3o+rKObQEGN5bXo/2RykwT/mQt
   g26ck3/x/9nWfLQgN5OhVx+2YEJyBlQZCXZM45q17xaJRMd6j9aoFQlYx
   FITv6cmUuOCrlobSeh6EHsss5aZwtgZ63p/7ztN4mUXpjYwbfO2Xi4CaQ
   g==;
X-IronPort-AV: E=Sophos;i="5.96,237,1665417600"; 
   d="scan'208";a="223568571"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 13:46:20 +0800
IronPort-SDR: vkWlAaI6KRwewDCQKKbokOubZ3JmtEnse4O1GbKtnsukY05eck0AwNPfS3LSNzyt2lsU5vv1ic
 DWyhU8ij2XgQk0fu/WUHvHM6rIvA9evbXtT1IX2xoFfYeF+1D/izbfID/o86gr66gC0y0KeQEN
 QiFDaTd4GY/Mj670Fmlulipei5Cq/iJTebeuht374RmXJOUimoVaN1X04QExRaLx9GUfQtTJWQ
 PZeV/rPgahDmzolvmVEwHzELXsnXnNVxdly8BVPW3nV5B0T99F4o4W2EULRU1Axxxy1snLDM0x
 X9A=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 20:59:00 -0800
IronPort-SDR: kPIqx+t/CgTTt4tfn0Pr7QAjNuVVAIzBS2ZhKLqTmmgN3xq69FVXad+bLePYH+XdlzYYypffis
 NK/fltKUwr11rjfBOgSowoptfVy36pYCyKf1/xQ12/B/bJxA4zqnp6raKPPaR2Y4T/TbLLG6xq
 AU6QV1oxMfeGBOTvelMxAs50JW/IiEcD4hHX60bdUgYj5R7tgHMvZBH45mvMmJeanfl4Iu4Lkm
 oJOrNIdRIQsp5zLwO7PKkCV1zT93G55EjEqulba30GYMCtg+g9Xm6leskIFYWWm2bgVJCKqYa3
 F9E=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 21:46:20 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NVrGM6Q5Dz1Rwrq
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 21:46:19 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670823978; x=1673415979; bh=FBuL/f+SfIP+JeApVo5isNeQh7i9IaA86Hr
        NllFL0nA=; b=ZpktU1I5bDOj/B2HV9ABMDlORKCWK8pKZ1KLd8kLyqCuiV9+V+j
        qpPe0nYwnvyDR+apmF/QDKmVOa3zKOggRMN4JIH49rAfdy5dMoOVWpV9pU7424Ke
        5gc9onjXlt2a631gyl6EsiTuGey2d9LqYJhyu898MEWbFrpXxzp3DmR+PxRxFnOS
        UrO3J/Kz3lVHov/IqmfEWr+mBTGkYTr/S+OqazSCYE2Q1IRG9CskEfVM+68a22tb
        vPzIFLFKLt9RjWXpteLaWJ2k+CWWS9ZwR2cKPy24QX9bMYb0poH110KrFMQx/F7/
        jEMO94w3ftYCEOJjKj2ProAW2wAgqv//t0Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fjz8lfo0lYcb for <linux-scsi@vger.kernel.org>;
        Sun, 11 Dec 2022 21:46:18 -0800 (PST)
Received: from [10.225.163.90] (unknown [10.225.163.90])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NVrGK4y2bz1RvLy;
        Sun, 11 Dec 2022 21:46:17 -0800 (PST)
Message-ID: <d16ef645-d60c-6b2f-7369-5b7f535631ca@opensource.wdc.com>
Date:   Mon, 12 Dec 2022 14:46:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 2/3] scsi: mpi3mr: fix bitmap memory size calculation
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
 <20221212015706.2609544-3-shinichiro.kawasaki@wdc.com>
 <c65beb54-7ff3-1a95-f255-916c25ef03d3@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <c65beb54-7ff3-1a95-f255-916c25ef03d3@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/12/22 14:35, Damien Le Moal wrote:
> On 12/12/22 10:57, Shin'ichiro Kawasaki wrote:
>> To allocate memory for bitmaps, the mpi3mr driver calculates sizes of
>> each bitmap using byte as unit. However, bit operation helper functions
>> assume that bitmaps are allocated using unsigned long as unit. This gap
>> causes memory access beyond the bitmap memory size and results in "BUG:
>> KASAN: slab-out-of-bounds". The BUG was observed at firmware download to
>> eHBA-9600. Call trace indicated that the out-of-bounds access happened
>> in find_first_zero_bit called from mpi3mr_send_event_ack for the bitmap
>> miroc->evtack_cmds_bitmap.
>>
>> To avoid the BUG, fix bitmap size calculations using unsigned long as
>> unit. Apply this fix to five places to cover all bitmap size
>> calculations in the driver.
>>
>> Fixes: c5758fc72b92 ("scsi: mpi3mr: Gracefully handle online FW update operation")
>> Fixes: e844adb1fbdc ("scsi: mpi3mr: Implement SCSI error handler hooks")
>> Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
>> Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
>> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>> ---
>>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 25 ++++++++++---------------
>>  1 file changed, 10 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
>> index 0c4aabaefdcc..272c318387b7 100644
>> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
>> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
>> @@ -1160,9 +1160,8 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
>>  		    "\tcontroller while sas transport support is enabled at the\n"
>>  		    "\tdriver, please reboot the system or reload the driver\n");
>>  
>> -	dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
>> -	if (mrioc->facts.max_devhandle % 8)
>> -		dev_handle_bitmap_sz++;
>> +	dev_handle_bitmap_sz = sizeof(unsigned long) *
>> +		DIV_ROUND_UP(mrioc->facts.max_devhandle, BITS_PER_LONG);
>>  	if (dev_handle_bitmap_sz > mrioc->dev_handle_bitmap_sz) {
>>  		removepend_bitmap = krealloc(mrioc->removepend_bitmap,
>>  		    dev_handle_bitmap_sz, GFP_KERNEL);
>> @@ -2957,25 +2956,22 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
>>  	if (!mrioc->pel_abort_cmd.reply)
>>  		goto out_failed;
>>  
>> -	mrioc->dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
>> -	if (mrioc->facts.max_devhandle % 8)
>> -		mrioc->dev_handle_bitmap_sz++;
> 
> mrioc->dev_handle_bitmap_sz = (mrioc->facts.max_devhandle + 7) >> 3;
> 
> would be a lot simpler...

Actually, if the code is changed to use bitmap_zalloc(), no rounding up to
8 or BITS_PER_LONG is needed at all, so the code would be really simpler.

> 
>> +	mrioc->dev_handle_bitmap_sz = sizeof(unsigned long) *
>> +		DIV_ROUND_UP(mrioc->facts.max_devhandle, BITS_PER_LONG);
>>  	mrioc->removepend_bitmap = kzalloc(mrioc->dev_handle_bitmap_sz,
>>  	    GFP_KERNEL);
> 
> What about using bitmap_alloc() here and keep the dev_handle_bitmap_sz
> value as is ?
> 
> (same for the other bitmaps)
> 
>>  	if (!mrioc->removepend_bitmap)
>>  		goto out_failed;
>>  
>> -	mrioc->devrem_bitmap_sz = MPI3MR_NUM_DEVRMCMD / 8;
>> -	if (MPI3MR_NUM_DEVRMCMD % 8)
>> -		mrioc->devrem_bitmap_sz++;
>> +	mrioc->devrem_bitmap_sz = sizeof(unsigned long) *
>> +		DIV_ROUND_UP(MPI3MR_NUM_DEVRMCMD, BITS_PER_LONG);
>>  	mrioc->devrem_bitmap = kzalloc(mrioc->devrem_bitmap_sz,
>>  	    GFP_KERNEL);
>>  	if (!mrioc->devrem_bitmap)
>>  		goto out_failed;
>>  
>> -	mrioc->evtack_cmds_bitmap_sz = MPI3MR_NUM_EVTACKCMD / 8;
>> -	if (MPI3MR_NUM_EVTACKCMD % 8)
>> -		mrioc->evtack_cmds_bitmap_sz++;
>> +	mrioc->evtack_cmds_bitmap_sz = sizeof(unsigned long) *
>> +		DIV_ROUND_UP(MPI3MR_NUM_EVTACKCMD, BITS_PER_LONG);
>>  	mrioc->evtack_cmds_bitmap = kzalloc(mrioc->evtack_cmds_bitmap_sz,
>>  	    GFP_KERNEL);
>>  	if (!mrioc->evtack_cmds_bitmap)
>> @@ -3415,9 +3411,8 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
>>  		if (!mrioc->chain_sgl_list[i].addr)
>>  			goto out_failed;
>>  	}
>> -	mrioc->chain_bitmap_sz = num_chains / 8;
>> -	if (num_chains % 8)
>> -		mrioc->chain_bitmap_sz++;
>> +	mrioc->chain_bitmap_sz = sizeof(unsigned long) *
>> +		DIV_ROUND_UP(num_chains, BITS_PER_LONG);
>>  	mrioc->chain_bitmap = kzalloc(mrioc->chain_bitmap_sz, GFP_KERNEL);
>>  	if (!mrioc->chain_bitmap)
>>  		goto out_failed;
> 

-- 
Damien Le Moal
Western Digital Research

