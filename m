Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MIME_HEADER_CTYPE_ONLY,
	MIME_NO_TEXT,SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947E4C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6643061166
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbhDSLC3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 07:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237914AbhDSLC2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 07:02:28 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C67C061760
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:01:53 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h20so17486752plr.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LfijYdv1eiDq+Ef4FM8Tw4kJU3aYgfOmAOW08abN+WU=;
        b=PzdPWY63+/1UWnGSFGgKj+cSZS/njqRT++A8XtEiOCsoXI6bqtYHTFZk3wcU1bzDrj
         BJcY7uvnj93fmLR/bU3q88St1DETBKdGnFmFdOuo301ukYSAZSF5S2iZMNTXB2Y7ye17
         Xv8ho9b7RC2IFuJIcWVtwaW+kZLpTzPwCYF5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LfijYdv1eiDq+Ef4FM8Tw4kJU3aYgfOmAOW08abN+WU=;
        b=Mhdk58wOLF1+Tzz5S11EvD5x4leQZ/vVTYnzQWMI7Iqx617sV+4N6bQeSbwrOZUbjx
         jeKUeAj2cz9RKqgfMPba7C+N6/6qYbHInwE476kPQU3hWrj8DuCRuwamp4qM2ltkVJtB
         wh4Qcf49gWDn4gj14fZ15LYt9hWmvuc35KV6R7IZQXr6Z9enzDo49f9VHRa5uoQv6Ptb
         DAOcM9cnuwtXxQkfnyNcb0gICOhJjZzgzCIWc+GjOXJxCtj9Meo2LX8BMpA2OQ4wpaPB
         aYNo7TFXEXWztCu/RjivfSqN9rLKxwntepwBKM0CDCp8fcTZWJqkcthivEIUGUmuDpZP
         BoZg==
X-Gm-Message-State: AOAM531ujJqVhPyMFSY5n8i8AdiFT5yN6FZ+LtohS3CjbyqJJfciLPtv
        pdNKunrS8AhU4fyuhkFU6wiTnBfVxEc+jdjSKgjxvSo0b0cmV9xKYoVjY/vW3skwcSY1m/na5Tb
        fmIpShuQ4+TMImLm6Hh68VdGQh/DKgk/UW7xY/M44vn62eWZAG/RDTQDwghko5OFFj/ezRz5TJP
        au6GX7lJUP
X-Google-Smtp-Source: ABdhPJywrDf6R71qZBNLPY3XIwPKHuZBI7LcwqOVsZw45atDaMuOG6NVjddbc7LGUkKNgB5msl6YkQ==
X-Received: by 2002:a17:90a:8b97:: with SMTP id z23mr23123886pjn.131.1618830112437;
        Mon, 19 Apr 2021 04:01:52 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k13sm11825736pfc.50.2021.04.19.04.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 04:01:51 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v3 00/24] Introducing mpi3mr driver
Date:   Mon, 19 Apr 2021 16:31:32 +0530
Message-Id: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d6088505c0514174"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d6088505c0514174

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
https://github.com/kadesai16/mpi3mr_v1
https://github.com/kadesai16/mpi3mr_v2
https://github.com/kadesai16/mpi3mr_v3


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
 drivers/scsi/mpi3mr/mpi/mpi30_api.h       |   23 +
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 2721 ++++++++++++++
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  285 ++
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |  216 ++
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 1423 +++++++
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |   46 +
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  675 ++++
 drivers/scsi/mpi3mr/mpi/mpi30_type.h      |   20 +
 drivers/scsi/mpi3mr/mpi3mr.h              |  895 +++++
 drivers/scsi/mpi3mr/mpi3mr_debug.h        |   60 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 3971 ++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 4146 +++++++++++++++++++++
 16 files changed, 14494 insertions(+)
 create mode 100644 drivers/scsi/mpi3mr/Kconfig
 create mode 100644 drivers/scsi/mpi3mr/Makefile
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_api.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_image.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_init.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_sas.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_transport.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_type.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_debug.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_fw.c
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_os.c

-- 
2.18.1


--000000000000d6088505c0514174
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKF2b7b8hoIFM+CyjlTS6+kiHOT8
RUzIgoAKFMtHVRa1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQxOTExMDE1MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBYRoFXzXDmClGCwoFU6YPRydSoUuIAnYac5nGibwASasiB
K5tSPFxj4Ge/ZsYKrtOTU0yCvZ8mW7rnzRK34y2K5Ny8Ia/g8NCbPftj6G0sWVwKhThBW3m32xkn
lmlqaus6okqivuN368DBHQ2YihbuuQdaXhZuW9H6Pg9D6nd41bCUVVSkctRut9FQMSBADuOPx2Kq
CJrLOnqSLLrVmxthtQa7GWAmuGWD39k9xZrpSWUt1CXOVHssj+/QzOTnNnjAzMXPzf322fKNwAK/
WzJs8essPK2Unk5pMwrEUL3GzM44/SI6HhbQPzdqqYjtFgldJZDH9zSzo6Fh/ILP9y2t
--000000000000d6088505c0514174--
