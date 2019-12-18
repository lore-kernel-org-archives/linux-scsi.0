Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6CCC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 11:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19EE124650
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 11:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfLRLM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:12:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:55134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfLRLM7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Dec 2019 06:12:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 274E8B1A1;
        Wed, 18 Dec 2019 11:12:56 +0000 (UTC)
Subject: Re: [PATCH] scsi: libfc: remove unnecessary assertion on ep variable
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     kjlu@umn.edu, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ira Weiny <ira.weiny@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191217212214.30722-1-pakki001@umn.edu>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ca12f639-2ee0-55eb-c927-c1ce97208c00@suse.de>
Date:   Wed, 18 Dec 2019 12:12:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191217212214.30722-1-pakki001@umn.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/17/19 10:22 PM, Aditya Pakki wrote:
> In ft_recv_write_data(), the pointer ep is dereferenced first and
> then asserts for NULL. The patch removes the unnecessary assertion.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>   drivers/target/tcm_fc/tfc_io.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
> index 1354a157e9af..6a38ff936389 100644
> --- a/drivers/target/tcm_fc/tfc_io.c
> +++ b/drivers/target/tcm_fc/tfc_io.c
> @@ -221,7 +221,6 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
>   	ep = fc_seq_exch(seq);
>   	lport = ep->lp;
>   	if (cmd->was_ddp_setup) {
> -		BUG_ON(!ep);
>   		BUG_ON(!lport);
>   		/*
>   		 * Since DDP (Large Rx offload) was setup for this request,
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
