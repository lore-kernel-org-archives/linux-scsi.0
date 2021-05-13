Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MIME_HEADER_CTYPE_ONLY,
	MIME_NO_TEXT,SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05953C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6AF9613D6
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhEMIdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 04:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbhEMIdm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 04:33:42 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A3CC06174A
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 01:32:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l19so58441plk.11
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 01:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=x25ubhn1FD5JJqpcLjd8dBl5b2LIZif/aTynIG6SPtk=;
        b=L3cOzvhVR2fUI8RSk/82udJ4ZxgOLkq+2udGPcDyYoLpZhXSuH+RvxtHDhNjmfy9wP
         MVQhQ9CrtF/yh+wR58yuOJJRDcicFTHdpJZhbYEHK37UPVOZwMjzMX2UvnF2XKcOQaMG
         fzkBpZ5+1Ue3orQ9pt4BsgFKzf9K+KmHOO/ps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x25ubhn1FD5JJqpcLjd8dBl5b2LIZif/aTynIG6SPtk=;
        b=eofM34ZbEKPmJnUXt4EFBeyMFsgWce9ZC3c/dKCq9eJt1g4JM4VrCg+2miE6yVYT2y
         TgcpcjL+3cBXAfZ7rpomx9+LZlDFZlWWRIUER7ChUeahMqVGMgybWlEE2mDhk5xEJRWT
         oSn6MestIAEZjDsgLad3PVfRZ0XY/ZktRusbxGf+V6TPp5708hN4B9U2Oc5urSt3QeNb
         zFKTK9Cz18CrIIvps4Ntp415Ai+6KZNPQy/LwWCkGiK69lCIZCRjVl9E/Z59/E2ub1mU
         voXf6yolM53COx+JlIK6yP2eFvcrbX+WzQq41qorwI2NJ0a8KhMpLIh4i5wQNLwkmfrA
         c9uQ==
X-Gm-Message-State: AOAM531kBI2jYrE1TeK0eJ6ZkH2aqCQ24E0V99Wv2pZctNd7RwXS9yvQ
        cP3Hw5poub9bKOxK72C3BpEE84HFfmTEHnFUL2kNyJyyNCtO7fg/nWTrrgP9H/Q1HmaCx4ibLLy
        qW6yatN80J8aFNrVjWlfB3fAz+pnGkuTvF/ELVkE5J54l3+/DbjLK0HvXYTBA61onrZf+KyCdAN
        QDKzaXuQ==
X-Google-Smtp-Source: ABdhPJx0qguhW9X2tFn6XMhUJk47qp28Sai5zREer6MS3B3zC6ELhTRNIFbqPzXoV3sdJKe1s5992A==
X-Received: by 2002:a17:902:c214:b029:ee:de19:9ae4 with SMTP id 20-20020a170902c214b02900eede199ae4mr38307885pll.57.1620894751741;
        Thu, 13 May 2021 01:32:31 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i123sm1632468pfc.53.2021.05.13.01.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:32:30 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v5 00/24] Introducing mpi3mr driver
Date:   Thu, 13 May 2021 14:05:44 +0530
Message-Id: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000edab1705c231f782"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000edab1705c231f782

v4->v5:
- Fix error reported by kernel test robot <lkp@intel.com> in Patch #6.

v3->v4
- Addressed comments from Christoph Hellwig and Bart Van Assche to make
  MPI headers compliant with Linux kernel coding guidelines.
- Added Reviewed-by tag from Hannes and Himanshu to appropriate patches.
- Use correct return type in scsi error handler (Patch #6) - comment
  provided by Hannes.
- Fix array overflow while printing ioc info(Patch #11) -
  comment provided by Hannes.
- Remove redundant kfree of dev_rmhs_cmds (Patch #13) -
  comment provided by Tomas.
- Replaced few strcpy with strncpy to avoid string overflow.
- Updated Copyright.

v2->v3
 - further removed unused pointer typedef from mpi30_type.h
 - Add Tomas Henzl's reviewed-tag to appropriate patches
 - Fix added which is Reported-by kernel test robot <lkp@intel.com>
 - Removed .eh_abort_handler suggested by Hannes.

v1->v2
 - removed undefined entries from mpi30_type.h
 - removed DRV_CMD_CALLBACK typedef
 - Use IRQF_SHARED  instead of IRQF_ONESHOT
 - Use READ_ONCE, WRITE_ONCE while accessing operational request
   queue consumer index 
 - removed in_interrup()
 - remove pr_cont.
 - move some code from error handling to device handling patch.
 - used direct values instead of macro MPI3_SECTOR_SIZE_XYZ
 - Add Hannes's reviewed-tag to appropriate patches
 - Add Reported-by kernel test robot <lkp@intel.com> to appropriate
   patches.


This patch series covers logical patches of the new device driver for the
MPI3MR high performance storage I/O & RAID controllers (Avenger series).
The mpi3mr has true multiple h/w queue interfacing like nvme.

See more info -
https://www.spinics.net/lists/linux-scsi/msg147868.html

The controllers managed by the mpi3mr driver are capable of reaching a
very high performance numbers compared to existing controller due to the
new hardware architectures. This Driver is tested with the internal
versions of the MPI3MR I/O & RAID controllers.

Patches are logical split mainly for better code review. Full patch set is
required for functional stability of this new driver.

You can find the source at - 
https://github.com/kadesai16/mpi3mr

Kashyap Desai (24):
  mpi3mr: add mpi30 Rev-R headers and Kconfig
  mpi3mr: base driver code
  mpi3mr: create operational request and reply queue pair
  mpi3mr: add support of queue command processing
  mpi3mr: add support of internal watchdog thread
  mpi3mr: add support of event handling part-1
  mpi3mr: add support of event handling pcie devices part-2
  mpi3mr: add support of event handling part-3
  mpi3mr: add support for recovering controller
  mpi3mr: add support of timestamp sync with firmware
  mpi3mr: print ioc info for debugging
  mpi3mr: add bios_param shost template hook
  mpi3mr: implement scsi error handler hooks
  mpi3mr: add change queue depth support
  mpi3mr: allow certain commands during pci-remove hook
  mpi3mr: hardware workaround for UNMAP commands to nvme drives
  mpi3mr: add support of threaded isr
  mpi3mr: add complete support of soft reset
  mpi3mr: print pending host ios for debug
  mpi3mr: wait for pending IO completions upon detection of VD IO
    timeout
  mpi3mr: add support of PM suspend and resume
  mpi3mr: add support of DSN secure fw check
  mpi3mr: add eedp dif dix support
  mpi3mr: add event handling debug prints

 drivers/scsi/Kconfig                      |    1 +
 drivers/scsi/Makefile                     |    1 +
 drivers/scsi/mpi3mr/Kconfig               |    7 +
 drivers/scsi/mpi3mr/Makefile              |    4 +
 drivers/scsi/mpi3mr/mpi/mpi30_api.h       |   20 +
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 1884 ++++++++++
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  220 ++
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |  163 +
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 1009 +++++
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |   37 +
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  486 +++
 drivers/scsi/mpi3mr/mpi3mr.h              |  895 +++++
 drivers/scsi/mpi3mr/mpi3mr_debug.h        |   60 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 3956 ++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 4063 +++++++++++++++++++++
 15 files changed, 12806 insertions(+)
 create mode 100644 drivers/scsi/mpi3mr/Kconfig
 create mode 100644 drivers/scsi/mpi3mr/Makefile
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_api.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_image.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_init.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_sas.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_transport.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_debug.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_fw.c
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_os.c

-- 
2.18.1


--000000000000edab1705c231f782
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIysHRGUMtJGbT8CIjniz4Y5ehAb
LPjAZPRdoHjCI04YMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUxMzA4MzIzMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAuwuENAC5ce2CtC2LU7Q7lAe2ixZW3qkjv4WWvbHxavI8U
tczaUlQFfyMvbxSnaPjb9rduKACWeXPR7qRZX5LgjatwYFmTfQSNRyTcdkqvj7N3bqSCd9Fy9nLb
pSlCb6pz6aEK8WI+Q0Vp5cK3TD14RKgJujXZL/lxSQL96g525O3tz5eIcJgBlMmNOYO2cvqmIvLN
ucL0O2H0bRHzZp9Xf3Gy1olgzK2qiOiuKPzpZuaiHOT3xX7N4maJC6j3QKC5Tf24ZihDhE6Gke9V
dedf8SOPjKCrPAPudpwj3FJi45uIjDXc1MxZUqBJSyUa0MqndIvFiOgYw3pEl2S0dY+p
--000000000000edab1705c231f782--
