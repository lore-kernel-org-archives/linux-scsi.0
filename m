Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A86CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 07:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FA9961BCF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 07:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbhKQHxj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 02:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbhKQHxf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 02:53:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3C4C061570;
        Tue, 16 Nov 2021 23:50:37 -0800 (PST)
Date:   Wed, 17 Nov 2021 08:50:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637135434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ax+O+TbFMKVdZPHia3nwdzGuCjCQzBuzpJRZNmRTT1M=;
        b=ljqHTGg9ES5+OAAYE8gtsu5iv/dszn+jGNbi+u6GbhfSA6MIrFszUK/2v2BUmSnD5F5EUM
        YkH9xM5MYjvqtGtDHq8GBpbZcHNuW/s+iM0mS4nPTmnGeK9BG3R74Ln6DAW3KxS5b/8hdY
        caFU5xYtwwly00TA5Y9DTPx0VUodACZmYjySXddRE3i11JKwuntUV8VgXMwn8UL+mRFG1d
        wtiUwSVbIfMp75VKRgdK+bf+VWuzi51j4jR3ap+qpEjJmyFzg6OjK62/pubkpQyMfstgrK
        xiCe4ZhPdm7Mnu3SiQztXwYvb8WxU8zzh5zHLMTtctROqFMW/zAFRG7IkcU5UA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637135434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ax+O+TbFMKVdZPHia3nwdzGuCjCQzBuzpJRZNmRTT1M=;
        b=gnMWDv+9tZsoyv8AOmlnky4MMUxsmWRmNILpO6wb/uXWFtQcL+pxE4g79SDWnYtThmZkuk
        Zv4uS8lpKB4Hk3Cw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com, hare@suse.de,
        tglx@linutronix.de, linux-scsi@vger.kernel.org,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 2/3] scsi/fcoe: Add a local_lock to fcoe_percpu
Message-ID: <20211117075033.hdqb7wvpz2r2jla7@linutronix.de>
References: <20211117025956.79616-1-dave@stgolabs.net>
 <20211117025956.79616-3-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211117025956.79616-3-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-11-16 18:59:55 [-0800], Davidlohr Bueso wrote:
> fcoe_get_paged_crc_eof() relies on the caller having preemption
> disabled to ensure the per-CPU fcoe_percpu context remains valid
> throughout the call. This is done by either holding spinlocks
> (such as bnx2fc_global_lock or qedf_global_lock) or the get_cpu()
> from fcoe_alloc_paged_crc_eof(). This last one breaks PREEMPT_RT
> semantics as there can be memory allocation and end up sleeping
> in atomic contexts.
> 
> Introduce a local_lock_t to struct fcoe_percpu that will keep the
> non-RT case the same, mapping to preempt_disable/enable, while
> RT will use a per-CPU spinlock allowing the region to be preemptible
> but still maintain CPU locality. The other users of fcoe_percpu
> are already safe in this regard and do not require local_lock()ing.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
