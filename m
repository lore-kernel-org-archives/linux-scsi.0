Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A000C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 13:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376E864F06
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 13:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhBYN0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 08:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhBYNZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 08:25:12 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2B1C0617AA
        for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2021 05:24:12 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id w19so5487099qki.13
        for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2021 05:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=MaSDJqvz/5k4qwi/qJSi7b59QqYGgrgi3NVEEtQQRmg=;
        b=dO7V687+TyyIwie0km/4GFqLCr0JY0EY07ltcqsdk8r0Sj9w3V3gFjotvUSx8+v5kV
         Tj+3+NUm3w/POZuItaMLRbRGUTu+hfuMT1tX147laCcRum265tMqvuNOAsPitsd6VAb7
         ogJSaEaOT524KchwceuogUWiJ2m2nUakCDdAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=MaSDJqvz/5k4qwi/qJSi7b59QqYGgrgi3NVEEtQQRmg=;
        b=MsZbMdh5uPKRdihgkFhz7mSFJ3dF718SI+1cDW8VCcpE7K8IacZujN9GL5+PLwfiOG
         Rs48vNRRiyuOWbmftWmqAWsInjDU440WfAQtBcAHgVaeYuH7KuaekjPai0oy+aOePmeL
         UqZgG6k7Iwl5+mJKM3lIQjE8Mi4HT47oLsq9RZ7unIf0DZma3VBdnQ7iMh9kp/jNU5Zs
         0Kjo1RIw4IJfXo2Xf4TLfGUAm/4jnIwuHyOnmzP2gf6OSmMwfSwQlDLLj+306EDaLExA
         0dnJV9QjzM4cbc9nBedPmNNUFxpqwWSYhn5Xhb80yv94Fll2eTzqDlNmW7F8R5Q77S/L
         JU7Q==
X-Gm-Message-State: AOAM530G4GJGsE9R4nbrgomgiSl4dTYK8vycC7SzCO/8EFGCpjb9B/rN
        hZngj0jFL1MccQ5fCJXsTyUcBqS7jpsYDEMPW//0RXRpVA3mKQ==
X-Google-Smtp-Source: ABdhPJxnAEIr9VMOiDXMqR+GbPWnEuy3UTdaZG8WDOpx2oTklFb8uyr1Rb7fMU3Lt4HNZOIS7uxb0inHQg2RDZUtJlI=
X-Received: by 2002:a37:5943:: with SMTP id n64mr2623645qkb.127.1614259451957;
 Thu, 25 Feb 2021 05:24:11 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-5-kashyap.desai@broadcom.com> <2faf0f39-67f5-a7c4-2e64-eb52d8da961f@redhat.com>
In-Reply-To: <2faf0f39-67f5-a7c4-2e64-eb52d8da961f@redhat.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIVk2r6yGrO96+nYWGuC86HruD4YwIZ+Yp5Aq2gOG+pxY2xkA==
Date:   Thu, 25 Feb 2021 18:54:09 +0530
Message-ID: <5c535a4374339ecf4521fb53a34e2823@mail.gmail.com>
Subject: RE: [PATCH 04/24] mpi3mr: add support of queue command processing
To:     Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003b167405bc29114c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003b167405bc29114c
Content-Type: text/plain; charset="UTF-8"

> >   * mpi3mr_slave_destroy - Slave destroy callback handler
> >   * @sdev: SCSI device reference
> > @@ -126,10 +658,114 @@ static int mpi3mr_target_alloc(struct
> > scsi_target *starget)  static int mpi3mr_qcmd(struct Scsi_Host *shost,
> >  	struct scsi_cmnd *scmd)
> >  {
> > +	struct mpi3mr_ioc *mrioc = shost_priv(shost);
> > +	struct mpi3mr_stgt_priv_data *stgt_priv_data;
> > +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> > +	struct scmd_priv *scmd_priv_data = NULL;
> > +	Mpi3SCSIIORequest_t *scsiio_req = NULL;
> > +	struct op_req_qinfo *op_req_q = NULL;
> >  	int retval = 0;
> > +	u16 dev_handle;
> > +	u16 host_tag;
> > +	u32 scsiio_flags = 0;
> > +	struct request *rq = scmd->request;
> > +	int iprio_class;
> > +
> > +	sdev_priv_data = scmd->device->hostdata;
> > +	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> > +		scmd->result = DID_NO_CONNECT << 16;
> > +		scmd->scsi_done(scmd);
> > +		goto out;
> > +	}
> >
> > -	scmd->result = DID_NO_CONNECT << 16;
> > -	scmd->scsi_done(scmd);
> > +	if (mrioc->stop_drv_processing) {
> > +		scmd->result = DID_NO_CONNECT << 16;
> > +		scmd->scsi_done(scmd);
> > +		goto out;
> > +	}
> Hi Kashyap,
> for what is the above test needed (stop_drv_processing) it looks like
other
> drivers don't need to protect exit function in this was (for example
mpt3sas).
Tomas, This driver code Is still under active development and I will
review this (marking as TBD).
Not only this area, but there are many more optimization possible in
mpi3mr driver.
We want to start with stable version of driver and gradually improve.
<mpi3mr> as multiple h/w queue support and mpt3sas is single queue h/w.
Due to some h/w differences we have noticed some issue are very frequent
for mp3mr vs mpt3sas.

We can opt other way around as well. We can remove this check now and when
we find the bug we can add the fix with root cause details.
Let me know if you are OK to keep this check now or add it whenever it is
required.

Kashyap

> Regards,
> Tomash

--0000000000003b167405bc29114c
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOWcIodfja68mIWMLUFPyqGMI2au
mxA9egjhda4mldbYMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDIyNTEzMjQxMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCbJQGEPoATvFvtfY3+gIWzlNdUs4ri8NbrQmI7Bos8Qu5i
cINRZ4iLGeA21ZClpOroqCocqOKmOb/6HcnQyQii4F1F1Js/6OGydyCmZm/pNMFSmS7Pcj+xURBL
hWJB1cL37UOHUE5bSNv3ty5RNoW4QiflDAx7q8xe0j+qYzBVnt0VoNWMyLCOpJCpO1X1iLD9e41/
ZTvruxVjYvcap0Iax3PbE2BSTioKpZn33zDqw2SoJDY3k2rTUmaPDY2N2gp23YrsA3rRyF0JzYBI
lPJcwNurvINzndmF9wQ1uY1tJeRk16ZI64hecrXfS8JnWHJcNRzR8ejyH+RG0A+67DNo
--0000000000003b167405bc29114c--
