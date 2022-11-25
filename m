Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609B8C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Nov 2022 17:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiKYRem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 12:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKYRel (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 12:34:41 -0500
Received: from mp-relay-01.fibernetics.ca (mp-relay-01.fibernetics.ca [208.85.217.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405C743AED
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 09:34:40 -0800 (PST)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-01.fibernetics.ca (Postfix) with ESMTPS id D5FE3E17C8;
        Fri, 25 Nov 2022 17:34:38 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id BCB3560460;
        Fri, 25 Nov 2022 17:34:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id Rz9xXZ8-6iPh; Fri, 25 Nov 2022 17:34:38 +0000 (UTC)
Received: from [192.168.48.17] (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id DD9336005F;
        Fri, 25 Nov 2022 17:34:36 +0000 (UTC)
Message-ID: <8a3a5d53-d1e1-0c95-4aea-923c46ac4e32@interlog.com>
Date:   Fri, 25 Nov 2022 12:34:36 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2 7/8] scsi_debug: Support configuring the maximum
 segment size
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20221123205740.463185-1-bvanassche@acm.org>
 <20221123205740.463185-8-bvanassche@acm.org>
Content-Language: en-CA
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20221123205740.463185-8-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-11-23 15:57, Bart Van Assche wrote:
> Add a kernel module parameter for configuring the maximum segment size.
> This patch enables testing SCSI support for segments smaller than the
> page size.
> 
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_debug.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index bebda917b138..ea8f762c55c3 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -770,6 +770,7 @@ static int sdebug_sector_size = DEF_SECTOR_SIZE;
>   static int sdeb_tur_ms_to_ready = DEF_TUR_MS_TO_READY;
>   static int sdebug_virtual_gb = DEF_VIRTUAL_GB;
>   static int sdebug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
> +static unsigned int sdebug_max_segment_size = -1U >   static unsigned int sdebug_lbpu = DEF_LBPU;
>   static unsigned int sdebug_lbpws = DEF_LBPWS;
>   static unsigned int sdebug_lbpws10 = DEF_LBPWS10;
> @@ -5851,6 +5852,7 @@ module_param_named(ndelay, sdebug_ndelay, int, S_IRUGO | S_IWUSR);
>   module_param_named(no_lun_0, sdebug_no_lun_0, int, S_IRUGO | S_IWUSR);
>   module_param_named(no_rwlock, sdebug_no_rwlock, bool, S_IRUGO | S_IWUSR);
>   module_param_named(no_uld, sdebug_no_uld, int, S_IRUGO);
> +module_param_named(max_segment_size, sdebug_max_segment_size, uint, S_IRUGO);

Could you place the above line in alphabetical order.

>   module_param_named(num_parts, sdebug_num_parts, int, S_IRUGO);
>   module_param_named(num_tgts, sdebug_num_tgts, int, S_IRUGO | S_IWUSR);
>   module_param_named(opt_blks, sdebug_opt_blks, int, S_IRUGO);
> @@ -7815,6 +7817,7 @@ static int sdebug_driver_probe(struct device *dev)
>   
>   	sdebug_driver_template.can_queue = sdebug_max_queue;
>   	sdebug_driver_template.cmd_per_lun = sdebug_max_queue;
> +	sdebug_driver_template.max_segment_size = sdebug_max_segment_size;
>   	if (!sdebug_clustering)
>   		sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;
>   

And could you add a
MODULE_PARM_DESC(max_segment_size, "<1 line description>");

entry as well (also in alphabetical order).

Other than that:
   Ack-ed by: Douglas Gilbert <dgilbert@interlog.com>
