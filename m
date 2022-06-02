Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25081C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 07:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiFBH5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 03:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiFBH5q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 03:57:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACA0B48A
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 00:57:44 -0700 (PDT)
Date:   Thu, 2 Jun 2022 09:57:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654156661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HNB2gmZQp4LzQNhdOO5xVUZzTpAcrg79fKvfveVH+P0=;
        b=slc6HO6Nv216LSshlC3Utkw3ppj6aIX0DVFcijRLqnDwJIC2//6mBZrm87+EGnH3DqIAzE
        ti7Y7N91XgxKnJoWRZF1wvFJwme0VcH/45sBITxEBFI+EAEqxFW6iHydZ3ioPTw1CE5tF2
        CL2r2YqqkvzPvi9NnNESJr1Jajm7D0QkCynwcmMiK7PVVtUiCnE27jaF0+YSPdvvZ/XHZE
        GGXsPSeU4wJyuA2T1ZNNo5Vs6qcEw/+iwrHMd/jRw5R/dTPmmUe/t3nigIAxJtApcWd+48
        f3BDsKI03AgaoGrfS/11zZzZ7mSZa1cZrKKDO3KEWR4cjo3sLSFBOddtgxUjnw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654156661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HNB2gmZQp4LzQNhdOO5xVUZzTpAcrg79fKvfveVH+P0=;
        b=Y9sRMZ39S1Es7QfdW61fbNgb/lMNb0L1jemKIyQeILJZlMQmPOjxNlJk7MgTFrEMPAY4FW
        HzmkA0eQfQiQ4EAQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 00/10] scsi: Replace tasklets as BH
Message-ID: <YphtdGbu2rhx4RaQ@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220530231512.9729-1-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-30 16:15:02 [-0700], Davidlohr Bueso wrote:
> and thus are more important than all tasks on the system. Furthermore
> there are no guarantees it will run in irq context at all if ksoftirq
> kicks in.

They never run in IRQ context, they always run in softirq context. Even
if ksoftirqd kicks in, the callbacks (tasklets) are invoked in softirq
context.
That is sort of preemptible but in tasklet's case it will run/ complete
all callbacks before any kind of preemption can kick in.
So there is the lack of preemption for many/ long running callbacks and
the callbacks have no context/ owner which means there is no way of
preferring one over the other.

Sebastian
