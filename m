Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7451C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0DBD61051
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhHJGP0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 02:15:26 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47632 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhHJGPY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 02:15:24 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5FC8F21F68;
        Tue, 10 Aug 2021 06:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628576102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=byJ1z/Gp4RuW9kVrXOQ8iDwXnSR4iaNZQ+kO8Ud4vI4=;
        b=0p7c+DaVluT9AWp7O4B65oRj1auRRRUf8hOPtdRV1RL4uTBEx9u6QsNxl3H2lokE8aBwP6
        9BYr3WxXs50Jg5FRHIi5yTwBZD69V8Dofz6U0OryOgR4vFFPOx29EDD0ge21uxJgEC3B1w
        wQE/eON1K0nEoEK8gRePu32cV6xUnVk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628576102;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=byJ1z/Gp4RuW9kVrXOQ8iDwXnSR4iaNZQ+kO8Ud4vI4=;
        b=l7X2qvVB2EcPwlec0jVvEVey7Icx/4oZGMItf9E/qXSrRkQRfxb6Vx74fLEneaBkI9O0ws
        ZEXYmZ1LW3xKPqDg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 2391B133D0;
        Tue, 10 Aug 2021 06:15:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 7DQrB2YZEmFDOgAAGKfGzw
        (envelope-from <hare@suse.de>); Tue, 10 Aug 2021 06:15:02 +0000
Subject: Re: [PATCH v5 01/52] core: Introduce the scsi_cmd_to_rq() function
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-2-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6d0dfa0a-1fe6-2a11-2f26-c8aa65079ec7@suse.de>
Date:   Tue, 10 Aug 2021 08:15:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809230355.8186-2-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/21 1:03 AM, Bart Van Assche wrote:
> The 'request' member of struct scsi_cmnd is superfluous. The struct
> request and struct scsi_cmnd data structures are adjacent and hence the
> request pointer can be derived easily from a scsi_cmnd pointer. Introduce
> a helper function that performs that conversion in a type-safe way. This
> patch is the first step towards removing the request member from struct
> scsi_cmnd. Making that change has the following advantages:
> - This is a performance optimization since adding an offset to a pointer
>    takes less time than dereferencing a pointer.
> - struct scsi_cmnd becomes smaller.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   include/scsi/scsi_cmnd.h | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 90da9617d28a..e76278ea1fee 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -146,6 +146,12 @@ struct scsi_cmnd {
>   	unsigned int extra_len;	/* length of alignment and padding */
>   };
>   
> +/* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
> +static inline struct request *scsi_cmd_to_rq(struct scsi_cmnd *scmd)
> +{
> +	return blk_mq_rq_from_pdu(scmd);
> +}
> +
>   /*
>    * Return the driver private allocation behind the command.
>    * Only works if cmd_size is set in the host template.
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
