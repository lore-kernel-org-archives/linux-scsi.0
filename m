Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D0EC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 23:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE3C207C4
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 23:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAxm0r3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgEPX3s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 May 2020 19:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726660AbgEPX3s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 May 2020 19:29:48 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DCAC061A0C;
        Sat, 16 May 2020 16:29:46 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id d21so6001076ljg.9;
        Sat, 16 May 2020 16:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VsIGqmQYU9B1hFiVmj/6ksJDLb/9MQhxyITf5iqCEAU=;
        b=CAxm0r3bkWmXjkeiCzLPuKYnFKjmYcTMlB211VAPCdb2e0rDkYvjgKujtHQo5YnQtR
         WYhrUreg7ADZxvFKkuBOju+THp+1gYsGi9JRt/ejoHugqQ4Lt4ZAXR+GRw0L0A+66/UM
         aT52BE/bEQrnitmXPtcIktSrpJmQpc7TJEMrOI75rNNhQB37g9VgqnacNxAKPZzWKTyC
         t5lEVHc9351QfxtHaytLZpm6wG6w9yCKQ6BfTZJuXdw3BjiOXq0PASbRavhsXMe4v5m7
         e6iGVuXlEwtLZbH1wQsJO1JSDfci6337NAg2ZQm4a6IpeQIYHn+TtN7fx0LsK8LP8LjF
         lWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VsIGqmQYU9B1hFiVmj/6ksJDLb/9MQhxyITf5iqCEAU=;
        b=MAg9pFOhYzriAxZ871VKtOgkLjY5lbZ+AWH01z4/vDbK1PAq8EKlZvBiBgJH0jjULr
         fbjEtKp6TmKp95hBSP5RRzMjhwDgKtonkKsUKTD+p4rdHYPyn5lHX9eJJsOYP2gD55tn
         +ff1EEMghmloDuJqNNuS5ajbzuq4okQqwv5GHN89TfOn3jXAK5onOwzklHc5XiDBervm
         F54BoSETgF56gbC2bXgMkQuD3NPwi5aqnbJVhuu5wQAI4Gkc48DLQcL+O850R8Y+nEC+
         TDo8VNcDztOC2zgjVq4nOsLR4I5FVP7L3+GHwdTwrko/8hpnW86aT3DErCmpqmUefGNn
         DltA==
X-Gm-Message-State: AOAM533avlE1crr8Mc++AtLc6QULDDBy4TbR7XJBNukXxJKAPOcSqq+L
        RxFRGlKgNA8O99mNNI2VZtiAnovjpuBN4gG0HtE=
X-Google-Smtp-Source: ABdhPJwMEerA6PY5MC+s0R6rodZvVntL+CV0Pe2OuKYU6/n9FN6gEnBajSh8QBi/2P6CtuqIJdRTr7gER99hj/E+DNQ=
X-Received: by 2002:a2e:a545:: with SMTP id e5mr6015544ljn.271.1589671784750;
 Sat, 16 May 2020 16:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <cd119ce943d9ec62ef1bff237ebb49e35a337c3b.1589407872.git.lance.digby@gmail.com>
 <93c437ce-f881-9f54-5e39-afa8afd96141@redhat.com>
In-Reply-To: <93c437ce-f881-9f54-5e39-afa8afd96141@redhat.com>
From:   Lance Digby <lance.digby@gmail.com>
Date:   Sun, 17 May 2020 09:29:38 +1000
Message-ID: <CAHh6B+poeCFeZjCt04QT2c12bgvCf9UN+5vdx5EeK6PcgD2y3g@mail.gmail.com>
Subject: Re: [PATCH target] target: Add initiatorname to NON_EXISTENT_LUN error
To:     Mike Christie <mchristi@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mike,  Thanks for the review!
  The pr_err  Detected NON_EXISTENT_LUN is the error messages issued
for the TCM_NON_EXISTENT_LUN retcode so I believe they are the same.
  Simply scanning for the wrong lun on an initiator will generate this
error on the target but not generate an error on the initiator. And I
have seen installs, with a lot of initiators, automate the scanning of
such luns incorrectly deemed missing.
  While this looks like a simple problem it can take days to get
access or the tcp traces to sort it out.

   Within the same routine there is another pr_err for
TCM_WRITE_PROTECTED that I did not add the initiatorname to as I
thought this would leave a heavy footprint on the initiator. If you
believe this should be changed for consistency please let me know and
I will add this and change to nacl->initiatorname.









On Sat, May 16, 2020 at 9:50 AM Mike Christie <mchristi@redhat.com> wrote:
>
> On 5/13/20 11:01 PM, Lance Digby wrote:
> > The NON_EXISTENT_LUN error can be written without an error condition
> >  on the initiator responsible. Adding the initiatorname to this message
> >  will reduce the effort required to fix this when many initiators are
> > supported by a target.
> >
> > Signed-off-by: Lance Digby <lance.digby@gmail.com>
> > ---
> >  drivers/target/target_core_device.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> > index 4cee113..604dea0 100644
> > --- a/drivers/target/target_core_device.c
> > +++ b/drivers/target/target_core_device.c
> > @@ -100,9 +100,10 @@
> >                */
> >               if (unpacked_lun != 0) {
> >                       pr_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
> > -                             " Access for 0x%08llx\n",
> > +                             " Access for 0x%08llx from %s\n",
> >                               se_cmd->se_tfo->fabric_name,
> > -                             unpacked_lun);
> > +                             unpacked_lun,
> > +                             se_sess->se_node_acl->initiatorname);
>
> You can do nacl->initiatorname.
>
> Do you also want add the name to the tmr case? It's probably not common,
> but the error message would be consistent.
>
> >                       return TCM_NON_EXISTENT_LUN;
> >               }
> >
>
