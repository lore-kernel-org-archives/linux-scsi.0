Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B79C47071
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 17:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjKPR6A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 12:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjKPR57 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 12:57:59 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857CEB8
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 09:57:55 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E7B34228EA;
        Thu, 16 Nov 2023 17:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1700157473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=sV3wZOgBMuglLO0B4Qe8uMfTB2DtVz84i/xdD27nwgs=;
        b=rePzNM+nW1ns5wDCWjyJ0EVnNkOaVkmdP1kwan+tVc87MvRWNhMW0MNxjoXx0vVEf38PJT
        xU3rmnAx17/9DFClNLJEPjLlKyfevfBJLzA4RCLx8W5np8S3f/nLtlJjOJx8tzNe4L4JwL
        SpMqLa5ipw0Uft1CvVuOyrUNFzrsau0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F344139C4;
        Thu, 16 Nov 2023 17:57:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id G9ARHyFYVmVNKAAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 16 Nov 2023 17:57:53 +0000
Message-ID: <62a980a72bdea399e056306d6452ea945df8c35c.camel@suse.com>
Subject: Re: [PATCH v12 04/20] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Thu, 16 Nov 2023 18:57:52 +0100
In-Reply-To: <5ac4a93d-4aee-4378-a93f-a8b00293b00b@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
         <20231114013750.76609-5-michael.christie@oracle.com>
         <89938a66-7203-4809-8d45-c820b5a21d4c@oracle.com>
         <5ac4a93d-4aee-4378-a93f-a8b00293b00b@oracle.com>
Autocrypt: addr=mwilck@suse.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 
MIME-Version: 1.0
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [-4.30 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_HAM_LONG(-1.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[suse.com:s=susede1];
         NEURAL_HAM_SHORT(-0.20)[-0.995];
         RCPT_COUNT_SEVEN(0.00)[7];
         FUZZY_BLOCKED(0.00)[rspamd.com];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2023-11-16 at 11:15 -0600, Mike Christie wrote:
> On 11/16/23 5:39 AM, John Garry wrote:
> > On 14/11/2023 01:37, Mike Christie wrote:
> >=20
> > Feel free to pick up:
> > Reviewed-by: John Garry <john.g.garry@oracle.com>
> >=20
> > > +=A0=A0=A0 the_result =3D scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> > > buffer,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 RC16=
_LEN, SD_TIMEOUT, sdkp->max_retries,
> >=20
> > BTW, some might find it a little confusing that we have
> > scsi_execute_cmd() retries arg as well as being able to pass
> > exec_args.failure, and exec_args.failure may allow us to retry.
> > Could this be improved, even in terms of arg or struct member
> > naming/comments?
>=20
> Will add some comments.
>=20
> Martin W, if you are going to ask about this again, the answer is
> that
> in a future patchset, we can kill the reties passed directly into
> scsi_execute_cmd.
>=20

Did I ask about this? ... I dimly remember ;-)

> We could make scsi_decide_disposition's failures an array of
> scsi_failure structs that gets checked in scsi_decide_disposition
> and scsi_check_passthrough. We would need to add a function callout
> to the scsi_failure struct for some of the more complicated failure
> handling. That could then be used for some of the other
> scsi_execute_cmd
> cases as well. For the normal/fast path case though we would need
> something to avoid function pointers.

I am not sure if I like this idea. scsi_decide_disposition() is
challenging to read already. I am not convinced that converting it into
a loop over "struct scsi_failure" would make it easier to understand.
I guess we'd need to see how it would look like.=20

To my understanding,=A0the two retry counts are currently orthogonal, the
one in scsi_execute_cmd() representing the standard mid-layer
"maybe_retry" case in scsi_decide_disposition, and the the other one
representing the additional "high level" passthrough retry. We need to
be careful when merging them.

Wrt the callout, I'd actually thought about that when looking at your
previous set, but I didn't want to interfere too much. I thought that
using callouts might simplify the scsi_failure handling, and might
actually make the new code easier to read. I can't judge possible
effects on performance.

Cheers,
Martin

