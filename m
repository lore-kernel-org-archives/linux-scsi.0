Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F5EC46CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjIRQtQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjIRQtB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:49:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7431FF1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:48:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 751C51FFFF;
        Mon, 18 Sep 2023 16:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1695055714; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xco0lnMR3wNhgKgILr5O2KQeOWnOxDhGJEKpIjnnZaw=;
        b=KLeAq2Cza1MF7CGyw7ESm3NX9/8GRErt/3sV6rO7EXbF9OcVLXxMfkGNtOS0ULq1BlPJwL
        lZIRWv/pT0CfjD9DyVBZ4UAtisXpU0hmXHb0GFcmHiDFKbH28gx+Ye2QC1v38CVIBQGobi
        yncwmyplAiYP62B4RXJVSp4soGwxqLA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3391B1358A;
        Mon, 18 Sep 2023 16:48:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pz0IC2J/CGX0BQAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 18 Sep 2023 16:48:34 +0000
Message-ID: <25a0b3bace532c5340196466f8a4194c9b8da473.camel@suse.com>
Subject: Re: [PATCH v11 07/34] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Mon, 18 Sep 2023 18:48:33 +0200
In-Reply-To: <64399d0e-dacb-4789-b37b-938a5e98eeee@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-8-michael.christie@oracle.com>
         <d3d8bc89e45708cde24912b497348f12c662f45f.camel@suse.com>
         <8d8cdaefa944afd3c478ffb77570cce53f7041c6.camel@suse.com>
         <64399d0e-dacb-4789-b37b-938a5e98eeee@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2023-09-17 at 19:35 -0500, Mike Christie wrote:
> On 9/15/23 4:34 PM, Martin Wilck wrote:
> > On Fri, 2023-09-15 at 22:21 +0200, Martin Wilck wrote:
> > > On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> > > > This has read_capacity_16 have scsi-ml retry errors instead of
> > > > driving
> > > > them itself.
> > > >=20
> > > > There are 2 behavior changes with this patch:
> > > > 1. There is one behavior change where we no longer retry when
> > > > scsi_execute_cmd returns < 0, but we should be ok. We don't
> > > > need to
> > > > retry
> > > > for failures like the queue being removed, and for the case
> > > > where
> > > > there
> > > > are no tags/reqs since the block layer waits/retries for us.
> > > > For
> > > > possible
> > > > memory allocation failures from blk_rq_map_kern we use
> > > > GFP_NOIO, so
> > > > retrying will probably not help.
> > > > 2. For the specific UAs we checked for and retried, we would
> > > > get
> > > > READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries
> > > > were
> > > > left
> > > > from the loop's retries. Each UA now gets
> > > > READ_CAPACITY_RETRIES_ON_RESET
> > > > reties, and the other errors (not including medium not present)
> > > > get
> > > > up
> > > > to 3 retries.
> > >=20
> > > This is ok, but - just a thought - would it make sense to add a
> > > field
> > > for maximum total retry count (summed over all failures)? That
> > > would
> > > allow us to minimize behavior changes also in other cases.
> >=20
> > Could we perhaps use scmd->allowed for this purpose?
> >=20
> > I noted that several callers of scsi_execute_cmd() in your patch
> > set
> > set the allowed parameter, e.g. to sdkp->max_retries in 07/34.
> > But allowed doesn't seem to be used at all in the passthrough case,
>=20
> I think scmd->allowed is still used for errors that don't hit the
> check_type goto in scsi_no_retry_cmd.
>=20
> If the user sets up scsi failures for only UAs, and we got a
> DID_TRANSPORT_DISRUPTED then we we do scsi_cmd_retry_allowed which
> checks scmd->allowed.
>=20
> In scsi_noretry_cmd we then hit the:
>=20
> =A0=A0=A0=A0=A0=A0=A0 if (!scsi_status_is_check_condition(scmd->result))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return false;
>=20
> and will retry.

Right. But that's pretty confusing. Actually, I am confused about some
other things as well.=A0

I apologize for taking a step back and asking some more questions and
presenting some more thoughts about your patch set as a whole.

For passthrough commands, the simplified logic is now:

scsi_decide_disposition()=20
{
         if (!scsi_device_online)
                return SUCCESS;
         if ((rtn =3D scsi_check_passthrough(scmd)) !=3D SCSI_RETURN_NOT_HA=
NDLED)
                return rtn;

         /* handle host byte for regular commands,=A0
            may return SUCESS, NEEDS_RETRY/ADD_TO_MLQUEUE,=A0
            FAILED, fall through, or jump to maybe_retry */

         /* handle status byte for regular commands, likewise */
         =20
 maybe_retry: /* [2] */
         if (scsi_cmd_retry_allowed(scmd) && !scsi_noretry_cmd(scmd))
                return NEEDS_RETRY;
         else
                return SUCCESS;
}

where scsi_noretry_cmd() has special treatment for passthrough commands
in certain cases (DID_TIME_OUT and CHECK_CONDITION).

Because you put the call to scsi_check_passthrough() before the
standard checks, some retries that the mid layer used to do will now
not be done if scsi_check_passthrough() returns SUCCESS. Also,
depending on the list of failures passed with the command, we might
miss the clauses in scsi_decide_disposition() where we previously
returned FAILED (I haven't reviewed the current callers, but at least
in theory it can happen). This will obviously change the runtime
behavior, in ways I wouldn't bet can't be detrimental.

Before your patch set, the checks we now do in scsi_check_passthrough()
were only performed in the case where the "regular command checks"
returned SUCCESS. If we want as little behavior change as possible, the
SUCCESS case is where we should plug in the call to
scsi_check_passthrough(). Or am I missing something? [1]

This way we'd preserve the current semantics of "retries" and "allowed"
which used to relate only to what were the "mid-layer retries" before
your patch set.

> > so we might as well use it as an upper limit for the total number of
> > retries.
> >=20
>=20
> If you really want an overall retry count let me know. I can just add
> a total limit to the scsi_failures struct. You have been the only person
> to ask about it and it didn't sound like you were sure if you wanted it
> or not, so I haven't done it.

The question whether we want an additional limit for the total "failure
retry" count is orthogonal to the above. My personal opinion is that we
do, as almost all call sites that I've seen in your set currently use
just a single retry count for all failures they handle.

I'm not sure whether the separate total retry count would have
practical relevance. I think that in most practical cases we won't have
a mix of standard "ML" retries and multiple different failure cases. I
suppose that in any given situation, it's more likely that there's a
single error condition which repeats.

I'm also unsure whether all this theoretical reasoning of mine warrants
you putting even more effort into this patch set, which has seen 11
revisions already. In general, you have much more experience with SCSI
error handling than I do.

Martin


[1] If we did that, we'd could also take into account that previously
the caller would have called scsi_execute_cmd() again, which would have
reset cmd->retries; so we could reset this field if
scsi_check_passthrough() decides to retry the command.

[2] It's weird, although unrelated to your patch set, that in the
maybe_retry clause we increment cmd->retries before checking
scsi_noretry_cmd().




