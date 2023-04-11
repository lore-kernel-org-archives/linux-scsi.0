Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23441C77B6F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 15:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjDKPoe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 11:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKPod (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 11:44:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EA5173A
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 08:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681227828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e+9zXyi8zdboRFVIHdeXsgxqr04iK6BIwTRIv6+bBdk=;
        b=Io0UGuXHX+v1jwF8Y4NHI5EVbVNYk6p0XEF74st/DBwcInGFWpl/IuV9XdxAYfwhakrl2m
        PJOY3DWkS7Bih6eVIavGLvhmNnNleUAVJUCZWL65Q+uCJbom9gKmwY3Y7u5h1v6UN1NEgh
        v0LyrY43q4VGg7rbOjrqzT4BekBisYs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-Q-RgbHVNMUWA6YjaGyb4Gw-1; Tue, 11 Apr 2023 11:43:38 -0400
X-MC-Unique: Q-RgbHVNMUWA6YjaGyb4Gw-1
Received: by mail-qk1-f200.google.com with SMTP id n129-20020a374087000000b0074a2ff16363so13030849qka.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 08:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681227817; x=1683819817;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e+9zXyi8zdboRFVIHdeXsgxqr04iK6BIwTRIv6+bBdk=;
        b=BkFw069GEMm/rmOeCBEs5qPh5FuX6M+NkBpZxp0vqhqQL1M0oHoT6TSB8uSw3Lx8uV
         /M58YEw+8ZXNscRp/GMhucT7MY1nKts+AkUNSt5SLbAUOhmaZd4HiSpwA1BHBsAZWJZa
         gWkUGIjS4nOSL9DDttogNk+F1iznZBBML9EJ+8Z03TW2WSLt87Nbn8fzyCBf7rfq7+L+
         uuyxn9XLpBSY0mzD0O+DmjByblp9KBV8QBVTwDhU1opp/GJpK2w8yV6xgtO5XruDr6ja
         KgJncM/2bBABjPap45TuJwt/y17ogZPX8RcXRgOgPUmSTVCWLmYvTyFw+bURdH5ZzG2H
         MJRw==
X-Gm-Message-State: AAQBX9e+8Em+EkOavdJIOaKSZivWeY8ZpA7+jgIdYBMdkKkzm/woqP6L
        XBe+JMJQgHfqdbapZHypPgLW1K2uZXVFZXzdMOHrDLGaAEyD/Y/Ps8oapFmTKiOfdQgCrKSK4pO
        m8biduJlxYGNxa+o5SUjbciaICWauGQ==
X-Received: by 2002:a05:622a:11c7:b0:3bf:d196:5e27 with SMTP id n7-20020a05622a11c700b003bfd1965e27mr23696796qtk.20.1681227817707;
        Tue, 11 Apr 2023 08:43:37 -0700 (PDT)
X-Google-Smtp-Source: AKy350bLPgq16DQg/CiDMoGUc4XZJGdfXNeHdDerjD4rh2UaoizJ/23PqeE7Kl1NIxklYcYZbWJ8oA==
X-Received: by 2002:a05:622a:11c7:b0:3bf:d196:5e27 with SMTP id n7-20020a05622a11c700b003bfd1965e27mr23696777qtk.20.1681227817480;
        Tue, 11 Apr 2023 08:43:37 -0700 (PDT)
Received: from [192.168.1.52] (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id n9-20020a374009000000b00742bc037f29sm4026759qka.120.2023.04.11.08.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 08:43:36 -0700 (PDT)
Message-ID: <4b16b673ba4d38417353970628e494714fcc1937.camel@redhat.com>
Subject: Re: question about mpt3sas commit b424eaa1b51c
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Tomas Henzl <thenzl@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Date:   Tue, 11 Apr 2023 08:43:34 -0700
In-Reply-To: <3b2829ee-93f1-feb1-d113-cbc084d23149@redhat.com>
References: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
         <3b2829ee-93f1-feb1-d113-cbc084d23149@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-04-11 at 15:09 +0200, Tomas Henzl wrote:
> On 4/8/23 21:18, Jerry Snitselaar wrote:
> > We've had some people trying to track a problem for months
> > revolving
> > around a system hanging at shutdown, and last thing they see being
> > a
> > message from mpt3sas about a reset. They quickly bisected down to
> > the
> > commit below, and reverted it made the problem go away for the
> > customer.
> >=20
> > b424eaa1b51c ("scsi: mpt3sas: Transition IOC to Ready state during
> > shutdown")
> >=20
> > I got asked to look at something since I recently at another issue
> > that involved mpt3sas at shutdown, so I was looking through the
> > history, saw this commit being mentined. Looking at it, I'm not
> > sure
> > why it is doing what is doing.
> >=20
> > It says it is to perform a soft reset, but that was already
> > happening before this commit via:
> >=20
> > scsih_shutdown -> mpt3sas_base_detach ->
> > mpt3sas_base_free_resources -> _base_make_ioc_ready(ioc,
> > SOFT_RESET);
> >=20
> > The original submission [1] had the following commit message:
> >=20
> > "During shutdown just move the IOC state to Ready state
> > by issuing MUR. No need to free any IOC memory pools."
> >=20
> > But is now skipping more than not freeing the memory pools. It no
> > longer frees memory that was kalloc'd, it doesn't unmap something
> > that
> > was iomapped, it no longer cleans up the fault reset workqueue, and
> > no
> > longer calls the pci cleanup code. It also no longer does the
> > things
> > it moved to scsih_shutdown under the pci access mutex, nor uses the
> > if
> > condition that was in mpt3sas_base_free_resources.
> >=20
> > [1]
> > https://lore.kernel.org/r/20210705145951.32258-1-sreekanth.reddy@broadc=
om.com
> >=20
> >=20
> > Am I missing something, and what the commit does here is really
> > okay?
>=20
> When a driver's shutdown method is called it may be still processing
> in
> parallel I/Os (that may also happen any time later) so not releasing
> the
> resources the driver has allocated is correct. A next step is then a
> power off or a boot of a new kernel anyway.
> A driver should stop DMA transfers and IRQ's, silence itself and when
> needed inform the attached hw to flush memory or whatever else.
>=20

Should it clean up dma mappings then? All of that memory pool stuff is
still mapped.

Thanks for the info.

Regards,
Jerry

> (The fix I've posted for the DMA issue in shutdown has this subject
> 'mpt3sas: fix an issue when driver's being removed')
>=20
> Regards,
> Tomas
>=20
> >=20
> > Regards,
> > Jerry
> >=20
>=20

