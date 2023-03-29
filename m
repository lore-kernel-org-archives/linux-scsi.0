Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC88FC74A5B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 04:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjC2EVb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 00:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjC2EV3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 00:21:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F72B0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 21:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680063639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nbKf5eN9+mQg0HV05YRHLZVg+yTUhGtNTNGQ2fk6wKI=;
        b=QlaznqOGXkdCRyZaU1gO6NcL8mp0ry1X6NqaFVlXI0HKKG2Klzn5telTvmYoxIRUuiBdp6
        4T+49YQ4EWve0lrx7O0yb6iwY87WUOYJmieO1/jhsUKrFqXYB+9qfykqdXlaoVXmepsCTh
        XyMNaS32k8z+IV1e4wdrUcR50CMgvJg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-VjYHpCZmMqOa4JTI8r1SPw-1; Wed, 29 Mar 2023 00:20:36 -0400
X-MC-Unique: VjYHpCZmMqOa4JTI8r1SPw-1
Received: by mail-pj1-f71.google.com with SMTP id ie21-20020a17090b401500b0023b4ba1e433so4086863pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 21:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680063635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nbKf5eN9+mQg0HV05YRHLZVg+yTUhGtNTNGQ2fk6wKI=;
        b=mtbT1e+4x66+lHI4+zm87tnDCSd7KJQsYlkANpsshsAPin5x/eS1uuJ2g+my8RSQLS
         s3fbbo8SJaDn66ygDddtwC7J1nPjNyBUwWaAzOnmmpjLmnTzdKpyhggpSWhtiGdNDph7
         H9UZbvmETGFGuDzg2PrwbTlegAffCKB9KVvL3nT33usGtBQbWAE0s5ixHCSFG0IpWfaG
         XRBY0qRLbeChAXABQClJmz7QMmiJV0CVTW4imGYEACWFyU0V2txlporOsksjHCv39UnV
         n5EHHEtvC5VFmKiYVtC6e9rEqT4G1XHHoYNlSYbeNGbAYMJQ2MLJHHZsYSKuKPiqtbcy
         rqrg==
X-Gm-Message-State: AAQBX9eJ0WLNSVcOtEb+aJpolurrsQYMCsf7cIy278xR9jZy7XmJLBVf
        6bjH3XfsAXs4Rdmd3BVmO5nyTf0evg1XhklsPtci4uo15Y9ja+2y/gpJgjvYfxr4grGb2vo4xhR
        HN4Og9aDsyrlHQeetKFAeXoisxgU9fU6pv46k/g==
X-Received: by 2002:a17:902:c101:b0:1a1:e48b:98b8 with SMTP id 1-20020a170902c10100b001a1e48b98b8mr6960263pli.10.1680063635340;
        Tue, 28 Mar 2023 21:20:35 -0700 (PDT)
X-Google-Smtp-Source: AKy350bylEcmNtK2xkxIU7zsD/T2DbkzbfXwdwKVjps9jtO6MUzVAe8C+NOj8acp6hZbQlftTI+vobfoTz5WgNbaRCU=
X-Received: by 2002:a17:902:c101:b0:1a1:e48b:98b8 with SMTP id
 1-20020a170902c10100b001a1e48b98b8mr6960258pli.10.1680063635079; Tue, 28 Mar
 2023 21:20:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230327074310.1862889-1-john.g.garry@oracle.com>
 <20230327074310.1862889-2-john.g.garry@oracle.com> <44d3878a-363e-632c-8e7d-d8bb016ac8df@interlog.com>
In-Reply-To: <44d3878a-363e-632c-8e7d-d8bb016ac8df@interlog.com>
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Wed, 29 Mar 2023 12:20:22 +0800
Message-ID: <CAHj4cs_yrMxEeYtV55m3GMkM3ZbU3HJ-_Uct44-3=A4_ZvW1fQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] scsi: scsi_debug: Fix check for sdev queue full
To:     dgilbert@interlog.com
Cc:     John Garry <john.g.garry@oracle.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 29, 2023 at 7:37=E2=80=AFAM Douglas Gilbert <dgilbert@interlog.=
com> wrote:
>
> On 2023-03-27 03:43, John Garry wrote:
> > There is a report that the blktests scsi/004 test for "TASK SET FULL" (=
TSF)
> > now fails.
> >
> > The condition upon we should issue this TSF is when the sdev queue is
> > full. The check for a full queue has an off-by-1 error. Previously we
> > would increment the number of requests in the queue after testing if th=
e
> > queue would be full, i.e. test if one less than full. Since we now use
> > scsi_device_busy() to count the number of requests in the queue, this
> > would already account for the current request, so fix the test for queu=
e
> > full accordingly.
> >
> > Fixes: 151f0ec9ddb5 ("scsi: scsi_debug: Drop sdebug_dev_info.num_in_q")
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Link: https://lore.kernel.org/oe-lkp/202303201334.18b30edc-oliver.sang@=
intel.com
> > Signed-off-by: John Garry <john.g.garry@oracle.com>
> Acked-by: Douglas Gilbert <dgilbert@interlog.com

Confirmed the change fixed the blktests scsi/004 failure issue, feel
free to add:
Tested-by: Yi Zhang <yi.zhang@redhat.com>

>
> Thanks.
>
> > ---
> >   drivers/scsi/scsi_debug.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index 7ed117e78bd4..782515abca2c 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -5580,7 +5580,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, =
struct sdebug_dev_info *devip,
> >               int num_in_q =3D scsi_device_busy(sdp);
> >               int qdepth =3D cmnd->device->queue_depth;
> >
> > -             if ((num_in_q =3D=3D (qdepth - 1)) &&
> > +             if ((num_in_q =3D=3D qdepth) &&
> >                   (atomic_inc_return(&sdebug_a_tsf) >=3D
> >                    abs(sdebug_every_nth))) {
> >                       atomic_set(&sdebug_a_tsf, 0);
>


--=20
Best Regards,
  Yi Zhang

