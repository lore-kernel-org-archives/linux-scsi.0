Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4B3C2FC0E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 11:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350266AbjHQLZx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350372AbjHQLZs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 07:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E17F30DA;
        Thu, 17 Aug 2023 04:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB756612BB;
        Thu, 17 Aug 2023 11:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A93C433C8;
        Thu, 17 Aug 2023 11:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692271532;
        bh=bW1qYLHsycLTe0L2ExpZ+YNEv6S0CIYkVeCF03sYJDs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nYxJxPSnb5R/ciXRYclWPvswRpKSVpkVRxPOz+F9/84+JGEVdBoeoKLf/WSdKUX/O
         8BsS3+nH4RmYgD54w1qONNdn2iJn9/qC5ssb/QwaD+1FbS8BmdiA6fzxANLKCNkNSt
         64HvyOzsGHRC4KfM5EPSGuoIxEJHPxNfi9Oi0ryc4Jd38oQjWZHCxYHjUlTB8uc3fb
         rDeeC/MtVVdXNKZabAa4vGHFbPGxpyK93RN0pPW92sPCMqnPwFBOVq40KyLtoQRLmc
         gwm7T4xAr+UJ/pKEfCyWGq1aBdgE6zE39nPA8NnTNDWc0ScAxdbuUwVGE4n6P98UxN
         5PFvQb6W57lWg==
Message-ID: <cbce2335-7a64-e5bf-c8bc-e5f294efc763@kernel.org>
Date:   Thu, 17 Aug 2023 20:25:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 09/17] scsi: scsi_debug: Support disabling zone write
 locking
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-10-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230816195447.3703954-10-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:53, Bart Van Assche wrote:
> Make it easier to test not using zone write locking by supporting
> disabling zone write locking in the scsi_debug driver.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_debug.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 9c0af50501f9..c44c523bde2c 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -832,6 +832,7 @@ static int dix_reads;
>  static int dif_errors;
>  
>  /* ZBC global data */
> +static bool sdeb_no_zwrl;
>  static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed disks */
>  static int sdeb_zbc_zone_cap_mb;
>  static int sdeb_zbc_zone_size_mb;
> @@ -5138,9 +5139,13 @@ static struct sdebug_dev_info *find_build_dev_info(struct scsi_device *sdev)
>  
>  static int scsi_debug_slave_alloc(struct scsi_device *sdp)
>  {
> +	struct request_queue *q = sdp->request_queue;
> +
>  	if (sdebug_verbose)
>  		pr_info("slave_alloc <%u %u %u %llu>\n",
>  		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
> +	if (sdeb_no_zwrl)
> +		q->limits.driver_preserves_write_order = true;

The option is named and discribed as "no_zone_write_lock", which is a block
layer concept. Given that this sets driver_preserves_write_order and does not
touch the use_zone_write_locking limit, I think it is better to name the option
"preserve_write_order" (or similar) to avoid confusion.

>  	return 0;
>  }
>  
> @@ -5738,6 +5743,7 @@ module_param_named(ndelay, sdebug_ndelay, int, S_IRUGO | S_IWUSR);
>  module_param_named(no_lun_0, sdebug_no_lun_0, int, S_IRUGO | S_IWUSR);
>  module_param_named(no_rwlock, sdebug_no_rwlock, bool, S_IRUGO | S_IWUSR);
>  module_param_named(no_uld, sdebug_no_uld, int, S_IRUGO);
> +module_param_named(no_zone_write_lock, sdeb_no_zwrl, bool, S_IRUGO);
>  module_param_named(num_parts, sdebug_num_parts, int, S_IRUGO);
>  module_param_named(num_tgts, sdebug_num_tgts, int, S_IRUGO | S_IWUSR);
>  module_param_named(opt_blks, sdebug_opt_blks, int, S_IRUGO);
> @@ -5812,6 +5818,8 @@ MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
>  MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
>  MODULE_PARM_DESC(no_rwlock, "don't protect user data reads+writes (def=0)");
>  MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
> +MODULE_PARM_DESC(no_zone_write_lock,
> +		 "Disable serialization of zoned writes (def=0)");
>  MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
>  MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
>  MODULE_PARM_DESC(opt_blks, "optimal transfer length in blocks (def=1024)");

-- 
Damien Le Moal
Western Digital Research

