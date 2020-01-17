Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3298C33CB6
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 14:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFAED2083E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 14:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Ldgz/1Ey"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgAQOJK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 09:09:10 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:41573 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAQOJI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 09:09:08 -0500
Received: by mail-il1-f193.google.com with SMTP id f10so21350094ils.8
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2020 06:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZQTKiWhb+mlUFEsYNRPuhDSO62Bf/P9OysX1lBNLHbg=;
        b=Ldgz/1Ey4ervR8uUqE1fpwEJykRSg9th87806nhOV+njUTuV7kYWLj2WWbrWbyMpt6
         /8vdwyFksfHZhK6Ms8OZINd8oJoHNJKgw87y9gIouJKkzx66dX2giDMxhhTKOtfmamv3
         VYuORK8sP+5RbA/Ech3ClUx2VQuBsSIhWXEoTCdhiKE2a+vXVcC0RzzzKbzSMMvXf7si
         8btqNg9QZTojFqrQ8yhFQdlY8Wsjnm3VB0Egb2OcfhOkPuECMZXT/cBiZsYUrAhvdEZ0
         uDlO4SOx+JEa3byugeRWe++GpVUdbL7/RES1dig5ZeYmmJxQvipSY3SpVXvzD0A9Sn0m
         8qdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZQTKiWhb+mlUFEsYNRPuhDSO62Bf/P9OysX1lBNLHbg=;
        b=BwmkczAAchVYMQEPcMUp8q6ap+Jq+OlOMt4FMvednbMbo8KW1qDxwWREKb9KqnW1s3
         YQ/0DWad4PhfSwTc0oD238S1v5kQLN/2cijWieKj9pqaSIgjlQhXs64KX29STi4zppiE
         zJ3TFVwRFLjcdRMJ1p8gQxNey01+2sxt4pE/eBB1B8qLGEyTGiDmxzxGuKSjmieVJqds
         XHNx0fR/zWxIUBJ3yoBLt2vift77NWejlishW2LzzhSXG6TZlBsnBAtnLaWuJbqdYbbI
         Qw3Oo3sbHJJJ0YbgUtBPqFEYDxiiyoF5EPnqHYuxh1B/3CoTAo5tJygaZTjlwTHgIHw4
         mRDg==
X-Gm-Message-State: APjAAAW+mr61B7LfSWQ21qIDIZyb50lqdB7Z3K07atnCZr52HkLvotr+
        Cz7S8gK5Vv9NxIfSaEPRHckcLXALbm5GPN57/eMEDw==
X-Google-Smtp-Source: APXvYqyqgjBDs+N9EIS3cHUrP9UQAJNS26at0U66wuQdqUXAKAnt6IOH7LIPJlibMJCP7fds4dYsCk0HMVPcsemkwag=
X-Received: by 2002:a92:d2:: with SMTP id 201mr3242371ila.22.1579270148136;
 Fri, 17 Jan 2020 06:09:08 -0800 (PST)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com> <20200117071923.7445-2-deepak.ukey@microchip.com>
In-Reply-To: <20200117071923.7445-2-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 17 Jan 2020 15:08:57 +0100
Message-ID: <CAMGffEmP+UfQS+9dUEjQvnJ0HZLRD-X_xJufRK_iQ8JTPQzb5A@mail.gmail.com>
Subject: Re: [PATCH V2 01/13] pm80xx : Increase request sg length.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 17, 2020 at 8:10 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Peter Chang <dpf@google.com>
>
> Increasing the per-request size maximum (max_sectors_kb) runs into
> the per-device dma scatter gather list limit (max_segments) for
> users of the io vector system calls (eg, readv and writev). This is
> because the kernel combines io vectors into dma segments when
> possible, but it doesn't work for our user because the vectors in the
> buffer cache get scrambled.
> This change bumps the advertised max scatter gather length to 528 to
> cover 2M w/ x86's 4k pages and some extra for the user checksum.
> It trims the size of some of the tables we don't care about and
> exposes all of the command slots upstream to the scsi layer
>
> Signed-off-by: Peter Chang <dpf@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> ---
>  drivers/scsi/pm8001/pm8001_defs.h | 5 +++--
>  drivers/scsi/pm8001/pm8001_init.c | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
> index 48e0624ecc68..1c7f15fd69ce 100644
> --- a/drivers/scsi/pm8001/pm8001_defs.h
> +++ b/drivers/scsi/pm8001/pm8001_defs.h
> @@ -75,7 +75,7 @@ enum port_type {
>  };
>
>  /* driver compile-time configuration */
> -#define        PM8001_MAX_CCB           512    /* max ccbs supported */
> +#define        PM8001_MAX_CCB           256    /* max ccbs supported */
Hi Deepack,

Why do you reduce PM8001_MAX_CCB?

The patch itself looks fine.
