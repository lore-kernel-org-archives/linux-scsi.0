Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0F3CD54AB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 09:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjISJHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 05:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjISJHU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 05:07:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2091CDA
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 02:07:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 285312271D;
        Tue, 19 Sep 2023 09:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1695114431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TaYHcIN2+j6ZnHw+ognCnCsy4RYnCE0LDzw3bdvnsbY=;
        b=fX7HoKO59XHY3E6n7bx4BhXBkU8vcwH016lmN+iwGJThwN96xZt0VA3EwLr9B+DRwoufgQ
        KwZq/qATmKCupH37GX5qS2Nb652FF5OQtLH/UISkjnirtX6Ea59uGmaEq4VX2cp4dJ7q17
        23xaUWafpFCX/ULUWdJU9S9m4DObzZ8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DAAE5134F3;
        Tue, 19 Sep 2023 09:07:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zYfMM75kCWUUIQAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 19 Sep 2023 09:07:10 +0000
Message-ID: <a4b2b991dbd7f9eef81feb9f6fa09850d0e299e7.camel@suse.com>
Subject: Re: [PATCH v11 07/34] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Tue, 19 Sep 2023 11:07:10 +0200
In-Reply-To: <e35f738c-b6d6-4e86-aa29-875b3629a0b7@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-8-michael.christie@oracle.com>
         <d3d8bc89e45708cde24912b497348f12c662f45f.camel@suse.com>
         <8d8cdaefa944afd3c478ffb77570cce53f7041c6.camel@suse.com>
         <64399d0e-dacb-4789-b37b-938a5e98eeee@oracle.com>
         <25a0b3bace532c5340196466f8a4194c9b8da473.camel@suse.com>
         <e35f738c-b6d6-4e86-aa29-875b3629a0b7@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-09-18 at 13:45 -0500, Mike Christie wrote:
> On 9/18/23 11:48 AM, Martin Wilck wrote:
> > On Sun, 2023-09-17 at 19:35 -0500, Mike Christie wrote:
> > > On 9/15/23 4:34 PM, Martin Wilck wrote:
> > > > On Fri, 2023-09-15 at 22:21 +0200, Martin Wilck wrote:
> > > > > On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> > > > > > This has read_capacity_16 have scsi-ml retry errors instead
> > > > > > of
> > > > > > driving
> > > > > > them itself.
> > > > > >=20
> > > > > > There are 2 behavior changes with this patch:
> > > > > > 1. There is one behavior change where we no longer retry
> > > > > > when
> > > > > > scsi_execute_cmd returns < 0, but we should be ok. We don't
> > > > > > need to
> > > > > > retry
> > > > > > for failures like the queue being removed, and for the case
> > > > > > where
> > > > > > there
> > > > > > are no tags/reqs since the block layer waits/retries for
> > > > > > us.
> > > > > > For
> > > > > > possible
> > > > > > memory allocation failures from blk_rq_map_kern we use
> > > > > > GFP_NOIO, so
> > > > > > retrying will probably not help.
> > > > > > 2. For the specific UAs we checked for and retried, we
> > > > > > would
> > > > > > get
> > > > > > READ_CAPACITY_RETRIES_ON_RESET retries plus whatever
> > > > > > retries
> > > > > > were
> > > > > > left
> > > > > > from the loop's retries. Each UA now gets
> > > > > > READ_CAPACITY_RETRIES_ON_RESET
> > > > > > reties, and the other errors (not including medium not
> > > > > > present)
> > > > > > get
> > > > > > up
> > > > > > to 3 retries.
> > > > >=20
> > > > > This is ok, but - just a thought - would it make sense to add
> > > > > a
> > > > > field
> > > > > for maximum total retry count (summed over all failures)?
> > > > > That
> > > > > would
> > > > > allow us to minimize behavior changes also in other cases.
> > > >=20
> > > > Could we perhaps use scmd->allowed for this purpose?
> > > >=20
> > > > I noted that several callers of scsi_execute_cmd() in your
> > > > patch
> > > > set
> > > > set the allowed parameter, e.g. to sdkp->max_retries in 07/34.
> > > > But allowed doesn't seem to be used at all in the passthrough
> > > > case,
> > >=20
> > > I think scmd->allowed is still used for errors that don't hit the
> > > check_type goto in scsi_no_retry_cmd.
> > >=20
> > > If the user sets up scsi failures for only UAs, and we got a
> > > DID_TRANSPORT_DISRUPTED then we we do scsi_cmd_retry_allowed
> > > which
> > > checks scmd->allowed.
> > >=20
> > > In scsi_noretry_cmd we then hit the:
> > >=20
> > > =A0=A0=A0=A0=A0=A0=A0 if (!scsi_status_is_check_condition(scmd->resul=
t))
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return false;
> > >=20
> > > and will retry.
> >=20
> > Right. But that's pretty confusing. Actually, I am confused about
> > some
> > other things as well.=A0
> >=20
> > I apologize for taking a step back and asking some more questions
> > and
> > presenting some more thoughts about your patch set as a whole.
> >=20
> > For passthrough commands, the simplified logic is now:
> >=20
> > scsi_decide_disposition()=20
> > {
> > =A0=A0=A0=A0=A0=A0=A0=A0 if (!scsi_device_online)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return SUCCESS;
> > =A0=A0=A0=A0=A0=A0=A0=A0 if ((rtn =3D scsi_check_passthrough(scmd)) !=
=3D
> > SCSI_RETURN_NOT_HANDLED)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rtn;
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0 /* handle host byte for regular commands,=A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 may return SUCESS, NEEDS_RETRY/ADD_TO=
_MLQUEUE,=A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 FAILED, fall through, or jump to mayb=
e_retry */
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0 /* handle status byte for regular commands, li=
kewise */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=20
> > =A0maybe_retry: /* [2] */
> > =A0=A0=A0=A0=A0=A0=A0=A0 if (scsi_cmd_retry_allowed(scmd) &&
> > !scsi_noretry_cmd(scmd))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NEEDS_RETRY;
> > =A0=A0=A0=A0=A0=A0=A0=A0 else
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return SUCCESS;
> > }
> >=20
> > where scsi_noretry_cmd() has special treatment for passthrough
> > commands
> > in certain cases (DID_TIME_OUT and CHECK_CONDITION).
> >=20
> > Because you put the call to scsi_check_passthrough() before the
> > standard checks, some retries that the mid layer used to do will
> > now
> > not be done if scsi_check_passthrough() returns SUCCESS. Also,
>=20
> Yeah, I did that on purpose to give scsi_execute_cmd more control
> over
> whether to retry or not. I think you are looking at this more like
> we want to be able to retry when scsi-ml decided not to.

I am not saying that giving the failure checks more control is wrong; I
lack experience to judge that. I was just pointing out a change in
behavior that wasn't obvious to me from the outset. IOW, I'd appreciate
a clear separation between the  formal change that moves failure
treatment for passthrough commands into the mid layer, and the semantic
changes regarding the ordering and precedence of the various cases in
scsi_decide_disposition().

> For example, I was thinking multipath related code like the scsi_dh
> handlers
> would want to fail for cases scsi-ml was currently retrying. Right
> now they
> are setting REQ_FAILFAST_TRANSPORT but for most drivers that's not
> doing what
> they think it does. Only DID_BUS_BUSY fast fails and I think the
> scsi_dh
> failover code wants other errors like DID_TRANSPORT_DISRUPTED to fail
> so the
> caller can decide based on something like the dm-multipath pg
> retries.

This makes sense for device handlers, but not so much for other
callers. Do we need to discuss a separate approach for commands sent by
device handlers?

Current device handlers have been written with the standard ML retry
handling in mind. The device handler changes in your patch set apply to
special CHECK CONDITION situations. These checks are executed before
the host byte checks in scsi_decide_disposition(). It's not obvious
from the code that none of these conditions can trigger if the host
byte is set [1], which would seem wrong. Perhaps we need separate
scsi_check_passthrough() handlers for host byte and status byte?

> > depending on the list of failures passed with the command, we might
> > miss the clauses in scsi_decide_disposition() where we previously
> > returned FAILED (I haven't reviewed the current callers, but at
> > least
> > in theory it can happen). This will obviously change the runtime
> > behavior, in ways I wouldn't bet can't be detrimental.
>=20
>=20
> I think it's reverse of what you are thinking for the FAILED case
> but I agree it's wrong (wrong but for different reasons).
>=20
> If scsi_decide_disposition returns FAILED then runtime is bad,
> because
> the scsi eh will start and then we have to wait for that.
>=20
> The scsi_execute_cmd user can now actually bypass the EH for FAILED
> so runtime will be shorter. However, I agree that it's wrong we can
> bypass the EH because in some cases we need to kick the device or
> cleanup cmds. So that should be fixed for sure and we should always
> start the EH and go through that code path.

Thanks for clarifying. I think I actually meant this, but my mind was
somewhat shady :-)

> >=20
> > Before your patch set, the checks we now do in
> > scsi_check_passthrough()
> > were only performed in the case where the "regular command checks"
> > returned SUCCESS. If we want as little behavior change as possible,
> > the
> > SUCCESS case is where we should plug in the call to
> > scsi_check_passthrough(). Or am I missing something? [1]
> >=20
> > This way we'd preserve the current semantics of "retries" and
> > "allowed"
> > which used to relate only to what were the "mid-layer retries"
> > before
> > your patch set.
>=20
> It looks like we had different priorities. I was trying to allow
> scsi_execute_cmd to be able to override scsi-ml retries, and not just
> allow
> us to retry if scsi-ml decided not to.

As I said above, I have nothing in general against this approach.
I would just like to separate it logically from the part of the patch
set that simply moves code from HL to ML. And obviously, changes in the
logic of scsi_decide_disposition() need in-depth review, if possible by
better qualified people than myself. I've stared at this code a lot of
times, but I wouldn't say I understand the entire decision tree.

> Given I messed up on the FAILED case above, I agree doing the less
> risky approach is better now. We can change it for multipath some
> other
> day.

AFAICT, dm-multipath + scsi device handlers are currently doing a
decent job. If we want improvements in this area, we should cover ALUA,
too, which would probably require a different approach, as the ALUA
handler's logic in alua_rtpg() can't be easily mapped to a "struct
failure" array.

>=20
> >=20
> > > > so we might as well use it as an upper limit for the total
> > > > number of
> > > > retries.
> > > >=20
> > >=20
> > > If you really want an overall retry count let me know. I can just
> > > add
> > > a total limit to the scsi_failures struct. You have been the only
> > > person
> > > to ask about it and it didn't sound like you were sure if you
> > > wanted it
> > > or not, so I haven't done it.
> >=20
> > The question whether we want an additional limit for the total
> > "failure
> > retry" count is orthogonal to the above. My personal opinion is
> > that we
> > do, as almost all call sites that I've seen in your set currently
> > use
> > just a single retry count for all failures they handle.
> >=20
> > I'm not sure whether the separate total retry count would have
> > practical relevance. I think that in most practical cases we won't
> > have
> > a mix of standard "ML" retries and multiple different failure
> > cases. I
> > suppose that in any given situation, it's more likely that there's
> > a
> > single error condition which repeats.
>=20
> I'm not sure what you are saying in the 2 paragraphs above.
>=20
> We have:
>=20
> 1. scsi_execute_cmd users like read_capacity_10 which will retry the
> device reset UA 10 times. Then it can retry that error 3 more time
> (this was probably not intentional so can be ignored) and it can
> retry
> any error other error except medium not present 3 times.
>=20
> And then it calls scsi_execute_cmd with sdkp->max_retries so the
> scsi-ml
> retried are whatever the user requested and 5 by default.
>=20
> I think we wanted to keep this behavior.

I don't object.=A0In this case, if we had a "total failure retries"
field, it would be set to infinity (or 13).

When I talked about a 'mix of standard "ML" retries and multiple
different failure cases' and its practical relevance, I had some weird
hypothetical devices in mind. Ignore it if you wish, or look at [2].

> 2.=A0 Then, for the initial device setup/discovery tests where the
> transport is
> flakey during device discovery/setup, we can hit the
> DID_TRANSPORT_DISRUPTED
> that multiple times, then we will get UAs after we relogin/reset the
> transport/device. So I think we want to keep the behavior where a
> user
> does
>=20
> +=A0=A0=A0=A0=A0=A0 struct scsi_failure failures[] =3D {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .sens=
e =3D UNIT_ATTENTION,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .asc =
=3D SCMD_FAILURE_ASC_ANY,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .ascq=
 =3D SCMD_FAILURE_ASCQ_ANY,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .allo=
wed =3D UA_RETRY_COUNT,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .resu=
lt =3D SAM_STAT_CHECK_CONDITION,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 },
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 {}
> +=A0=A0=A0=A0=A0=A0 };
>=20
>=20
> scsi_execute_cmd(.... $NORMAL_CMD_RETRIES)
>=20
> then we can retry transport errors NORMAL_CMD_RETRIES then once those
> settle still retry UAs UA_RETRY_COUNT times.

Yes, sure. I already agreed that we still need the standard "allowed"
field in its current form, and that we can't re-use it for failures.
In this case, with just one element in the failures array, a total
failure count wouldn't matter at all.
>=20
> 3. Then we have the cases where the scsi_execute_cmd user retried
> multiple errors and in this patchset we used to retry a total of N
> times, but now can retry each error up to N times. For this it sounds
> like you want to code it so we only do a total of N times so the
> behavior is the same as before.
>=20
> To handle all these I think I need the extra allowed field on the
> scsi_failures.
>=20

Right. My impression was that some callers wanted to limit the overall
number of retries. But it's difficult to say what the original
intention of the authors was, and how much thought they put into it in
the first place.

Martin

[1] I think that if the host byte is set we never have a CC status and
valid sense data. But the host byte is ultimately up to drivers, so
this is not obvious from the code, and hard to prove.

[2] My thinking was as follows: the e.g. for read_capacity_10(), the
SCSI result can be a) CC/UA/3a/00 (device reset, which read_capacity_10
will retry 10x), or b) some code that ML retries (e.g. CC/UA/04/01), or
c) anything else, which s_r_10 will retry 3x. Case b) used to be
retried up to 3*sdkp->max_retries times, while with your patch it will
only be retried sdkp->max_retries 1times.=20

It gets more confusing if you consider a device that would return these
error codes in an alternating fashion. Consider a device that returns
CC/UA/04/01, CC/UA/3a/00, CC/UA/04/01, CC/UA/3a/00,...
Previously, the CC/UA/04/01 would be hidden in the ML, because the ML
retry count would be reset with every call to scsi_execute_cmd(), and
CC/UA/3a/00 would be repeated 10x. Now, CC/UA/04/01 will use up retries
(first those from your SCMD_FAILURE_RESULT_ANY case, then the ML
retries) and eventually fail before the 10 retries for the device reset
case are exhausted. You can imagine out even more tricky scenarios.

This kind of weirdness is what I meant with 'a mix of standard "ML"
retries and multiple different failure cases'. Such cases are treated
differently now than they used to be. I wanted to point that out, and
at the same time I wanted to say that I doubt this has practical
relevance. *Real* devices will return CC/UA/3a/00 a couple of times in
a row, and then some other error, like you described.

