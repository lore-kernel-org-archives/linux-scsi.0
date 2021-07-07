Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_NO_TEXT,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4741BC07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 08:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23B5B61C73
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 08:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhGGIPl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 04:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhGGIPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 04:15:40 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1BDC061574
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 01:13:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p9so1070421pjl.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 01:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=sjgK7L6d5P3m0zl1xoh1UTZsSaRzX8OSjGH3nQtYfAk=;
        b=Qgc+D+1ROrTZMoTPa+Ti4HYAh2q/Jn0Fkh7ECXlowiNBQQQ3QYje9NWA7mgVxv+W0B
         HH34hO4YDAcGjVHox5PlpWryrQugrVNSqVCjk5oTE77vPf8sR7D7jhKjmE4eSunKJck4
         UYobJ1oe7ouDtwYxHkkthJiMiqe3nuvTzPgyA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=sjgK7L6d5P3m0zl1xoh1UTZsSaRzX8OSjGH3nQtYfAk=;
        b=cH3OknxbEsuz7GMTDbZkStycj5shKpx4+XNAQ3wGFEN4bxzwf1wK8Mc1PitIGwHnJ3
         sWQx9BT1wGG5vkvgVRd/28Umh6n88noURK6aw+k8whnOVrHgF95lJt0N6vzn/9m0XJ+P
         44CAE2wUtK0u9TSplWNjBVF5fIeSsce18VWlXciZEX6qiVJLQzS1uOs+0K3OnP4udcE5
         tlKS8Jk4+3ynfy18ibHSsph0B2bCU+udCDW39VDflQ1ZAraZXX0YLfOk3fBYPnWgJ01k
         fH18JxtgwqIoxTMKY53rurqhb8H3W1J+2H/d40S8lGMcQbfvNtWKAXVEreFDzd76Rean
         16vw==
X-Gm-Message-State: AOAM530j/5UcGT9FJPwGqFdoiUevD/qJtUcAa950YMHR1c5B0VneO1Pb
        uMAno006wadTp6gpdzLaloNmUkrytvOOZxtwcpbfFl5Gs7Ug27LT95OiycvxTRkD5emqAT6b3XL
        yWl0Tc8o4fdZB5yroPnG+bqW5nbLACEs5nrAl9zgFoisi22qe8CUGwmO39OyMoqCW98qEYFJciV
        rNYNJx+jhKlrTkwg==
X-Google-Smtp-Source: ABdhPJwC2XD6esY7KRdhnU3mSHjpJ4aY32CKKwkeLEZe/nYk5SYaSnhiPUstEkTL8W9B5OiFA8c55Q==
X-Received: by 2002:a17:90a:c288:: with SMTP id f8mr8915411pjt.194.1625645580087;
        Wed, 07 Jul 2021 01:13:00 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 123sm464867pfw.33.2021.07.07.01.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 01:12:59 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        kashyap.desai@broadcom.com, sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v3] mpi3mr: Fix W=1 compilation warnings
Date:   Wed,  7 Jul 2021 13:47:56 +0530
Message-Id: <20210707081756.20922-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005de16005c6841bca"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000005de16005c6841bca
Content-Transfer-Encoding: 8bit

Fix for below W=1 compilation warning,
'strncpy' output may be truncated copying 16 bytes
 from a string of length 64

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v3:
 - strscpy() itself will add NULL terminator,
 so no need to add NULL terminator again.
 - Also replace strncpy() with strscpy() in subsequent lines.

v2:
 Replace memcpy() with strscpy()

 drivers/scsi/mpi3mr/mpi3mr_fw.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 9eceafca59bc..2dba2b0af166 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2607,14 +2607,13 @@ static int mpi3mr_issue_iocinit(struct mpi3mr_ioc *mrioc)
 		goto out;
 	}
 	drv_info->information_length = cpu_to_le32(data_len);
-	strncpy(drv_info->driver_signature, "Broadcom", sizeof(drv_info->driver_signature));
-	strncpy(drv_info->os_name, utsname()->sysname, sizeof(drv_info->os_name));
-	drv_info->os_name[sizeof(drv_info->os_name) - 1] = 0;
-	strncpy(drv_info->os_version, utsname()->release, sizeof(drv_info->os_version));
-	drv_info->os_version[sizeof(drv_info->os_version) - 1] = 0;
-	strncpy(drv_info->driver_name, MPI3MR_DRIVER_NAME, sizeof(drv_info->driver_name));
-	strncpy(drv_info->driver_version, MPI3MR_DRIVER_VERSION, sizeof(drv_info->driver_version));
-	strncpy(drv_info->driver_release_date, MPI3MR_DRIVER_RELDATE, sizeof(drv_info->driver_release_date));
+	strscpy(drv_info->driver_signature, "Broadcom", sizeof(drv_info->driver_signature));
+	strscpy(drv_info->os_name, utsname()->sysname, sizeof(drv_info->os_name));
+	strscpy(drv_info->os_version, utsname()->release, sizeof(drv_info->os_version));
+	strscpy(drv_info->driver_name, MPI3MR_DRIVER_NAME, sizeof(drv_info->driver_name));
+	strscpy(drv_info->driver_version, MPI3MR_DRIVER_VERSION, sizeof(drv_info->driver_version));
+	strscpy(drv_info->driver_release_date, MPI3MR_DRIVER_RELDATE,
+	    sizeof(drv_info->driver_release_date));
 	drv_info->driver_capabilities = 0;
 	memcpy((u8 *)&mrioc->driver_info, (u8 *)drv_info,
 	    sizeof(mrioc->driver_info));
-- 
2.27.0


--0000000000005de16005c6841bca
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILBAfjMYP2rWMMH63vJJ
ib2EdiAFKRFabK8wR8hoxkXKMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMDcwNzA4MTMwMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAO8BjnCOUly5eCzn9DCliZn/oHRjny7VUT+7N8
84ERbnd87DNudRWasKqsGZhThbc2idYumUhktBLIkEW3QTF8fva8qaVqaKRjR18KNg862xDfhxrW
8H+2yOKfZNGxWRaTWsrkT57nkTNmap1GSwKw+tQYaKCHyQNk2KPPgGJYBrecSIJwT0CVbW/cel5q
HjzgsNiHQMAIcSBGH3Hgy0JhC1xjXY/3TqCVjqVfzpuwzBTo83CGjkfsVyo43w/2eeHkLcc2IniP
H09Pd6HGSvdWQIvO+EhpJjSFRlxpLwlgsvJ3MlXrGJZdk1qET9LTH9oOhrlhGDxNkRoDyNGT4J9V
--0000000000005de16005c6841bca--
