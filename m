Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61799C2B9F4
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 19:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 479446113C
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 19:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhFQTVb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 15:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbhFQTVb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2021 15:21:31 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E65C061574
        for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2021 12:19:23 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id h12so5824405pfe.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2021 12:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1YtHzDrhODP2fcqwl1I80FcUbqbQ5oRnYjoavYZIAgA=;
        b=Tqbmao2YbenHcBuq3cCN+1y5QO1/HJOQLr9oWigie7QNan6tFUqzHIhPLJkMiLDvJz
         zrMmaQkG8/6sXHBvT1noFqcl/V+fHZ4S3Sw3kmz1EMqz+knhoMYjLssp8wgelUoIul7/
         xkcWZeqc2gHE2Ova8+928ZlyUofLh9+zNEzJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1YtHzDrhODP2fcqwl1I80FcUbqbQ5oRnYjoavYZIAgA=;
        b=Bwog57rnyWopxj2h8jEoKVZl4w1oCO+PnpB8w5p5bGY1a4OGyjt68S9A0J8Q+VxmH1
         aOanZijOzImMVBwnoYeE+yMHqaBiTiFGFFvliBECcvSbDUddIwDDVu+H+ShFFlq6dUFZ
         4ImLvO7ODwXSakcrbjh5NfktxEuzNv2iejfBBDV27Pbv88ILUcsOCkHfHHvLaKnMS6F8
         vZB6P001fqobE+Exiz4mp4hu1fQxG/kFLNq/CDZiuZTqa6qCIpwnR/zm1j+kyCl4SrSn
         YYkFa2lvuoYNBbCv3RHYKf6PY833PLmQ3rqO/0TQMaH++lII96SXpT/8HGbFuu5BqtLs
         bOWA==
X-Gm-Message-State: AOAM533/8tRBR+BuoN6TLpaYmm+egs+NnOf0pdo1Jd037s8MDzcZCbe2
        JlGn0vtR5FjM1x/IrxbVKTgtRg==
X-Google-Smtp-Source: ABdhPJx6AwGcYIkb6UV4imPunNXmEG7lsk+kgHT8zDurtDmnr8QlXUh1CeOa/ObxVNibVtffpb9+zw==
X-Received: by 2002:a63:f915:: with SMTP id h21mr6512205pgi.78.1623957561877;
        Thu, 17 Jun 2021 12:19:21 -0700 (PDT)
Received: from smtpclient.apple ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id k7sm8925750pjj.46.2021.06.17.12.19.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jun 2021 12:19:20 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.1\))
Subject: Re: [PATCH 1/1]: scsi scsi_dh_alua: don't fail I/O until transition
 time expires
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <AF99F82D-7451-412C-AD21-8CF5593E6F59@purestorage.com>
Date:   Thu, 17 Jun 2021 12:19:19 -0700
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B5561C06-0029-45C5-9291-A66DAF48C303@purestorage.com>
References: <622E6257-85C7-4F9B-9CCD-2EF1791CB21F@purestorage.com>
 <23d45b9e-2c56-d637-dd2f-ea5a1ef267ac@suse.de>
 <27C07B47-22C8-4447-BB09-1386C64C21A0@purestorage.com>
 <add9c9c2-ed37-e973-6d8f-1d98c94905e4@suse.de>
 <AF99F82D-7451-412C-AD21-8CF5593E6F59@purestorage.com>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3654.120.0.1.1)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hannes,

I ran with what you mentioned about the multipath layer and chased down =
where the issue is happening. What I see is that new I/O coming in and =
hitting the device handler=E2=80=99s prep_fn here if the state is =
transitioning:

	case SCSI_ACCESS_STATE_TRANSITIONING:
		return BLK_STS_AGAIN;

The issue is when this hits multipath_end_io, this block status even =
though it is AGAIN implying it should be retried results in the path =
getting failed. Adding a check here like this makes our problem go away:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bced42f082b0..d5d6be96068d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1657,7 +1657,7 @@ static int multipath_end_io(struct dm_target *ti, =
struct request *clone,
                else
                        r =3D DM_ENDIO_REQUEUE;
=20
-               if (pgpath)
+               if (pgpath && (error !=3D BLK_STS_AGAIN))
                        fail_path(pgpath);
=20
                if (!atomic_read(&m->nr_valid_paths) &&

I am not sure if this where you were going but it does work without any =
other changes.

Thanks,
Brian

Brian Bunker
SW Eng
brian@purestorage.com



> On Jun 10, 2021, at 2:08 PM, Brian Bunker <brian@purestorage.com> =
wrote:
>=20
>=20
>> On Jun 9, 2021, at 12:03 AM, Hannes Reinecke <hare@suse.de> wrote:
>>=20
>> On 6/8/21 2:03 AM, Brian Bunker wrote:
>>>> Do not return an error to multipath which will result in a failed =
path until the \
>>>> transition time expires.
>>>> The current patch which returns BLK_STS_AGAIN for ALUA =
transitioning breaks the \
>>>> assumptions in our target regarding ALUA states. With that change =
an error is very \
>>>> quickly returned to multipath which in turn immediately fails the =
path. The \
>>>> assumption in that patch seems to be that another path will be =
available for \
>>>> multipath to use. That assumption I don't believe is fair to make =
since while one \
>>>> path is in a transitioning state it is reasonable to assume that =
other paths may \
>>>> also be in non active states.
>>>> I beg to disagree. Path groups are nominally independent, and might
>>>> change states independent on the other path groups.
>>>> While for some arrays a 'transitioning' state is indeed =
system-wide,
>>>> other arrays might be able to serve I/O on other paths whilst one =
is in
>>>> transitioning.
>>>> So I'd rather not presume anything here.
>>> I agree. No problem there. Our array could and does return =
transitioning on
>>> some portal groups while others might be active/online or =
unavailable.
>>>> As outlined above, we cannot assume that all paths will be set to
>>>> 'transitioning' once we hit the 'transitioning' condition on one =
path.
>>>> As such, we need to retry the I/O on other paths, to ensure =
failover
>>>> does work in these cases. Hence it's perfectly okay to set this =
path to
>>> =E2=80=98> failed' as we cannot currently send I/O to that path.
>>>> If, however, we are hitting a 'transitioning' status on _all_ paths =
(ie
>>>> all paths are set to 'failed') we need to ensure that we do _not_ =
fail
>>>> the I/O (as technically the paths are still alive), but retry with
>>>> TUR/RTPG until one path reaches a final state.
>>>> Then we should reinstate that path and continue with I/O.
>>> I am not saying that all paths should be changed to transitioning, =
but
>>> I/Os sent to the path that is in transitioning should not =
immediately
>>> fail if there is not an online path like what does happen without
>>> this patch or one like it.
>>> The other paths which are in other states should succeed or fail
>>> I/O as they would based on their state. I am only concerned about
>>> the portal group in the transitioning state and making sure it =
doesn=E2=80=99t
>>> immediately bubble errors back to the multipath layer which fails =
the
>>> path which is what we see and don=E2=80=99t want to see.
>>>> So what is the error you are seeing?
>>> Right now this is what fails and used to work before the patch
>>> This worked in previous Linux versions and continues to work
>>> in Windows, ESXi, Solaris, AIX, and HP-UX. I have tested those.
>>> It might work on others as well, but that list is good enough for =
me.
>>> We have an array with two controllers and when all is good
>>> each controller reports active/optimized for all of it ports. There
>>> Is a TPG per controller.
>>> CT0 - Primary - AO - TPG 0
>>> CT1 - Secondary - AO - TPG 1
>>> In any upgrade there is a point where we have to have the
>>> secondary promote to primary. In our world we call this a
>>> giveback. This is done by returning unavailable for I/O
>>> that is sent to the previous primary CT0 and transitioning
>>> for CT1, the promoting secondary:
>>> CT0 - was primary - unavailable - TPG 0
>>> CT1 - promoting not yet primary - transitioning - TPG 1
>>> This is where we hit the issue. The paths to CT0 fail
>>> since its ALUA state is unavailable as expected. The paths
>>> to CT1 also quickly fail in the same second after some
>>> retries. There are no paths which can serve I/O for a
>>> short time as the secondary promotes to primary. We
>>> expect ALUA state transitioning to protect this path
>>> against an I/O error returning to multipath which it
>>> no longer does.
>>> If it worked we would expect:
>>> CT0 - becoming secondary - still unavailable - TPG 0
>>> CT1 - Primary - AO - TPG 1
>>> And a short time later:
>>> CT0 - secondary - AO - TPG 0
>>> CT1 - primary - AO - TPG 1
>>> Hopefully that helps with the context and why we
>>> are proposing what we are.
>>> Ah-ha.
>> 'Unavailable' state. Right.
>>=20
>> Hmm. Seems that we need to distinguish (at the device-mapper =
multipath layer) between temporarily failed paths (like transitioning), =
which could become available at a later time, and permanently failed =
paths (like unavailable or standby), for which a retry would not yield =
different results. I thought we did that, but apparently there's an =
issue somewhere.
>>=20
>> Lemme see ...
>>=20
>> Cheers,
>>=20
>> Hannes
>> --=20
>> Dr. Hannes Reinecke                Kernel Storage Architect
>> hare@suse.de                              +49 911 74053 688
>> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix =
Imend=C3=B6rffer
>=20
> Thanks. For us, the current behavior after the fix I mentioned which =
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
>=20
> Thanks,
> Brian
>=20

