Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BC5C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Apr 2022 12:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbiDYMaK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 08:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241987AbiDYM34 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 08:29:56 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A564A6E4CE
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 05:24:23 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j17so14630690pfi.9
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 05:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=hyIHIhSqrYqHgp1w9JnIylg4skAFEnOxGevWMaBp13g=;
        b=fIrmBZ5dLKWR64SECgm9Is2azk+vnAom0ul1Xky9hd1G7KFfEaUpOAJjU9wh/5tB4e
         tr5SIVtXGoouKdgyihFjr3G/FT8arSua8kb0EgJgDirCBi3sWfBtvfqeewJ5QHiX306U
         SzMBZ3G6R0rHQxg++AdZR2RK4KUTI9S5Ao5hY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=hyIHIhSqrYqHgp1w9JnIylg4skAFEnOxGevWMaBp13g=;
        b=KhmK7NQSLoPEUyGHwMV3mCWcdypNP9PLzmIJ2ClZYNn54Edb/RRfZtZgrdM6764JAV
         R0WyzbLbKOmhVt1+b+Qy2Sh25drgYN7Q+ZspksN11MSPXnNkzZpmXzqYAM7H5ZvcaQ0j
         qdA8C3IsIKGaExjoEYlRADLR58izsAIyRyhwK1bcBAzeN0EG5ICOpWC5J2Jbjch8nSHc
         cLZ9gIwlvkIDBqH1f2mAmGWDfK7iQVjqyTaomExx/EQt7MqRZiSlMTRlX74zdTZ1aHOq
         LLCyfMbY0D6jOtJXCsmOXsdOS4mHR6Re0IRbFkXO8KULDcKXuVmXbzD8hVXCNkZEGqTH
         JgSw==
X-Gm-Message-State: AOAM531vPHMq77Zxx0y7Ri1LLtoBuqqgB9GAcDLNwKKZLL9/nMgGokCA
        d4aiVDGNkFk8EuVe2IW6A8Fpou6BKI+OBl4WU9IY+puBIw/9kYVK6LbX2AfTqfPTxXHf/z/Hyuw
        inMmiyLnKK+u7pDJfJuSLgeP7byWjA0woxEai8KmCJy229wK7Lr3D7sQTJVGRCXv/8EBKweFbxc
        eIPuiHwOk=
X-Google-Smtp-Source: ABdhPJzikJz4pG3Z7UqZB3Hr94+PubwhVww4DMtYOOxjVvBbR1/OwU4xoxm0EkZeXvrrLd/srYLRtA==
X-Received: by 2002:a05:6a00:21c7:b0:4fd:f89f:ec17 with SMTP id t7-20020a056a0021c700b004fdf89fec17mr18735970pfj.72.1650889462801;
        Mon, 25 Apr 2022 05:24:22 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm9757722pge.23.2022.04.25.05.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 05:24:21 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        hare@suse.de, himanshu.madhani@oracle.com,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v6 0/8] mpi3mr: add BSG interface support for controller management
Date:   Mon, 25 Apr 2022 08:23:26 -0400
Message-Id: <20220425122334.368142-1-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000004fb7f05dd79a864"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000004fb7f05dd79a864
Content-Transfer-Encoding: 8bit

This patchset adds BSG interface support for controller
management. BSG layer facilitates communication/data exchange 
between application and driver/firmware through BSG device node.

v6:
-Fixed errors/warnings reported by kernel test robot <lkp@intel.com>.

v5:
-Addressed review comments from Himanshu for patch#2 and added
 reviewed-by tags. 

v4:
-Restored MPI headers to driver source directory(drivers/scsi/mpi3mr).
-Moved data structures/definitions used by user space applications
 from MPI headers to uapi header(uapi/scsi/scsi_bsg_mpi3mr.h).
-Addressed review comments from Bart Van Assche and Himanshu Madhani. 

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
  mpi3mr: move data structures/definitions from MPI headers to uapi
    header
  mpi3mr: add support for MPT commands
  mpi3mr: add support for PEL commands
  mpi3mr: expose adapter state to sysfs
  mpi3mr: add support for nvme pass-through
  mpi3mr: update driver version to 8.0.0.69.0

 drivers/scsi/mpi3mr/Kconfig          |    1 +
 drivers/scsi/mpi3mr/Makefile         |    1 +
 drivers/scsi/mpi3mr/mpi/mpi30_init.h |   53 -
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h  |   28 -
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h  |   31 +-
 drivers/scsi/mpi3mr/mpi3mr.h         |  133 ++-
 drivers/scsi/mpi3mr/mpi3mr_app.c     | 1605 ++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_debug.h   |   37 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c      |  331 +++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c      |   52 +-
 include/uapi/scsi/scsi_bsg_mpi3mr.h  |  580 ++++++++++
 11 files changed, 2723 insertions(+), 129 deletions(-)
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_app.c
 create mode 100644 include/uapi/scsi/scsi_bsg_mpi3mr.h

-- 
2.27.0


--00000000000004fb7f05dd79a864
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKDTnfo85qRgKgBbtF+EoCejkKQ8YL2E
EcfUUE+TkKJEMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQy
NTEyMjQyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBqBxHRSwu3vCUTjCW3cQ0e85RpQignfOdEpNwfoNdWYNeoTDEU
TIuVHA2W9clbWHWILXN0OqcPwkv34XNNN7hIuCO9T8WaAOr7whl/OMaa9pZJ/DSbKCrrdBW+15Ix
I5jPRuaq1aq1dGdGBN3kXQ5MfVbAWaH/1C2tqGlTwOZV+sBNSpMlylr5cw9Wsmmpwtok0dAezkZC
8qKIfkDZTTxsLx+48IICQj95JuPn65a/oOGeDiS402qglcuD3AQ4mKVqo4lG2IJOqUS9IIvCXGGw
IC3t6isIvtSFg7AUNVcaTa4X6hfxQki+tOM/Rxo6JRjEUGI5QbkkyvZXCv4bUsIq
--00000000000004fb7f05dd79a864--
