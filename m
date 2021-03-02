Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7A1C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8E3B64F16
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581618AbhCBS7x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581052AbhCBSh6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 13:37:58 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1B7C0617A7
        for <linux-scsi@vger.kernel.org>; Tue,  2 Mar 2021 10:36:59 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id b3so15490593qtj.10
        for <linux-scsi@vger.kernel.org>; Tue, 02 Mar 2021 10:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=dPVlsjwD+9sm3PGP3Y8ScEkTSGP/yd0sqiN6W6JmMhU=;
        b=Y3RnDH2e2pP1t71RP4DvjMiRGHeXsLBg+OpYj6HIreePN6K07+Op+EfVuYg0uOWi5h
         +hrx1IdaNlivM0mKWTQ1CD10pKTorYLB4QwUevLubBQ4V+/ZPAONI8ju/U1RBIg1MHrb
         Gp6l3zGd9AHWOVFuTyLsuQOnFW98TtMYUPk6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=dPVlsjwD+9sm3PGP3Y8ScEkTSGP/yd0sqiN6W6JmMhU=;
        b=Yb8u2rVJAv1y+P8xAg47pDgLm2WVcJDozThooEI816hd7MyLNq1tOIper/KoSI0mLP
         ZysXVA+/Y/8xx1XfDQEbihQlVIX7hzohJ7t88QsnuQgYgAG4+Gw5GyK8Fh4piibvSS/R
         OeyeyZ5u6zj3OoBEt/BYxrFuFRxm1h3U8r1+/wIALr1GXg7ESNWSWeZ77sPlgzinHLB3
         n/FLC1D3QQcDwAA1EoxwPsloFG1Dl++a5YYE6047INRDdd5WjIprunBc0nIzmx3d3wWO
         sGQsFPUBYLv8p+eCQ2JKKMFFToi0vhqO9dcTmAuqLI10ru+YFXwORfMJ5ySDY5Hnvi1s
         pBUg==
X-Gm-Message-State: AOAM532g2fI+8mIXAkb+QFQRL6imsVoOicx+CjIBHYabmkDhX4ElcQVf
        zpPDcFJyhmxMgTWSHyhm9KiaIvBUP9cXatIMFdJu4g==
X-Google-Smtp-Source: ABdhPJzk+dWGn1Qa0ViU33/FMoDv4Hh73y/lrW2r3gIAAgBZVXZG3ri96ghP6JrncHY5qO8Xyn1SO9IKV3NeePqhqcw=
X-Received: by 2002:ac8:6796:: with SMTP id b22mr19264682qtp.101.1614710218655;
 Tue, 02 Mar 2021 10:36:58 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-3-kashyap.desai@broadcom.com> <86097522-6d52-c336-b41c-fc2b4ad8701b@suse.de>
In-Reply-To: <86097522-6d52-c336-b41c-fc2b4ad8701b@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIVk2r6yGrO96+nYWGuC86HruD4YwK+swt7AnLHlBipymz/MA==
Date:   Wed, 3 Mar 2021 00:06:53 +0530
Message-ID: <b1140b05cb2ab8a1c4fccbb33920ea38@mail.gmail.com>
Subject: RE: [PATCH 02/24] mpi3mr: base driver code
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000006051305bc9205cc"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000006051305bc9205cc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > +struct mpi3mr_ioc {
> > +	struct list_head list;
> > +	struct pci_dev *pdev;
> > +	struct Scsi_Host *shost;
> > +	u8 id;
> > +	int cpu_count;
> > +
> > +	char name[MPI3MR_NAME_LENGTH];
> > +	char driver_name[MPI3MR_NAME_LENGTH];
> > +
> > +	Mpi3SysIfRegs_t __iomem *sysif_regs;
> > +	resource_size_t sysif_regs_phys;
> > +	int bars;
> > +	u64 dma_mask;
> > +
> > +	u16 msix_count;
> > +	u8 intr_enabled;
> > +
> > +	u16 num_admin_req;
> > +	u32 admin_req_q_sz;
> > +	u16 admin_req_pi;
> > +	u16 admin_req_ci;
> > +	void *admin_req_base;
> > +	dma_addr_t admin_req_dma;
> > +	spinlock_t admin_req_lock;
> > +
> > +	u16 num_admin_replies;
> > +	u32 admin_reply_q_sz;
> > +	u16 admin_reply_ci;
> > +	u8 admin_reply_ephase;
> > +	void *admin_reply_base;
> > +	dma_addr_t admin_reply_dma;
> > +
> > +	u32 ready_timeout;
> > +
> > +	struct mpi3mr_intr_info *intr_info;
>
> Please, be consistent.
> If you must introduce typedefs for your internal structures, okay.
> But then introduce typedefs for _all_ internal structures.
> Or leave the typedefs and just use 'struct XXX'; which actually is the
> recommended way for linux.

Are you referring " typedef struct mpi3mr_drv_" ?. This is because of some
inter-operability issue of different kernel version. I will remove this
typedef in my V2.
Usually, our goal is not to have typedef in drivers except mpi3.0 header
files. I will scan such instances in and will update all the places.

>
> > +	u16 intr_info_count;
> > +
> > +	u16 num_queues;
> > +	u16 num_op_req_q;
> > +	struct op_req_qinfo *req_qinfo;
> > +
> > +	u16 num_op_reply_q;
> > +	struct op_reply_qinfo *op_reply_qinfo;
> > +
> > +	struct mpi3mr_drv_cmd init_cmds;
> > +	struct mpi3mr_ioc_facts facts;
> > +	u16 op_reply_desc_sz;
> > +
> > +	u32 num_reply_bufs;
> > +	struct dma_pool *reply_buf_pool;
> > +	u8 *reply_buf;
> > +	dma_addr_t reply_buf_dma;
> > +	dma_addr_t reply_buf_dma_max_address;
> > +
> > +	u16 reply_free_qsz;
> > +	struct dma_pool *reply_free_q_pool;
> > +	U64 *reply_free_q;
> > +	dma_addr_t reply_free_q_dma;
> > +	spinlock_t reply_free_queue_lock;
> > +	u32 reply_free_queue_host_index;
> > +
> > +	u32 num_sense_bufs;
> > +	struct dma_pool *sense_buf_pool;
> > +	u8 *sense_buf;
> > +	dma_addr_t sense_buf_dma;
> > +
> > +	u16 sense_buf_q_sz;
> > +	struct dma_pool *sense_buf_q_pool;
> > +	U64 *sense_buf_q;
> > +	dma_addr_t sense_buf_q_dma;
> > +	spinlock_t sbq_lock;
> > +	u32 sbq_host_index;
> > +
> > +	u8 is_driver_loading;
> > +
> > +	u16 max_host_ios;
> > +
> > +	u32 chain_buf_count;
> > +	struct dma_pool *chain_buf_pool;
> > +	struct chain_element *chain_sgl_list;
> > +	u16  chain_bitmap_sz;
> > +	void *chain_bitmap;
> > +
> > +	u8 reset_in_progress;
> > +	u8 unrecoverable;
> > +
> > +	int logging_level;
> > +
> > +	struct mpi3mr_fwevt *current_event;
> > +	Mpi3DriverInfoLayout_t driver_info;
>
> See my comment about struct typedefs above.

I will remove this typedef and similar instances.

> > +static inline int mpi3mr_request_irq(struct mpi3mr_ioc *mrioc, u16
index)
> > +{
> > +	struct pci_dev *pdev =3D mrioc->pdev;
> > +	struct mpi3mr_intr_info *intr_info =3D mrioc->intr_info + index;
> > +	int retval =3D 0;
> > +
> > +	intr_info->mrioc =3D mrioc;
> > +	intr_info->msix_index =3D index;
> > +	intr_info->op_reply_q =3D NULL;
> > +
> > +	snprintf(intr_info->name, MPI3MR_NAME_LENGTH, "%s%d-msix%d",
> > +	    mrioc->driver_name, mrioc->id, index);
> > +
> > +	retval =3D request_threaded_irq(pci_irq_vector(pdev, index),
> mpi3mr_isr,
> > +	    mpi3mr_isr_poll, IRQF_ONESHOT, intr_info->name, intr_info);
> > +	if (retval) {
> > +		ioc_err(mrioc, "%s: Unable to allocate interrupt %d!\n",
> > +		    intr_info->name, pci_irq_vector(pdev, index));
> > +		return retval;
> > +	}
> > +
>
> The point of having 'mpi3mr_isr_poll()' here is what exactly?

This is a place holder and actual use case is handled in " [17/24] mpi3mr:
add support of threaded isr"
For easy review, I have created separate patch " [17/24] mpi3mr: add
support of threaded isr"
> > +	areq_entry =3D (u8 *)mrioc->admin_req_base +
> > +	    (areq_pi * MPI3MR_ADMIN_REQ_FRAME_SZ);
> > +	memset(areq_entry, 0, MPI3MR_ADMIN_REQ_FRAME_SZ);
> > +	memcpy(areq_entry, (u8 *)admin_req, admin_req_sz);
> > +
> > +	if (++areq_pi =3D=3D max_entries)
> > +		areq_pi =3D 0;
> > +	mrioc->admin_req_pi =3D areq_pi;
> > +
> > +	writel(mrioc->admin_req_pi, &mrioc->sysif_regs-
> >AdminRequestQueuePI);
> > +
> > +out:
> > +	spin_unlock_irqrestore(&mrioc->admin_req_lock, flags);
> > +
> > +	return retval;
> > +}
> > +
>
> It might be an idea to have an 'admin' queue structure; keeping the
> values all within the main IOC structure might cause cache misses and a
> degraded performance.

Noted your point. We can do it in future update. I think it make sense for
code readability as well.

> > +int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> > +{
> > +	int retval =3D 0;
> > +	enum mpi3mr_iocstate ioc_state;
> > +	u64 base_info;
> > +	u32 timeout;
> > +	u32 ioc_status, ioc_config;
> > +	Mpi3IOCFactsData_t facts_data;
> > +
> > +	mrioc->change_count =3D 0;
> > +	mrioc->cpu_count =3D num_online_cpus();
>
> What about CPU hotplug?


We have to use num_available_cpus() to get benefit of cpu hotplug. In next
update it will be available.

> > +
> > +/* global driver scop variables */
> > +LIST_HEAD(mrioc_list);
> > +DEFINE_SPINLOCK(mrioc_list_lock);
> > +static int mrioc_ids;
> > +static int warn_non_secure_ctlr;
> > +
> > +MODULE_AUTHOR(MPI3MR_DRIVER_AUTHOR);
> > +MODULE_DESCRIPTION(MPI3MR_DRIVER_DESC);
> > +MODULE_LICENSE(MPI3MR_DRIVER_LICENSE);
> > +MODULE_VERSION(MPI3MR_DRIVER_VERSION);
> > +
> > +/* Module parameters*/
> > +int logging_level;
> > +module_param(logging_level, int, 0);
> > +MODULE_PARM_DESC(logging_level,
> > +	" bits for enabling additional logging info (default=3D0)");
> > +
> > +
> > +/**
> > + * mpi3mr_map_queues - Map queues callback handler
> > + * @shost: SCSI host reference
> > + *
> > + * Call the blk_mq_pci_map_queues with from which operational
> > + * queue the mapping has to be done
> > + *
> > + * Return: return of blk_mq_pci_map_queues
> > + */
> > +static int mpi3mr_map_queues(struct Scsi_Host *shost)
> > +{
> > +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> > +
> > +	return blk_mq_pci_map_queues(&shost-
> >tag_set.map[HCTX_TYPE_DEFAULT],
> > +	    mrioc->pdev, 0);
> > +}
> > +
>
> What happened to polling?
> You did some patches for megaraid_sas, so I would have expected them to
> be here, too ...

Internally, Io_uring iopoll is also completed for this driver as well, but
it is under testing and may be available in next update.

> > +module_init(mpi3mr_init);
> > +module_exit(mpi3mr_exit);
> >
> Cheers,

Hannes -

Thanks for the feedback. I am working on all the comments and soon I will
be posting V2.

Kashyap
>
> Hannes
> --
> Dr. Hannes Reinecke		           Kernel Storage Architect
> hare@suse.de			                  +49 911 74053 688
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: Felix Imend=C3=B6rffer

--00000000000006051305bc9205cc
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMHbvOUpdNa51Lb3/lDe2OIBSr8v
7DUbyBfbQaKLgiLsMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDMwMjE4MzY1OVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQC8ebthn+cNEevam0bwVr9NSi0nyVa1dRZPF27X4lUii7mu
916Wgz7KDAUSFYvRQq1thQYHqk14xhlmVNXnBhpbmrwLNoeZ4pqqTOQLywGbusGyQmhzBj9l7jw6
GNy/EzUpOdYc2Cw4KKh+sdiTr498aBQSUyafK9oXmjcKCw8AtNYDTIsTvcY2C0OfoyNF9b/Pbo5z
MokPs4FjkWhb66CJ3I2RXcijOLygIKBWaujrq0XonFYcvnpNRFXh1AdXVGnOz09BnIWBC7khLr4G
hkgg0zDaDtOhlTfPEAsqRbqLRHBdMQtOPBJt18xxzidS6U1TjrL0mYHXYonhoBZPiiZJ
--00000000000006051305bc9205cc--
