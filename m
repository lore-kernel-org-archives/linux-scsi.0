Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9B9C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 14:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbiDHOrh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 10:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbiDHOrc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 10:47:32 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D321E2BD5
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 07:45:27 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i27so17784394ejd.9
        for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2022 07:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X1cKTqcQViXafS1VNce/VD8KpttAi5tCsHaWiMoE4xA=;
        b=a6Aq2UdHLBWbEyZ0S4N06fXCctgcupcbgzqYRgwNoevzQ0eBU008r6VYRDuf23HiDd
         w78xeh7YiDuInxkOoM2UtBzrtMUJ7rP3Y+5tc44Qj04sT+a6N9o1tiJTSYE3N4ulWRfF
         VTTONVgwlh3RBkafJ2YaKwXsR509fxMk/lGr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X1cKTqcQViXafS1VNce/VD8KpttAi5tCsHaWiMoE4xA=;
        b=Emy+jcVyTm0aBscxC9JNy1SI1/N+QCcQHZKEDNuKydN5/8M0jI5p9jS36OTSHj4GGQ
         BlRC/bdcqB2nfvJgTZpYYf+StOZp7oBq+0Hn/sse5jRvM7IeAP2VpkPRl7Z28YFRDBXf
         p0SVVxwwbQguzz2HZklfPJPuQ7dZWNA+hgT275mQen8c0/gyBQQLZ57ThN6eNOJVnlDR
         BkaqkMAMds+EGt/SC8oWU72n56PN3VeGoVacUGld9tyGlCo87e+wptFq8C8ycohPRyEx
         JWXwnReGIeSECNlxkiSJW0hOE2Hfia0ZQR62AwAdaMxEq81sLUiEg1cCp/mh4Si53uyw
         +GAw==
X-Gm-Message-State: AOAM5328UsaQmSFd+NWyyXHP/1qn8g1oUK/TwIYnGRqm2MQej6POAxce
        csCpFKMloi1BtcIOhC2sxuNf309TrfFdyTfHJbJFDW5Kf83QReZidKfTSaGWEnS39h5wMAbXkT8
        JMf6AXYg6ZsETN/MchZr+adbe4DFks/nJ
X-Google-Smtp-Source: ABdhPJxGhgSTzygfXjIq88sk5oW9yrj+NyLmWTW4uLUn4QC9C1n0jR01MKnF+jyH7QAO7SMHHnSGHQTpp9lY0BxlggU=
X-Received: by 2002:a17:907:8a09:b0:6df:f1c6:bfc4 with SMTP id
 sc9-20020a1709078a0900b006dff1c6bfc4mr19031305ejc.550.1649429126238; Fri, 08
 Apr 2022 07:45:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220407192913.345411-1-sumit.saxena@broadcom.com>
 <20220407192913.345411-4-sumit.saxena@broadcom.com> <20220408051351.GA31826@lst.de>
 <d5cd2ee3-2520-6fc6-0292-0efbc7f34a65@acm.org>
In-Reply-To: <d5cd2ee3-2520-6fc6-0292-0efbc7f34a65@acm.org>
From:   Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date:   Fri, 8 Apr 2022 08:45:09 -0600
Message-ID: <CAFdVvOwj43jDSj78JFMPPHdc_9QvJt3e-dDZ9yuHAF+Ut3At+g@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] mpi3mr: move MPI headers to uapi/scsi/mpi3mr
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Prayas Patel <prayas.patel@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002c143705dc25a547"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000002c143705dc25a547
Content-Type: text/plain; charset="UTF-8"

Bart,
We can submit another patchset where we will move only structures
which are used both by applications and drivers into the include/uapi
and keep the remaining ones which are not used in the app into the
older mpi3mr/mpi  folder.  However, I have a generic question on why
we need to move the headers into uapi because the driver provides the
transfer mechanism already in the uapi through app.h and the
information transferred in through that is blob from the driver
perspective and that goes to the controller directly and processed by
the controller, only for specific cases like NVMe encapsulated
command, to set up the DMA address the driver parse through the
command.  Wouldn't it make sense to keep all of the
controller/firmware related structures along with the driver and
expose only the transport mechanism in the uapi?

Thanks
Sathya


On Fri, Apr 8, 2022 at 8:37 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 4/7/22 22:13, Christoph Hellwig wrote:
> > On Thu, Apr 07, 2022 at 03:29:08PM -0400, Sumit Saxena wrote:
> >> MPI headers are used by user space applications so
> >> it makes sense to move them to uapi/scsi/mpi3mr.
> >
> > I think this is a horrible idea.  These headers are a huge and a bit of
> > a mess, and no we need to provide uapi guarantees for them.
>
> Hi Christoph,
>
> Although I agree with the above: my understanding is that this patch
> series adds a new NVMe pass-through mechanism but without adding the
> necessary declarations under include/uapi. That is why I asked recently
> to move the necessary declarations into the include/uapi directory.
>
> Bart.

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--0000000000002c143705dc25a547
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AYPMVSim4+pTItuq9IB5a3B4lXktI8GoZ4icvNq/tDUC+UQBkiyx41thyEA3MCL+kgpIDnw1yNbe
DuhEcmBxC3E4cziK/swLRngmgXt+5vyInAJZt7HlQxtmx5IEZ4mXQ9lv/ZbRm6xdAgMBAAGjggHc
MIIB2DAOBgNVHQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRw
Oi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcnQwQQYIKwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJz
b25hbHNpZ24yY2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZo
dHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRC
MEAwPqA8oDqGOGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3JsMCYGA1UdEQQfMB2BG3NhdGh5YS5wcmFrYXNoQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
pgsVbwKDpO1jbwtH74jMrhpldKgwDQYJKoZIhvcNAQELBQADggEBAAs3g9+OH401HDPcsiK943D1
29CLPOuPWwMLezDdRvDcSqXw/gHia/3hEqnSZiSNEHi7WJ+bhd7c/kLupVhlae5tQwGMchue4U6R
/3Ck8BQ5wivGrL3n0hksKHrXs+pPI96sat0kZCX/OVLJ6KfZoNBnl4lgXkgjfrWs/2U+gcMU2lmw
zhujPHSNF2UIyRNtvcw0NozAtiov/KGLHocfrD39IAsX9SpKaqH6W0lFtOeevTeAg7Y0yXo7HXKY
t+RqMzkDTXFXS6MXhqwXQHf6laWJkR9smRePlZ7BHSurIjHbpKhVaYCd6aKI4gUlq2t/zr+ct4Ls
WZg6a7glbWLB4YExggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx1ZyicYAvHT9A0GRQwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIP/bfu0i
r1PUFuuhSK307hAGoVGMUAQCHimoMFt2GuaxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIyMDQwODE0NDUyNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCQoD7lf9qmVmnWjvccC5JBJT8h
y2pGPzsZqUI55cxgsPp8w//z1p7ShV2GlEU6DTwm9DyTnr9eczND6v9CaP2jJ6iFvudPZ5zseoby
ws/YFGqxXAHxAW1gp3rVW0EiT6rLfkhyipBgS0N9diyTW1YEcPSirIIISMOsZhRaRARJ2/vwrB1+
67QSQJkQZ1fybG7K+7R4ys+E7CTGxG72HJTsMywp4ruaMaFjwWofRsXMoRfWjoCVB9uM4l9A8YIo
KKQtMumFYkPOVbp3ulosUCAw6UQDQSxloHHkzrVxireWlAl4FoRX/tsoHMx3SBySVtln6pj8S8EV
rZ8QnucJYTBG
--0000000000002c143705dc25a547--
