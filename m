Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A036C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 15:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345558AbiEaPRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 11:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344803AbiEaPRY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 11:17:24 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63B72662
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 08:17:23 -0700 (PDT)
Date:   Tue, 31 May 2022 17:17:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654010240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ol3kdkkk49nmiEiLcm/7rDa+qO3nNFafIE0Bw/6OUk0=;
        b=t3FrJiRoPbZh2x554/Emq/9bEyUFR5JJhmQp5hzkLW/cdG5uzx3h/02s6mtp0mcZZYRZ0W
        p5qXU9RRoxleqaWeUONt/M0ediJvZg8my07GH1xlnstz5YEjYUgZ8ZDT1wnwpAFKPIvlv/
        GSNDwEoPMUAIKMKjDyXrqgOf+apz0HDYN6YQVN9JkNqDOPXZGNM+86z8+Vd5myaHEca9cG
        aTqtOsdTScNEDHO49aSDcK55vkoKJO8W9bDQq9DlqaNYGOvcNvmOrAd8vKTBGLAQJQVKDv
        Jrk/a1Lz/6mPvC8kz5B8FmOJjLu98QhRs885YPKv7SHyUaN1b4VWYIFi6zxNhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654010240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ol3kdkkk49nmiEiLcm/7rDa+qO3nNFafIE0Bw/6OUk0=;
        b=YYbj+yTX4y7TUNOYU7j8BjN8o8PqLSZQQcfwmfXspxPCCJjW9qIBS/JLHYr7UmgX8OYjR9
        C8oPL3gQGNsuWjDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     Davidlohr Bueso <dave@stgolabs.net>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ejb@linux.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 01/10] scsi/mvsas: Kill CONFIG_SCSI_MVSAS_TASKLET
Message-ID: <YpYxfSYDbCJEh9PG@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-2-dave@stgolabs.net>
 <17747966-ea44-ebe5-3d79-df7c33b6a16e@huawei.com>
 <20220531145231.opypdzrlrg23ihil@offworld>
 <5d28e848-0b9d-2aaa-e00e-7888342d25a7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5d28e848-0b9d-2aaa-e00e-7888342d25a7@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-31 16:12:05 [+0100], John Garry wrote:
> On 31/05/2022 15:52, Davidlohr Bueso wrote:
> > On Tue, 31 May 2022, John Garry wrote:
> > > Question: Can there be any good reason to do this?
> > 
> > Removing tasklets altogether, albeit perhaps a pipe dream.
> 
> Sorry, maybe I was not clear, but I was just asking if there was a good
> reason to disable interrupts at source while handling the interrupt, and not
> the change to stop using a tasklet.

Without reading the patch first: You need to disable the interrupt
source while the tasklet/ threaded interrupt is handled. Otherwise the
interrupt will keep coming and the tasklet/ threaded interrupt will have
no chance to make progress. So the box will lock up. This is often
overseen on fast machines because the interrupt needs a few usecs to
trigger and so the CPU is able to make a little bit of progress between
each trigger.

> Thanks,
> John

Sebastian
