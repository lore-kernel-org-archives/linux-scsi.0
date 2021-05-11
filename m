Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D64CC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 18:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D8F26186A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 18:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhEKSfk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 14:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhEKSfh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2021 14:35:37 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982BBC061574
        for <linux-scsi@vger.kernel.org>; Tue, 11 May 2021 11:34:30 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id a22so19188952qkl.10
        for <linux-scsi@vger.kernel.org>; Tue, 11 May 2021 11:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=YOp546iaaGGrbX+57Vc8semal5Vq9YQWjrdBBMovIM0=;
        b=ApfUAtZ+JNl8tgW5eIePTpY+b6F/Oi6yicbSYKe3cB87pUIuRCANW1rLPO76KeOQe4
         y21RVvys6NeF8oiWX8HzDjHEgFPDDELxKPBTxVt9hW7s1sHetSMIpKIQV95kU4STpn4p
         YE4HT53cPSfNrK0O+B9gVadGhEbiwbRVe08Co=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=YOp546iaaGGrbX+57Vc8semal5Vq9YQWjrdBBMovIM0=;
        b=P0cTd8Vu13XHyI9s/NB4+xR5beIU8X3hrMXUdeLv5LXzC48/Oj2OJ159rgRRxaM/hv
         PX5XloGVqMyBZGTS+2p7tKSz8vrXxebPHV44RWvA/fhA4VOx49bgPLNdsf0hOJYGUYIX
         aSu2GYziviEWXDsDjJHEKpw/OZD7tTgxtTF4ni0FowXP0QiCRyDP5n8mkY4lSvMjpxcq
         TQwRNEpzLacr2pDvPlsHrrtf1MDFgRrVuameX1Tu8nglUJ/a0QrHEKSYBW3N+CmPvRdn
         /Ly0CNpJkdJqavigwtxqQ1gFaTgea6tqdOio9HMtlNeQwwWqC8zzBfovGabhQIa5BVnX
         8N/g==
X-Gm-Message-State: AOAM5309MrPxqJoemf45nJuaF6fgtb4k9DZ+lWqX+y4vjuTlmi7fAMzp
        lug1VTNTPd+QeURgkBGziHsxoZtScUgaR+4X9JVPZg==
X-Google-Smtp-Source: ABdhPJyDETi/Iev4KOu75YwSyCVtdVpJTI73eN5UvvEKmI1NYvk2UmJYTdZWueyIF3HRJbWvg0yIFNCuNL4LD9z1AyQ=
X-Received: by 2002:a37:aa0b:: with SMTP id t11mr29228847qke.70.1620758069474;
 Tue, 11 May 2021 11:34:29 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-7-kashyap.desai@broadcom.com> <1f03c0a0-e9a9-3782-3948-4a11ecb43826@suse.de>
In-Reply-To: <1f03c0a0-e9a9-3782-3948-4a11ecb43826@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIA/XT3c415OaY1ygHMgGHDvdQMAAMBhIPAAlcXNaGqYGfzIA==
Date:   Wed, 12 May 2021 00:04:27 +0530
Message-ID: <93f2f5fefa6b16d7dc9bf8298b9eeb8f@mail.gmail.com>
Subject: RE: [PATCH v3 06/24] mpi3mr: add support of event handling part-1
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000083ef505c21225fc"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000083ef505c21225fc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > @@ -612,7 +1942,25 @@ static void mpi3mr_target_destroy(struct
> scsi_target *starget)
> >   */
> >  static int mpi3mr_slave_configure(struct scsi_device *sdev)  {
> > +	struct scsi_target *starget;
> > +	struct Scsi_Host *shost;
> > +	struct mpi3mr_ioc *mrioc;
> > +	struct mpi3mr_tgt_dev *tgt_dev;
> > +	unsigned long flags;
> >  	int retval =3D 0;
> > +
> > +	starget =3D scsi_target(sdev);
> > +	shost =3D dev_to_shost(&starget->dev);
> > +	mrioc =3D shost_priv(shost);
> > +
> > +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> > +	tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> > +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> > +	if (!tgt_dev)
> > +		return retval;
> > +
>
> Return '0' on unknown SCSI devices? Really?

Hannes  - I will fix this in V4. I am planning to send V4 today. Please
review.
>
> > +	mpi3mr_tgtdev_put(tgt_dev);
> > +
> >  	return retval;
> >  }
> >
> > @@ -626,7 +1974,37 @@ static int mpi3mr_slave_configure(struct
> scsi_device *sdev)
> >   */
> >  static int mpi3mr_slave_alloc(struct scsi_device *sdev)  {
> > +	struct Scsi_Host *shost;
> > +	struct mpi3mr_ioc *mrioc;
> > +	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
> > +	struct mpi3mr_tgt_dev *tgt_dev;
> > +	struct mpi3mr_sdev_priv_data *scsi_dev_priv_data;
> > +	unsigned long flags;
> > +	struct scsi_target *starget;
> >  	int retval =3D 0;
> > +
> > +	starget =3D scsi_target(sdev);
> > +	shost =3D dev_to_shost(&starget->dev);
> > +	mrioc =3D shost_priv(shost);
> > +	scsi_tgt_priv_data =3D starget->hostdata;
> > +
> > +	scsi_dev_priv_data =3D kzalloc(sizeof(*scsi_dev_priv_data),
> GFP_KERNEL);
> > +	if (!scsi_dev_priv_data)
> > +		return -ENOMEM;
> > +
> > +	scsi_dev_priv_data->lun_id =3D sdev->lun;
> > +	scsi_dev_priv_data->tgt_priv_data =3D scsi_tgt_priv_data;
> > +	sdev->hostdata =3D scsi_dev_priv_data;
> > +
> > +	scsi_tgt_priv_data->num_luns++;
> > +
> > +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> > +	tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> > +	if (tgt_dev && (tgt_dev->starget =3D=3D NULL))
> > +		tgt_dev->starget =3D starget;
> > +	if (tgt_dev)
> > +		mpi3mr_tgtdev_put(tgt_dev);
> > +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> >  	return retval;
> >  }
> >
> Same here. I would have expected -ENXIO to be returned fi the tgt_dev is
> not
> found.
> And you can fold the two 'if' clauses into one eg like:

This is fixed in  in V4.

>
> if (tgt_dev) {
>   if (tgt_dev->starget =3D=3D NULL)
>     tgt_dev =3D starget;
>   mpi3mr_tgtdev_put(tgt_dev);
>   retval =3D 0;
> }
>
> > @@ -640,7 +2018,33 @@ static int mpi3mr_slave_alloc(struct scsi_device
> *sdev)
> >   */
> >  static int mpi3mr_target_alloc(struct scsi_target *starget)  {
> > +	struct Scsi_Host *shost =3D dev_to_shost(&starget->dev);
> > +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> > +	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
> > +	struct mpi3mr_tgt_dev *tgt_dev;
> > +	unsigned long flags;
> >  	int retval =3D -ENODEV;
> > +
> > +	scsi_tgt_priv_data =3D kzalloc(sizeof(*scsi_tgt_priv_data),
> GFP_KERNEL);
> > +	if (!scsi_tgt_priv_data)
> > +		return -ENOMEM;
> > +
> > +	starget->hostdata =3D scsi_tgt_priv_data;
> > +	scsi_tgt_priv_data->starget =3D starget;
> > +	scsi_tgt_priv_data->dev_handle =3D MPI3MR_INVALID_DEV_HANDLE;
> > +
> > +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> > +	tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> > +	if (tgt_dev && !tgt_dev->is_hidden) {
> > +		scsi_tgt_priv_data->dev_handle =3D tgt_dev->dev_handle;
> > +		scsi_tgt_priv_data->perst_id =3D tgt_dev->perst_id;
> > +		scsi_tgt_priv_data->dev_type =3D tgt_dev->dev_type;
> > +		scsi_tgt_priv_data->tgt_dev =3D tgt_dev;
> > +		tgt_dev->starget =3D starget;
> > +		atomic_set(&scsi_tgt_priv_data->block_io, 0);
> > +		retval =3D 0;
> > +	}
> > +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> >  	return retval;
> >  }
> >
> Ah, here is the correct value set.
> (But wasn't it ENXIO which should've been returned for unknown targets?)

This is fixed in V4.

>
> > @@ -836,7 +2240,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct
> > pci_device_id *id)  {
> >  	struct mpi3mr_ioc *mrioc =3D NULL;
> >  	struct Scsi_Host *shost =3D NULL;
> > -	int retval =3D 0;
> > +	int retval =3D 0, i;
> >
> >  	shost =3D scsi_host_alloc(&mpi3mr_driver_template,
> >  	    sizeof(struct mpi3mr_ioc));
> > @@ -857,11 +2261,21 @@ mpi3mr_probe(struct pci_dev *pdev, const
> struct pci_device_id *id)
> >  	spin_lock_init(&mrioc->admin_req_lock);
> >  	spin_lock_init(&mrioc->reply_free_queue_lock);
> >  	spin_lock_init(&mrioc->sbq_lock);
> > +	spin_lock_init(&mrioc->fwevt_lock);
> > +	spin_lock_init(&mrioc->tgtdev_lock);
> >  	spin_lock_init(&mrioc->watchdog_lock);
> >  	spin_lock_init(&mrioc->chain_buf_lock);
> >
> > +	INIT_LIST_HEAD(&mrioc->fwevt_list);
> > +	INIT_LIST_HEAD(&mrioc->tgtdev_list);
> > +	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
> > +
> >  	mpi3mr_init_drv_cmd(&mrioc->init_cmds,
> MPI3MR_HOSTTAG_INITCMDS);
> >
> > +	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> > +		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
> > +		    MPI3MR_HOSTTAG_DEVRMCMD_MIN + i);
> > +
> >  	if (pdev->revision)
> >  		mrioc->enable_segqueue =3D true;
> >
> > @@ -877,6 +2291,17 @@ mpi3mr_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
> >  	shost->max_channel =3D 1;
> >  	shost->max_id =3D 0xFFFFFFFF;
> >
> > +	snprintf(mrioc->fwevt_worker_name, sizeof(mrioc-
> >fwevt_worker_name),
> > +	    "%s%d_fwevt_wrkr", mrioc->driver_name, mrioc->id);
> > +	mrioc->fwevt_worker_thread =3D alloc_ordered_workqueue(
> > +	    mrioc->fwevt_worker_name, WQ_MEM_RECLAIM);
> > +	if (!mrioc->fwevt_worker_thread) {
> > +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> > +		    __FILE__, __LINE__, __func__);
> > +		retval =3D -ENODEV;
> > +		goto out_fwevtthread_failed;
> > +	}
> > +
> >  	mrioc->is_driver_loading =3D 1;
> >  	if (mpi3mr_init_ioc(mrioc)) {
> >  		ioc_err(mrioc, "failure at %s:%d/%s()!\n", @@ -903,6 +2328,8
> @@
> > mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >  addhost_failed:
> >  	mpi3mr_cleanup_ioc(mrioc);
> >  out_iocinit_failed:
> > +	destroy_workqueue(mrioc->fwevt_worker_thread);
> > +out_fwevtthread_failed:
> >  	spin_lock(&mrioc_list_lock);
> >  	list_del(&mrioc->list);
> >  	spin_unlock(&mrioc_list_lock);
> > @@ -924,14 +2351,30 @@ static void mpi3mr_remove(struct pci_dev
> *pdev)
> > {
> >  	struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
> >  	struct mpi3mr_ioc *mrioc;
> > +	struct workqueue_struct	*wq;
> > +	unsigned long flags;
> > +	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
> >
> >  	mrioc =3D shost_priv(shost);
> >  	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
> >  		ssleep(1);
> >
> >  	mrioc->stop_drv_processing =3D 1;
> > +	mpi3mr_cleanup_fwevt_list(mrioc);
> > +	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
> > +	wq =3D mrioc->fwevt_worker_thread;
> > +	mrioc->fwevt_worker_thread =3D NULL;
> > +	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
> > +	if (wq)
> > +		destroy_workqueue(wq);
> >
> >  	scsi_remove_host(shost);
> > +	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
> > +	    list) {
> > +		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
> > +		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
> > +		mpi3mr_tgtdev_put(tgtdev);
> > +	}
> >
> >  	mpi3mr_cleanup_ioc(mrioc);
> >
> > @@ -955,6 +2398,8 @@ static void mpi3mr_shutdown(struct pci_dev
> *pdev)
> > {
> >  	struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
> >  	struct mpi3mr_ioc *mrioc;
> > +	struct workqueue_struct	*wq;
> > +	unsigned long flags;
> >
> >  	if (!shost)
> >  		return;
> > @@ -963,6 +2408,13 @@ static void mpi3mr_shutdown(struct pci_dev
> *pdev)
> >  	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
> >  		ssleep(1);
> >  	mrioc->stop_drv_processing =3D 1;
> > +	mpi3mr_cleanup_fwevt_list(mrioc);
> > +	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
> > +	wq =3D mrioc->fwevt_worker_thread;
> > +	mrioc->fwevt_worker_thread =3D NULL;
> > +	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
> > +	if (wq)
> > +		destroy_workqueue(wq);
> >
> >  	mpi3mr_cleanup_ioc(mrioc);
> >
> >
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		        Kernel Storage Architect
> hare@suse.de			               +49 911 74053 688
> SUSE Software Solutions Germany GmbH, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, HRB 36809 (AG N=C3=BCrnberg)

--000000000000083ef505c21225fc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOi8qfkEvBPKKFqqpI6gX1glIkqd
Mds2jRpSlBTJC6ulMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUxMTE4MzQzMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBqvT4yH4ykKyJTq6YxVGsdSoDE4XVJvK3NeVapNZGg/n6d
lwpbDNUgAjX0tHaVq9N7FT+LKG28CbGi4MM2ZjLWXwbdLWSfUh+0Rwy9GDK3Xq5WUgLi2BN7BONb
+tNlMd+6mi8pYzT4TZioTIkciqtnlpQ4C/omUL5respamehWgK1Z0xhZ+OhPryg7SsnGeJInLRNW
GmUZBpz0FvgociJX2QX4ez/uJL+kj135m6iLfJXHjKfCpJuWCHAlxXM6oHGBd5X2zw9WHFBmxVOf
cqf5bYzaOBIhsF1tCdxyxgI67P8D6IedzkVfEgWU8k0+JduMtb99eNvqlY8w9N5qh655
--000000000000083ef505c21225fc--
