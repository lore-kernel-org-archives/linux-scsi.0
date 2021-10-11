Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F4C9C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 02:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B71B60E54
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 02:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhJKCGB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Oct 2021 22:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbhJKCGB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Oct 2021 22:06:01 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC93EC061570
        for <linux-scsi@vger.kernel.org>; Sun, 10 Oct 2021 19:04:01 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id p23so3071414vsq.10
        for <linux-scsi@vger.kernel.org>; Sun, 10 Oct 2021 19:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bfZxBQqSlnMz3lcuj1XK/231rEN9kT4LRHRvZ4eNtbk=;
        b=M23AiDiWE0ixlr2J7wy3RNlffR8Q4Iv8C/4PyN5IuUPVZvUf/A+DM4u7QpRMwqizdZ
         H+UNTTRapKZo2UQ77sVi70HrjrkTVG5p47S8xnrJUOIZ66KWZS5yjXLMi1SqwF+fsSD+
         d0zBMz3WFrCAXS+6EdGE1BvC84JB3JzQe7Knl8kPTmg0gDQEbltLrrYZKGgim1LH9yFa
         X6e5Yo1lUAdIMVK2Dq4zuyo6MBRR/6F7jOuPr80mHe50TYS+kDq+RJNDyMKL11nHXgu4
         RA8n7pbgBYrmrxlGvNiH2EHJiVmOumKX35sZKvKB+DbBYwFRQSe8b+K/kzmbFLcMbmfz
         SdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bfZxBQqSlnMz3lcuj1XK/231rEN9kT4LRHRvZ4eNtbk=;
        b=WxZ3qAQCQ7stNOkEldOJiSrAHKtH65nhebqT8gtCcSTvdiHqTLV0PXCK3OqbRkYLgt
         5BChu6TvfsiVXk4a3nkuWQYMXlOwIGPVKup6V5TFazUOpZuADv3/oBoXz+FWjuP92Rsn
         WJLIc66UU1P5lZYBBmfk72e1afdeZy+5JKhKPvUmyt9qvWvqjgpEsJ5f6Y0ETRQjIVfd
         isSYSEuH54iEJmPIbwk6UjMtBQwJHtN6eFClXz6QUKfgmceeZVydzLYA4tv76/zvkHlR
         wPpTlFzrVTwkmOwI8CKKdnrUEa9wim/3uo2dXk//i9QKvf3Sqw//JSE3eyGZHi6PVu+W
         uXWA==
X-Gm-Message-State: AOAM533ES+HidDMzgPyhfzFRIunnFvTOamHinlZmyzPjgsZi3j5tgmgG
        YJVw/5I6dXus+6SFGknn1evh/trR0BeH5zg6Mcw6EQ==
X-Google-Smtp-Source: ABdhPJxcuf1rdNXYSV6+NbpGyOa0b6p/JhpkthDczILToJF0O1F+AIc1Hg9+g7STLtYKtseLexVIB72v02JVIbqOjmI=
X-Received: by 2002:a67:ee4b:: with SMTP id g11mr18874850vsp.5.1633917841003;
 Sun, 10 Oct 2021 19:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211010071947.2002025-1-fengli@smartx.com> <95db5f3d-99dd-ddbb-ea44-8cd37d92ce0f@oracle.com>
In-Reply-To: <95db5f3d-99dd-ddbb-ea44-8cd37d92ce0f@oracle.com>
From:   Li Feng <fengli@smartx.com>
Date:   Mon, 11 Oct 2021 10:03:49 +0800
Message-ID: <CAHckoCxCRZXXcSp3A+i+vxzM8AomDtAohVYDy1FmARJzB2SrCQ@mail.gmail.com>
Subject: Re: [PATCH] iscsi_tcp: fix the NULL pointer dereference
To:     michael.christie@oracle.com
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:ISCSI" <open-iscsi@googlegroups.com>,
        "open list:ISCSI" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Gulam Mohamed <gulam.mohamed@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks,
Feng Li

<michael.christie@oracle.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8811=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8812:05=E5=86=99=E9=81=93=EF=BC=9A
>
> On 10/10/21 2:19 AM, Li Feng wrote:
> >  drivers/scsi/iscsi_tcp.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> > index 1bc37593c88f..2ec1405d272d 100644
> > --- a/drivers/scsi/iscsi_tcp.c
> > +++ b/drivers/scsi/iscsi_tcp.c
> > @@ -724,6 +724,8 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi=
_cls_conn *cls_conn,
> >               break;
> >       case ISCSI_PARAM_DATADGST_EN:
> >               iscsi_set_param(cls_conn, param, buf, buflen);
> > +             if (!tcp_sw_conn || !tcp_sw_conn->sock)
> > +                     return -ENOTCONN;
> >               tcp_sw_conn->sendpage =3D conn->datadgst_en ?
> >                       sock_no_sendpage : tcp_sw_conn->sock->ops->sendpa=
ge;
> >               break;
> >
>
> Hi,
>
> Thanks for the patch. This was supposed to be fixed in:
>
> commit 9e67600ed6b8565da4b85698ec659b5879a6c1c6
> Author: Gulam Mohamed <gulam.mohamed@oracle.com>
> Date:   Thu Mar 25 09:32:48 2021 +0000
>
>     scsi: iscsi: Fix race condition between login and sync thread
>
> because it was not supposed to allow set_param to be called on
> an unbound connection. However, it looks like there was a mistake in
> the patch:
>
>                 err =3D transport->set_param(conn, ev->u.set_param.param,
>                                            data, ev->u.set_param.len);
> +               if ((conn->state =3D=3D ISCSI_CONN_BOUND) ||
> +                       (conn->state =3D=3D ISCSI_CONN_UP)) {
> +                       err =3D transport->set_param(conn, ev->u.set_para=
m.param,
> +                                       data, ev->u.set_param.len);
> +               } else {
> +                       return -ENOTCONN;
> +               }
>
>
> and that first set_param call was supposed to be deleted and
> replaced with the one that was added in the conn->state check.
>
> We should just need a patch to remove that first set_param call.

Yes, I have checked the upstream code, this is an obvious mistake here.
I encountered this issue on 5.11.12-300.fc34.x86_64, it doesn't
include this patch,
so I check the pointer like my patch.
Thanks.
