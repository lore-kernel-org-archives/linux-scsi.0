Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FE0C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Oct 2022 03:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiJMDyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Oct 2022 23:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJMDyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2022 23:54:49 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FF11ADB5
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2022 20:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665633287; x=1697169287;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bGW7TFvymg2sARnBD1Vdb1YQ+YDQm45TRkn/b/R2j6I=;
  b=UDmKsHC1b1iifUkokcNloHuXKcOwjBjO5tWaNkjMUuHbU1gVsR7+mDaV
   uubxGsSUdtcGTSFU8M7VFhB/jNTSWYfZ/APXEnC3qIw/AseYviXJ2RO6w
   /epWIgcTcRVIBoh++5du0pW871D+DD5E7Az2jUr12T678tDp5iethvOZL
   anoRESoh3e5ZH1/SvVWsYEO82sm1KvelEQt1MJlZYJZyZXoPFV2TZ6bMX
   RgrIhYQgDc+CUVgumOUiw8Gmv8nh9M6QLUvY91qARSUf3W3tAWY5oUCdQ
   TTSN7U5jS4FfUDmhzv8z6ukDsxI56gt8f8CK/R1BiR2umgrzSmTlhymNG
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,180,1661788800"; 
   d="scan'208";a="214061891"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2022 11:54:44 +0800
IronPort-SDR: sVpd6g7MZzlwE2vc7hyk8DzYrMndaFv24Vo5zDK5VpOn64hbqKuUmrR5n8CVQh5fL/t5ReMpU7
 1PMQLnj3Gk0s3iwn06s95tmsjkb4XZxyzS2u8Er3b5OcIoGXwra298ssSaN4zYAZmI8VYcKnLN
 HRWTGyQwj6Qc/WCIy9q2iaXuVWfuDSrJp/GkGiE4PD2aQg9EOuZTYStwVQcxLy18JXvVmebkhs
 cuUbV0BzMSTaA9NfOF5xAI+zotJ6YOHv0px3JsUkoE6VpIZO7ciiwMR6A1aQaUmCt0o+kSukhY
 GaQWzUrF/kWULuBYLvjLn6qe
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Oct 2022 20:08:45 -0700
IronPort-SDR: Nb+6jHrRJgjt8TGOcQ3CidTKx+3p3e2cheUuv1h3qFa7XYOYBNgxgRS80wtJvkL7JTl64CPVg4
 D3x7Qkq6wHTI+yzcQZikHTgUUl7xZtToxj2gNyvPL1uNoG8uBFqdNhp5IWGidCjHTPYjF8RGTF
 CPRruumWWme0YwqLPOJWRdRIV3hZ9IeucV07OydCTaDC3YXs9yh3lUALmtlVUok1WuD5wrtLPJ
 RxuAxLxwfoAkgcGa+Hfg1/fAhy/A7UEt/CeKjiylGttGBq4TnCCSTC0YG+LQtWAmDgOFEd9LFY
 uVk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Oct 2022 20:54:44 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MnwdH6Bslz1Rwt8
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2022 20:54:43 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1665633283; x=1668225284; bh=bGW7TFvymg2sARnBD1Vdb1YQ+YDQm45TRkn
        /b/R2j6I=; b=JAwzwSjgv4pDEzuiFW9aw2f/J4tekZSFz0G5B+klHX0GKbXhxyh
        7M6kLafUSBxAnittZfANuWsgxVAjrd1EbH5kLQx1sA/eEJtb4CmomXc9izhQTgRc
        Cg/YA4T2c9k8gxgCWIF6jEuxt+0bHjbFn4YiJMElADB6cqK9igcOWqqd34pqob/V
        NDSWFmzOZf7Tqa0NaKDcKoUwyqxgw8hLAwqUCvXlNrEdt6eoSvEa5cHxd98Us2ho
        JsmBChTvZLd/IRWC/qsflKhUfOcwt57KpLsoauZ5Rxyv7tJlXpqowjW7mVC2WNZo
        efDxh4AZ8gRqxiURcrenDp8urmvmN29q56g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Oygjx_KIdsmy for <linux-scsi@vger.kernel.org>;
        Wed, 12 Oct 2022 20:54:43 -0700 (PDT)
Received: from [10.89.85.169] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.85.169])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MnwdG2q13z1RvLy;
        Wed, 12 Oct 2022 20:54:42 -0700 (PDT)
Message-ID: <0e67aa4d-f66e-f392-5950-31b1c90c287b@opensource.wdc.com>
Date:   Thu, 13 Oct 2022 12:54:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 4.19] scsi: sd: Fix 'sdkp' in sd_first_printk
Content-Language: en-US
To:     Li kunyu <kunyu@nfschina.com>, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221013023438.3263-1-kunyu@nfschina.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221013023438.3263-1-kunyu@nfschina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/10/13 11:34, Li kunyu wrote:
> In the sd_first_printk macro, replace the sdkp parameter with the
> defined sdsk parameter to resolve the compilation error.

Which compilation errors ? None that I can see.
Do you mean "to avoid potential compilation errors" ?

> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---
>  drivers/scsi/sd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index a7d4f50b67d4..e5bdf0a10071 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -133,7 +133,7 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
>  
>  #define sd_first_printk(prefix, sdsk, fmt, a...)			\
>  	do {								\
> -		if ((sdkp)->first_scan)					\
> +		if ((sdsk)->first_scan)					\

Instead of changing this one, I would prefer changing sdsk to sdkp in the macro
parameter list. "sdkp" is used everywhere in sd.c. "sdsk" is not used anywhere
so it would be unclear.

>  			sd_printk(prefix, sdsk, fmt, ##a);		\
>  	} while (0)
>  

-- 
Damien Le Moal
Western Digital Research

