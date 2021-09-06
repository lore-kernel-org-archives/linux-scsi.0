Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261D2C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 06:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 058AC60F12
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 06:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbhIFGUG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 02:20:06 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52442 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhIFGUF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 02:20:05 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4976A20082;
        Mon,  6 Sep 2021 06:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630909140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P4Gr5gu+/Hse23+X+v7ckIdKYFVr0+SFB6GIXh/7mKA=;
        b=1AQ4JXfpJTOydyUnkkWeEWJ1L0c1SKUxn74xKexN3zLxC76NDAbcdoViZvXVAE3LnrZlE3
        GEIgr8FCCBi7iV+Xk7muCIFVaq0uOJHcJysEKY0S4xdZX9flCLOT+H7xwBN5bKL00xrZF4
        53AXpKPe4VpfEKwAEHwFvLbnP3QgQIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630909140;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P4Gr5gu+/Hse23+X+v7ckIdKYFVr0+SFB6GIXh/7mKA=;
        b=OsfXzNCeSbKV+bfZcJsxsoRyih/kOMopVWOIq4Pvdob1ZD7+RFgFvkYZ9rh05kyr2wiRVU
        whZEdVtyvoqcAjDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id C5FF213299;
        Mon,  6 Sep 2021 06:18:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id lmSWLtKyNWGeTwAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 06 Sep 2021 06:18:58 +0000
Subject: Re: [PATCH v3 6/8] dm: add add_disk() error handling
To:     Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
        martin.petersen@oracle.com, jejb@linux.ibm.com, kbusch@kernel.org,
        sagi@grimberg.me, adrian.hunter@intel.com, beanhuo@micron.com,
        ulf.hansson@linaro.org, avri.altman@wdc.com, swboyd@chromium.org,
        agk@redhat.com, snitzer@redhat.com, josef@toxicpanda.com
Cc:     hch@infradead.org, bvanassche@acm.org, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mmc@vger.kernel.org, dm-devel@redhat.com,
        nbd@other.debian.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210830212538.148729-1-mcgrof@kernel.org>
 <20210830212538.148729-7-mcgrof@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <067651b9-f530-2613-a419-6b8c3b11ef88@suse.de>
Date:   Mon, 6 Sep 2021 08:19:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210830212538.148729-7-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/30/21 11:25 PM, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> There are two calls to dm_setup_md_queue() which can fail then,
> one on dm_early_create() and we can easily see that the error path
> there calls dm_destroy in the error path. The other use case is on
> the ioctl table_load case. If that fails userspace needs to call
> the DM_DEV_REMOVE_CMD to cleanup the state - similar to any other
> failure.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   drivers/md/dm.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
