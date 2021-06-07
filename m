Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65250C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43CD761159
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhFGLjO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:39:14 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36350 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbhFGLjM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 07:39:12 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AEC6021A97;
        Mon,  7 Jun 2021 11:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623065840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yZOHVH2XtB2FE9PhDbBJcskiQDcVcxS8zf+lEFsGqY0=;
        b=mXb7JQJUGFm96HgGhW+dndEGTPAV/F4fJKWot+BhQZClPPd5RChHC9pZkuDfjUFFFknj+F
        D0uPtdSHtde0XLXez1W75314Ome3TUwBFOijaHSnD3J5hb4a5nQkgq74bgig2hPRE6P4vZ
        CMFpsE4FbvQwBiB2P42IEqqWcdEDYjU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623065840;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yZOHVH2XtB2FE9PhDbBJcskiQDcVcxS8zf+lEFsGqY0=;
        b=rYDieUQoI9UXhhucsY+uMIwgGA1K10ptiXZRcRjbVG/AbQLT7025FpIzSjshZR08GxGdah
        Vqu0q+muk7El0ABA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 80E47118DD;
        Mon,  7 Jun 2021 11:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623065840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yZOHVH2XtB2FE9PhDbBJcskiQDcVcxS8zf+lEFsGqY0=;
        b=mXb7JQJUGFm96HgGhW+dndEGTPAV/F4fJKWot+BhQZClPPd5RChHC9pZkuDfjUFFFknj+F
        D0uPtdSHtde0XLXez1W75314Ome3TUwBFOijaHSnD3J5hb4a5nQkgq74bgig2hPRE6P4vZ
        CMFpsE4FbvQwBiB2P42IEqqWcdEDYjU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623065840;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yZOHVH2XtB2FE9PhDbBJcskiQDcVcxS8zf+lEFsGqY0=;
        b=rYDieUQoI9UXhhucsY+uMIwgGA1K10ptiXZRcRjbVG/AbQLT7025FpIzSjshZR08GxGdah
        Vqu0q+muk7El0ABA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id YLWyHvAEvmCTXQAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 07 Jun 2021 11:37:20 +0000
Subject: Re: [PATCH 2/4] scsi: core: fix failure handling of
 scsi_add_host_with_dma
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-3-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <d414ccf1-bd6b-8de5-6792-15fbc166b885@suse.de>
Date:   Mon, 7 Jun 2021 13:37:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210602133029.2864069-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/21 3:30 PM, Ming Lei wrote:
> When scsi_add_host_with_dma() return failure, the caller will call
> scsi_host_put(shost) to release everything allocated for this host
> instance. So we can't free allocated stuff in scsi_add_host_with_dma(),
> otherwise double free will be caused.
> 
> Strictly speaking, these host resources allocation should have been
> moved to scsi_host_alloc(), but the allocation may need driver's
> info which can be built between calling scsi_host_alloc() and
> scsi_add_host(), so just keep the allocations in
> scsi_add_host_with_dma().
> 
> Fixes the problem by relying on host device's release handler to
> release everything.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hosts.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
