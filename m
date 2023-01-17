Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864FCC38147
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 22:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjAQWZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 17:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjAQWYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 17:24:02 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDE065ECA;
        Tue, 17 Jan 2023 14:03:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 05C4634469;
        Tue, 17 Jan 2023 22:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673993005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cNlI+9UfYWFV0uaPvoECFFSdv2wmbsdPyIUgQd9knbY=;
        b=PjrYgDT9wxvvYd/YDARNXxg/aCtgXm5tG+TXHfURfJw3vTLOtWAS7lMb9ND1gP0I93OH6C
        G5QqMyEYqD2IVFJXN7Obzv08misoTK0zuHbZFUBQKcldT/Jvu8DGo05EMG7fivhrpeZVl+
        aIJEKCh4CC6ufxQspXOTJxQefX645hI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B02C513357;
        Tue, 17 Jan 2023 22:03:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lMl5KSwbx2NNCgAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 17 Jan 2023 22:03:24 +0000
Message-ID: <983f47533ee56b2a954de97dc7e02cbcbc4f9841.camel@suse.com>
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
Date:   Tue, 17 Jan 2023 23:03:24 +0100
In-Reply-To: <2bea9c3e-2a61-a51e-c13b-796adabe6f71@acm.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
         <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
         <a9da2b27-882f-bc8e-3400-cb53440e2159@acm.org>
         <125f247806396f19fd27dcfa71f530b5b4a529a6.camel@suse.com>
         <c23a6bf4-0b6e-0bbb-b74d-af69756bcf9a@acm.org>
         <ab7d61dd7f7c0289114e36fef6e9f282ad5c976b.camel@suse.com>
         <2bea9c3e-2a61-a51e-c13b-796adabe6f71@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-01-17 at 13:52 -0800, Bart Van Assche wrote:
> On 1/17/23 13:48, Martin Wilck wrote:
> > Yes, that was my suggestion. Just defer the scsi_device_put() call
> > in
> > alua_rtpg_queue() in the case where the actual RTPG handler is not
> > queued. I won't have time for that before next week though.
>=20
> Hi Martin,
>=20
> Do you agree that the call trace shared by Steffen is not sufficient
> to=20
> conclude that this change is necessary?

Hmm, I suppose I missed your point... to re-iterate my thinking:

 1 alua_queue_rtpg() must take a ref to the sdev before queueing work,
   whether or not the caller already has one
 2 queue_delayed_work() can fail
 3 if queue_delayed_work() fails, alua_queue_rtpg() must drop the ref
   it just took
 4 BUT (and this is what I guess I missed) this ref can't be the last
   one dropped, because the caller of alua_rtpg_queue() must still hold
   a reference. And scsi_device_put() only sleeps if the last ref is
   dropped. Therefore the issue in Steffen's call stack should
   indeed be fixed just by removing the might_sleep(). If all callers
   callers of alua_rtpg_queue() must hold an sdev reference (I believe=A0
   they do), we can indeed remove the might_sleep() entirely.

Is this correct reasoning, and what you meant previously? If yes, I
agree, and I apologize for not realizing it in the first place.=A0
But I think this is subtle enough to deserve a comment in the code.

Thanks
Martin

