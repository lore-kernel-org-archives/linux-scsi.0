Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD3EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 23:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJSXX2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiJSXX0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 19:23:26 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020E5157F4F
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 16:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666221805; x=1697757805;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=vlkt1v1g8ti9pwOxJcXiOdit/xXQMhdKenJrDFCmjso=;
  b=qqv4/YG1l4D7y86GaMBpKej7ZCMvzqJ/yd3vsoTNJfhDAQaKazbXh6dE
   d6o/Lp1p+wr69qLYQPv4Wmogx7yqD/gPnrx8JMkVWT/TqpfITq3ODJGFz
   Y20wug84KfzF7ZK0grXjl/6Vs/DitZ4qHs3bAV3tMJPqMjn02nrj4x99s
   VR05XS3YNfw5aXPkESvr86xYTcJnaI5oZt2uAH0/wdfb8T7+I8ifXlahX
   beo+QKKq4WAQgLDO0rB6hNShh0lL04zv4hvl4oEFFHDjsUVF+qSI+St+y
   f6VRtzLZ3M+s6o/qFqskhsrsA0EwMfU31MopzEYKQMdkYKOKdvkOfUllL
   w==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661788800"; 
   d="scan'208";a="214269699"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Oct 2022 07:23:25 +0800
IronPort-SDR: rmdWpPvcvdY2itBm0UoHz1bO+AyDX6PnEKRiJF/H0owZfS+TSaR7Lu9ekoP0eA+dz5WBeImNea
 RHcWF5z3dYW3fKLuG2IHbjCWqN+ZrwbRHjYYbKJioYGSD2yDSoeps1R5n7Aea1MpRHmzHS0SnR
 YyIZUa4z4ExYFGqwuvmvlFNrHb3Zie2KtO/7z9oArr/maA/T2LIrcVM1U1Jv0l16aDuuwC1L4l
 PulqovnzXBr9pZhBFDN31OgLuCfaN5HOFmCLx5Rp4QuS4SNYnf+9nzMWdjM3lpiKdzQwAzAS64
 vLkf92rabfwbDIS0AntgQmnT
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 15:42:54 -0700
IronPort-SDR: AH+oYJ6427vTGUUoTQkxdHJ5CrEHB4jfpbr+NB6ACHx+MZGuRJOeodDyucwyzQf19NhvP43kG0
 RhQuXPjv/oB2wxZpgDk0OyWGf+UA7Jwg3dmfVzinpvyXbB9hF8awVZqibbPH6FHPOyEFq+xIEy
 YSLuz4nGmmiF2CLrm5aBQZywr3T4BU7C2zXc2fwqItvgzcVYTzNvhBpuq6ziLHgQCrQyjSDZsy
 L4jhETsizSqgyQP1ZVRVZW2kZ6lVf6PNP2mBxoQcabgMSTThLXvPiZy0pRuVFBOgJw2hj4jaYc
 4MY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 16:23:25 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mt6H104Khz1RvTr
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 16:23:25 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666221804; x=1668813805; bh=vlkt1v1g8ti9pwOxJcXiOdit/xXQMhdKenJ
        rDFCmjso=; b=irrCHZ2Gbic0GxtwKHzSkimxs96oAf2M4UExypF021UttufRCxd
        vzxXYaQxJRXcfS4xcmJY3iKja+Z6RIneNdsAx0573SnJ58G24k1ZRQx4GnLZj6wL
        hu0HRWoueUphsS6IcWgJMSB7GqJ1Vi9DMJIW8aCejHMoQgIRBPqqznjAd9VnyoeL
        tLbO+iQ5JuJOnDe2uNKxn8NLTLQRbD3Bagz97apNvZFnMVNUh1MjmR+rMO3mZBR4
        q2MArGIfXySvR9iLDoxAEHtn5JHBxN3+J1AmVJ6+tXJGKl+DB+dLu22m3ePaMw0U
        m0i1+PBI9m5RNjYz30N8Eb+9etDU6NlbcSQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EeSqyEIg1Lja for <linux-scsi@vger.kernel.org>;
        Wed, 19 Oct 2022 16:23:24 -0700 (PDT)
Received: from [10.225.163.126] (unknown [10.225.163.126])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mt6Gz341xz1RvLy;
        Wed, 19 Oct 2022 16:23:23 -0700 (PDT)
Message-ID: <787a0875-27c3-7bb8-8777-3d8b38635789@opensource.wdc.com>
Date:   Thu, 20 Oct 2022 08:23:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v4 06/36] hwmon: drivetemp: Convert to scsi_exec_req
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221016195946.7613-1-michael.christie@oracle.com>
 <20221016195946.7613-7-michael.christie@oracle.com>
 <01d9407a-26d1-e00b-8e52-04760af4b65a@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <01d9407a-26d1-e00b-8e52-04760af4b65a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/22 07:06, Bart Van Assche wrote:
> On 10/16/22 12:59, Mike Christie wrote:
>> scsi_execute* is going to be removed. Convert to scsi_exec_req so
>> we pass all args in a scsi_exec_args struct.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> Reviewed-by: Martin Wilck <mwilck@suse.com>
>> ---
>>   drivers/hwmon/drivetemp.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
>> index 5bac2b0fc7bb..ec208cac9c7f 100644
>> --- a/drivers/hwmon/drivetemp.c
>> +++ b/drivers/hwmon/drivetemp.c
>> @@ -192,9 +192,14 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
>>   	scsi_cmd[12] = lba_high;
>>   	scsi_cmd[14] = ata_command;
>>   
>> -	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
>> -				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
>> -				NULL);
>> +	return scsi_exec_req(((struct scsi_exec_args) {
>> +					.sdev = st->sdev,
>> +					.cmd = scsi_cmd,
>> +					.data_dir = data_dir,
>> +					.buf = st->smartdata,
>> +					.buf_len = ATA_SECT_SIZE,
>> +					.timeout = HZ,
>> +					.retries = 5 }));
>>   }
>>   
>>   static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
> 
> Since Damien Le Moal is the ATA Maintainer, you may want to Cc him for 
> ATA patches. Anyway:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

This is ATA related, but not ata code :)

Anyway, while not being a fan of the function call + struct initialization
all together, this looks correct to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

