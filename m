Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F199C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 02:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99CF60F3A
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 02:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhJKCH3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Oct 2021 22:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbhJKCH2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Oct 2021 22:07:28 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6640CC061570
        for <linux-scsi@vger.kernel.org>; Sun, 10 Oct 2021 19:05:29 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id j22so2261388vsl.5
        for <linux-scsi@vger.kernel.org>; Sun, 10 Oct 2021 19:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KfKGpB69JakEhV7wCiyg7yYE2U8SOe4PXgzGoFRyXyA=;
        b=62xzRgbv/YP/+26c3Jb/xpV3IEeNovO3G9Gjs/nOrXzWOspbwLWXtx0a5jL63uwftY
         e2eHjfBaHkhxi6BJmPZsxufQj0DCFBYa6T0IywZyE8W4KA4FUu5oWRWVm7Ias1DWcP8V
         JvM9k8beS2psealM5n85VNjAkIw/FDGU6wPEWIX4o2dplkC3mKTZtw7AXRPqMoG7p6zy
         zgIK+Js/h1OxjJ5iOZeBcKSBtMexqS35mG0irDyR3uZA/vGH5xZ+94Zl6sx6SQjQhUqW
         is6Wu6azwz6bgNmHT/zrEWJROsrJxKnSl0OVh3tHX6miz3d8RGnkA/bRhSF4LvScyTx+
         zUbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KfKGpB69JakEhV7wCiyg7yYE2U8SOe4PXgzGoFRyXyA=;
        b=mRNtHl5xGCxZtGZkOV3zSpvSNdx6pED4b0bMSTliJV2SbZMDOD7YTYzrrzu7OkiqH5
         74kn7CJZMkmAKIzyZP/83DiotjoGGkemLn0yXRNYCjSjUtvF9+WM3Jtx3fOrmwLa/nU7
         GwP6fIZVUjYgCqlRId6gj8XWDmo3GB8xeTlke7mHDdrKPP/3B/qzJuLbeaxQ6CwkSDf7
         WuiuPPrb6YSIrQPFvL7/LzkYlvjzL1QUvRX06ah4prLaGuST5j1IykjTFuytrI1z+gS8
         Kay3v+XwrpI77ak6+U9CrlCpa2DVur6E/XHBhyVJWKydbrvD/qpmhuXvOqRodSqioYYU
         1L3A==
X-Gm-Message-State: AOAM532kqTq8p9EAsgppAAD14itDvHnfOkhd33oUwSyu7MvOTe2DodyG
        CFNdJL/QfoBXngmimAtj4jeyQtfav2JyqsdEj2gLAg==
X-Google-Smtp-Source: ABdhPJyiaz56utYAyTJWeL0whLmME5VstAmja6/IkFWuvSMSQU9u0W+8b0lB+bjleVmuHcHYX1JoaCdoFQPJ8R6TdDw=
X-Received: by 2002:a67:d28f:: with SMTP id z15mr21025758vsi.44.1633917928593;
 Sun, 10 Oct 2021 19:05:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211010161904.60471-1-michael.christie@oracle.com> <3e97c682-924d-ffb3-ab92-deae2718865f@suse.com>
In-Reply-To: <3e97c682-924d-ffb3-ab92-deae2718865f@suse.com>
From:   Li Feng <fengli@smartx.com>
Date:   Mon, 11 Oct 2021 10:05:17 +0800
Message-ID: <CAHckoCzKf4wmKELq3edxG=94bG0MpxtpptpS_OkVeDs5+CjuwQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: iscsi: Fix set_param handling
To:     Lee Duncan <lduncan@suse.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Gulam Mohamed <gulam.mohamed@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:SCSI TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Lee Duncan <lduncan@suse.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8811=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=889:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On 10/10/21 9:19 AM, Mike Christie wrote:
> > In:
> >
> > commit 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and
> > sync thread")
> >
> > we meant to add a check where before we call set_param we make sure the
> > iscsi_cls_connection is bound. The problem is that between versions 4 a=
nd
> > 5 of the patch the deletion of the unchecked set_param call was dropped
> > so we ended up with 2 calls. As a result we can still hit a crash where
> > we access the unbound connection on the first call.
> >
> > This patch removes that first call.
> >
> > Fixes: 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and
> > sync thread")
> >
> > Signed-off-by: Mike Christie <michael.christie@oracle.com>
> > ---
> >  drivers/scsi/scsi_transport_iscsi.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tr=
ansport_iscsi.c
> > index 922e4c7bd88e..78343d3f9385 100644
> > --- a/drivers/scsi/scsi_transport_iscsi.c
> > +++ b/drivers/scsi/scsi_transport_iscsi.c
> > @@ -2930,8 +2930,6 @@ iscsi_set_param(struct iscsi_transport *transport=
, struct iscsi_uevent *ev)
> >                       session->recovery_tmo =3D value;
> >               break;
> >       default:
> > -             err =3D transport->set_param(conn, ev->u.set_param.param,
> > -                                        data, ev->u.set_param.len);
> >               if ((conn->state =3D=3D ISCSI_CONN_BOUND) ||
> >                       (conn->state =3D=3D ISCSI_CONN_UP)) {
> >                       err =3D transport->set_param(conn, ev->u.set_para=
m.param,
> >
>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
>
Reviewed-by: Li Feng <fengli@smartx.com>
