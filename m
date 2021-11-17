Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D56C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 08:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F2D63231
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 08:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhKQIhw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 03:37:52 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:58402 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhKQIhv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 03:37:51 -0500
Date:   Wed, 17 Nov 2021 09:34:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637138092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LmkNgBHietKVu8Mte2YXrWfeDL2G6tqiH2IZ5HuMaQo=;
        b=mRUTOVzNf7t1sNT3UWDiqwbesA3vtPGtA1rkL6doTGzPLrchC16Cbu5aBXizU3ACaxyX03
        8jravJiQNio60wp/JEueci1W1XReq8X6WYROtk30/tro/ggocT+Ke09UV8o2onPms/vWCV
        TTD/SkQXmiQ4BptiosCHBkH/Q78T5ElMGOkvD5oA4daD81l8NUzfa+wjOYgUlSlDU7PMJ0
        lXnWKP+GbHCw6T4iTFw+AWNjg1TxPnv1o/aR/uA/AyBVrYzs+CLLHAHDS0Rz8TEQJfOte+
        qJuNAbVf02Sxu3MkPUrQdwuckmyuECmxvUrsCkIo4kJqkCXiaC5ER+n8LRNcXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637138092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LmkNgBHietKVu8Mte2YXrWfeDL2G6tqiH2IZ5HuMaQo=;
        b=hv+xK+RYzJAupVxyMrZ7Q+e7GbLjaNeEQdZI5Tu0pK2knXxMtS9DGJ9FbmD7JhXQzJQGNI
        W6UEZfN4qz5yUOCA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com, hare@suse.de,
        tglx@linutronix.de, linux-scsi@vger.kernel.org,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 3/3] scsi/fcoe: Add a local_lock to percpu localport
 statistics
Message-ID: <20211117083450.ccgbcmgtwmbkqiqy@linutronix.de>
References: <20211117025956.79616-1-dave@stgolabs.net>
 <20211117025956.79616-4-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211117025956.79616-4-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-11-16 18:59:56 [-0800], Davidlohr Bueso wrote:
> Updating the per-CPU lport->stats relies on disabling preemption
> with get/put_cpu() semantics. However, this is a bit harsh for
> PREEMPT_RT and by using a local_lock, it can allow the region
> to be preemptible, guaranteeing CPU locality, without making any
> difference to the non-RT common case as it will continue to
> disable preemption.

What about adding a struct u64_stats_sync where the stats are updated.
You have to use u64_stats_update_begin() at the beginning and the
matching end function instead the get_cpu()/ local_lock().
You need just ensure that there is only one writer at a time. Network
wise it is easy as there are often per-queue stats so one writer at a
time :)

Looking closer, the current approach appears broken in that regard:
stats members, such as TxFrames/ TxWords which are incremented in
bnx2fc_xmit(), are 64bit. Reading/ writing them requires two operations
on 32bit architectures. But we probably don't care because stats and it
happens hardly and performance of course. This is the cute part about
u64_stats_sync, it magically vanishes on 64bit architectures.

Sebastian
