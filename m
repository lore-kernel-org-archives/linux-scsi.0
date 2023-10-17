Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DB1CDB482
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 21:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjJQVEK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 17:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjJQVEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 17:04:10 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4679F
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 14:04:08 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-59bd60ca09bso8317437b3.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 14:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697576648; x=1698181448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vy5kifYUA5S1vuWKYVOsp3on9SJlAfGsX2X2Nt/UkvA=;
        b=G8hd/CQtz3kYPpUmdxaSHIcW7unSST9p7koneE+ZZBJT5X8MWfz5y/xwHzPe/Smo2l
         ZBuswmxnpkQcNAVLGGkDRzHOcLO/9Ow5L5Zd7maw88cbf7hYsV7lLKYS8aVvj0VD6Sue
         yEBwgoeJTXUsb7IFXygurohfs1oNlXtQwJlFNeP2fPB6IrWoABI3g5rpnKQyKbXj6dek
         38BVxJ/FtBnsM/SrWq0JJBWj5OBlngELXfWNvvvk+o95hzntu4JbYBBW954f69p2+LM/
         F3nfLrEqQeIxIbDoysf8g7YXNdHs7CFqAAn644QXFcoIt0q/CRjf1PECQ2noH/86HkBv
         ao6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697576648; x=1698181448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vy5kifYUA5S1vuWKYVOsp3on9SJlAfGsX2X2Nt/UkvA=;
        b=t9dlECY3bBRwwBXKN/sBR5DOxQ1n3yKPEHpYRH9LlidHZjlkNEZrWbM70cMtChkiRe
         h/8j1ViXT/rRfBaKcqQlMgoW1oot/l9aGC1JtNoMPnJP90ZA+8bruWobOHuZkXsEG8rn
         +XvHW4VBOII9Po+Hm0sJZifbzWOnLD+GW2HguUHfyiuF9VqDYkmKkN023LWpmBwII/Vs
         0QkMZmuItR7Koljg4TZdY/snYNiY4AVhZ3ZwckBHwOgvyhmcmqHwK4JistyOikekT21k
         sbZGWjADtXSgm4ARQIBtXT2/SfAp6ol4gkWCqYDs81wKPZsc18JBBamfMKYXnSe0UDQv
         LxiQ==
X-Gm-Message-State: AOJu0Yzk+ZNf+RTaaK5VxwELFdYWIVtUf2gmSc5bBNkr/TreLnv64X1s
        IUEE+h4ZGSxu1y1E33IYIwaNkereQwxJNg+8aLLgk2m3Kfs=
X-Google-Smtp-Source: AGHT+IFWhI2DJbfwiKZN3oUsYgQhI9cJUsrT+y6qLtjDfHwj4EnbGJOTE2CEr565SwsYXH80FuoBkWc7Xc0dNqCBHbU=
X-Received: by 2002:a25:dad6:0:b0:d9a:df5a:6387 with SMTP id
 n205-20020a25dad6000000b00d9adf5a6387mr3217690ybf.3.1697576647835; Tue, 17
 Oct 2023 14:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <01b7568f-4ab4-4d56-bfa6-9ecc5fc261fe@moroto.mountain>
In-Reply-To: <01b7568f-4ab4-4d56-bfa6-9ecc5fc261fe@moroto.mountain>
From:   Justin Tee <justintee8345@gmail.com>
Date:   Tue, 17 Oct 2023 14:03:57 -0700
Message-ID: <CABPRKS90AOLdyxPTrh84tkcaZzY6w==EnARJjSEaqOW=K38bmA@mail.gmail.com>
Subject: Re: [bug report] scsi: lpfc: Validate ELS LS_ACC completion payload
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     justin.tee@broadcom.com, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dan,

Yes, you=E2=80=99re right.  We should change that to use list_first_entry_o=
r_null.

Thanks for pointing this out and we will push a patch to correct this.

Regards,
Justin

On Tue, Oct 17, 2023 at 6:54=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> Hello Justin Tee,
>
> The patch a3c3c0a806f1: "scsi: lpfc: Validate ELS LS_ACC completion
> payload" from Oct 9, 2023 (linux-next), leads to the following Smatch
> static checker warning:
>
>         drivers/scsi/lpfc/lpfc_els.c:2133 lpfc_cmpl_els_plogi()
>         warn: list_entry() does not return NULL 'prsp'
>
> drivers/scsi/lpfc/lpfc_els.c
>     2126                 if (release_node)
>     2127                         lpfc_disc_state_machine(vport, ndlp, cmd=
iocb,
>     2128                                                 NLP_EVT_DEVICE_R=
M);
>     2129         } else {
>     2130                 /* Good status, call state machine */
>     2131                 prsp =3D list_entry(cmdiocb->cmd_dmabuf->list.ne=
xt,
>     2132                                   struct lpfc_dmabuf, list);
> --> 2133                 if (!prsp)
>
> list_entry() never returns NULL.  If the list is empty it returns an
> invalid pointer.  Did you want to use list_entry_or_null()?
>
>     2134                         goto out;
>     2135                 if (!lpfc_is_els_acc_rsp(prsp))
>     2136                         goto out;
>     2137                 ndlp =3D lpfc_plogi_confirm_nport(phba, prsp->vi=
rt, ndlp);
>
> regards,
> dan carpenter
