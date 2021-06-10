Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709BBC48BE5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 21:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55EB861412
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 21:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFJVLR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 17:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhFJVLO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 17:11:14 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F410FC061574
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2021 14:09:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h16so4427891pjv.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2021 14:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=cQhd7bmMhTES9BCeBHPRiz1cvAp3d6F8G5Vo0apk51s=;
        b=Y7AehQFZpF59Vs4TlnGxGIDn5V4gUp00UFDpsp/1w+uZO5rtpZb21Oo6iyR8ng1IXZ
         P/n5rIidmn1a6KEPfFmYkPxAW9BJaxIIk8oOuQHaTP9WXgzqqBhmXbJous1NEY+sgz+8
         pCdye9m6luYHaUs268SNjN8ou8u42cDbHTVZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=cQhd7bmMhTES9BCeBHPRiz1cvAp3d6F8G5Vo0apk51s=;
        b=WLz28UflovyjLsSDCuNfWJPpFSwKdTcbeiMmb01RAeaMEbRvA3GGkZQ9BPl10lRtSA
         RSxeloKTrsKkPmNcbzH3a9DGiGoKlDiTCoUa7+acAAwlrETCjTLxQr7w2ibTjh6BxBfm
         yIjMBKnV7X9JaRzqkmwmv63/h9mEpQkbzVHHsVWxAZ6Ivmgx7Ugh1nnORxNGvOIFzzXl
         CrRu0VOAPODBDT+IXeD18O1x9rGMeER8G6oZH5Gcw8Zg2bz9egyfvL9D7o86kQxOU5db
         KypL7KKHr7ScD+5ic8FjMboRshyYI6M3bN/g9lXKJWfRJ2ftKniL2THvd+8Cxt+oRehM
         UVPg==
X-Gm-Message-State: AOAM530zOAHiqDet4xaWcS3UubYvA40/bPwv9ulVIc175aA7GHstT+Ch
        h9PlnQz05BHuvWz0TF+cLuOSCe5iiTp5ZA==
X-Google-Smtp-Source: ABdhPJwA5cNk9xQZVu5ApgTAIe030QZ7buivUE79fyNR5+ioJhk1Ru9EOmkDyjmLaFB1smhCdIemhg==
X-Received: by 2002:a17:90a:4e85:: with SMTP id o5mr5414188pjh.22.1623359340383;
        Thu, 10 Jun 2021 14:09:00 -0700 (PDT)
Received: from smtpclient.apple ([104.129.154.187])
        by smtp.gmail.com with ESMTPSA id f18sm2923625pfv.79.2021.06.10.14.08.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 14:08:18 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.1\))
Subject: Re: [PATCH 1/1]: scsi scsi_dh_alua: don't fail I/O until transition
 time expires
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <add9c9c2-ed37-e973-6d8f-1d98c94905e4@suse.de>
Date:   Thu, 10 Jun 2021 14:08:02 -0700
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AF99F82D-7451-412C-AD21-8CF5593E6F59@purestorage.com>
References: <622E6257-85C7-4F9B-9CCD-2EF1791CB21F@purestorage.com>
 <23d45b9e-2c56-d637-dd2f-ea5a1ef267ac@suse.de>
 <27C07B47-22C8-4447-BB09-1386C64C21A0@purestorage.com>
 <add9c9c2-ed37-e973-6d8f-1d98c94905e4@suse.de>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3654.120.0.1.1)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On Jun 9, 2021, at 12:03 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 6/8/21 2:03 AM, Brian Bunker wrote:
>>> Do not return an error to multipath which will result in a failed =
path until the \
>>> transition time expires.
>>> The current patch which returns BLK_STS_AGAIN for ALUA transitioning =
breaks the \
>>> assumptions in our target regarding ALUA states. With that change an =
error is very \
>>> quickly returned to multipath which in turn immediately fails the =
path. The \
>>> assumption in that patch seems to be that another path will be =
available for \
>>> multipath to use. That assumption I don't believe is fair to make =
since while one \
>>> path is in a transitioning state it is reasonable to assume that =
other paths may \
>>> also be in non active states.
>>> I beg to disagree. Path groups are nominally independent, and might
>>> change states independent on the other path groups.
>>> While for some arrays a 'transitioning' state is indeed system-wide,
>>> other arrays might be able to serve I/O on other paths whilst one is =
in
>>> transitioning.
>>> So I'd rather not presume anything here.
>> I agree. No problem there. Our array could and does return =
transitioning on
>> some portal groups while others might be active/online or =
unavailable.
>>> As outlined above, we cannot assume that all paths will be set to
>>> 'transitioning' once we hit the 'transitioning' condition on one =
path.
>>> As such, we need to retry the I/O on other paths, to ensure failover
>>> does work in these cases. Hence it's perfectly okay to set this path =
to
>> =E2=80=98> failed' as we cannot currently send I/O to that path.
>>> If, however, we are hitting a 'transitioning' status on _all_ paths =
(ie
>>> all paths are set to 'failed') we need to ensure that we do _not_ =
fail
>>> the I/O (as technically the paths are still alive), but retry with
>>> TUR/RTPG until one path reaches a final state.
>>> Then we should reinstate that path and continue with I/O.
>> I am not saying that all paths should be changed to transitioning, =
but
>> I/Os sent to the path that is in transitioning should not immediately
>> fail if there is not an online path like what does happen without
>> this patch or one like it.
>> The other paths which are in other states should succeed or fail
>> I/O as they would based on their state. I am only concerned about
>> the portal group in the transitioning state and making sure it =
doesn=E2=80=99t
>> immediately bubble errors back to the multipath layer which fails the
>> path which is what we see and don=E2=80=99t want to see.
>>> So what is the error you are seeing?
>> Right now this is what fails and used to work before the patch
>> This worked in previous Linux versions and continues to work
>> in Windows, ESXi, Solaris, AIX, and HP-UX. I have tested those.
>> It might work on others as well, but that list is good enough for me.
>> We have an array with two controllers and when all is good
>> each controller reports active/optimized for all of it ports. There
>> Is a TPG per controller.
>> CT0 - Primary - AO - TPG 0
>> CT1 - Secondary - AO - TPG 1
>> In any upgrade there is a point where we have to have the
>> secondary promote to primary. In our world we call this a
>> giveback. This is done by returning unavailable for I/O
>> that is sent to the previous primary CT0 and transitioning
>> for CT1, the promoting secondary:
>> CT0 - was primary - unavailable - TPG 0
>> CT1 - promoting not yet primary - transitioning - TPG 1
>> This is where we hit the issue. The paths to CT0 fail
>> since its ALUA state is unavailable as expected. The paths
>> to CT1 also quickly fail in the same second after some
>> retries. There are no paths which can serve I/O for a
>> short time as the secondary promotes to primary. We
>> expect ALUA state transitioning to protect this path
>> against an I/O error returning to multipath which it
>> no longer does.
>> If it worked we would expect:
>> CT0 - becoming secondary - still unavailable - TPG 0
>> CT1 - Primary - AO - TPG 1
>> And a short time later:
>> CT0 - secondary - AO - TPG 0
>> CT1 - primary - AO - TPG 1
>> Hopefully that helps with the context and why we
>> are proposing what we are.
>> Ah-ha.
> 'Unavailable' state. Right.
>=20
> Hmm. Seems that we need to distinguish (at the device-mapper multipath =
layer) between temporarily failed paths (like transitioning), which =
could become available at a later time, and permanently failed paths =
(like unavailable or standby), for which a retry would not yield =
different results. I thought we did that, but apparently there's an =
issue somewhere.
>=20
> Lemme see ...
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix =
Imend=C3=B6rffer

Thanks. For us, the current behavior after the fix I mentioned which =
broke things leaves us in a bad state. The only thing we can do is use =
no_path_retry in multipath.conf, but that brings with it just a new set =
of problems. There are times we do want an I/O error to return to the =
caller as quickly as possible (We actual don=E2=80=99t have any paths =
that can serve I/O). The state where one controller is unavailable and =
the other is transitioning is not a condition where we would want an I/O =
error returned. We expect that the transitioning path would protect us =
until it transitions to an online state in our case. These transition =
times in our case are very short, just a few seconds, but we would =
prefer to not hold on to I/O on the target if we can=E2=80=99t serve it. =
The transitioning state had been working great for this up until Centos =
8 stream picked up the change.

Thanks,
Brian

