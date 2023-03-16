Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0412C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 11:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCPLDE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 07:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCPLC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 07:02:57 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF0B3CE3E
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 04:02:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso4807507pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 04:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1678964574;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=HqfNcXAmucmpZLUoK4UBHZ8hrBWycmCKznL9U5LGagg=;
        b=CtPRqIQsrrW9KVA9Fy7ysjT+Yd4VSMXO/lZwtBLKMDD1/4NqioBLPdy0nxz7M7DWak
         +nfxWirkVZTpPAhJqeMRhf4Tz8riEDh4ZFNDRYaMmtVo8jyeYmBgMKttWDgeBJIwkJT/
         2qR26MuG3wENw36qgXOvqIMB70abnvK1RoxA4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678964574;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HqfNcXAmucmpZLUoK4UBHZ8hrBWycmCKznL9U5LGagg=;
        b=DI9Csm+245CCZL/j1WlZ9GYfZiLZGCvi8dtxP3CCq+1y/nfOB2hTNb1ZI25/niJ7+E
         X9VOMBbhReCYxEHyZBk0+Y1/IZ0QvK1pv/9a/kKTfoRNwNI5PkWS3FwcpxxFEndvzPmV
         HGFbWOwNfcHNmZe/+NNFIz3qUO7yxY1p9HkNrv8CC5cyaaE1WZbgfdXfjyGbO4kCssi8
         cWEwJqi5JKl/AhL40kVoS/GTKh+EWQcGWWgrh45vrv8UL/4JOLVwXkMVtHXsIkwYUrCN
         dsp8ud5eXgBzldFrpo0e2q9j9WJ/bYR9kMXh+hNHC0qJROIXbDECoAISoBMBO9Wy4Q9s
         Qnkg==
X-Gm-Message-State: AO0yUKWIhfu6rnvpQMUwe7d/6lPBmYKnA4ig6Qj/C8wYae7jTWIZlj9R
        02rGgBh2+ShuJCzLK/GfEPOlGjPXCFZ9IY3Szc7PiMQDI1gQ1TJ+PBFBw+YXLOsTqYlhUweQZO2
        REzqaHws8qYmFeZ8jFFLZHYK0kN2Hbdvs7Zfr5D8chH+RnVX2Gi8Sp7EZmm5rbARJrZvIiXCUOj
        W9eW93/mUbqQ==
X-Google-Smtp-Source: AK7set84+vhVsdK9q74wb0wwP87mNDSyGfeXuxsLbTi5uwULjcsSxs1Ox6ol0ehqv3/w/0p8AANRtg==
X-Received: by 2002:a17:903:124d:b0:19e:8566:ea86 with SMTP id u13-20020a170903124d00b0019e8566ea86mr3328668plh.62.1678964574177;
        Thu, 16 Mar 2023 04:02:54 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id kb5-20020a170903338500b0019a6cce2060sm5343590plb.57.2023.03.16.04.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 04:02:53 -0700 (PDT)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 7/8] mpi3mr: updated copyright year
Date:   Thu, 16 Mar 2023 16:32:08 +0530
Message-Id: <20230316110209.60145-8-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230316110209.60145-1-ranjan.kumar@broadcom.com>
References: <20230316110209.60145-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000127c3805f7026781"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000127c3805f7026781
Content-Transfer-Encoding: 8bit

updated copyright year from 2022 to 2023

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h | 2 +-
 drivers/scsi/mpi3mr/mpi3mr.h              | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c          | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_debug.h        | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c    | 2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 1adccd2d5c77..2fc196499c89 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2017-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2017-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_CNFG_H
 #define MPI30_CNFG_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
index 64c58815988a..47035b811902 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_image.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2018-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2018-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_IMAGE_H
 #define MPI30_IMAGE_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
index 9efd4c6de813..af86d12c8e49 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_init.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_INIT_H
 #define MPI30_INIT_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index 1c6c6730df5c..f5e9c2309ce6 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_IOC_H
 #define MPI30_IOC_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
index 1b2a96325d21..7c15e5851ce4 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
  *
  */
 #ifndef MPI30_PCI_H
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
index e587f77ccd68..4a93c67d335f 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_SAS_H
 #define MPI30_SAS_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
index f0cd203d78fb..441cfc2c7f09 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_TRANSPORT_H
 #define MPI30_TRANSPORT_H     1
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index eb9a447986eb..a564747cf088 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 393b86ee2036..0bd1fd628206 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_debug.h b/drivers/scsi/mpi3mr/mpi3mr_debug.h
index ee6edd8322e6..e94f7520d153 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_debug.h
+++ b/drivers/scsi/mpi3mr/mpi3mr_debug.h
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 037134f8b024..e9b3684a3c8f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index b5daa76e8628..39ebaa8a0fc8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 3b61815979da..bd33dbded0cd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
-- 
2.31.1


--000000000000127c3805f7026781
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEH9fcpO4goERM0jBYW10/oHBJy/aQpY
XbDEWh0o1MYgMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMx
NjExMDI1NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBpFm3WrhjgPzBuu+LdMo6lKXwZ1N4VEcq++vdHr4DXh25sOHU2
9el6ID4w/gO6awaHTBTuEvFcfSd2vpIL1t3ox8PTiF0WKxPlZ/zukhK6+8mholPUiqcGIXSrLPF0
uJSKxvKaU+TOQ1MHMWnNRPy6BYPeN0IN6e1hr0D5QtFy4ieWqdt4+jkDFfMAz3ri6UOo4LYtLcqo
eEYPpajMNHaO4jod2SZUwlIbJPQ94C7LIKbSz7eZoNTkbUhj6RKIX/U9LqBUV2YX1o31VNRBwV8q
6umg0J9UF1dhZqhjq6+yIERqv702PxBb2ETqFSmHLKICWnD82Z5hwJi17r9HIUMY
--000000000000127c3805f7026781--
