Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1018C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 13:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD4464F0A
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 13:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhBYNiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 08:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhBYNiT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 08:38:19 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBD8C06174A
        for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2021 05:37:39 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id 204so5533343qke.11
        for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2021 05:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=gOmbdYFAak9lC4vWONL7JTrKgxspsly5eRnUQfqyxZM=;
        b=c0mNoYjzbW5l8OGuS2cdTcRKx1kdTmXJ2cMn8g3VqCBlBZjzSp0b7xuqiqy4Ak3Y5h
         2AzAI8sZFI1lg0QR1js2D71C7XkhCf4ilKPF/qTooRFOQcpX/6RXmm/1Rh322k0BJHSh
         Hx8oaEzsxZ9hWPfDi0HdhuLd2yJZkYAen4xnA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=gOmbdYFAak9lC4vWONL7JTrKgxspsly5eRnUQfqyxZM=;
        b=b61YwEJAV5Wa1/T21LuomGX7mMjQx1XJHXWdbBoODAsodaXZhUCjhPbLvUhBRNodge
         TzmPJe0FqZUkPsIpDcdilSBp7XnDI5JhQIL42DTE39GGKGfltXlNS2gd0TsdtRVtLvFO
         RPNhx1CxvAmpoHlrsJGrndWiti7i0I/bFGHvzAjbgJkWTpgu0qICu8zFaTzO/zuto652
         gBcxY6yU8cdUoocZqWnUCcjN79+69gCkssKiHnTb2nub6JJi+LN10pU7QrgDBUtH0jyE
         EqOlbqVAlXXLgefRSDAKIcS7eCNI0apjvq5s2SeE3Xwik6Ag96nLvMDfxQaWVPCBofU8
         E5Yg==
X-Gm-Message-State: AOAM533l7250DuwzIgHmVDUYgl8saKQhFeFmihPul7ZfvxbqhIrJfCEG
        xlVlguVMd/fnTf+ANZUgOQGX0nhtvwxQ9AwapqRLXw==
X-Google-Smtp-Source: ABdhPJxctSxtPNlwyDShBAUOsTFFOCOyR0lqRylC5hCM7tN6k4VK9JxRCVfTfw8EEyznRQVeRCBAbgz4D3XpoT/rpl0=
X-Received: by 2002:a37:9f91:: with SMTP id i139mr2707140qke.72.1614260258522;
 Thu, 25 Feb 2021 05:37:38 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-22-kashyap.desai@broadcom.com> <a6ff2b4b-90e8-9659-ab99-a20571511d24@redhat.com>
In-Reply-To: <a6ff2b4b-90e8-9659-ab99-a20571511d24@redhat.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIVk2r6yGrO96+nYWGuC86HruD4YwHUXBlwALnh5fSp113VMA==
Date:   Thu, 25 Feb 2021 19:07:36 +0530
Message-ID: <edc031956d135dc5f9bed9beabf0d059@mail.gmail.com>
Subject: RE: [PATCH 21/24] mpi3mr: add support of PM suspend and resume
To:     Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004e063605bc29413b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000004e063605bc29413b
Content-Type: text/plain; charset="UTF-8"

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Monday, February 22, 2021 9:03 PM
> To: Kashyap Desai <kashyap.desai@broadcom.com>; linux-
> scsi@vger.kernel.org
> Cc: jejb@linux.ibm.com; martin.petersen@oracle.com;
> steve.hagan@broadcom.com; peter.rivera@broadcom.com; mpi3mr-
> linuxdrv.pdl@broadcom.com; sathya.prakash@broadcom.com
> Subject: Re: [PATCH 21/24] mpi3mr: add support of PM suspend and resume
>
> On 12/22/20 11:11 AM, Kashyap Desai wrote:
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: sathya.prakash@broadcom.com
> > ---
> >  drivers/scsi/mpi3mr/mpi3mr_os.c | 85
> > +++++++++++++++++++++++++++++++++
> >  1 file changed, 85 insertions(+)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > b/drivers/scsi/mpi3mr/mpi3mr_os.c index 1708aca1a5cd..ac47eed74705
> > 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> ...
> > +/**
> > + * mpi3mr_resume - PCI power management resume callback
> > + * @pdev: PCI device instance
> > + *
> > + * Restore the power state to D0 and reinitialize the controller
> > + * and resume I/O operations to the target devices
> > + *
> > + * Return: 0 on success, non-zero on failure  */ static int
> > +mpi3mr_resume(struct pci_dev *pdev) {
> > +	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> > +	struct mpi3mr_ioc *mrioc;
> > +	pci_power_t device_state = pdev->current_state;
> > +	int r;
> > +
> > +	mrioc = shost_priv(shost);
> > +
> > +	ioc_info(mrioc, "pdev=0x%p, slot=%s, previous operating state
> [D%d]\n",
> > +	    pdev, pci_name(pdev), device_state);
> > +	pci_set_power_state(pdev, PCI_D0);
> > +	pci_enable_wake(pdev, PCI_D0, 0);
> > +	pci_restore_state(pdev);
> > +	mrioc->pdev = pdev;
> > +	mrioc->cpu_count = num_online_cpus();
> > +	r = mpi3mr_setup_resources(mrioc);
> > +	if (r) {
> > +		ioc_info(mrioc, "%s: Setup resoruces failed[%d]\n",
>
> A typo 					here ^

Noted. I will fix it in V2. I will scan all the patch for such things one
more time.

Kashyap

> > +		    __func__, r);
> > +		return r;
> > +	}

--0000000000004e063605bc29413b
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIK1BOWZur+ePElsk97LblKhqFd4Q
TLjrXLa+ChCSpTrzMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDIyNTEzMzczOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQB4/xJliLWU97EpmrV5vsP84Sj+kosCCKXuXU0VNsqKw9PN
lvYpYO7axdDbDcWh0STkZc1mo7sEOhh88Zvs8QNHLwChit9q+ql8KS2HqSX/JJwqLYxsyfDfrT0g
bbSm8aIQoDs0OiN0O9mnmrqOB6w1p7LgqvpE+Jx5f6QroIcwUaPbFtoYyDMIlu404WzBlQuQIG+u
zQvoUZjJi4YEgdvWvAEqvWexhYakTqwGDWsWf7+WdvgaDXQTbxiCtKYl+4rJdxVxtH3nQvEKkZKB
Tp/f+SBFoef+s7/fYeuUQbCOPm3lFvOPd8W0hp9M6EEE/3BksWlFELv2XgmQKgarG+Ji
--0000000000004e063605bc29413b--
