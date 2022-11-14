Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEF9C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Nov 2022 11:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiKNLll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Nov 2022 06:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiKNLlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2022 06:41:39 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD6755A3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2022 03:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668426098; x=1699962098;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S4uW1Zo1T6wWO4jPJiSBayzCQ9M2fgQ259lnn6ddu0s=;
  b=g6xEbENGszVxpey7oG9t1e6KUqJHLAPIUp+jbgDePXWmaB4fGfkC6C7Z
   hAv7zD3ANANmmDIpzGiV5j8kuwiOeDX3k9VMLH6iaOTHQORY+yiLn8yEl
   oA+RJw7nubzo/4TMRsv8jVDpCeRqUtT3ldUyRiZovdVf+z5NJJQoE7rby
   npikeNsUH7Vlf7YiI209CnSwMJtIHK7VeHUISOdOWhnLvxK+treT3RC33
   KfAl+WgXxLIWYFjRENKRMOhm4hAaM9TpVSW/V5ntqg/zstzxl9QwWBA4J
   msCW2dqGDepOHU2/hosHDrs6i4kV1QTxabDFMyuXsy2eSq4gB/ILueGYO
   A==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="216544777"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 19:41:37 +0800
IronPort-SDR: Rg4wjzqZq9rslH59nqOu9AiD7/qjmKffs2j+uvC1Ao2Jc8iUED+J9vHRyEzPvDZQ+ASgt5/IuP
 Moz0oKdYW6r0JxGby+c0mhvAAGKfErOHJAX0iCy0g/Pxngycdz/qRx7UVGJPw6R4sg413bd5KF
 fBiluobIXDV1BYsVlJoSdcSFE8+dztVjgMmT3pIil+0icSsFy9ZAZFWYEF+r9SVux8jqn+vFZ6
 KskvzvDPPOqfb9L3y0FkTI3+4Kul1nZP50p4PH9JW3GEyIxEuGmAK9ydlCZf+ReEz21YgxsPsQ
 PsA=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Nov 2022 02:54:51 -0800
IronPort-SDR: rZ7dW/op1+EssvsrounKgc5rngcp0ljBKG78wTlmWuJVf7coLFudXQQ8RHxi8ZxCONteK6NuCJ
 vHOPiOmNmqV1iE8Rjvcb5q0OG9j8GYk+wzZgmcUDgssseoOEdaegIQen6D/fU78G8r5sArPUXr
 aJzeS9fll+0w0IKWJO8QFHzWzJ3uPuD1IbvALSTf3WlJK0wjvA2oL4d3irgOKAtOL+lto1SMpJ
 ScuGHEPC/KSYQ96iQuuzK/s25zw2qP5UWLw0TljFpV22Fcrem3g0ydqh8LB6jzwKGq46TyEsqm
 3hg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Nov 2022 03:41:38 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N9nTF54tPz1RwqL
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2022 03:41:37 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1668426097; x=1671018098; bh=S4uW1Zo1T6wWO4jPJiSBayzCQ9M2fgQ259l
        nn6ddu0s=; b=GhwB22F9MQJrZKubJUc1GlgvHSXouktCZvg3ol2qygXmhMFlpX8
        Nc/o50P4CKg19COTkw0UnldkyPKLvgaSASZcnFqoEy37JsIK6gH7kTqNdRoDJbea
        bCTVTUE9VLV44pt673aiGYRhTG92Uw9fF33ghacR9kSCw00yYOhtByz3UJUvv9MI
        oak10vEampZxJVsI/+lIhfKA8cbX3aIFdrb5xJx+2MY2LPfaX3mFku6NNgAcQjus
        vKXfCi85+enXER9m+zQVdNL6mTYrb5OALgJ5Ap8vRk3/Gq8BvuyT/UkB4Fx+VoMh
        BfED2RuMM8yNJgrrBMzgMv+viqEFC9NjdRQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fUu4OHO84uzs for <linux-scsi@vger.kernel.org>;
        Mon, 14 Nov 2022 03:41:37 -0800 (PST)
Received: from [10.225.163.46] (unknown [10.225.163.46])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N9nTD3VSzz1RvLy;
        Mon, 14 Nov 2022 03:41:36 -0800 (PST)
Message-ID: <d31f033d-73ff-091f-ab3d-054c72359531@opensource.wdc.com>
Date:   Mon, 14 Nov 2022 20:41:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] scsi: sd_zbc: trace zone append emulation
Content-Language: en-US
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
References: <278ba0682187eae377f39f2c6646706c388df17b.1668415091.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <278ba0682187eae377f39f2c6646706c388df17b.1668415091.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/22 20:22, Johannes Thumshirn wrote:
> Add tracepoints to the SCSI zone append emulation, in order to trace the
> zone start to write-pointer aligned LBA translation and the corresponding
> completion.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

2 nits below. Otherwise, looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/sd_zbc.c       |  5 +++
>  include/trace/events/scsi.h | 64 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index bd15624c6322..956d1982c51b 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -18,6 +18,8 @@
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
>  
> +#include <trace/events/scsi.h>
> +
>  #include "sd.h"
>  
>  /**
> @@ -450,6 +452,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
>  			break;
>  		}
>  
> +		trace_scsi_prepare_zone_append(cmd, *lba, wp_offset);
>  		*lba += wp_offset;
>  	}
>  	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
> @@ -558,6 +561,8 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
>  
>  	switch (op) {
>  	case REQ_OP_ZONE_APPEND:
> +		trace_scsi_zone_wp_update(cmd, rq->__sector,
> +				  sdkp->zones_wp_offset[zno], good_bytes);
>  		rq->__sector += sdkp->zones_wp_offset[zno];
>  		fallthrough;
>  	case REQ_OP_WRITE_ZEROES:
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index a2c7befd451a..50d36aa417cc 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -327,6 +327,70 @@ TRACE_EVENT(scsi_eh_wakeup,
>  	TP_printk("host_no=%u", __entry->host_no)
>  );
>  
> +TRACE_EVENT(scsi_prepare_zone_append,
> +
> +	    TP_PROTO(struct scsi_cmnd *cmnd, sector_t lba,
> +		     unsigned int wp_offset),
> +
> +	    TP_ARGS(cmnd, lba, wp_offset),
> +
> +	    TP_STRUCT__entry(
> +		     __field( unsigned int, host_no )
> +		     __field( unsigned int, channel )
> +		     __field( unsigned int, id )
> +		     __field( unsigned int, lun )
> +		     __field( sector_t, lba )

Why not align "lba" with the other fields ?

> +		     __field( unsigned int, wp_offset)

missing space before ")" (since that seems to be the style convention in
that file.

> +	    ),
> +
> +	    TP_fast_assign(
> +		__entry->host_no	= cmnd->device->host->host_no;
> +		__entry->channel	= cmnd->device->channel;
> +		__entry->id		= cmnd->device->id;
> +		__entry->lun		= cmnd->device->lun;
> +		__entry->lba		= lba;
> +		__entry->wp_offset	= wp_offset;
> +	    ),
> +
> +	    TP_printk("host_no=%u, channel=%u id=%u lun=%u lba=%llu wp_offset=%u",
> +		      __entry->host_no, __entry->channel, __entry->id,
> +		      __entry->lun, __entry->lba, __entry->wp_offset)
> +);
> +
> +TRACE_EVENT(scsi_zone_wp_update,
> +
> +	    TP_PROTO(struct scsi_cmnd *cmnd, sector_t rq_sector,
> +		     unsigned int wp_offset, unsigned int good_bytes),
> +
> +	    TP_ARGS(cmnd, rq_sector, wp_offset, good_bytes),
> +
> +	    TP_STRUCT__entry(
> +		     __field( unsigned int, host_no )
> +		     __field( unsigned int, channel )
> +		     __field( unsigned int, id )
> +		     __field( unsigned int, lun )
> +		     __field( sector_t, rq_sector )
> +		     __field( unsigned int, wp_offset)
> +		     __field( unsigned int, good_bytes)

Same comment as above for rq_sector and missing spaces before ")".

> +	    ),
> +
> +	    TP_fast_assign(
> +		__entry->host_no	= cmnd->device->host->host_no;
> +		__entry->channel	= cmnd->device->channel;
> +		__entry->id		= cmnd->device->id;
> +		__entry->lun		= cmnd->device->lun;
> +		__entry->rq_sector	= rq_sector;
> +		__entry->wp_offset	= wp_offset;
> +		__entry->good_bytes	= good_bytes;
> +	    ),
> +
> +	    TP_printk("host_no=%u, channel=%u id=%u lun=%u rq_sector=%llu" \
> +		      " wp_offset=%u good_bytes=%u",
> +		      __entry->host_no, __entry->channel, __entry->id,
> +		      __entry->lun, __entry->rq_sector, __entry->wp_offset,
> +		      __entry->good_bytes)
> +);
> +
>  #endif /*  _TRACE_SCSI_H */
>  
>  /* This part must be outside protection */

-- 
Damien Le Moal
Western Digital Research

