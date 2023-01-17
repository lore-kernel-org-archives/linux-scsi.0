Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4A5C00A5A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 22:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjAQWte (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 17:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjAQWrr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 17:47:47 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55AAB4E07;
        Tue, 17 Jan 2023 13:48:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E5704349D3;
        Tue, 17 Jan 2023 21:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673992123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ABmnaFOhAxeaDmI6GsVJDrQ8mjhYez5N9zWsCMIgoGA=;
        b=U4yhLR7qkErvYgdEnY05Z0ysZVo6hjuYMI2j6onrulZ0WmZmqaYjywGqX6E5GQLbV+d12v
        slZYTPS9ZRQojoaf5QD9gdduoexm7wKxN2Opp4l5MUmJX/f9ZY/cWvSLVifQlaTt0jRZPr
        Eo2Q/Db5g0Dz/JORYP9yVXYjHn5q3kk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 979791390C;
        Tue, 17 Jan 2023 21:48:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TTJcI7sXx2OWAwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 17 Jan 2023 21:48:43 +0000
Message-ID: <ab7d61dd7f7c0289114e36fef6e9f282ad5c976b.camel@suse.com>
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Steffen Maier <maier@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Date:   Tue, 17 Jan 2023 22:48:42 +0100
In-Reply-To: <c23a6bf4-0b6e-0bbb-b74d-af69756bcf9a@acm.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
         <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
         <a9da2b27-882f-bc8e-3400-cb53440e2159@acm.org>
         <125f247806396f19fd27dcfa71f530b5b4a529a6.camel@suse.com>
         <c23a6bf4-0b6e-0bbb-b74d-af69756bcf9a@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-01-17 at 10:50 -0800, Bart Van Assche wrote:
> On 1/17/23 01:28, Martin Wilck wrote:
> > On Mon, 2023-01-16 at 09:48 -0800, Bart Van Assche wrote:
> > > On 1/16/23 08:57, Martin Wilck wrote:
> > > > Can we simply defer the scsi_device_put() to a workqueue?
> > >=20
> > > I'm concerned that would reintroduce a race condition when LLD
> > > kernel
> > > modules are removed.
> >=20
> > I don't follow. Normally, alua_rtpg_queue() queues rtpg_work, and
> > alua_rtpg_work() will be called from the work queue and will
> > eventually
> > call scsi_device_put() when the RTPG is finished.
> >=20
> > alua_rtpg_queue() only calls scsi_device_put() if queueing
> > rtpg_work
> > fails[*]. If we deferred this scsi_device_put() call to a work
> > queue,
> > what would be the difference (wrt a module_put() race condition)
> > compared to the case where queue_delayed_work() succeeds?
> > In both cases, scsi_device_put() would be called from a work queue.
> >=20
> > Given that alua_rtpg_queue() must take a reference to the scsi
> > device
> > for the case that queueing succeeds, and that alua_rtpg_queue() is
> > sometimes called in atomic context, I think deferring the
> > scsi_device_put() call is the only option we have.
>=20
> Hi Martin,
>=20
> Before commit f93ed747e2c7 ("scsi: core: Release SCSI devices=20
> synchronously") the SCSI device release code could continue running=20
> asynchronously after the last module_put() call of the LLD associated
> with the SCSI device.
>=20
> Since commit f93ed747e2c7 it is guaranteed that freeing device memory
> (scsi_device_dev_release()) has finished before the last LLD=20
> module_put() call happens.
>=20
> Do you perhaps plan to defer the scsi_device_put() calls in the ALUA=20
> device handler to a workqueue?

Yes, that was my suggestion. Just defer the scsi_device_put() call in
alua_rtpg_queue() in the case where the actual RTPG handler is not
queued. I won't have time for that before next week though.

Martin

