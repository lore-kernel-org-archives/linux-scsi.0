Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB351C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 13:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78424613C8
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 13:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242721AbhDWNTR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 09:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242705AbhDWNTQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 09:19:16 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D926C061574
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 06:18:40 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id s5so40731001qkj.5
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 06:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=Lk83xZh8GA3uGvgx1qBUG3iAvz60Ni5WAuZFgpl+i28=;
        b=GNlV00sXdbVtNfMvTrm02DU1spKFmAcOUIKPynqlHb3LTGta62G8TsHAOhOhTbcQpT
         0PGQGdo5Gbs/kLInx++Enxn/n42NNjEX0M9s9uUBTRoVgbv4BGNCa4iNUFTcbET2VPFW
         lWpAOZN71i40U175ZP33A05PRQOsyR9qBmpi8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=Lk83xZh8GA3uGvgx1qBUG3iAvz60Ni5WAuZFgpl+i28=;
        b=cz6CpjEOMYNSkxNkQoPcSlH2Dn1/y0PwoTrrp9LEkkmn95zWguOQqzRv+pa6bXmN5w
         wO/4y9HVa+cDDhLZ3cL0H0T14vLQjwVZaoqXaIYsrfMV71jWQa1mwnB02GiYJv1A/HPH
         2+yHavEPEkTyCk91P1L1GANAN0Tf7dvJjG9XGxjgUijMgjP8OsroBGe2LsEftJUNDXL/
         BZyK3yLZhu0r2ohbKENs3rjBnklBg6d6S/ksNdkmqPQiMuecwbQxjej3N1r3Y/147i6l
         xFVrkFqZnYjjgHQC0JseV+K5928lX/IM28VOn7Xui5SijrwqEd/35FH9CSvQ+6b1Kk/8
         Pglw==
X-Gm-Message-State: AOAM532NGeDtAxKSAOiF6D8tXU5jocuqSvMq+Fh1I5IN06Bgx69Zyf+F
        k5k94o6Qw8oxUdY7i7NrSgXMgM1YNxEQ45bxY084WHsZYrU=
X-Google-Smtp-Source: ABdhPJznEtg3vT+FDIgpvgdinTFrO3viX0fElH9/L//wwJWxIVmR7pXbgEk8xd8kb0RSMs0b6B/9N6Nhc1gbbvtg5qo=
X-Received: by 2002:a05:620a:21d9:: with SMTP id h25mr3997200qka.70.1619183919127;
 Fri, 23 Apr 2021 06:18:39 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-2-kashyap.desai@broadcom.com> <32dd1ee9-4172-50b9-493c-181ae66da11c@acm.org>
 <39cd58b5a03db494176f2f1df1ef365c@mail.gmail.com> <ce374ec3-754f-e36d-f844-088ac17535b0@acm.org>
 <15a1b800b7b3f2ab52e189700b07f412@mail.gmail.com> <20210420063325.GA3528859@infradead.org>
In-Reply-To: <20210420063325.GA3528859@infradead.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJcVwghM9OVj4HmzOm4xelj9Cqw9wIWPpHGAoWLddkBRCM/PAESKQrQAiAYSokCDbeBQqle1+pw
Date:   Fri, 23 Apr 2021 18:48:36 +0530
Message-ID: <a2370b16625dc1d06e1dabdd3732122b@mail.gmail.com>
Subject: RE: [PATCH v2 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000058a1b205c0a3a2d1"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000058a1b205c0a3a2d1
Content-Type: text/plain; charset="UTF-8"

> On Mon, Apr 19, 2021 at 03:50:50PM +0530, Kashyap Desai wrote:
> > Hi Bart - This is possible to modify, but I have to forward this
> > feedback to group who owns the MPI header within a Broadcom.
> > It will be difficult to accommodate requested to change in this
series.
> >
> > I have marked your feedback as TBD for upcoming driver update (not in
> > current patch set). In V3, this is not accommodated.  Hope this is OK
> > with you.
>
> Please stop this crap.  There is absolute no reason at all ofr this
mess.
>
> Please just write a normal driver with a hand-generated header.  That
requires
> less work than all the arguing here and means people can immediately
jump
> in and actually understand the driver, unlike the current train wreck.
And
> looking at mpt2sas/mpt3sas is is pretty clear that the comon header
scheme
> does not work at all.

Hi Christoph, I am working on converting/freshly written mpi3 header which
will be very much linux coding standard. I will accommodate the same in my
next post instead of delaying it.

Kashyap

--00000000000058a1b205c0a3a2d1
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGKPr9VieXp/KC9a1jC+6/QApm+e
3fYxQVyyF26Ix3+tMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQyMzEzMTgzOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQC9jaxeinUTvP/wgAyvgFZwAnCshBe4JXin5HaljvGe+8mZ
AU709pquYtbmsRIb8+d4oE6hTcOT1N6R68pq5JmcOput2n2AkcKpD0G3t2CI4BOTGXNKAa+DQOyz
BsnQd5wBxWj+rFYPqOsljkAQRENyMPwnO0VmrOLthv3uPG+jW1AL2L0ARhOHguGcdmHgOQHvC1M/
VRrgff0SDgp6pfAqwIZHlehaueYKkYD9iuZHxvFwLte8irW8nvOO9crxbnNHGBbhia8erQuxjvTd
7N0HLYxJRz6i3SN/AHo0Mn5JhexsHI/+/W5UuYRESfYnkye8D/mXvJeCkNwe3zzCgwe4
--00000000000058a1b205c0a3a2d1--
