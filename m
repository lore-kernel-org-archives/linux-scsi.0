Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MIME_NO_TEXT,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA83C2D0E4
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8499222384
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FypTPky/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgKOT0z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgKOT0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:26:54 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329F0C0613CF
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:26:54 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 131so806632pfb.9
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=LbEzhfMqerOPCE9MWjzXOnHWBdhnf16rmleBMKP8jdc=;
        b=FypTPky/9sldeDHBiTEJvXuLlwyDSbaJLF6NDZTnl+HiJCLEYme5cckYFqqICfl4c4
         oD/B4WA/eyHthD8LLZ3YtMgRYCq2hIGWqzfA11CygtQ3XL1Kva/P6tFtSqxxkEpUwP0K
         uXtMyGcKo8M4TYsodbPW6Ky6tvgOGUimNKB6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=LbEzhfMqerOPCE9MWjzXOnHWBdhnf16rmleBMKP8jdc=;
        b=Q5+cJ47Wua3EYubfJOrsdBxev7fchQWGPxnqG3Qt71yISvjiOWqstJB5uif8dmx+Bl
         7w5zcR1aWwLcgFYDBLm7oJikU3nCiB1XGeOQSM1LA8AI/NUEAMoxDBicao8BpEc0G1h6
         +YzCZY9+8ken5lItsIMPGnqme4Fwc+fZ5jrTGUwT084D0y7zYsUMYr2LbsMWt5pscxq5
         fsydTAKOh/gDSD3O9GcuuT6x3jeOapiG1QrF3Ydlk5HyADAbU6GYw2iVIT59uAh5dLvJ
         8+SaRFR8FR/WiZDe9q+8Bq1wWwV9/I2hEDDpIIyyJqt1QQaX7xgTBv4O/S1C8WHlK712
         c3CA==
X-Gm-Message-State: AOAM532E8ZaGrtsBMhU6v8RdHUzQCkdlyhtD92dbTzh2ITplLe9nn9qF
        ryJ+SdqOY6G0STM11vDkgYxc+AL35TZGm9/2PQEh9dm16Jf4V/G6XYkNrF76Ev9I3/dAoZ2jp0D
        fNyzQDcsb+X/remPcGJmag+cdXLhrlLhB2LhQ4alnQmEZQ3IA556S1htIX4rHlpujQWBCDMAkDQ
        3vaVc=
X-Google-Smtp-Source: ABdhPJwyHDqucTmc+UPue6crEsCcACbG7oveCwCT8Lmlx9Whda+foYFa/RGAxgbfWi+BG5EJ1rKALw==
X-Received: by 2002:a17:90a:5c82:: with SMTP id r2mr12186078pji.69.1605468412993;
        Sun, 15 Nov 2020 11:26:52 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:26:51 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>
Subject: [PATCH 00/17] lpfc: Update lpfc to revision 12.8.0.6
Date:   Sun, 15 Nov 2020 11:26:29 -0800
Message-Id: <20201115192646.12977-1-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007d441f05b42a3eed"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000007d441f05b42a3eed
Content-Transfer-Encoding: 8bit

Update lpfc to revision 12.8.0.6

This patch set contains several sets of recoding and refactoring.

A close look was taken at the driver to identify what was causing
continual small state machine errors as well other repeatitive issues.
Code review showed several things and this is the first set of changes
to address the deficiencies.

This set of changes addresses the following items:

Remote Port (node/ndlp) handling in the discovery engine:
  It was rather clear that the implementation of refcounting on the
  remote port node was improper.  A refcount going to zero didn't
  simply release the node. Instead other logic kicked into play. This
  then caused other code to be placed within the discovery engine to
  for node removal, ... if it was actually removed. What happened in
  many cases was the node structure continued to exist beyond the
  existence of the remote port. It was stored in a node list that
  could then be matched by re-discovery events. And it also caused
  multiple structures to exist on the node list for the same device.

  So this area has been significantly reworked to go back to a
  standard ref counting scheme, which of course meant that the base
  model for when and how to take references had to be re-addressed in
  the different code flows.
  
  And of course, once one thing starts working right, new issues were
  seen. This brought out inconsistencies on when the node is "freed"
  around transport devloss callbacks which led to stale pointer
  accesses which had to be addressed. Another example was NPIV, where
  it brought out a different handling for nodes on an NPIV vport vs
  the same nodes on a standard physical port. So this was corrected as
  well.

  While working on the above, it was rather clear that global host
  locks were taken for node-specific structure changes and the locking
  was too coarse. Discovery code was reworked to support a node-level
  lock.

Native SLI-4 WQE use:
  The other area that was rather ugly was sli-4 handling. Discovery
  and SCSI io paths were implemented as iocb's, which is a SLI-3
  construct.  The code then, when on SLI-4 hardware, converted to SLI-4
  WQEs to then talk to the hardware. However, the nvme path, which is
  only supported on SLI-4, was only implemnted with WQEs.  What it
  meant was: there were very subtle bugs creeping in as SLI-4 data
  structures didn't fully overlay on the SLI-3 structures; there was
  a lot of duplication of code in different areas; and with the
  duplication came differences and confusion.

  This patch set reorganizes the IO paths, which includes abort paths,
  into a formal division between SLI-3 and SLI-4. The basic style is a
  common routine is called by a code path, which identifies the hw
  type, and then vectors into SLI-type specific routines which deal
  specifically with iocbs or WQEs. With different command types also
  comes different completion handlers.  Although these changes look
  like a lot of change it is mostly a large refactoring. Old common
  layers that performed iocb-specific work was moved to SLI-3-specific
  routines, and routines were created for SLI-4. For SLI-4, a lot of
  code came from the nvme routines.

  The end result is the common routines, with SLI-4 being natively
  supported for ELS and SCSI & NVME initiator io paths.

The patches were cut against Martin's 5.11/scsi-queue tree


James Smart (17):
  lpfc: Rework remote port ref counting and node freeing
  lpfc: Rework locations of ndlp reference taking
  lpfc: Fix removal of scsi transport device get and put on dev
    structure
  lpfc: Fix refcounting around scsi and nvme transport apis
  lpfc: Rework remote port lock handling
  lpfc: Remove ndlp when a PLOGI/ADISC/PRLI/REG_RPI ultimately fails
  lpfc: Unsolicited ELS leaves node in incorrect state while dropping it
  lpfc: Fix NPIV discovery and Fabric Node detection
  lpfc: Fix NPIV Fabric Node reference counting
  lpfc: Refactor wqe structure definitions for common use
  lpfc: Enable common wqe_template support for both scsi and nvme
  lpfc: Enable common send_io interface for SCSI and NVME
  lpfc: convert scsi path to use common io submission path
  lpfc: convert scsi io completions to sli-3 and sli-4 handlers
  lpfc: Convert abort handling to sli-3 and sli-4 handlers
  lpfc: Update lpfc version to 12.8.0.6
  lpfc: Update changed file copyrights for 2020

 drivers/scsi/lpfc/lpfc.h           |    9 +-
 drivers/scsi/lpfc/lpfc_attr.c      |   19 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |   79 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   18 +-
 drivers/scsi/lpfc/lpfc_ct.c        |   81 +-
 drivers/scsi/lpfc/lpfc_debugfs.c   |    8 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   45 +-
 drivers/scsi/lpfc/lpfc_els.c       | 1285 +++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  754 +++++-----------
 drivers/scsi/lpfc/lpfc_hw4.h       |   12 +-
 drivers/scsi/lpfc/lpfc_init.c      |  121 ++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  215 ++---
 drivers/scsi/lpfc/lpfc_nvme.c      |  326 ++-----
 drivers/scsi/lpfc/lpfc_nvme.h      |    4 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |   60 +-
 drivers/scsi/lpfc/lpfc_scsi.c      | 1133 ++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli.c       |  659 +++++++++-----
 drivers/scsi/lpfc/lpfc_sli.h       |    7 +-
 drivers/scsi/lpfc/lpfc_version.h   |    4 +-
 drivers/scsi/lpfc/lpfc_vport.c     |  128 +--
 20 files changed, 2719 insertions(+), 2248 deletions(-)

-- 
2.26.2


--0000000000007d441f05b42a3eed
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgHh9/dCWIA/ZxYQza
KNG0l9RZz58iibH8emqcVG9NcYEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNjUzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABZ1QZixL7ctsGW1XjYqo2MW0bpzMpbpuGre
ygksmu9PPlcELB7Qe4uYPq+Kd1HKqYfyXXDkYdwKOKAfs7ZWv0M9jppb9b+sn6xubC3aR81WJ7Qn
ehrDCa0wqQ/PSCaKnaRZ8JRllKDG7umnvcWSQybHatmlWOK2rt/PTbHjMB78qVMZfSJPwitvc09f
4UJc/4tGNc4LiFiktVpJdUGuSHA8tjG7mk3bCtTGTqjxiP2bEB84u9MCPyHUHJyCNH+q3IKQ+6X2
ItSxPWYxZ7xvBDIyv+PsL73V1M6U6Y+XZVq9A3T8MMEp79hTOKdXLcK7DXP1Rb2FbaOCRkCUJL44
Idk=
--0000000000007d441f05b42a3eed--
