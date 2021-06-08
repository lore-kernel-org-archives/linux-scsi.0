Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6322EC47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 00:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47EDB61182
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 00:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFHAFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhFHAFJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 20:05:09 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C3CC061574
        for <linux-scsi@vger.kernel.org>; Mon,  7 Jun 2021 17:03:14 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id o9so12281473pgd.2
        for <linux-scsi@vger.kernel.org>; Mon, 07 Jun 2021 17:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qxNUdxDIXHt94LFZpYu8CYN+2jv//VnDFV9+Y/4Ijog=;
        b=kwFfQ9pLRU5G/1Hrso/6vqPxIQH615+FgY2BzSCXEy56nXqxPVFQuimTwYeGNCXzR9
         3T78BZM79FDE7WybjuGjYYPqXv0NB2ILfZ0ry/a9GqBFbBFqf9eshdw+CfexhO96N/p4
         lnlCMTJ6bd0KeUlYwhnY0nek6ovimSsoX5cCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qxNUdxDIXHt94LFZpYu8CYN+2jv//VnDFV9+Y/4Ijog=;
        b=iGJhkK/oFqcpLe2HTz98kejFjR3BiR7zstO7qTGEAARxWUr0JMpqqgvRBHra2M/N8S
         kb+O9a+OI0Iz4cbkOjaefeb5f+6zAEalcHxzL6I9gnArK8Q2/LZAc15Te9Mi9gZPNtIM
         y/VxdOedLZmLxqvdDQY1v8ydGk53QOdYVIq7Ow0EKDNvrs841uHXFW9PJp2xppJZKDfu
         w36LN8KlXYhJX569KoY6smaU9ygkSpwZQgWZ4EmFAFqmoZ0xaVgrPS/8Xveg6K+beD+E
         /v6Gi4Md6xs0CEyWWZKcaX5MtX5tkAygErpXc8i8TYAr37PtHXbF9XWK0JBJiJ13y5rK
         nLQA==
X-Gm-Message-State: AOAM533wvOrsjFdjZvDw0vYWRwiPjnzDdWmGZn6f3xNOn3v8nrI6HhB0
        ZT5wFKMFOuaArkamG1bcfWsQ8A==
X-Google-Smtp-Source: ABdhPJw4vwYrKHBdEIVWhoYVU3yKZyOXcrBtMoTQiWA1iLcG12cbeKuaXvvYvMBKrfaQ2SDZSjwdJg==
X-Received: by 2002:aa7:947d:0:b029:2ea:1b56:3acb with SMTP id t29-20020aa7947d0000b02902ea1b563acbmr19393455pfq.68.1623110593850;
        Mon, 07 Jun 2021 17:03:13 -0700 (PDT)
Received: from smtpclient.apple ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id x6sm9327066pfd.173.2021.06.07.17.03.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jun 2021 17:03:13 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.1\))
Subject: Re: [PATCH 1/1]: scsi scsi_dh_alua: don't fail I/O until transition
 time expires
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <23d45b9e-2c56-d637-dd2f-ea5a1ef267ac@suse.de>
Date:   Mon, 7 Jun 2021 17:03:10 -0700
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <27C07B47-22C8-4447-BB09-1386C64C21A0@purestorage.com>
References: <622E6257-85C7-4F9B-9CCD-2EF1791CB21F@purestorage.com>
 <23d45b9e-2c56-d637-dd2f-ea5a1ef267ac@suse.de>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3654.120.0.1.1)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Do not return an error to multipath which will result in a failed path =
until the \
> transition time expires.=20
> The current patch which returns BLK_STS_AGAIN for ALUA transitioning =
breaks the \
> assumptions in our target regarding ALUA states. With that change an =
error is very \
> quickly returned to multipath which in turn immediately fails the =
path. The \
> assumption in that patch seems to be that another path will be =
available for \
> multipath to use. That assumption I don't believe is fair to make =
since while one \
> path is in a transitioning state it is reasonable to assume that other =
paths may \
> also be in non active states. =20

> I beg to disagree. Path groups are nominally independent, and might
> change states independent on the other path groups.
> While for some arrays a 'transitioning' state is indeed system-wide,
> other arrays might be able to serve I/O on other paths whilst one is =
in
> transitioning.
> So I'd rather not presume anything here.

I agree. No problem there. Our array could and does return transitioning =
on
some portal groups while others might be active/online or unavailable.

> As outlined above, we cannot assume that all paths will be set to
> 'transitioning' once we hit the 'transitioning' condition on one path.
> As such, we need to retry the I/O on other paths, to ensure failover
> does work in these cases. Hence it's perfectly okay to set this path =
to
=E2=80=98> failed' as we cannot currently send I/O to that path.

> If, however, we are hitting a 'transitioning' status on _all_ paths =
(ie
> all paths are set to 'failed') we need to ensure that we do _not_ fail
> the I/O (as technically the paths are still alive), but retry with
> TUR/RTPG until one path reaches a final state.
> Then we should reinstate that path and continue with I/O.

I am not saying that all paths should be changed to transitioning, but
I/Os sent to the path that is in transitioning should not immediately
fail if there is not an online path like what does happen without
this patch or one like it.

The other paths which are in other states should succeed or fail
I/O as they would based on their state. I am only concerned about
the portal group in the transitioning state and making sure it doesn=E2=80=
=99t
immediately bubble errors back to the multipath layer which fails the
path which is what we see and don=E2=80=99t want to see.

> So what is the error you are seeing?

Right now this is what fails and used to work before the patch
This worked in previous Linux versions and continues to work
in Windows, ESXi, Solaris, AIX, and HP-UX. I have tested those.
It might work on others as well, but that list is good enough for me.

We have an array with two controllers and when all is good
each controller reports active/optimized for all of it ports. There
Is a TPG per controller.

CT0 - Primary - AO - TPG 0
CT1 - Secondary - AO - TPG 1

In any upgrade there is a point where we have to have the
secondary promote to primary. In our world we call this a
giveback. This is done by returning unavailable for I/O
that is sent to the previous primary CT0 and transitioning
for CT1, the promoting secondary:

CT0 - was primary - unavailable - TPG 0
CT1 - promoting not yet primary - transitioning - TPG 1

This is where we hit the issue. The paths to CT0 fail
since its ALUA state is unavailable as expected. The paths
to CT1 also quickly fail in the same second after some
retries. There are no paths which can serve I/O for a
short time as the secondary promotes to primary. We
expect ALUA state transitioning to protect this path
against an I/O error returning to multipath which it
no longer does.

If it worked we would expect:
CT0 - becoming secondary - still unavailable - TPG 0
CT1 - Primary - AO - TPG 1

And a short time later:
CT0 - secondary - AO - TPG 0
CT1 - primary - AO - TPG 1

Hopefully that helps with the context and why we
are proposing what we are.

Thanks,
Brian

Brian Bunker
SW Eng
brian@purestorage.com



> On Jun 7, 2021, at 5:42 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 5/28/21 8:34 PM, Brian Bunker wrote:
>> Do not return an error to multipath which will result in a failed =
path until the transition time expires.
>>=20
>> The current patch which returns BLK_STS_AGAIN for ALUA transitioning =
breaks the assumptions in our target
>> regarding ALUA states. With that change an error is very quickly =
returned to multipath which in turn
>> immediately fails the path. The assumption in that patch seems to be =
that another path will be available
>> for multipath to use. That assumption I don=E2=80=99t believe is fair =
to make since while one path is in a
>> transitioning state it is reasonable to assume that other paths may =
also be in non active states.=20
>>=20
> I beg to disagree. Path groups are nominally independent, and might
> change states independent on the other path groups.
> While for some arrays a 'transitioning' state is indeed system-wide,
> other arrays might be able to serve I/O on other paths whilst one is =
in
> transitioning.
> So I'd rather not presume anything here.
>=20
>=20
>> The SPC spec has a note on this:
>> The IMPLICIT TRANSITION TIME field indicates the minimum amount of =
time in seconds the application client
>> should wait prior to timing out an implicit state transition (see =
5.15.2.2). A value of zero indicates that
>> the implicit transition time is not specified.
>>=20
> Oh, I know _that_ one. What with me being one of the implementors =
asking
> for it :-)
>=20
> But again, this is _per path_. One cannot assume anything about =
_other_
> paths here.
>=20
>> In the SCSI ALUA device handler a value of 0 translates to the =
transition time being set to 60 seconds.
>> The current approach of failing I/O on the transitioning path in a =
much quicker time than what is stated
>> seems to violate this aspect of the specification.
>>> #define ALUA_FAILOVER_TIMEOUT		60
>> unsigned long transition_tmo =3D ALUA_FAILOVER_TIMEOUT * HZ;
>>=20
>=20
> No. The implicit transitioning timeout is used to determine for how =
long
> we will be sending a 'TEST UNIT READY'/'REPORT TARGET PORT GROUPS' =
combo
> to figure out if this particular path is still in transitioning. Once
> this timeout is exceeded we're setting the path to 'standby'.
> And this 'setting port to standby' is our action for 'timing out an
> implicit state transition' as defined by the spec.
>=20
>> This patch uses the expiry the same way it is used elsewhere in the =
device handler. Once the transition
>> state is entered keep retrying until the expiry value is reached. If =
that happens, return the error to
>> multipath the same way that is currently done with BLK_STS_AGAIN.
>>=20
> And that is precisely what I want to avoid.
>=20
> As outlined above, we cannot assume that all paths will be set to
> 'transitioning' once we hit the 'transitioning' condition on one path.
> As such, we need to retry the I/O on other paths, to ensure failover
> does work in these cases. Hence it's perfectly okay to set this path =
to
> 'failed' as we cannot currently send I/O to that path.
>=20
> If, however, we are hitting a 'transitioning' status on _all_ paths =
(ie
> all paths are set to 'failed') we need to ensure that we do _not_ fail
> the I/O (as technically the paths are still alive), but retry with
> TUR/RTPG until one path reaches a final state.
> Then we should reinstate that path and continue with I/O.
>=20
> I thought that this is what we do already; but might be that there are
> some issues lurking here.
>=20
> So what is the error you are seeing?
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		        Kernel Storage Architect
> hare@suse.de			               +49 911 74053 688
> SUSE Software Solutions Germany GmbH, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, HRB 36809 (AG N=C3=BCrnberg)

