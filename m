Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC07EE57DF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 07:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbjIKHDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 03:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjIKHDW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 03:03:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D61120;
        Mon, 11 Sep 2023 00:03:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CB1D72184F;
        Mon, 11 Sep 2023 07:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694415795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BAwWb4ZF4BNoMDnjo6GRgRIPbTakVTV3K2OFb4+gBO4=;
        b=IUneyFweO9N897sUuhcHjNJimjaBXHeA/wBRBSWvHzvGdAD5I1gr5DBHYU7HGD8MXyKene
        MymM+l0pCv8kg9pj5h/Ojovwm0DTFyd2OBVtZQIGk8zJh3E9Hv1NzFHxSF0FgeZ9dqFfPW
        0A9LraG0eBz1RCYfasgHdNhYspCV5Wc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694415795;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BAwWb4ZF4BNoMDnjo6GRgRIPbTakVTV3K2OFb4+gBO4=;
        b=EY7xkzcPhACnv5ebzd6i//IMjIHj65xeHL3dvsEdJOZI4orFpH7S1GKl13I/LCxBrHWcDl
        m47ouXMXmWIaJ8Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7F39D13780;
        Mon, 11 Sep 2023 07:03:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uF1oHbO7/mSIUwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 11 Sep 2023 07:03:15 +0000
Message-ID: <e8dac57a-b8f1-4195-87d2-86e7f1abb601@suse.de>
Date:   Mon, 11 Sep 2023 09:03:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/19] ata: libata-eh: Improve reset error messages
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-18-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230911040217.253905-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 06:02, Damien Le Moal wrote:
> Some drives are really slow to spinup on resume, resulting is a very
> slow response to COMRESET and to error messages such as:
> 
> ata1: COMRESET failed (errno=-16)
> ata1: link is slow to respond, please be patient (ready=0)
> ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> ata1.00: configured for UDMA/133
> 
> Given that the slowness of the response is indicated with the message
> "link is slow to respond..." and that resets are retried until the
> device is detected as online after up to 1min (ata_eh_reset_timeouts),
> there is no point in printing the "COMRESET failed" error message. Let's
> not scare the user with non fatal errors and only warn about reset
> failures in ata_eh_reset() when all reset retries have been exhausted.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-eh.c   | 2 ++
>   drivers/ata/libata-sata.c | 1 -
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 43b0a1509548..bbc522d16f44 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -2919,6 +2919,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
>   		 */
>   		if (ata_is_host_link(link))
>   			ata_eh_thaw_port(ap);
> +		ata_link_warn(link, "%sreset failed\n",
> +			      reset == hardreset ? "hard" : "soft");
>   		goto out;
>   	}
>   
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 0748e9ea4f5f..00674aae1696 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -608,7 +608,6 @@ int sata_link_hardreset(struct ata_link *link, const unsigned int *timing,
>   		/* online is set iff link is online && reset succeeded */
>   		if (online)
>   			*online = false;
> -		ata_link_err(link, "COMRESET failed (errno=%d)\n", rc);
>   	}
>   	return rc;
>   }
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

