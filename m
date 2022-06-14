Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C84C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 13:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245363AbiFNNZm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 09:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243101AbiFNNZl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 09:25:41 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98B13CFE2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2022 06:25:40 -0700 (PDT)
Date:   Tue, 14 Jun 2022 15:25:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1655213138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HgXa9L+iV+7zBfhKa3Rr0XV93bVTAQjox2YJMz4AHCM=;
        b=Aqgy5qT7mH48G22oPeVFUFgifa/KQqsaUyJQtY9dpXLWEPFTOvW4WqCjf3DvJcs8Gy27q2
        MEw27SJcu7teRJpWbVvSKDJU7s6Ft94EnzU1BPdJ5b0CvVE7WF9L+LJcaurg3TZOm+hRvC
        GNKUYFHgApG36uqPj/xkJANXu0b4bQWYMZfgMaMRZXz9l/rC9nFzTKv8Vw2c638s65E2WB
        8IlQBIil0o5Kl13wODCSU209ePbs7jrmGUqtt9BYn5vHMHIqDKJB7udj4S7RKvLs7/r1Od
        kL+T17cI6y1H9IOUkuuzDKMo0kbIIvL5BEHNhJkm9uF0Odf3D1guIOhyH60nBA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1655213138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HgXa9L+iV+7zBfhKa3Rr0XV93bVTAQjox2YJMz4AHCM=;
        b=EBE7d9+UYA5E++I4PSONdHMe8+Fit1/L+J9Q/EsQAzlhNCZCT47ZWw1HksPr1cDxxU/Qua
        YSVyfNd8EOeK/ACw==
From:   'Sebastian Andrzej Siewior' <bigeasy@linutronix.de>
To:     David Laight <David.Laight@aculab.com>
Cc:     Davidlohr Bueso <dave@stgolabs.net>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "ejb@linux.ibm.com" <ejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 09/10] scsi/ibmvscsi: Replace srp tasklet with work
Message-ID: <YqiMUS0IGtMgyQ6q@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-10-dave@stgolabs.net>
 <YqILmd/WnNT/zYrf@linutronix.de>
 <7faa88aaf7554545a60561d73597dc4f@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7faa88aaf7554545a60561d73597dc4f@AcuMS.aculab.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-06-09 15:46:04 [+0000], David Laight wrote:
> From: Sebastian Andrzej Siewior
> > Sent: 09 June 2022 16:03
> > 
> > On 2022-05-30 16:15:11 [-0700], Davidlohr Bueso wrote:
> > > Tasklets have long been deprecated as being too heavy on the system
> > > by running in irq context - and this is not a performance critical
> > > path. If a higher priority process wants to run, it must wait for
> > > the tasklet to finish before doing so.
> > >
> > > Process srps asynchronously in process context in a dedicated
> > > single threaded workqueue.
> > 
> > I would suggest threaded interrupts instead. The pattern here is the
> > same as in the previous driver except here is less locking.
> 
> How long do these actions runs for, and what is waiting for
> them to finish?

That is something that one with hardware and workload can answer.

> These changes seem to drop the priority from above that of the
> highest priority RT process down to that of a default priority
> user process.
> There is no real guarantee that the latter will run 'any time soon'.

Not sure I can follow. Using threaded interrupts will run at FIFO-50 by
default. Workqueue however is SCHED_OTHER. But then it is not bound to
any CPU so it will run on an available CPU.

> Consider some workloads I'm setting up where most of the cpu are
> likely to spend 90%+ of the time running processes under the RT
> scheduler that are processing audio.
> 
> It is quite likely that a non-RT thread (especially one bound
> to a specific cpu) won't run for several milliseconds.
> (We have to go through 'hoops' to avoid dropping ethernet frames.)
> 
> I'd have thought that some of these kernel threads really
> need to run at a 'middling' RT priority.

The threaded interrupts do this by default. If you run your own RT
threads you need to decide if they are more or less important than the
interrupts.

> 	David

Sebastian
