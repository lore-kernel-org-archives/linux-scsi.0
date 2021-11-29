Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C49C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 22:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbhK2Wqd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 17:46:33 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57761 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbhK2Wp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 17:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638225760; x=1669761760;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xQDU90aNRdvcs2omB6XNeDvq/8JOV0Ih+h3qHHnnobo=;
  b=PIeUBHtyzl8IM+lfK7sP3O2+m5Iv52iuz8JGljfj7nRP9zEGY/n+VKC2
   AbKUdRefGGvrVsir1n071O30fjwKgVAbhcEvsaw2zz/am6+UQsawT2Afg
   4+2uRlh0CcNcCMZIaj3RJt7GlIxMpVeQDTtWorf+dJYWF7u1pOPlUag9o
   2GEJ73oCIP3MRYe//WIi5K4wb7fQgBwRXnH3ru3Gqap7g8jy/vKtaRE4D
   kvQQVZhjQDrONivxowomQxCg7TV9meyvV9hG+xvBTQJKheGl4B8TD7eJJ
   9DFFku1LKXuxlGQtdRHCoFAlL7QJ1UFP+S5g8T8Rve4Qsl8Kl11ED10Tg
   g==;
X-IronPort-AV: E=Sophos;i="5.87,273,1631548800"; 
   d="scan'208";a="290952947"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2021 06:42:39 +0800
IronPort-SDR: LX3Oq3qoC5xHczWaeqW7HATUXUGZusX6Pfk2ASeDVs96ub8oUHQKmjCohllB5PScJ4CR+w2sUC
 MyVwiUNCSArK0Orfd29hJVKUWfV2rsLud9y2BxpXS/5pr+tjfFX4+G9BPzMrqQAK9zp7a5kO7O
 aAGj6+H1dwPY94lL9FthfcF2EYrSL9Z9ysKFse3FpNwABMSIH87SBnLDbUysnUTAY1ixukmYlk
 3F46mhA/VlKXWwyvEBWgOkycuZq19RTpJeyG6Npbo+4Qfcn/HIs7byauO1RgG0R8xlfkDqUyCv
 /e9JD1Iu5td5f4tcbR2kMeCC
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 14:15:53 -0800
IronPort-SDR: TO7PX6X1ElARHizcp27cSZo4GomOAZVKuGGUPcvMDxFqtgf7HT/rfey/PO5Y8oQiGJrnIbcjGh
 dffYjRPPIfEcIxmMjkeYzeKupAsadLrUWbRXG2Q79JMryKQVBYYow5P4Q1pWT/+CK+gAWal9e6
 Cfy9fZJpzflYl29YmOq2+gKasAKfGc4eA1GcMWzJkO1CKt9lSKsX5/QzM2q2rUaV2TMtf0gLLT
 +2C3iQZQrOpumqLStIIXUc0AP3SrzYzW/SVNYzXE04Icjjc9PHQP+jfamHLTnL9KZKHtTDarmY
 5ng=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 14:36:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J30Zb330sz1RtVp
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 14:36:39 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1638225399; x=1640817400; bh=xQDU90aNRdvcs2omB6XNeDvq/8JOV0Ih+h3
        qHHnnobo=; b=Ejtngr52Nt1EKueqJUxHcBi45y5hMzka9d75NdgMjFL0yUi1zar
        V5hWofUUBh9ZSCSOcBjZn9BTjj0mS9Kz/XPrMuPbTZPEwh4OTSU9IgwcJDRZCFtg
        GVDzHlR7mYAVRahJciTw2TrbFRElGZgfPWUM/tuABr1iM3lUFRh13HbOcpbmhuqy
        1051UeaRcTowiDETnohNFLlbzfVOz2Xoc+XsLQIqwuAoT2AC9o/Von6bCWh+dura
        WCqcc2owUqnP6Hf5DWQK2KLWUHmo4l5SyJJP02Wg7vYoyQkAvwyAiJNsUMdtZTed
        5WAfaAms5h3wUjufiAzQ6utduUyXWvURc+w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 08DD0tC2Mob1 for <linux-scsi@vger.kernel.org>;
        Mon, 29 Nov 2021 14:36:39 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J30ZZ17cFz1RtVl;
        Mon, 29 Nov 2021 14:36:37 -0800 (PST)
Message-ID: <f262862a-ba14-eeba-8202-6ec20390eb50@opensource.wdc.com>
Date:   Tue, 30 Nov 2021 07:36:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v2] scsi: sd_zbc: Clean up sd_zbc_parse_report() setting
 of wp
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211129131508.350058-1-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211129131508.350058-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/29 22:15, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Make sd_zbc_parse_report() use if/else when setting the write pointer,
> instead of setting it unconditionally and then conditionally updating it.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes since V2:
> -Picked up Johannes' tag.
> -Dropped patch 1/2 from the series. The actual +/- lines of this patch is
>  unchanged.
> 
>  drivers/scsi/sd_zbc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index ed06798983f8..20e849437687 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -61,10 +61,11 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
>  	zone.len = logical_to_sectors(sdp, get_unaligned_be64(&buf[8]));
>  	zone.capacity = zone.len;
>  	zone.start = logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
> -	zone.wp = logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
>  	if (zone.type != ZBC_ZONE_TYPE_CONV &&
>  	    zone.cond == ZBC_ZONE_COND_FULL)

Actually, thinking about this test again, I think we should simplify it to:

	if (zone.cond == ZBC_ZONE_COND_FULL)

since conventional zones always have the condition ZBC_ZONE_COND_NO_WP, checking
the zone type is useless.

With that changed, feel free to add:

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

>  		zone.wp = zone.start + zone.len;
> +	else
> +		zone.wp = logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
>  
>  	ret = cb(&zone, idx, data);
>  	if (ret)
> 



-- 
Damien Le Moal
Western Digital Research
