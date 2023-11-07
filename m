Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31C3C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Nov 2023 18:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbjKGSOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Nov 2023 13:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbjKGSOx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2023 13:14:53 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04C412B
        for <linux-scsi@vger.kernel.org>; Tue,  7 Nov 2023 10:14:51 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-d9bf9122c1aso885768276.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2023 10:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699380891; x=1699985691; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wcogn3if5x+iFLnXB5sybkqGYS285fbBdbSGLeI0L8I=;
        b=YQz0SprHmEgV43v/GqI4hyy+LW5mKb0ouIipcpMnxNtQBTVaw4wGYuxtsTkLxU5zhT
         f4VYiCg1omwkK86wZ+M3fE0qm038kEk9762cVypA4z0PGAaRlps9cthYeiJ8l6eSiAC3
         mgwAU+EQNINZp8n3ilUc4j0Qd22cTAX2ZaQmSINrP/SdAPzQdoQcw6t5InRm2Ad/sGvi
         KBsFDT7yXffL53fUxH3v/TDAH0Rm9AUIkuO0/x6EJD6pp/vOsDLUtvNn4UssImUg9f/d
         hPhGuGAB8urTcDU1kEWH3tGsx6NxIyIvPWVTgcpFba0NtLebrC9qUC4PB+szgmM/q+lq
         YZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699380891; x=1699985691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wcogn3if5x+iFLnXB5sybkqGYS285fbBdbSGLeI0L8I=;
        b=gMJF/L3t24hAHDyUsGRB/NqNmUL6zYYH6qXr8SosxZH1AfPA6P6HC1Azqo0TdyrRar
         LzG+D3NvZmw8ddts8eJMGLsgnHbR7Zxm8MjqHCj2IlTcl6o7riDi7ncwt5eJTDvfvKZ3
         5oCRK0HfLyyok8Ot1wfsijygccBgtoaeyg89OkyE+R8n+qecs6EBE8lVoEs+1bc+18tc
         REDtBAVeQnuclPSu99qiDeVyrWu6/HEB4g1ywCkI4vstS8vbI5fuRwMSbMFiBxZXrKtd
         nbKUmzMh7ilF/9Tp+ciwbCi1VxZOLKQ4/LWbOT2NdfgIlunACfH8NUm+sYhZ7eP+JnR6
         9n6Q==
X-Gm-Message-State: AOJu0YzcKS2MNPGOnAC0kiBGvR4Kn7M61ufgc48/hTL7fIVOcTSAHPOW
        Ozb4UkVkoBJZu2i3sr/Q4xfvJdda36x/g9knB/c=
X-Google-Smtp-Source: AGHT+IE37PwiaaharuOYglaqMrIefRjTshaUYYCrs5sJDJbnJZAu4Fs/Dpf9Xf1thpUqFoIR23Z4wyPoXSzOL6MVNWQ=
X-Received: by 2002:a25:414b:0:b0:d9c:e705:5d48 with SMTP id
 o72-20020a25414b000000b00d9ce7055d48mr20541484yba.1.1699380890752; Tue, 07
 Nov 2023 10:14:50 -0800 (PST)
MIME-Version: 1.0
References: <d3e2ffd8-3ebe-4e28-8509-c76f2b991ca3@moroto.mountain>
In-Reply-To: <d3e2ffd8-3ebe-4e28-8509-c76f2b991ca3@moroto.mountain>
From:   Justin Tee <justintee8345@gmail.com>
Date:   Tue, 7 Nov 2023 10:14:40 -0800
Message-ID: <CABPRKS9aAP7ngRkGRxZGggeRQVDJCGA=w_AW+YB+ahiO7TtkUQ@mail.gmail.com>
Subject: Re: [bug report] scsi: lpfc: Add EDC ELS support
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     jsmart2021@gmail.com, linux-scsi@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dan,

> On Tue, Nov 7, 2023 at 7:26=E2=80=AFAM Dan Carpenter <dan.carpenter@linar=
o.org> wrote:
> This is a couple years old but apparently, but I've never reported it
> before.  Smatch wanted a goto try_rdf; here.  Not sure if Smatch is
> correct.  If not just ignore this it.  These are one time emails.

I think return =E2=80=93EIO on line 4353 is fine.  If lpfc_nlp_get(ndlp) fr=
om
line 4350 returned NULL, then we want to early return and not issue an
RDF.  This behavior is consistent with the !ndlp check on lines
4307=E2=80=934308.  If we don=E2=80=99t have a valid ndlp login context wit=
h the
Fabric, then there=E2=80=99s no point to goto try_rdf to issue an RDF.

And for line 4353, I confirm that the only unwind needed is
lpfc_els_free_iocb from the previous line.

Regards,
Justin
