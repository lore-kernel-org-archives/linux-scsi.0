Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F863C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 03:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08FF92082F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 03:13:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bxIFkbvN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfKZDNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 22:13:02 -0500
Received: from mail-io1-f48.google.com ([209.85.166.48]:38575 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfKZDNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 22:13:02 -0500
Received: by mail-io1-f48.google.com with SMTP id u24so17112251iob.5
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2019 19:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QEIejJXcRC4WlPC8wmM6MfOLdn3fWdMUTlqgNdFaAWk=;
        b=bxIFkbvN5t6g3gU9glU2iDTicMbwYw/F4tvvMgSdmhoOglsJ3qdh0qK8PuvOawG3Ri
         mbC5x0WEoKo28M/F4ZicjlkUzOcqIE42ELcUCXyOSAus+Cw5x2dDnEneVBolYAIO1sh1
         F9c8SA7AFRP/R3bJ6ZqBWNWQDycQHusNcxrgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=QEIejJXcRC4WlPC8wmM6MfOLdn3fWdMUTlqgNdFaAWk=;
        b=Pcs11UW0pf36anduoP+v+E+05TY+X11j4l6mMqigDz1LeWRdjA2l6escFCNA3etpN4
         d6Y9Tj8ZyRl/N/FbgOau7QWKzemEL1yx+gm/ac7BCYa/rEKpdBDpc3J9aQXHNWbX2CDP
         oxCeqW17VGJthYt+U0eAsbXSaiY/te5FE3EjTXPpj5RJh42DjdfUE/d4+iRFAgnTwu8P
         z6GjLugLmNi0Kc8Wpx93Q+nioZDgL+SqJwSeIykIOlIn5wHjnRuZvtucyhQNTXWShvfR
         rF2wgdbhc8LW015iMBPl/WUv2FK1EuOTjdbCQPmX2D1jMCQGqEIQ29mhsCE9y1dVXSH9
         jnLw==
X-Gm-Message-State: APjAAAWYuaiavj6NWASB7xbQ1G5ZNTlb4nTbLmD/EGfpP+7L3bQuNMSJ
        MRhK2ZqAEoSTxzPcvIBaZGTQ+yScSe8ZOWDYYP92qg==
X-Google-Smtp-Source: APXvYqwMjr1NzRfz7PLI7iRLKUS03EZe++YWkGhiTW60tgUub5D6Y96J/QeJBkDuoHxs6anlUIuYdwB7/8wr1+4jtJY=
X-Received: by 2002:a02:7683:: with SMTP id z125mr28651246jab.84.1574737981691;
 Mon, 25 Nov 2019 19:13:01 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20191118103117.978-1-ming.lei@redhat.com> <20191118103117.978-2-ming.lei@redhat.com>
 <97bf460e-62c9-dc64-db4c-fb5540e70ae9@suse.de>
In-Reply-To: <97bf460e-62c9-dc64-db4c-fb5540e70ae9@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQH3BpsAXu9UwBJw1xp6lr9PVp09cQMYv4CvAYuhPOanNN3E8A==
Date:   Tue, 26 Nov 2019 08:42:59 +0530
Message-ID: <252362ee5ac748694d205441729c433f@mail.gmail.com>
Subject: RE: [PATCH 1/4] scsi: megaraid_sas: use private counter for tracking
 inflight per-LUN commands
To:     Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >  drivers/scsi/megaraid/megaraid_sas.h        |  1 +
> >  drivers/scsi/megaraid/megaraid_sas_base.c   | 15 +++++++++++++--
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 13 +++++++++----
> >  3 files changed, 23 insertions(+), 6 deletions(-)
> >
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Ming - Sorry for delay. I will update this Patch. We prefer driver to
avoid counter for per sdev if possible. We are currently testing driver
using below changes.

inline unsigned long sdev_nr_inflight_request(struct request_queue *q) {
    struct blk_mq_hw_ctx *hctx =3D q->queue_hw_ctx[0]

    return atomic_read(&hctx->nr_active);
}

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		      Teamlead Storage & Networking
> hare@suse.de			                  +49 911 74053 688
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg =
HRB
> 247165 (AG M=C3=BCnchen), GF: Felix Imend=C3=B6rffer
