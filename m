Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B980C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 11:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjFLLhT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 07:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjFLLgj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 07:36:39 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0153C1708;
        Mon, 12 Jun 2023 04:15:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B633A1FED7;
        Mon, 12 Jun 2023 11:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686568523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uV8gfOHNoty7LIUzvG3FLkKQz6YIw9I8wGaNW/Cgnfk=;
        b=OjaFRAHXVApnkEoO+JYsE9j80+6hp3FBWMCcwPOdIXv0aunL35c1c/13RZNLKilZacUEK6
        gxT3sZseyPYCjK6a6hevn8FLpzULDxJ963v3inja8c/zqoDuNL0bLnyem8LJ1yDV89KDgB
        VbBHLQZc0bUitn4hnmrtOn+gZzK596Q=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 56C8F138EC;
        Mon, 12 Jun 2023 11:15:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zt5mE0v+hmSJQQAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 12 Jun 2023 11:15:23 +0000
Message-ID: <2bfdb9a65668109c204f7d4677bd717f049b1e83.camel@suse.com>
Subject: Re: [PATCH v3 4/8] scsi: call scsi_stop_queue() without state_mutex
 held
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Date:   Mon, 12 Jun 2023 13:15:22 +0200
In-Reply-To: <dcef340d-0b43-42d3-0e1c-a96cd90283d3@oracle.com>
References: <20230607182249.22623-1-mwilck@suse.com>
         <20230607182249.22623-5-mwilck@suse.com>
         <3b8b13bf-a458-827a-b916-07d7eee8ae00@acm.org>
         <50cb1a5bd501721d7c816b1ca8bf560daa8e3cc9.camel@suse.com>
         <ff669f59e3c42e5dec4920d705e2b8748ad600d5.camel@suse.com>
         <20230608054444.GB11554@lst.de>
         <5be7eebb-f734-1a0a-9f97-1b3534bc26ac@acm.org>
         <dcef340d-0b43-42d3-0e1c-a96cd90283d3@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2023-06-08 at 13:54 -0500, Mike Christie wrote:
> On 6/8/23 9:12 AM, Bart Van Assche wrote:
> > On 6/7/23 22:44, Christoph Hellwig wrote:
> > > > > Thanks. This wasn't obvious to me from the current code. I'll
> > > > > add a
> > > > > comment in the next version.
> > > >=20
> > > > The crucial question is now, is it sufficient to call
> > > > blk_mq_quiesce_queue_nowait() under the mutex, or does the call
> > > > to
> > > > blk_mq_wait_quiesce_done() have to be under the mutex, too?
> > > > The latter would actually kill off our attempt to fix the delay
> > > > in fc_remote_port_delete() that was caused by repeated
> > > > synchronize_rcu() calls.
> > > >=20
> > > > But if I understand you correctly, moving the wait out of the
> > > > mutex
> > > > should be ok. I'll update the series accordingly.
> > >=20
> > > I can't think of a reason we'd want to lock over the wait, but
> > > Bart
> > > knows this code way better than I do.
> >=20
> > Unless deep changes would be made in the block layer
> > blk_mq_quiesce_queue_nowait() and/or blk_mq_wait_quiesce_done()
> > functions, moving blk_mq_wait_quiesce_done() outside the critical
> > section seems fine to me.
>=20
> If it helps, I tested with iscsi and the mutex changes discussed
> above
> and it worked ok for me.

I guess the race that Bart was hinting at is hard to trigger.

I would like to remark that the fact that we need to hold the SCSI
state_mutex while calling blk_mq_quiesce_queue_nowait() looks like a
layering issue to me. Not sure if, and how, this could be avoided,
though.

Regards
Martin

