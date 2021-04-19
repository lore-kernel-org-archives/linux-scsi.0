Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C272C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 16:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E74916135F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 16:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhDSQUf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 12:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbhDSQUd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 12:20:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70491C06174A
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 09:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ULfldEWCeiG86bWrzItwxbpSXvkNGw6z9N7T1wXEGhM=; b=XyKBXjWDroeWpKdHNd640lTUhy
        0tLAyURMa3/DCDXB+joGOdsvOwsY3GmxNZOiIRui1QpPHCm0vjDXMM5SgfH5YD3MTeLYHfWITz+zM
        Pj9kF5m2xxhz4JhybrxdqDByElUwoB8mBApVHBU8Fx4qVaOauqbc9WI1xBYy5uV+dRSXVaGCOq4UB
        syb6++VUe03L86dQu+y0eIVXh6EFKA0uP6d9M/pP/8Bo/Zzxy9Pn67TKZEIYVF576MKwXOLLa7L/G
        sZW7NiJIQsTFmfnPVLe5gGK+/dF2PbC/zkmQAw7JfWjGCeLE8O9nIb39L0Uuxf7ZnXLdVL9sxht6m
        Lpj5n2Sw==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYWcG-00DzdO-8w; Mon, 19 Apr 2021 16:19:22 +0000
Subject: Re: [RFC] qla2xxx: Add dev_loss_tmo kernel module options
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>
References: <20210419100014.47144-1-dwagner@suse.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <cb00b188-31bf-d943-8f82-31c8c966c728@infradead.org>
Date:   Mon, 19 Apr 2021 09:19:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210419100014.47144-1-dwagner@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 4/19/21 3:00 AM, Daniel Wagner wrote:
> Allow to set the default dev_loss_tmo value as kernel module option.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> 
>  drivers/scsi/qla2xxx/qla_attr.c | 4 ++--
>  drivers/scsi/qla2xxx/qla_gbl.h  | 1 +
>  drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
>  drivers/scsi/qla2xxx/qla_os.c   | 5 +++++
>  4 files changed, 9 insertions(+), 3 deletions(-)
> 

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d74c32f84ef5..c686522ff64e 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -338,6 +338,11 @@ static void qla2x00_free_device(scsi_qla_host_t *);
>  static int qla2xxx_map_queues(struct Scsi_Host *shost);
>  static void qla2x00_destroy_deferred_work(struct qla_hw_data *);
>  
> +int ql2xdev_loss_tmo = 60;
> +module_param(ql2xdev_loss_tmo, int, 0444);
> +MODULE_PARM_DESC(ql2xdev_loss_tmo,
> +		"Time to wait for device to recover before reporting\n"
> +		"an error. Default is 60 seconds\n");

No need for the \n in the quoted string. Just change it to a space.


-- 
~Randy

