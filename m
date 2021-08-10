Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE3CC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D29F36105A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237762AbhHJGVe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 02:21:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51538 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbhHJGVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 02:21:34 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B34B61FE26;
        Tue, 10 Aug 2021 06:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628576471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgbjpFOYqZOfyOG0tFhKFzVnUIoPzMxQy4lhnTe4ZCg=;
        b=TuyAR3FCXQQytECl4jmbobAqJRIUxvkufSKzc4fPf6aobEe/Z9Ydqw5jf3Z6JkfP6YUofV
        msuaC7VdZoDNrEC6ru35YtOYI/7HKM6yeqatB8DyZm8t0kg3vEhtDxgQ/QmS+0Im4BletD
        EeAKkoEZ5wti/maHXN3Ea2C0LSMUrzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628576471;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgbjpFOYqZOfyOG0tFhKFzVnUIoPzMxQy4lhnTe4ZCg=;
        b=pGxjTBRcO311QH2oRWVVwC+TNts+v3GuTVAI+vpRuRslkfkrlRxiVupkWE7lMGnUTrdqP3
        8FzkdI7nRBUIHHDw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 972E2133D0;
        Tue, 10 Aug 2021 06:21:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id DgUYJNcaEmFiOwAAGKfGzw
        (envelope-from <hare@suse.de>); Tue, 10 Aug 2021 06:21:11 +0000
Subject: Re: [PATCH v5 09/52] RDMA/srp: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-10-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <98c5db43-b031-1c99-5d67-df4dee5840e2@suse.de>
Date:   Tue, 10 Aug 2021 08:21:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809230355.8186-10-bvanassche@acm.org>
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
>   drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
