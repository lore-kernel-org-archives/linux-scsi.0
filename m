Return-Path: <SRS0=Lz4Y=DB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E29C4363D
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 16:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF815238E3
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 16:31:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YrAOWx9q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgIXQbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 12:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgIXQbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2020 12:31:03 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007CEC0613CE
        for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2020 09:31:02 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id j3so2186901qvi.7
        for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2020 09:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:mime-version:thread-index:date:message-id:subject:to:cc;
        bh=s+FarfKRLQcAOJ95Xd8X2s476CeHPw+H32WavNfg3Qo=;
        b=YrAOWx9qpyq7/lvxsVRhK7rneFtUK2bOyTFO1Dzx5lWUHz98kPDur+fCjoC3gOa79o
         kPq1QKGJQOvqQUjAUeo51qMmgj6LG0kRow0wNQfHU/aIVe6bRCbX54dk8iDmL4wltbFT
         n1tsZsl12c/GFm6WaIPReviZC0kt48XnliNLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:mime-version:thread-index:date:message-id
         :subject:to:cc;
        bh=s+FarfKRLQcAOJ95Xd8X2s476CeHPw+H32WavNfg3Qo=;
        b=RmbfCf7JNG16H/kWWAnwrLnGdHH4lbqonKTCjcaD8Y+qbv8mfNYyVzPtTmMIQpTbc4
         lqmXTmMq0yxPMSeaYwNIhGIIGgsHuMYrj8F74YAAsbXj2Nw8LmJ/VDqzYB/2vJCi+AAM
         qDDjBuZgOze0w7U1/X/1yctamAbZ76EeLnFTHeNjSN+9NGvQ/QwhSKLmqmhVbEVZLZly
         8PAzomIRwxZOczrajhYxa6q+RzeOZ4pm8fRH/WLReI9eHYRZk0tzzJLCObEGqSCW+S3r
         soqM2Neqt/NGWwmPhdTqvbpSIZ2LYkawuQCdG9QdHNXvUEspFOYjf3xdOsjuHwagHTJw
         jloQ==
X-Gm-Message-State: AOAM532tNSLRG8lxGRMTkK57lWA3+D28dEu+zQDtKQV+uEMTHmBGPqiN
        Tm+sQGI6RPFkVZh/+I3DuwEEQ9i6TFdz3s2J254+6RKoJAZHwogF
X-Google-Smtp-Source: ABdhPJyXTt5niwx0sgM9B4UYF/bTEygF1b2efNcuCw6JcahUZ1Sj+gz9sl7kVj5pDaZSEbEyUZptfQ9/Mb0gnKwDZqk=
X-Received: by 2002:ad4:408f:: with SMTP id l15mr63288qvp.4.1600965061534;
 Thu, 24 Sep 2020 09:31:01 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AdaSjq9R2SPHjGPRR3eT1ulUKAKjSw==
Date:   Thu, 24 Sep 2020 22:00:58 +0530
Message-ID: <bb7d75ce38d5c6e2f19f467b17d67f26@mail.gmail.com>
Subject: [RFC] Introducing mpi3mr driver
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com
Cc:     Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d325d505b011b92f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d325d505b011b92f
Content-Type: text/plain; charset="UTF-8"

Hi Everyone -

Broadcom  RAID controller division has designed and manufactured the next
generation high performance storage I/O  and RAID controllers which are
significantly different from existing IT HBA controller and MegaRAID
controller and they are architected with significant redesign from the
previous generation of controllers to meet performance needs + simplified
Raid IO path for driver and OS stack (all complex part of RAID is now
handled by h/w in new architecture ).

Broadcom currently has Fusion-MPT (Fusion Message Passing Technology)
based I/O controllers (IT/IR HBA)  primarily managed  by mptsas,mpt3sas
drivers based on MPT generations and MegaRAID product family of RAID
controllers primarily managed by megaraid_sas driver, The MegaRAID
controllers are based on a mix of MPI and MFI interfaces.  IT/IR HBA and
MegaRAID firmware are tightly coupled in some cases but use proprietary
interfaces while interacting with the drivers. In the past, these two
product lines were developed in parallel and hence diverged into two
different user interfaces and different IO path stack.  The existing
products are compliant with one of the MPI versions from 1.0, 2.0, 2.5 and
2.6.

There were certain challenges in MegaRAID controller product architecture
which made it difficult to extend to its next generation of product.
Broadcom decided to re-architect hardware and firmware's components
completely to overcome the extendibility issues of existing controllers
and derived a new interface specification named MPI3.0 and transport
technology named MPI3.0.  Original idea of this new design is to extend
performance and functional requirements to the next level as current
design has already saturated this goal. Even though the name of this new
interface is MPI revision 3.0, it is a significant lift from the current
MPI2.6. I will cover some of the key differences in next session.

Broadcom has evaluated thoroughly on the merits and drawbacks of managing
the new controllers based on MPI3.0 using existing drivers vs a brand new
driver  and decided to develop  a new  driver called <mpi3mr> to manage
it's MPI3.0 generation of controllers onwards for next decade.

A key feature of this new driver is to deliver a single, unified driver
that covers both our tri-mode HBA and RAID Controller families. This
simplification is an important aspect of Broadcom's next generation
tri-mode controllers to achieve unified software stack and to enhance
overall performance of the controller.

Hence, we are looking towards submitting a brand new driver for the
Broadcom new generation unified tri-mode HBA and RAID controllers.
This Introduction is submitted as a heads-up prior to submitting the
driver patches and soliciting feedback for the new driver submission.

New driver named - <mpi3mr> driver will manage both HBA and RAID mode of
new controller products and it is a unified driver playing the role of
megaraid_sas and mpt3sas driver for future generation of Broadcom's
RAID/HBA controllers.

Broadcom believes that the key advantages of a new driver to manage the
next generation storage controllers are -

-         Unified host interface for both RAID and HBA modes of the
controller
-         Heavy automated I/O handling at the hardware level to enhance
the performance and to have thin driver stack
-         Exposes dedicated Admin queue and IO queue pairs.
-         Different system interface registers exposed to bring up, reset
and shutdown the controller similar to NVMe.
-         Improved memory requirement constraints.  For example - No
constraint of the same 4GB memory region requirement for request frame
pool.  The controller can support segmented request frame pool etc.
-         Firmware Diagnostic buffer interface is redesigned.
-         No requirement of Fast Path and LDIO path in driver (primarily
all megaraid_sas_fp.c code is no more required)
-         Multiple IO submission and completion queue concept.
-          Does not use the doorbell mechanism for handshake with FW prior
to interrupt setup.  All management communication will happen through
dedicated Admin Queue.
-          IOCTL interface is not similar to the older generation of
controllers.
-          No difference between SGE vs PRP creation of NVME drives. It is
all IEEE SGE.
-          There is no significant logic change in the driver for handling
bare drives and volumes and those are encapsulated in the
hardware/firmware level.
-          Because of the new h/w interface (admin, submission queues),
memory allocation requirements are significantly changed.


We will be submitting PATCH/RFC soon for upstream review.

Thanks, Kashyap

--000000000000d325d505b011b92f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQRQYJKoZIhvcNAQcCoIIQNjCCEDICAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2aMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFRzCCBC+gAwIBAgIMNJ2hfsaqieGgTtOzMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTE0MTE0
NTE2WhcNMjIwOTE1MTE0NTE2WjCBkDELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRYwFAYDVQQDEw1LYXNo
eWFwIERlc2FpMSkwJwYJKoZIhvcNAQkBFhprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALcJrXmVmbWEd4eX2uEKGBI6v43LPHKbbncKqMGH
Dez52MTfr4QkOZYWM4Rqv8j6vb8LPlUc9k0CEnC9Yaj9ZzDOcR+gHfoZ3F1JXSVRWdguz25MiB6a
bU8odXAymhaig9sNJLxiWid3RORmG/w1Nceflo/72Cwttt0ytDTKdF987/aVGqMIxg3NnXM/cn+T
0wUiccp8WINUie4nuR9pzv5RKGqAzNYyo8krQ2URk+3fGm1cPRoFEVAkwrCs/FOs6LfggC2CC4LB
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgLUsuiPL1
nH+/P9ogSP7/fhz37HtiEZtc0LYqrh6Y0CQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAwOTI0MTYzMTAyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADm+CJKnHFDsJ+Wx34Q45Mnzm0i+
tQdMNjBn0Acy6awzd6PH0t02w9azFAc3eiKuo8v7HGgNXSQHQQA/glYRjeqydDYO/bId62luhu+h
gPNRHEi8fabFrX2SND1t8G4xO3b5CM2D0jWERNGQYlqHKUr+L8KyiC0WgsG+T5VuYZm9t1Z76F5v
djD2szCWiZ4GtiiPcLYnPjIMcSo2Veyk3LAAIRS3ab6VZ3mjZTePBo9JpGU03mf5K3RFZGE6pPzb
j7ZzPnSgj71oTTXmTLjPcHbyrO4N7+YRFLh0ma+gm4GRrHQ4zWswtsEmpVa68qR34UraJErUOb8a
hNb9Ex3ZO0g=
--000000000000d325d505b011b92f--
