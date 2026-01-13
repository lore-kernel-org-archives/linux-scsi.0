Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AE8392817
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 17:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768326419; cv=none; b=uNMWxNb6SQ9hpl2tMuBsS/n9lyKr/IrMIm5sBcQdm8AONci/DIhsoerL4R0Wr2UmmvOkvwONOO63Ffa7kOmgs8I0eM49VxX/N7kgpfpkImjJRAoHjzqP3lbf5UZbR0l3B4FzGwuu7p0byI8VBmgki4m1V6GabWKRjElZmz0Qj0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768326419; c=relaxed/simple;
	bh=0PZNB/Dea+HJCs+wC4Pcy5L34N33Jw+DlZPjjD8dcUw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FxYK+MApt0bETRNDyW3swbdBKEX+xyudmRGl5EEnT2yqpElHf5sGJatoUVhro+UxChTbRlZAXWGA19CW7NyniCOREL1QTYVn9ska9jXubR8CBn8S7ZPCI5zFIW/O+jQnbsKV975hO2NEwtq/DrjNFxSTXqALhmOYKsa+1Odk/tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=WjOSFPsq; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WjOSFPsq"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2a0f3f74587so57875765ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 09:46:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768326417; x=1768931217;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vvcBln30pqDqlGimVz0mQpUNAm7U9lmd/S5c1CG4Q1Y=;
        b=Z9IkFmiecD3YzMrNdhxvr38L+ZEnZsOu/3LWtknnfpZ6qxw6VacDZIVcQ0Gpw/nS8t
         b9Zj5uKi7efNBnkfNuuLK9FH10N/yfK4zTHelSaEkzsWzqT7fu09WIo+kEbpbHitNhWp
         cFQEA5CKNglVyd3+ujte1mOjtbnk4ahlYYGkV7QMMug8iO/0NqHPWolgOod8FFYGgBC6
         CZmB1pKJCknZM0mE1xw7d/1BvKUTtRMMaddywqM6smOyOdb9zO4xeFxlrCBTpXdKo1MX
         NNzar0V5KUwnSUqGWMKhcVKFTUe+VjCNWz2HLgYzaGnoDfya74xH8S0AHh9v2kX3YQOy
         z+oA==
X-Gm-Message-State: AOJu0YwTK+XNN2PGZARG5NM1q43C7hQ3gGZfdvliyU8pimZLRrKlUCjf
	uTnsjlFavP/h6aefb/O9OhDBtXEogsGYM+a39kdM0adjAr22GGtzGI6Pl5/lMa9b8iKuIqmb30t
	cerI1kTTqcnHAhI7Kxd6LTcdiM0i7PIry0ZFHyLdFjsoqwDv8KQHS+qZPVWyY3SYPWjAJmKLLbv
	x916e0WbFNdNnP2u10P1UD5B4kWpNlR0VVYsn+z/fp9yZaadCExuPEQdM+lkpYHVJ/d1cA+Vmv3
	vpW1NaL3YRKFJV3
X-Gm-Gg: AY/fxX7m2m6ApVcn6Isa0COmbaKXoc8moKVYSFeXg4jRdnLgpehCNZh9VHUvM4s7YbN
	b1bMqOkwhMu5ljncPtlUz2Sght3LuMCQCd/qQYW3IKpL9bPBOlLntmSA4MqSXggQDucGF1iHBOT
	gfzfos8hoqa5A4oMKx94Sd86QMK/P19AdtDifOR0mTwQb0Br+enMrUVPFkt2c2ypjGIDZoT3C0P
	KP+GMBiiYfHw2yhUSqfgsRP2l86aT6o03qIqHme6dA5ptIggzF6o6fyZseMIJjyXF6i7LeUMTkx
	cJFTnzUSgGptbOxXHIecaX6G9fOk07/Mn+Tj28LWv2XCCK2IhZJi5clLx5BVH1I82C5N9+6yknr
	f2jL3nl9rcimvPzgs7eVkv6RY+VtXL3eW+LslmfiJ/a40my9LcsXxiNR+3fAKH/WY883B
X-Google-Smtp-Source: AGHT+IGfrlUl7KA71xTi6m7h8QUstb3Wg5tO0tmhXTwOz9BBFg1TiTwgRaus2Xsri5LWBQEdxYIPvY/tCKb9
X-Received: by 2002:a17:902:fc4b:b0:2a0:9084:3aff with SMTP id d9443c01a7336-2a3ee509c6dmr219753715ad.61.1768326416666;
        Tue, 13 Jan 2026 09:46:56 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-c551057e86fsm1065803a12.10.2026.01.13.09.46.56
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jan 2026 09:46:56 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b8735332877so112170466b.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 09:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768326414; x=1768931214; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vvcBln30pqDqlGimVz0mQpUNAm7U9lmd/S5c1CG4Q1Y=;
        b=WjOSFPsqiaalQ5v7SNnFHZ571ty96Tg9jRgu3d7owcOf0tgILJQKmkOnHPOUjp36dl
         fkrdF7vtnneMqyKGLdCMkYu4Q6243JkPTIp2u5FfYG/OTychJwnVPJ6Azi5Ow+E9HB7K
         HmwRuGKDlXOwbR+GNJhpjSA1OmguaCEFgwdfs=
X-Received: by 2002:a17:907:72c6:b0:b87:2630:e67b with SMTP id a640c23a62f3a-b872630fc7cmr671532966b.50.1768326414317;
        Tue, 13 Jan 2026 09:46:54 -0800 (PST)
X-Received: by 2002:a17:907:72c6:b0:b87:2630:e67b with SMTP id
 a640c23a62f3a-b872630fc7cmr671530266b.50.1768326413852; Tue, 13 Jan 2026
 09:46:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
 <20260112081037.74376-5-ranjan.kumar@broadcom.com> <7075bee5-75ce-4092-93c9-06d162a53362@kernel.org>
In-Reply-To: <7075bee5-75ce-4092-93c9-06d162a53362@kernel.org>
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
Date: Tue, 13 Jan 2026 23:16:39 +0530
X-Gm-Features: AZwV_Qirlrxf5N-VE_Iiwdr4DmqFwI5z9PCRPFMqq6My9TDuue76JfwmiFgt3zQ
Message-ID: <CAMFBP8MWuNJT-UV75v+uG0sGFG1epyPndgF2+JsGRGHHTe6-TA@mail.gmail.com>
Subject: Re: [PATCH v1 4/7] mpi3mr: Use negotiated link rate from DevicePage0
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com, 
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com, 
	salomondush@google.com
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000cc703006484893da"

--000000000000cc703006484893da
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Damien,

On Mon, Jan 12, 2026 at 7:48=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> On 1/12/26 09:10, Ranjan Kumar wrote:
> > Firmware populates the negotiated SAS link rate in DevicePage0
> > during device discovery. Update mpi3mr to cache this value while
> > initializing the target device.
> >
> > When available, the cached link rate is used instead of issuing
> > additional SAS PHY or expander PHY page reads.
> > If the DevicePage0 value is missing or invalid, the driver
> > falls back to the existing PHY-based mechanism.
> >
> > Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> > ---
> >  drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h   |  2 +
> >  drivers/scsi/mpi3mr/mpi3mr.h           |  2 +
> >  drivers/scsi/mpi3mr/mpi3mr_os.c        | 88 ++++++++++++++++++++++++++
> >  drivers/scsi/mpi3mr/mpi3mr_transport.c | 30 +++++----
> >  4 files changed, 110 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr=
/mpi/mpi30_cnfg.h
> > index 8c8bfbbdd34e..67d72b82cbe0 100644
> > --- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
> > +++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
> > @@ -2314,6 +2314,8 @@ struct mpi3_device0_sas_sata_format {
> >       u8         attached_phy_identifier;
> >       u8         max_port_connections;
> >       u8         zone_group;
> > +     u8         reserved10[3];
> > +     u8         negotiated_link_rate;
> >  };
> >
> >  #define MPI3_DEVICE0_SASSATA_FLAGS_WRITE_SAME_UNMAP_NCQ (0x0400)
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.=
h
> > index 611a51a353c9..590c017acf25 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr.h
> > +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> > @@ -643,6 +643,7 @@ struct mpi3mr_enclosure_node {
> >   * @dev_info: Device information bits
> >   * @phy_id: Phy identifier provided in device page 0
> >   * @attached_phy_id: Attached phy identifier provided in device page 0
> > + * @negotiated_link_rate: Negotiated link rate from device page 0
> >   * @sas_transport_attached: Is this device exposed to transport
> >   * @pend_sas_rphy_add: Flag to check device is in process of add
> >   * @hba_port: HBA port entry
> > @@ -654,6 +655,7 @@ struct tgt_dev_sas_sata {
> >       u16 dev_info;
> >       u8 phy_id;
> >       u8 attached_phy_id;
> > +     u8 negotiated_link_rate;
> >       u8 sas_transport_attached;
> >       u8 pend_sas_rphy_add;
> >       struct mpi3mr_hba_port *hba_port;
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3=
mr_os.c
> > index 4dbf2f337212..ac94654494ba 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -1138,6 +1138,90 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr=
_ioc *mrioc)
> >       }
> >  }
> >
> > +/**
> > + * mpi3mr_debug_dump_devpg0 - Dump device page0
> > + * @mrioc: Adapter instance reference
> > + * @dev_pg0: Device page 0.
> > + *
> > + * Prints pertinent details of the device page 0.
> > + *
> > + * Return: Nothing.
> > + */
> > +static void
> > +mpi3mr_debug_dump_devpg0(struct mpi3mr_ioc *mrioc, struct mpi3_device_=
page0 *dev_pg0)
> > +{
> > +
>
> No need for this blank line.
>
> > +     if (!(mrioc->logging_level &
> > +         (MPI3_DEBUG_EVENT | MPI3_DEBUG_EVENT_WORK_TASK)))
> > +             return;
>
> Please move this test in the caller so that we can avoid a function call =
for
> nothing if debug is not enabled.
>
> > +
> > +     ioc_info(mrioc,
> > +         "device_pg0: handle(0x%04x), perst_id(%d), wwid(0x%016llx), e=
ncl_handle(0x%04x), slot(%d)\n",
> > +         le16_to_cpu(dev_pg0->dev_handle),
> > +         le16_to_cpu(dev_pg0->persistent_id),
> > +         le64_to_cpu(dev_pg0->wwid), le16_to_cpu(dev_pg0->enclosure_ha=
ndle),
> > +         le16_to_cpu(dev_pg0->slot));
> > +     ioc_info(mrioc, "device_pg0: access_status(0x%02x), flags(0x%04x)=
, device_form(0x%02x), queue_depth(%d)\n",
> > +         dev_pg0->access_status, le16_to_cpu(dev_pg0->flags),
> > +         dev_pg0->device_form, le16_to_cpu(dev_pg0->queue_depth));
> > +     ioc_info(mrioc, "device_pg0: parent_handle(0x%04x), iounit_port(%=
d)\n",
> > +         le16_to_cpu(dev_pg0->parent_dev_handle), dev_pg0->io_unit_por=
t);
> > +
> > +     switch (dev_pg0->device_form) {
> > +     case MPI3_DEVICE_DEVFORM_SAS_SATA:
> > +     {
> > +             struct mpi3_device0_sas_sata_format *sasinf =3D
> > +                 &dev_pg0->device_specific.sas_sata_format;
>
> Please add a blank line after declarations. Same comment applies to other=
 cases
> below.
>
> > +             ioc_info(mrioc,
> > +                 "device_pg0: sas_sata: sas_address(0x%016llx),flags(0=
x%04x),\n"
> > +                 "device_info(0x%04x), phy_num(%d), attached_phy_id(%d=
),negotiated_link_rate(0x%02x)\n",
> > +                 le64_to_cpu(sasinf->sas_address),
> > +                 le16_to_cpu(sasinf->flags),
> > +                 le16_to_cpu(sasinf->device_info), sasinf->phy_num,
> > +                 sasinf->attached_phy_identifier, sasinf->negotiated_l=
ink_rate);
> > +             break;
> > +     }
> > +     case MPI3_DEVICE_DEVFORM_PCIE:
> > +     {
> > +             struct mpi3_device0_pcie_format *pcieinf =3D
> > +                 &dev_pg0->device_specific.pcie_format;
> > +             ioc_info(mrioc,
> > +                 "device_pg0: pcie: port_num(%d), device_info(0x%04x),=
 mdts(%d), page_sz(0x%02x)\n",
> > +                 pcieinf->port_num, le16_to_cpu(pcieinf->device_info),
> > +                 le32_to_cpu(pcieinf->maximum_data_transfer_size),
> > +                 pcieinf->page_size);
> > +             ioc_info(mrioc,
> > +                 "device_pg0: pcie: abort_timeout(%d), reset_timeout(%=
d) capabilities (0x%08x)\n",
> > +                 pcieinf->nvme_abort_to, pcieinf->controller_reset_to,
> > +                 le32_to_cpu(pcieinf->capabilities));
> > +             break;
> > +     }
> > +     case MPI3_DEVICE_DEVFORM_VD:
> > +     {
> > +             struct mpi3_device0_vd_format *vdinf =3D
> > +                 &dev_pg0->device_specific.vd_format;
> > +
> > +             ioc_info(mrioc,
> > +                 "device_pg0: vd: state(0x%02x), raid_level(%d), flags=
(0x%04x),\n"
> > +                 "device_info(0x%04x) abort_timeout(%d), reset_timeout=
(%d)\n",
> > +                 vdinf->vd_state, vdinf->raid_level,
> > +                 le16_to_cpu(vdinf->flags),
> > +                 le16_to_cpu(vdinf->device_info),
> > +                 vdinf->vd_abort_to, vdinf->vd_reset_to);
> > +             ioc_info(mrioc,
> > +                 "device_pg0: vd: tg_id(%d), high(%dMiB), low(%dMiB), =
qd_reduction_factor(%d)\n",
> > +                 vdinf->io_throttle_group,
> > +                 le16_to_cpu(vdinf->io_throttle_group_high),
> > +                 le16_to_cpu(vdinf->io_throttle_group_low),
> > +                 ((le16_to_cpu(vdinf->flags) &
> > +                    MPI3_DEVICE0_VD_FLAGS_IO_THROTTLE_GROUP_QD_MASK) >=
> 12));
> > +
> > +     }
> > +     default:
> > +             break;
> > +     }
> > +}
> > +
> >  /**
> >   * mpi3mr_update_tgtdev - DevStatusChange evt bottomhalf
> >   * @mrioc: Adapter instance reference
> > @@ -1159,6 +1243,8 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_io=
c *mrioc,
> >       struct mpi3mr_enclosure_node *enclosure_dev =3D NULL;
> >       u8 prot_mask =3D 0;
> >
> > +     mpi3mr_debug_dump_devpg0(mrioc, dev_pg0);
> > +
> >       tgtdev->perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
> >       tgtdev->dev_handle =3D le16_to_cpu(dev_pg0->dev_handle);
> >       tgtdev->dev_type =3D dev_pg0->device_form;
> > @@ -1237,6 +1323,8 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_io=
c *mrioc,
> >               tgtdev->dev_spec.sas_sata_inf.phy_id =3D sasinf->phy_num;
> >               tgtdev->dev_spec.sas_sata_inf.attached_phy_id =3D
> >                   sasinf->attached_phy_identifier;
> > +             tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate =3D
> > +                     sasinf->negotiated_link_rate;
> >               if ((dev_info & MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK) !=
=3D
> >                   MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_END_DEVICE)
> >                       tgtdev->is_hidden =3D 1;
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3=
mr/mpi3mr_transport.c
> > index d70f002d6487..101161554ef1 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > @@ -2284,11 +2284,11 @@ void mpi3mr_expander_remove(struct mpi3mr_ioc *=
mrioc, u64 sas_address,
> >   * @mrioc: Adapter instance reference
> >   * @tgtdev: Target device
> >   *
> > - * This function identifies whether the target device is
> > - * attached directly or through expander and issues sas phy
> > - * page0 or expander phy page1 and gets the link rate, if there
> > - * is any failure in reading the pages then this returns link
> > - * rate of 1.5.
> > + * This function first tries to use the link rate from DevicePage0
> > + * (populated by firmware during device discovery). If the cached
> > + * value is not available or invalid, it falls back to reading from
> > + * sas phy page0 or expander phy page1.
> > + *
> >   *
> >   * Return: logical link rate.
> >   */
> > @@ -2301,6 +2301,14 @@ static u8 mpi3mr_get_sas_negotiated_logical_link=
rate(struct mpi3mr_ioc *mrioc,
> >       u32 phynum_handle;
> >       u16 ioc_status;
> >
> > +     /* First, try to use link rate from DevicePage0 (populated by fir=
mware) */
> > +     if (tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate >=3D
> > +         MPI3_SAS_NEG_LINK_RATE_1_5) {
> > +             link_rate =3D tgtdev->dev_spec.sas_sata_inf.negotiated_li=
nk_rate;
> > +             goto out;
> > +     }
> > +
> > +     /* Fallback to reading from phy pages if DevicePage0 value not av=
ailable */
> >       phy_number =3D tgtdev->dev_spec.sas_sata_inf.phy_id;
> >       if (!(tgtdev->devpg0_flag & MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATT=
ACHED)) {
> >               phynum_handle =3D ((phy_number<<MPI3_SAS_EXPAND_PGAD_PHYN=
UM_SHIFT)
> > @@ -2318,9 +2326,7 @@ static u8 mpi3mr_get_sas_negotiated_logical_linkr=
ate(struct mpi3mr_ioc *mrioc,
> >                           __FILE__, __LINE__, __func__);
> >                       goto out;
> >               }
> > -             link_rate =3D (expander_pg1.negotiated_link_rate &
> > -                          MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
> > -                     MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
> > +             link_rate =3D expander_pg1.negotiated_link_rate;
> >               goto out;
> >       }
> >       if (mpi3mr_cfg_get_sas_phy_pg0(mrioc, &ioc_status, &phy_pg0,
> > @@ -2335,11 +2341,11 @@ static u8 mpi3mr_get_sas_negotiated_logical_lin=
krate(struct mpi3mr_ioc *mrioc,
> >                   __FILE__, __LINE__, __func__);
> >               goto out;
> >       }
> > -     link_rate =3D (phy_pg0.negotiated_link_rate &
> > -                  MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
> > -             MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
> > +     link_rate =3D phy_pg0.negotiated_link_rate;
> > +
> >  out:
> > -     return link_rate;
> > +     return ((link_rate & MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
> > +             MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT);
> >  }
> >
> >  /**
>
[Ranja]: Thanks for the review. I will do the changes and will resend v2.
>
> --
> Damien Le Moal
> Western Digital Research

--000000000000cc703006484893da
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
zZSItX49nLoa4TBbzuCzoINrv59QeSCVlVdAYussUS3840ZjvcYHSQx3tqYcBN+an07lDASmGEM5
7PEXJPVInjl/Fva3ksL3r8anR4PWc3Xz5jLD8Xg6BU4zmIcR/t1GlqWuz8uTWmQtm40C9m91Q9a+
2alIIV6BTs8IG2ELtt4EfcVvi5af+Hu878sGeBtMx6Z9ljoKl3MfvDdtUNO4bkJ97a7PXy/CKxiy
TApQj4qg9SKQcsH0xzQan67XeXjkvk4frNDhRikCAwEAAaOCAd0wggHZMA4GA1UdDwEB/wQEAwIF
oDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3Nl
Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1Ud
IAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAy
hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNVHQ4EFgQUfLdm66N7GfDsoL8cYp3s4YdO
isMwDQYJKoZIhvcNAQELBQADggIBAA/lnAxDb9jbesclnBxWIKUSxAMIrq4XKO5WKHUYIOOzd2sL
o59fH9AWg1AfVONfWIUNdWDrmNNLs0+drSKaZbGx2RWMbaL9ubo7+BTQV33ZRBxnnkmc9QszlOo5
m6FB9uPOGB9LvJMCkJ8S7hNc9G/p7dB79s1IKc8JGEDIrsgX3s4xSCJA20WdePHY5rLh5ySwXyI2
3sVTUC+oK0HJFRo+TpdMMtdpOetWzIkUbGceiOA2ur8372+0KOmvlIHA/jEnW3BRfmB2vmdk+raY
C/xbXY9JEfS6D881+X/90w+cCQ7nuA1OELebS1RbSdXT6YkRDPWYA/DPFhOYCAiMwVAPRaAH1AQc
8J8yTDigwRUCq4qKCYU9YnqQh3YZRbUYnW+i3+rAO2SUbKl0VM5y0tq+GOGLC7w+v6yGossZmy+6
3w72qp/Colr4r5ZaROb+L2FXqk4tL/HfkRhliyPPPNIjre2mIkvFuShk5A5FcvQYCzDtejAz9JHq
ZVJ1ZD+auQDbIUxT+Dn9bI5XkQnWJ9KrlcORtztdYTDafN8VQuweS3JY0X/VCNBNZkiYXd7fzOza
hvkw/S+v8cIfiakLKBREtiBHqWLdVf5CNDVYpd17yz0LGz0TKARbfuK/EiKflA10pnnnOB33Ru9D
WPp9aHW3szGYr3+H9AHS6IDwkIxyMYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0Eg
MjAyMwIMDcMaKRu9LrbAxERoMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCDb1R45
5clPz/u8Qqnx+He5zHmSNZ0vU8ivzoRqeUbUCDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjAxMTMxNzQ2NTRaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA3T/QdGYa7w7Zw0ANzIn9n1XRDlBC1EZCcPt3lmu+S
a1u4xOISmV3Pqj0KaYwlt0eq5G6rLF/SqMXgwKEqFjgqwRVbk+1o4HOHQ5WvDb5wzaNDLLpUA6BZ
9xWILT17WiU1E6WKlAg3QStsv74wgoDqrIouHd1wqmGlL5w5dXCbJUrq5xgi0uWIVjsouSG2Eaum
2WEFKvi/IeUdss1vSqSOVjr+cV4NNxBUml4ML6E8JWtJw80WZFxqy2+CcVGGesobYht+fHaidS0K
uBBot2j/E7XyPYPTeu983KI8GPpw8Ko1XeBFjTyM1SBXEXmIbEiG2bANPmWoAD6XSrarbhum
--000000000000cc703006484893da--
