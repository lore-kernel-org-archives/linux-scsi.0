Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MIME_HEADER_CTYPE_ONLY,
	MIME_NO_TEXT,SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE8FC433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42D8D611C1
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242968AbhDGCEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 22:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhDGCEY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 22:04:24 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD87FC06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 19:04:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 11so10087779pfn.9
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 19:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xUbvPjtHe0gbwSSfDi//rJzYJK9Kmye1CGUymwfNlDg=;
        b=DTzJj/oJz5SzGa9U3K7YHNcfAagnjredct0kvGPcO924z1xW1YmqSfbOf9W9JHlySS
         TP4AuSPfryk77RQtF1t6DQEIVmNBFigubUAjedydw5fAlNDtAEY4dTd8xjWak4ih5N2U
         7/qTFYu5cISZvyzJdXKHg7hCmQF5zCA0TOd0A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xUbvPjtHe0gbwSSfDi//rJzYJK9Kmye1CGUymwfNlDg=;
        b=kbrLPuE5OPdDSQRwfsG43CB+ZG0uTGdeEbPiw75IWPXeinEXp9qf0ZwRVa743ziD2b
         GdQKtbM7QPQwqNBz7eFXUuiMVEHajHpEKzDfpI1iyzz2m5EWWk7WBU8SNiRRkibfnram
         FPaZ7hXDcD3P51wLKNJg+hDfalxTf6Gm/8M9LU0UU6aa6OPUkxoaPx0yp3riW63+4s2F
         QYBJ8o4XjMiYQ7V+NVl7pBDw5+MMBAXvy0pghcehqXmxc7ka2ENqQREaGlqEenb+NEnt
         InanAPbP9C/j1hepeR31LKwXIyYA1oaZ3qBNTi6zUcoqWCiafMuo5DtUn1+vg/sJds8/
         CZtQ==
X-Gm-Message-State: AOAM530aO3W92FXsDdbY1wa0ZsqDOhQjJC9xzmPyAP/6fj9AjspqrbjR
        42zg6QswvVOLSoVSSop0FnvLvRSqq3sgZlF8bT7cTNi1wyca3PI+D+7pa4y+Wzq6xjk7CL7JzyA
        XCNGNHd5SadfNugdv6hgV+nbLkbWv55beBrzkJlcYtqZXQEelR+aMOb9/w+dZZPMzkUoWgPn9MC
        PHstvndA==
X-Google-Smtp-Source: ABdhPJx4/4LRHCpI4A1e6Noc/OIlVkHgoWUF8KKTZgnMQzqZj5YDyth7MpuHDgdyFn4bjxqq597k4w==
X-Received: by 2002:a63:f54b:: with SMTP id e11mr1000876pgk.139.1617761054904;
        Tue, 06 Apr 2021 19:04:14 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y9sm3435858pja.50.2021.04.06.19.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 19:04:13 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v2 00/24] Introducing mpi3mr driver
Date:   Wed,  7 Apr 2021 07:34:27 +0530
Message-Id: <20210407020451.924822-1-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000009bb3c05bf5859f3"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000009bb3c05bf5859f3

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
 drivers/scsi/mpi3mr/mpi/mpi30_api.h       |   23 +
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  285 ++
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |  216 ++
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 1423 +++++++
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  675 ++++
 drivers/scsi/mpi3mr/mpi/mpi30_type.h      |   47 +
 drivers/scsi/mpi3mr/mpi3mr.h              |  895 +++++
 drivers/scsi/mpi3mr/mpi3mr_debug.h        |   60 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 3970 ++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 4145 +++++++++++++++++++++
 13 files changed, 11748 insertions(+)
 create mode 100644 drivers/scsi/mpi3mr/Kconfig
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_api.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_image.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_init.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_transport.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_type.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_debug.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_fw.c
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_os.c


base-commit: e09481c55ba7346ab725f41891e1bb61729dda00
-- 
2.18.1


--00000000000009bb3c05bf5859f3
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEMO567sm/l/biF79sowOZq1pMMv
uYTy8BJO05MJdrIuMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQwNzAyMDQxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBodLxyjoJe3XVjpS363ocLrr0wk8OtWLVhzQJKIy+UdYEs
8lm00LFBacFYqIiPX7sC7bWSu3njN6bU1Ini6ZSC9P/Pn0WXqoDY6qmlOgy/76Dxb1D0jTtIl136
SmkM6gltOpjGOW/FSxFk9zpEfrrWfOJsu8rhArnX3ELHoapXKa1qZWPVLNAu1Aw7TbI1AYMQ7+v/
KMfhCPIaMdO5KkpzqM3Pt3UQgocULUIzoryu9FNuxW3ZrsvMUUBHpX43ucnDIewTsUUxkN+Qu/lF
TC+BfEfmcjfyLROlwVwCkzocM/se7xLAGJ44Ehlk0jwuIFA7TLFYI4h60Se1Ca5YK8BC
--00000000000009bb3c05bf5859f3--
