Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_HEADER_CTYPE_ONLY,MIME_NO_TEXT,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE83C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 16:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 512DD64DF0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 16:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhBOQHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Feb 2021 11:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhBOPr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2021 10:47:56 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DEEC061786
        for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2021 07:40:25 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id gx20so4140279pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2021 07:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=A6QzahvyaSfp2UWOam+EBuhZMAevNzh1YdwFtjgK84E=;
        b=DM7Iv2oV/WuU7oXJ0MeVR90RTvlwthfLV5S+kz5oHI0jIcLi6PpVkLJz2GPimQZcfx
         wfDRmy2C8IkrPxKcrd7wkAg112mGhXWuXGyh6P5/zzDhWd3j7C/AUUP/EAvk/vNyw3jH
         LnLW0iUBv5iy6+D8QpDtdERjLvPj/1diHXbeY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=A6QzahvyaSfp2UWOam+EBuhZMAevNzh1YdwFtjgK84E=;
        b=N1nK7F26FSllKPviARGpIhEPm802UdTA+gl1U479uEEYaI42rTuU4NHyiFIiUh7LSZ
         0WdN7iw2vVa1kkB+7Usc9YyAdUkbnl/4/KrMMgedISe0I0ndyJXqnJAuFXxwDJvGfeeA
         3HZSvAs+mcLqGT0fpe2NrdCzwEDjBdYCdME+kk6Hxa6XKdpqsDe853+LNOOfaZagltF9
         tAH7xSgmLyPKCbhBnE2HKrTVFj0nd6QIgGjXEHdrRJBKdnT74vT6UWxllejkzJDdYKAv
         VmagAZjo3rlSGP02GCbBVjsbmueiZTNQf8yz9J3D+autseHdo/UniaIa7HXgGGZM+T1m
         k1jg==
X-Gm-Message-State: AOAM5317SIrQ/Iw94q+fO/+enNESzKhMaE7u6aMR96K3MmnC5swhL/a4
        iYAUQOmwNxTmOCWURpYS2Byaj7BwbykvrA5w8gUE8ckvqPNwTgnW6037YGX5Oz1z/4FAZjCr+4h
        eCbp7dO5FpdtvRlXgjaoAm+shbUw6nv1yYI2MoRXW0Vt8Dn/bL5ecwEAqI8PSrUqs4QoRweLbPX
        Fa1Zg1taI3
X-Google-Smtp-Source: ABdhPJz3psfC9q6lAHi6PwJQPj/Wt+Xg2HVqIr45R/ZU6X0M6PEe8vUmpVcatXsZLP2XJ4JkyM/1pw==
X-Received: by 2002:a17:90a:9918:: with SMTP id b24mr3745754pjp.127.1613403624103;
        Mon, 15 Feb 2021 07:40:24 -0800 (PST)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id m4sm18031341pgu.4.2021.02.15.07.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 07:40:23 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v4 0/5] io_uring iopoll in scsi layer
Date:   Mon, 15 Feb 2021 13:10:43 +0530
Message-Id: <20210215074048.19424-1-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f0344c05bb61cd48"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f0344c05bb61cd48

This patch series is to support io_uring iopoll feature
in scsi stack. This patch set requires shared hosttag support.

This patch set is created on top of 5.12/scsi-staging branch.
https://kernel.googlesource.com/pub/scm/linux/kernel/git/mkp/scsi/+/refs/heads/5.12/scsi-staging

v4 ->
- Merge "[PATCH v3] scsi_debug: add new defer_type for mq_poll" into
  this series.
- Fix IO hang issue of above patch and created v4.  

v3 ->  
- added reviewed-by tag
- Fix comment provided by Hannes for below patch.
https://patchwork.kernel.org/project/linux-scsi/patch/20201203034100.29716-3-kashyap.desai@broadcom.com/
- Fix Functional issue of poll_queues settings not working in v2.

v2 -> 
- updated feedback from v1.
- added reviewed-by & tested-by tag
- remove flood of prints in scsi_debug driver during iopoll
  reported by Douglas Gilbert.
- added new patch to support to get shost from hctx.
  added new helper function "scsi_init_hctx"

v1 -> 
Fixed warnings in scsi_debug driver.
Reported-by: kernel test robot <lkp@intel.com>


Kashyap Desai (5):
  add io_uring with IOPOLL support in scsi layer
  megaraid_sas: iouring iopoll support
  scsi_debug : iouring iopoll support
  scsi_debug: add new defer type for mq poll
  scsi: set shost as hctx driver_data

 drivers/scsi/megaraid/megaraid_sas.h        |   3 +
 drivers/scsi/megaraid/megaraid_sas_base.c   |  87 +++++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  42 +++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   2 +
 drivers/scsi/scsi_debug.c                   | 226 +++++++++++++++++---
 drivers/scsi/scsi_lib.c                     |  29 ++-
 include/scsi/scsi_cmnd.h                    |   1 +
 include/scsi/scsi_host.h                    |  11 +
 8 files changed, 359 insertions(+), 42 deletions(-)


base-commit: d39bfd0686fd2b21f857c61bb2753db3a932cb24
-- 
2.18.1


--000000000000f0344c05bb61cd48
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg53tUubCO
zcNq8IcT0JVp1u9rI0s304snX+GsZBIPjI0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwMjE1MTU0MDI0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGH+sPq6FB/5QyzItU9JPT6eGGEj
2FgUOlLzgSDpUxC8lJL6SnfngF/ZuCVP/GXCExSYrt3ReDMxEeu/j6GK+OTvNkZus2mWPxtkgp1A
HYdRtlAVYNOKgB9Bc2ZVLeLk8W4gooeCzOxOAFXEsEj3TxY8RxNIrv+jP7njrfpEJChhMx420D+5
5cZLx+3F+/9AtsNuAvMJ8wspngs5LkUe3zF02M7zuTDHzVma+SGXx8u2oTgNq5MlN+JnynUlu+wc
C+SCeouu6ZqMCXEl24fcsrHjlXap8Hv9fSPNEJUTk5UoMZKTpN577yZyNg/mFTt08i3BZThsg1jJ
kaC4z9eI11Y=
--000000000000f0344c05bb61cd48--
