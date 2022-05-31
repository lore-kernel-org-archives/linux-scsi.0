Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED6AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 15:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345743AbiEaPbo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 11:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239001AbiEaPbn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 11:31:43 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54793271
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 08:31:41 -0700 (PDT)
Date:   Tue, 31 May 2022 17:31:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654011100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7FREbcwOrqto74ZUT8TXex2Yk5yLeYzeDM3FJWSDdjA=;
        b=kvDOJ6dDu14wIG8t01rGaRnyEpB3cnqTw4XbDadtE6U3NpZJ1JtldJlC8X1+kbxMdGkGPF
        RPJT9vB51fw3p+0pGI20x9md4qgo1YI9c/6jrSURQF8mJ8rOeyKPK4TcoSTLPHC299Qq1U
        CkL5CjiTEBdV1q6OLGDZD6MaP+kLv+Qx1uBSVEqTw/Cm6rJyuL+JJVmLHahdYCh/H2xIxz
        eWur2Qm1RxQ/MClqGeoTW/cAytDs4kn8jxOas/hGmBYOj4vDzadxghQM5ap7omTNYyhaK5
        qec2blypoEIRcQJ/tBXVrs0bKknucJBrb+aNEiErwQoGqFqPPLAV77dgUoyfiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654011100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7FREbcwOrqto74ZUT8TXex2Yk5yLeYzeDM3FJWSDdjA=;
        b=RBrBx0m6Pk3Pb0KU7UdWvhnfmRLjkwha7sBwlF64y4TLtbH+lviDRMX1A5+u1UOpAQHKV0
        PDQgwwLMQi7j7HCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     Davidlohr Bueso <dave@stgolabs.net>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ejb@linux.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 01/10] scsi/mvsas: Kill CONFIG_SCSI_MVSAS_TASKLET
Message-ID: <YpY02u8XaF2BljiS@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-2-dave@stgolabs.net>
 <17747966-ea44-ebe5-3d79-df7c33b6a16e@huawei.com>
 <20220531145231.opypdzrlrg23ihil@offworld>
 <5d28e848-0b9d-2aaa-e00e-7888342d25a7@huawei.com>
 <YpYxfSYDbCJEh9PG@linutronix.de>
 <0ebd951e-f047-1930-4ace-f5199921bf9a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0ebd951e-f047-1930-4ace-f5199921bf9a@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-31 16:26:26 [+0100], John Garry wrote:
> On 31/05/2022 16:17, Sebastian Andrzej Siewior wrote:
> > > Sorry, maybe I was not clear, but I was just asking if there was a good
> > > reason to disable interrupts at source while handling the interrupt, and not
> > > the change to stop using a tasklet.
> > Without reading the patch first: You need to disable the interrupt
> > source while the tasklet/ threaded interrupt is handled. Otherwise the
> > interrupt will keep coming and the tasklet/ threaded interrupt will have
> > no chance to make progress. So the box will lock up. This is often
> > overseen on fast machines because the interrupt needs a few usecs to
> > trigger and so the CPU is able to make a little bit of progress between
> > each trigger.
> > 
> 
> ah, so we would need IRQF_ONESHOT flag set to keep the interrupt line
> disabled until the threaded part completes, right?

This is one way of doing it and this is what threaded irqs do. However
this requires all handler to specify that option which is not very
compatible with shared handler.

> Thanks,
> John

Sebastian
