Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D683DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 11:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiBILzb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 06:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiBILzU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 06:55:20 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF88C1038CB
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 02:52:30 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3E61A21100;
        Wed,  9 Feb 2022 08:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644395904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RZkdfty/FDRKv5eQ02n4fM9UlVP/+Z1xR4By6zJ8/lQ=;
        b=0wGZz07iPt83nWCnrl3oBHiPee0LfIpyZfZhT4yDR2Z4NZDZy2sqxrQmW85Dp6ENED/z9R
        t3/i9GorNfXWWXF2qEB3ZVILFueB07yiP9InpG09rbsjclLTnZiXBN2UUiJWNrj7ni3LbB
        BxcMwplPv0JqqGva64WYt2dF2lglpk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644395904;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RZkdfty/FDRKv5eQ02n4fM9UlVP/+Z1xR4By6zJ8/lQ=;
        b=LxPFSTvmw+ivaLG0mdQDb6PTAMBImk9BMxew/UA8zersxGgvioWxQPW6/5MfD+7TwhRxKO
        GpGIcnLYOcbsJBDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9EA6813A7C;
        Wed,  9 Feb 2022 08:38:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0zbqIn99A2I4KQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:38:23 +0000
Message-ID: <d1a7b4ca-5eed-b204-c142-9b4009fd3b52@suse.de>
Date:   Wed, 9 Feb 2022 09:38:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 44/44] scsi: core: Remove struct scsi_pointer from
 struct scsi_cmnd
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-45-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-45-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:25, Bart Van Assche wrote:
> Remove struct scsi_pointer from struct scsi_cmnd since the previous patches
> removed all users of that member of struct scsi_cmnd. Additionally, reorder
> the members of struct scsi_cmnd such that the statement that the field
> below can be modified by the SCSI LLD is again correct.
> 
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   include/scsi/scsi_cmnd.h | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 6794d7322cbd..4fd2c522e914 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -123,11 +123,15 @@ struct scsi_cmnd {
>   				 * command (auto-sense). Length must be
>   				 * SCSI_SENSE_BUFFERSIZE bytes. */
>   
> +	int flags;		/* Command flags */
> +	unsigned long state;	/* Command completion state */
> +
> +	unsigned int extra_len;	/* length of alignment and padding */
> +
>   	/*
> -	 * The following fields can be written to by the host specific code.
> -	 * Everything else should be left alone.
> +	 * The fields below can be modified by the SCSI LLD but the fields
> +	 * above not.
>   	 */
> -	struct scsi_pointer SCp;	/* Scratchpad used by some host adapters */
>   
>   	unsigned char *host_scribble;	/* The host adapter is allowed to
>   					 * call scsi_malloc and get some memory
> @@ -138,10 +142,6 @@ struct scsi_cmnd {
>   					 * to be at an address < 16Mb). */
>   
>   	int result;		/* Status code from lower level driver */
> -	int flags;		/* Command flags */
> -	unsigned long state;	/* Command completion state */
> -
> -	unsigned int extra_len;	/* length of alignment and padding */
>   };
>   
>   /* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
