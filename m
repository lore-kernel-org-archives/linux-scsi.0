Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4124C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 22:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiKBWbZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 18:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiKBWbV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 18:31:21 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D090959B
        for <linux-scsi@vger.kernel.org>; Wed,  2 Nov 2022 15:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667428280; x=1698964280;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wycN1ywsGVar2/HmuDfjKLByGk6bVQGXsupV97TH910=;
  b=rMXnDTSdupa+M/Y6xbGG6JmJAJmS1lvXpbbFPyMc6eJvRlYUAGR+vXEX
   3AZYRnXVhy45sGvJRl1cyi3BowpFmoSh6xvueylYP6nVa/ZCp9xzzLx5P
   5PuVJL7OOluwXEvJpd7O2cOZaKIUlTbvI/NqgDvhwnvKxbYJnk0/huEDD
   53NY+kAdKGfd+fEPuP4ctmWb+erXfsvzeS2TN3VMPPu/0oy3XQJzmE4HI
   wDAIBYq3uTT0QO7h9ggAcCLUIz4fshcysSFy1NPxyQ8XPm30zaOuOMyFs
   JNjjmYtdHuHXT0dsqamocg5ix3Wqe9+YyXKsXbXcpXEbrcAoxAJ4dD+fq
   w==;
X-IronPort-AV: E=Sophos;i="5.95,235,1661788800"; 
   d="scan'208";a="327451322"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Nov 2022 06:31:20 +0800
IronPort-SDR: FBZkAlyVn/lKhFf3Jnn6tN5jb83Iqu/EXnblK3Ut1OSe8eRqatVkmdvGscsqC5WsWzLkl2QNss
 fWRCv0BVo+cd80OpWgHRySZv0vCcXw/dMat1WWNyvlzMlecjQ3IVH2SnXr5R1vCHmcu9H3LUal
 f2eVuacW54Jk28FJTC7kjMiPekt4cGOk6LpdaKz2rIk7ecdAVi6LvKOag6qNb6cnApuY6o1fiV
 o9LD7ip5enDOdTq8Gdgx7J8Q8zB7YaSdG5Ibp98spAeiuELJPxjiPwukqV3uB6f4/22J4baV46
 krE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Nov 2022 14:44:47 -0700
IronPort-SDR: 0+wQSNjdx3JVnFWSsqdmRDTKLC0ZhThK89NoNnzKquc5N+zITdc1ysOk1bSyV27hpB61b4Ec0k
 7jqNj+P8//XA5zee/qnWDAFRe2QhN7ICxJqiWgVu06LLC7it9nVvQmjQ8PxysPhCj2AZUOYeAD
 Q3DZH2TsYPnn3wzZ/LllhgdkJ+VUuJgalTtOwnJeNB2jmgyfWLVyW00I42FRoVVHDlkQuHlt53
 Fyuv3JSUC+Q+sfnFmUwahjxWCSJvwCUO9rXSSKgxVNL74eixfu7jNd9V0B3a0+7E0GXe5U6u2w
 Olw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Nov 2022 15:31:19 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N2hSR3DMGz1Rwrq
        for <linux-scsi@vger.kernel.org>; Wed,  2 Nov 2022 15:31:19 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1667428279; x=1670020280; bh=wycN1ywsGVar2/HmuDfjKLByGk6bVQGXsup
        V97TH910=; b=Oeq/KnJeir6EiX+IsALaxEGkjw8gFaAM9zq47Gvl7O9SJgPdXnu
        HsJGDBJ6fdJs5rcxvSKYpdrBzAMXMZXjCQKDamMwyclQ7tUvJK5nL0C1uL/nyofQ
        mNbRHcx0M5yBdBjttk9KutVx1Y1wdCNGQQqqyLyV+hpLCpsvDS5N8mYj3bDpr5nm
        QQwUEs7AXl5ztfWrKj3MBTzVciUuZvkVhH/66J1MAFn0Sr31nuGoHppaOBeyiJ9X
        yDydzFHvpn8WXDEyO9pOdf5CTQmf14vWrtNnsWDo93tV373/S/9zwhq9T94SyXxU
        SecCqUGCj0cQ/gs0ZcoHNvkjF++m/PTEyzg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qIpuoglkTQEe for <linux-scsi@vger.kernel.org>;
        Wed,  2 Nov 2022 15:31:19 -0700 (PDT)
Received: from [10.225.163.24] (unknown [10.225.163.24])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N2hSQ2SkDz1RvLy;
        Wed,  2 Nov 2022 15:31:18 -0700 (PDT)
Message-ID: <5df5e86c-8d15-11e5-5ccb-bd739da2d60e@opensource.wdc.com>
Date:   Thu, 3 Nov 2022 07:31:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3] scsi: scsi_debug: Make the READ CAPACITY response
 compliant with ZBC
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
References: <20221102193248.3177608-1-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221102193248.3177608-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/22 04:32, Bart Van Assche wrote:
> From ZBC-1:
> * RC BASIS = 0: The RETURNED LOGICAL BLOCK ADDRESS field indicates the
>   highest LBA of a contiguous range of zones that are not sequential write
>   required zones starting with the first zone.
> * RC BASIS = 1: The RETURNED LOGICAL BLOCK ADDRESS field indicates the LBA
>   of the last logical block on the logical unit.
> 
> The current scsi_debug READ CAPACITY response does not comply with the above
> if there are one or more sequential write required zones. SCSI initiators
> need a way to retrieve the largest valid LBA from SCSI devices. Reporting
> the largest valid LBA if there are one or more sequential zones requires to
> set the RC BASIS field in the READ CAPACITY response to one. Hence this
> patch.
> 
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> Changes between v2 and v3: elaborated the comment added by this patch.
> 
> Changes between v1 and v2: simplified this patch as suggested by Damien.
> 
>  drivers/scsi/scsi_debug.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 697fc57bc711..629853662b82 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1899,6 +1899,13 @@ static int resp_readcap16(struct scsi_cmnd *scp,
>  			arr[14] |= 0x40;
>  	}
>  
> +	/*
> +	 * Since the scsi_debug READ CAPACITY implementation always reports the
> +	 * total disk capacity, set RC BASIS = 1 for host-managed ZBC devices.
> +	 */
> +	if (devip->zmodel == BLK_ZONED_HM)
> +		arr[12] |= 1 << 4;
> +
>  	arr[15] = sdebug_lowest_aligned & 0xff;
>  
>  	if (have_dif_prot) {

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

