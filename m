Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE97DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 06:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28C160EE1
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 06:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239662AbhIFGOp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 02:14:45 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51890 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbhIFGOk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 02:14:40 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0F2ED20086;
        Mon,  6 Sep 2021 06:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630908815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lspn4kTqfo1l+UEtf4Egkt0be/N8Ml77bfdiqmTef88=;
        b=Z7kAUAkoUoVqKUucQvGBbnne9RRYQb+877TVVUDYFlXLBj1vd2K6aEYj8O7WegcEvA+rAW
        triorv/pklm8/0LJmUL6zTdEhyiD2l1EDkCZGZyJn0j1qKjnoS0y8Jo0jX6UdXHvHdNGgW
        NUua9pi49OO9Tdn5znoETfAgzvUdf70=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630908815;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lspn4kTqfo1l+UEtf4Egkt0be/N8Ml77bfdiqmTef88=;
        b=hLOiAHDIAS7+slwD/a6rYPlZQ8urmL226wpnzqRp17MgWRgfPhhPZFIs7yN9RLxrncR8z1
        rnp0/BnhHQnKdUAw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 87DF013299;
        Mon,  6 Sep 2021 06:13:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id ujk+II6xNWG+TgAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 06 Sep 2021 06:13:34 +0000
Subject: Re: [PATCH v3 2/8] scsi/sr: add error handling support for add_disk()
To:     Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
        martin.petersen@oracle.com, jejb@linux.ibm.com, kbusch@kernel.org,
        sagi@grimberg.me, adrian.hunter@intel.com, beanhuo@micron.com,
        ulf.hansson@linaro.org, avri.altman@wdc.com, swboyd@chromium.org,
        agk@redhat.com, snitzer@redhat.com, josef@toxicpanda.com
Cc:     hch@infradead.org, bvanassche@acm.org, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mmc@vger.kernel.org, dm-devel@redhat.com,
        nbd@other.debian.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210830212538.148729-1-mcgrof@kernel.org>
 <20210830212538.148729-3-mcgrof@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ac5a8219-fc6a-d11f-3123-3aeda97fce53@suse.de>
Date:   Mon, 6 Sep 2021 08:13:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210830212538.148729-3-mcgrof@kernel.org>
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
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   drivers/scsi/sr.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
