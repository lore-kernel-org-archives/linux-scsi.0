Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9365DC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 15:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E1A52073E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 15:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgGNPPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 11:15:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:46196 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgGNPPS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 11:15:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8755BACDF;
        Tue, 14 Jul 2020 15:15:18 +0000 (UTC)
Subject: Re: [PATCH v2.1 05/29] scsi: fcoe: fcoe_ctlr: Fix a myriad of
 documentation issues
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-6-lee.jones@linaro.org>
 <20200714150721.GE1398296@dell>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <dea177d6-812f-e0b5-8e1f-54cbf5e6e8f1@suse.de>
Date:   Tue, 14 Jul 2020 17:15:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200714150721.GE1398296@dell>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/20 5:07 PM, Lee Jones wrote:
> Mostly missing or incorrect (bitrotted) function parameters.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/scsi/fcoe/fcoe_ctlr.c:139: warning: Function parameter or member 'mode' not described in 'fcoe_ctlr_init'
>   drivers/scsi/fcoe/fcoe_ctlr.c:604: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_encaps'
>   drivers/scsi/fcoe/fcoe_ctlr.c:1312: warning: Function parameter or member 'skb' not described in 'fcoe_ctlr_recv_clr_vlink'
>   drivers/scsi/fcoe/fcoe_ctlr.c:1312: warning: Excess function parameter 'fh' description in 'fcoe_ctlr_recv_clr_vlink'
>   drivers/scsi/fcoe/fcoe_ctlr.c:1781: warning: Function parameter or member 't' not described in 'fcoe_ctlr_timeout'
>   drivers/scsi/fcoe/fcoe_ctlr.c:1781: warning: Excess function parameter 'arg' description in 'fcoe_ctlr_timeout'
>   drivers/scsi/fcoe/fcoe_ctlr.c:1904: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_recv_flogi'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2166: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_stop_locked'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2166: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_stop_locked'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2188: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_stop'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2188: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_stop'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2204: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_stop_final'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2204: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_stop_final'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2273: warning: Function parameter or member 'frport' not described in 'fcoe_ctlr_vn_parse'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2273: warning: Excess function parameter 'rdata' description in 'fcoe_ctlr_vn_parse'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2804: warning: Function parameter or member 'frport' not described in 'fcoe_ctlr_vlan_parse'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2804: warning: Excess function parameter 'rdata' description in 'fcoe_ctlr_vlan_parse'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2900: warning: Excess function parameter 'min_len' description in 'fcoe_ctlr_vlan_send'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Function parameter or member 'fip' not described in 'fcoe_ctlr_vlan_recv'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Function parameter or member 'skb' not described in 'fcoe_ctlr_vlan_recv'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Excess function parameter 'lport' description in 'fcoe_ctlr_vlan_recv'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Excess function parameter 'fp' description in 'fcoe_ctlr_vlan_recv'
>   drivers/scsi/fcoe/fcoe_ctlr.c:3033: warning: Function parameter or member 'callback' not described in 'fcoe_ctlr_disc_start'
>   drivers/scsi/fcoe/fcoe_ctlr.c:3033: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_start'
>   drivers/scsi/fcoe/fcoe_ctlr.c:3033: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_start'
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
> Changelog:
> 
> v2
>   - Rename title s/fcoe_ctlr_disc_recv/fcoe_ctlr_disc_start/ while we're at it
> 
>   drivers/scsi/fcoe/fcoe_ctlr.c | 28 ++++++++++++++--------------
>   1 file changed, 14 insertions(+), 14 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
