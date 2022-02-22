Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82F9C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 18:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiBVSaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 13:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbiBVSaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 13:30:16 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08B2EEA7D;
        Tue, 22 Feb 2022 10:29:49 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id p8so12921606pfh.8;
        Tue, 22 Feb 2022 10:29:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1etCuTtUGMTh1zy0Rkelm55EZW2T//pVnNR7YFuw4UM=;
        b=lM52GhZcLNxGReQvkewX6k+UsRaW+W6quIAKfUJzVrh/0pPuiidL26KzaJJA5ONKPe
         rQ00ZEjGiUVgPVPsI8glk996gyvFGAOFMqdukub+F0q8dc5yi4ojD9LLsOn12zELc/z6
         6QL/68MlpCJvmrJjAHsYmS8NjkF33Em2XqM+VgkKwRtAvUuRn1jy2PF8/Oc+fahHVAS0
         BoRHda8via2cly/SSVXSi4GqiCbxaKsNG16n1JLKCU7M6JENr28ehzubDw04zBTIyJTp
         3CZF17rTuqPrRvYBcDtVYjZZ1ouaw42AhgDgUkDEs61JU6U9c7GWvEq6TB6AMSz2ZHgc
         bD8A==
X-Gm-Message-State: AOAM533mEx1z2K0p3pLldPbU9tvqtV9HP1k2nlSb8gHwaYiGaQZ6g8Hl
        KwJ7LMRvIWirG/mZD4xUG31l7mMgXPpWKg==
X-Google-Smtp-Source: ABdhPJz/NwkGmoTyHeOw8uxGygP6M5F2JksIPxMWhUY6SlqPGzMPrfRYtxl3w1y1dSsMOaSqaIhZnw==
X-Received: by 2002:aa7:85c2:0:b0:4cb:b95a:887f with SMTP id z2-20020aa785c2000000b004cbb95a887fmr26068497pfn.74.1645554589177;
        Tue, 22 Feb 2022 10:29:49 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s19sm18098839pfu.34.2022.02.22.10.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 10:29:48 -0800 (PST)
Message-ID: <4b9a4121-7f37-9bd3-036a-51892a456eef@acm.org>
Date:   Tue, 22 Feb 2022 10:29:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 10/12] block: move blk_exit_queue into disk_release
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220222141450.591193-1-hch@lst.de>
 <20220222141450.591193-11-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220222141450.591193-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 06:14, Christoph Hellwig wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> There can't be FS IO in disk_release(), so move blk_exit_queue() there.
> 
> We still need to freeze queue here since the request is freed after the
> bio is completed and passthrough request rely on scheduler tags as well.
> 
> The disk can be released before or after queue is cleaned up, and we have
> to free the scheduler request pool before blk_cleanup_queue returns,
> while the static request pool has to be freed before exiting the
> I/O scheduler.

This patch looks dubious to me because:
- The blk_freeze_queue() call in blk_cleanup_queue() waits for pending
   requests to finish, so why to move blk_exit_queue() from
   blk_cleanup_queue() into disk_release()?
- I'm concerned that this patch will break user space, e.g. scripts that
   try to unload an I/O scheduler kernel module immediately after having
   removed a request queue.

> +static void blk_mq_release_queue(struct request_queue *q)
> +{
> +	blk_mq_cancel_work_sync(q);
> +
> +	/*
> +	 * There can't be any non non-passthrough bios in flight here, but
> +	 * requests stay around longer, including passthrough ones so we
> +	 * still need to freeze the queue here.
> +	 */
> +	blk_mq_freeze_queue(q);

The above comment should be elaborated since what matters in this 
context is not whether or not any bios are still in flight but what 
happens with the request structures. As you know blk_queue_enter() fails 
after the DYING flag has been set, a flag that is set by 
blk_cleanup_queue(). blk_cleanup_queue() already freezes the queue. So 
why is it necessary to call blk_mq_freeze_queue() from 
blk_mq_release_queue()?

Bart.
