Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6402C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F8E61052
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbhHJGZk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 02:25:40 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48648 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbhHJGZj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 02:25:39 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A1CC021FA1;
        Tue, 10 Aug 2021 06:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628576717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lMQO2oIUjldlICoI2IJosxg8yE8enC8hdDK/5klMX2g=;
        b=IQJSFRs1izMjgYrMl0aE6WS8KxKxmboiJDGQqOcQGQeSNuJ+4PUMOAVyD3dzGWcYi6N/H4
        gU7h0Tb/GKPrjWL2lJkbHJVKzohdykz1HYDMRB3W+aA8XI/Nxbo22qr6iFKelxFenLEC6t
        s8zcccdS+Gi3CLfJF1o9SUFhxN3sEms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628576717;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lMQO2oIUjldlICoI2IJosxg8yE8enC8hdDK/5klMX2g=;
        b=4ALnhTQCJf2QirPpGoLHOiulje75AJGRg6fZMYAzv5Ft/Zpm4nBTFwFK4B9QhWKYVGNGcG
        ZiJguE28xCHRv8Cw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 869B3133D0;
        Tue, 10 Aug 2021 06:25:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id zvU3IM0bEmEHPAAAGKfGzw
        (envelope-from <hare@suse.de>); Tue, 10 Aug 2021 06:25:17 +0000
Subject: Re: [PATCH v5 14/52] advansys: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-15-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b4dd9bf7-1d4b-9a09-2100-dcf0c3aeb434@suse.de>
Date:   Tue, 10 Aug 2021 08:25:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809230355.8186-15-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/21 1:03 AM, Bart Van Assche wrote:
> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
> instead. This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/advansys.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index f3377e2ef5fb..ffb391967573 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -7423,7 +7423,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>   	 * Set the srb_tag to the command tag + 1, as
>   	 * srb_tag '0' is used internally by the chip.
>   	 */
> -	srb_tag = scp->request->tag + 1;
> +	srb_tag = scsi_cmd_to_rq(scp)->tag + 1;
>   	asc_scsi_q->q2.srb_tag = srb_tag;
>   
>   	/*
> @@ -7637,7 +7637,7 @@ static int
>   adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>   	      adv_req_t **adv_reqpp)
>   {
> -	u32 srb_tag = scp->request->tag;
> +	u32 srb_tag = scsi_cmd_to_rq(scp)->tag;
>   	adv_req_t *reqp;
>   	ADV_SCSI_REQ_Q *scsiqp;
>   	int ret;
> 
Cf the previous patch; we really should introduce a helper to get the 
tag from a SCSI command.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
