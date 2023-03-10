Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDE7C64EC4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 06:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCJGbZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 01:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCJGbY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 01:31:24 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617DB10492B
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 22:31:23 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x3so16290853edb.10
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 22:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1678429882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sg5IDQVzoHHx9juAi4oyOBm+SjRQfbgHMhEURnQ4C88=;
        b=a86p7s1NvMVybuIMFnfbwegln2H4dCGlTlt0mJPcIb/cMRXqX0bG3H3Y9w9B2kxKUX
         yo4b61NN6QNDZTTs8a4aHWgtPX58jbnNOoOM7Kdp/js+b/yxf9oGcUbn/JzrLyp79XZN
         vdbrfDDWPGTawuDyxwlVtLeNkY9NqTDI2mXaXk8QkYomJ5v1UdC8wbhaUSppth7TY3r0
         IRrXIFw5iqV63mSYo1OeO9KVEda74yutU9zYE3dp1+YHKMF42M+cE51RX7xsmcUJzau+
         CCkULZZkE30XhsCTpgnTQbSD1RfaC8b3n5MwcwThsAl7FCwtmZFM7hROIsMxUABjGhol
         6r6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678429882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sg5IDQVzoHHx9juAi4oyOBm+SjRQfbgHMhEURnQ4C88=;
        b=dDW9YaiGBr4GCzTkocctfNc+PZvcnoEWfEpKendDZOi/8HPdyKS7xkhJF61j+T//4l
         wV5pNSaisUc45fqQHs++xp4TEuuhsx1VWVAGSFk1/J5WeCXPXMo12TzgiPg6fbtdj7Bo
         QH6z1dHulSQa9ldk38f6gdoHFUzt304P7pDcT3nbi5pbPGuvg7X0Cnkm56+n0QgXbOoM
         ObkDr0kzAvYph0fW576SZ6AJWlwVmZ1u4rTvJyEJiXY+qzMgfD/qGT2T6qgB4akGZU6q
         0Aw5GchFit/WurNCiW98ikHAx+qFhP2ck+5D7FqcHo3NPHORq7wQckD3eDS7YpGg+b0t
         PC6A==
X-Gm-Message-State: AO0yUKU18ZL8XCblXFKMkJR9SgJENw4lX+1gbDKkD48T/x25CAHlIOln
        iOo9I6NpDH6SM4YCntQ0rDCq8KKIxGji72wZ2iKyAQ==
X-Google-Smtp-Source: AK7set+C5rPOSwx6rJCQzVfey7qk5pYmOpHBz4UREqtXYc/FcJa1v6JE+A9lsjGX37Ti87QJ14z8KHTmhMIxsKeff7U=
X-Received: by 2002:a17:906:498e:b0:901:e556:6e23 with SMTP id
 p14-20020a170906498e00b00901e5566e23mr12494714eju.0.1678429881857; Thu, 09
 Mar 2023 22:31:21 -0800 (PST)
MIME-Version: 1.0
References: <20230309192614.2240602-1-bvanassche@acm.org> <20230309192614.2240602-64-bvanassche@acm.org>
In-Reply-To: <20230309192614.2240602-64-bvanassche@acm.org>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 10 Mar 2023 07:31:10 +0100
Message-ID: <CAMGffE=16SJf9EK_8Ouw0kmmFB+6UP--xPFg8b+9u3Lhrns06w@mail.gmail.com>
Subject: Re: [PATCH v2 63/82] scsi: pcmcia-pm8001: Declare SCSI host template const
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 9, 2023 at 8:29=E2=80=AFPM Bart Van Assche <bvanassche@acm.org>=
 wrote:
>
> Make it explicit that the SCSI host template is not modified.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>

>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index 7e589fe3e010..8b9490011e36 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -96,7 +96,7 @@ static void pm8001_map_queues(struct Scsi_Host *shost)
>  /*
>   * The main structure which LLDD must register for scsi core.
>   */
> -static struct scsi_host_template pm8001_sht =3D {
> +static const struct scsi_host_template pm8001_sht =3D {
>         .module                 =3D THIS_MODULE,
>         .name                   =3D DRV_NAME,
>         .proc_name              =3D DRV_NAME,
