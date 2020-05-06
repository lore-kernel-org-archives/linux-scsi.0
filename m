Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6429C38A24
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 12:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D64A206DB
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 12:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgEFM2D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 08:28:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:34986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgEFM2C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 May 2020 08:28:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 18BCBAC6C;
        Wed,  6 May 2020 12:28:04 +0000 (UTC)
Subject: Re: [PATCH] scsi: fnic: Use kmalloc instead of vmalloc for a small
 memory allocation
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200423204620.26395-1-christophe.jaillet@wanadoo.fr>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9675b485-cc1e-d928-6888-00d1d666b599@suse.de>
Date:   Wed, 6 May 2020 14:27:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423204620.26395-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/20 10:46 PM, Christophe JAILLET wrote:
> 'struct fc_trace_flag_type' is just a few bytes long. There is no need
> to allocate such a structure with vmalloc. Using kmalloc instead.
> 
> While at it, axe a useless test when freeing the memory.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/scsi/fnic/fnic_debugfs.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
> index 13f7d88d6e57..8d6ce3470594 100644
> --- a/drivers/scsi/fnic/fnic_debugfs.c
> +++ b/drivers/scsi/fnic/fnic_debugfs.c
> @@ -58,8 +58,7 @@ int fnic_debugfs_init(void)
>   						fnic_trace_debugfs_root);
>   
>   	/* Allocate memory to structure */
> -	fc_trc_flag = (struct fc_trace_flag_type *)
> -		vmalloc(sizeof(struct fc_trace_flag_type));
> +	fc_trc_flag = kmalloc(sizeof(*fc_trc_flag), GFP_KERNEL);
>   
>   	if (fc_trc_flag) {
>   		fc_trc_flag->fc_row_file = 0;
> @@ -87,8 +86,7 @@ void fnic_debugfs_terminate(void)
>   	debugfs_remove(fnic_trace_debugfs_root);
>   	fnic_trace_debugfs_root = NULL;
>   
> -	if (fc_trc_flag)
> -		vfree(fc_trc_flag);
> +	kfree(fc_trc_flag);
>   }
>   
>   /*
> 
Reviewed-by: Hannes Reinecke <har@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
