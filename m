Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4EFC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 01:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344035AbhK0BGP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 20:06:15 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25822 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344257AbhK0BEO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 20:04:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637974861; x=1669510861;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5NdzGhyWLqSuyXUPp3yipZpIj0NWrYfZrWkdVCnTtw0=;
  b=FUMifaCaMLve1Ku9W1EER++I0Z6OotCMIJwLXMh3WjfBFTaXZ7remL2w
   b4bzICRjMILJd8utjPdDIcYeYm3LLYUpqo5R1TG8qjplxC+yRCXbO9GVZ
   nE+2nE+TQMKZ2o71f5cb+XiPRNMYpep25dko7Szms91/9xV1Fvh9g/Q41
   KbOhZzgRX4WMDVt72fTjd5J04INzie5puyDrt9kpfilM6PXUiVRdGqbTc
   iGRVY6AtoV37K00DEWbZxcklAeVqCET4FzFSW+z3v36miPU6rMlq+Ai1G
   Q6gac5UoritIxB6YZ2V0MLDblQj1rujDPAaMBmSKseQZ6cm7UUCY5DPgS
   w==;
X-IronPort-AV: E=Sophos;i="5.87,267,1631548800"; 
   d="scan'208";a="298621242"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2021 09:01:01 +0800
IronPort-SDR: dySmHeykyJoias1gV9bf9OpVUzevBjePRBi0rMt1MM7LzypHZqVqrF9sr70bhwVxuboy6Cq8MH
 1Parn4dgsOuVjCPvL0Fcylj0QVhEYy/zGYs2hp5oXNUQLYuGtMWwavYIXIeuddDNmBIvjSvfPD
 nzsFYtHS3zq5KwMJyviWz29ZlaOOdlluRvDntGEsU7z1ibrBmDAy/zjleTC3DtP35HH6lnGKeB
 /Q6FQovetSn/fBS6iuxn1rcwZ1U+dtG6Fi7nVLhNUrv1OG05P3DW1Dg4MI6rqeSteET35RV3UV
 z2vl1nUKz4tabLzjdc8WvdG7
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 16:34:18 -0800
IronPort-SDR: KHiwnA4ZSePJQXhI6+a1csiJLEYQyRkeUPUF24a/zpIr79n4E3eUuBXKlnDNwPp7JlTSxmrH89
 bev97A89oX4sQA5D4NDCBgFkOEjJLax5KAm2ItfPcnQxvu6brznnDI8ACi7klp1tSa6Ape1tum
 5k+q/jppD2LIDf5Jr5Gho5oMnHdYTIxNYij0uFEedcrfnDvf9THAwngJQaebGGvuEAwK9JnQkg
 vQhyVCgLGOoI0hpzXuIwviDyc+RYTFYzQN83XOuGPGCpe1iLAKW36ggUP5mjam4JW2jCph1bSs
 0rk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 17:01:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J1CwX1YCFz1RtVp
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 17:01:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637974859; x=1640566860; bh=5NdzGhyWLqSuyXUPp3yipZpIj0NWrYfZrWk
        dVCnTtw0=; b=F03gprLKE4QCXMw6qXE4vjieQNQRRlZRqe6X7hcbvPmzlwHNdCP
        Rrxzk1wWbxLrb2NEOuwsbpk2/+x1agIF1tqyXFhh1wLimnUh0IyCiB+YYpx8pywy
        n++5WgUYBXFj+1/SKtqkkFWIOL0F6kqoZPPP8y2pzRT8i46Y/03hHVv1LHcVmsAV
        Gwmem/jIV7ZGxoBD8NntK9mveRHkpFc6mIEcATyoaN2RQT3zC43LCdaLtkDqMoQG
        3Lx3BnY1xO9v5qL0+XxFvirjCFKZQL4L/upGpHZXkMcDQnHVS5VWnxVvRVAxisW3
        zphrXPh8ZLAKuUiSX1IWsRKO+aT2Ro3sp4A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1Y2AYtUaflqi for <linux-scsi@vger.kernel.org>;
        Fri, 26 Nov 2021 17:00:59 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J1CwW0hWTz1RtVl;
        Fri, 26 Nov 2021 17:00:58 -0800 (PST)
Message-ID: <9172d395-29d0-6b1a-4be7-8968bfac6762@opensource.wdc.com>
Date:   Sat, 27 Nov 2021 10:00:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH 1/2] scsi: sd_zbc: Compare against block layer enum values
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/26 21:55, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> sd_zbc_parse_report() fills in a struct blk_zone, which is the block layer
> representation of a zone. This struct is also what will be copied to user
> for a BLKREPORTZONE ioctl.
> 
> Since sd_zbc_parse_report() compares against zone.type and zone.cond, which
> are members of a struct blk_zone, the correct enum values to compare
> against are the enum values defined by the block layer.
> 
> These specific enum values for ZBC and the block layer happen to have the
> same enum constants, but they could theoretically have been different.
> 
> Compare against the block layer enum values, to make it more obvious that
> struct blk_zone is the block layer representation of a zone, and not the
> SCSI/ZBC representation of a zone.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  drivers/scsi/sd_zbc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index ed06798983f8..024f1bec6e5a 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -62,8 +62,8 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
>  	zone.capacity = zone.len;
>  	zone.start = logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
>  	zone.wp = logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
> -	if (zone.type != ZBC_ZONE_TYPE_CONV &&
> -	    zone.cond == ZBC_ZONE_COND_FULL)
> +	if (zone.type != BLK_ZONE_TYPE_CONVENTIONAL &&
> +	    zone.cond == BLK_ZONE_COND_FULL)
>  		zone.wp = zone.start + zone.len;

For the sake of avoiding layering violation, I would keep the code as is, unles
Martin and James are OK with this ?

A more sensible patch may be to add a static checking that all BLK_ZONE_COND_*
and BLK_ZONE_TYPE_* enum values are equal to the ZBC defined values in
include/scsi/scsi_proto.h (ZBC_ZONE_COND_* and ZBC_ZONE_TYPE_* macros).


-- 
Damien Le Moal
Western Digital Research
