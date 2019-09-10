Return-Path: <SRS0=qYHy=XF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B30C4740A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 11:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A35D2089F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 11:18:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nv5Oj6uq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392907AbfIJLSH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 07:18:07 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39293 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392848AbfIJLSG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 07:18:06 -0400
Received: by mail-qk1-f196.google.com with SMTP id 4so16527437qki.6;
        Tue, 10 Sep 2019 04:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=frO/4e4TV6SO1RRZqWT4we5pX4/lanaUDNg2viAs+M8=;
        b=nv5Oj6uq2Kul7q7iwz0WJZUmQBxNZYQuCmJM1wWz2mpnaISpld8W+mb5BFrlrkjTHC
         8BGIPSecP45RYl26aOXhk4EUh/xUDoum9Os+LYpHUg0bqOlTrsOlK1C12rhF+EqPlLTN
         ytzxDTifEbFNVaFZvJcerT1ty3JNdxBWGf0gMM56kRCgIqPHq5MULth5Z9txeY6L1SoP
         TjOWfrqPN2PwTM3BQOFf+zIYeuDmsuCmv/jAVhEqYLyHEiPnfOhv9FUdWaXaN/VlJ/5S
         80xdUSGZKKNnGeGx6d5g2/0J6oQX3VVI20/iI+1vBLoWHVpGR7IFXIwIW03fShgmkzkB
         YsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=frO/4e4TV6SO1RRZqWT4we5pX4/lanaUDNg2viAs+M8=;
        b=G1kpSYU9ocUDy0OiS7qgWzYAB44KJDQg3b7y3No0iBkOqNW04b8Wee1d5sHc4bFd+5
         uczpiqpOzGnNb1SmMdx5D9Lb3SHHN/G81TLICSEXDBfdDPdNPZZ3MO20hz4XjUB2bFYy
         tFcJtcJqqxyDj26d5rZd7O8VO85/2hU5L/Ha00JejTCSs4oJjMW2DsNjGbjGhmXBw+J4
         mCC1S0/sJhEqFqIa0/SRPfHPQrpVknM6ViF4dqSYvKB83SQm1TZ4tiseTHi31kwTaUfa
         ss2O58GVvAXCjbmiRibd8gsUaYk91jfYrU9rZ9NnmNZG6Vwk0qT+veLkIkyXJj3fPV59
         SeAg==
X-Gm-Message-State: APjAAAXnDSPNrTUcNtTVJC1qX5Smx6nQYMguA2dYeB6NhkbtKrLAodov
        hrK6/FQWK/8ftW2FwEuEy8/Df2rPbTAYrQ7b4lU=
X-Google-Smtp-Source: APXvYqxVriuHghKffsomFZFQ7snbX8qOdBWioDf5ZIGKnykMN8oM/e5Cj7MB7MrFUSNQvZDhS0IbEOPHDQTpwEMpn+U=
X-Received: by 2002:a37:a946:: with SMTP id s67mr29298195qke.470.1568114285444;
 Tue, 10 Sep 2019 04:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190909054219.GA119246@LGEARND20B15>
In-Reply-To: <20190909054219.GA119246@LGEARND20B15>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Tue, 10 Sep 2019 20:17:59 +0900
Message-ID: <CADLLry4CjS+1syBCf68BFUbWxZJ8UGcUphinE1Hs7FRvdK0ikg@mail.gmail.com>
Subject: Re: [PATCH] scsi: dpt_i2o: drop unnecessary comparison statement
To:     aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello, Maintainers...
Would you please review this patch and share the feedback?

Thanks,
Austin Kim

2019=EB=85=84 9=EC=9B=94 9=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 2:42, Au=
stin Kim <austindh.kim@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> The type of 'chan' is u32 which contain non-negative value.
> So 'chan < 0' is statment is always false.
>
> Remove unnecessary comparison statement
>
> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> ---
>  drivers/scsi/dpt_i2o.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index abc74fd..df48ef5 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -1120,7 +1120,7 @@ static struct adpt_device* adpt_find_device(adpt_hb=
a* pHba, u32 chan, u32 id, u6
>  {
>         struct adpt_device* d;
>
> -       if(chan < 0 || chan >=3D MAX_CHANNEL)
> +       if(chan >=3D MAX_CHANNEL)
>                 return NULL;
>
>         d =3D pHba->channel[chan].device[id];
> --
> 2.6.2
>
