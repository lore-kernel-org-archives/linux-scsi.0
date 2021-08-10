Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63A1C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E40F61073
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbhHJGXA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 02:23:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48270 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbhHJGW7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 02:22:59 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9E2C421FBF;
        Tue, 10 Aug 2021 06:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628576557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxQMRyPo68jm1oTmu5jCl2um3Yf3M1E8HeoZxyYsp8I=;
        b=VVx52mcgME8rZAEFt2tMu/qTG7yZBnnbVBmD+OLOtkYrMullTyVYz7bVYaOVmM9wgwVsmB
        eBLRGgaRxKMmuy+4KBRXmyuLi5U9wHKr+QCGe68G9WnKeW11yEPqHP4XUyUcC0W6GR8Z/z
        KiFaeUTNrcR2HBbtGyhvwjJ9Iu+Ko1E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628576557;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxQMRyPo68jm1oTmu5jCl2um3Yf3M1E8HeoZxyYsp8I=;
        b=kLT+0CH+0B4r5igvwCv+n4oS7dESUqPMcOuLJW2v/dkwLrSROS4mA2NvtF+IdjKnlPXrWx
        PWr9wl0EYCUqAfBw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 7E28A133D0;
        Tue, 10 Aug 2021 06:22:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id tuvnHS0bEmGgOwAAGKfGzw
        (envelope-from <hare@suse.de>); Tue, 10 Aug 2021 06:22:37 +0000
Subject: Re: [PATCH v5 12/52] NCR5380: Use sc_data_direction instead of
 rq_data_dir()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-13-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <3949bb0a-c425-db7f-0192-b18b4ac6d57d@suse.de>
Date:   Tue, 10 Aug 2021 08:22:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809230355.8186-13-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/21 1:03 AM, Bart Van Assche wrote:
> This patch prepares for the removal of the request pointer from struct
> scsi_cmnd and does not change any functionality.
> 
> Suggested-by: Finn Thain <fthain@linux-m68k.org>
> Acked-by: Finn Thain <fthain@linux-m68k.org>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/NCR5380.c   | 6 +++---
>   drivers/scsi/sun3_scsi.c | 3 ++-
>   2 files changed, 5 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
