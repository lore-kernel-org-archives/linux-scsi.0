Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C2DC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0856864F25
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581616AbhCBS7t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244125AbhCBS06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 13:26:58 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E44C061793
        for <linux-scsi@vger.kernel.org>; Tue,  2 Mar 2021 10:11:34 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id 2so6373866qtw.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Mar 2021 10:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=iIZ76uHOX39xaOig73yIc4asv+BYoaj+aoQq5sFumuE=;
        b=gCQVqkGMPwwOPnYO7b5HYZGfyVYCtTEI/CFva2UoXgybIFCIxov0zL3knY8722gU/l
         YrLHGKZL9APGT0ZDKZ6AcC4W5snXK4vqFvqA7qOZxgOPRHccSkZXiSbw9eYu9tMXSHmJ
         65sB8MwG0F5jg0hEf/gwHLT6+ag9Dyr0hg7Ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=iIZ76uHOX39xaOig73yIc4asv+BYoaj+aoQq5sFumuE=;
        b=oQmUsg/cEdRM+0NmYQ0Uvbk8p+xJdW3T0b/2AibCNKFN7C8RrDn2We6pyCtjAnK01y
         1SLj1uqOGThb1ZGz2xg8cFz+8FIsR/d8iTXaDCNiAGWgkxacfcwzYA6c4m/0dZAw+AOZ
         t2rDQ4p9HuMnJe0wcPiYwWe6OSBgjOXLwa+mZYIXC24Ao5k4oRCuOJ8oheFYtNhJQYFj
         b3N9NnE2/BVDekNIjdTlb+aCYsJc0w9wHn0FSxXI24UoV43ohb7OcpOaEyCbXPIdpTUa
         hvZFPsKdAo8Kp4dYyZXqR/mFxym2FLdcLbpEE7vzwU1dQdUWUGhiRmbwDMEKHSwwhvF4
         9ADw==
X-Gm-Message-State: AOAM531Io/ASyoID9RTsOVX5OBOT2TPIHCl6ZI9iAAEpOR+iG8zpYb1P
        sKaQkKUBQB9L/U1wIFqwQMmzmedCkQm5QkWIqmftAg==
X-Google-Smtp-Source: ABdhPJxzPL4NhFKDQN0rmRd50POT2kYCMq4uyXmbIMiZIky3jrvM1tZuDmZwKvE0hDW0i38fON264YDZawO8GBxDXrI=
X-Received: by 2002:a05:622a:2c4:: with SMTP id a4mr19073636qtx.201.1614708693910;
 Tue, 02 Mar 2021 10:11:33 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-2-kashyap.desai@broadcom.com> <3c325481-753c-d2e0-9110-c08cf747ed8f@suse.de>
In-Reply-To: <3c325481-753c-d2e0-9110-c08cf747ed8f@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIVk2r6yGrO96+nYWGuC86HruD4YwJ+nQ82AqgAOqOpyr5ygA==
Date:   Tue, 2 Mar 2021 23:41:30 +0530
Message-ID: <49f794c98f2c62f717f143271bb0ef84@mail.gmail.com>
Subject: RE: [PATCH 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000024c19a05bc91aa5d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000024c19a05bc91aa5d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > +++ b/drivers/scsi/mpi3mr/mpi/mpi30_api.h
> > @@ -0,0 +1,21 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +/*
> > + *  Copyright 2019-2020 Broadcom Inc. All rights reserved.
> > + *
>
> 2020? Sure you don't want to update it to 2021?
This file is common for application, firmware, driver and UEFI driver and
we are consumer of this file. Further update on this driver will have
updated revision whenever maintainer of this header file post the new
update.

> > +typedef struct _MPI3_SCSI_IO_CDB_EEDP32 {
> > +    U8              CDB[20];                            /* 0x00 */
> > +    __be32          PrimaryReferenceTag;                /* 0x14 */
> > +    U16             PrimaryApplicationTag;              /* 0x18 */
> > +    U16             PrimaryApplicationTagMask;          /* 0x1A */
> > +    U32             TransferLength;                     /* 0x1C */
> > +} MPI3_SCSI_IO_CDB_EEDP32, MPI3_POINTER
> PTR_MPI3_SCSI_IO_CDB_EEDP32,
> > +  Mpi3ScsiIoCdbEedp32_t, MPI3_POINTER pMpi3ScsiIoCdbEedp32_t;
> > +
>
> As noted by Bart, this is a bit naff.
> I can live with having driver-specific typedefs, but having
> driver-specific typedefs _just_ for little endian is pushing it.
> (And incidentally also cancels your argument that you need the
> driver-specific types for cross-development.)
> So please, be consistent, and either use driver-specific typedefs
> throughout or revert to use basic linux types.

As explained earlier - This file is common for application, firmware,
driver and UEFI driver and we are consumer of this file.
Please consider header file as an exception.

>
> > +typedef union _MPI3_SCSO_IO_CDB_UNION {
> > +    U8                      CDB32[32];
> > +    MPI3_SCSI_IO_CDB_EEDP32 EEDP32;
> > +    MPI3_SGE_SIMPLE         SGE;
> > +} MPI3_SCSO_IO_CDB_UNION, MPI3_POINTER
> PTR_MPI3_SCSO_IO_CDB_UNION,
> > +  Mpi3ScsiIoCdb_t, MPI3_POINTER pMpi3ScsiIoCdb_t;
> > +
> > +typedef struct _MPI3_SCSI_IO_REQUEST {
> > +    U16                     HostTag;                        /* 0x00
*/
> > +    U8                      IOCUseOnly02;                   /* 0x02
*/
> > +    U8                      Function;                       /* 0x03
*/
> > +    U16                     IOCUseOnly04;                   /* 0x04
*/
> > +    U8                      IOCUseOnly06;                   /* 0x06
*/
> > +    U8                      MsgFlags;                       /* 0x07
*/
> > +    U16                     ChangeCount;                    /* 0x08
*/
> > +    U16                     DevHandle;                      /* 0x0A
*/
> > +    U32                     Flags;                          /* 0x0C
*/
> > +    U32                     SkipCount;                      /* 0x10
*/
> > +    U32                     DataLength;                     /* 0x14
*/
> > +    U8                      LUN[8];                         /* 0x18
*/
> > +    MPI3_SCSO_IO_CDB_UNION  CDB;                            /* 0x20
*/
> > +    MPI3_SGE_UNION          SGL[4];                         /* 0x40
*/
> > +} MPI3_SCSI_IO_REQUEST, MPI3_POINTER PTR_MPI3_SCSI_IO_REQUEST,
> > +  Mpi3SCSIIORequest_t, MPI3_POINTER pMpi3SCSIIORequest_t;
> > +
>
> Ho-hum.
> What happens if you have SGLs with more than 4 entries?

It is dynamic array. SGL[3] is primarily used in driver and you can notice
that it is for DIF/DIX metadata. Driver will fill simple SGLs in main
frame if there is a room.
Usually MPT Frame size is 128 byte, but another size can be defined by FW
as well. If there are more than 4 SGLs and driver cannot accommodate in
main frame, it will use chain frame which will have remaining SGLs.
Chain frame logic is same as generic mpt3sas interface (with slight
modification in fields based on hardware interface.)

> > diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_type.h
> b/drivers/scsi/mpi3mr/mpi/mpi30_type.h
> > new file mode 100644
> > index 000000000000..5de35e7a660f
> > --- /dev/null
> > +++ b/drivers/scsi/mpi3mr/mpi/mpi30_type.h
> > @@ -0,0 +1,89 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +/*
> > + *  Copyright 2016-2020 Broadcom Inc. All rights reserved.
> > + *
> > + *           Name: mpi30_type.h
> > + *    Description: MPI basic type definitions
> > + *  Creation Date: 10/07/2016
> > + *        Version: 03.00.00
> > + */
> > +#ifndef MPI30_TYPE_H
> > +#define MPI30_TYPE_H     1
> > +
> >
> +/***************************************************************
> **************
> > + * Define MPI3_POINTER if it has not already been defined. By default
*
> > + * MPI3_POINTER is defined to be a near pointer. MPI3_POINTER can be
> defined *
> > + * as a far pointer by defining MPI3_POINTER as "far *" before this
header
> *
> > + * file is included.
*
> > +
> *****************************************************************
> ***********/
> > +#ifndef MPI3_POINTER
> > +#define MPI3_POINTER    *
> > +#endif  /* MPI3_POINTER */
> > +
> > +/* The basic types may have already been included by mpi_type.h or
> mpi2_type.h*/
> > +#if !defined(MPI_TYPE_H) && !defined(MPI2_TYPE_H)
> > +#if 1
> >
> +/***************************************************************
> **************
> > +*
> > +*               Basic Types
> > +*
> >
> +****************************************************************
> *************/
> > +
> > +typedef u8 U8;
> > +typedef __le16 U16;
> > +typedef __le32 U32;
> > +typedef __le64 U64 __aligned(4);
> > +
> >
> +/***************************************************************
> **************
> > +*
> > +*               Pointer Types
> > +*
> >
> +****************************************************************
> *************/
> > +
> > +typedef U8 * PU8;
> > +typedef U16 * PU16;
> > +typedef U32 * PU32;
> > +typedef U64 * PU64;
> > +#else
> >
> +/***************************************************************
> **************
> > + *              Basic Types
*
> > +
> *****************************************************************
> ***********/
> > +typedef int8_t      S8;
> > +typedef uint8_t     U8;
> > +typedef int16_t     S16;
> > +typedef uint16_t    U16;
> > +typedef int32_t     S32;
> > +typedef uint32_t    U32;
> > +typedef int64_t     S64;
> > +typedef uint64_t    U64;
> > +
> >
> +/***************************************************************
> **************
> > + *              Structure Types
*
> > +
> *****************************************************************
> ***********/
> > +typedef struct _S64struct {
> > +    U32         Low;
> > +    S32         High;
> > +} S64struct;
> > +
> > +typedef struct _U64struct {
> > +    U32         Low;
> > +    U32         High;
> > +} U64struct;
> > +
>
> I wonder why you need these structures on a 64-bit system ...

Please consider all such things in header file as an exception since
header files are common and created to all platforms and users must use
without modified version to avoid API compatibility issues.
Mpi3mr linux driver is not using this but some other users like UEFI
driver, windows drivers etc might be a consumer of it.

>
> >
> +/***************************************************************
> **************
> > + *              Pointer Types
*
> > +
> *****************************************************************
> ***********/
> > +typedef S8 * PS8;
> > +typedef U8 * PU8;
> > +typedef S16 * PS16;
> > +typedef U16 * PU16;
> > +typedef S32         *PS32;
> > +typedef U32         *PU32;
> > +typedef S64 * PS64;
> > +typedef U64 * PU64;
> > +typedef S64struct * PS64struct;
> > +typedef U64struct * PU64struct;
> > +#endif
> > +#endif  /* MPI_TYPE_H && MPI2_TYPE_H */
> > +
> > +#endif  /* MPI30_TYPE_H */
> >
> And I do agree with Bart, please kill the pointer types.
> It's not serving any purpose whatsoever.

Same as above.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		           Kernel Storage Architect
> hare@suse.de			                  +49 911 74053 688
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: Felix Imend=C3=B6rffer

--00000000000024c19a05bc91aa5d
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMF+lhyz2R/nwxtWc39VG7XamrJf
IRX8L1wzv+/AtsmLMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDMwMjE4MTEzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQB+YIN3sNJlP7o7Nfzu36wGQL4IMNY79M89/R1/zZ3+QDql
xeu8sso3SR51/3T+nS8HWta2+x+sjDc4NmXkwKW7vQcgdvMoWG2tt0PKZq3A+Yi2yLQP26eE56ei
SQGmFez9s9pM2E2AUmF+49zsYKXPfglV2Aae1ALxK0iuFibCrOfBfZS7c993ohgUpvbPujdHu7+M
ugvpxsvP/t1/C7p9wlSKRHxp411ryG8q7f4RLs79ErKKj0VRET+7aM6i/XVPFoO5JlXR/uo1n9ze
tkNZSepQXcROst0OW2kvYqG2svPH4z0Xkl7H0OO6qRhWUInlQ/fIff1PwWzh4ndYO+QP
--00000000000024c19a05bc91aa5d--
