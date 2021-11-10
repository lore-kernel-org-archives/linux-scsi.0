Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DD5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 10:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B44561246
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 10:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhKJKYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 05:24:55 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:33192 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhKJKYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 05:24:54 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DC14E21B13;
        Wed, 10 Nov 2021 10:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636539725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n2gUgSIgAj9eb3dIsUJAzVrygXCWhMwvVtCx323hbzk=;
        b=s5WPclLApj6VTZD2JY1svclNq/wt0ib4TXHiMdFwlRafjAuMiuVZON9pVtxaVBOPXcbema
        f4tglGpLkSbqR8n78UzCIJ1n34WMXDPZhEWIIWw4W0wIFQCr3lyqMUCnwz5SoeDsc2nFpj
        82wXg/rlbOl/T6+QHURfhDcQcEDSstU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636539725;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n2gUgSIgAj9eb3dIsUJAzVrygXCWhMwvVtCx323hbzk=;
        b=a+jEixb6pafMJgikEnh5kbjvhIXB0eUvOlPoloqwiX10io2vJ3fjhMlhCbgfNendm3+Q5/
        CGsit7jXABemwIDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C143F13B7F;
        Wed, 10 Nov 2021 10:22:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rFj9Lk2di2HZMwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 10 Nov 2021 10:22:05 +0000
Subject: Re: sorting out the freeze / quiesce mess
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
References: <20211110091407.GA8396@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <477f3098-39be-ad07-e2fb-3ef3309c4dce@suse.de>
Date:   Wed, 10 Nov 2021 11:22:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211110091407.GA8396@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/21 10:14 AM, Christoph Hellwig wrote:
> Hi Jens and Ming,
> 
> I've been looking into properly supporting queue freezing for bio based
> drivers (that is only release q_usage_counter on bio completion for them).
> And the deeper I look into the code the more I'm confused by us having
> the blk_mq_quiesce* interface in addition to blk_freeze_queue.  What
> is a good reason to do a quiesce separately from a freeze?
> 
IIRC the 'quiesce' interface was an abstraction from the SCSI 'quiesce'
operation, where we had to stop all I/O except for TMFs and scanning.
And 'freeze' was designed fro stopping all I/O.

But I'm not sure if that ever was the distinction, or if it still
applies today.

And yeah, I've been wondering myself.

Probably we should just kill the 'quiesce' stuff and see where we end up :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
