Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EACC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50DFB206C3
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgGHGa4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:30:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:57244 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbgGHGaz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jul 2020 02:30:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 746C6AC1D;
        Wed,  8 Jul 2020 06:30:54 +0000 (UTC)
Subject: Re: [PATCH 09/10] scsi: libfc: fc_disc: Fix-up some incorrectly
 referenced function parameters
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200707140055.2956235-1-lee.jones@linaro.org>
 <20200707140055.2956235-10-lee.jones@linaro.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <cd81c7d2-0a65-fb8e-d16f-350e93ed66ea@suse.de>
Date:   Wed, 8 Jul 2020 08:30:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707140055.2956235-10-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/7/20 4:00 PM, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/scsi/libfc/fc_disc.c:343: warning: Function parameter or member 'disc' not described in 'fc_disc_gpn_ft_req'
>   drivers/scsi/libfc/fc_disc.c:343: warning: Excess function parameter 'lport' description in 'fc_disc_gpn_ft_req'
>   drivers/scsi/libfc/fc_disc.c:380: warning: Function parameter or member 'disc' not described in 'fc_disc_gpn_ft_parse'
>   drivers/scsi/libfc/fc_disc.c:380: warning: Excess function parameter 'lport' description in 'fc_disc_gpn_ft_parse'
>   drivers/scsi/libfc/fc_disc.c:498: warning: Function parameter or member 'disc_arg' not described in 'fc_disc_gpn_ft_resp'
>   drivers/scsi/libfc/fc_disc.c:498: warning: Excess function parameter 'lp_arg' description in 'fc_disc_gpn_ft_resp'
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/scsi/libfc/fc_disc.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
> index 2b865c6423e29..428f40cfd1c36 100644
> --- a/drivers/scsi/libfc/fc_disc.c
> +++ b/drivers/scsi/libfc/fc_disc.c
> @@ -337,7 +337,7 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
>   
>   /**
>    * fc_disc_gpn_ft_req() - Send Get Port Names by FC-4 type (GPN_FT) request
> - * @lport: The discovery context
> + * @disc: The discovery context
>    */
>   static void fc_disc_gpn_ft_req(struct fc_disc *disc)
>   {
> @@ -370,7 +370,7 @@ static void fc_disc_gpn_ft_req(struct fc_disc *disc)
>   
>   /**
>    * fc_disc_gpn_ft_parse() - Parse the body of the dNS GPN_FT response.
> - * @lport: The local port the GPN_FT was received on
> + * @disc:  The descovery context
>    * @buf:   The GPN_FT response buffer
>    * @len:   The size of response buffer
>    *
> @@ -488,7 +488,7 @@ static void fc_disc_timeout(struct work_struct *work)
>    * fc_disc_gpn_ft_resp() - Handle a response frame from Get Port Names (GPN_FT)
>    * @sp:	    The sequence that the GPN_FT response was received on
>    * @fp:	    The GPN_FT response frame
> - * @lp_arg: The discovery context
> + * @disc_arg: The discovery context
>    *
>    * Locking Note: This function is called without disc mutex held, and
>    *		 should do all its processing with the mutex held
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
