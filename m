Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C654C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 19:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiDGTeF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 15:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiDGTeD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 15:34:03 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC882B4481
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 12:31:52 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d15so5901403pll.10
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 12:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=bg8mstvRCMBocBZgStR59YYl8gkaGHLnhDVu4be2oZ8=;
        b=Cpi6j2gF4157zNhQrFdj6Q5eHAJ1jpiCcwlF4qsCxvwjDDP1SlS8khCMXiK2nvJa6P
         CU3dJ59yEZrh0Xq+m4/cscRYukHq/VtCrrG6IeO4zBvhxxo217/FKgRVjwcsNL4ddgcl
         ZfeGxU6i9iM/57m7f5RzEUu7PWjuToclcxid8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=bg8mstvRCMBocBZgStR59YYl8gkaGHLnhDVu4be2oZ8=;
        b=HN0bVoGH/sLKN8RNnNO8GbvI0a25s1qekBdUtmprPrdZqbDZvsEOcA0Y2VkR148sNd
         d7A0qQup532Eu3pNnkl0tM+xX0LQpKp+EC/t+iotyc7oh8g5lpdVsswxYeXBYz2n9Cp6
         xn9q2nePx3Fo7mlmWYPPXpcgedwmbiXohLw/nUTJUSetGF/q+GXNlm0ENjO92QCJrRtv
         5MpUYTjbrT6iYwsKTC5mqSySRfdZUwpJ32leS/zyHxC9+/amSWSQo7FpIc2Nb8ogcH5U
         q+IAFepd5OVG6GAAGq7+mS4UOQ+8toRUTd/WEsEzgXs/Fv2sawS3iIO1FTuEeKAPYei4
         HqTg==
X-Gm-Message-State: AOAM532vG+pcVpkK0EvDIIavLFK5N0Ct41zhi+KoDNaGUxGejL1qPR4r
        Yd5Jv6h0zfdkpxkFbR/mKQQ5xAPC5xUGomdWSlXoMa/P3FKiXP6W1TD97HZ2RFV1PpoBOQpY5rq
        Fl2kDTL4jFgTRE12zzvu8ec0IC2o/WPM5yNTAjPQqmTzexdJHyEaXVb5Ianx1m4qbLXY5CtWcMx
        z6QMorNrwsjw==
X-Google-Smtp-Source: ABdhPJxf8tNCKMupMIFH27EPkvs4E+RtxT07zyR4CGOsHiln6v+XSULu2HZ0dkrJV/E6yecyhkdwqw==
X-Received: by 2002:a17:90a:5409:b0:1ca:8a21:323b with SMTP id z9-20020a17090a540900b001ca8a21323bmr17758286pjh.135.1649359788236;
        Thu, 07 Apr 2022 12:29:48 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o3-20020a056a0015c300b004fb24adc4b8sm23579275pfu.159.2022.04.07.12.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 12:29:47 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v3 0/8] mpi3mr: add BSG interface support for controller management
Date:   Thu,  7 Apr 2022 15:29:05 -0400
Message-Id: <20220407192913.345411-1-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004fa5ec05dc15805a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000004fa5ec05dc15805a
Content-Transfer-Encoding: 8bit

This patchset adds BSG interface support for controller
management. BSG layer facilitates communication/data exchange 
between application and driver/firmware through BSG device node.

v3:
-Moved MPI headers to /include/uapi/scsi/mpi3mr
-As Bart suggested, moved struct mpi3mr_nvme_pt_sge from
 uapi header to driver header.

v2:
-Moved definitions to be used by user space applications to
 header scsi_bsg_mpi3mr.h in /include/upai/scsi 

Sumit Saxena (8):
  mpi3mr: add BSG device support
  mpi3mr: add support for driver commands
  mpi3mr: move MPI headers to uapi/scsi/mpi3mr
  mpi3mr: add support for MPT commands
  mpi3mr: add support for PEL commands
  mpi3mr: expose adapter state to sysfs
  mpi3mr: add support for nvme pass-through
  mpi3mr: update driver version to 8.0.0.69.0

 drivers/scsi/mpi3mr/Kconfig                   |    1 +
 drivers/scsi/mpi3mr/Makefile                  |    1 +
 drivers/scsi/mpi3mr/mpi3mr.h                  |  146 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c              | 1612 +++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_debug.h            |   37 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c               |  331 +++-
 drivers/scsi/mpi3mr/mpi3mr_os.c               |   52 +-
 .../uapi/scsi/mpi3mr}/mpi30_cnfg.h            |    0
 .../uapi/scsi/mpi3mr}/mpi30_image.h           |    0
 .../uapi/scsi/mpi3mr}/mpi30_init.h            |    0
 .../uapi/scsi/mpi3mr}/mpi30_ioc.h             |    0
 .../uapi/scsi/mpi3mr}/mpi30_pci.h             |    0
 .../uapi/scsi/mpi3mr}/mpi30_sas.h             |    0
 .../uapi/scsi/mpi3mr}/mpi30_transport.h       |    0
 include/uapi/scsi/mpi3mr/mpi3mr_bsg.h         |  444 +++++
 15 files changed, 2599 insertions(+), 25 deletions(-)
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_app.c
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_cnfg.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_image.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_init.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_ioc.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_pci.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_sas.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_transport.h (100%)
 create mode 100644 include/uapi/scsi/mpi3mr/mpi3mr_bsg.h

-- 
2.27.0


--0000000000004fa5ec05dc15805a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIH6w36rapdhSoNqR+btXxb5s+2rvGL21
zgUzaP9oMgR1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQw
NzE5Mjk0OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQB7mp26yh41BrppWWcm58gkbO+CoMo3NwUD9HacwjAo/SI+mCB7
3y4xsHTi6oDcxXUDlXXFyZgt4F8D+4kHknPWEtOKX5NpMk6bOnmdZwpIoqkr4IKtPrpWG3f1bGre
mlFHo0C+aACvMyIrMXziLMqgYJTnW6XhqZlNeaqhEodPytLun3LxpPSAixtOAddVNf2FD7M+iV2r
6BU+q1zRHyUfXUF8Jev5Ui0nemMKzHIRDCkVSGiTNt4GiYQgjbY23sC+RGKoRMFothBaTP3++y7K
HQ+mgKbpzABaf3cjDgRqsaFkHHhc3B3JSpSN8AH/9WIAvI50Y+kHiy0fAUpvlAXh
--0000000000004fa5ec05dc15805a--
