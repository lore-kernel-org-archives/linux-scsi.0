Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C083C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 01:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242021AbhK0BIh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 20:08:37 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:22852 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344559AbhK0BGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 20:06:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637975004; x=1669511004;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XV4UqKRsXLb7fyc8i1b9TJahDUcJdMFsKICpbp+bl4c=;
  b=KHVkAwLgBNc5DbNRjQzaeluBlD5q+erkdpoY3f0DScmRKDuX/K15lKSr
   FgrT8vmaJXfsAW1uTieS3GN0kM8BU6XNKOwPEb7f6n8boSC5rthiEUXt6
   7T9gpXcjwySbmhf1OpwcZGCZf/kxAS+ekUDQz+byEq2nL8uZn8UeTYDsd
   OJGSB3lsbneewGFVHrzD8VCHxHrqlIkyGRHiFaxOcwANsCn2eEo5rllQZ
   AJL9oWv+zONK+ktgFdyj+I65dGJ51m6gpIQn9m6ikldKuqVP8AlhRKrSr
   cXJdDkrMWlfmDbBGBn38TNlZg/ISf4/cuH9GyQR4IGX+Dis8K6ryLkBSy
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,267,1631548800"; 
   d="scan'208";a="187798124"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2021 09:03:23 +0800
IronPort-SDR: Pkd5In3Z52bSUQoNpbNLiY/80g+EGu9YEsXd9aclaZVHU942tTxeeWiaqfHkcqGPptQ1H353OI
 iNzucsxgnGiEVvUpNX77wcINTIFxFmC/aGcOBdr//3RLte7/q2dqaaoVYoMqE/ebZhEyCLtAS+
 uypey4xweTmyrtoSiLPcdamqw3uetKumXqAeb7QqxQLxPTsShFEEB1RDLb9g/pba2yTFUzzWKN
 G5eXpYY+huNWaRR2aebKyKSL5oq1K4pDhQBXWfTcAisYjJC5z1w3bsj9nJzY2n67mHsgrdCzga
 dQGq7zX5geI/dC/1WOFdKojD
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 16:38:12 -0800
IronPort-SDR: bP/wT/uIzlU+JE942sHagJEkqPdkpn3aL+ujH7WazLOP0Pu6LNzwbkNIwMvKvMYf5l5nPjXwMF
 JQnDDwJp/vVyeA1UZSRKTtdXLJHWpQC62yRIQiI/6FyqM8i51Bdk8Y5T9rSZ/uxG6kAmAmt3jT
 LAfgsaIp16XW8TAJybpvuy6IP7qKdtWqi6EM8W8rKd4k1fH+fj4NUG2+QshsoMzIDPHymF4pF1
 XGGbT7NhE/ZZdm++0GvFbzfDZluSDm6aRVHSK6jgZEr7/yzdbsusM94dOuppNtTt5T5giJrE3U
 w44=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 17:03:22 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J1CzF2f1cz1RtVt
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 17:03:21 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637975000; x=1640567001; bh=XV4UqKRsXLb7fyc8i1b9TJahDUcJdMFsKIC
        pbp+bl4c=; b=fGckbpybtAVqefZm0g5qcnDBsb4PBdt/+3XRrtDJAnN2vlkOsMZ
        ZWY8Cp+iDh1HJujCbOXjJRqqk9+vQxjGucYAyRObYjgXoESBibulkdnVwz8Wxs7t
        eNULKkYagjYunNpnDCo804wNr1Xd3W1lkfe0zQMDJjoZnzJcB0Tg3eKWGmLWYmC2
        WwAt/3z1SrHpKwsumZfhNCNSHBqfWBkWUs2XFQR9uGlATcPtmAwPUqxre0Sircxf
        SStsNPDqm0vyY3H5sCKI8CQwQrIhn5Ox7F+hpzMuI9QC5GRWr3coWR9fou0DEnFs
        qgK65/auI96c6ZMBmZu8WNMvH47nip4lLZA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BKElDeotSceH for <linux-scsi@vger.kernel.org>;
        Fri, 26 Nov 2021 17:03:20 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J1CzD1z9Xz1RtVl;
        Fri, 26 Nov 2021 17:03:20 -0800 (PST)
Message-ID: <807efbfc-f249-1329-15f0-52f0f15eeed7@opensource.wdc.com>
Date:   Sat, 27 Nov 2021 10:03:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH 2/2] scsi: sd_zbc: Clean up sd_zbc_parse_report() setting
 of wp
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
 <20211126125533.266015-2-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211126125533.266015-2-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/26 21:56, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Make sd_zbc_parse_report() use if/else when setting the write pointer,
> instead of setting it unconditionally and then conditionally updating it.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  drivers/scsi/sd_zbc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 024f1bec6e5a..3e25ded3ac0f 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -61,10 +61,11 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
>  	zone.len = logical_to_sectors(sdp, get_unaligned_be64(&buf[8]));
>  	zone.capacity = zone.len;
>  	zone.start = logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
> -	zone.wp = logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
>  	if (zone.type != BLK_ZONE_TYPE_CONVENTIONAL &&
>  	    zone.cond == BLK_ZONE_COND_FULL)
>  		zone.wp = zone.start + zone.len;
> +	else
> +		zone.wp = logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
>  
>  	ret = cb(&zone, idx, data);
>  	if (ret)
> 

Looks good to me, modulo the switch to using BLK_ZONE_* enums.


-- 
Damien Le Moal
Western Digital Research
