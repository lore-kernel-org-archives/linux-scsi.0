Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34F7C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Dec 2021 13:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244133AbhLFNjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 08:39:19 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:42046 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbhLFNjQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 08:39:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638797745; x=1670333745;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PCUK/MK1/+6JuYZ4qaxTq3y0IfDzZp42enRu8LX9wOQ=;
  b=CRKwTcejoxUvixPmkz81HTghqxEYL1EcLm34N8Td88R5tu3Nle+Ng1ST
   nQOYSGgTZoBnKAO5B2lb6ApvS102hhIFM7uDjwk+l9CHtBS47xEM10wE3
   8r0DGTImiMw5iDAYAeEPDerblggGM7T7zE8EXvFUSxKvuiy0ghw2pKnZs
   kZsVBzbMBDU1jWd5OK1f9icCmW4I6Ulsi5LNUx0ZxCM0VeLo1Ml9oslSH
   T2tk51m5FAC+2wjvZTcb1a5GHlwGWw1mhIKTmzU9Qgl8TNazWsPxFw6Ia
   DAiDzBthVTi5SGR23u2XHk+cqvUVEgAicj1fQyhertrOJ/6oGFsv4gyoF
   w==;
X-IronPort-AV: E=Sophos;i="5.87,291,1631548800"; 
   d="scan'208";a="187562221"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Dec 2021 21:35:45 +0800
IronPort-SDR: 4XZbq6ZBs724gmEKWCOTNCjJRnHDoiFcpgM4/8ZLm8rmYofMVl2jyeGIVU21InMGNNutaLiekw
 P4eJLBtq8+MEuWg2Sp3J1d7NgEPeOsv9R5sCkP8kHotgIUkGv3XWhjzCDTsAEs1gsQT89TeJPd
 LdeM5zdPpJ1fPcmURK5iAG8DAN7OzgKGHcU36v4grUjpt0gGtXmtYh6FzF2XkJKBxczKSZZ+t8
 39seszLhKIigtgI41jF645/znShE4GlP62bnwVUCVyS2GgKurRCI9BR9rekG6WFGGRigfx0Htn
 pvBceCKukSV22tzuxCZGUv4J
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 05:10:25 -0800
IronPort-SDR: QADAnSgh9+iFZY0rUoNofhMxQfeg1ouIT5e3r1HkTamElOQG4dDcrBlfFm8Gj8+aMxyUv5VBNe
 MY2rVFHp+BmPOleBTWVEOR85DlX+WODhy0aBd31mfNJXV1gTVdEfmf5V6GMSuTiMt9sSj3L+on
 6alwBkv582ICcodGOO44ygwGpVaKUda9JOkc6y4tAQaYAO8ae6UQKLXsULeUpQ6uoC+D47xsoI
 JrSS/7dfocvNo8zZXtjgURq4eyZsQznJq84/VnzTO4H250CPHSzvgyDIO5UYzLPOD2viv6XaY3
 g5M=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 05:35:48 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J74FH2jxlz1Rwns
        for <linux-scsi@vger.kernel.org>; Mon,  6 Dec 2021 05:35:47 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1638797747; x=1641389748; bh=PCUK/MK1/+6JuYZ4qaxTq3y0IfDzZp42enR
        u8LX9wOQ=; b=ldsj/COJbnudeObRXiYfu/BeEBUtubMR8QRgnbYukwx6r3qUhKa
        Yz55eT9iDSnF2jQqQJhGECoCxrUobnnM9SIkazuMbFlNNT1NXCs/G4QhPrpOdSRv
        cDu39/P/J85lHY5EhxozQY1ViGNsUco3hHpq271E3KIqre97TQj77BVNR2yeB8Vp
        irp7ESxefv80o2FB3NuxxGGnR/Rtb4hhm9bnrCxrjM485FkRSKU4Wts6uPerDFMK
        isLqVEzCJkholt+m/rtStXJxDggmDvguFRbFhPdEfxTNweozMJsv8d4hHX/7pJC1
        ePBBhePAuSEUerbFnepAzus5mvSdxaFVaRw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tyAa-gbvlycU for <linux-scsi@vger.kernel.org>;
        Mon,  6 Dec 2021 05:35:47 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J74FG2RKSz1RtVG;
        Mon,  6 Dec 2021 05:35:46 -0800 (PST)
Message-ID: <bba4768e-b96d-1f04-5de8-b87264342fdc@opensource.wdc.com>
Date:   Mon, 6 Dec 2021 22:35:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] scsi: scsi_debug: Fix buffer size of REPORT ZONES command
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
References: <20211206122939.105942-1-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211206122939.105942-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/12/06 21:29, Shin'ichiro Kawasaki wrote:
> According to ZBC and SPC specifications, the unit of ALLOCATION LENGTH
> field of REPORT ZONES command is byte. However, current scsi_debug
> implementation handles it as number of zones to calculate buffer size to
> report zones. When the ALLOCATION LENGTH has a large number, this
> results in too large buffer size and causes memory allocation failure.
> Fix the failure by handling ALLOCATION LENGTH as byte unit.
> 
> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/scsi_debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 3c0da3770edf..74513129b36d 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4342,7 +4342,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>  	rep_max_zones = min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
>  			    max_zones);
>  
> -	arr = kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
> +	arr = kcalloc(1, alloc_len, GFP_ATOMIC);

Then maybe use kzalloc here ? No need for kcalloc...

>  	if (!arr) {
>  		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>  				INSUFF_RES_ASCQ);
> 


-- 
Damien Le Moal
Western Digital Research
