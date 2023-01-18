Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E78DC32793
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 09:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjARJZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 04:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjARJVP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 04:21:15 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F265D7CF;
        Wed, 18 Jan 2023 00:45:07 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D43A120FA1;
        Wed, 18 Jan 2023 08:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674031505; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CIyN7YiA3+rbHPO3gNKdtnXqDTIaHQ4EqaEylgTiUjw=;
        b=gvm86aoL8qAYmMDskwMmKjCPebC9lqw8dk2SWIgXVxfxEAsUeEBOqehqHvFA1QPZaYRqfx
        bJSkmwAV3Su9fK4AC5/OwM2sIG4lRbjKrbhi3UyufBTihij+wecXzmqFDJu5uZfiEhySS5
        bcV5wVsTvqawNgwVifNm6R0miUTlX6o=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 887D4138FE;
        Wed, 18 Jan 2023 08:45:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eXrcH5Gxx2NnIQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 18 Jan 2023 08:45:05 +0000
Message-ID: <58cc11efc62bd81da323f17a19ac021456c6fc7f.camel@suse.com>
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
Date:   Wed, 18 Jan 2023 09:45:04 +0100
In-Reply-To: <08e7e15e-37e0-0d45-9332-fe4b6e896cb2@acm.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
         <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
         <a9da2b27-882f-bc8e-3400-cb53440e2159@acm.org>
         <125f247806396f19fd27dcfa71f530b5b4a529a6.camel@suse.com>
         <c23a6bf4-0b6e-0bbb-b74d-af69756bcf9a@acm.org>
         <ab7d61dd7f7c0289114e36fef6e9f282ad5c976b.camel@suse.com>
         <2bea9c3e-2a61-a51e-c13b-796adabe6f71@acm.org>
         <983f47533ee56b2a954de97dc7e02cbcbc4f9841.camel@suse.com>
         <08e7e15e-37e0-0d45-9332-fe4b6e896cb2@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-01-17 at 16:29 -0800, Bart Van Assche wrote:
> On 1/17/23 14:03, Martin Wilck wrote:
> > On Tue, 2023-01-17 at 13:52 -0800, Bart Van Assche wrote:
> > > On 1/17/23 13:48, Martin Wilck wrote:
> > > > Yes, that was my suggestion. Just defer the scsi_device_put()
> > > > call
> > > > in
> > > > alua_rtpg_queue() in the case where the actual RTPG handler is
> > > > not
> > > > queued. I won't have time for that before next week though.
> > >=20
> > > Hi Martin,
> > >=20
> > > Do you agree that the call trace shared by Steffen is not
> > > sufficient
> > > to
> > > conclude that this change is necessary?
> >=20
> > Hmm, I suppose I missed your point... to re-iterate my thinking:
> >=20
> > =A0 1 alua_queue_rtpg() must take a ref to the sdev before queueing
> > work,
> > =A0=A0=A0 whether or not the caller already has one
> > =A0 2 queue_delayed_work() can fail
> > =A0 3 if queue_delayed_work() fails, alua_queue_rtpg() must drop the
> > ref
> > =A0=A0=A0 it just took
> > =A0 4 BUT (and this is what I guess I missed) this ref can't be the
> > last
> > =A0=A0=A0 one dropped, because the caller of alua_rtpg_queue() must sti=
ll
> > hold
> > =A0=A0=A0 a reference. And scsi_device_put() only sleeps if the last re=
f
> > is
> > =A0=A0=A0 dropped. Therefore the issue in Steffen's call stack should
> > =A0=A0=A0 indeed be fixed just by removing the might_sleep(). If all
> > callers
> > =A0=A0=A0 callers of alua_rtpg_queue() must hold an sdev reference (I
> > believe
> > =A0=A0=A0 they do), we can indeed remove the might_sleep() entirely.
> >=20
> > Is this correct reasoning, and what you meant previously? If yes, I
> > agree, and I apologize for not realizing it in the first place.
> > But I think this is subtle enough to deserve a comment in the code.
>=20
> Yes, that's what I'm thinking.
>=20
> How about the patch below?
>=20
> Thanks,
>=20
> Bart.
>=20
> [PATCH] scsi: device_handler: alua: Remove a might_sleep() annotation
>=20
> The might_sleep() annotation in alua_rtpg_queue() is not correct
> since the
> command completion code may call this function from atomic context.
> Calling alua_rtpg_queue() from atomic context in the command
> completion
> path is fine since request submitters must hold an sdev reference
> until
> command execution has completed. This patch fixes the following
> kernel
> warning:
>=20
> BUG: sleeping function called from invalid context at
> drivers/scsi/device_handler/scsi_dh_alua.c:992
> Call Trace:
> =A0 dump_stack_lvl+0xac/0x100
> =A0 __might_resched+0x284/0x2c8
> =A0 alua_rtpg_queue+0x3c/0x98 [scsi_dh_alua]
> =A0 alua_check+0x122/0x250 [scsi_dh_alua]
> =A0 alua_check_sense+0x172/0x228 [scsi_dh_alua]
> =A0 scsi_check_sense+0x8a/0x2e0
> =A0 scsi_decide_disposition+0x286/0x298
> =A0 scsi_complete+0x6a/0x108
> =A0 blk_complete_reqs+0x6e/0x88
> =A0 __do_softirq+0x13e/0x6b8
> =A0 __irq_exit_rcu+0x14a/0x170
> =A0 irq_exit_rcu+0x22/0x50
> =A0 do_ext_irq+0x10a/0x1d0
>=20
> Reported-by: Steffen Maier <maier@linux.ibm.com>
> Cc: Steffen Maier <maier@linux.ibm.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>


Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0 drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++--
> =A0 1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 55a5073248f8..362fa631f39b 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -987,6 +987,9 @@ static void alua_rtpg_work(struct work_struct
> *work)
> =A0=A0 *
> =A0=A0 * Returns true if and only if alua_rtpg_work() will be called
> asynchronously.
> =A0=A0 * That function is responsible for calling @qdata->fn().
> + *
> + * Context: may be called from atomic context (alua_check()) only if
> the caller
> + *=A0=A0=A0=A0=A0holds an sdev reference.
> =A0=A0 */
> =A0 static bool alua_rtpg_queue(struct alua_port_group *pg,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 struct scsi_device *sdev,
> @@ -995,8 +998,6 @@ static bool alua_rtpg_queue(struct
> alua_port_group *pg,
> =A0=A0=A0=A0=A0=A0=A0=A0int start_queue =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned long flags;
>=20
> -=A0=A0=A0=A0=A0=A0=A0might_sleep();
> -
> =A0=A0=A0=A0=A0=A0=A0=A0if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
>=20
>=20

