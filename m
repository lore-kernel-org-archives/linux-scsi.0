Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57818C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 05:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKIFRN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 00:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKIFRN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 00:17:13 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3051B9C4
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 21:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667971032; x=1699507032;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IoL2UyxtK73iwNO1e6iz3YiHDhUZiwtpPQNe1nrPnpo=;
  b=nUHu6cpX39tzJ+uINvGt+5/puAZiftSCAXdxWHYdEcXxXlzMjuneiCNg
   zRZU24iTm7DD+QI7/XnD+M6d6641+MnAMU9/XZcSKtVg0KUns+b7ueHk+
   f36vTAQd3u+HUjgi6Ux7DFXqkC43QhK/TB0nrYcKeyYO8KouowwLOTYpq
   9068uQfi3WMxeOgH8kbPaKVHDOzP/Dddb7MkafaZ6Pj6AwIisnQK38/Zz
   dxLa9ImB58DIMAfOcx8BcPMTh8VYAsQqv4HrtzUSX/elKes3WFE88ufWA
   /MYb1MGKXkgR3NgCCpXyM/34vy6DzyIgzQpxmpgBpqfeeyy5Dcr+BCMcM
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,149,1665417600"; 
   d="scan'208";a="327928347"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 13:17:11 +0800
IronPort-SDR: vGrgTGo2r+DDNWVCITbTye52u1bzwCX9CI+r8VR4Kt9vL/+PFwh1z2H7AqJU3TCBYPTYpPFHBK
 n5LxoI56UGZEM29ja8heOLFzkaaeH3CeLDCsGD5S+3xosbX4GA/wq9uVHu/z55kR4EVoNzM+ii
 VSPMy2fCG7SQISezeBRDIALByMJSEGUXwV6ObmOKF8Mf51cbgZfUZRXVXSXTh6ARX+A7T9MkO0
 0O1mW66wTbfvJfAIfMT0Ng4w/VULVLTj2+i77JuTWcWBKgY6rdznuT6zqOsmpIplaDMlG/LVVG
 YCE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 20:30:32 -0800
IronPort-SDR: dOmFllC+4gaKhkjjpverMSUoJibWXnroRUHNI6S5IQR+uPzUG9nVUgM6+Mx38zlorOpwfQCJiv
 l6d5ka3CjkWkiAOJmlRNX4Zv121AGKIwaR5hnWgHCAllshwCnR8B3M6uEykiv0QbV7tQMWIrj7
 Apw/QWEGfEcUg5wCAlfy7ManPhXPQuB7vj6rLwh9mw6SJOTNFAtwOqRdww2D5pDXmduq2y+GX6
 mg3eA2HWzv1pij1PIH6c2i6mfDzvvPKP3NA2yoeiLNXcGLtUjwIKgEvx8faROA3uiPEosadPv2
 X3U=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 21:17:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N6Y9y1flNz1Rwrq
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 21:17:10 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1667971029; x=1670563030; bh=IoL2UyxtK73iwNO1e6iz3YiHDhUZiwtpPQN
        e1nrPnpo=; b=ppa2Zu18dqxw10NQGhYE3JWlDXt/Ud7tZ2bazq54vp/pcCllObc
        nrs05JHojuMtLT9FkHKjInOKWqX/dGRrPM9WcS4gfmVZ0SCYf34gZyEwRya3exSN
        gFJFo/t0gWJyl7KFxgs5wbkEbJYM0NBPB33QVkBCConfMcVK5qR/jhPO43eW/dnE
        vT/+BFMxlDIuWp7M2ttpMgZgg7N3GAQeZk464MqWtr2MstCNVoOVcZ50OyGMKGNs
        JMxZK9ViMFMSgrnhGQBNGzRA7mCLldfPJvtihUVMI0jgoGvxpf3gIV+mO95rXkE2
        J6tAbgaTikP4GoWpupSdP88Uye66ITlodCQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KcPFbDOAnQnj for <linux-scsi@vger.kernel.org>;
        Tue,  8 Nov 2022 21:17:09 -0800 (PST)
Received: from [10.225.163.37] (unknown [10.225.163.37])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N6Y9x0zVqz1RvLy;
        Tue,  8 Nov 2022 21:17:08 -0800 (PST)
Message-ID: <6c0c6bfc-64d5-b822-e438-57e1e1d8b7f9@opensource.wdc.com>
Date:   Wed, 9 Nov 2022 14:17:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 1/2] scsi: sd_zbc: do not enforce READ/WRITE (16) on
 host-aware devices
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
References: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
 <20221109025941.1594612-2-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221109025941.1594612-2-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 11:59, Shin'ichiro Kawasaki wrote:
> ZBC Zoned Block Commands specification mandates READ (16) and WRITE (16)
> commands only for host-managed zoned block devices. It does not mandate
> the commands for host-aware zoned block devices. However, current
> sd_zbc_read_zones() code assumes the commands were mandated for host-
> aware devices also and enforces the commands. If the host-aware drives
> do not support the commands, they may fail.
> 
> To conform to the ZBC specification and to avoid the failure, check
> device type and modify use_16_for_rw and use_10_for_rw flags only for
> host-managed zoned block devices, so that the READ (16) and WRITE (16)
> commands are not enforced on host-aware zoned block devices.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/sd_zbc.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index bd15624c6322..4717a55dbf35 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -921,9 +921,11 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
>  		return 0;
>  	}
>  
> -	/* READ16/WRITE16 is mandatory for ZBC disks */
> -	sdkp->device->use_16_for_rw = 1;
> -	sdkp->device->use_10_for_rw = 0;
> +	/* READ16/WRITE16 is mandatory for host-managed devices */
> +	if (sdkp->device->type == TYPE_ZBC) {
> +		sdkp->device->use_16_for_rw = 1;
> +		sdkp->device->use_10_for_rw = 0;
> +	}
>  
>  	if (!blk_queue_is_zoned(q)) {
>  		/*

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

