Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E45CC677F1
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Jan 2023 07:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238700AbjAMH5u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 02:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjAMH5m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 02:57:42 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A630642626;
        Thu, 12 Jan 2023 23:57:39 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 569BD5FB79;
        Fri, 13 Jan 2023 07:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673596658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgKuRF7JIR0JKTum+5Go+bcLCePwj7nHsbxwtr15QVU=;
        b=gIx3PFjOKRc6DwoF8jW8t+18TCTJXra7sBSmZenpFz0Zpi9CAhZv4H+XSzgHhOQ7hKOrBL
        vs2/NTmsiCXqkmku5RNaKY2JOrWt+uN5czOsdmcWu6Lg+vNbtHOTaadIwBvQRsmfEcBnHB
        hAXSxxvrmPJGM8RXhO6DnFAY4zx5krg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673596658;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgKuRF7JIR0JKTum+5Go+bcLCePwj7nHsbxwtr15QVU=;
        b=Sm+5n8pjkwJjtu0xDrqN6c8prNk/rbyHhZxhUNymawI+BmFEkChTp67tPp3wIn1z9kvtuo
        k/Kqfdo55IVNESBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C24ED13913;
        Fri, 13 Jan 2023 07:57:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TGeIK/EOwWNBRgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 13 Jan 2023 07:57:37 +0000
Message-ID: <ab23c5dd-3a61-452c-52c9-43b6b18f2c8e@suse.de>
Date:   Fri, 13 Jan 2023 08:57:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 03/18] scsi: core: allow libata to complete successful
 commands via EH
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-4-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230112140412.667308-4-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/12/23 15:03, Niklas Cassel wrote:
> In SCSI, we get the sense data as part of the completion, for ATA
> however, we need to fetch the sense data as an extra step. For an
> aborted ATA command the sense data is fetched via libata's
> ->eh_strategy_handler().
> 
> For Command Duration Limits policy 0xD:
> The device shall complete the command without error with the additional
> sense code set to DATA CURRENTLY UNAVAILABLE.
> 
> In order to handle this policy in libata, we intend to send a successful
> command via SCSI EH, and let libata's ->eh_strategy_handler() fetch the
> sense data for the good command. This is similar to how we handle an
> aborted ATA command, just that we need to read the Successful NCQ
> Commands log instead of the NCQ Command Error log.
> 
> When we get a SATA completion with successful commands, ATA_SENSE will
> be set, indicating that some commands in the completion have sense data.
> 
> The sense_valid bitmask in the Sense Data for Successful NCQ Commands
> log will inform exactly which commands that had sense data, which might
> be a subset of all the commands that was completed in the same
> completion. (Yet all will have ATA_SENSE set, since the status is per
> completion.)
> 
> The successful commands that have e.g. a "DATA CURRENTLY UNAVAILABLE"
> sense data will have a SCSI ML byte set, so scsi_eh_flush_done_q() will
> not set the scmd->result to DID_TIME_OUT for these commands. However,
> the successful commands that did not have sense data, must not get their
> result marked as DID_TIME_OUT by SCSI EH.
> 
> Add a new flag SCMD_EH_SUCCESS_CMD, which tells SCSI EH to not mark a
> command as DID_TIME_OUT, even if it has scmd->result == SAM_STAT_GOOD.
> 
> This will be used by libata in a follow-up patch.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/scsi/scsi_error.c | 3 ++-
>   include/scsi/scsi_cmnd.h  | 5 +++++
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 2aa2c2aee6e7..51aa5c1e31b5 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2165,7 +2165,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
>   			 * scsi_eh_get_sense), scmd->result is already
>   			 * set, do not set DID_TIME_OUT.
>   			 */
> -			if (!scmd->result)
> +			if (!scmd->result &&
> +			    !(scmd->flags & SCMD_EH_SUCCESS_CMD))
>   				scmd->result |= (DID_TIME_OUT << 16);
>   			SCSI_LOG_ERROR_RECOVERY(3,
>   				scmd_printk(KERN_INFO, scmd,
Wouldn't it be better to use '!scmd->result && !scsi_sense_valid(scmd)' 
instead of a new flag?
After all, if we have a valid sense code we _have_ been able to 
communicate with the device. And as we did so it's questionable whether 
it should count as a command time out ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

