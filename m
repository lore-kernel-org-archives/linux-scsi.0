Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D8EC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Apr 2022 23:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiDQXMq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Apr 2022 19:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiDQXMd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Apr 2022 19:12:33 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B75EB9E
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650236996; x=1681772996;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ELA1hCyKdupR/HCmzqjECxgejDRvLAn5veaDFaRqiTk=;
  b=ZqbBG5zmM8ljRykZHlX7uSQhbuPe0DBBlqjhUKDI45rznTa0dOjaawvY
   R275ohuYsvhYngJjsfNBeQWc/0qTsbmMZzDctiHS2l0D0yskUnb1lbcLn
   dMoFXMUfZINI1P6QC/43PQT7LtyUmrs8qB2VKYgdXGMQQ1Y7DwkxGLUjA
   cZ0TP5IbdvyFTk+TBbpESEgSv1Mjqk/aoCDXDX8RlRahQquxv+mVmthzt
   7z/Ul5EeRdPk8pjQRyTk43xWnloB06YXUiTiEgX8JQcBGR14PPO+siLsh
   HTh29T4lbmHDEgl5L95LiKnYR6ZUdNXcOjkNKX4gJGBOpMY0xU1xvRa1W
   g==;
X-IronPort-AV: E=Sophos;i="5.90,267,1643644800"; 
   d="scan'208";a="310084940"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 07:09:55 +0800
IronPort-SDR: 4qtuwrnbIdmTJ2LxKkL/CBOQ1yfHYMQKwxkQ0UlGkLo2trMMe/NryrxK+4CWtyheMJhJHElQ8u
 v3lRugFoD67rl/6uGN/Shigab7botUISM7zQDIiOrJpRQhb+V9PHe63LThqq2zljLmZfFlD9b9
 813vw7akkf46YjJ9zFtUGTkX49tCVw6UZUc8cic+YvTRQN1Gv0w9trllWpWM8kMr/VJdv4fS3J
 PATbjAxzCRgQkUClM7RRg/A/SfhxCJNEJuk3jjWT1u31ZVqqqXyKf6ySn0AKQUi7SsIKZszJlO
 GWoW00eeVPX9xipHEj0gWdK4
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 15:40:17 -0700
IronPort-SDR: 7b02jwH3+3NZRNMxj7QugvAnoPp2vbK6ErKdqJtMmPqWMDubvhw54XMJM5Aory0hEZzMnOF90k
 M2hs17pzLFYAGzPs4kI+BdaFUw+Q9/u7f204qtL+bzM2wUQfru282R3jv1jTOTgxZIpYE2toh5
 Wa+3ICJrMOErzVyqXHBRXrN9O/H2WqRQ8IlZLdonVugKGLxbMWpjqFeH4DiWIeaB0teXrWUEqs
 L7g7KF0zFw2FtlXxw5aC1iWTFRts9+BGQ+5/IFQcdlniivo8RSG/H9CYpPwJSLUuCM5vKS1KMi
 Rg4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 16:09:55 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhQkq2Cs5z1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:09:55 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650236994; x=1652828995; bh=ELA1hCyKdupR/HCmzqjECxgejDRvLAn5vea
        DFaRqiTk=; b=Zz+5FWPQYcKeSqzt7aI9owsYZI1+OE2OiFS6VTu/uSRMYDjaMhB
        QFDAcJxiTWNn6zFvL5SVbLoxM9PYkUk6RTOKD46tnQKgZMwixwh7q4ZiwSY4SKge
        +cegAP9F8MgmZVGqkPOwcuZYvvqtNbYzsV6rq6T21Yb4Zp7d4CsRLpWpaHgczxZD
        6AVCZSB97a8vi7D2Yjm4uor3jSWLjjK5pStF8s5u9F6XtlVc1x55tN5VW1U5KxdR
        EUpvW5T9IW53GSjoBBLOsEJInJ5mGFOaIK4CLAJ7TYYbST12uDB8brYBXMza0d+2
        3K5c3S/zSQ2b3M8RQdXy2Rqh1DwSBO4ji5w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id WwBq_gTjYabT for <linux-scsi@vger.kernel.org>;
        Sun, 17 Apr 2022 16:09:54 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhQkn4dNpz1Rvlx;
        Sun, 17 Apr 2022 16:09:53 -0700 (PDT)
Message-ID: <eb2e59d1-b28b-aaa3-ca70-46f7ccfbba06@opensource.wdc.com>
Date:   Mon, 18 Apr 2022 08:09:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 3/8] scsi: sd_zbc: Verify that the zone size is a power of
 two
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220415201752.2793700-1-bvanassche@acm.org>
 <20220415201752.2793700-4-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220415201752.2793700-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/22 05:17, Bart Van Assche wrote:
> The following check in sd_zbc_cmnd_checks() can only work correctly if
> the zone size is a power of two:
> 
> 	if (sector & (sd_zbc_zone_sectors(sdkp) - 1))
> 		/* Unaligned request */
> 		return BLK_STS_IOERR;
> 
> Hence this patch that verifies that the zone size is a power of two.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Note that this is already checked in blk_revalidate_disk_zones(), but it
does not hurt to add the check.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/sd_zbc.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index d0275855b16c..c1f295859b27 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -666,6 +666,13 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
>  
>  	*zblocks = zone_blocks;
>  
> +	if (!is_power_of_2(*zblocks)) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "Zone size %llu is not a power of two.\n",
> +			  zone_blocks);
> +		return -EINVAL;
> +	}
> +
>  	return 0;
>  }
>  


-- 
Damien Le Moal
Western Digital Research
