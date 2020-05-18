Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D224C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 01:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1307920758
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 01:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YsFijEJH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgERBCT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 May 2020 21:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgERBCS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 May 2020 21:02:18 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCF5C061A0C;
        Sun, 17 May 2020 18:02:17 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id u6so8022634ljl.6;
        Sun, 17 May 2020 18:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cElIIYyJDPkLVWUxrz4v0d1891qYoBkXO8M2vNfJEH4=;
        b=YsFijEJHPXeg94GNEmqZJLNcWewKowqaDTETzBP1hzhBlf5dXDzrOloBm21bmvyeN+
         6hoexuKacMYoUy2FGrqb5zz1pE9vIXCMRRL0Nz8zgvkyBRV+yOYQ5kzNpssT38FuFee4
         6sAJJZWy1Pth2HLVK09p/3c4Y0Ye/QX2h4owQQuTUo+N3kaRwqWKSl0FuhYK8He0hSCj
         qI/4aM3fkrPMvYPIU1UIYU/tnvfieZnQYWV0mnRQX6AInyrg5dFzWLRK3UgD7nfO7Ws9
         Qd/5rGvcHYP0aT89CKO2Y5lKTekO/Z1qnEuCFByvWufQ2hamJL2nWlqjYRVmzNCFk0BV
         f61g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cElIIYyJDPkLVWUxrz4v0d1891qYoBkXO8M2vNfJEH4=;
        b=ASy61LHdncg2i6cI1bHm6/+aC14hLvcuF5AdoiZKkIa7dOXq29iWCGTbA8hYXnnGkk
         nHdCNMDgnU99J8Q//utorhof3WHtXoATShUT7yMU4cK+mMw2h+pq+5kOpdbv0lQkz8XH
         01AtOqBxr2aqnBoL43YG0jjvOneDZY09yXQJLpi4yswvgQL8gokweP7+9wMcGMjqfuuH
         r50qhNkPMm9EvprzS3fW665vq5cxnnoibh+44eqowq4tcbraCQVJ7LVFfpKNDXucr6SU
         zNnjkCIVUGelXjhjapRej1TNSrhgHId+dYeJvFmdeENrAyQ0HOdWLpkGk8aE8mdyINxd
         fPWQ==
X-Gm-Message-State: AOAM531BT8OsT44WePqfMAnz8dJuiiZ8J9kpcWtuQDBDeaTjAbcmdcd4
        BpFAHFslDr0gMFOdEo1zcz3z6jyLAkjT2k5ePXg=
X-Google-Smtp-Source: ABdhPJzHTda9lpdlJDy3TE3YR8EMfRVlmgl+cKKojgVanXQPBKR/80ucTM+XJb0QWU72z9u7k2YbnjR83ZQguE6nNgM=
X-Received: by 2002:a2e:b891:: with SMTP id r17mr8744535ljp.34.1589763735537;
 Sun, 17 May 2020 18:02:15 -0700 (PDT)
MIME-Version: 1.0
References: <cd119ce943d9ec62ef1bff237ebb49e35a337c3b.1589407872.git.lance.digby@gmail.com>
 <93c437ce-f881-9f54-5e39-afa8afd96141@redhat.com> <CAHh6B+poeCFeZjCt04QT2c12bgvCf9UN+5vdx5EeK6PcgD2y3g@mail.gmail.com>
 <fb2b881c-fe23-4a80-53c3-189d744f2fe3@redhat.com>
In-Reply-To: <fb2b881c-fe23-4a80-53c3-189d744f2fe3@redhat.com>
From:   Lance Digby <lance.digby@gmail.com>
Date:   Mon, 18 May 2020 11:02:03 +1000
Message-ID: <CAHh6B+q4b34awGvKxh7vh+Vn75WjBme11NumusNLxiyZ+t4GxA@mail.gmail.com>
Subject: Re: [PATCH target] target: Add initiatorname to NON_EXISTENT_LUN error
To:     Mike Christie <mchristi@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks again Mike will send out a new version.

On Mon, May 18, 2020 at 5:16 AM Mike Christie <mchristi@redhat.com> wrote:
>
> On 5/16/20 6:29 PM, Lance Digby wrote:
> > Mike,  Thanks for the review!
> >   The pr_err  Detected NON_EXISTENT_LUN is the error messages issued
> > for the TCM_NON_EXISTENT_LUN retcode so I believe they are the same.
> >   Simply scanning for the wrong lun on an initiator will generate this
> > error on the target but not generate an error on the initiator. And I
> > have seen installs, with a lot of initiators, automate the scanning of
> > such luns incorrectly deemed missing.
> >   While this looks like a simple problem it can take days to get
> > access or the tcp traces to sort it out.
> >
> >    Within the same routine there is another pr_err for
> > TCM_WRITE_PROTECTED that I did not add the initiatorname to as I
> > thought this would leave a heavy footprint on the initiator. If you
>
> I'm not sure what you mean by heavy footprint on the initiator part means.
>
> I would say do whatever is helpful to you to debug the problem. For
> TCM_WRITE_PROTECTED I'm not sure the initiatorname is helpful. I think
> the target name and tpg would be useful, because I think you sometimes
> set it at the tpg level then it gets inherited by the LU. But I think
> it's a pain to get to the target name from this code path, so I wouldn't
> worry about adding it now.
>
> > believe this should be changed for consistency please let me know and
> > I will add this and change to nacl->initiatorname.
>
> Just to make sure we are on the same page. I was just commenting about
> the other NON_EXISTENT_LUN instace in transport_lookup_tmr_lun. I just
> thought we would want/need the same info there.
>
>
> >
> >
> >
> >
> >
> >
> >
> >
> >
> > On Sat, May 16, 2020 at 9:50 AM Mike Christie <mchristi@redhat.com> wrote:
> >>
> >> On 5/13/20 11:01 PM, Lance Digby wrote:
> >>> The NON_EXISTENT_LUN error can be written without an error condition
> >>>  on the initiator responsible. Adding the initiatorname to this message
> >>>  will reduce the effort required to fix this when many initiators are
> >>> supported by a target.
> >>>
> >>> Signed-off-by: Lance Digby <lance.digby@gmail.com>
> >>> ---
> >>>  drivers/target/target_core_device.c | 5 +++--
> >>>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> >>> index 4cee113..604dea0 100644
> >>> --- a/drivers/target/target_core_device.c
> >>> +++ b/drivers/target/target_core_device.c
> >>> @@ -100,9 +100,10 @@
> >>>                */
> >>>               if (unpacked_lun != 0) {
> >>>                       pr_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
> >>> -                             " Access for 0x%08llx\n",
> >>> +                             " Access for 0x%08llx from %s\n",
> >>>                               se_cmd->se_tfo->fabric_name,
> >>> -                             unpacked_lun);
> >>> +                             unpacked_lun,
> >>> +                             se_sess->se_node_acl->initiatorname);
> >>
> >> You can do nacl->initiatorname.
> >>
> >> Do you also want add the name to the tmr case? It's probably not common,
> >> but the error message would be consistent.
> >>
> >>>                       return TCM_NON_EXISTENT_LUN;
> >>>               }
> >>>
> >>
> >
>
