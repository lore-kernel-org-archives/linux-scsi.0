Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A0DC19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 09:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbiHKJ4Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 05:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbiHKJ4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 05:56:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808557AC26
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 02:56:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2AB0D3893B;
        Thu, 11 Aug 2022 09:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660211781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5gLNuyF9U1QaArKEHvS91t3vWtWrSEaZAt/j8lCUnqE=;
        b=tutuzK9nOeaN8yqid5xLod+t/EN3wI2JgHcMv+1sbKa2FF7jR8p1lDdxzXQKqXB20EkZTM
        OJx8hlLvHp19Y1WPjLqjgsPuzlf8ZfmFUFhzz7HnUaAWQ7SHlGJr3s3ZEHUfGKRlIcgJ10
        +vhrzfioFM9KuIbE16syvjRt1VAFpos=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D7B4C1342A;
        Thu, 11 Aug 2022 09:56:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id q0jyMkTS9GLIewAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 11 Aug 2022 09:56:20 +0000
Message-ID: <e4dd855269b2efb2e2f3efdde92f1f3339159878.camel@suse.com>
Subject: Re: [PATCH 3/4] scsi: Internally retry scsi_execute commands
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Hannes Reinecke <Hannes.Reinecke@suse.com>
Date:   Thu, 11 Aug 2022 11:56:20 +0200
In-Reply-To: <2b1943b2-466f-5674-1c8c-7db7b2dc4738@oracle.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
         <20220810034155.20744-4-michael.christie@oracle.com>
         <6149f7bdfa013e0352e59dee2669298b2c080a03.camel@suse.com>
         <2b1943b2-466f-5674-1c8c-7db7b2dc4738@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-08-10 at 12:06 -0500, Mike Christie wrote:
> On 8/10/22 5:46 AM, Martin Wilck wrote:
> > Hi Mike,
> >=20
> > On Tue, 2022-08-09 at 22:41 -0500, Mike Christie wrote:
> > > In several places like LU setup and pr_ops we will hit the
> > > noretry
> > > code
> > > path because we do not retry any passthrough commands that hit
> > > device
> > > errors even though scsi-ml thinks the command is retryable.
> > >=20
> > > This has us only fast fail commands that hit device errors that
> > > have
> > > been
> > > submitted through the block layer directly and not via
> > > scsi_execute.
> > > This
> > > allows SG IO and other users to continue to get fast failures and
> > > all
> > > device errors returned to them, and scsi_execute users will get
> > > their
> > > retries they had requested.
> > >=20
> > > Signed-off-by: Mike Christie <michael.christie@oracle.com>
> >=20
> > Thanks a lot. I like the general approach, but I am concerned that
> > by
> > treating every command sent by scsi_execute() or scsi_execute_req()
> > as
> > a retryable command, we may break some callers, or at least modify
> > their semantics in unexpected ways. For example, spi_execute(),
> > scsi_probe_lun(), scsi_report_lun_scan() currently retry only on
> > UA.
> > With this change, these commands will be retried in additional
> > cases,
> > without the caller noticing (see 949bf797595fc ("[SCSI] fix command
> > retries in spi_transport class"). It isn't obvious to me that this
> > is
> > correct in all affected cases.=A0
> Let's make sure we are on the same page, because I might agree with
> you.
> But for possible solutions we need to agree what this patch actually
> changes.
>=20
> We currently have 3 places we get retries from:
>=20
> 1. scsi_decide_disposition - For passthrough commands the patch only
> changes
> the behavior when scsi_decide_disposition gets NEED_RETRY, retries <
> allowed,
> and REQ_FAILFAST_DEV is not set.
>=20
> It's really specific and not as general as I think you thought it
> was.

I was aware of it, but I confused matters for some cases :-/

> 2. scsi_io_completion - Passthrough commands are never retried here.
>=20
> 3. scsi_execute users driving retries.

There's also the error handler retrying commands e.g. after a
successful abort. This is the DID_TIME_OUT case, actually -
scsi_decide_disposition() never calls scsi_noretry_cmd() for
DID_TIME_OUT.

> For your examples above:
> =A0
> - The scan/probe functions ask for 3 retries and so with patch1 we
> will now
> get 3 x 3 retries for errors that hit #1.
>=20
> So I agree this is really wrong for DID_TIME_OUT.
>=20
> - There is no behavior change for spi because it uses
> REQ_FAILFAST_DEV.

Overlooked that, thanks.

> >=20
> > Note that the retry logic of the mid level may change depending on
> > the
> > installed device handler. For example, ALUA devices will endlessly
> > retry UA with ASC=3D29, which some callers explicitly look for.
>=20
> There is no behavior change with my patch for ASC=3D29 case, because it
> uses ADD_TO_MLQUEUE and we don't run scsi_noretry_cmd for that error.

Right, thanks for pointing that out. I saw it but didn't realize what
it meant.

> It could change how 0x04/0x0a is handled because it uses NEEDS_RETRY.
> However, scsi_dh_alua uses REQ_FAILFAST_DEV so we do not retry in
> scsi_noretry_cmd like before.

Not quite following you here - alua_check_sense() is called for any
command, not just those submitted from the ALUA code.
>=20

> > I believe we need to review all callers that have their own retry
> > loop
> > and /or error handling logic. This includes sd_spinup_disk(),
> > sd_sync_cache(), scsi_test_unit_ready(). SCSI device handlers treat
> > some sense keys in special ways, or may retry commands on another
> > member of a port group (see alua_rtpg()).
>=20
> There is no change in behavior for the alua one but agree with the
> general
> comment.
>=20
> >=20
> > DID_TIME_OUT is a general concern - no current caller of
> > scsi_execute()
> > expects timed-out commands to be retried, and doing so has the
> > potential of slowing down operations a lot. I am aware that my
> > recent
> > patch changed exactly this for scsi_probe_lun(), but doing the same
> > thing for every scsi_execute() invocation sounds at least somewhat
> > dangerous.
>=20
> Agree this patch is wrong:
> - With patch1 that fixes scsi_cmnd->allowed we can end up with N and
> M
> DID_TIME_OUT retries and that can get crazy. So agree with that.
>=20
> - For the general idea of do we always want to retry DID_TIME_OUT, I
> can
> I also see your point.
>=20
> - After reading your mail and thinking about patch 4, I was thinking
> that
> this is wrong for patch 4 as well. For the pr_ops case we want the
> opposite
> of what you were mentioning in here. I actually want scsi-ml to retry
> all UAs for me or allow me to retry all UAs and not just handle the
> specific
> PGR related ones.
>=20
> I'm not sure where to go from here:
>=20
> 1. Just have the callers drive extra retries like we do now.
>=20
> I guess I've come around and are ok with this.

Me too, but I'm not sure about Christoph.

>=20
> With patch1, scsi_cmnd->allowed and scsi_execute works for me, so my
> previous comment about scsi_probe_lun needing to retry that case does
> not apply since scsi-ml will do it for me.
>=20
> I do think we need to retry your case in other places though.
>=20
> 2. Instead of trying to make it general for all scsi_execute_users,
> we can
> add SCMD bits for specific cases like DID_TIME_OUT or a SCMD bit that
> tells
> scsi_noretry_cmd to not always fail passthrough commands just because
> they
> are passthrough. It would work the opposite of the FASTFAIL bits
> where instead
> of failing fast, we retry.
>=20
> I think because the cases scsi_noretry_cmd is used for are really
> specific cases
> (scsi_decide_disposition sees NEEDS_RETRY, retries < allowed, and
> REQ_FAILFAST_DEV
> is not set) that might not be very useful.=A0

I don't think it's _that_ speficic. (retries < allowed) is the default
case, at least for the first failure. REQ_FAILFAST_DEV has very few
users except for the device handlers, and NEEDS_RETRY is a rather
frequently used disposition.

> I'm not sure we want to add a bunch of
> cases specific to scsi_execute callers to scsi_check_sense? I don't
> think we do.

If we don't want to fall back to 1. above, I think we can go a long way
with two additional flags for scsi_execute() callers:

 a) indicate whether DID_TIME_OUT should be retried by the error
handler (default: no),
 b) indicate whether UA (and NOT READY?) should be retried on the ML
(default: current behavior)

The rationale for b) is that (IIRC from yesterday's code inspection all
callers that check sense codes only define special cases for UA, or
some subcases of it.

Maybe we need also

 c) indicate whether the (don't) retry logic for SG_IO should be used.

> To be clear, I mean for this approach to be generally useful we would
> have to
> add the cases scsi_execute callers are retrying in scsi_check_sense.
> We could
> then remove the scsi_execute caller driven retries and only have
> scsi_decide_disposition
> retry.
>=20
> It sounded really nice at first, but to do that I would have a bunch
> of cases
> that might be specific to pr_ops, alua or scanning, etc. Then I also
> had cases where
> user1 does not want to retry but user2 did, so I have to add more
> SCMD bits. So, in
> the end it will get messier than you initially think.
>=20

I agree. I thought about passing a lookup table of sense keys (not) to
be retried to the ML, but it feels over-engineered to me.=20

Thanks
Martin

