Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C358C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbiBIIUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiBIIUi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:20:38 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3527C0613CA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:20:42 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 93311210E9;
        Wed,  9 Feb 2022 08:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644394841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FX0OEzZVGcnmIPJmYTkvAEjNsQAGYW/NrBlpLv1uNYs=;
        b=qoMzhtC9SF4jbIsmreB9ABsKqskbujinGPUfLK6QP7hcz32/4ns/xj2qtzuqk3iB51xsIt
        BQnl/h9FQY+h0mgk7iYTOs9bKCM5LY26M3sMeKON+9peaYRIgiZZ8zLmoZZtsq1ISuj8Oc
        zunfu6W12+XHPNacDjJa9hanH4hb5d0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644394841;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FX0OEzZVGcnmIPJmYTkvAEjNsQAGYW/NrBlpLv1uNYs=;
        b=DXTt/gUqHpVs4yXzX+0yhMaM8rLFs5MygKu/Mfyigok/OKv5zR8NX8l7Y8UjdnJOFQUJ0n
        qidVyB7J6zuglqBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 393C5139D1;
        Wed,  9 Feb 2022 08:20:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CcikBVl5A2IoIQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:20:41 +0000
Message-ID: <1b2d0e6b-2968-6129-6ff0-bfc5840a0c09@suse.de>
Date:   Wed, 9 Feb 2022 09:20:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 33/44] nsp_cs: Move the SCSI pointer to private command
 data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-34-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-34-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:25, Bart Van Assche wrote:
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> in struct scsi_cmnd.
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/pcmcia/nsp_cs.c    | 206 ++++++++++++++++++--------------
>   drivers/scsi/pcmcia/nsp_cs.h    |   2 +-
>   drivers/scsi/pcmcia/nsp_debug.c |   2 +-
>   3 files changed, 120 insertions(+), 90 deletions(-)
> 
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index dcffda384eaf..94d8185d3190 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -70,6 +70,17 @@ static bool       free_ports = 0;
>   module_param(free_ports, bool, 0);
>   MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (default: 0 (=no))");
>   
> +struct nsp_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static struct scsi_pointer *nsp_priv(struct scsi_cmnd *cmd)
> +{
> +	struct nsp_cmd_priv *ncmd = scsi_cmd_priv(cmd);
> +
> +	return &ncmd->scsi_pointer;
> +}
> +

Same here: please use 'struct scsi_pointer' directly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
