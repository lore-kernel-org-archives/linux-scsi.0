Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90325C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7753A61205
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhFGLl0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:41:26 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55154 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbhFGLl0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 07:41:26 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 94B2B1FDC5;
        Mon,  7 Jun 2021 11:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623065974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gLPqukj9E8xOxqs4sFQrqN9ws5ddBFSvjU43Uy8i4xQ=;
        b=htbYE4+DP+IDOjwUW1UfQvkrCgNPhZd83STh6cK/QcmSBGo3oqbgS72hrrAa1wnPILlyOl
        8WIAedAMLOmEloJEibIfENNZcROuBHj66e+5043upHKdKg7o6/oi3Hw4AcdJUlXzC15Eoc
        qMyejeVy41dx3eolTrAgYqhx5x6Axuw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623065974;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gLPqukj9E8xOxqs4sFQrqN9ws5ddBFSvjU43Uy8i4xQ=;
        b=C9kWEbZZLcWnKjTamORlKZx54BHGFGyd5hlZR1D8t8NTE+kA4JbVnT4ZSxUasi8kjUka89
        g4adsjTMG62AtfDA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 52AF2118DD;
        Mon,  7 Jun 2021 11:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623065974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gLPqukj9E8xOxqs4sFQrqN9ws5ddBFSvjU43Uy8i4xQ=;
        b=htbYE4+DP+IDOjwUW1UfQvkrCgNPhZd83STh6cK/QcmSBGo3oqbgS72hrrAa1wnPILlyOl
        8WIAedAMLOmEloJEibIfENNZcROuBHj66e+5043upHKdKg7o6/oi3Hw4AcdJUlXzC15Eoc
        qMyejeVy41dx3eolTrAgYqhx5x6Axuw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623065974;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gLPqukj9E8xOxqs4sFQrqN9ws5ddBFSvjU43Uy8i4xQ=;
        b=C9kWEbZZLcWnKjTamORlKZx54BHGFGyd5hlZR1D8t8NTE+kA4JbVnT4ZSxUasi8kjUka89
        g4adsjTMG62AtfDA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id t2q5E3YFvmCPXgAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 07 Jun 2021 11:39:34 +0000
Subject: Re: [PATCH 1/4] scsi: core: fix error handling of scsi_host_alloc
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-2-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <cd3de5d9-5470-83fe-9e59-8f6e364af93a@suse.de>
Date:   Mon, 7 Jun 2021 13:39:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210602133029.2864069-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/21 3:30 PM, Ming Lei wrote:
> After device is initialized via device_initialize(), or its name is
> set via dev_set_name(), the device has to be freed via put_device(),
> otherwise device name will be leaked because it is allocated
> dynamically in dev_set_name().
> 
> Fixes the issue by replacing kfree(shost) via put_device(&shost->shost_gendev)
> which can help to free dev_name(&shost->shost_dev) when host state is
> in SHOST_CREATED. Meantime needn't to remove IDA and stop the kthread of
> shost->ehandler in the error handling code.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hosts.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
