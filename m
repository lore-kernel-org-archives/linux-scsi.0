Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58F4C74A5B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 14:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCPOHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 10:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCPOHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 10:07:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5601CD58BE
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 07:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678975588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UgMDTiStEF85Ioza/girhQTz9UClQi/pg6W3A0BYpDE=;
        b=Ja8qrWgiamIGbMCn4jk/hf4wS07tSRGlli8u87WS2mia2ugbGCEa/+fhsiAp7LgMgWv8OC
        0yzb/JOBuJzcfQg2zVKH3xrtNs/DTTLUDQFiiCiTLD+q4aG70y2XMytpIVqqvn/QOVSwgD
        hBSCWCkQ5AFstqvoL9+a6rMxI3SKyI8=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-5baym8mEOXaNUV5SZ3RfbA-1; Thu, 16 Mar 2023 10:06:27 -0400
X-MC-Unique: 5baym8mEOXaNUV5SZ3RfbA-1
Received: by mail-yb1-f200.google.com with SMTP id e11-20020a5b004b000000b00b37118ce5a7so1974965ybp.10
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 07:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678975586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UgMDTiStEF85Ioza/girhQTz9UClQi/pg6W3A0BYpDE=;
        b=rCqbSgHmTkUaGq6PoqMAMuohbqRIo0FkjRKyzQBrKj2I0XzZfQEeEkIju0xBDPO/c7
         zoNYmeu5/UFUOWVo3tVoS/wX8RwuULnibIk3q6I7nwULODq4FY+R3A/Utlo7+RbjSNWK
         eX0K1nljyTm0ucLGIoWytR/UfXO4IQ6iu4o+UnRbainvsAqdmyx4a64SQn3qBZy2iWH/
         BUuT9ej/VRPe2YzcbqPu/RcZsK0sN9tgRoNUsznM9b+KZmh4QvI3BsAFpkon+kp3i4cs
         b26rAAxhuEZUC3ZlqD6NrOLY0j0F1g0DwoZH06zMiOSvsR+iNoYkhIZcZ6S5i/llDTab
         rUQw==
X-Gm-Message-State: AO0yUKWEXasLm7eB0I7bUV2XzkG6tiaPy/OXG5YA4pmInlzD1izmbYXm
        x9FusxjtgtqcaNQqU1xO52eZ9K62dbVUaCy+gh378q0+ZJAUugd+UYdMQbZtP7HfNohNXBQKsaU
        DSajX9RklzcaWNtOTwXLbhsiBfRfipDOQ2T+9Dw==
X-Received: by 2002:a81:4317:0:b0:52e:f77c:315d with SMTP id q23-20020a814317000000b0052ef77c315dmr2404690ywa.3.1678975586629;
        Thu, 16 Mar 2023 07:06:26 -0700 (PDT)
X-Google-Smtp-Source: AK7set+W06+Z1Quvd50yqRAEEP3PdK81dRQNkqvZUU49Z41ptq0NMe3jeG2hBo4qkYa3hyse6foi7+3YaeAREaFfyZk=
X-Received: by 2002:a81:4317:0:b0:52e:f77c:315d with SMTP id
 q23-20020a814317000000b0052ef77c315dmr2404677ywa.3.1678975586373; Thu, 16 Mar
 2023 07:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230315192130.970021-1-desnesn@redhat.com> <20230315192130.970021-2-desnesn@redhat.com>
 <44d364bc-62ac-7d31-b886-0f7ee94e3a08@arm.com>
In-Reply-To: <44d364bc-62ac-7d31-b886-0f7ee94e3a08@arm.com>
From:   Desnes Nunes <desnesn@redhat.com>
Date:   Thu, 16 Mar 2023 11:06:15 -0300
Message-ID: <CACaw+exWmGQwBz5oCsz_YTiQfNt4=hSm1UDb6aV75gABwRb4Zw@mail.gmail.com>
Subject: Re: [PATCH 1/3] dma-debug: small dma_debug_entry's comment and
 variable name updates
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     iommu@lists.linux.dev, linux-scsi@vger.kernel.org,
        storagedev@microchip.com, linux-kernel@vger.kernel.org, hch@lst.de,
        martin.petersen@oracle.com, don.brace@microchip.com,
        m.szyprowski@samsung.com, jejb@linux.ibm.com, jsnitsel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Good day Robin,

Thank you very much for the review and clarification - will send a v2
with the proper comment update.

Best Regards,

On Thu, Mar 16, 2023 at 7:24=E2=80=AFAM Robin Murphy <robin.murphy@arm.com>=
 wrote:
>
> On 2023-03-15 19:21, Desnes Nunes wrote:
> > Small update on dma_debug_entry's struct commentary and also standardiz=
e
> > the usage of 'dma_addr' variable name from debug_dma_map_page() on
> > debug_dma_unmap_page(), and similarly on debug_dma_free_coherent()
> >
> > Signed-off-by: Desnes Nunes <desnesn@redhat.com>
> > ---
> >   kernel/dma/debug.c | 11 ++++++-----
> >   1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> > index 18c93c2276ca..e0ad8db1ec25 100644
> > --- a/kernel/dma/debug.c
> > +++ b/kernel/dma/debug.c
> > @@ -52,7 +52,8 @@ enum map_err_types {
> >   /**
> >    * struct dma_debug_entry - track a dma_map* or dma_alloc_coherent ma=
pping
> >    * @list: node on pre-allocated free_entries list
> > - * @dev: 'dev' argument to dma_map_{page|single|sg} or dma_alloc_coher=
ent
> > + * @dev: pointer to the device driver
>
> The original comment was correct...
>
> > + * @dev_addr: 'dev' argument to dma_map_{page|single|sg} or dma_alloc_=
coherent
>
> ...and the address is clearly not the argument representing the device,
> since it is an address :/
>
> Thanks,
> Robin.
>
> >    * @size: length of the mapping
> >    * @type: single, page, sg, coherent
> >    * @direction: enum dma_data_direction
> > @@ -1262,13 +1263,13 @@ void debug_dma_mapping_error(struct device *dev=
, dma_addr_t dma_addr)
> >   }
> >   EXPORT_SYMBOL(debug_dma_mapping_error);
> >
> > -void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
> > +void debug_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
> >                         size_t size, int direction)
> >   {
> >       struct dma_debug_entry ref =3D {
> >               .type           =3D dma_debug_single,
> >               .dev            =3D dev,
> > -             .dev_addr       =3D addr,
> > +             .dev_addr       =3D dma_addr,
> >               .size           =3D size,
> >               .direction      =3D direction,
> >       };
> > @@ -1403,13 +1404,13 @@ void debug_dma_alloc_coherent(struct device *de=
v, size_t size,
> >   }
> >
> >   void debug_dma_free_coherent(struct device *dev, size_t size,
> > -                      void *virt, dma_addr_t addr)
> > +                      void *virt, dma_addr_t dma_addr)
> >   {
> >       struct dma_debug_entry ref =3D {
> >               .type           =3D dma_debug_coherent,
> >               .dev            =3D dev,
> >               .offset         =3D offset_in_page(virt),
> > -             .dev_addr       =3D addr,
> > +             .dev_addr       =3D dma_addr,
> >               .size           =3D size,
> >               .direction      =3D DMA_BIDIRECTIONAL,
> >       };
>


--=20
Desnes Nunes
Principal Software Engineer
Red Hat Brasil

