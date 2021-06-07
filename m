Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C37C4743F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C51676121D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhFGLmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:42:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36606 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhFGLmb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 07:42:31 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F0B0221A93;
        Mon,  7 Jun 2021 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623066039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATVAiI6RtRQRyNfJmKxKg2saJK4YPMiaDHH9Y0WQYd8=;
        b=F6uX6qqanFjvv3+7i+6dXeGLguU9JFIX3pcdFmi1qyF/9NwRUNrl5eh9RmK1qccqyNspMk
        qhjO/oAenFOOoFgcpVeW2Mo0NSAHXrL5i7JX2xRqDfNOO++xKyf21hDjRl67iGg+Imhl1m
        VNO00U+LsZfAWq9PoRLk7yI5xKu35vI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623066039;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATVAiI6RtRQRyNfJmKxKg2saJK4YPMiaDHH9Y0WQYd8=;
        b=eWDOgCNO1gqZjlw2KJ2jaYrS3o+tUNTbRMcYV7WvNUbRHu2M2ML81GytJ0Zay+9wMTew1N
        Sx3dBiiJMJjZHmBA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id B46ED118DD;
        Mon,  7 Jun 2021 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623066039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATVAiI6RtRQRyNfJmKxKg2saJK4YPMiaDHH9Y0WQYd8=;
        b=F6uX6qqanFjvv3+7i+6dXeGLguU9JFIX3pcdFmi1qyF/9NwRUNrl5eh9RmK1qccqyNspMk
        qhjO/oAenFOOoFgcpVeW2Mo0NSAHXrL5i7JX2xRqDfNOO++xKyf21hDjRl67iGg+Imhl1m
        VNO00U+LsZfAWq9PoRLk7yI5xKu35vI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623066039;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATVAiI6RtRQRyNfJmKxKg2saJK4YPMiaDHH9Y0WQYd8=;
        b=eWDOgCNO1gqZjlw2KJ2jaYrS3o+tUNTbRMcYV7WvNUbRHu2M2ML81GytJ0Zay+9wMTew1N
        Sx3dBiiJMJjZHmBA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id DCYpK7cFvmBCXwAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 07 Jun 2021 11:40:39 +0000
Subject: Re: [PATCH 3/4] scsi: core: put .shost_dev in failure path if host
 state becomes running
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-4-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <50a04420-0104-04b2-7c37-8f9e25949085@suse.de>
Date:   Mon, 7 Jun 2021 13:40:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210602133029.2864069-4-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/21 3:30 PM, Ming Lei wrote:
> scsi_host_dev_release() only works around for us by freeing
> dev_name(&shost->shost_dev) when host state is SHOST_CREATED. After host
> state is changed to SHOST_RUNNING, scsi_host_dev_release() doesn't do
> that any more.
> 
> So fix the issue by put .shost_dev in failure path if host state becomes
> running, meantime move get_device(&shost->shost_gendev) before
> device_add(&shost->shost_dev), so that scsi_host_cls_release() can put
> this reference.
> 
> Reported-by: John Garry <john.garry@huawei.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hosts.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
