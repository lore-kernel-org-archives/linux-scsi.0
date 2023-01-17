Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38118C63797
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 09:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbjAQJas (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 04:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbjAQJaV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 04:30:21 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E809B222C3;
        Tue, 17 Jan 2023 01:28:59 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8DBE738255;
        Tue, 17 Jan 2023 09:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673947738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1CvSo/qSedgiSECxhcO0fwxvcSz9JJSCrPUIUeJbKqo=;
        b=Bfznrds3fbAuPH9iFRLwyAjb2SChkFG2uzmhWRp/YX2oj/Ol3qG99UOlXpRYp6L2yWzwKm
        PUAtcdZ0q5n/pFADl3g5uEQt2B1nwRQBdkzmOAz7KAWIHqTn/uwRNeGUK2gBxtnlvfYf3k
        G4SeKKeWiTTngJ1Uc4UhXYyptLcCQJc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 442CC13357;
        Tue, 17 Jan 2023 09:28:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id a4obD1pqxmNceQAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 17 Jan 2023 09:28:58 +0000
Message-ID: <125f247806396f19fd27dcfa71f530b5b4a529a6.camel@suse.com>
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
Date:   Tue, 17 Jan 2023 10:28:57 +0100
In-Reply-To: <a9da2b27-882f-bc8e-3400-cb53440e2159@acm.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
         <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
         <a9da2b27-882f-bc8e-3400-cb53440e2159@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bart,

On Mon, 2023-01-16 at 09:48 -0800, Bart Van Assche wrote:
> On 1/16/23 08:57, Martin Wilck wrote:
> > Can we simply defer the scsi_device_put() to a workqueue?
>=20
> I'm concerned that would reintroduce a race condition when LLD kernel
> modules are removed.

I don't follow. Normally, alua_rtpg_queue() queues rtpg_work, and
alua_rtpg_work() will be called from the work queue and will eventually
call scsi_device_put() when the RTPG is finished.

alua_rtpg_queue() only calls scsi_device_put() if queueing rtpg_work
fails[*]. If we deferred this scsi_device_put() call to a work queue,
what would be the difference (wrt a module_put() race condition)
compared to the case where queue_delayed_work() succeeds?=A0
In both cases, scsi_device_put() would be called from a work queue.

Given that alua_rtpg_queue() must take a reference to the scsi device
for the case that queueing succeeds, and that alua_rtpg_queue() is
sometimes called in atomic context, I think deferring the
scsi_device_put() call is the only option we have.

Thanks,
Martin

[*] or if queueing turns out to be unnecessary, in which case we could
optimize away the scsi_device_get() call.

