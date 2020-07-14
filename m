Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4160BC433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FD7C221ED
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgGNHBK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:01:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:37794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgGNHBK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 03:01:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A7D27AEAA;
        Tue, 14 Jul 2020 07:01:10 +0000 (UTC)
Subject: Re: [PATCH v2 06/29] scsi: fcoe: fcoe_transport: Correct some
 kernel-doc issues
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-7-lee.jones@linaro.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d2c4ead1-8922-3b72-0aee-b889a0c409f8@suse.de>
Date:   Tue, 14 Jul 2020 09:01:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713074645.126138-7-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 9:46 AM, Lee Jones wrote:
> Mainly due to misdocumentation or bitrotted descriptions.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/scsi/fcoe/fcoe_transport.c:396: warning: Function parameter or member 'skb' not described in 'fcoe_check_wait_queue'
>   drivers/scsi/fcoe/fcoe_transport.c:447: warning: Function parameter or member 't' not described in 'fcoe_queue_timer'
>   drivers/scsi/fcoe/fcoe_transport.c:447: warning: Excess function parameter 'lport' description in 'fcoe_queue_timer'
>   drivers/scsi/fcoe/fcoe_transport.c:682: warning: Function parameter or member 'netdev' not described in 'fcoe_netdev_map_lookup'
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/scsi/fcoe/fcoe_transport.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
> index a20ddc301c89e..6e187d0e71fd2 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -382,6 +382,7 @@ EXPORT_SYMBOL_GPL(fcoe_clean_pending_queue);
>   /**
>    * fcoe_check_wait_queue() - Attempt to clear the transmit backlog
>    * @lport: The local port whose backlog is to be cleared
> + * @skb: The received FIP packet
>    *
>    * This empties the wait_queue, dequeues the head of the wait_queue queue
>    * and calls fcoe_start_io() for each packet. If all skb have been
> @@ -439,7 +440,7 @@ EXPORT_SYMBOL_GPL(fcoe_check_wait_queue);
>   
>   /**
>    * fcoe_queue_timer() - The fcoe queue timer
> - * @lport: The local port
> + * @t: Timer context use to obtain the FCoE port
>    *
>    * Calls fcoe_check_wait_queue on timeout
>    */
> @@ -672,6 +673,7 @@ static void fcoe_del_netdev_mapping(struct net_device *netdev)
>   /**
>    * fcoe_netdev_map_lookup - find the fcoe transport that matches the netdev on which
>    * it was created
> + * @netdev: The net device that the FCoE interface is on
>    *
>    * Returns : ptr to the fcoe transport that supports this netdev or NULL
>    * if not found.
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
