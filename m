Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03297C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 12:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6BD1613C3
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 12:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbhDUMVx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 08:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbhDUMVw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 08:21:52 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE41C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 05:21:19 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id z23so977219lji.4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 05:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dFK23tL69/zHtgkPOPGsutdBBvQgYk8rGx7d9R0yWH4=;
        b=ZDvDrMuYFdJyxEvwfStPY+Gl528YhecQAoZgggMe77LwKDNiEFmOoJJ9GSUdY1TeL3
         DmVU8YRyQJo0fcw2WycFXojFfmjDPtfxSl/f1rFnFiKumIXbNOUL1GE57ag8npv07rWg
         9ZiI+7KyUKUheeEwl1UEz9mrCIwghuLniK7IA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dFK23tL69/zHtgkPOPGsutdBBvQgYk8rGx7d9R0yWH4=;
        b=NCWJdtfR4CsBqshUvAMqcBKnn5T/TPDZCEB4z22SW8NBDToJeF0XOpTA1H3JvWUGZt
         tzGaT9CyjgXIjYDr2SrWs6+azkT37v34IsFEwLQeAmRv16YBvpDUlEAt/4RpcpmC0xjx
         zKwhYuZhr7snzqNlEwtcNI7UkPc0JsmfAvLsj0OTeGgBVRWtzJKJ9LLQyxEgyGTH+df8
         nyNqwXzQU6R87AmAY372xo10jqWIqgU6dGH9yccNp2oyatUTluNTRmrza2ZpEjmk5HB9
         wqBZBXQIHlvv7ZW09mXSzPftKS2iN6tKYKHFfrKyJP+C1T4oARbWyR/fdN8OSGe51axc
         no/g==
X-Gm-Message-State: AOAM531QGnneqDXxwpx/oAW2WWqrphnIzv35ekPS7TP9I9OiBAFgQkg6
        RdST8SR8Di3q2XwCbkKAZ6Ks+t3C2Iug4Z+UE2uyEg==
X-Google-Smtp-Source: ABdhPJxfU9+FZ7WyzqlbqBI/MR6Cd6gJJEX/7J0EdPIehxCdOKmT5wXPZElU9KKxiJE2CAh7VMQuFgTLSb9q8ItOLRM=
X-Received: by 2002:a05:651c:307:: with SMTP id a7mr18550126ljp.166.1619007677810;
 Wed, 21 Apr 2021 05:21:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210202095832.23072-1-sreekanth.reddy@broadcom.com>
 <fb7eb3b5-0a2e-c94b-4eb5-a69bae810f8f@huawei.com> <CA+RiK67DvX0MPJCRrBUpWDeu8Y7pkWMJ60J7XpSo8gsFMn+u0w@mail.gmail.com>
 <3336568e-356d-b858-7d45-40068a7eecee@huawei.com>
In-Reply-To: <3336568e-356d-b858-7d45-40068a7eecee@huawei.com>
From:   Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Date:   Wed, 21 Apr 2021 17:51:05 +0530
Message-ID: <CA+RiK64RY+eGC-qc5kY7ahtJ41CMADuAYn06H7JDJy+4xAZ-Vw@mail.gmail.com>
Subject: Re: [PATCH v2] mpt3sas: Added support for shared host tagset for cpuhotplug
To:     John Garry <john.garry@huawei.com>
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008aeec705c07a99b7"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008aeec705c07a99b7
Content-Type: text/plain; charset="UTF-8"

Hi John,

Removing ioc->is_gen35_ioc condition will enable Shared host tag.
We have not tested it with older generation of controllers.
I will test it and let you know.

Thanks,
Suganath


On Wed, Apr 21, 2021 at 3:57 PM John Garry <john.garry@huawei.com> wrote:
>
> On 21/04/2021 11:20, Suganath Prabu Subramani wrote:
> > On Tue, Apr 20, 2021 at 8:09 PM John Garry <john.garry@huawei.com> wrote:
> >>
> >> On 02/02/2021 09:58, Sreekanth Reddy wrote:
> >>> d transport support for SAS 3.0 HBA devices */
> >>> @@ -12028,6 +12053,21 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >>>        } else
> >>>                ioc->hide_drives = 0;
> >>>
> >>> +     shost->host_tagset = 0;
> >>> +     shost->nr_hw_queues = 1;
> >>> +
> >>> +     if (ioc->is_gen35_ioc && ioc->reply_queue_count > 1 &&
>
> *
>
> >>> +         host_tagset_enable && ioc->smp_affinity_enable) {
> >>> +
> >>
> >> I wanted to test host_tagset_enable feature on my LSI 3008 card (I think
> >> that it uses MP25 version), but is_gen35_ioc is not set there - is there
> >> some specific reason for which we can't support on that HW rev?
> >>
> > John,
> > We want to avoid any code changes for older generation controllers as much as
> > possible. Shared host tag is a major IO path change and for older generation
> > controllers it is better not to enable such feature and support.
> > "Fix engine policy for older controller"
>
> ok, understood.
>
> But is there a change which you can share for me to test locally?
>
> In the test for enabling, above *, I just locally removed the
> ioc->is_gen35_ioc condition and it looks to work ok. Is this good
> enough, or am I possibly doing something dangerous? I'd appreciate if
> you can share something for me to try locally.
>
> Thanks,
> John
>
> >
> >>> +             shost->host_tagset = 1;
> >>> +             shost->nr_hw_queues =
> >>> +                 ioc->reply_queue_count - ioc->high_iops_queues;
> >>> +
> >>> +             dev_info(&ioc->pdev->dev,
> >>> +                 "Max SCSIIO MPT commands: %d shared with nr_hw_queues = %d\n",
> >>> +                 shost->can_queue, shost->nr_hw_queues);
> >>> +     }
> >>
> >> Thanks,
> >> John
>

--0000000000008aeec705c07a99b7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBXAwggRYoAMCAQICDCAc2j96+IoHW5040jANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjQzNTVaFw0yMjA5MTUxMTMwMjdaMIGm
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xITAfBgNVBAMTGFN1Z2FuYXRoIFByYWJ1IFN1YnJhbWFuaTE0
MDIGCSqGSIb3DQEJARYlc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJp3W6i+yVqwmKTbucNHNrAD35AKBa4GklrnUcWS
As4Yz62jxfJOu+dcysfahgpi3JcAhTe/eRMLc5on8ReYZAYCMNJ+jpNKRuf1Abgh6nfhcNf+cuGb
S83CJlqxdJjbnimwwbueitA/edWTFjcULNUDZZEmAPJkbHXmlTlJD8TMdR0ezem/d4niexc4RCyt
YMUhnlcyFg+2OR0MKuT2Q714Ka0IamXFyyXhX5wD9B+ITo5hu+ZtXV2RuOXy0U2bIEQzFPVJ7QA9
hUD4z7+jEN/0xIbuF8EJZMsb6XAT+CFOjnizM5yvGFfmupDlyQ4JuVb86R8v2AEDpXmbdnS1tDkC
AwEAAaOCAeYwggHiMA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUH
MAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNp
Z24yY2EyMDIwLmNydDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3Nn
Y2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAw
SQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29u
YWxzaWduMmNhMjAyMC5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJy
b2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk
1b5I3qGPzzAdBgNVHQ4EFgQURmgYmHXuw9VrKqnEjPBuviQS0CEwDQYJKoZIhvcNAQELBQADggEB
AAp1Yt9kkxViI/9B/AQxLFmuC9wWruix0ajjegaJ/HZ6C1ky/V9QvI1MwweIhBiuk2jttOzO4h87
rADIQnEI3bf5ccaw61CJNqc6Cb4LiEIjPF7py8f6+rHL928xCUnKqeCO2sC0A+k39bCiyHaGo432
eXxWNXxGrLg6/2TuwgOtvbil0hWwK/Wf5ql2YiZXy8wRo9IhHoY/4cJLS/Fay8yKX8IdhEc3pNbu
dDLaJg39U0ikF3NHtNMaXXHgh6TMs3OsWhH4+zlvkC0eSC6dvasGxmpPQPQe/0huBB8gDbzGrRg/
cRn2ctMmNHxZO4EBJ5SzsV/lHimTk+5K39lzkzYxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQ
ZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwgHNo/eviKB1udONIwDQYJYIZIAWUDBAIBBQCggdQwLwYJ
KoZIhvcNAQkEMSIEIBqk/gNbFbBlscf74YAOnhkPWbHowKS1r1IfGj+w8Jx4MBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQyMTEyMjExOFowaQYJKoZIhvcNAQkP
MVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCR
XquaIU7d7AvRdqqYs0Pu0DTL+2PLBVNr9sOVKIHVr/C/QF9KscOdSHHDQr6mPcVeaPnz+CsXzXto
EX/sPQByIVMXwTZxLGWYDCpRG/TlCqdqdHkAdxxjkoUXcZrZj7PAL9zbQow8MWjFDypBK0Ap9DxS
kh+WsaV4hF27ByNN73EsiyBzh9d+jhtkRFWIf476wfdqtBVHZilpZy91hGFvAQQPo92ePDgHZHIM
Slswml941P+8RyqdPni1zpaYcr5JvYDT+ABq5BM4pvK4f5RFUhfevc6AUPWW5bTxrXZ76lc90k9P
MH2R1E4Gbc2g1ajfEPmPaIZU4aCBDKEf9Mii
--0000000000008aeec705c07a99b7--
