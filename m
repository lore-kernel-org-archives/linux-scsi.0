Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF35CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 23:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiGKX2h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiGKX2c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 19:28:32 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12268AED1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657582099; x=1689118099;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=phvl3YOOdW42IiTKFpvBZyB+lJPE1VIg3pfFESIUyg4=;
  b=IrsOc7wD5VoJ2mxs+Ll0VdG4SCctfGCFW5YGkSgGrLz6MkDo3yiVZQyA
   pDzlB72/U4kko0kiMNTTLEtqP1O+s1rtUPrDISCtEweCWO9LjS/XBPU8v
   YwuX/kScuIEQ/g0RqnzLGFgLGyZrZ45Xlan6fncPSYFJXuZTORnNguSYB
   2KsdIqLhJDJAQv6oQ9wx0hMvuWtP3LV1h6LEWQWgMSElucFlMjpr5cOcQ
   RqFCTDAusUgCzPwLxHu5GRud20g9LqkPV0GPrRsSqVt7WVeB4A2XwepTe
   Zreoh9R423KXLpgeXaa1sjc67mBi1qTtn5rmBM/aVdxsxxKOVUMC9YlHQ
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,264,1650902400"; 
   d="scan'208";a="205429130"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2022 07:28:18 +0800
IronPort-SDR: j7l4z1beDMudVIfGD4Hi/R2NNC/s96yB1kOk8GadnSOjN5lg6y3t4TjiiF011D9PynGMHrW4Fz
 iZJxTs3qjNDHQqwNNx49/1hC/3UWhJyKHzYa8pKg2yriMZH6vA3zBgZxoQ8CpyaRWHwVBx8D3r
 3IyKdFPSR6UOgf1Zwx0KFnhbbYc/DfgUlUI1GkCJO39+lEOZQ4Wy0/74NUWhLolirH8JsSHlv+
 v+GqagUI3c2r2tXaq6BKYOlFUVxhdZ+IKpMXcjVNkRxs2rWZU+gidjN5e7jRNyZ4YTX8EeLeio
 TJdXg2nBSlpf/yvLaACQMCZc
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 15:45:18 -0700
IronPort-SDR: TtfdxmGB9WAyNzmGXodVMTbRSJyQpW+dmRJ0xYtHYiqFECayMbNh1ZVXmE3Q66Uk6zWk24j2we
 HgT6vmDQiVe0D62/jlUgeLazP+MgLd3r99Nc4G5bKdMVpeGHqq03Ha/gRNkxLFFR2PY1L7wyK6
 Y5lBNDhi2IFR+DcQPN5rlaWAzNgLyPthW3Vp7tMBX+zIAY48ZPRNkhM2jABaFydEbSkFueMnms
 MuslibHIzzY1qYeP1xHFtJl+Q/bOOfxeQXDZNFw7Td2OoOkXdiloPHpf1v52YAp6iFch14c2VY
 h1Y=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 16:28:20 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Lhg6q4pc5z1Rwnl
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:28:19 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1657582098; x=1660174099; bh=phvl3YOOdW42IiTKFpvBZyB+lJPE1VIg3pf
        FESIUyg4=; b=nZ+9v7Kc3DYpg9a3AhqDXFy3Aku6aRMT4q7aXa3giA1yB+O1hB4
        689sJC/N2coR+B3sNAMtccKRmUYh6zfV5U35hb4goYsX+eCoM3RB1amcuNos8f/B
        Dubr9Ah3+f/MrT78S77cYWCbxq98mFDeVV2EpwQavwSamqx7WqMNgeZQAbCTlZsx
        lVnlpeifAx3ECXSXDxi6VMwDa66hqGwnWg85KgsptxKuSEh1Td0u4XFnbpBqh9p0
        UzwxkMgczaO8NV7nMnZTHzXxpyyc2FyiESTE1TBLySoJS4Btgzr+7ynDpdzBxmyk
        TRwJPPDycSpQdOPLyspniE1F/X/0Giv9ikw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id M0GlsNwvMG5i for <linux-scsi@vger.kernel.org>;
        Mon, 11 Jul 2022 16:28:18 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Lhg6n6lD2z1RtVk;
        Mon, 11 Jul 2022 16:28:17 -0700 (PDT)
Message-ID: <95f2f1d5-3e32-bb6f-b8e4-df0c232ed6eb@opensource.wdc.com>
Date:   Tue, 12 Jul 2022 08:28:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-4-bvanassche@acm.org>
 <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/22 08:11, Damien Le Moal wrote:
> On 7/12/22 08:00, Bart Van Assche wrote:
>> Using the RETURNED LOGICAL BLOCK ADDRESS field + 1 as the capacity (largest
>> addressable LBA) if RC BASIS = 0 is wrong if there are sequential write
>> required zones. Hence only use the RC BASIS = 0 capacity if there are no
>> sequential write required zones.
> 
> This does not make sense to me: RC BASIS == 0 is defined like this:
> 
> The RETURNED LOGICAL BLOCK ADDRESS field indicates the highest LBA of a
> contiguous range of zones that are not sequential write required zones
> starting with the first zone.
> 
> Do you have these cases:
> 1) host-managed disks:
> SWR zones are *mandatory* so there is at least one. Thus read capacity
> will return either 0 if there are no conventional zones (they are
> optional) or the total capacity of the set of contiguous conventional
> zones starting at lba 0. In either case, read capacity does not give you
> the actual total capacity and you have to look at the report zones reply
> max lba field.
> 2) host-aware disks:
> There are no SWR zones, there cannot be any. You can only have
> conventional zones (optionally) and sequential write preferred zones. So
> "the highest LBA of a contiguous range of zones that are not sequential
> write required zones starting with the first zone" necessarily is always
> the total capacity. RC BASIS = 0 is non-sensical for host-aware drives.

What I meant to say here for the host-aware case is that RC BASIS is
irrelevant. Both RC BASIS = 0 and = 1 end up with read capacity giving the
actual total capacity. ANd for good reasons: the host-aware model is
designed to be backward compatible with regular disks, which do not have
RC BASIS, so RC BASIS = 0, always.

> 
> So I do not understand your change.
> 
> Note that anyway, there are no drives out there that use RC BASIS = 0. I
> had to hack a drive FW to implement it to test this code...
> 
>>
>> Cc: Damien Le Moal <damien.lemoal@wdc.com>
>> Cc: Hannes Reinecke <hare@suse.com>
>> Fixes: d2e428e49eec ("scsi: sd_zbc: Reduce boot device scan and revalidate time")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/scsi/sd_zbc.c | 26 ++++++++++++++++++++++----
>>  1 file changed, 22 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>> index 6acc4f406eb8..41ff1c0fd04b 100644
>> --- a/drivers/scsi/sd_zbc.c
>> +++ b/drivers/scsi/sd_zbc.c
>> @@ -699,7 +699,7 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
>>   *
>>   * Get the device zone size and check that the device capacity as reported
>>   * by READ CAPACITY matches the max_lba value (plus one) of the report zones
>> - * command reply for devices with RC_BASIS == 0.
>> + * command reply.
>>   *
>>   * Returns 0 upon success or an error code upon failure.
>>   */
>> @@ -709,6 +709,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
>>  	u64 zone_blocks;
>>  	sector_t max_lba;
>>  	unsigned char *rec;
>> +	u8 same;
>>  	int ret;
>>  
>>  	/* Do a report zone to get max_lba and the size of the first zone */
>> @@ -716,9 +717,26 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
>>  	if (ret)
>>  		return ret;
>>  
>> -	if (sdkp->rc_basis == 0) {
>> -		/* The max_lba field is the capacity of this device */
>> -		max_lba = get_unaligned_be64(&buf[8]);
>> +	/*
>> +	 * From ZBC-1: "If the ZONE LIST LENGTH field is zero then the SAME
>> +	 * field is invalid and should be ignored by the application client."
>> +	 */
>> +	if (get_unaligned_be32(&buf[0]) == 0) {
>> +		sd_printk(KERN_INFO, sdkp, "No zones have been reported\n");
>> +		return -EIO;
>> +	}
>> +
>> +	same = buf[4] & 0xf;
>> +	max_lba = get_unaligned_be64(&buf[8]);
>> +	/*
>> +	 * The max_lba field is the largest addressable LBA of the disk if:
>> +	 * - Either RC BASIS == 1.
>> +	 * - Or RC BASIS == 0, there is at least one zone in the response
>> +	 *   (max_lba != 0) and all zones have the same type (same == 1 ||
>> +	 *   same == 2).
>> +	 */
>> +	if ((sdkp->rc_basis == 0 && max_lba && (same == 1 || same == 2)) ||
>> +	    sdkp->rc_basis == 1) {
>>  		if (sdkp->capacity != max_lba + 1) {
>>  			if (sdkp->first_scan)
>>  				sd_printk(KERN_WARNING, sdkp,
> 
> 


-- 
Damien Le Moal
Western Digital Research
