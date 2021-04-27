Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F74CC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 16:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01AA61077
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 16:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237865AbhD0Qpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 12:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhD0Qpm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Apr 2021 12:45:42 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF4BC061574
        for <linux-scsi@vger.kernel.org>; Tue, 27 Apr 2021 09:44:59 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id l1so4800817qtr.12
        for <linux-scsi@vger.kernel.org>; Tue, 27 Apr 2021 09:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=VCJBsbPrxgLKA2utXwpx9Yl+4Y3SZCaExPIHIQptJxI=;
        b=J6qxo6d7MhEYjq5DpF/Vk33Gwv5pOjPsB6/EcpEsDvsIvCJY+sB7pwxWp4Iz1kwa3K
         nGwJLPppwqN921+W4KhSc4MmVSdlCT6pv3svrHXsVyMghjqfgFNeAnb3nsuUrpje4gpN
         3wwjzl4tAY0LgHAzTgBtxZHBxYQcPVdFaPFcI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=VCJBsbPrxgLKA2utXwpx9Yl+4Y3SZCaExPIHIQptJxI=;
        b=cvJtyRsGnB6ccreicsR6ufQcrPm2w9JbK7IEmTqYBQTloGdYGkXh4nJR6ahLdO6oWQ
         Vh/6HDqOQeyGY2okInxo3LXRtQbM/DCXvlDl1AXLEnAj52fbHxjuoC/WwmBgHdMQDf9+
         OVHrl0utPmJ0+v1QBmHlqPEU9mJeJdHs1qCg7yzhMlgi+DDKFezgNjjiEUBWWcyRfvEj
         2YR3qeoMAKzqc+Uc1/yJ4ZtEx3p8Ushk8uyya2HIlUh1fG5cp/pVCwbAevXLZvt7P3fA
         RJrkCbHqrh+OvD3gdvynXR45E25gibkCJOMIJJhNJRlbNcQ7Go7emtA1H+xPXauqZuF2
         aQ3g==
X-Gm-Message-State: AOAM531MCxmEivq2T/SQuBfGdyceIqiHewIGHWZo6jI+8F9XtP1dncEa
        oG5rtHSiiTQCCaZRjOzKSxQphU2XnSJaOui+BJcLSrC9/eg=
X-Google-Smtp-Source: ABdhPJzXLfQJuSVFU2ZEOvQsSu5C1/CrKRdhD8Yd3HgE2CyTuSAmymTMSEkmcHkDpSGJcym/jrfPDxt0NP1AtobR0uU=
X-Received: by 2002:ac8:5d88:: with SMTP id d8mr22828383qtx.387.1619541898057;
 Tue, 27 Apr 2021 09:44:58 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-5-kashyap.desai@broadcom.com> <128bcfe2-cd96-f90d-690e-8f2d075279e6@suse.de>
In-Reply-To: <128bcfe2-cd96-f90d-690e-8f2d075279e6@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIA/XT3c415OaY1ygHMgGHDvdQMAADYtaXKAltenCSqW2pZgA==
Date:   Tue, 27 Apr 2021 22:14:55 +0530
Message-ID: <112865784f146b4a12eca750e017547b@mail.gmail.com>
Subject: RE: [PATCH v3 04/24] mpi3mr: add support of queue command processing
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008f2e8e05c0f6fb5e"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008f2e8e05c0f6fb5e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > +/**
> > + * mpi3mr_scmd_from_host_tag - Get SCSI command from host tag
> > + * @mrioc: Adapter instance reference
> > + * @host_tag: Host tag
> > + * @qidx: Operational queue index
> > + *
> > + * Identify the block tag from the host tag and queue index and
> > + * retrieve associated scsi command using scsi_host_find_tag().
> > + *
> > + * Return: SCSI command reference or NULL.
> > + */
> > +static struct scsi_cmnd *mpi3mr_scmd_from_host_tag(
> > +	struct mpi3mr_ioc *mrioc, u16 host_tag, u16 qidx) {
> > +	struct scsi_cmnd *scmd =3D NULL;
> > +	struct scmd_priv *priv =3D NULL;
> > +	u32 unique_tag =3D host_tag - 1;
> > +
> > +	if (WARN_ON(host_tag > mrioc->max_host_ios))
> > +		goto out;
> > +
> > +	unique_tag |=3D (qidx << BLK_MQ_UNIQUE_TAG_BITS);
> > +
> > +	scmd =3D scsi_host_find_tag(mrioc->shost, unique_tag);
> > +	if (scmd) {
> > +		priv =3D scsi_cmd_priv(scmd);
> > +		if (!priv->in_lld_scope)
> > +			scmd =3D NULL;
> > +	}
>
> That, I guess, is wrong.
>
> And 'real' unique tag (ie encoding the hwq num and the tag) only makes
> sense
> if you have _separate_ tag pools per queue.
> As your HBA supports only a single tag space _per HBA_ that would mean
> that
> you would have to _split_ that pool between hardware queues.

Hannes -

In current series, We have separate_ tag pools per queue.  There are two
stuffs in this driver/hw which is not matching with multiqueue support of
NVMe native.
1. Memory usage is too high and because of that we have segmented queue
support.
We are detecting queue full per operation queue which is unlikely event but
we wanted to keep it for some time. We will revisit this part once h/w
product goes under aggressive testing.
2. Whatever can_queue value H/W expose is not something per Operation queue=
,
but our h/w also do not break even though there are more than can_queue
command outstanding.
Actual outstanding per operation queue and controller wide in this h/w is
not very defined value, but it is too large (much higher higher than
can_queue) and we have considered this area to handle later.

> Which I don't think you do, as this would lead to a very imbalanced tag
> usage
> and ultimately a tag starvation on large systems.
> Hence each per-HWQ bitmap will cover the _full_ tag space, and the only
> way
> to make that work is to use shared hosttags.

In my initial study, I have noticed shared host tag is also giving similar
performance so we have plan to use shared host tag in future.
Doing this - We are strictly following can_queue level throttling in SML an=
d
no matter how much max h/w really support.

Kashyap

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		        Kernel Storage Architect
> hare@suse.de			               +49 911 74053 688
> SUSE Software Solutions Germany GmbH, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, HRB 36809 (AG N=C3=BCrnberg)

--0000000000008f2e8e05c0f6fb5e
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFJDnShCypDydmMmoxQLPIfSp0z3
5MXqtdIDzzZymmz+MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQyNzE2NDQ1OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCWm8MIYtC74b/lY9VkNr4jstr1FXH4KcspEjilzcpch1d/
xdHlRhBnOlTPjHsTork/HgExZPHWCSX+aVEktfjlQf54bQx52u14KR9HSv7xuzHLa6S65HK/mffe
yYEteFjy0SZu5Bfe3eBJMkA4pYJiEMYBvGIACNIy0KbHLb2XdbM1wJAsHODhSy7tK7BAu1olklgd
D5JGfzvF+lQud5JK5IPiffx0NjLcaXdS5wwtx8ckZ2vwVnpa/ccXrR0hVBtWgQCaklJWLCtFrQFg
Xeg7xHUaTPZ3VXiGwlMza6nZCKAaWXQFWGxRJToqEqomA6QjQuAr8JOCr/Ta5Gil0lSA
--0000000000008f2e8e05c0f6fb5e--
