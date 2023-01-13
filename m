Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD3DC54EBE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Jan 2023 07:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjAMH67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 02:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240526AbjAMH6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 02:58:39 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D28B6ADA0;
        Thu, 12 Jan 2023 23:58:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9A09E5FE58;
        Fri, 13 Jan 2023 07:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673596706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=otW0mb3CTZWxMImGHKfgnX+s5Su993mmeabdgXX8nM0=;
        b=HPEw1IwiJkKE1mqTQ9dC7XaOkgNe5L8HDQNSIHLUzQkvEBIhc+uBs336+bv1YRdQxRqzTm
        W6K76A4kRaXGku3ldLJgOfVjm1cf8I55iHNa5VIJA6kaSZurXeetroCxO+VTM7u1g2A1E9
        9scRAW0YKNv5c34e4h0VMj4PuoLmfTE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673596706;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=otW0mb3CTZWxMImGHKfgnX+s5Su993mmeabdgXX8nM0=;
        b=AgTpGGIigLDPurbafMJ9bbef1xdswctgJrSHniZu7+rLo8esPO9YEDBaR22ECvtP+yvw+I
        OoTI4P+ur58hwsCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B0BA13913;
        Fri, 13 Jan 2023 07:58:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id O0JQOiEPwWOiRgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 13 Jan 2023 07:58:25 +0000
Message-ID: <2cc87ccf-d537-4d79-8fd4-fe05d45db3d6@suse.de>
Date:   Fri, 13 Jan 2023 08:58:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 04/18] scsi: rename and move get_scsi_ml_byte()
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-5-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230112140412.667308-5-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/12/23 15:03, Niklas Cassel wrote:
> SCSI has two different getters:
> - get_XXX_byte() (in scsi_cmnd.h) which takes a struct scsi_cmnd *, and
> - XXX_byte() (in scsi.h) which takes a scmd->result.
> The proper name for get_scsi_ml_byte() should thus be without the get_
> prefix, as it takes a scmd->result. Rename the function to rectify this.
> 
> Additionally, move get_scsi_ml_byte() to scsi_priv.h since both scsi_lib.c
> and scsi_error.c will need to use this helper in a follow-up patch.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/scsi/scsi_lib.c  | 7 +------
>   drivers/scsi/scsi_priv.h | 5 +++++
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9ed1ebcb7443..6630a36b873e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -579,11 +579,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>   	return false;
>   }
>   
> -static inline u8 get_scsi_ml_byte(int result)
> -{
> -	return (result >> 8) & 0xff;
> -}
> -
>   /**
>    * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
>    * @result:	scsi error code
> @@ -596,7 +591,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
>   	 * Check the scsi-ml byte first in case we converted a host or status
>   	 * byte.
>   	 */
> -	switch (get_scsi_ml_byte(result)) {
> +	switch (scsi_ml_byte(result)) {
>   	case SCSIML_STAT_OK:
>   		break;
>   	case SCSIML_STAT_RESV_CONFLICT:
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 96284a0e13fe..74324fba4281 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -29,6 +29,11 @@ enum scsi_ml_status {
>   	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
>   };
>   
> +static inline u8 scsi_ml_byte(int result)
> +{
> +	return (result >> 8) & 0xff;
> +}
> +
>   /*
>    * Scsi Error Handler Flags
>    */

Naming is hard :-)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

