Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D5FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiDLXhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbiDLXcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:47 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3836E7C79C
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:16 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f3so300346pfe.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uMgL2cDpyTLu1ZaQy4VHaI57pjl/M8wUWyaip/pbBtQ=;
        b=eUQ+6w5sjYOGbYTK/xx1LGYyiS1oUJd1FlkRr2z4APBd6Ik+dJGafzOZHd9NFSe5gg
         x0GeaDlCgy9MFbyJUaAU8mjUXSomKj5CWjAUP7xG/JSIatirFHVjYbV5YJvZRO/4Nlf8
         JJUARQmGRKiqeBr6OrQSni+Fhp/K3pfqTo87w2sv+z/ASbq64xSyeCHyRyBsUxULm3ME
         FiX25qAb6BkjVrY/SVK7nUsvUrB2vytNUYXFbDq1VO5XimTDxhlacH08ibWzJQBxqTXk
         fNl2Uebeek4KpTZmD/uvWLR6ngm22K3SAUN5euSIQUCmzBIaVkiQUv/Zzf2lXpikwP7C
         aPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uMgL2cDpyTLu1ZaQy4VHaI57pjl/M8wUWyaip/pbBtQ=;
        b=vRBN/uA9jahlF2vXyZtQ3mohH+8mo9UnhgdkOOQMjCqyfvmLtiDeZOEQYDiDT6NiBO
         cTI2dsKwLS4Il+2WNU3lARebsBetHDKEcDWwh0cvz2wSddqyqn09p7p/wMUUwi/rN5us
         36ZysyO5HOyBY7npiaR6uQ8lLQpWqHNRXpZol5k27PMbhzdpOGHrikAptb/ryiG/fom4
         HiIAuhxA0NqIfv5pY4j/Kqh/WEZDd/MUW3Jbs+oB8S5WCJRWJsQ3eze7PVvHuOez4rTY
         crUZiq0YI84uCwbNKrxbtS0a2RxYFAAwDqw/Ex4Fhso44cy0KqCrsJCmZUnZyURDNLUj
         RcVg==
X-Gm-Message-State: AOAM53090MdLrqKARQEEtA56vtnR8gPf/RDEphIrO2/n5ihiTwrB/frm
        yMrMnGi1yqddr9mv5x5wF8m+2TpJFOc=
X-Google-Smtp-Source: ABdhPJwIj0jNxa6VC51xYmZpZACwQNsPINmWNI931YUVxhpL6vAVvp41TLjxV/RDd9wmX1VnAFpkuw==
X-Received: by 2002:a63:3246:0:b0:39d:9649:e07c with SMTP id y67-20020a633246000000b0039d9649e07cmr4443406pgy.261.1649802015385;
        Tue, 12 Apr 2022 15:20:15 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/26] lpfc: Update lpfc to revision 14.2.0.2
Date:   Tue, 12 Apr 2022 15:19:42 -0700
Message-Id: <20220412222008.126521-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.2

This patch set a bunch of small fixes, several discovery fixes,
a few logging enhancements, and a rework patch to get rid of
overloaded structure fields.

The patches were cut against Martin's 5.18/scsi-queue tree

James Smart (26):
  lpfc: Tweak message log categories for ELS/FDMI/NVME Rescan
  lpfc: Move cfg_log_verbose check before calling lpfc_dmp_dbg
  lpfc: Fix diagnostic fw logging after a function reset
  lpfc: Zero SLI4 fcp_cmnd buffer's fcpCntl0 field
  lpfc: Requeue SCSI I/O to upper layer when fw reports link down
  lpfc: Fix SCSI I/O completion and abort handler deadlock
  lpfc: Clear fabric topology flag before initiating a new FLOGI
  lpfc: Fix null pointer dereference after failing to issue FLOGI and
    PLOGI
  lpfc: Protect memory leak for NPIV ports sending PLOGI_RJT
  lpfc: Update fc_prli_sent outstanding only after guaranteed IOCB
    submit
  lpfc: Transition to NPR state upon LOGO cmpl if link down or aborted
  lpfc: Remove unnecessary NULL pointer assignment for ELS_RDF path
  lpfc: Move MI module parameter check to handle dynamic disable
  lpfc: Correct CRC32 calculation for congestion stats
  lpfc: Fix call trace observed during I/O with CMF enabled
  lpfc: Revise FDMI reporting of supported port speed for trunk groups
  lpfc: Remove false FDMI NVME FC-4 support for NPIV ports
  lpfc: Register for Application Services FC-4 type in Fabric topology
  lpfc: Introduce FC_RSCN_MEMENTO flag for tracking post RSCN completion
  lpfc: Fix field overload in lpfc_iocbq data structure
  lpfc: Refactor cleanup of mailbox commands
  lpfc: Change FA-PWWN detection methodology
  lpfc: Update stat accounting for READ_STATUS mbox command
  lpfc: Expand setting ELS_ID field in ELS_REQUEST64_WQE
  lpfc: Update lpfc version to 14.2.0.2
  lpfc: Copyright updates for 14.2.0.2 patches

 drivers/scsi/lpfc/lpfc.h           |   6 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  55 ++-
 drivers/scsi/lpfc/lpfc_bsg.c       |  79 ++--
 drivers/scsi/lpfc/lpfc_crtn.h      |   4 +-
 drivers/scsi/lpfc/lpfc_ct.c        | 252 ++++++-----
 drivers/scsi/lpfc/lpfc_els.c       | 644 ++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 143 +++----
 drivers/scsi/lpfc/lpfc_hw.h        |  75 ++--
 drivers/scsi/lpfc/lpfc_hw4.h       |  17 +-
 drivers/scsi/lpfc/lpfc_init.c      | 209 +++++-----
 drivers/scsi/lpfc/lpfc_logmsg.h    |   8 +-
 drivers/scsi/lpfc/lpfc_mbox.c      | 203 +++++----
 drivers/scsi/lpfc/lpfc_nportdisc.c |  64 ++-
 drivers/scsi/lpfc/lpfc_nvme.c      |  35 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |  73 ++--
 drivers/scsi/lpfc/lpfc_scsi.c      |  55 ++-
 drivers/scsi/lpfc/lpfc_sli.c       | 226 +++++-----
 drivers/scsi/lpfc/lpfc_sli.h       |  34 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |   3 +
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |  31 +-
 21 files changed, 1112 insertions(+), 1106 deletions(-)

-- 
2.26.2

