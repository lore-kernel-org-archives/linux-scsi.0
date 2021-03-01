Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3237CC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A2964E3F
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhCAHyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:54:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:41744 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232620AbhCAHyT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:54:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 79132AAC5;
        Mon,  1 Mar 2021 07:32:16 +0000 (UTC)
Subject: Re: [PATCH v4 4/5] scsi_debug: add new defer type for mq poll
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     Douglas Gilbert <dgilbert@interlog.com>
References: <20210215074048.19424-1-kashyap.desai@broadcom.com>
 <20210215074048.19424-5-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9aa25fed-44e0-810e-9fdb-1f802fddb611@suse.de>
Date:   Mon, 1 Mar 2021 08:32:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210215074048.19424-5-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/21 8:40 AM, Kashyap Desai wrote:
> From: Douglas Gilbert <dgilbert@interlog.com>
> 
> Add a new sdeb_defer_type enumeration: SDEB_DEFER_POLL for requests
> that have REQ_HIPRI set in cmd_flags field. It is expected that
> these requests will be polled via the mq_poll entry point which
> is driven by calls to blk_poll() in the block layer. Therefore
> timer events are not 'wired up' in the normal fashion.
> 
> There are still cases with short delays (e.g. < 10 microseconds)
> where by the time the command response processing occurs, the delay
> is already exceeded in which case the code calls scsi_done()
> directly. In such cases there is no window for mq_poll() to be
> called.
> 
> Add 'mq_polls' counter that increments on each scsi_done() called
> via the mq_poll entry point. Can be used to show (with 'cat
> /proc/scsi/scsi_debug/<host_id>') that blk_poll() is causing
> completions rather than some other mechanism.
> 
> This patch is improvement over previous patch
> "scsi_debug: iouring iopoll support"
> 
> Changes since version 3
>    - Fix IO hang issue. Do not return from schedule_resp. Use new defer
>      type for mq poll to queue the REQ_HIPRI IOs.
> 
> Changes since version 2 [sent 20210206 to linux-scsi list]
>    - the sdebug_blk_mq_poll() callback didn't cope with the
>      uncommon case where sqcp->sd_dp is NULL. Fix.
> 
> Changes since version 1 [sent 20210201 to linux-scsi list]
>    - harden SDEB_DEFER_POLL which broke under testing
>    - add mq_polls counter for debug output
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
