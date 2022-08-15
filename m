Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A59C00140
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Aug 2022 15:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiHOP0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 11:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiHOP0g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 11:26:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3218015FF4
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 08:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660577195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gRm8Qm84cdP80jnwoCtGTGa5zd6N03cK9WEkK0EjwzE=;
        b=dPBFo260ChttCP1n8LTRCnfJRTLaUPCIYTaFR1EGzJ5e3Vwx5vebd1DjPXE6kbcreLFtiF
        lnOOpgDqnL7HvYZzT/wZ2o0lDkX68x94WKpDyZv7UtN63/sXdkq3RybEr2rSVp20nLWd/V
        pXe0EMF00iup0nxi9of6Aduqg6gYxVI=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-624-s9K0QdcrPd2AXA5jXghstQ-1; Mon, 15 Aug 2022 11:26:33 -0400
X-MC-Unique: s9K0QdcrPd2AXA5jXghstQ-1
Received: by mail-il1-f197.google.com with SMTP id i4-20020a056e0212c400b002e5c72b3bd7so1547923ilm.6
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 08:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=gRm8Qm84cdP80jnwoCtGTGa5zd6N03cK9WEkK0EjwzE=;
        b=dOejFdD7t5sPPvogWMepC+18pwbm+x36gUEUKbxagm/6ctGszSO+9eYQHPakjRZ1Nl
         nyJb9huNBNj1sc9A0MZrzYi2EWkPYFmHTeu9vIhB7s//g0NK9BBxZbHG1AGebEl0uLo9
         HoAHiRXH5qU5yBPwKlyPM4pJey7bdYg+egogc95WvFwb31e/+diFSnKytBMqnDVb5bnz
         /v22ARYKlXKp+GgZNHcnb4KGRkPD36qk9cOULa4znFqLFwL9ViujNKo6A8u+5FRjg9VQ
         hQ/TfuGND2uHMUsvf71HtXV9U0H4FamTET05zUZn60Ti0t7QSAgzT84tLzClq8xrF7R1
         hnIA==
X-Gm-Message-State: ACgBeo2KcC2dcow608CK+SBjzLFdLcJpMB+i9dFiNdrcyp2GvlvI9Ggu
        eIl5VXIDWbXVlEFP37+EBN5AkrbfQVQY3BrNyXmzIzftoHtlmKlK1NdAd4anl9yUxTfVtCdxjRB
        ekgCp+EJKYREdbEgUL0g4jZmoZ7+4EousyX78Dw==
X-Received: by 2002:a02:600f:0:b0:342:9185:60b4 with SMTP id i15-20020a02600f000000b00342918560b4mr7681839jac.248.1660577193160;
        Mon, 15 Aug 2022 08:26:33 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6GhuM4k9A0g3gyj4yVJnu3JQGRWjWFhjqYUWSQLhH3n0g5zhM4HyWnCgLw6Olc0OHrhmS552ZRfvxluZnwxXo=
X-Received: by 2002:a02:600f:0:b0:342:9185:60b4 with SMTP id
 i15-20020a02600f000000b00342918560b4mr7681828jac.248.1660577192994; Mon, 15
 Aug 2022 08:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220812204553.2202539-1-bvanassche@acm.org>
In-Reply-To: <20220812204553.2202539-1-bvanassche@acm.org>
From:   Ewan Milne <emilne@redhat.com>
Date:   Mon, 15 Aug 2022 11:26:22 -0400
Message-ID: <CAGtn9r=QrDBcEssvtwrEcXa6xO-8Jp3rMfJ09CxDNMhc549z_g@mail.gmail.com>
Subject: Re: [PATCH 0/4] Remove procfs support
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

You want to *remove* a user-visible interface that has been there
for decades (granted, /proc has its issues and sysfs could replace it)
because you want to make a kernel data structure a const structure?

Many other things in the kernel still provide a procfs interface.


-Ewan


On Fri, Aug 12, 2022 at 4:46 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Hi Martin,
>
> The SCSI sysfs interface made the procfs interface superfluous. sysfs support was
> added in the most prominent user of the procfs interface (sg3_utils) in 2008. The
> implementation of the procfs interface makes it harder than necessary to constify
> the SCSI host templates. Hence this patch series that removes the procfs interface.
>
> Please consider this patch series for the next merge window.
>
> Thanks,
>
> Bart.
>
> Bart Van Assche (4):
>   scsi: esas2r: Rename two functions and two variables
>   scsi: esas2r: Remove procfs support
>   scsi: core: Remove procfs support
>   scsi: core: Update a source code comment
>
>  drivers/scsi/Kconfig               |  11 -
>  drivers/scsi/Makefile              |   1 -
>  drivers/scsi/esas2r/esas2r.h       |   4 +-
>  drivers/scsi/esas2r/esas2r_ioctl.c |   2 +-
>  drivers/scsi/esas2r/esas2r_main.c  |  43 +--
>  drivers/scsi/hosts.c               |   5 -
>  drivers/scsi/scsi.c                |   8 +-
>  drivers/scsi/scsi_devinfo.c        | 146 ---------
>  drivers/scsi/scsi_priv.h           |  17 -
>  drivers/scsi/scsi_proc.c           | 477 -----------------------------
>  drivers/scsi/sg.c                  | 358 ----------------------
>  include/scsi/scsi_host.h           |   8 +-
>  12 files changed, 14 insertions(+), 1066 deletions(-)
>  delete mode 100644 drivers/scsi/scsi_proc.c
>

