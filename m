Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF36FA3743
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Nov 2022 03:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiKADXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 23:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiKADXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 23:23:44 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3B8FD6
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 20:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667273023; x=1698809023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DaR/ZcWntu84lPSiKt0Y8CxwdfWVhid67mS6ok5wTGc=;
  b=mH9Y1t0mWaaaGoQumjizPLs0QxFrPFY0aZid2UN6rtYjy6hKj2WUU+AO
   JfA1/joDUcp9LNzQOjRgJO8NDjcEMZbV2z2pcrm9jB/uGkh4MUQxVX4V2
   wcQ+WioS9dnCGwELJHcxTDh0wNVKKwITLf/938lBWt4JbiJiak5CA7oN7
   am3hEkMvMPl8VkzsA0kil1ApdRD+kfW0K2HDUJn6nFuqf1bHIIsmztKuw
   bfySmdoKpudmzZz4BmUU+IttCab8IS5kmUwSf/t0WUOmvYnLU7ALSi99q
   G86lh/LgviqYNB9VraHkn3cW20EEzFMryRYp4vd9uJqUgTo2eTWjn5KTP
   g==;
X-IronPort-AV: E=Sophos;i="5.95,229,1661788800"; 
   d="scan'208";a="213479351"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Nov 2022 11:23:42 +0800
IronPort-SDR: SFAlL3lWInQIb6SKVuCdi7EqodRArPPvSeuc5KK8S1USq6yM7mKR9pmzFxixShoHe7Z+x2k6w1
 8sG0NuWP+khwXzWSxNMy0W/kPuUcT6CemiRfcl0ObMe9bk40CnMdGs2bcohret0sc0raipmsYn
 O155VOueRRRgo3/IrxD/+2UXEdPg5IlfqyQkDyw3CH5SZfBWFp0SbALdM3FC5dMSWJ7MrenSjP
 EfwvgeQ7RgBaGQ/vzPq6zMTlMiNWy4Wc+Cr90UyevfroMWR3tpls2pa3TpqXvXkTI30aeMgW9L
 nT6TwGnXPtln4CackpoDAnPd
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Oct 2022 19:42:57 -0700
IronPort-SDR: J+TJx6o1nlkt5/bzrhZlK1K+tYOi3/gSxNXduc1rAWE44TXdOAqlu4gH5vckmt/+pZx1RbcxTm
 d1v2au4xCZg+05aQijVZ0q57syRGuv7mXU2txhwFjxKsR9/pvbgBOTKY2UFB+5Ylnihug3fKuT
 JDarPInUQrf/bNaDWBo4HB0TsDuPDCXx8/hOyd1Yzrq31Vzh9IDOxxHXuowO7BS9gA3gBtOsdM
 2+K982mUfiH0yunMJb6Jdzw8Y9YeYAe2QtcUc5/VHFxm18Y2yN8XnKDqrINCKe7HmfBA0KsQrE
 W8I=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Oct 2022 20:23:41 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N1b2j4G9yz1RvTr
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 20:23:41 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1667273021; x=1669865022; bh=DaR/ZcWntu84lPSiKt0Y8CxwdfWVhid67mS
        6ok5wTGc=; b=NwsXCxnLPhv5AU/yrFvyTsYHcNCBs0zbw4tlijYRlpM2fe8ysC0
        VcrgJ0iaH9vS2Q9zy6KtIz3O5R0yzV61rF9vAdqm1XZuWTetWC4BWrItAXbTSm73
        DUZfg9s6mCL+twlKe8nGut4DJFJrDQlQLEEzkE7AlucGPCKTC4GZ+0j89m0vjuIS
        t25O/f7bPEig/WuI/QoGdrLxexwF7K1B4aKzsUSDD+RiqwjWYzzDeCtXrh7B2JTf
        x+krjY9e2RsLw2ImZGfQRe2fxTj3FzDpRe7H3i806rnSH0VySYfV5ZrrOJ2/rn1H
        0Acwnrsw4sBFpBbdD/Wxy/Cj1+wWxEXlKlw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 24R26NafCPak for <linux-scsi@vger.kernel.org>;
        Mon, 31 Oct 2022 20:23:41 -0700 (PDT)
Received: from [10.225.163.24] (unknown [10.225.163.24])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N1b2h3DG6z1RvLy;
        Mon, 31 Oct 2022 20:23:40 -0700 (PDT)
Message-ID: <af9b39f5-037f-5dea-8c14-0e020e275b9a@opensource.wdc.com>
Date:   Tue, 1 Nov 2022 12:23:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] scsi: scsi_debug: Make the READ CAPACITY response
 compliant with ZBC
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
References: <20221031224755.2607812-1-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221031224755.2607812-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/22 07:47, Bart Van Assche wrote:
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
>  drivers/scsi/scsi_debug.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 697fc57bc711..fec87296cf06 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1899,6 +1899,10 @@ static int resp_readcap16(struct scsi_cmnd *scp,
>  			arr[14] |= 0x40;
>  	}
>  
> +	/* Set RC BASIS = 1 for host-managed devices. */

No it is not necessarily set. It is up to the device vendor to choose if
RC_BASIS is set or not, based on the device implementation.
Applicability of RC = 0 or RC = 1 depends on the presence of conventional
zones. so:

1) If there are conventional zones, then using RC_BASIS = 1 or = 0 are
both OK with HM devices. In the case of RC_BASIS = 0, the host can issue a
report zones and get the device max lba from the report header (sd_zbc.c
does that).
2) If there are no conventional zones, then using RC_BASIS = 0 does not
make much sense, but nothing in the ZBC text prevent it either...

So we should refine this and maybe add an option to allow specifying rc
basis ?

> +	if (devip->zmodel == BLK_ZONED_HM)
> +		arr[12] |= 1 << 4;
> +
>  	arr[15] = sdebug_lowest_aligned & 0xff;
>  
>  	if (have_dif_prot) {

-- 
Damien Le Moal
Western Digital Research

