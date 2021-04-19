Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49838C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 10:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1626761008
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 10:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbhDSKVb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 06:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbhDSKVa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 06:21:30 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B43C061760
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 03:20:54 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id z25so2910734qtn.8
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 03:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=Vb/sPbWrlO8EIiiTe5eaCqfS2pMSI6Z0DIUhyzyFEkc=;
        b=a323FEbT6yN8pHeJ2rTruiOWtGskL9AMC90MYiksKFYTJgnRUD6TWFJq9wGNAZ7fhK
         nCEBVkxB0jm2GGZbnh1PZWYLKnQghmbJUbZDHihcZz26PQEecayf7iFl1CZUJ7Fu00XX
         FUcsPpe9g0DxbqA+/qRT/UH4Mmvw8DoqSoQsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=Vb/sPbWrlO8EIiiTe5eaCqfS2pMSI6Z0DIUhyzyFEkc=;
        b=SUKN46okZ0NTFdhcRe2t1GfXBJ9aJWwaO8hQb3odQ7gMMjL2/JHIGfNgt9UhtBGrwU
         nVce/BDCIV3RRXsLVEvFxbOTuj+Nnf/sM76kiFsZhXqKvvIO8+RYRivV6+2fHllQ/GNQ
         B7ULDOMJJODNmzwon+h+RBP614RCfXY3r98TUToSgdW7dxcDTL6Pd8+7amUz2nDjKzUC
         8qqNPmgWMAJLsHr7iDKiU3tBZsHoZvchdTnAruhyFUpUD6EAV18DuMxDd52wmTRyUYyF
         4RmWKBPirSTuZIv3Tn5g1Je1kDC6EKhGPSgPtITUG6ZXfTMCuMaUDpOAGminIeF+7L4G
         kldw==
X-Gm-Message-State: AOAM530UKUI2UYwuo7ahJx6iLLuzXfxZ/fCpou0OodVIZ+8UIp96lVrj
        38cZ8N2ULavdOT9vBDAi2eB8VuKhcckeU6oMozHHvw==
X-Google-Smtp-Source: ABdhPJwvDUsQCI/TdGNoYEgWVEdPF9UvxxLQfHglx0gUFp6NpWteW1uxCD+aXKbcmg4rwW1X9LGuUVfj9SKCZqNZmwQ=
X-Received: by 2002:a05:622a:3c8:: with SMTP id k8mr11135295qtx.101.1618827652904;
 Mon, 19 Apr 2021 03:20:52 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-2-kashyap.desai@broadcom.com> <32dd1ee9-4172-50b9-493c-181ae66da11c@acm.org>
 <39cd58b5a03db494176f2f1df1ef365c@mail.gmail.com> <ce374ec3-754f-e36d-f844-088ac17535b0@acm.org>
In-Reply-To: <ce374ec3-754f-e36d-f844-088ac17535b0@acm.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJcVwghM9OVj4HmzOm4xelj9Cqw9wIWPpHGAoWLddkBRCM/PAESKQrQqXnJZ0A=
Date:   Mon, 19 Apr 2021 15:50:50 +0530
Message-ID: <15a1b800b7b3f2ab52e189700b07f412@mail.gmail.com>
Subject: RE: [PATCH v2 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003aa6f605c050af97"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003aa6f605c050af97
Content-Type: text/plain; charset="UTF-8"

> On 4/16/21 3:53 AM, Kashyap Desai wrote:
> [ ... ]
> >>> +#ifndef MPI3_POINTER
> >>> +#define MPI3_POINTER    *
> >>> +#endif  /* MPI3_POINTER */
> >>
> >> As far as I know there are no far pointers in the Linux kernel.
> >
> > Hi Bart - I can remove the comment and just use below line in this
> > file -
> > #define MPI3_POINTER    *
> >
> > Common MPI header file which is directly derived from common
> > repository within a Broadcom like " mpi30_cnfg.h", "
> > mpi30_transport.h" etc. has reference of MPI3_POINTER  instead of
> > directly
> using "*" there.
> > It may be useful for some third party development (like SDK) and they
> > can replace MPI3_POINTER  accordingly. Only mpi30_types.h is Linux
> > only file and we add wrapper in this file to make sure common header
> > file compiles on Linux instead of completely replacing whole MPI header
> > file.
>
> How about changing all MPI3_POINTER occurrences into
> MPI3_POINTER_ATTR * and defining MPI3_POINTER_ATTR as an empty macro
> in this header file?


Hi Bart - This is possible to modify, but I have to forward this feedback to
group who owns the MPI header within a Broadcom.
It will be difficult to accommodate requested to change in this series.

I have marked your feedback as TBD for upcoming driver update (not in
current patch set). In V3, this is not accommodated.  Hope this is OK with
you.

>
> >>> +typedef u8 U8;
> >>> +typedef __le16 U16;
> >>
> >> Introducing U16 as an alias for __le16 is confusing since there is
> >> already an 'u16' type in the Linux kernel. Please use the __le* types
> >> directly.
> >
> > I explain this issue in above comment.
>
> I'm not sure that explanation is sufficient. Has it been considered to
> change all
> U16 occurrences into __le16 and to add 'typedef uint16_t __le16;' in the
> appropriate header file if building for another operating system than
> Linux?

Same as above.

I agree with your concern and same is under discussion within Broadcom and
we will get back to linux community with outcome.
I am not sure how much we can fit considering it is widely used outside the
Linux so need some time. At very high level, I see your proposal should be
doable. Let me check.

>
> >>> +typedef U8 * PU8;
> >>> +typedef U16 * PU16;
> >>> +typedef U32 * PU32;
> >>> +typedef U64 * PU64;
> >>
> >> Please use __le* directly instead of introducing the above aliases.
> >> Please also follow the Linux kernel coding style (no space after '*').
> >
> > There is no reference in mpi3mr driver to use above defines. I will
> > remove them completely.
>
> Thanks!
>
> Bart.

--0000000000003aa6f605c050af97
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFt09YAH7tZzN0SLm3BHaj+somVi
6gtawUsEAUTacLr2MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQxOTEwMjA1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBeDMFG4iXx4z/pZlQpnBMgmoZwDOsrL7DneDRunws2deg4
N8zDSNgfWGeIOv2CIoDOHYvx/uAhQJqDBRRPhoiAdG43u8ctiXSOklb4TfpmmGref8mLmn3A31ZK
qw0xuwzpebQtb0NMUBRWKRmhYJjDj9eCS6kq4hxRyB4exUMoiYFuWx7SBMSwH7NKibgc5hfV8iSV
dWXIl2+nuphTDvQm5F6dnZI1tPWH3ybeu74u4QTZko9v6tpn1iZiSEpABfZGvcnK9oYCVV6OwH/e
5uNcbb3jFORQVRm8YnrXZs0/+zO588r5k1BVs7c7ndWIIsCkXuvGxlok1+zGEt7mnftg
--0000000000003aa6f605c050af97--
