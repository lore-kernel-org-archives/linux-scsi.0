Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F83C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B95A72310D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgLVKNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgLVKNh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:13:37 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9049BC061248
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:12:39 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id v1so1073462pjr.2
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1999FWFeqP7vEJX0TRPeYf4OopJolKu3V8ki8/vt7U0=;
        b=HKrc4uWhjw6LWyGr4jsSAsjLC5c6gsSfDngY1Nt/4euiU+mudBlNKuFbtLicZS4jld
         e6d7Rv22t/Mlp0U0zJulgAECGWc63/t3g61odRIkEeYKnCpCPb3upzxcrHuk3agPDr/g
         ZSIbsKYhc8OEbF4dvCbDaAY2KrGHgN5D7Vgq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=1999FWFeqP7vEJX0TRPeYf4OopJolKu3V8ki8/vt7U0=;
        b=ZC33ueFdP/Ggnv1T7GUsnZ8XOfSUkBONIN0Hbh5iZBh/GnC0qdLe/RcoDFJtrDCyf8
         mrhu2M/eOKAU/6ab+mlSrqLn6oT+kL8XHOPWsP5KANJvs/o0FOP4eCCeotqnC/UDSznl
         hU/Y8o7PoIlMCriQe1sOAIWxKOSiUI27InZy7bqopowRWYPa++0OT8qiI9s29bGHtkg7
         ljAPxqVhxZSEZocbdTG/viSEatVuKyMBnakEuYON8uhmcmqyjtyAI0C6l+u8BhTMmEyE
         RqPcIR17tC4rtjLoFE6hlxFjR241bIurHDh18FQnP2xmkFPAgSQHDqFK/UkgwA/zaie0
         ZGwQ==
X-Gm-Message-State: AOAM532INMn3Hqdl6D8OMF8JunCnOXhaGjRSc1iDJOf2xoHVbuQ64tE5
        1HdfKqAUZIGwMfCz3fbbYipqpPrDspLrSs8YbjEUEx0Xt8B+SPq2VISRE0Eca9t0roPP8fGL+B4
        fOydaz9e8RpYaunb4s4550ZlM8KKcguZi2DugPD3BiHKIBZfpk3Mx+IZoB4lSkQRNg+e006Mkc4
        7nlqt4S0AB
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJwbaSL/VOSzkwEmYRYk2yAN6Er9ei5rEr4bxm+2haTenxJrEdkV2WD2RtKTAbXBrsUKwpfmkg==
X-Received: by 2002:a17:90a:b118:: with SMTP id z24mr21116528pjq.14.1608631957115;
        Tue, 22 Dec 2020 02:12:37 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:12:36 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 06/24] mpi3mr: add support of event handling part-1
Date:   Tue, 22 Dec 2020 15:41:38 +0530
Message-Id: <20201222101156.98308-7-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000732d0805b70ad0ea"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000732d0805b70ad0ea
Content-Type: text/plain; charset="US-ASCII"

Firmware can report various MPI Events.
Support for certain Events (as listed below) are enabled in the driver
and their processing in driver is covered in this patch.

MPI3_EVENT_DEVICE_ADDED
MPI3_EVENT_DEVICE_INFO_CHANGED
MPI3_EVENT_DEVICE_STATUS_CHANGE
MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE
MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST
MPI3_EVENT_SAS_DISCOVERY
MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR

Key support in this patch is device add/removal.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi/mpi30_api.h  |    2 +
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h | 2721 ++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h  |   46 +
 drivers/scsi/mpi3mr/mpi3mr.h         |  195 ++
 drivers/scsi/mpi3mr/mpi3mr_fw.c      |  177 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c      | 1452 ++++++++++++++
 6 files changed, 4592 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_sas.h

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_api.h b/drivers/scsi/mpi3mr/mpi/mpi30_api.h
index ca07387536d3..7bdd5aeb23be 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_api.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_api.h
@@ -14,8 +14,10 @@
 
 #include "mpi30_type.h"
 #include "mpi30_transport.h"
+#include "mpi30_cnfg.h"
 #include "mpi30_image.h"
 #include "mpi30_init.h"
 #include "mpi30_ioc.h"
+#include "mpi30_sas.h"
 
 #endif  /* MPI30_API_H */
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
new file mode 100644
index 000000000000..3badb1bb85b1
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -0,0 +1,2721 @@
+/*
+ *  Copyright 2017-2020 Broadcom Inc. All rights reserved.
+ *
+ *           Name: mpi30_cnfg.h
+ *    Description: Contains definitions for Configuration messages and pages
+ *  Creation Date: 03/15/2017
+ *        Version: 03.00.00
+ */
+#ifndef MPI30_CNFG_H
+#define MPI30_CNFG_H     1
+
+/*****************************************************************************
+ *              Configuration Page Types                                     *
+ ****************************************************************************/
+#define MPI3_CONFIG_PAGETYPE_IO_UNIT                    (0x00)
+#define MPI3_CONFIG_PAGETYPE_MANUFACTURING              (0x01)
+#define MPI3_CONFIG_PAGETYPE_IOC                        (0x02)
+#define MPI3_CONFIG_PAGETYPE_UEFI_BSD                   (0x03)
+#define MPI3_CONFIG_PAGETYPE_SECURITY                   (0x04)
+#define MPI3_CONFIG_PAGETYPE_ENCLOSURE                  (0x11)
+#define MPI3_CONFIG_PAGETYPE_DEVICE                     (0x12)
+#define MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT                (0x20)
+#define MPI3_CONFIG_PAGETYPE_SAS_EXPANDER               (0x21)
+#define MPI3_CONFIG_PAGETYPE_SAS_PHY                    (0x23)
+#define MPI3_CONFIG_PAGETYPE_SAS_PORT                   (0x24)
+#define MPI3_CONFIG_PAGETYPE_PCIE_IO_UNIT               (0x30)
+#define MPI3_CONFIG_PAGETYPE_PCIE_SWITCH                (0x31)
+#define MPI3_CONFIG_PAGETYPE_PCIE_LINK                  (0x33)
+
+/*****************************************************************************
+ *              Configuration Page Attributes                                *
+ ****************************************************************************/
+#define MPI3_CONFIG_PAGEATTR_MASK                       (0xF0)
+#define MPI3_CONFIG_PAGEATTR_READ_ONLY                  (0x00)
+#define MPI3_CONFIG_PAGEATTR_CHANGEABLE                 (0x10)
+#define MPI3_CONFIG_PAGEATTR_PERSISTENT                 (0x20)
+
+/*****************************************************************************
+ *              Configuration Page Actions                                   *
+ ****************************************************************************/
+#define MPI3_CONFIG_ACTION_PAGE_HEADER                  (0x00)
+#define MPI3_CONFIG_ACTION_READ_DEFAULT                 (0x01)
+#define MPI3_CONFIG_ACTION_READ_CURRENT                 (0x02)
+#define MPI3_CONFIG_ACTION_WRITE_CURRENT                (0x03)
+#define MPI3_CONFIG_ACTION_READ_PERSISTENT              (0x04)
+#define MPI3_CONFIG_ACTION_WRITE_PERSISTENT             (0x05)
+
+/*****************************************************************************
+ *              Configuration Page Addressing                                *
+ ****************************************************************************/
+
+/**** Device PageAddress Format ****/
+#define MPI3_DEVICE_PGAD_FORM_MASK                      (0xF0000000)
+#define MPI3_DEVICE_PGAD_FORM_GET_NEXT_HANDLE           (0x00000000)
+#define MPI3_DEVICE_PGAD_FORM_HANDLE                    (0x20000000)
+#define MPI3_DEVICE_PGAD_HANDLE_MASK                    (0x0000FFFF)
+
+/**** SAS Expander PageAddress Format ****/
+#define MPI3_SAS_EXPAND_PGAD_FORM_MASK                  (0xF0000000)
+#define MPI3_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE       (0x00000000)
+#define MPI3_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM        (0x10000000)
+#define MPI3_SAS_EXPAND_PGAD_FORM_HANDLE                (0x20000000)
+#define MPI3_SAS_EXPAND_PGAD_PHYNUM_MASK                (0x00FF0000)
+#define MPI3_SAS_EXPAND_PGAD_PHYNUM_SHIFT               (16)
+#define MPI3_SAS_EXPAND_PGAD_HANDLE_MASK                (0x0000FFFF)
+
+/**** SAS Phy PageAddress Format ****/
+#define MPI3_SAS_PHY_PGAD_FORM_MASK                     (0xF0000000)
+#define MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER               (0x00000000)
+#define MPI3_SAS_PHY_PGAD_PHY_NUMBER_MASK               (0x000000FF)
+
+/**** SAS Port PageAddress Format ****/
+#define MPI3_SASPORT_PGAD_FORM_MASK                     (0xF0000000)
+#define MPI3_SASPORT_PGAD_FORM_GET_NEXT_PORT            (0x00000000)
+#define MPI3_SASPORT_PGAD_FORM_PORT_NUM                 (0x10000000)
+#define MPI3_SASPORT_PGAD_PORT_NUMBER_MASK              (0x000000FF)
+
+/**** Enclosure PageAddress Format ****/
+#define MPI3_ENCLOS_PGAD_FORM_MASK                      (0xF0000000)
+#define MPI3_ENCLOS_PGAD_FORM_GET_NEXT_HANDLE           (0x00000000)
+#define MPI3_ENCLOS_PGAD_FORM_HANDLE                    (0x10000000)
+#define MPI3_ENCLOS_PGAD_HANDLE_MASK                    (0x0000FFFF)
+
+/**** PCIe Switch PageAddress Format ****/
+#define MPI3_PCIE_SWITCH_PGAD_FORM_MASK                 (0xF0000000)
+#define MPI3_PCIE_SWITCH_PGAD_FORM_GET_NEXT_HANDLE      (0x00000000)
+#define MPI3_PCIE_SWITCH_PGAD_FORM_HANDLE_PORT_NUM      (0x10000000)
+#define MPI3_PCIE_SWITCH_PGAD_FORM_HANDLE               (0x20000000)
+#define MPI3_PCIE_SWITCH_PGAD_PORTNUM_MASK              (0x00FF0000)
+#define MPI3_PCIE_SWITCH_PGAD_PORTNUM_SHIFT             (16)
+#define MPI3_PCIE_SWITCH_PGAD_HANDLE_MASK               (0x0000FFFF)
+
+/**** PCIe Link PageAddress Format ****/
+#define MPI3_PCIE_LINK_PGAD_FORM_MASK                   (0xF0000000)
+#define MPI3_PCIE_LINK_PGAD_FORM_GET_NEXT_LINK          (0x00000000)
+#define MPI3_PCIE_LINK_PGAD_FORM_LINK_NUM               (0x10000000)
+#define MPI3_PCIE_LINK_PGAD_LINKNUM_MASK                (0x000000FF)
+
+/**** Security PageAddress Format ****/
+#define MPI3_SECURITY_PGAD_FORM_MASK                    (0xF0000000)
+#define MPI3_SECURITY_PGAD_FORM_GET_NEXT_SLOT           (0x00000000)
+#define MPI3_SECURITY_PGAD_FORM_SOT_NUM                 (0x10000000)
+#define MPI3_SECURITY_PGAD_SLOT_GROUP_MASK              (0x0000FF00)
+#define MPI3_SECURITY_PGAD_SLOT_MASK                    (0x000000FF)
+
+/*****************************************************************************
+ *              Configuration Request Message                                *
+ ****************************************************************************/
+typedef struct _MPI3_CONFIG_REQUEST {
+    U16             HostTag;                            /* 0x00 */
+    U8              IOCUseOnly02;                       /* 0x02 */
+    U8              Function;                           /* 0x03 */
+    U16             IOCUseOnly04;                       /* 0x04 */
+    U8              IOCUseOnly06;                       /* 0x06 */
+    U8              MsgFlags;                           /* 0x07 */
+    U16             ChangeCount;                        /* 0x08 */
+    U16             Reserved0A;                         /* 0x0A */
+    U8              PageVersion;                        /* 0x0C */
+    U8              PageNumber;                         /* 0x0D */
+    U8              PageType;                           /* 0x0E */
+    U8              Action;                             /* 0x0F */
+    U32             PageAddress;                        /* 0x10 */
+    U16             PageLength;                         /* 0x14 */
+    U16             Reserved16;                         /* 0x16 */
+    U32             Reserved18[2];                      /* 0x18 */
+    MPI3_SGE_UNION  SGL;                                /* 0x20 */
+} MPI3_CONFIG_REQUEST, MPI3_POINTER PTR_MPI3_CONFIG_REQUEST,
+  Mpi3ConfigRequest_t, MPI3_POINTER pMpi3ConfigRequest_t;
+
+/*****************************************************************************
+ *              Configuration Pages                                          *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              Configuration Page Header                                    *
+ ****************************************************************************/
+typedef struct _MPI3_CONFIG_PAGE_HEADER {
+    U8              PageVersion;                        /* 0x00 */
+    U8              Reserved01;                         /* 0x01 */
+    U8              PageNumber;                         /* 0x02 */
+    U8              PageAttribute;                      /* 0x03 */
+    U16             PageLength;                         /* 0x04 */
+    U8              PageType;                           /* 0x06 */
+    U8              Reserved07;                         /* 0x07 */
+} MPI3_CONFIG_PAGE_HEADER, MPI3_POINTER PTR_MPI3_CONFIG_PAGE_HEADER,
+  Mpi3ConfigPageHeader_t, MPI3_POINTER pMpi3ConfigPageHeader_t;
+
+/*****************************************************************************
+ *              Common definitions used by Configuration Pages           *
+ ****************************************************************************/
+
+/**** Defines for Negotiated Link Rates ****/
+#define MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK             (0xF0)
+#define MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT            (4)
+#define MPI3_SAS_NEG_LINK_RATE_PHYSICAL_MASK            (0x0F)
+#define MPI3_SAS_NEG_LINK_RATE_UNKNOWN_LINK_RATE        (0x00)
+#define MPI3_SAS_NEG_LINK_RATE_PHY_DISABLED             (0x01)
+#define MPI3_SAS_NEG_LINK_RATE_NEGOTIATION_FAILED       (0x02)
+#define MPI3_SAS_NEG_LINK_RATE_SATA_OOB_COMPLETE        (0x03)
+#define MPI3_SAS_NEG_LINK_RATE_PORT_SELECTOR            (0x04)
+#define MPI3_SAS_NEG_LINK_RATE_SMP_RESET_IN_PROGRESS    (0x05)
+#define MPI3_SAS_NEG_LINK_RATE_UNSUPPORTED_PHY          (0x06)
+#define MPI3_SAS_NEG_LINK_RATE_1_5                      (0x08)
+#define MPI3_SAS_NEG_LINK_RATE_3_0                      (0x09)
+#define MPI3_SAS_NEG_LINK_RATE_6_0                      (0x0A)
+#define MPI3_SAS_NEG_LINK_RATE_12_0                     (0x0B)
+#define MPI3_SAS_NEG_LINK_RATE_22_5                     (0x0C)
+
+/**** Defines for the AttachedPhyInfo field ****/
+#define MPI3_SAS_APHYINFO_INSIDE_ZPSDS_PERSISTENT       (0x00000040)
+#define MPI3_SAS_APHYINFO_REQUESTED_INSIDE_ZPSDS        (0x00000020)
+#define MPI3_SAS_APHYINFO_BREAK_REPLY_CAPABLE           (0x00000010)
+
+#define MPI3_SAS_APHYINFO_REASON_MASK                   (0x0000000F)
+#define MPI3_SAS_APHYINFO_REASON_UNKNOWN                (0x00000000)
+#define MPI3_SAS_APHYINFO_REASON_POWER_ON               (0x00000001)
+#define MPI3_SAS_APHYINFO_REASON_HARD_RESET             (0x00000002)
+#define MPI3_SAS_APHYINFO_REASON_SMP_PHY_CONTROL        (0x00000003)
+#define MPI3_SAS_APHYINFO_REASON_LOSS_OF_SYNC           (0x00000004)
+#define MPI3_SAS_APHYINFO_REASON_MULTIPLEXING_SEQ       (0x00000005)
+#define MPI3_SAS_APHYINFO_REASON_IT_NEXUS_LOSS_TIMER    (0x00000006)
+#define MPI3_SAS_APHYINFO_REASON_BREAK_TIMEOUT          (0x00000007)
+#define MPI3_SAS_APHYINFO_REASON_PHY_TEST_STOPPED       (0x00000008)
+#define MPI3_SAS_APHYINFO_REASON_EXP_REDUCED_FUNC       (0x00000009)
+
+/**** Defines for the PhyInfo field ****/
+#define MPI3_SAS_PHYINFO_STATUS_MASK                    (0xC0000000)
+#define MPI3_SAS_PHYINFO_STATUS_SHIFT                   (30)
+#define MPI3_SAS_PHYINFO_STATUS_ACCESSIBLE              (0x00000000)
+#define MPI3_SAS_PHYINFO_STATUS_NOT_EXIST               (0x40000000)
+#define MPI3_SAS_PHYINFO_STATUS_VACANT                  (0x80000000)
+
+#define MPI3_SAS_PHYINFO_PHY_POWER_CONDITION_MASK       (0x18000000)
+#define MPI3_SAS_PHYINFO_PHY_POWER_CONDITION_ACTIVE     (0x00000000)
+#define MPI3_SAS_PHYINFO_PHY_POWER_CONDITION_PARTIAL    (0x08000000)
+#define MPI3_SAS_PHYINFO_PHY_POWER_CONDITION_SLUMBER    (0x10000000)
+
+#define MPI3_SAS_PHYINFO_REASON_MASK                    (0x000F0000)
+#define MPI3_SAS_PHYINFO_REASON_UNKNOWN                 (0x00000000)
+#define MPI3_SAS_PHYINFO_REASON_POWER_ON                (0x00010000)
+#define MPI3_SAS_PHYINFO_REASON_HARD_RESET              (0x00020000)
+#define MPI3_SAS_PHYINFO_REASON_SMP_PHY_CONTROL         (0x00030000)
+#define MPI3_SAS_PHYINFO_REASON_LOSS_OF_SYNC            (0x00040000)
+#define MPI3_SAS_PHYINFO_REASON_MULTIPLEXING_SEQ        (0x00050000)
+#define MPI3_SAS_PHYINFO_REASON_IT_NEXUS_LOSS_TIMER     (0x00060000)
+#define MPI3_SAS_PHYINFO_REASON_BREAK_TIMEOUT           (0x00070000)
+#define MPI3_SAS_PHYINFO_REASON_PHY_TEST_STOPPED        (0x00080000)
+#define MPI3_SAS_PHYINFO_REASON_EXP_REDUCED_FUNC        (0x00090000)
+
+#define MPI3_SAS_PHYINFO_SATA_PORT_ACTIVE               (0x00004000)
+#define MPI3_SAS_PHYINFO_SATA_PORT_SELECTOR_PRESENT     (0x00002000)
+#define MPI3_SAS_PHYINFO_VIRTUAL_PHY                    (0x00001000)
+
+#define MPI3_SAS_PHYINFO_PARTIAL_PATHWAY_TIME_MASK      (0x00000F00)
+#define MPI3_SAS_PHYINFO_PARTIAL_PATHWAY_TIME_SHIFT     (8)
+
+#define MPI3_SAS_PHYINFO_ROUTING_ATTRIBUTE_MASK         (0x000000F0)
+#define MPI3_SAS_PHYINFO_ROUTING_ATTRIBUTE_DIRECT       (0x00000000)
+#define MPI3_SAS_PHYINFO_ROUTING_ATTRIBUTE_SUBTRACTIVE  (0x00000010)
+#define MPI3_SAS_PHYINFO_ROUTING_ATTRIBUTE_TABLE        (0x00000020)
+
+/**** Defines for the ProgrammedLinkRate field ****/
+#define MPI3_SAS_PRATE_MAX_RATE_MASK                    (0xF0)
+#define MPI3_SAS_PRATE_MAX_RATE_NOT_PROGRAMMABLE        (0x00)
+#define MPI3_SAS_PRATE_MAX_RATE_1_5                     (0x80)
+#define MPI3_SAS_PRATE_MAX_RATE_3_0                     (0x90)
+#define MPI3_SAS_PRATE_MAX_RATE_6_0                     (0xA0)
+#define MPI3_SAS_PRATE_MAX_RATE_12_0                    (0xB0)
+#define MPI3_SAS_PRATE_MAX_RATE_22_5                    (0xC0)
+#define MPI3_SAS_PRATE_MIN_RATE_MASK                    (0x0F)
+#define MPI3_SAS_PRATE_MIN_RATE_NOT_PROGRAMMABLE        (0x00)
+#define MPI3_SAS_PRATE_MIN_RATE_1_5                     (0x08)
+#define MPI3_SAS_PRATE_MIN_RATE_3_0                     (0x09)
+#define MPI3_SAS_PRATE_MIN_RATE_6_0                     (0x0A)
+#define MPI3_SAS_PRATE_MIN_RATE_12_0                    (0x0B)
+#define MPI3_SAS_PRATE_MIN_RATE_22_5                    (0x0C)
+
+/**** Defines for the HwLinkRate field ****/
+#define MPI3_SAS_HWRATE_MAX_RATE_MASK                   (0xF0)
+#define MPI3_SAS_HWRATE_MAX_RATE_1_5                    (0x80)
+#define MPI3_SAS_HWRATE_MAX_RATE_3_0                    (0x90)
+#define MPI3_SAS_HWRATE_MAX_RATE_6_0                    (0xA0)
+#define MPI3_SAS_HWRATE_MAX_RATE_12_0                   (0xB0)
+#define MPI3_SAS_HWRATE_MAX_RATE_22_5                   (0xC0)
+#define MPI3_SAS_HWRATE_MIN_RATE_MASK                   (0x0F)
+#define MPI3_SAS_HWRATE_MIN_RATE_1_5                    (0x08)
+#define MPI3_SAS_HWRATE_MIN_RATE_3_0                    (0x09)
+#define MPI3_SAS_HWRATE_MIN_RATE_6_0                    (0x0A)
+#define MPI3_SAS_HWRATE_MIN_RATE_12_0                   (0x0B)
+#define MPI3_SAS_HWRATE_MIN_RATE_22_5                   (0x0C)
+
+/**** Defines for the Slot field ****/
+#define MPI3_SLOT_INVALID                           (0xFFFF)
+
+/**** Defines for the SlotIndex field ****/
+#define MPI3_SLOT_INDEX_INVALID                     (0xFFFF)
+
+/*****************************************************************************
+ *              Manufacturing Configuration Pages                            *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              Manufacturing Page 0                                         *
+ ****************************************************************************/
+typedef struct _MPI3_MAN_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                 /* 0x00 */
+    U8                              ChipRevision[8];        /* 0x08 */
+    U8                              ChipName[32];           /* 0x10 */
+    U8                              BoardName[32];          /* 0x30 */
+    U8                              BoardAssembly[32];      /* 0x50 */
+    U8                              BoardTracerNumber[32];  /* 0x70 */
+    U32                             BoardPower;             /* 0x90 */
+    U32                             Reserved94;             /* 0x94 */
+    U32                             Reserved98;             /* 0x98 */
+    U8                              OEM;                    /* 0x9C */
+    U8                              SubOEM;                 /* 0x9D */
+    U16                             Reserved9E;             /* 0x9E */
+    U8                              BoardMfgDay;            /* 0xA0 */
+    U8                              BoardMfgMonth;          /* 0xA1 */
+    U16                             BoardMfgYear;           /* 0xA2 */
+    U8                              BoardReworkDay;         /* 0xA4 */
+    U8                              BoardReworkMonth;       /* 0xA5 */
+    U16                             BoardReworkYear;        /* 0xA6 */
+    U64                             BoardRevision;          /* 0xA8 */
+    U8                              EPackFRU[16];           /* 0xB0 */
+    U8                              ProductName[256];       /* 0xC0 */
+} MPI3_MAN_PAGE0, MPI3_POINTER PTR_MPI3_MAN_PAGE0,
+  Mpi3ManPage0_t, MPI3_POINTER pMpi3ManPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN0_PAGEVERSION       (0x00)
+
+/*****************************************************************************
+ *              Manufacturing Page 1                                         *
+ ****************************************************************************/
+
+#define MPI3_MAN1_VPD_SIZE                                   (512)
+
+typedef struct _MPI3_MAN_PAGE1 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                  /* 0x00 */
+    U32                             Reserved08[2];           /* 0x08 */
+    U8                              VPD[MPI3_MAN1_VPD_SIZE]; /* 0x10 */
+} MPI3_MAN_PAGE1, MPI3_POINTER PTR_MPI3_MAN_PAGE1,
+  Mpi3ManPage1_t, MPI3_POINTER pMpi3ManPage1_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN1_PAGEVERSION                                 (0x00)
+
+/*****************************************************************************
+ *              Manufacturing Page 5                                         *
+ ****************************************************************************/
+typedef struct _MPI3_MAN5_PHY_ENTRY {
+    U64     IOC_WWID;                                       /* 0x00 */
+    U64     DeviceName;                                     /* 0x08 */
+    U64     SATA_WWID;                                      /* 0x10 */
+} MPI3_MAN5_PHY_ENTRY, MPI3_POINTER PTR_MPI3_MAN5_PHY_ENTRY,
+  Mpi3Man5PhyEntry_t, MPI3_POINTER pMpi3Man5PhyEntry_t;
+
+#ifndef MPI3_MAN5_PHY_MAX
+#define MPI3_MAN5_PHY_MAX                                   (1)
+#endif  /* MPI3_MAN5_PHY_MAX */
+
+typedef struct _MPI3_MAN_PAGE5 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                 /* 0x00 */
+    U8                              NumPhys;                /* 0x08 */
+    U8                              Reserved09[3];          /* 0x09 */
+    U32                             Reserved0C;             /* 0x0C */
+    MPI3_MAN5_PHY_ENTRY             Phy[MPI3_MAN5_PHY_MAX]; /* 0x10 */
+} MPI3_MAN_PAGE5, MPI3_POINTER PTR_MPI3_MAN_PAGE5,
+  Mpi3ManPage5_t, MPI3_POINTER pMpi3ManPage5_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN5_PAGEVERSION                                (0x00)
+
+/*****************************************************************************
+ *              Manufacturing Page 6                                         *
+ ****************************************************************************/
+typedef struct _MPI3_MAN6_GPIO_ENTRY {
+    U8      FunctionCode;                                                     /* 0x00 */
+    U8      Reserved01;                                                       /* 0x01 */
+    U16     Flags;                                                            /* 0x02 */
+    U8      Param1;                                                           /* 0x04 */
+    U8      Param2;                                                           /* 0x05 */
+    U16     Reserved06;                                                       /* 0x06 */
+    U32     Param3;                                                           /* 0x08 */
+} MPI3_MAN6_GPIO_ENTRY, MPI3_POINTER PTR_MPI3_MAN6_GPIO_ENTRY,
+  Mpi3Man6GpioEntry_t, MPI3_POINTER pMpi3Man6GpioEntry_t;
+
+/**** Defines for the FunctionCode field ****/
+#define MPI3_MAN6_GPIO_FUNCTION_GENERIC                                       (0x00)
+#define MPI3_MAN6_GPIO_FUNCTION_ALTERNATE                                     (0x01)
+#define MPI3_MAN6_GPIO_FUNCTION_EXT_INTERRUPT                                 (0x02)
+#define MPI3_MAN6_GPIO_FUNCTION_GLOBAL_ACTIVITY                               (0x03)
+#define MPI3_MAN6_GPIO_FUNCTION_OVER_TEMPERATURE                              (0x04)
+#define MPI3_MAN6_GPIO_FUNCTION_PORT_STATUS_GREEN                             (0x05)
+#define MPI3_MAN6_GPIO_FUNCTION_PORT_STATUS_YELLOW                            (0x06)
+#define MPI3_MAN6_GPIO_FUNCTION_CABLE_MANAGEMENT                              (0x07)
+#define MPI3_MAN6_GPIO_FUNCTION_BKPLANE_MGMT_TYPE                             (0x08)
+#define MPI3_MAN6_GPIO_FUNCTION_ISTWI_MUX_RESET                               (0x09)
+#define MPI3_MAN6_GPIO_FUNCTION_ISTWI_RESET                                   (0x0A)
+#define MPI3_MAN6_GPIO_FUNCTION_BACKEND_PCIE_RESET                            (0x0B)
+#define MPI3_MAN6_GPIO_FUNCTION_GLOBAL_FAULT                                  (0x0C)
+#define MPI3_MAN6_GPIO_FUNCTION_EPACK_ATTN                                    (0x0D)
+#define MPI3_MAN6_GPIO_FUNCTION_EPACK_ONLINE                                  (0x0E)
+#define MPI3_MAN6_GPIO_FUNCTION_EPACK_FAULT                                   (0x0F)
+#define MPI3_MAN6_GPIO_FUNCTION_CTRL_TYPE                                     (0x10)
+#define MPI3_MAN6_GPIO_FUNCTION_LICENSE                                       (0x11)
+#define MPI3_MAN6_GPIO_FUNCTION_REFCLK_CONTROL                                (0x12)
+
+/**** Defines for Param1 (Flags) when FunctionCode is EXT_INTERRUPT ****/
+#define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_SOURCE_MASK                        (0xF0)
+#define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_SOURCE_GENERIC                     (0x00)
+#define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_SOURCE_CABLE_MGMT                  (0x10)
+#define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_SOURCE_ACTIVE_CABLE_OVERCURRENT    (0x20)
+
+#define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_TRIGGER_MASK                       (0x01)
+#define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_TRIGGER_EDGE                       (0x00)
+#define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_TRIGGER_LEVEL                      (0x01)
+
+/**** Defines for Param1 (PHY STATE) when FunctionCode is PORT_STATUS_GREEN ****/
+#define MPI3_MAN6_GPIO_PORT_GREEN_PARAM1_PHY_STATUS_ALL_UP                    (0x00)
+#define MPI3_MAN6_GPIO_PORT_GREEN_PARAM1_PHY_STATUS_ONE_OR_MORE_UP            (0x01)
+
+/**** Defines for Param1 (INTERFACE_SIGNAL) when FunctionCode is CABLE_MANAGEMENT ****/
+#define MPI3_MAN6_GPIO_CABLE_MGMT_PARAM1_INTERFACE_MODULE_PRESENT             (0x00)
+#define MPI3_MAN6_GPIO_CABLE_MGMT_PARAM1_INTERFACE_ACTIVE_CABLE_ENABLE        (0x01)
+#define MPI3_MAN6_GPIO_CABLE_MGMT_PARAM1_INTERFACE_CABLE_MGMT_ENABLE          (0x02)
+
+/**** Defines for Param2 (ISTWI RESET) when FunctionCode is ISTWI_MUX_RESET ****/
+#define MPI3_MAN6_GPIO_ISTWI_MUX_RESET_PARAM2_SPEC_MUX                        (0x00)
+#define MPI3_MAN6_GPIO_ISTWI_MUX_RESET_PARAM2_ALL_MUXES                       (0x01)
+
+/**** Defines for Param1 (LECENSE_TYPE) when FunctionCode is LICENSE ****/
+#define MPI3_MAN6_GPIO_LICENSE_PARAM1_TYPE_IBUTTON                            (0x00)
+
+
+/**** Defines for the Flags field ****/
+#define MPI3_MAN6_GPIO_FLAGS_SLEW_RATE_MASK                                   (0x0100)
+#define MPI3_MAN6_GPIO_FLAGS_SLEW_RATE_FAST_EDGE                              (0x0100)
+#define MPI3_MAN6_GPIO_FLAGS_SLEW_RATE_SLOW_EDGE                              (0x0000)
+#define MPI3_MAN6_GPIO_FLAGS_DRIVE_STRENGTH_MASK                              (0x00C0)
+#define MPI3_MAN6_GPIO_FLAGS_DRIVE_STRENGTH_100OHM                            (0x0000)
+#define MPI3_MAN6_GPIO_FLAGS_DRIVE_STRENGTH_66OHM                             (0x0040)
+#define MPI3_MAN6_GPIO_FLAGS_DRIVE_STRENGTH_50OHM                             (0x0080)
+#define MPI3_MAN6_GPIO_FLAGS_DRIVE_STRENGTH_33OHM                             (0x00C0)
+#define MPI3_MAN6_GPIO_FLAGS_ALT_DATA_SEL_MASK                                (0x0030)
+#define MPI3_MAN6_GPIO_FLAGS_ALT_DATA_SEL_SHIFT                               (4)
+#define MPI3_MAN6_GPIO_FLAGS_ACTIVE_HIGH                                      (0x0008)
+#define MPI3_MAN6_GPIO_FLAGS_BI_DIR_ENABLED                                   (0x0004)
+#define MPI3_MAN6_GPIO_FLAGS_DIRECTION_MASK                                   (0x0003)
+#define MPI3_MAN6_GPIO_FLAGS_DIRECTION_INPUT                                  (0x0000)
+#define MPI3_MAN6_GPIO_FLAGS_DIRECTION_OPEN_DRAIN_OUTPUT                      (0x0001)
+#define MPI3_MAN6_GPIO_FLAGS_DIRECTION_OPEN_SOURCE_OUTPUT                     (0x0002)
+#define MPI3_MAN6_GPIO_FLAGS_DIRECTION_PUSH_PULL_OUTPUT                       (0x0003)
+
+#ifndef MPI3_MAN6_GPIO_MAX
+#define MPI3_MAN6_GPIO_MAX                                                    (1)
+#endif  /* MPI3_MAN6_GPIO_MAX */
+
+typedef struct _MPI3_MAN_PAGE6 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                   /* 0x00 */
+    U16                             Flags;                                    /* 0x08 */
+    U16                             Reserved0A;                               /* 0x0A */
+    U8                              NumGPIO;                                  /* 0x0C */
+    U8                              Reserved0D[3];                            /* 0x0D */
+    MPI3_MAN6_GPIO_ENTRY            GPIO[MPI3_MAN6_GPIO_MAX];                 /* 0x10 */
+} MPI3_MAN_PAGE6, MPI3_POINTER PTR_MPI3_MAN_PAGE6,
+  Mpi3ManPage6_t, MPI3_POINTER pMpi3ManPage6_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN6_PAGEVERSION                                                 (0x00)
+
+/**** Defines for the Flags field ****/
+#define MPI3_MAN6_FLAGS_HEARTBEAT_LED_DISABLED                                (0x0001)
+
+/*****************************************************************************
+ *              Manufacturing Page 7                                         *
+ ****************************************************************************/
+typedef struct _MPI3_MAN7_RECEPTACLE_INFO {
+    U32                             Name[4];                    /* 0x00 */
+    U8                              Location;                   /* 0x10 */
+    U8                              ConnectorType;              /* 0x11 */
+    U8                              PEDClk;                     /* 0x12 */
+    U8                              ConnectorID;                /* 0x13 */
+    U32                             Reserved14;                 /* 0x14 */
+} MPI3_MAN7_RECEPTACLE_INFO, MPI3_POINTER PTR_MPI3_MAN7_RECEPTACLE_INFO,
+ Mpi3Man7ReceptacleInfo_t, MPI3_POINTER pMpi3Man7ReceptacleInfo_t;
+
+/**** Defines for Location field ****/
+#define MPI3_MAN7_LOCATION_UNKNOWN                         (0x00)
+#define MPI3_MAN7_LOCATION_INTERNAL                        (0x01)
+#define MPI3_MAN7_LOCATION_EXTERNAL                        (0x02)
+#define MPI3_MAN7_LOCATION_VIRTUAL                         (0x03)
+
+/**** Defines for ConnectorType - Use definitions from SES-4 ****/
+
+/**** Defines for PEDClk field ****/
+#define MPI3_MAN7_PEDCLK_ROUTING_MASK                      (0x10)
+#define MPI3_MAN7_PEDCLK_ROUTING_DIRECT                    (0x00)
+#define MPI3_MAN7_PEDCLK_ROUTING_CLOCK_BUFFER              (0x10)
+#define MPI3_MAN7_PEDCLK_ID_MASK                           (0x0F)
+
+#ifndef MPI3_MAN7_RECEPTACLE_INFO_MAX
+#define MPI3_MAN7_RECEPTACLE_INFO_MAX                      (1)
+#endif  /* MPI3_MAN7_RECEPTACLE_INFO_MAX */
+
+typedef struct _MPI3_MAN_PAGE7 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                           /* 0x00 */
+    U32                             Flags;                                            /* 0x08 */
+    U8                              NumReceptacles;                                   /* 0x0C */
+    U8                              Reserved0D[3];                                    /* 0x0D */
+    U32                             EnclosureName[4];                                 /* 0x10 */
+    MPI3_MAN7_RECEPTACLE_INFO       ReceptacleInfo[MPI3_MAN7_RECEPTACLE_INFO_MAX];    /* 0x20 */   /* variable length array */
+} MPI3_MAN_PAGE7, MPI3_POINTER PTR_MPI3_MAN_PAGE7,
+  Mpi3ManPage7_t, MPI3_POINTER pMpi3ManPage7_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN7_PAGEVERSION                              (0x00)
+
+/**** Defines for Flags field ****/
+#define MPI3_MAN7_FLAGS_BASE_ENCLOSURE_LEVEL_MASK          (0x01)
+#define MPI3_MAN7_FLAGS_BASE_ENCLOSURE_LEVEL_0             (0x00)
+#define MPI3_MAN7_FLAGS_BASE_ENCLOSURE_LEVEL_1             (0x01)
+
+
+/*****************************************************************************
+ *              Manufacturing Page 8                                         *
+ ****************************************************************************/
+
+typedef struct _MPI3_MAN8_PHY_INFO {
+    U8                              ReceptacleID;               /* 0x00 */
+    U8                              ConnectorLane;              /* 0x01 */
+    U16                             Reserved02;                 /* 0x02 */
+    U16                             Slotx1;                     /* 0x04 */
+    U16                             Slotx2;                     /* 0x06 */
+    U16                             Slotx4;                     /* 0x08 */
+    U16                             Reserved0A;                 /* 0x0A */
+    U32                             Reserved0C;                 /* 0x0C */
+} MPI3_MAN8_PHY_INFO, MPI3_POINTER PTR_MPI3_MAN8_PHY_INFO,
+  Mpi3Man8PhyInfo_t, MPI3_POINTER pMpi3Man8PhyInfo_t;
+
+#ifndef MPI3_MAN8_PHY_INFO_MAX
+#define MPI3_MAN8_PHY_INFO_MAX                      (1)
+#endif  /* MPI3_MAN8_PHY_INFO_MAX */
+
+typedef struct _MPI3_MAN_PAGE8 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                            /* 0x00 */
+    U32                             Reserved08;                        /* 0x08 */
+    U8                              NumPhys;                           /* 0x0C */
+    U8                              Reserved0D[3];                     /* 0x0D */
+    MPI3_MAN8_PHY_INFO              PhyInfo[MPI3_MAN8_PHY_INFO_MAX];   /* 0x10 */  /* variable length array */
+} MPI3_MAN_PAGE8, MPI3_POINTER PTR_MPI3_MAN_PAGE8,
+  Mpi3ManPage8_t, MPI3_POINTER pMpi3ManPage8_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN8_PAGEVERSION                   (0x00)
+
+/*****************************************************************************
+ *              Manufacturing Page 9                                         *
+ ****************************************************************************/
+typedef struct _MPI3_MAN9_RSRC_ENTRY {
+    U32     Maximum;        /* 0x00 */
+    U32     Decrement;      /* 0x04 */
+    U32     Minimum;        /* 0x08 */
+    U32     Actual;         /* 0x0C */
+} MPI3_MAN9_RSRC_ENTRY, MPI3_POINTER PTR_MPI3_MAN9_RSRC_ENTRY,
+  Mpi3Man9RsrcEntry_t, MPI3_POINTER pMpi3Man9RsrcEntry_t;
+
+typedef enum _MPI3_MAN9_RESOURCES {
+    MPI3_MAN9_RSRC_OUTSTANDING_REQS = 0,
+    MPI3_MAN9_RSRC_TARGET_CMDS      = 1,
+    MPI3_MAN9_RSRC_SAS_TARGETS      = 2,
+    MPI3_MAN9_RSRC_PCIE_TARGETS     = 3,
+    MPI3_MAN9_RSRC_INITIATORS       = 4,
+    MPI3_MAN9_RSRC_VDS              = 5,
+    MPI3_MAN9_RSRC_ENCLOSURES       = 6,
+    MPI3_MAN9_RSRC_ENCLOSURE_PHYS   = 7,
+    MPI3_MAN9_RSRC_EXPANDERS        = 8,
+    MPI3_MAN9_RSRC_PCIE_SWITCHES    = 9,
+    MPI3_MAN9_RSRC_PDS              = 10,
+    MPI3_MAN9_RSRC_HOST_PDS         = 11,
+    MPI3_MAN9_RSRC_ADV_HOST_PDS     = 12,
+    MPI3_MAN9_RSRC_RAID_PDS         = 13,
+    MPI3_MAN9_RSRC_NUM_RESOURCES
+} MPI3_MAN9_RESOURCES;
+
+#define MPI3_MAN9_MIN_OUTSTANDING_REQS      (1)
+#define MPI3_MAN9_MAX_OUTSTANDING_REQS      (65000)
+
+#define MPI3_MAN9_MIN_TARGET_CMDS           (0)
+#define MPI3_MAN9_MAX_TARGET_CMDS           (65535)
+
+#define MPI3_MAN9_MIN_SAS_TARGETS           (0)
+#define MPI3_MAN9_MAX_SAS_TARGETS           (65535)
+
+#define MPI3_MAN9_MIN_PCIE_TARGETS          (0)
+/* Max PCIe Targets is product specific */
+
+#define MPI3_MAN9_MIN_INITIATORS            (0)
+#define MPI3_MAN9_MAX_INITIATORS            (65535)
+
+#define MPI3_MAN9_MIN_ENCLOSURES            (0)
+#define MPI3_MAN9_MAX_ENCLOSURES            (65535)
+
+#define MPI3_MAN9_MIN_ENCLOSURE_PHYS        (0)
+/*
+ * Max Enclosure Phys depends on the largest enclosure
+ * i.e. the enclosure with the largest number of phys.
+ */
+
+#define MPI3_MAN9_MIN_EXPANDERS             (0)
+#define MPI3_MAN9_MAX_EXPANDERS             (65535)
+
+#define MPI3_MAN9_MIN_PCIE_SWITCHES         (0)
+/* Max PCIe Switches is product specific */
+
+typedef struct _MPI3_MAN_PAGE9 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                 /* 0x00 */
+    U8                              NumResources;                           /* 0x08 */
+    U8                              Reserved09;                             /* 0x09 */
+    U16                             Reserved0A;                             /* 0x0A */
+    U32                             Reserved0C;                             /* 0x0C */
+    U32                             Reserved10;                             /* 0x10 */
+    U32                             Reserved14;                             /* 0x14 */
+    U32                             Reserved18;                             /* 0x18 */
+    U32                             Reserved1C;                             /* 0x1C */
+    MPI3_MAN9_RSRC_ENTRY            Resource[MPI3_MAN9_RSRC_NUM_RESOURCES]; /* 0x20 */
+} MPI3_MAN_PAGE9, MPI3_POINTER PTR_MPI3_MAN_PAGE9,
+  Mpi3ManPage9_t, MPI3_POINTER pMpi3ManPage9_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN9_PAGEVERSION                   (0x00)
+
+/*****************************************************************************
+ *              Manufacturing Page 10                                        *
+ ****************************************************************************/
+typedef struct _MPI3_MAN10_ISTWI_CTRLR_ENTRY {
+    U16     SlaveAddress;       /* 0x00 */
+    U16     Flags;              /* 0x02 */
+    U32     Reserved04;         /* 0x04 */
+} MPI3_MAN10_ISTWI_CTRLR_ENTRY, MPI3_POINTER PTR_MPI3_MAN10_ISTWI_CTRLR_ENTRY,
+  Mpi3Man10IstwiCtrlrEntry_t, MPI3_POINTER pMpi3Man10IstwiCtrlrEntry_t;
+
+/**** Defines for the Flags field ****/
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_SLAVE_ENABLED          (0x0002)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_MASTER_ENABLED         (0x0001)
+
+#ifndef MPI3_MAN10_ISTWI_CTRLR_MAX
+#define MPI3_MAN10_ISTWI_CTRLR_MAX          (1)
+#endif  /* MPI3_MAN10_ISTWI_CTRLR_MAX */
+
+typedef struct _MPI3_MAN_PAGE10 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                         /* 0x00 */
+    U32                             Reserved08;                                     /* 0x08 */
+    U8                              NumISTWICtrl;                                   /* 0x0C */
+    U8                              Reserved0D[3];                                  /* 0x0D */
+    MPI3_MAN10_ISTWI_CTRLR_ENTRY    ISTWIController[MPI3_MAN10_ISTWI_CTRLR_MAX];    /* 0x10 */
+} MPI3_MAN_PAGE10, MPI3_POINTER PTR_MPI3_MAN_PAGE10,
+  Mpi3ManPage10_t, MPI3_POINTER pMpi3ManPage10_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN10_PAGEVERSION                  (0x00)
+
+/*****************************************************************************
+ *              Manufacturing Page 11                                        *
+ ****************************************************************************/
+typedef struct _MPI3_MAN11_MUX_DEVICE_FORMAT {
+    U8      MaxChannel;         /* 0x00 */
+    U8      Reserved01[3];      /* 0x01 */
+    U32     Reserved04;         /* 0x04 */
+} MPI3_MAN11_MUX_DEVICE_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_MUX_DEVICE_FORMAT,
+  Mpi3Man11MuxDeviceFormat_t, MPI3_POINTER pMpi3Man11MuxDeviceFormat_t;
+
+typedef struct _MPI3_MAN11_TEMP_SENSOR_DEVICE_FORMAT {
+    U8      Type;               /* 0x00 */
+    U8      Reserved01[3];      /* 0x01 */
+    U8      TempChannel[4];     /* 0x04 */
+} MPI3_MAN11_TEMP_SENSOR_DEVICE_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_TEMP_SENSOR_DEVICE_FORMAT,
+  Mpi3Man11TempSensorDeviceFormat_t, MPI3_POINTER pMpi3Man11TempSensorDeviceFormat_t;
+
+/**** Defines for the Type field ****/
+#define MPI3_MAN11_TEMP_SENSOR_TYPE_MAX6654         (0x00)
+#define MPI3_MAN11_TEMP_SENSOR_TYPE_EMC1442         (0x01)
+#define MPI3_MAN11_TEMP_SENSOR_TYPE_ADT7476         (0x02)
+
+/**** Define for the TempChannel field ****/
+#define MPI3_MAN11_TEMP_SENSOR_CHANNEL_ENABLED      (0x01)
+
+typedef struct _MPI3_MAN11_SEEPROM_DEVICE_FORMAT {
+    U8      Size;               /* 0x00 */
+    U8      PageWriteSize;      /* 0x01 */
+    U16     Reserved02;         /* 0x02 */
+    U32     Reserved04;         /* 0x04 */
+} MPI3_MAN11_SEEPROM_DEVICE_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_SEEPROM_DEVICE_FORMAT,
+  Mpi3Man11SeepromDeviceFormat_t, MPI3_POINTER pMpi3Man11SeepromDeviceFormat_t;
+
+/**** Defines for the Size field ****/
+#define MPI3_MAN11_SEEPROM_SIZE_1KBITS              (0x01)
+#define MPI3_MAN11_SEEPROM_SIZE_2KBITS              (0x02)
+#define MPI3_MAN11_SEEPROM_SIZE_4KBITS              (0x03)
+#define MPI3_MAN11_SEEPROM_SIZE_8KBITS              (0x04)
+#define MPI3_MAN11_SEEPROM_SIZE_16KBITS             (0x05)
+#define MPI3_MAN11_SEEPROM_SIZE_32KBITS             (0x06)
+#define MPI3_MAN11_SEEPROM_SIZE_64KBITS             (0x07)
+#define MPI3_MAN11_SEEPROM_SIZE_128KBITS            (0x08)
+
+typedef struct _MPI3_MAN11_DDR_SPD_DEVICE_FORMAT {
+    U8      Channel;            /* 0x00 */
+    U8      Reserved01[3];      /* 0x01 */
+    U32     Reserved04;         /* 0x04 */
+} MPI3_MAN11_DDR_SPD_DEVICE_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_DDR_SPD_DEVICE_FORMAT,
+  Mpi3Man11DdrSpdDeviceFormat_t, MPI3_POINTER pMpi3Man11DdrSpdDeviceFormat_t;
+
+typedef struct _MPI3_MAN11_CABLE_MGMT_DEVICE_FORMAT {
+    U8      Type;               /* 0x00 */
+    U8      ReceptacleID;       /* 0x01 */
+    U16     Reserved02;         /* 0x02 */
+    U32     Reserved04;         /* 0x04 */
+} MPI3_MAN11_CABLE_MGMT_DEVICE_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_CABLE_MGMT_DEVICE_FORMAT,
+  Mpi3Man11CableMgmtDeviceFormat_t, MPI3_POINTER pMpi3Man11CableMgmtDeviceFormat_t;
+
+/**** Defines for the Type field ****/
+#define MPI3_MAN11_CABLE_MGMT_TYPE_SFF_8636           (0x00)
+
+typedef struct _MPI3_MAN11_BKPLANE_SPEC_UBM_FORMAT {
+    U16     Flags;              /* 0x00 */
+    U16     Reserved02;         /* 0x02 */
+} MPI3_MAN11_BKPLANE_SPEC_UBM_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_BKPLANE_SPEC_UBM_FORMAT,
+  Mpi3Man11BkplaneSpecUBMFormat, MPI3_POINTER pMpi3Man11BkplaneSpecUBMFormat;
+
+#define MPI3_MAN11_BKPLANE_UBM_FLAGS_REFCLK_POLICY_ALWAYS_ENABLED  (0x0200)
+#define MPI3_MAN11_BKPLANE_UBM_FLAGS_FORCE_POLLING                 (0x0100)
+#define MPI3_MAN11_BKPLANE_UBM_FLAGS_MAX_FRU_MASK                  (0x00F0)
+#define MPI3_MAN11_BKPLANE_UBM_FLAGS_MAX_FRU_SHIFT                 (4)
+#define MPI3_MAN11_BKPLANE_UBM_FLAGS_POLL_INTERVAL_MASK            (0x000F)
+#define MPI3_MAN11_BKPLANE_UBM_FLAGS_POLL_INTERVAL_SHIFT           (0)
+
+typedef struct _MPI3_MAN11_BKPLANE_SPEC_VPP_FORMAT {
+    U16     Flags;              /* 0x00 */
+    U16     Reserved02;         /* 0x02 */
+} MPI3_MAN11_BKPLANE_SPEC_VPP_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_BKPLANE_SPEC_VPP_FORMAT,
+  Mpi3Man11BkplaneSpecVPPFormat, MPI3_POINTER pMpi3Man11BkplaneSpecVPPFormat;
+
+#define MPI3_MAN11_BKPLANE_VPP_FLAGS_REFCLK_POLICY_ALWAYS_ENABLED  (0x0040)
+#define MPI3_MAN11_BKPLANE_VPP_FLAGS_PRESENCE_DETECT_MASK          (0x0030)
+#define MPI3_MAN11_BKPLANE_VPP_FLAGS_PRESENCE_DETECT_GPIO          (0x0000)
+#define MPI3_MAN11_BKPLANE_VPP_FLAGS_PRESENCE_DETECT_REG           (0x0010)
+#define MPI3_MAN11_BKPLANE_VPP_FLAGS_POLL_INTERVAL_MASK            (0x000F)
+#define MPI3_MAN11_BKPLANE_VPP_FLAGS_POLL_INTERVAL_SHIFT           (0)
+
+
+typedef union _MPI3_MAN11_BKPLANE_SPEC_FORMAT {
+    MPI3_MAN11_BKPLANE_SPEC_UBM_FORMAT     Ubm;
+    MPI3_MAN11_BKPLANE_SPEC_VPP_FORMAT     Vpp;
+} MPI3_MAN11_BKPLANE_SPEC_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_BKPLANE_SPEC_FORMAT,
+  Mpi3Man11BkplaneSpecFormat, MPI3_POINTER pMpi3Man11BkplaneSpecFormat;
+
+typedef struct _MPI3_MAN11_BKPLANE_MGMT_DEVICE_FORMAT {
+    U8                                     Type;                   /* 0x00 */
+    U8                                     ReceptacleID;           /* 0x01 */
+    U16                                    Reserved02;             /* 0x02 */
+    MPI3_MAN11_BKPLANE_SPEC_FORMAT         BackplaneMgmtSpecific;  /* 0x04 */
+} MPI3_MAN11_BKPLANE_MGMT_DEVICE_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_BKPLANE_MGMT_DEVICE_FORMAT,
+  Mpi3Man11BkplaneMgmtDeviceFormat_t, MPI3_POINTER pMpi3Man11BkplaneMgmtDeviceFormat_t;
+
+/**** Defines for the Type field ****/
+#define MPI3_MAN11_BKPLANE_MGMT_TYPE_UBM            (0x00)
+#define MPI3_MAN11_BKPLANE_MGMT_TYPE_VPP            (0x01)
+
+typedef struct _MPI3_MAN11_GAS_GAUGE_DEVICE_FORMAT {
+    U8      Type;               /* 0x00 */
+    U8      Reserved01[3];      /* 0x01 */
+    U32     Reserved04;         /* 0x04 */
+} MPI3_MAN11_GAS_GAUGE_DEVICE_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_GAS_GAUGE_DEVICE_FORMAT,
+  Mpi3Man11GasGaugeDeviceFormat_t, MPI3_POINTER pMpi3Man11GasGaugeDeviceFormat_t;
+
+/**** Defines for the Type field ****/
+#define MPI3_MAN11_GAS_GAUGE_TYPE_STANDARD          (0x00)
+
+typedef union _MPI3_MAN11_DEVICE_SPECIFIC_FORMAT {
+    MPI3_MAN11_MUX_DEVICE_FORMAT            Mux;
+    MPI3_MAN11_TEMP_SENSOR_DEVICE_FORMAT    TempSensor;
+    MPI3_MAN11_SEEPROM_DEVICE_FORMAT        Seeprom;
+    MPI3_MAN11_DDR_SPD_DEVICE_FORMAT        DdrSpd;
+    MPI3_MAN11_CABLE_MGMT_DEVICE_FORMAT     CableMgmt;
+    MPI3_MAN11_BKPLANE_MGMT_DEVICE_FORMAT   BkplaneMgmt;
+    MPI3_MAN11_GAS_GAUGE_DEVICE_FORMAT      GasGauge;
+    U32                                     Words[2];
+} MPI3_MAN11_DEVICE_SPECIFIC_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_DEVICE_SPECIFIC_FORMAT,
+  Mpi3Man11DeviceSpecificFormat_t, MPI3_POINTER pMpi3Man11DeviceSpecificFormat_t;
+
+typedef struct _MPI3_MAN11_ISTWI_DEVICE_FORMAT {
+    U8                                  DeviceType;         /* 0x00 */
+    U8                                  Controller;         /* 0x01 */
+    U8                                  Reserved02;         /* 0x02 */
+    U8                                  Flags;              /* 0x03 */
+    U16                                 DeviceAddress;      /* 0x04 */
+    U8                                  MuxChannel;         /* 0x06 */
+    U8                                  MuxIndex;           /* 0x07 */
+    MPI3_MAN11_DEVICE_SPECIFIC_FORMAT   DeviceSpecific;     /* 0x08 */
+} MPI3_MAN11_ISTWI_DEVICE_FORMAT, MPI3_POINTER PTR_MPI3_MAN11_ISTWI_DEVICE_FORMAT,
+  Mpi3Man11IstwiDeviceFormat_t, MPI3_POINTER pMpi3Man11IstwiDeviceFormat_t;
+
+/**** Defines for the DeviceType field ****/
+#define MPI3_MAN11_ISTWI_DEVTYPE_MUX                  (0x00)
+#define MPI3_MAN11_ISTWI_DEVTYPE_TEMP_SENSOR          (0x01)
+#define MPI3_MAN11_ISTWI_DEVTYPE_SEEPROM              (0x02)
+#define MPI3_MAN11_ISTWI_DEVTYPE_DDR_SPD              (0x03)
+#define MPI3_MAN11_ISTWI_DEVTYPE_CABLE_MGMT           (0x04)
+#define MPI3_MAN11_ISTWI_DEVTYPE_BACKPLANE_MGMT       (0x05)
+#define MPI3_MAN11_ISTWI_DEVTYPE_GAS_GAUGE            (0x06)
+
+/**** Defines for the Flags field ****/
+#define MPI3_MAN11_ISTWI_FLAGS_MUX_PRESENT            (0x01)
+#define MPI3_MAN11_ISTWI_FLAGS_BUS_SPEED_MASK         (0x06)
+#define MPI3_MAN11_ISTWI_FLAGS_BUS_SPEED_100KHZ       (0x00)
+#define MPI3_MAN11_ISTWI_FLAGS_BUS_SPEED_400KHZ       (0x02)
+
+#ifndef MPI3_MAN11_ISTWI_DEVICE_MAX
+#define MPI3_MAN11_ISTWI_DEVICE_MAX             (1)
+#endif  /* MPI3_MAN11_ISTWI_DEVICE_MAX */
+
+typedef struct _MPI3_MAN_PAGE11 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                     /* 0x00 */
+    U32                             Reserved08;                                 /* 0x08 */
+    U8                              NumISTWIDev;                                /* 0x0C */
+    U8                              Reserved0D[3];                              /* 0x0D */
+    MPI3_MAN11_ISTWI_DEVICE_FORMAT  ISTWIDevice[MPI3_MAN11_ISTWI_DEVICE_MAX];   /* 0x10 */
+} MPI3_MAN_PAGE11, MPI3_POINTER PTR_MPI3_MAN_PAGE11,
+  Mpi3ManPage11_t, MPI3_POINTER pMpi3ManPage11_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN11_PAGEVERSION                  (0x00)
+
+
+/*****************************************************************************
+ *              Manufacturing Page 12                                        *
+ ****************************************************************************/
+#ifndef MPI3_MAN12_NUM_SGPIO_MAX
+#define MPI3_MAN12_NUM_SGPIO_MAX                                     (1)
+#endif  /* MPI3_MAN12_NUM_SGPIO_MAX */
+
+typedef struct _MPI3_MAN12_SGPIO_INFO {
+    U8                              SlotCount;                                  /* 0x00 */
+    U8                              Reserved01[3];                              /* 0x01 */
+    U32                             Reserved04;                                 /* 0x04 */
+    U8                              PhyOrder[32];                               /* 0x08 */
+} MPI3_MAN12_SGPIO_INFO, MPI3_POINTER PTR_MPI3_MAN12_SGPIO_INFO,
+  Mpi3Man12SGPIOInfo, MPI3_POINTER pMpi3Man12SGPIOInfo;
+
+typedef struct _MPI3_MAN_PAGE12 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                     /* 0x00 */
+    U32                             Flags;                                      /* 0x08 */
+    U32                             SClockFreq;                                 /* 0x0C */
+    U32                             ActivityModulation;                         /* 0x10 */
+    U8                              NumSGPIO;                                   /* 0x14 */
+    U8                              Reserved15[3];                              /* 0x15 */
+    U32                             Reserved18;                                 /* 0x18 */
+    U32                             Reserved1C;                                 /* 0x1C */
+    U32                             Pattern[8];                                 /* 0x20 */
+    MPI3_MAN12_SGPIO_INFO           SGPIOInfo[MPI3_MAN12_NUM_SGPIO_MAX];        /* 0x40 */   /* variable length */
+} MPI3_MAN_PAGE12, MPI3_POINTER PTR_MPI3_MAN_PAGE12,
+  Mpi3ManPage12_t, MPI3_POINTER pMpi3ManPage12_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN12_PAGEVERSION                                       (0x00)
+
+/**** Defines for the Flags field ****/
+#define MPI3_MAN12_FLAGS_ERROR_PRESENCE_ENABLED                      (0x0400)
+#define MPI3_MAN12_FLAGS_ACTIVITY_INVERT_ENABLED                     (0x0200)
+#define MPI3_MAN12_FLAGS_GROUP_ID_DISABLED                           (0x0100)
+#define MPI3_MAN12_FLAGS_SIO_CLK_FILTER_ENABLED                      (0x0004)
+#define MPI3_MAN12_FLAGS_SCLOCK_SLOAD_TYPE_MASK                      (0x0002)
+#define MPI3_MAN12_FLAGS_SCLOCK_SLOAD_TYPE_PUSH_PULL                 (0x0000)
+#define MPI3_MAN12_FLAGS_SCLOCK_SLOAD_TYPE_OPEN_DRAIN                (0x0002)
+#define MPI3_MAN12_FLAGS_SDATAOUT_TYPE_MASK                          (0x0001)
+#define MPI3_MAN12_FLAGS_SDATAOUT_TYPE_PUSH_PULL                     (0x0000)
+#define MPI3_MAN12_FLAGS_SDATAOUT_TYPE_OPEN_DRAIN                    (0x0001)
+
+/**** Defines for the SioClkFreq field ****/
+#define MPI3_MAN12_SIO_CLK_FREQ_MIN                                  (32)        /* 32 Hz min SIO Clk Freq */
+#define MPI3_MAN12_SIO_CLK_FREQ_MAX                                  (100000)    /* 100 KHz max SIO Clk Freq */
+
+/**** Defines for the ActivityModulation field ****/
+#define MPI3_MAN12_ACTIVITY_MODULATION_FORCE_OFF_MASK                (0x0000F000)
+#define MPI3_MAN12_ACTIVITY_MODULATION_FORCE_OFF_SHIFT               (12)
+#define MPI3_MAN12_ACTIVITY_MODULATION_MAX_ON_MASK                   (0x00000F00)
+#define MPI3_MAN12_ACTIVITY_MODULATION_MAX_ON_SHIFT                  (8)
+#define MPI3_MAN12_ACTIVITY_MODULATION_STRETCH_OFF_MASK              (0x000000F0)
+#define MPI3_MAN12_ACTIVITY_MODULATION_STRETCH_OFF_SHIFT             (4)
+#define MPI3_MAN12_ACTIVITY_MODULATION_STRETCH_ON_MASK               (0x0000000F)
+#define MPI3_MAN12_ACTIVITY_MODULATION_STRETCH_ON_SHIFT              (0)
+
+/*** Defines for the Pattern field ****/
+#define MPI3_MAN12_PATTERN_RATE_MASK                                 (0xE0000000)
+#define MPI3_MAN12_PATTERN_RATE_2_HZ                                 (0x00000000)
+#define MPI3_MAN12_PATTERN_RATE_4_HZ                                 (0x20000000)
+#define MPI3_MAN12_PATTERN_RATE_8_HZ                                 (0x40000000)
+#define MPI3_MAN12_PATTERN_RATE_16_HZ                                (0x60000000)
+#define MPI3_MAN12_PATTERN_RATE_10_HZ                                (0x80000000)
+#define MPI3_MAN12_PATTERN_RATE_20_HZ                                (0xA0000000)
+#define MPI3_MAN12_PATTERN_RATE_40_HZ                                (0xC0000000)
+#define MPI3_MAN12_PATTERN_LENGTH_MASK                               (0x1F000000)
+#define MPI3_MAN12_PATTERN_LENGTH_SHIFT                              (24)
+#define MPI3_MAN12_PATTERN_BIT_PATTERN_MASK                          (0x00FFFFFF)
+#define MPI3_MAN12_PATTERN_BIT_PATTERN_SHIFT                         (0)
+
+
+/*****************************************************************************
+ *              Manufacturing Page 13                                        *
+ ****************************************************************************/
+
+#ifndef MPI3_MAN13_NUM_TRANSLATION_MAX
+#define MPI3_MAN13_NUM_TRANSLATION_MAX                               (1)
+#endif  /* MPI3_MAN13_NUM_TRANSLATION_MAX */
+
+typedef struct _MPI3_MAN13_TRANSLATION_INFO {
+    U32                             SlotStatus;                                        /* 0x00 */
+    U32                             Mask;                                              /* 0x04 */
+    U8                              Activity;                                          /* 0x08 */
+    U8                              Locate;                                            /* 0x09 */
+    U8                              Error;                                             /* 0x0A */
+    U8                              Reserved0B;                                        /* 0x0B */
+} MPI3_MAN13_TRANSLATION_INFO, MPI3_POINTER PTR_MPI3_MAN13_TRANSLATION_INFO,
+  Mpi3Man13TranslationInfo, MPI3_POINTER pMpi3Man13TranslationInfo;
+
+/**** Defines for the SlotStatus field ****/
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_FAULT                     (0x20000000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_DEVICE_OFF                (0x10000000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_DEVICE_ACTIVITY           (0x00800000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_DO_NOT_REMOVE             (0x00400000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_DEVICE_MISSING            (0x00100000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_INSERT                    (0x00080000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_REMOVAL                   (0x00040000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_IDENTIFY                  (0x00020000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_OK                        (0x00008000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_RESERVED_DEVICE           (0x00004000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_HOT_SPARE                 (0x00002000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_CONSISTENCY_CHECK         (0x00001000)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_IN_CRITICAL_ARRAY         (0x00000800)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_IN_FAILED_ARRAY           (0x00000400)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_REBUILD_REMAP             (0x00000200)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_REBUILD_REMAP_ABORT       (0x00000100)
+#define MPI3_MAN13_TRANSLATION_SLOTSTATUS_PREDICTED_FAILURE         (0x00000040)
+
+/**** Defines for the Mask field - use MPI3_MAN13_TRANSLATION_SLOTSTATUS_ defines ****/
+
+/**** Defines for the Activity, Locate, and Error fields ****/
+#define MPI3_MAN13_BLINK_PATTERN_FORCE_OFF                          (0x00)
+#define MPI3_MAN13_BLINK_PATTERN_FORCE_ON                           (0x01)
+#define MPI3_MAN13_BLINK_PATTERN_PATTERN_0                          (0x02)
+#define MPI3_MAN13_BLINK_PATTERN_PATTERN_1                          (0x03)
+#define MPI3_MAN13_BLINK_PATTERN_PATTERN_2                          (0x04)
+#define MPI3_MAN13_BLINK_PATTERN_PATTERN_3                          (0x05)
+#define MPI3_MAN13_BLINK_PATTERN_PATTERN_4                          (0x06)
+#define MPI3_MAN13_BLINK_PATTERN_PATTERN_5                          (0x07)
+#define MPI3_MAN13_BLINK_PATTERN_PATTERN_6                          (0x08)
+#define MPI3_MAN13_BLINK_PATTERN_PATTERN_7                          (0x09)
+#define MPI3_MAN13_BLINK_PATTERN_ACTIVITY                           (0x0A)
+#define MPI3_MAN13_BLINK_PATTERN_ACTIVITY_TRAIL                     (0x0B)
+
+typedef struct _MPI3_MAN_PAGE13 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                            /* 0x00 */
+    U8                              NumTrans;                                          /* 0x08 */
+    U8                              Reserved09[3];                                     /* 0x09 */
+    U32                             Reserved0C;                                        /* 0x0C */
+    MPI3_MAN13_TRANSLATION_INFO     Translation[MPI3_MAN13_NUM_TRANSLATION_MAX];       /* 0x10 */  /* variable length */
+} MPI3_MAN_PAGE13, MPI3_POINTER PTR_MPI3_MAN_PAGE13,
+  Mpi3ManPage13_t, MPI3_POINTER pMpi3ManPage13_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN13_PAGEVERSION                                       (0x00)
+
+/*****************************************************************************
+ *              Manufacturing Page 14                                        *
+ ****************************************************************************/
+
+typedef struct _MPI3_MAN_PAGE14 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                            /* 0x00 */
+    U16                             Flags;                                             /* 0x08 */
+    U16                             Reserved0A;                                        /* 0x0A */
+    U8                              NumSlotGroups;                                     /* 0x0C */
+    U8                              NumSlots;                                          /* 0x0D */
+    U16                             MaxCertChainLength;                                /* 0x0E */
+    U32                             SealedSlots;                                       /* 0x10 */
+} MPI3_MAN_PAGE14, MPI3_POINTER PTR_MPI3_MAN_PAGE14,
+  Mpi3ManPage14_t, MPI3_POINTER pMpi3ManPage14_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN14_PAGEVERSION                                       (0x00)
+
+/**** Defines for the Flags field ****/
+#define MPI3_MAN14_FLAGS_AUTH_SESSION_REQ                            (0x01)
+#define MPI3_MAN14_FLAGS_AUTH_API_MASK                               (0x0E)
+#define MPI3_MAN14_FLAGS_AUTH_API_NONE                               (0x00)
+#define MPI3_MAN14_FLAGS_AUTH_API_CEREBUS                            (0x02)
+#define MPI3_MAN14_FLAGS_AUTH_API_DMTF_PMCI                          (0x04)
+
+/*****************************************************************************
+ *              Manufacturing Page 15                                        *
+ ****************************************************************************/
+
+#ifndef MPI3_MAN15_VERSION_RECORD_MAX
+#define MPI3_MAN15_VERSION_RECORD_MAX      1
+#endif  /* MPI3_MAN15_VERSION_RECORD_MAX */
+
+typedef struct _MPI3_MAN15_VERSION_RECORD {
+    U16                             SPDMVersion;                                       /* 0x00 */
+    U16                             Reserved02;                                        /* 0x02 */
+} MPI3_MAN15_VERSION_RECORD, MPI3_POINTER PTR_MPI3_MAN15_VERSION_RECORD,
+  Mpi3Man15VersionRecord_t, MPI3_POINTER pMpi3Man15VersionRecord_t;
+
+typedef struct _MPI3_MAN_PAGE15 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                            /* 0x00 */
+    U8                              NumVersionRecords;                                 /* 0x08 */
+    U8                              Reserved09[3];                                     /* 0x09 */
+    U32                             Reserved0C;                                        /* 0x0C */
+    MPI3_MAN15_VERSION_RECORD       VersionRecord[MPI3_MAN15_VERSION_RECORD_MAX];      /* 0x10 */
+} MPI3_MAN_PAGE15, MPI3_POINTER PTR_MPI3_MAN_PAGE15,
+  Mpi3ManPage15_t, MPI3_POINTER pMpi3ManPage15_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN15_PAGEVERSION                                       (0x00)
+
+/*****************************************************************************
+ *              Manufacturing Page 16                                        *
+ ****************************************************************************/
+
+#ifndef MPI3_MAN16_CERT_ALGO_MAX
+#define MPI3_MAN16_CERT_ALGO_MAX      1
+#endif  /* MPI3_MAN16_CERT_ALGO_MAX */
+
+typedef struct _MPI3_MAN16_CERTIFICATE_ALGORITHM {
+    U8                                   SlotGroup;                                    /* 0x00 */
+    U8                                   Reserved01[3];                                /* 0x01 */
+    U32                                  BaseAsymAlgo;                                 /* 0x04 */
+    U32                                  BaseHashAlgo;                                 /* 0x08 */
+    U32                                  Reserved0C[3];                                /* 0x0C */
+} MPI3_MAN16_CERTIFICATE_ALGORITHM, MPI3_POINTER PTR_MPI3_MAN16_CERTIFICATE_ALGORITHM,
+  Mpi3Man16CertificateAlgorithm_t, MPI3_POINTER pMpi3Man16CertificateAlgorithm_t;
+
+typedef struct _MPI3_MAN_PAGE16 {
+    MPI3_CONFIG_PAGE_HEADER              Header;                                         /* 0x00 */
+    U32                                  Reserved08;                                     /* 0x08 */
+    U8                                   NumCertAlgos;                                   /* 0x0C */
+    U8                                   Reserved0D[3];                                  /* 0x0D */
+    MPI3_MAN16_CERTIFICATE_ALGORITHM     CertificateAlgorithm[MPI3_MAN16_CERT_ALGO_MAX]; /* 0x10 */
+} MPI3_MAN_PAGE16, MPI3_POINTER PTR_MPI3_MAN_PAGE16,
+  Mpi3ManPage16_t, MPI3_POINTER pMpi3ManPage16_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN16_PAGEVERSION                                       (0x00)
+
+/*****************************************************************************
+ *              Manufacturing Page 17                                        *
+ ****************************************************************************/
+
+#ifndef MPI3_MAN17_HASH_ALGORITHM_MAX
+#define MPI3_MAN17_HASH_ALGORITHM_MAX      1
+#endif  /* MPI3_MAN17_HASH_ALGORITHM_MAX */
+
+typedef struct _MPI3_MAN17_HASH_ALGORITHM {
+    U8                              MeasSpecification;                                 /* 0x00 */
+    U8                              Reserved01[3];                                     /* 0x01 */
+    U32                             MeasurementHashAlgo;                               /* 0x04 */
+    U32                             Reserved08[2];                                     /* 0x08 */
+} MPI3_MAN17_HASH_ALGORITHM, MPI3_POINTER PTR_MPI3_MAN17_HASH_ALGORITHM,
+  Mpi3Man17HashAlgorithm_t, MPI3_POINTER pMpi3Man17HashAlgorithm_t;
+
+typedef struct _MPI3_MAN_PAGE17 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                            /* 0x00 */
+    U32                             Reserved08;                                        /* 0x08 */
+    U8                              NumHashAlgos;                                      /* 0x0C */
+    U8                              Reserved0D[3];                                     /* 0x0D */
+    MPI3_MAN17_HASH_ALGORITHM       HashAlgorithm[MPI3_MAN17_HASH_ALGORITHM_MAX];      /* 0x10 */
+} MPI3_MAN_PAGE17, MPI3_POINTER PTR_MPI3_MAN_PAGE17,
+  Mpi3ManPage17_t, MPI3_POINTER pMpi3ManPage17_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN17_PAGEVERSION                                       (0x00)
+
+/*****************************************************************************
+ *              Manufacturing Page 20                                        *
+ ****************************************************************************/
+
+typedef struct _MPI3_MAN_PAGE20 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                            /* 0x00 */
+    U32                             Reserved08;                                        /* 0x08 */
+    U32                             NonpremiumFeatures;                                /* 0x0C */
+    U8                              AllowedPersonalities;                              /* 0x10 */
+    U8                              Reserved11[3];                                     /* 0x11 */
+} MPI3_MAN_PAGE20, MPI3_POINTER PTR_MPI3_MAN_PAGE20,
+  Mpi3ManPage20_t, MPI3_POINTER pMpi3ManPage20_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN20_PAGEVERSION                                       (0x00)
+
+/**** Defines for the AllowedPersonalities field ****/
+#define MPI3_MAN20_ALLOWEDPERSON_RAID_MASK                           (0x02)
+#define MPI3_MAN20_ALLOWEDPERSON_RAID_ALLOWED                        (0x02)
+#define MPI3_MAN20_ALLOWEDPERSON_RAID_NOT_ALLOWED                    (0x00)
+#define MPI3_MAN20_ALLOWEDPERSON_EHBA_MASK                           (0x01)
+#define MPI3_MAN20_ALLOWEDPERSON_EHBA_ALLOWED                        (0x01)
+#define MPI3_MAN20_ALLOWEDPERSON_EHBA_NOT_ALLOWED                    (0x00)
+
+/**** Defines for the NonpremuimFeatures field ****/
+#define MPI3_MAN20_NONPREMUIM_DISABLE_PD_DEGRADED_MASK               (0x01)
+#define MPI3_MAN20_NONPREMUIM_DISABLE_PD_DEGRADED_ENABLED            (0x00)
+#define MPI3_MAN20_NONPREMUIM_DISABLE_PD_DEGRADED_DISABLED           (0x01)
+
+/*****************************************************************************
+ *              Manufacturing Page 21                                        *
+ ****************************************************************************/
+
+typedef struct _MPI3_MAN_PAGE21 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                            /* 0x00 */
+    U32                             Reserved08;                                        /* 0x08 */
+    U32                             Flags;                                             /* 0x0C */
+} MPI3_MAN_PAGE21, MPI3_POINTER PTR_MPI3_MAN_PAGE21,
+  Mpi3ManPage21_t, MPI3_POINTER pMpi3ManPage21_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_MAN21_PAGEVERSION                                       (0x00)
+
+/**** Defines for the Flags field ****/
+#define MPI3_MAN21_FLAGS_HOST_METADATA_CAPABILITY_MASK               (0x80)
+#define MPI3_MAN21_FLAGS_HOST_METADATA_CAPABILITY_ENABLED            (0x80)
+#define MPI3_MAN21_FLAGS_HOST_METADATA_CAPABILITY_DISABLED           (0x00)
+#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_MASK                     (0x60)
+#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_BLOCK                    (0x00)
+#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_ALLOW                    (0x20)
+#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_WARN                     (0x40)
+#define MPI3_MAN21_FLAGS_BLOCK_SSD_WR_CACHE_CHANGE_MASK              (0x08)
+#define MPI3_MAN21_FLAGS_BLOCK_SSD_WR_CACHE_CHANGE_ALLOW             (0x00)
+#define MPI3_MAN21_FLAGS_BLOCK_SSD_WR_CACHE_CHANGE_PREVENT           (0x08)
+#define MPI3_MAN21_FLAGS_SES_VPD_ASSOC_MASK                          (0x01)
+#define MPI3_MAN21_FLAGS_SES_VPD_ASSOC_DEFAULT                       (0x00)
+#define MPI3_MAN21_FLAGS_SES_VPD_ASSOC_OEM_SPECIFIC                  (0x01)
+
+/*****************************************************************************
+ *              Manufacturing Pages 32-63 (ProductSpecific)                  *
+ ****************************************************************************/
+#ifndef MPI3_MAN_PROD_SPECIFIC_MAX
+#define MPI3_MAN_PROD_SPECIFIC_MAX                      (1)
+#endif  /* MPI3_MAN_PROD_SPECIFIC_MAX */
+
+typedef struct _MPI3_MAN_PAGE_PRODUCT_SPECIFIC {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                            /* 0x00 */
+    U32                             ProductSpecificInfo[MPI3_MAN_PROD_SPECIFIC_MAX];   /* 0x08 */  /* variable length array */
+} MPI3_MAN_PAGE_PRODUCT_SPECIFIC, MPI3_POINTER PTR_MPI3_MAN_PAGE_PRODUCT_SPECIFIC,
+  Mpi3ManPageProductSpecific_t, MPI3_POINTER pMpi3ManPageProductSpecific_t;
+
+/*****************************************************************************
+ *              IO Unit Configuration Pages                                  *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              IO Unit Page 0                                               *
+ ****************************************************************************/
+typedef struct _MPI3_IO_UNIT_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                     /* 0x00 */
+    U64                             UniqueValue;                /* 0x08 */
+    U32                             NvdataVersionDefault;       /* 0x10 */
+    U32                             NvdataVersionPersistent;    /* 0x14 */
+} MPI3_IO_UNIT_PAGE0, MPI3_POINTER PTR_MPI3_IO_UNIT_PAGE0,
+  Mpi3IOUnitPage0_t, MPI3_POINTER pMpi3IOUnitPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOUNIT0_PAGEVERSION                (0x00)
+
+/*****************************************************************************
+ *              IO Unit Page 1                                               *
+ ****************************************************************************/
+typedef struct _MPI3_IO_UNIT_PAGE1 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                     /* 0x00 */
+    U32                             Flags;                      /* 0x08 */
+    U8                              DMDIoDelay;                 /* 0x0C */
+    U8                              DMDReportPCIe;              /* 0x0D */
+    U8                              DMDReportSATA;              /* 0x0E */
+    U8                              DMDReportSAS;               /* 0x0F */
+} MPI3_IO_UNIT_PAGE1, MPI3_POINTER PTR_MPI3_IO_UNIT_PAGE1,
+  Mpi3IOUnitPage1_t, MPI3_POINTER pMpi3IOUnitPage1_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOUNIT1_PAGEVERSION                (0x00)
+
+/**** Defines for the Flags field ****/
+#define MPI3_IOUNIT1_FLAGS_NVME_WRITE_CACHE_MASK                   (0x00000030)
+#define MPI3_IOUNIT1_FLAGS_NVME_WRITE_CACHE_ENABLE                 (0x00000000)
+#define MPI3_IOUNIT1_FLAGS_NVME_WRITE_CACHE_DISABLE                (0x00000010)
+#define MPI3_IOUNIT1_FLAGS_NVME_WRITE_CACHE_NO_MODIFY              (0x00000020)
+#define MPI3_IOUNIT1_FLAGS_ATA_SECURITY_FREEZE_LOCK                (0x00000008)
+#define MPI3_IOUNIT1_FLAGS_WRITE_SAME_BUFFER                       (0x00000004)
+#define MPI3_IOUNIT1_FLAGS_SATA_WRITE_CACHE_MASK                   (0x00000003)
+#define MPI3_IOUNIT1_FLAGS_SATA_WRITE_CACHE_ENABLE                 (0x00000000)
+#define MPI3_IOUNIT1_FLAGS_SATA_WRITE_CACHE_DISABLE                (0x00000001)
+#define MPI3_IOUNIT1_FLAGS_SATA_WRITE_CACHE_UNCHANGED              (0x00000002)
+
+/**** Defines for the DMDReport PCIe/SATA/SAS fields ****/
+#define MPI3_IOUNIT1_DMD_REPORT_DELAY_TIME_MASK                    (0x7F)
+#define MPI3_IOUNIT1_DMD_REPORT_UNIT_16_SEC                        (0x80)
+
+/*****************************************************************************
+ *              IO Unit Page 2                                               *
+ ****************************************************************************/
+#ifndef MPI3_IO_UNIT2_GPIO_VAL_MAX
+#define MPI3_IO_UNIT2_GPIO_VAL_MAX      (1)
+#endif  /* MPI3_IO_UNIT2_GPIO_VAL_MAX */
+
+typedef struct _MPI3_IO_UNIT_PAGE2 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                 /* 0x00 */
+    U8                              GPIOCount;                              /* 0x08 */
+    U8                              Reserved09[3];                          /* 0x09 */
+    U16                             GPIOVal[MPI3_IO_UNIT2_GPIO_VAL_MAX];    /* 0x0C */
+} MPI3_IO_UNIT_PAGE2, MPI3_POINTER PTR_MPI3_IO_UNIT_PAGE2,
+  Mpi3IOUnitPage2_t, MPI3_POINTER pMpi3IOUnitPage2_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOUNIT2_PAGEVERSION                (0x00)
+
+/**** Define for the GPIOVal field ****/
+#define MPI3_IOUNIT2_GPIO_FUNCTION_MASK         (0xFFFC)
+#define MPI3_IOUNIT2_GPIO_FUNCTION_SHIFT        (2)
+#define MPI3_IOUNIT2_GPIO_SETTING_MASK          (0x0001)
+#define MPI3_IOUNIT2_GPIO_SETTING_OFF           (0x0000)
+#define MPI3_IOUNIT2_GPIO_SETTING_ON            (0x0001)
+
+/*****************************************************************************
+ *              IO Unit Page 3                                               *
+ ****************************************************************************/
+
+typedef struct _MPI3_IO_UNIT3_SENSOR {
+    U16             Flags;                                      /* 0x00 */
+    U16             Reserved02;                                 /* 0x02 */
+    U16             Threshold[4];                               /* 0x04 */
+    U32             Reserved0C;                                 /* 0x0C */
+    U32             Reserved10;                                 /* 0x10 */
+    U32             Reserved14;                                 /* 0x14 */
+} MPI3_IO_UNIT3_SENSOR, MPI3_POINTER PTR_MPI3_IO_UNIT3_SENSOR,
+  Mpi3IOUnit3Sensor_t, MPI3_POINTER pMpi3IOUnit3Sensor_t;
+
+/**** Defines for the Flags field ****/
+#define MPI3_IOUNIT3_SENSOR_FLAGS_T3_ENABLE         (0x0008)
+#define MPI3_IOUNIT3_SENSOR_FLAGS_T2_ENABLE         (0x0004)
+#define MPI3_IOUNIT3_SENSOR_FLAGS_T1_ENABLE         (0x0002)
+#define MPI3_IOUNIT3_SENSOR_FLAGS_T0_ENABLE         (0x0001)
+
+#ifndef MPI3_IO_UNIT3_SENSOR_MAX
+#define MPI3_IO_UNIT3_SENSOR_MAX        (1)
+#endif  /* MPI3_IO_UNIT3_SENSOR_MAX */
+
+typedef struct _MPI3_IO_UNIT_PAGE3 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                             /* 0x00 */
+    U32                             Reserved08;                         /* 0x08 */
+    U8                              NumSensors;                         /* 0x0C */
+    U8                              PollingInterval;                    /* 0x0D */
+    U16                             Reserved0E;                         /* 0x0E */
+    MPI3_IO_UNIT3_SENSOR            Sensor[MPI3_IO_UNIT3_SENSOR_MAX];   /* 0x10 */
+} MPI3_IO_UNIT_PAGE3, MPI3_POINTER PTR_MPI3_IO_UNIT_PAGE3,
+  Mpi3IOUnitPage3_t, MPI3_POINTER pMpi3IOUnitPage3_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOUNIT3_PAGEVERSION                (0x00)
+
+/*****************************************************************************
+ *              IO Unit Page 4                                               *
+ ****************************************************************************/
+typedef struct _MPI3_IO_UNIT4_SENSOR {
+    U16             CurrentTemperature;     /* 0x00 */
+    U16             Reserved02;             /* 0x02 */
+    U8              Flags;                  /* 0x04 */
+    U8              Reserved05[3];          /* 0x05 */
+    U32             Reserved08;             /* 0x08 */
+    U32             Reserved0C;             /* 0x0C */
+} MPI3_IO_UNIT4_SENSOR, MPI3_POINTER PTR_MPI3_IO_UNIT4_SENSOR,
+  Mpi3IOUnit4Sensor_t, MPI3_POINTER pMpi3IOUnit4Sensor_t;
+
+/**** Defines for the Flags field ****/
+#define MPI3_IOUNIT4_SENSOR_FLAGS_TEMP_VALID        (0x01)
+
+#ifndef MPI3_IO_UNIT4_SENSOR_MAX
+#define MPI3_IO_UNIT4_SENSOR_MAX        (1)
+#endif  /* MPI3_IO_UNIT4_SENSOR_MAX */
+
+typedef struct _MPI3_IO_UNIT_PAGE4 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                             /* 0x00 */
+    U32                             Reserved08;                         /* 0x08 */
+    U8                              NumSensors;                         /* 0x0C */
+    U8                              Reserved0D[3];                      /* 0x0D */
+    MPI3_IO_UNIT4_SENSOR            Sensor[MPI3_IO_UNIT4_SENSOR_MAX];   /* 0x10 */
+} MPI3_IO_UNIT_PAGE4, MPI3_POINTER PTR_MPI3_IO_UNIT_PAGE4,
+  Mpi3IOUnitPage4_t, MPI3_POINTER pMpi3IOUnitPage4_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOUNIT4_PAGEVERSION                (0x00)
+
+/*****************************************************************************
+ *              IO Unit Page 5                                               *
+ ****************************************************************************/
+typedef struct _MPI3_IO_UNIT5_SPINUP_GROUP {
+    U8              MaxTargetSpinup;    /* 0x00 */
+    U8              SpinupDelay;        /* 0x01 */
+    U8              SpinupFlags;        /* 0x02 */
+    U8              Reserved03;         /* 0x03 */
+} MPI3_IO_UNIT5_SPINUP_GROUP, MPI3_POINTER PTR_MPI3_IO_UNIT5_SPINUP_GROUP,
+  Mpi3IOUnit5SpinupGroup_t, MPI3_POINTER pMpi3IOUnit5SpinupGroup_t;
+
+/**** Defines for the SpinupFlags field ****/
+#define MPI3_IOUNIT5_SPINUP_FLAGS_DISABLE       (0x01)
+
+#ifndef MPI3_IO_UNIT5_PHY_MAX
+#define MPI3_IO_UNIT5_PHY_MAX       (4)
+#endif  /* MPI3_IO_UNIT5_PHY_MAX */
+
+typedef struct _MPI3_IO_UNIT_PAGE5 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                     /* 0x00 */
+    MPI3_IO_UNIT5_SPINUP_GROUP      SpinupGroupParameters[4];   /* 0x08 */
+    U32                             Reserved18;                 /* 0x18 */
+    U32                             Reserved1C;                 /* 0x1C */
+    U32                             Reserved20;                 /* 0x20 */
+    U8                              Reserved24;                 /* 0x24 */
+    U8                              SATADeviceWaitTime;         /* 0x25 */
+    U8                              SpinupEnclDriveCount;       /* 0x26 */
+    U8                              SpinupEnclDelay;            /* 0x27 */
+    U8                              NumPhys;                    /* 0x28 */
+    U8                              PEInitialSpinupDelay;       /* 0x29 */
+    U8                              TopologyStableTime;         /* 0x2A */
+    U8                              Flags;                      /* 0x2B */
+    U8                              Phy[MPI3_IO_UNIT5_PHY_MAX]; /* 0x2C */
+} MPI3_IO_UNIT_PAGE5, MPI3_POINTER PTR_MPI3_IO_UNIT_PAGE5,
+  Mpi3IOUnitPage5_t, MPI3_POINTER pMpi3IOUnitPage5_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOUNIT5_PAGEVERSION                           (0x00)
+
+/**** Defines for the Flags field ****/
+#define MPI3_IOUNIT5_FLAGS_POWER_CAPABLE_SPINUP            (0x02)
+#define MPI3_IOUNIT5_FLAGS_AUTO_PORT_ENABLE                (0x01)
+
+/**** Defines for the PHY field ****/
+#define MPI3_IOUNIT5_PHY_SPINUP_GROUP_MASK                 (0x03)
+
+/*****************************************************************************
+ *              IO Unit Page 6                                               *
+ ****************************************************************************/
+typedef struct _MPI3_IO_UNIT_PAGE6 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                     /* 0x00 */
+    U32                             BoardPowerRequirement;      /* 0x08 */
+    U32                             PCISlotPowerAllocation;     /* 0x0C */
+    U8                              Flags;                      /* 0x10 */
+    U8                              Reserved11[3];              /* 0x11 */
+} MPI3_IO_UNIT_PAGE6, MPI3_POINTER PTR_MPI3_IO_UNIT_PAGE6,
+  Mpi3IOUnitPage6_t, MPI3_POINTER pMpi3IOUnitPage6_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOUNIT6_PAGEVERSION                (0x00)
+
+/**** Defines for the Flags field ****/
+#define MPI3_IOUNIT6_FLAGS_ACT_CABLE_PWR_EXC    (0x01)
+
+/*****************************************************************************
+ *              IO Unit Page 7                                               *
+ ****************************************************************************/
+typedef struct _MPI3_IO_UNIT_PAGE7 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                     /* 0x00 */
+    U32                             Reserved08;                 /* 0x08 */
+} MPI3_IO_UNIT_PAGE7, MPI3_POINTER PTR_MPI3_IO_UNIT_PAGE7,
+  Mpi3IOUnitPage7_t, MPI3_POINTER pMpi3IOUnitPage7_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOUNIT7_PAGEVERSION                (0x00)
+
+/*****************************************************************************
+ *              IO Unit Page 8                                               *
+ ****************************************************************************/
+
+#ifndef MPI3_IOUNIT8_DIGEST_MAX
+#define MPI3_IOUNIT8_DIGEST_MAX                   (1)
+#endif  /* MPI3_IOUNIT8_DIGEST_MAX */
+
+typedef union _MPI3_IOUNIT8_DIGEST {
+    U32                             Dword[16];
+    U16                             Word[32];
+    U8                              Byte[64];
+} MPI3_IOUNIT8_DIGEST, MPI3_POINTER PTR_MPI3_IOUNIT8_DIGEST,
+  Mpi3IOUnit8Digest, MPI3_POINTER pMpi3IOUnit8Digest;
+
+typedef struct _MPI3_IO_UNIT_PAGE8 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                             /* 0x00 */
+    U8                              SBMode;                             /* 0x08 */
+    U8                              SbState;                            /* 0x09 */
+    U16                             Reserved0A;                         /* 0x0A */
+    U8                              NumSlots;                           /* 0x0C */
+    U8                              SlotsAvailable;                     /* 0x0D */
+    U8                              CurrentKeyEncryptionAlgo;           /* 0x0E */
+    U8                              KeyDigestHashAlgo;                  /* 0x0F */
+    U32                             Reserved10[2];                      /* 0x10 */
+    U32                             CurrentKey[128];                    /* 0x18 */
+    MPI3_IOUNIT8_DIGEST             Digest[MPI3_IOUNIT8_DIGEST_MAX];   /* 0x218 */  /* variable length */
+} MPI3_IO_UNIT_PAGE8, MPI3_POINTER PTR_MPI3_IO_UNIT_PAGE8,
+  Mpi3IOUnitPage8_t, MPI3_POINTER pMpi3IOUnitPage8_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOUNIT8_PAGEVERSION                  (0x00)
+
+/**** Defines for the SBMode field ****/
+#define MPI3_IOUNIT8_SBMODE_SECURE_DEBUG          (0x04)
+#define MPI3_IOUNIT8_SBMODE_HARD_SECURE           (0x02)
+#define MPI3_IOUNIT8_SBMODE_CONFIG_SECURE         (0x01)
+
+/**** Defines for the SBState field ****/
+#define MPI3_IOUNIT8_SBSTATE_KEY_UPDATE_PENDING   (0x02)
+#define MPI3_IOUNIT8_SBSTATE_SECURE_BOOT_ENABLED  (0x01)
+
+/*****************************************************************************
+ *              IO Unit Page 9                                               *
+ ****************************************************************************/
+
+typedef struct _MPI3_IO_UNIT_PAGE9 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                             /* 0x00 */
+    U32                             Flags;                              /* 0x08 */
+    U16                             FirstDevice;                        /* 0x0C */
+    U16                             Reserved0E;                         /* 0x0E */
+} MPI3_IO_UNIT_PAGE9, MPI3_POINTER PTR_MPI3_IO_UNIT_PAGE9,
+  Mpi3IOUnitPage9_t, MPI3_POINTER pMpi3IOUnitPage9_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOUNIT9_PAGEVERSION                  (0x00)
+
+/**** Defines for the Flags field ****/
+#define MPI3_IOUNIT9_FLAGS_VDFIRST_ENABLED         (0x01)
+
+/**** Defines for the FirstDevice field ****/
+#define MPI3_IOUNIT9_FIRSTDEVICE_UNKNOWN          (0xFFFF)
+
+/*****************************************************************************
+ *              IOC Configuration Pages                                      *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              IOC Page 0                                                   *
+ ****************************************************************************/
+typedef struct _MPI3_IOC_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                 /* 0x00 */
+    U32                             Reserved08;             /* 0x08 */
+    U16                             VendorID;               /* 0x0C */
+    U16                             DeviceID;               /* 0x0E */
+    U8                              RevisionID;             /* 0x10 */
+    U8                              Reserved11[3];          /* 0x11 */
+    U32                             ClassCode;              /* 0x14 */
+    U16                             SubsystemVendorID;      /* 0x18 */
+    U16                             SubsystemID;            /* 0x1A */
+} MPI3_IOC_PAGE0, MPI3_POINTER PTR_MPI3_IOC_PAGE0,
+  Mpi3IOCPage0_t, MPI3_POINTER pMpi3IOCPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOC0_PAGEVERSION               (0x00)
+
+/*****************************************************************************
+ *              IOC Page 1                                                   *
+ ****************************************************************************/
+typedef struct _MPI3_IOC_PAGE1 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                 /* 0x00 */
+    U32                             CoalescingTimeout;      /* 0x08 */
+    U8                              CoalescingDepth;        /* 0x0C */
+    U8                              PCISlotNum;             /* 0x0D */
+    U16                             Reserved0E;             /* 0x0E */
+} MPI3_IOC_PAGE1, MPI3_POINTER PTR_MPI3_IOC_PAGE1,
+  Mpi3IOCPage1_t, MPI3_POINTER pMpi3IOCPage1_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOC1_PAGEVERSION               (0x00)
+
+/**** Defines for the PCISlotNum field ****/
+#define MPI3_IOC1_PCISLOTNUM_UNKNOWN        (0xFF)
+
+/*****************************************************************************
+ *              IOC Page 2                                                   *
+ ****************************************************************************/
+#ifndef MPI3_IOC2_EVENTMASK_WORDS
+#define MPI3_IOC2_EVENTMASK_WORDS           (4)
+#endif  /* MPI3_IOC2_EVENTMASK_WORDS */
+
+typedef struct _MPI3_IOC_PAGE2 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                 /* 0x00 */
+    U32                             Reserved08;                             /* 0x08 */
+    U16                             SASBroadcastPrimitiveMasks;             /* 0x0C */
+    U16                             SASNotifyPrimitiveMasks;                /* 0x0E */
+    U32                             EventMasks[MPI3_IOC2_EVENTMASK_WORDS];  /* 0x10 */
+} MPI3_IOC_PAGE2, MPI3_POINTER PTR_MPI3_IOC_PAGE2,
+  Mpi3IOCPage2_t, MPI3_POINTER pMpi3IOCPage2_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_IOC2_PAGEVERSION               (0x00)
+
+
+/*****************************************************************************
+ *              UEFI BSD and HII Configuration Pages                         *
+ ****************************************************************************/
+typedef struct _MPI3_UEFIBSD_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;             /* 0x00 */
+    U32                             BSDOptions;         /* 0x08 */
+    U8                              SSUTimeout;         /* 0x0C */
+    U8                              IOTimeout;          /* 0x0D */
+    U8                              TURRetries;         /* 0x0E */
+    U8                              TURInterval;        /* 0x0F */
+    U8                              Reserved10;         /* 0x10 */
+    U8                              SecurityKeyTimeout; /* 0x11 */
+    U16                             Reserved12;         /* 0x12 */
+    U32                             Reserved14;         /* 0x14 */
+    U32                             Reserved18;         /* 0x18 */
+} MPI3_UEFIBSD_PAGE0, MPI3_POINTER PTR_MPI3_UEFIBSD_PAGE0,
+  Mpi3UefiBsdPage0_t, MPI3_POINTER pMpi3UefiBsdPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_UEFIBSD_PAGEVERSION               (0x00)
+
+/**** Defines for the BSDOptions field ****/
+#define MPI3_UEFIBSD_BSDOPTS_REGISTRATION_MASK              (0x00000003)
+#define MPI3_UEFIBSD_BSDOPTS_REGISTRATION_IOC_AND_DEVS      (0x00000000)
+#define MPI3_UEFIBSD_BSDOPTS_REGISTRATION_IOC_ONLY          (0x00000001)
+#define MPI3_UEFIBSD_BSDOPTS_REGISTRATION_NONE              (0x00000002)
+#define MPI3_UEFIBSD_BSDOPTS_DIS_HII_CONFIG_UTIL            (0x00000004)
+#define MPI3_UEFIBSD_BSDOPTS_EN_ADV_ADAPTER_CONFIG          (0x00000008)
+
+
+/*****************************************************************************
+ *              Security Configuration Pages                                *
+ ****************************************************************************/
+
+typedef union _MPI3_SECURITY_MAC {
+    U32                             Dword[16];
+    U16                             Word[32];
+    U8                              Byte[64];
+} MPI3_SECURITY_MAC, MPI3_POINTER PTR_MPI3_SECURITY_MAC,
+  Mpi3SecurityMAC_t, MPI3_POINTER pMpi3SecurityMAC_t;
+
+typedef union _MPI3_SECURITY_NONCE {
+    U32                             Dword[16];
+    U16                             Word[32];
+    U8                              Byte[64];
+} MPI3_SECURITY_NONCE, MPI3_POINTER PTR_MPI3_SECURITY_NONCE,
+  Mpi3SecurityNonce_t, MPI3_POINTER pMpi3SecurityNonce_t;
+
+/*****************************************************************************
+ *              Security Page 0                                             *
+ ****************************************************************************/
+
+typedef union _MPI3_SECURITY0_CERT_CHAIN {
+    U32                             Dword[1024];
+    U16                             Word[2048];
+    U8                              Byte[4096];
+} MPI3_SECURITY0_CERT_CHAIN, MPI3_POINTER PTR_MPI3_SECURITY0_CERT_CHAIN,
+  Mpi3Security0CertChain_t, MPI3_POINTER pMpi3Security0CertChain_t;
+
+typedef struct _MPI3_SECURITY_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                 /* 0x00 */
+    U8                              SlotNumGroup;                           /* 0x08 */
+    U8                              SlotNum;                                /* 0x09 */
+    U16                             CertChainLength;                        /* 0x0A */
+    U8                              CertChainFlags;                         /* 0x0C */
+    U8                              Reserved0D[3];                          /* 0x0D */
+    U32                             BaseAsymAlgo;                           /* 0x10 */
+    U32                             BaseHashAlgo;                           /* 0x14 */
+    U32                             Reserved18[4];                          /* 0x18 */
+    MPI3_SECURITY_MAC               MAC;                                    /* 0x28 */
+    MPI3_SECURITY_NONCE             Nonce;                                  /* 0x68 */
+    MPI3_SECURITY0_CERT_CHAIN       CertificateChain;                       /* 0xA8 */
+} MPI3_SECURITY_PAGE0, MPI3_POINTER PTR_MPI3_SECURITY_PAGE0,
+  Mpi3SecurityPage0_t, MPI3_POINTER pMpi3SecurityPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SECURITY0_PAGEVERSION               (0x00)
+
+/**** Defines for the CertChainFlags field ****/
+#define MPI3_SECURITY0_CERTCHAIN_FLAGS_AUTH_API_MASK       (0x0E)
+#define MPI3_SECURITY0_CERTCHAIN_FLAGS_AUTH_API_UNUSED     (0x00)
+#define MPI3_SECURITY0_CERTCHAIN_FLAGS_AUTH_API_CERBERUS   (0x02)
+#define MPI3_SECURITY0_CERTCHAIN_FLAGS_AUTH_API_SPDM       (0x04)
+#define MPI3_SECURITY0_CERTCHAIN_FLAGS_SEALED              (0x01)
+
+/*****************************************************************************
+ *              Security Page 1                                             *
+ ****************************************************************************/
+
+#ifndef MPI3_SECURITY1_KEY_RECORD_MAX
+#define MPI3_SECURITY1_KEY_RECORD_MAX      1
+#endif  /* MPI3_SECURITY1_KEY_RECORD_MAX */
+
+#ifndef MPI3_SECURITY1_PAD_MAX
+#define MPI3_SECURITY1_PAD_MAX      1
+#endif  /* MPI3_SECURITY1_PAD_MAX */
+
+typedef union _MPI3_SECURITY1_KEY_DATA {
+    U32                             Dword[128];
+    U16                             Word[256];
+    U8                              Byte[512];
+} MPI3_SECURITY1_KEY_DATA, MPI3_POINTER PTR_MPI3_SECURITY1_KEY_DATA,
+  Mpi3Security1KeyData_t, MPI3_POINTER pMpi3Security1KeyData_t;
+
+typedef struct _MPI3_SECURITY1_KEY_RECORD {
+    U8                              Flags;                                  /* 0x00 */
+    U8                              Consumer;                               /* 0x01 */
+    U16                             KeyDataSize;                            /* 0x02 */
+    U32                             AdditionalKeyData;                      /* 0x04 */
+    U32                             Reserved08[2];                          /* 0x08 */
+    MPI3_SECURITY1_KEY_DATA         KeyData;                                /* 0x10 */
+} MPI3_SECURITY1_KEY_RECORD, MPI3_POINTER PTR_MPI3_SECURITY1_KEY_RECORD,
+  Mpi3Security1KeyRecord_t, MPI3_POINTER pMpi3Security1KeyRecord_t;
+
+/**** Defines for the Flags field ****/
+#define MPI3_SECURITY1_KEY_RECORD_FLAGS_TYPE_MASK            (0x1F)
+#define MPI3_SECURITY1_KEY_RECORD_FLAGS_TYPE_NOT_VALID       (0x00)
+#define MPI3_SECURITY1_KEY_RECORD_FLAGS_TYPE_HMAC            (0x01)
+#define MPI3_SECURITY1_KEY_RECORD_FLAGS_TYPE_AES             (0x02)
+#define MPI3_SECURITY1_KEY_RECORD_FLAGS_TYPE_ECDSA_PRIVATE   (0x03)
+#define MPI3_SECURITY1_KEY_RECORD_FLAGS_TYPE_ECDSA_PUBLIC    (0x04)
+
+/**** Defines for the Consumer field ****/
+#define MPI3_SECURITY1_KEY_RECORD_CONSUMER_NOT_VALID         (0x00)
+#define MPI3_SECURITY1_KEY_RECORD_CONSUMER_SAFESTORE         (0x01)
+#define MPI3_SECURITY1_KEY_RECORD_CONSUMER_CERT_CHAIN        (0x02)
+#define MPI3_SECURITY1_KEY_RECORD_CONSUMER_AUTH_DEV_KEY      (0x03)
+#define MPI3_SECURITY1_KEY_RECORD_CONSUMER_CACHE_OFFLOAD     (0x04)
+
+typedef struct _MPI3_SECURITY_PAGE1 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                     /* 0x00 */
+    U32                             Reserved08[2];                              /* 0x08 */
+    MPI3_SECURITY_MAC               MAC;                                        /* 0x10 */
+    MPI3_SECURITY_NONCE             Nonce;                                      /* 0x50 */
+    U8                              NumKeys;                                    /* 0x90 */
+    U8                              Reserved91[3];                              /* 0x91 */
+    U32                             Reserved94[3];                              /* 0x94 */
+    MPI3_SECURITY1_KEY_RECORD       KeyRecord[MPI3_SECURITY1_KEY_RECORD_MAX];   /* 0xA0 */
+    U8                              Pad[MPI3_SECURITY1_PAD_MAX];                /* ??  */
+} MPI3_SECURITY_PAGE1, MPI3_POINTER PTR_MPI3_SECURITY_PAGE1,
+  Mpi3SecurityPage1_t, MPI3_POINTER pMpi3SecurityPage1_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SECURITY1_PAGEVERSION               (0x00)
+
+/*****************************************************************************
+ *              SAS IO Unit Configuration Pages                              *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              SAS IO Unit Page 0                                           *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_IO_UNIT0_PHY_DATA {
+    U8              IOUnitPort;                         /* 0x00 */
+    U8              PortFlags;                          /* 0x01 */
+    U8              PhyFlags;                           /* 0x02 */
+    U8              NegotiatedLinkRate;                 /* 0x03 */
+    U16             ControllerPhyDeviceInfo;            /* 0x04 */
+    U16             Reserved06;                         /* 0x06 */
+    U16             AttachedDevHandle;                  /* 0x08 */
+    U16             ControllerDevHandle;                /* 0x0A */
+    U32             DiscoveryStatus;                    /* 0x0C */
+    U32             Reserved10;                         /* 0x10 */
+} MPI3_SAS_IO_UNIT0_PHY_DATA, MPI3_POINTER PTR_MPI3_SAS_IO_UNIT0_PHY_DATA,
+  Mpi3SasIOUnit0PhyData_t, MPI3_POINTER pMpi3SasIOUnit0PhyData_t;
+
+#ifndef MPI3_SAS_IO_UNIT0_PHY_MAX
+#define MPI3_SAS_IO_UNIT0_PHY_MAX           (1)
+#endif  /* MPI3_SAS_IO_UNIT0_PHY_MAX */
+
+typedef struct _MPI3_SAS_IO_UNIT_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                 /* 0x00 */
+    U32                             Reserved08;                             /* 0x08 */
+    U8                              NumPhys;                                /* 0x0C */
+    U8                              Reserved0D[3];                          /* 0x0D */
+    MPI3_SAS_IO_UNIT0_PHY_DATA      PhyData[MPI3_SAS_IO_UNIT0_PHY_MAX];     /* 0x10 */
+} MPI3_SAS_IO_UNIT_PAGE0, MPI3_POINTER PTR_MPI3_SAS_IO_UNIT_PAGE0,
+  Mpi3SasIOUnitPage0_t, MPI3_POINTER pMpi3SasIOUnitPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASIOUNIT0_PAGEVERSION                         (0x00)
+
+/**** Defines for the PortFlags field ****/
+#define MPI3_SASIOUNIT0_PORTFLAGS_DISC_IN_PROGRESS          (0x08)
+#define MPI3_SASIOUNIT0_PORTFLAGS_AUTO_PORT_CONFIG          (0x01)
+
+/**** Defines for the PhyFlags field ****/
+#define MPI3_SASIOUNIT0_PHYFLAGS_INIT_PERSIST_CONNECT       (0x40)
+#define MPI3_SASIOUNIT0_PHYFLAGS_TARG_PERSIST_CONNECT       (0x20)
+#define MPI3_SASIOUNIT0_PHYFLAGS_PHY_DISABLED               (0x08)
+
+/**** Use MPI3_SAS_NEG_LINK_RATE_ defines for the NegotiatedLinkRate field ****/
+
+/**** Use MPI3_SAS_DEVICE_INFO_ defines (see mpi30_sas.h) for the ControllerPhyDeviceInfo field ****/
+
+/**** Use MPI3_SAS_DISC_STATUS_ defines (see mpi30_ioc.h) for the DiscoveryStatus field ****/
+
+/*****************************************************************************
+ *              SAS IO Unit Page 1                                           *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_IO_UNIT1_PHY_DATA {
+    U8              IOUnitPort;                         /* 0x00 */
+    U8              PortFlags;                          /* 0x01 */
+    U8              PhyFlags;                           /* 0x02 */
+    U8              MaxMinLinkRate;                     /* 0x03 */
+    U16             ControllerPhyDeviceInfo;            /* 0x04 */
+    U16             MaxTargetPortConnectTime;           /* 0x06 */
+    U32             Reserved08;                         /* 0x08 */
+} MPI3_SAS_IO_UNIT1_PHY_DATA, MPI3_POINTER PTR_MPI3_SAS_IO_UNIT1_PHY_DATA,
+  Mpi3SasIOUnit1PhyData_t, MPI3_POINTER pMpi3SasIOUnit1PhyData_t;
+
+#ifndef MPI3_SAS_IO_UNIT1_PHY_MAX
+#define MPI3_SAS_IO_UNIT1_PHY_MAX           (1)
+#endif  /* MPI3_SAS_IO_UNIT1_PHY_MAX */
+
+typedef struct _MPI3_SAS_IO_UNIT_PAGE1 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                 /* 0x00 */
+    U16                             ControlFlags;                           /* 0x08 */
+    U16                             SASNarrowMaxQueueDepth;                 /* 0x0A */
+    U16                             AdditionalControlFlags;                 /* 0x0C */
+    U16                             SASWideMaxQueueDepth;                   /* 0x0E */
+    U8                              NumPhys;                                /* 0x10 */
+    U8                              SATAMaxQDepth;                          /* 0x11 */
+    U16                             Reserved12;                             /* 0x12 */
+    MPI3_SAS_IO_UNIT1_PHY_DATA      PhyData[MPI3_SAS_IO_UNIT1_PHY_MAX];     /* 0x14 */
+} MPI3_SAS_IO_UNIT_PAGE1, MPI3_POINTER PTR_MPI3_SAS_IO_UNIT_PAGE1,
+  Mpi3SasIOUnitPage1_t, MPI3_POINTER pMpi3SasIOUnitPage1_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASIOUNIT1_PAGEVERSION                                 (0x00)
+
+/**** Defines for the ControlFlags field ****/
+#define MPI3_SASIOUNIT1_CONTROL_CONTROLLER_DEVICE_SELF_TEST         (0x8000)
+#define MPI3_SASIOUNIT1_CONTROL_SATA_SW_PRESERVE                    (0x1000)
+#define MPI3_SASIOUNIT1_CONTROL_SATA_48BIT_LBA_REQUIRED             (0x0080)
+#define MPI3_SASIOUNIT1_CONTROL_SATA_SMART_REQUIRED                 (0x0040)
+#define MPI3_SASIOUNIT1_CONTROL_SATA_NCQ_REQUIRED                   (0x0020)
+#define MPI3_SASIOUNIT1_CONTROL_SATA_FUA_REQUIRED                   (0x0010)
+#define MPI3_SASIOUNIT1_CONTROL_TABLE_SUBTRACTIVE_ILLEGAL           (0x0008)
+#define MPI3_SASIOUNIT1_CONTROL_SUBTRACTIVE_ILLEGAL                 (0x0004)
+#define MPI3_SASIOUNIT1_CONTROL_FIRST_LVL_DISC_ONLY                 (0x0002)
+#define MPI3_SASIOUNIT1_CONTROL_HARD_RESET_MASK                     (0x0001)
+#define MPI3_SASIOUNIT1_CONTROL_HARD_RESET_DEVICE_NAME              (0x0000)
+#define MPI3_SASIOUNIT1_CONTROL_HARD_RESET_SAS_ADDRESS              (0x0001)
+
+/**** Defines for the AdditionalControlFlags field ****/
+#define MPI3_SASIOUNIT1_ACONTROL_DA_PERSIST_CONNECT                 (0x0100)
+#define MPI3_SASIOUNIT1_ACONTROL_MULTI_PORT_DOMAIN_ILLEGAL          (0x0080)
+#define MPI3_SASIOUNIT1_ACONTROL_SATA_ASYNCHROUNOUS_NOTIFICATION    (0x0040)
+#define MPI3_SASIOUNIT1_ACONTROL_INVALID_TOPOLOGY_CORRECTION        (0x0020)
+#define MPI3_SASIOUNIT1_ACONTROL_PORT_ENABLE_ONLY_SATA_LINK_RESET   (0x0010)
+#define MPI3_SASIOUNIT1_ACONTROL_OTHER_AFFILIATION_SATA_LINK_RESET  (0x0008)
+#define MPI3_SASIOUNIT1_ACONTROL_SELF_AFFILIATION_SATA_LINK_RESET   (0x0004)
+#define MPI3_SASIOUNIT1_ACONTROL_NO_AFFILIATION_SATA_LINK_RESET     (0x0002)
+#define MPI3_SASIOUNIT1_ACONTROL_ALLOW_TABLE_TO_TABLE               (0x0001)
+
+/**** Defines for the PortFlags field ****/
+#define MPI3_SASIOUNIT1_PORT_FLAGS_AUTO_PORT_CONFIG                 (0x01)
+
+/**** Defines for the PhyFlags field ****/
+#define MPI3_SASIOUNIT1_PHYFLAGS_INIT_PERSIST_CONNECT               (0x40)
+#define MPI3_SASIOUNIT1_PHYFLAGS_TARG_PERSIST_CONNECT               (0x20)
+#define MPI3_SASIOUNIT1_PHYFLAGS_PHY_DISABLE                        (0x08)
+
+/**** Defines for the MaxMinLinkRate field ****/
+#define MPI3_SASIOUNIT1_MMLR_MAX_RATE_MASK                          (0xF0)
+#define MPI3_SASIOUNIT1_MMLR_MAX_RATE_SHIFT                         (4)
+#define MPI3_SASIOUNIT1_MMLR_MAX_RATE_6_0                           (0xA0)
+#define MPI3_SASIOUNIT1_MMLR_MAX_RATE_12_0                          (0xB0)
+#define MPI3_SASIOUNIT1_MMLR_MAX_RATE_22_5                          (0xC0)
+#define MPI3_SASIOUNIT1_MMLR_MIN_RATE_MASK                          (0x0F)
+#define MPI3_SASIOUNIT1_MMLR_MIN_RATE_6_0                           (0x0A)
+#define MPI3_SASIOUNIT1_MMLR_MIN_RATE_12_0                          (0x0B)
+#define MPI3_SASIOUNIT1_MMLR_MIN_RATE_22_5                          (0x0C)
+
+/**** Use MPI3_SAS_DEVICE_INFO_ defines (see mpi30_sas.h) for the ControllerPhyDeviceInfo field ****/
+
+/*****************************************************************************
+ *              SAS IO Unit Page 2                                           *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_IO_UNIT2_PHY_PM_SETTINGS {
+    U8              ControlFlags;                       /* 0x00 */
+    U8              Reserved01;                         /* 0x01 */
+    U16             InactivityTimerExponent;            /* 0x02 */
+    U8              SATAPartialTimeout;                 /* 0x04 */
+    U8              Reserved05;                         /* 0x05 */
+    U8              SATASlumberTimeout;                 /* 0x06 */
+    U8              Reserved07;                         /* 0x07 */
+    U8              SASPartialTimeout;                  /* 0x08 */
+    U8              Reserved09;                         /* 0x09 */
+    U8              SASSlumberTimeout;                  /* 0x0A */
+    U8              Reserved0B;                         /* 0x0B */
+} MPI3_SAS_IO_UNIT2_PHY_PM_SETTINGS, MPI3_POINTER PTR_MPI3_SAS_IO_UNIT2_PHY_PM_SETTINGS,
+  Mpi3SasIOUnit2PhyPmSettings_t, MPI3_POINTER pMpi3SasIOUnit2PhyPmSettings_t;
+
+#ifndef MPI3_SAS_IO_UNIT2_PHY_MAX
+#define MPI3_SAS_IO_UNIT2_PHY_MAX           (1)
+#endif  /* MPI3_SAS_IO_UNIT2_PHY_MAX */
+
+typedef struct _MPI3_SAS_IO_UNIT_PAGE2 {
+    MPI3_CONFIG_PAGE_HEADER             Header;                                                     /* 0x00 */
+    U8                                  NumPhys;                                                    /* 0x08 */
+    U8                                  Reserved09[3];                                              /* 0x09 */
+    U32                                 Reserved0C;                                                 /* 0x0C */
+    MPI3_SAS_IO_UNIT2_PHY_PM_SETTINGS   SASPhyPowerManagementSettings[MPI3_SAS_IO_UNIT2_PHY_MAX];   /* 0x10 */
+} MPI3_SAS_IO_UNIT_PAGE2, MPI3_POINTER PTR_MPI3_SAS_IO_UNIT_PAGE2,
+  Mpi3SasIOUnitPage2_t, MPI3_POINTER pMpi3SasIOUnitPage2_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASIOUNIT2_PAGEVERSION                     (0x00)
+
+/**** Defines for the ControlFlags field ****/
+#define MPI3_SASIOUNIT2_CONTROL_SAS_SLUMBER_ENABLE      (0x08)
+#define MPI3_SASIOUNIT2_CONTROL_SAS_PARTIAL_ENABLE      (0x04)
+#define MPI3_SASIOUNIT2_CONTROL_SATA_SLUMBER_ENABLE     (0x02)
+#define MPI3_SASIOUNIT2_CONTROL_SATA_PARTIAL_ENABLE     (0x01)
+
+/**** Defines for the InactivityTimerExponent field ****/
+#define MPI3_SASIOUNIT2_ITE_SAS_SLUMBER_MASK            (0x7000)
+#define MPI3_SASIOUNIT2_ITE_SAS_SLUMBER_SHIFT           (12)
+#define MPI3_SASIOUNIT2_ITE_SAS_PARTIAL_MASK            (0x0700)
+#define MPI3_SASIOUNIT2_ITE_SAS_PARTIAL_SHIFT           (8)
+#define MPI3_SASIOUNIT2_ITE_SATA_SLUMBER_MASK           (0x0070)
+#define MPI3_SASIOUNIT2_ITE_SATA_SLUMBER_SHIFT          (4)
+#define MPI3_SASIOUNIT2_ITE_SATA_PARTIAL_MASK           (0x0007)
+#define MPI3_SASIOUNIT2_ITE_SATA_PARTIAL_SHIFT          (0)
+
+#define MPI3_SASIOUNIT2_ITE_EXP_TEN_SECONDS             (7)
+#define MPI3_SASIOUNIT2_ITE_EXP_ONE_SECOND              (6)
+#define MPI3_SASIOUNIT2_ITE_EXP_HUNDRED_MILLISECONDS    (5)
+#define MPI3_SASIOUNIT2_ITE_EXP_TEN_MILLISECONDS        (4)
+#define MPI3_SASIOUNIT2_ITE_EXP_ONE_MILLISECOND         (3)
+#define MPI3_SASIOUNIT2_ITE_EXP_HUNDRED_MICROSECONDS    (2)
+#define MPI3_SASIOUNIT2_ITE_EXP_TEN_MICROSECONDS        (1)
+#define MPI3_SASIOUNIT2_ITE_EXP_ONE_MICROSECOND         (0)
+
+/*****************************************************************************
+ *              SAS IO Unit Page 3                                           *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_IO_UNIT_PAGE3 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                         /* 0x00 */
+    U32                             Reserved08;                     /* 0x08 */
+    U32                             PowerManagementCapabilities;    /* 0x0C */
+} MPI3_SAS_IO_UNIT_PAGE3, MPI3_POINTER PTR_MPI3_SAS_IO_UNIT_PAGE3,
+  Mpi3SasIOUnitPage3_t, MPI3_POINTER pMpi3SasIOUnitPage3_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASIOUNIT3_PAGEVERSION                     (0x00)
+
+/**** Defines for the PowerManagementCapabilities field ****/
+#define MPI3_SASIOUNIT3_PM_HOST_SAS_SLUMBER_MODE        (0x00000800)
+#define MPI3_SASIOUNIT3_PM_HOST_SAS_PARTIAL_MODE        (0x00000400)
+#define MPI3_SASIOUNIT3_PM_HOST_SATA_SLUMBER_MODE       (0x00000200)
+#define MPI3_SASIOUNIT3_PM_HOST_SATA_PARTIAL_MODE       (0x00000100)
+#define MPI3_SASIOUNIT3_PM_IOUNIT_SAS_SLUMBER_MODE      (0x00000008)
+#define MPI3_SASIOUNIT3_PM_IOUNIT_SAS_PARTIAL_MODE      (0x00000004)
+#define MPI3_SASIOUNIT3_PM_IOUNIT_SATA_SLUMBER_MODE     (0x00000002)
+#define MPI3_SASIOUNIT3_PM_IOUNIT_SATA_PARTIAL_MODE     (0x00000001)
+
+
+/*****************************************************************************
+ *              SAS Expander Configuration Pages                             *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              SAS Expander Page 0                                          *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_EXPANDER_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                         /* 0x00 */
+    U8                              IOUnitPort;                     /* 0x08 */
+    U8                              ReportGenLength;                /* 0x09 */
+    U16                             EnclosureHandle;                /* 0x0A */
+    U32                             Reserved0C;                     /* 0x0C */
+    U64                             SASAddress;                     /* 0x10 */
+    U32                             DiscoveryStatus;                /* 0x18 */
+    U16                             DevHandle;                      /* 0x1C */
+    U16                             ParentDevHandle;                /* 0x1E */
+    U16                             ExpanderChangeCount;            /* 0x20 */
+    U16                             ExpanderRouteIndexes;           /* 0x22 */
+    U8                              NumPhys;                        /* 0x24 */
+    U8                              SASLevel;                       /* 0x25 */
+    U16                             Flags;                          /* 0x26 */
+    U16                             STPBusInactivityTimeLimit;      /* 0x28 */
+    U16                             STPMaxConnectTimeLimit;         /* 0x2A */
+    U16                             STP_SMP_NexusLossTime;          /* 0x2C */
+    U16                             MaxNumRoutedSASAddresses;       /* 0x2E */
+    U64                             ActiveZoneManagerSASAddress;    /* 0x30 */
+    U16                             ZoneLockInactivityLimit;        /* 0x38 */
+    U16                             Reserved3A;                     /* 0x3A */
+    U8                              TimeToReducedFunc;              /* 0x3C */
+    U8                              InitialTimeToReducedFunc;       /* 0x3D */
+    U8                              MaxReducedFuncTime;             /* 0x3E */
+    U8                              ExpStatus;                      /* 0x3F */
+} MPI3_SAS_EXPANDER_PAGE0, MPI3_POINTER PTR_MPI3_SAS_EXPANDER_PAGE0,
+  Mpi3SasExpanderPage0_t, MPI3_POINTER pMpi3SasExpanderPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASEXPANDER0_PAGEVERSION                       (0x00)
+
+/**** Use MPI3_SAS_DISC_STATUS_ defines (see mpi30_ioc.h) for the DiscoveryStatus field ****/
+
+/**** Defines for the Flags field ****/
+#define MPI3_SASEXPANDER0_FLAGS_REDUCED_FUNCTIONALITY       (0x2000)
+#define MPI3_SASEXPANDER0_FLAGS_ZONE_LOCKED                 (0x1000)
+#define MPI3_SASEXPANDER0_FLAGS_SUPPORTED_PHYSICAL_PRES     (0x0800)
+#define MPI3_SASEXPANDER0_FLAGS_ASSERTED_PHYSICAL_PRES      (0x0400)
+#define MPI3_SASEXPANDER0_FLAGS_ZONING_SUPPORT              (0x0200)
+#define MPI3_SASEXPANDER0_FLAGS_ENABLED_ZONING              (0x0100)
+#define MPI3_SASEXPANDER0_FLAGS_TABLE_TO_TABLE_SUPPORT      (0x0080)
+#define MPI3_SASEXPANDER0_FLAGS_CONNECTOR_END_DEVICE        (0x0010)
+#define MPI3_SASEXPANDER0_FLAGS_OTHERS_CONFIG               (0x0004)
+#define MPI3_SASEXPANDER0_FLAGS_CONFIG_IN_PROGRESS          (0x0002)
+#define MPI3_SASEXPANDER0_FLAGS_ROUTE_TABLE_CONFIG          (0x0001)
+
+/**** Defines for the ExpStatus field ****/
+#define MPI3_SASEXPANDER0_ES_NOT_RESPONDING                 (0x02)
+#define MPI3_SASEXPANDER0_ES_RESPONDING                     (0x03)
+#define MPI3_SASEXPANDER0_ES_DELAY_NOT_RESPONDING           (0x04)
+
+/*****************************************************************************
+ *              SAS Expander Page 1                                          *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_EXPANDER_PAGE1 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                     /* 0x00 */
+    U8                              IOUnitPort;                 /* 0x08 */
+    U8                              Reserved09[3];              /* 0x09 */
+    U8                              NumPhys;                    /* 0x0C */
+    U8                              Phy;                        /* 0x0D */
+    U16                             NumTableEntriesProgrammed;  /* 0x0E */
+    U8                              ProgrammedLinkRate;         /* 0x10 */
+    U8                              HwLinkRate;                 /* 0x11 */
+    U16                             AttachedDevHandle;          /* 0x12 */
+    U32                             PhyInfo;                    /* 0x14 */
+    U16                             AttachedDeviceInfo;         /* 0x18 */
+    U16                             Reserved1A;                 /* 0x1A */
+    U16                             ExpanderDevHandle;          /* 0x1C */
+    U8                              ChangeCount;                /* 0x1E */
+    U8                              NegotiatedLinkRate;         /* 0x1F */
+    U8                              PhyIdentifier;              /* 0x20 */
+    U8                              AttachedPhyIdentifier;      /* 0x21 */
+    U8                              Reserved22;                 /* 0x22 */
+    U8                              DiscoveryInfo;              /* 0x23 */
+    U32                             AttachedPhyInfo;            /* 0x24 */
+    U8                              ZoneGroup;                  /* 0x28 */
+    U8                              SelfConfigStatus;           /* 0x29 */
+    U16                             Reserved2A;                 /* 0x2A */
+    U16                             Slot;                       /* 0x2C */
+    U16                             SlotIndex;                  /* 0x2E */
+} MPI3_SAS_EXPANDER_PAGE1, MPI3_POINTER PTR_MPI3_SAS_EXPANDER_PAGE1,
+  Mpi3SasExpanderPage1_t, MPI3_POINTER pMpi3SasExpanderPage1_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASEXPANDER1_PAGEVERSION                   (0x00)
+
+/**** Defines for the ProgrammedLinkRate field - use MPI3_SAS_PRATE_ defines ****/
+
+/**** Defines for the HwLinkRate field - use MPI3_SAS_HWRATE_ defines ****/
+
+/**** Defines for the PhyInfo field - use MPI3_SAS_PHYINFO_ defines ****/
+
+/**** Defines for the AttachedDeviceInfo field - use MPI3_SAS_DEVICE_INFO_ defines ****/
+
+/**** Defines for the NegotiatedLinkRate field - use MPI3_SAS_NEG_LINK_RATE_ defines ****/
+
+/**** Defines for the DiscoveryInfo field ****/
+#define MPI3_SASEXPANDER1_DISCINFO_BAD_PHY_DISABLED     (0x04)
+#define MPI3_SASEXPANDER1_DISCINFO_LINK_STATUS_CHANGE   (0x02)
+#define MPI3_SASEXPANDER1_DISCINFO_NO_ROUTING_ENTRIES   (0x01)
+
+/**** Defines for the AttachedPhyInfo field - use MPI3_SAS_APHYINFO_ defines ****/
+
+/**** Defines for the Slot field - use MPI3_SLOT_ defines ****/
+
+/**** Defines for the SlotIndex field - use MPI3_SLOT_INDEX_ ****/
+
+
+/*****************************************************************************
+ *              SAS Port Configuration Pages                                 *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              SAS Port Page 0                                              *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_PORT_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                 /* 0x00 */
+    U8                              PortNumber;             /* 0x08 */
+    U8                              Reserved09;             /* 0x09 */
+    U8                              PortWidth;              /* 0x0A */
+    U8                              Reserved0B;             /* 0x0B */
+    U8                              ZoneGroup;              /* 0x0C */
+    U8                              Reserved0D[3];          /* 0x0D */
+    U64                             SASAddress;             /* 0x10 */
+    U16                             DeviceInfo;             /* 0x18 */
+    U16                             Reserved1A;             /* 0x1A */
+    U32                             Reserved1C;             /* 0x1C */
+} MPI3_SAS_PORT_PAGE0, MPI3_POINTER PTR_MPI3_SAS_PORT_PAGE0,
+  Mpi3SasPortPage0, MPI3_POINTER pMpi3SasPortPage0;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASPORT0_PAGEVERSION                       (0x00)
+
+/**** Defines for the DeviceInfo field - use MPI3_SAS_DEVICE_INFO_ defines ****/
+
+/*****************************************************************************
+ *              SAS PHY Configuration Pages                                  *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              SAS PHY Page 0                                               *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_PHY_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                 /* 0x00 */
+    U16                             OwnerDevHandle;         /* 0x08 */
+    U16                             Reserved0A;             /* 0x0A */
+    U16                             AttachedDevHandle;      /* 0x0C */
+    U8                              AttachedPhyIdentifier;  /* 0x0E */
+    U8                              Reserved0F;             /* 0x0F */
+    U32                             AttachedPhyInfo;        /* 0x10 */
+    U8                              ProgrammedLinkRate;     /* 0x14 */
+    U8                              HwLinkRate;             /* 0x15 */
+    U8                              ChangeCount;            /* 0x16 */
+    U8                              Flags;                  /* 0x17 */
+    U32                             PhyInfo;                /* 0x18 */
+    U8                              NegotiatedLinkRate;     /* 0x1C */
+    U8                              Reserved1D[3];          /* 0x1D */
+    U16                             Slot;                   /* 0x20 */
+    U16                             SlotIndex;              /* 0x22 */
+} MPI3_SAS_PHY_PAGE0, MPI3_POINTER PTR_MPI3_SAS_PHY_PAGE0,
+  Mpi3SasPhyPage0_t, MPI3_POINTER pMpi3SasPhyPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASPHY0_PAGEVERSION                        (0x00)
+
+/**** Defines for the AttachedPhyInfo field - use MPI3_SAS_APHYINFO_ defines ****/
+
+/**** Defines for the ProgrammedLinkRate field - use MPI3_SAS_PRATE_ defines ****/
+
+/**** Defines for the HwLinkRate field - use MPI3_SAS_HWRATE_ defines ****/
+
+/**** Defines for the Flags field ****/
+#define MPI3_SASPHY0_FLAGS_SGPIO_DIRECT_ATTACH_ENC      (0x01)
+
+/**** Defines for the PhyInfo field - use MPI3_SAS_PHYINFO_ defines ****/
+
+/**** Defines for the NegotiatedLinkRate field - use MPI3_SAS_NEG_LINK_RATE_ defines ****/
+
+/**** Defines for the Slot field - use MPI3_SLOT_ defines ****/
+
+/**** Defines for the SlotIndex field - use MPI3_SLOT_INDEX_ ****/
+
+/*****************************************************************************
+ *              SAS PHY Page 1                                               *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_PHY_PAGE1 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                         /* 0x00 */
+    U32                             Reserved08;                     /* 0x08 */
+    U32                             InvalidDwordCount;              /* 0x0C */
+    U32                             RunningDisparityErrorCount;     /* 0x10 */
+    U32                             LossDwordSynchCount;            /* 0x14 */
+    U32                             PhyResetProblemCount;           /* 0x18 */
+} MPI3_SAS_PHY_PAGE1, MPI3_POINTER PTR_MPI3_SAS_PHY_PAGE1,
+  Mpi3SasPhyPage1_t, MPI3_POINTER pMpi3SasPhyPage1_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASPHY1_PAGEVERSION                        (0x00)
+
+/*****************************************************************************
+ *              SAS PHY Page 2                                               *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_PHY2_PHY_EVENT {
+    U8      PhyEventCode;       /* 0x00 */
+    U8      Reserved01[3];      /* 0x01 */
+    U32     PhyEventInfo;       /* 0x04 */
+} MPI3_SAS_PHY2_PHY_EVENT, MPI3_POINTER PTR_MPI3_SAS_PHY2_PHY_EVENT,
+  Mpi3SasPhy2PhyEvent_t, MPI3_POINTER pMpi3SasPhy2PhyEvent_t;
+
+/**** Defines for the PhyEventCode field - use MPI3_SASPHY3_EVENT_CODE_ defines */
+
+#ifndef MPI3_SAS_PHY2_PHY_EVENT_MAX
+#define MPI3_SAS_PHY2_PHY_EVENT_MAX         (1)
+#endif  /* MPI3_SAS_PHY2_PHY_EVENT_MAX */
+
+typedef struct _MPI3_SAS_PHY_PAGE2 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                     /* 0x00 */
+    U32                             Reserved08;                                 /* 0x08 */
+    U8                              NumPhyEvents;                               /* 0x0C */
+    U8                              Reserved0D[3];                              /* 0x0D */
+    MPI3_SAS_PHY2_PHY_EVENT         PhyEvent[MPI3_SAS_PHY2_PHY_EVENT_MAX];      /* 0x10 */
+} MPI3_SAS_PHY_PAGE2, MPI3_POINTER PTR_MPI3_SAS_PHY_PAGE2,
+  Mpi3SasPhyPage2_t, MPI3_POINTER pMpi3SasPhyPage2_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASPHY2_PAGEVERSION                        (0x00)
+
+/*****************************************************************************
+ *              SAS PHY Page 3                                               *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_PHY3_PHY_EVENT_CONFIG {
+    U8      PhyEventCode;           /* 0x00 */
+    U8      Reserved01[3];          /* 0x01 */
+    U8      CounterType;            /* 0x04 */
+    U8      ThresholdWindow;        /* 0x05 */
+    U8      TimeUnits;              /* 0x06 */
+    U8      Reserved07;             /* 0x07 */
+    U32     EventThreshold;         /* 0x08 */
+    U16     ThresholdFlags;         /* 0x0C */
+    U16     Reserved0E;             /* 0x0E */
+} MPI3_SAS_PHY3_PHY_EVENT_CONFIG, MPI3_POINTER PTR_MPI3_SAS_PHY3_PHY_EVENT_CONFIG,
+  Mpi3SasPhy3PhyEventConfig_t, MPI3_POINTER pMpi3SasPhy3PhyEventConfig_t;
+
+/**** Defines for the PhyEventCode field ****/
+#define MPI3_SASPHY3_EVENT_CODE_NO_EVENT                    (0x00)
+#define MPI3_SASPHY3_EVENT_CODE_INVALID_DWORD               (0x01)
+#define MPI3_SASPHY3_EVENT_CODE_RUNNING_DISPARITY_ERROR     (0x02)
+#define MPI3_SASPHY3_EVENT_CODE_LOSS_DWORD_SYNC             (0x03)
+#define MPI3_SASPHY3_EVENT_CODE_PHY_RESET_PROBLEM           (0x04)
+#define MPI3_SASPHY3_EVENT_CODE_ELASTICITY_BUF_OVERFLOW     (0x05)
+#define MPI3_SASPHY3_EVENT_CODE_RX_ERROR                    (0x06)
+#define MPI3_SASPHY3_EVENT_CODE_INV_SPL_PACKETS             (0x07)
+#define MPI3_SASPHY3_EVENT_CODE_LOSS_SPL_PACKET_SYNC        (0x08)
+#define MPI3_SASPHY3_EVENT_CODE_RX_ADDR_FRAME_ERROR         (0x20)
+#define MPI3_SASPHY3_EVENT_CODE_TX_AC_OPEN_REJECT           (0x21)
+#define MPI3_SASPHY3_EVENT_CODE_RX_AC_OPEN_REJECT           (0x22)
+#define MPI3_SASPHY3_EVENT_CODE_TX_RC_OPEN_REJECT           (0x23)
+#define MPI3_SASPHY3_EVENT_CODE_RX_RC_OPEN_REJECT           (0x24)
+#define MPI3_SASPHY3_EVENT_CODE_RX_AIP_PARTIAL_WAITING_ON   (0x25)
+#define MPI3_SASPHY3_EVENT_CODE_RX_AIP_CONNECT_WAITING_ON   (0x26)
+#define MPI3_SASPHY3_EVENT_CODE_TX_BREAK                    (0x27)
+#define MPI3_SASPHY3_EVENT_CODE_RX_BREAK                    (0x28)
+#define MPI3_SASPHY3_EVENT_CODE_BREAK_TIMEOUT               (0x29)
+#define MPI3_SASPHY3_EVENT_CODE_CONNECTION                  (0x2A)
+#define MPI3_SASPHY3_EVENT_CODE_PEAKTX_PATHWAY_BLOCKED      (0x2B)
+#define MPI3_SASPHY3_EVENT_CODE_PEAKTX_ARB_WAIT_TIME        (0x2C)
+#define MPI3_SASPHY3_EVENT_CODE_PEAK_ARB_WAIT_TIME          (0x2D)
+#define MPI3_SASPHY3_EVENT_CODE_PEAK_CONNECT_TIME           (0x2E)
+#define MPI3_SASPHY3_EVENT_CODE_PERSIST_CONN                (0x2F)
+#define MPI3_SASPHY3_EVENT_CODE_TX_SSP_FRAMES               (0x40)
+#define MPI3_SASPHY3_EVENT_CODE_RX_SSP_FRAMES               (0x41)
+#define MPI3_SASPHY3_EVENT_CODE_TX_SSP_ERROR_FRAMES         (0x42)
+#define MPI3_SASPHY3_EVENT_CODE_RX_SSP_ERROR_FRAMES         (0x43)
+#define MPI3_SASPHY3_EVENT_CODE_TX_CREDIT_BLOCKED           (0x44)
+#define MPI3_SASPHY3_EVENT_CODE_RX_CREDIT_BLOCKED           (0x45)
+#define MPI3_SASPHY3_EVENT_CODE_TX_SATA_FRAMES              (0x50)
+#define MPI3_SASPHY3_EVENT_CODE_RX_SATA_FRAMES              (0x51)
+#define MPI3_SASPHY3_EVENT_CODE_SATA_OVERFLOW               (0x52)
+#define MPI3_SASPHY3_EVENT_CODE_TX_SMP_FRAMES               (0x60)
+#define MPI3_SASPHY3_EVENT_CODE_RX_SMP_FRAMES               (0x61)
+#define MPI3_SASPHY3_EVENT_CODE_RX_SMP_ERROR_FRAMES         (0x63)
+#define MPI3_SASPHY3_EVENT_CODE_HOTPLUG_TIMEOUT             (0xD0)
+#define MPI3_SASPHY3_EVENT_CODE_MISALIGNED_MUX_PRIMITIVE    (0xD1)
+#define MPI3_SASPHY3_EVENT_CODE_RX_AIP                      (0xD2)
+#define MPI3_SASPHY3_EVENT_CODE_LCARB_WAIT_TIME             (0xD3)
+#define MPI3_SASPHY3_EVENT_CODE_RCVD_CONN_RESP_WAIT_TIME    (0xD4)
+#define MPI3_SASPHY3_EVENT_CODE_LCCONN_TIME                 (0xD5)
+#define MPI3_SASPHY3_EVENT_CODE_SSP_TX_START_TRANSMIT       (0xD6)
+#define MPI3_SASPHY3_EVENT_CODE_SATA_TX_START               (0xD7)
+#define MPI3_SASPHY3_EVENT_CODE_SMP_TX_START_TRANSMT        (0xD8)
+#define MPI3_SASPHY3_EVENT_CODE_TX_SMP_BREAK_CONN           (0xD9)
+#define MPI3_SASPHY3_EVENT_CODE_SSP_RX_START_RECEIVE        (0xDA)
+#define MPI3_SASPHY3_EVENT_CODE_SATA_RX_START_RECEIVE       (0xDB)
+#define MPI3_SASPHY3_EVENT_CODE_SMP_RX_START_RECEIVE        (0xDC)
+
+/**** Defines for the CounterType field ****/
+#define MPI3_SASPHY3_COUNTER_TYPE_WRAPPING                  (0x00)
+#define MPI3_SASPHY3_COUNTER_TYPE_SATURATING                (0x01)
+#define MPI3_SASPHY3_COUNTER_TYPE_PEAK_VALUE                (0x02)
+
+/**** Defines for the TimeUnits field ****/
+#define MPI3_SASPHY3_TIME_UNITS_10_MICROSECONDS             (0x00)
+#define MPI3_SASPHY3_TIME_UNITS_100_MICROSECONDS            (0x01)
+#define MPI3_SASPHY3_TIME_UNITS_1_MILLISECOND               (0x02)
+#define MPI3_SASPHY3_TIME_UNITS_10_MILLISECONDS             (0x03)
+
+/**** Defines for the ThresholdFlags field ****/
+#define MPI3_SASPHY3_TFLAGS_PHY_RESET                       (0x0002)
+#define MPI3_SASPHY3_TFLAGS_EVENT_NOTIFY                    (0x0001)
+
+#ifndef MPI3_SAS_PHY3_PHY_EVENT_MAX
+#define MPI3_SAS_PHY3_PHY_EVENT_MAX         (1)
+#endif  /* MPI3_SAS_PHY3_PHY_EVENT_MAX */
+
+typedef struct _MPI3_SAS_PHY_PAGE3 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                         /* 0x00 */
+    U32                             Reserved08;                                     /* 0x08 */
+    U8                              NumPhyEvents;                                   /* 0x0C */
+    U8                              Reserved0D[3];                                  /* 0x0D */
+    MPI3_SAS_PHY3_PHY_EVENT_CONFIG  PhyEventConfig[MPI3_SAS_PHY3_PHY_EVENT_MAX];    /* 0x10 */
+} MPI3_SAS_PHY_PAGE3, MPI3_POINTER PTR_MPI3_SAS_PHY_PAGE3,
+  Mpi3SasPhyPage3_t, MPI3_POINTER pMpi3SasPhyPage3_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASPHY3_PAGEVERSION                        (0x00)
+
+/*****************************************************************************
+ *              SAS PHY Page 4                                               *
+ ****************************************************************************/
+typedef struct _MPI3_SAS_PHY_PAGE4 {
+    MPI3_CONFIG_PAGE_HEADER         Header;             /* 0x00 */
+    U8                              Reserved08[3];      /* 0x08 */
+    U8                              Flags;              /* 0x0B */
+    U8                              InitialFrame[28];   /* 0x0C */
+} MPI3_SAS_PHY_PAGE4, MPI3_POINTER PTR_MPI3_SAS_PHY_PAGE4,
+  Mpi3SasPhyPage4_t, MPI3_POINTER pMpi3SasPhyPage4_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_SASPHY4_PAGEVERSION                        (0x00)
+
+/**** Defines for the Flags field ****/
+#define MPI3_SASPHY4_FLAGS_FRAME_VALID                  (0x02)
+#define MPI3_SASPHY4_FLAGS_SATA_FRAME                   (0x01)
+
+
+/*****************************************************************************
+ *              Common definitions used by PCIe Configuration Pages          *
+ ****************************************************************************/
+
+/**** Defines for Negotiated Link Rates ****/
+#define MPI3_PCIE_LINK_RETIMERS_MASK                    (0x30)
+#define MPI3_PCIE_LINK_RETIMERS_SHIFT                   (4)
+#define MPI3_PCIE_NEG_LINK_RATE_MASK                    (0x0F)
+#define MPI3_PCIE_NEG_LINK_RATE_UNKNOWN                 (0x00)
+#define MPI3_PCIE_NEG_LINK_RATE_PHY_DISABLED            (0x01)
+#define MPI3_PCIE_NEG_LINK_RATE_2_5                     (0x02)
+#define MPI3_PCIE_NEG_LINK_RATE_5_0                     (0x03)
+#define MPI3_PCIE_NEG_LINK_RATE_8_0                     (0x04)
+#define MPI3_PCIE_NEG_LINK_RATE_16_0                    (0x05)
+#define MPI3_PCIE_NEG_LINK_RATE_32_0                    (0x06)
+
+/*****************************************************************************
+ *              PCIe IO Unit Configuration Pages                             *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              PCIe IO Unit Page 0                                          *
+ ****************************************************************************/
+typedef struct _MPI3_PCIE_IO_UNIT0_PHY_DATA {
+    U8      Link;                       /* 0x00 */
+    U8      LinkFlags;                  /* 0x01 */
+    U8      PhyFlags;                   /* 0x02 */
+    U8      NegotiatedLinkRate;         /* 0x03 */
+    U16     AttachedDevHandle;          /* 0x04 */
+    U16     ControllerDevHandle;        /* 0x06 */
+    U32     EnumerationStatus;          /* 0x08 */
+    U8      IOUnitPort;                 /* 0x0C */
+    U8      Reserved0D[3];              /* 0x0D */
+} MPI3_PCIE_IO_UNIT0_PHY_DATA, MPI3_POINTER PTR_MPI3_PCIE_IO_UNIT0_PHY_DATA,
+  Mpi3PcieIOUnit0PhyData_t, MPI3_POINTER pMpi3PcieIOUnit0PhyData_t;
+
+/**** Defines for the LinkFlags field ****/
+#define MPI3_PCIEIOUNIT0_LINKFLAGS_CONFIG_SOURCE_MASK      (0x10)
+#define MPI3_PCIEIOUNIT0_LINKFLAGS_CONFIG_SOURCE_IOUNIT1   (0x00)
+#define MPI3_PCIEIOUNIT0_LINKFLAGS_CONFIG_SOURCE_BKPLANE   (0x10)
+#define MPI3_PCIEIOUNIT0_LINKFLAGS_ENUM_IN_PROGRESS        (0x08)
+
+/**** Defines for the PhyFlags field ****/
+#define MPI3_PCIEIOUNIT0_PHYFLAGS_PHY_DISABLED          (0x08)
+#define MPI3_PCIEIOUNIT0_PHYFLAGS_HOST_PHY              (0x01)
+
+/**** Defines for the NegotiatedLinkRate field - use MPI3_PCIE_NEG_LINK_RATE_ defines ****/
+
+/**** Defines for the EnumerationStatus field ****/
+#define MPI3_PCIEIOUNIT0_ES_MAX_SWITCH_DEPTH_EXCEEDED   (0x80000000)
+#define MPI3_PCIEIOUNIT0_ES_MAX_SWITCHES_EXCEEDED       (0x40000000)
+#define MPI3_PCIEIOUNIT0_ES_MAX_ENDPOINTS_EXCEEDED      (0x20000000)
+#define MPI3_PCIEIOUNIT0_ES_INSUFFICIENT_RESOURCES      (0x10000000)
+
+#ifndef MPI3_PCIE_IO_UNIT0_PHY_MAX
+#define MPI3_PCIE_IO_UNIT0_PHY_MAX      (1)
+#endif  /* MPI3_PCIE_IO_UNIT0_PHY_MAX */
+
+typedef struct _MPI3_PCIE_IO_UNIT_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                 /* 0x00 */
+    U32                             Reserved08;                             /* 0x08 */
+    U8                              NumPhys;                                /* 0x0C */
+    U8                              InitStatus;                             /* 0x0D */
+    U16                             Reserved0E;                             /* 0x0E */
+    MPI3_PCIE_IO_UNIT0_PHY_DATA     PhyData[MPI3_PCIE_IO_UNIT0_PHY_MAX];    /* 0x10 */
+} MPI3_PCIE_IO_UNIT_PAGE0, MPI3_POINTER PTR_MPI3_PCIE_IO_UNIT_PAGE0,
+  Mpi3PcieIOUnitPage0_t, MPI3_POINTER pMpi3PcieIOUnitPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_PCIEIOUNIT0_PAGEVERSION                        (0x00)
+
+/**** Defines for the InitStatus field ****/
+#define MPI3_PCIEIOUNIT0_INITSTATUS_NO_ERRORS               (0x00)
+#define MPI3_PCIEIOUNIT0_INITSTATUS_NEEDS_INITIALIZATION    (0x01)
+#define MPI3_PCIEIOUNIT0_INITSTATUS_NO_TARGETS_ALLOCATED    (0x02)
+#define MPI3_PCIEIOUNIT0_INITSTATUS_RESOURCE_ALLOC_FAILED   (0x03)
+#define MPI3_PCIEIOUNIT0_INITSTATUS_BAD_NUM_PHYS            (0x04)
+#define MPI3_PCIEIOUNIT0_INITSTATUS_UNSUPPORTED_CONFIG      (0x05)
+#define MPI3_PCIEIOUNIT0_INITSTATUS_HOST_PORT_MISMATCH      (0x06)
+#define MPI3_PCIEIOUNIT0_INITSTATUS_PHYS_NOT_CONSECUTIVE    (0x07)
+#define MPI3_PCIEIOUNIT0_INITSTATUS_BAD_CLOCKING_MODE       (0x08)
+#define MPI3_PCIEIOUNIT0_INITSTATUS_PROD_SPEC_START         (0xF0)
+#define MPI3_PCIEIOUNIT0_INITSTATUS_PROD_SPEC_END           (0xFF)
+
+/*****************************************************************************
+ *              PCIe IO Unit Page 1                                          *
+ ****************************************************************************/
+typedef struct _MPI3_PCIE_IO_UNIT1_PHY_DATA {
+    U8      Link;                       /* 0x00 */
+    U8      LinkFlags;                  /* 0x01 */
+    U8      PhyFlags;                   /* 0x02 */
+    U8      MaxMinLinkRate;             /* 0x03 */
+    U32     Reserved04;                 /* 0x04 */
+    U32     Reserved08;                 /* 0x08 */
+} MPI3_PCIE_IO_UNIT1_PHY_DATA, MPI3_POINTER PTR_MPI3_PCIE_IO_UNIT1_PHY_DATA,
+  Mpi3PcieIOUnit1PhyData_t, MPI3_POINTER pMpi3PcieIOUnit1PhyData_t;
+
+/**** Defines for the LinkFlags field ****/
+#define MPI3_PCIEIOUNIT1_LINKFLAGS_PCIE_CLK_MODE_MASK                     (0x03)
+#define MPI3_PCIEIOUNIT1_LINKFLAGS_PCIE_CLK_MODE_DIS_SEPARATE_REFCLK      (0x00)
+#define MPI3_PCIEIOUNIT1_LINKFLAGS_PCIE_CLK_MODE_EN_SRIS                  (0x01)
+#define MPI3_PCIEIOUNIT1_LINKFLAGS_PCIE_CLK_MODE_EN_SRNS                  (0x02)
+
+/**** Defines for the PhyFlags field ****/
+#define MPI3_PCIEIOUNIT1_PHYFLAGS_PHY_DISABLE               (0x08)
+
+/**** Defines for the MaxMinLinkRate ****/
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_MASK                      (0xF0)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_SHIFT                     (4)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_2_5                       (0x20)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_5_0                       (0x30)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_8_0                       (0x40)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_16_0                      (0x50)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_32_0                      (0x60)
+
+#ifndef MPI3_PCIE_IO_UNIT1_PHY_MAX
+#define MPI3_PCIE_IO_UNIT1_PHY_MAX          (1)
+#endif  /* MPI3_PCIE_IO_UNIT1_PHY_MAX */
+
+typedef struct _MPI3_PCIE_IO_UNIT_PAGE1 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                 /* 0x00 */
+    U32                             ControlFlags;                           /* 0x08 */
+    U32                             Reserved0C;                             /* 0x0C */
+    U8                              NumPhys;                                /* 0x10 */
+    U8                              Reserved11;                             /* 0x11 */
+    U16                             Reserved12;                             /* 0x12 */
+    MPI3_PCIE_IO_UNIT1_PHY_DATA     PhyData[MPI3_PCIE_IO_UNIT1_PHY_MAX];    /* 0x14 */
+} MPI3_PCIE_IO_UNIT_PAGE1, MPI3_POINTER PTR_MPI3_PCIE_IO_UNIT_PAGE1,
+  Mpi3PcieIOUnitPage1_t, MPI3_POINTER pMpi3PcieIOUnitPage1_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_PCIEIOUNIT1_PAGEVERSION                        (0x00)
+
+/*****************************************************************************
+ *              PCIe IO Unit Page 2                                          *
+ ****************************************************************************/
+typedef struct _MPI3_PCIE_IO_UNIT_PAGE2 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                                 /* 0x00 */
+    U16                             NVMeMaxQueueDepth;                      /* 0x08 */
+    U16                             Reserved0A;                             /* 0x0A */
+    U8                              NVMeAbortTO;                            /* 0x0C */
+    U8                              Reserved0D;                             /* 0x0D */
+    U16                             Reserved0E;                             /* 0x0E */
+} MPI3_PCIE_IO_UNIT_PAGE2, MPI3_POINTER PTR_MPI3_PCIE_IO_UNIT_PAGE2,
+  Mpi3PcieIOUnitPage2_t, MPI3_POINTER pMpi3PcieIOUnitPage2_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_PCIEIOUNIT2_PAGEVERSION                        (0x00)
+
+/*****************************************************************************
+ *              PCIe Switch Configuration Pages                              *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              PCIe Switch Page 0                                           *
+ ****************************************************************************/
+typedef struct _MPI3_PCIE_SWITCH_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER     Header;             /* 0x00 */
+    U8                          IOUnitPort;         /* 0x08 */
+    U8                          SwitchStatus;       /* 0x09 */
+    U8                          Reserved0A[2];      /* 0x0A */
+    U16                         DevHandle;          /* 0x0C */
+    U16                         ParentDevHandle;    /* 0x0E */
+    U8                          NumPorts;           /* 0x10 */
+    U8                          PCIeLevel;          /* 0x11 */
+    U16                         Reserved12;         /* 0x12 */
+    U32                         Reserved14;         /* 0x14 */
+    U32                         Reserved18;         /* 0x18 */
+    U32                         Reserved1C;         /* 0x1C */
+} MPI3_PCIE_SWITCH_PAGE0, MPI3_POINTER PTR_MPI3_PCIE_SWITCH_PAGE0,
+  Mpi3PcieSwitchPage0_t, MPI3_POINTER pMpi3PcieSwitchPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_PCIESWITCH0_PAGEVERSION                  (0x00)
+
+/**** Defines for the SwitchStatus field ****/
+#define MPI3_PCIESWITCH0_SS_NOT_RESPONDING            (0x02)
+#define MPI3_PCIESWITCH0_SS_RESPONDING                (0x03)
+#define MPI3_PCIESWITCH0_SS_DELAY_NOT_RESPONDING      (0x04)
+
+/*****************************************************************************
+ *              PCIe Switch Page 1                                           *
+ ****************************************************************************/
+typedef struct _MPI3_PCIE_SWITCH_PAGE1 {
+    MPI3_CONFIG_PAGE_HEADER     Header;                 /* 0x00 */
+    U8                          IOUnitPort;             /* 0x08 */
+    U8                          Reserved09[3];          /* 0x09 */
+    U8                          NumPorts;               /* 0x0C */
+    U8                          PortNum;                /* 0x0D */
+    U16                         AttachedDevHandle;      /* 0x0E */
+    U16                         SwitchDevHandle;        /* 0x10 */
+    U8                          NegotiatedPortWidth;    /* 0x12 */
+    U8                          NegotiatedLinkRate;     /* 0x13 */
+    U16                         Slot;                   /* 0x14 */
+    U16                         SlotIndex;              /* 0x16 */
+    U32                         Reserved18;             /* 0x18 */
+} MPI3_PCIE_SWITCH_PAGE1, MPI3_POINTER PTR_MPI3_PCIE_SWITCH_PAGE1,
+  Mpi3PcieSwitchPage1_t, MPI3_POINTER pMpi3PcieSwitchPage1_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_PCIESWITCH1_PAGEVERSION        (0x00)
+
+/**** Defines for the NegotiatedLinkRate field - use MPI3_PCIE_NEG_LINK_RATE_ defines ****/
+
+/**** Defines for the Slot field - use MPI3_SLOT_ defines ****/
+
+/**** Defines for the SlotIndex field - use MPI3_SLOT_INDEX_ ****/
+
+/*****************************************************************************
+ *              PCIe Link Configuration Pages                                *
+ ****************************************************************************/
+typedef struct _MPI3_PCIE_LINK_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER     Header;                 /* 0x00 */
+    U8                          Link;                   /* 0x08 */
+    U8                          Reserved09[3];          /* 0x09 */
+    U32                         CorrectableErrorCount;  /* 0x0C */
+    U16                         NFatalErrorCount;       /* 0x10 */
+    U16                         Reserved12;             /* 0x12 */
+    U16                         FatalErrorCount;        /* 0x14 */
+    U16                         Reserved16;             /* 0x16 */
+} MPI3_PCIE_LINK_PAGE0, MPI3_POINTER PTR_MPI3_PCIE_LINK_PAGE0,
+  Mpi3PcieLinkPage0_t, MPI3_POINTER pMpi3PcieLinkPage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_PCIELINK0_PAGEVERSION          (0x00)
+
+
+/*****************************************************************************
+ *              Enclosure Configuration Pages                                *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              Enclosure Page 0                                             *
+ ****************************************************************************/
+typedef struct _MPI3_ENCLOSURE_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                 /* 0x00 */
+    U64                             EnclosureLogicalID;     /* 0x08 */
+    U16                             Flags;                  /* 0x10 */
+    U16                             EnclosureHandle;        /* 0x12 */
+    U16                             NumSlots;               /* 0x14 */
+    U16                             StartSlot;              /* 0x16 */
+    U8                              IOUnitPort;             /* 0x18 */
+    U8                              EnclosureLevel;         /* 0x19 */
+    U16                             SEPDevHandle;           /* 0x1A */
+    U32                             Reserved1C;             /* 0x1C */
+} MPI3_ENCLOSURE_PAGE0, MPI3_POINTER PTR_MPI3_ENCLOSURE_PAGE0,
+  Mpi3EnclosurePage0_t, MPI3_POINTER pMpi3EnclosurePage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_ENCLOSURE0_PAGEVERSION                     (0x00)
+
+/**** Defines for the Flags field ****/
+#define MPI3_ENCLS0_FLAGS_ENCL_TYPE_MASK                (0xC000)
+#define MPI3_ENCLS0_FLAGS_ENCL_TYPE_VIRTUAL             (0x0000)
+#define MPI3_ENCLS0_FLAGS_ENCL_TYPE_SAS                 (0x4000)
+#define MPI3_ENCLS0_FLAGS_ENCL_TYPE_PCIE                (0x8000)
+#define MPI3_ENCLS0_FLAGS_ENCL_DEV_PRESENT_MASK         (0x0010)
+#define MPI3_ENCLS0_FLAGS_ENCL_DEV_NOT_FOUND            (0x0000)
+#define MPI3_ENCLS0_FLAGS_ENCL_DEV_PRESENT              (0x0010)
+#define MPI3_ENCLS0_FLAGS_MNG_MASK                      (0x000F)
+#define MPI3_ENCLS0_FLAGS_MNG_UNKNOWN                   (0x0000)
+#define MPI3_ENCLS0_FLAGS_MNG_IOC_SES                   (0x0001)
+#define MPI3_ENCLS0_FLAGS_MNG_SES_ENCLOSURE             (0x0002)
+
+/**** Defines for the PhysicalPort field - use MPI3_DEVICE0_PHYPORT_ defines ****/
+
+/*****************************************************************************
+ *              Device Configuration Pages                                   *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              Common definitions used by Device Configuration Pages           *
+ ****************************************************************************/
+
+/**** Defines for the DeviceForm field ****/
+#define MPI3_DEVICE_DEVFORM_SAS_SATA                    (0x00)
+#define MPI3_DEVICE_DEVFORM_PCIE                        (0x01)
+#define MPI3_DEVICE_DEVFORM_VD                          (0x02)
+
+/*****************************************************************************
+ *              Device Page 0                                                *
+ ****************************************************************************/
+typedef struct _MPI3_DEVICE0_SAS_SATA_FORMAT {
+    U64     SASAddress;                 /* 0x00 */
+    U16     Flags;                      /* 0x08 */
+    U16     DeviceInfo;                 /* 0x0A */
+    U8      PhyNum;                     /* 0x0C */
+    U8      AttachedPhyIdentifier;      /* 0x0D */
+    U8      MaxPortConnections;         /* 0x0E */
+    U8      ZoneGroup;                  /* 0x0F */
+} MPI3_DEVICE0_SAS_SATA_FORMAT, MPI3_POINTER PTR_MPI3_DEVICE0_SAS_SATA_FORMAT,
+  Mpi3Device0SasSataFormat_t, MPI3_POINTER pMpi3Device0SasSataFormat_t;
+
+/**** Defines for the Flags field ****/
+#define MPI3_DEVICE0_SASSATA_FLAGS_SLUMBER_CAP          (0x0200)
+#define MPI3_DEVICE0_SASSATA_FLAGS_PARTIAL_CAP          (0x0100)
+#define MPI3_DEVICE0_SASSATA_FLAGS_ASYNC_NOTIFY         (0x0080)
+#define MPI3_DEVICE0_SASSATA_FLAGS_SW_PRESERVE          (0x0040)
+#define MPI3_DEVICE0_SASSATA_FLAGS_UNSUPP_DEV           (0x0020)
+#define MPI3_DEVICE0_SASSATA_FLAGS_48BIT_LBA            (0x0010)
+#define MPI3_DEVICE0_SASSATA_FLAGS_SMART_SUPP           (0x0008)
+#define MPI3_DEVICE0_SASSATA_FLAGS_NCQ_SUPP             (0x0004)
+#define MPI3_DEVICE0_SASSATA_FLAGS_FUA_SUPP             (0x0002)
+#define MPI3_DEVICE0_SASSATA_FLAGS_PERSIST_CAP          (0x0001)
+
+/**** Defines for the DeviceInfo field - use MPI3_SAS_DEVICE_INFO_ defines (see mpi30_sas.h) ****/
+
+typedef struct _MPI3_DEVICE0_PCIE_FORMAT {
+    U8      SupportedLinkRates;         /* 0x00 */
+    U8      MaxPortWidth;               /* 0x01 */
+    U8      NegotiatedPortWidth;        /* 0x02 */
+    U8      NegotiatedLinkRate;         /* 0x03 */
+    U8      PortNum;                    /* 0x04 */
+    U8      ControllerResetTO;          /* 0x05 */
+    U16     DeviceInfo;                 /* 0x06 */
+    U32     MaximumDataTransferSize;    /* 0x08 */
+    U32     Capabilities;               /* 0x0C */
+    U16     NOIOB;                      /* 0x10 */
+    U8      NVMeAbortTO;                /* 0x12 */
+    U8      PageSize;                   /* 0x13 */
+    U16     ShutdownLatency;            /* 0x14 */
+    U16     Reserved16;                 /* 0x16 */
+} MPI3_DEVICE0_PCIE_FORMAT, MPI3_POINTER PTR_MPI3_DEVICE0_PCIE_FORMAT,
+  Mpi3Device0PcieFormat_t, MPI3_POINTER pMpi3Device0PcieFormat_t;
+
+/**** Defines for the SupportedLinkRates field ****/
+#define MPI3_DEVICE0_PCIE_LINK_RATE_32_0_SUPP           (0x10)
+#define MPI3_DEVICE0_PCIE_LINK_RATE_16_0_SUPP           (0x08)
+#define MPI3_DEVICE0_PCIE_LINK_RATE_8_0_SUPP            (0x04)
+#define MPI3_DEVICE0_PCIE_LINK_RATE_5_0_SUPP            (0x02)
+#define MPI3_DEVICE0_PCIE_LINK_RATE_2_5_SUPP            (0x01)
+
+/**** Defines for the NegotiatedLinkRate field - use MPI3_PCIE_NEG_LINK_RATE_ defines ****/
+
+/**** Defines for DeviceInfo bitfield ****/
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK             (0x0003)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NO_DEVICE        (0x0000)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE      (0x0001)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_SWITCH_DEVICE    (0x0002)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_SCSI_DEVICE      (0x0003)
+
+/**** Defines for the Capabilities field ****/
+#define MPI3_DEVICE0_PCIE_CAP_METADATA_SEPARATED            (0x00000010)
+#define MPI3_DEVICE0_PCIE_CAP_SGL_DWORD_ALIGN_REQUIRED      (0x00000008)
+#define MPI3_DEVICE0_PCIE_CAP_NVME_SGL_ENABLED              (0x00000004)
+#define MPI3_DEVICE0_PCIE_CAP_BIT_BUCKET_SGL_SUPP           (0x00000002)
+#define MPI3_DEVICE0_PCIE_CAP_SGL_SUPP                      (0x00000001)
+
+typedef struct _MPI3_DEVICE0_VD_FORMAT {
+    U8      VdState;              /* 0x00 */
+    U8      RAIDLevel;            /* 0x01 */
+    U16     DeviceInfo;           /* 0x02 */
+    U16     Flags;                /* 0x04 */
+    U16     Reserved06;           /* 0x06 */
+    U32     Reserved08[2];        /* 0x08 */
+} MPI3_DEVICE0_VD_FORMAT, MPI3_POINTER PTR_MPI3_DEVICE0_VD_FORMAT,
+  Mpi3Device0VdFormat_t, MPI3_POINTER pMpi3Device0VdFormat_t;
+
+/**** Defines for the VdState field ****/
+#define MPI3_DEVICE0_VD_STATE_OFFLINE                       (0x00)
+#define MPI3_DEVICE0_VD_STATE_PARTIALLY_DEGRADED            (0x01)
+#define MPI3_DEVICE0_VD_STATE_DEGRADED                      (0x02)
+#define MPI3_DEVICE0_VD_STATE_OPTIMAL                       (0x03)
+
+/**** Defines for RAIDLevel field ****/
+#define MPI3_DEVICE0_VD_RAIDLEVEL_RAID_0                    (0)
+#define MPI3_DEVICE0_VD_RAIDLEVEL_RAID_1                    (1)
+#define MPI3_DEVICE0_VD_RAIDLEVEL_RAID_5                    (5)
+#define MPI3_DEVICE0_VD_RAIDLEVEL_RAID_6                    (6)
+#define MPI3_DEVICE0_VD_RAIDLEVEL_RAID_10                   (10)
+#define MPI3_DEVICE0_VD_RAIDLEVEL_RAID_50                   (50)
+#define MPI3_DEVICE0_VD_RAIDLEVEL_RAID_60                   (60)
+
+/**** Defines for DeviceInfo field ****/
+#define MPI3_DEVICE0_VD_DEVICE_INFO_HDD                     (0x0010)
+#define MPI3_DEVICE0_VD_DEVICE_INFO_SSD                     (0x0008)
+#define MPI3_DEVICE0_VD_DEVICE_INFO_NVME                    (0x0004)
+#define MPI3_DEVICE0_VD_DEVICE_INFO_SATA                    (0x0002)
+#define MPI3_DEVICE0_VD_DEVICE_INFO_SAS                     (0x0001)
+
+/**** Defines for the Flags field ****/
+#define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_MASK            (0x0003)
+#define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_NONE            (0x0000)
+#define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_HOST            (0x0001)
+#define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_IOC             (0x0002)
+
+typedef union _MPI3_DEVICE0_DEV_SPEC_FORMAT {
+    MPI3_DEVICE0_SAS_SATA_FORMAT        SasSataFormat;
+    MPI3_DEVICE0_PCIE_FORMAT            PcieFormat;
+    MPI3_DEVICE0_VD_FORMAT              VdFormat;
+} MPI3_DEVICE0_DEV_SPEC_FORMAT, MPI3_POINTER PTR_MPI3_DEVICE0_DEV_SPEC_FORMAT,
+  Mpi3Device0DevSpecFormat_t, MPI3_POINTER pMpi3Device0DevSpecFormat_t;
+
+typedef struct _MPI3_DEVICE_PAGE0 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                 /* 0x00 */
+    U16                             DevHandle;              /* 0x08 */
+    U16                             ParentDevHandle;        /* 0x0A */
+    U16                             Slot;                   /* 0x0C */
+    U16                             EnclosureHandle;        /* 0x0E */
+    U64                             WWID;                   /* 0x10 */
+    U16                             PersistentID;           /* 0x18 */
+    U8                              IOUnitPort;             /* 0x1A */
+    U8                              AccessStatus;           /* 0x1B */
+    U16                             Flags;                  /* 0x1C */
+    U16                             Reserved1E;             /* 0x1E */
+    U16                             SlotIndex;              /* 0x20 */
+    U16                             QueueDepth;             /* 0x22 */
+    U8                              Reserved24[3];          /* 0x24 */
+    U8                              DeviceForm;             /* 0x27 */
+    MPI3_DEVICE0_DEV_SPEC_FORMAT    DeviceSpecific;         /* 0x28 */
+} MPI3_DEVICE_PAGE0, MPI3_POINTER PTR_MPI3_DEVICE_PAGE0,
+  Mpi3DevicePage0_t, MPI3_POINTER pMpi3DevicePage0_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_DEVICE0_PAGEVERSION                        (0x00)
+
+/**** Defines for the Slot field - use MPI3_SLOT_ defines ****/
+
+/**** Defines for the WWID field ****/
+#define MPI3_DEVICE0_WWID_INVALID                       (0xFFFFFFFFFFFFFFFF)
+
+/**** Defines for the PersistentID field ****/
+#define MPI3_DEVICE0_PERSISTENTID_INVALID               (0xFFFF)
+
+/**** Defines for the IOUnitPort field ****/
+#define MPI3_DEVICE0_IOUNITPORT_INVALID                 (0xFF)
+
+/**** Defines for the AccessStatus field ****/
+/* Generic Access Status Codes  */
+#define MPI3_DEVICE0_ASTATUS_NO_ERRORS                              (0x00)
+#define MPI3_DEVICE0_ASTATUS_NEEDS_INITIALIZATION                   (0x01)
+#define MPI3_DEVICE0_ASTATUS_CAP_UNSUPPORTED                        (0x02)
+#define MPI3_DEVICE0_ASTATUS_DEVICE_BLOCKED                         (0x03)
+#define MPI3_DEVICE0_ASTATUS_UNAUTHORIZED                           (0x04)
+#define MPI3_DEVICE0_ASTATUS_DEVICE_MISSING_DELAY                   (0x05)
+/* SAS Access Status Codes  */
+#define MPI3_DEVICE0_ASTATUS_SAS_UNKNOWN                            (0x10)
+#define MPI3_DEVICE0_ASTATUS_ROUTE_NOT_ADDRESSABLE                  (0x11)
+#define MPI3_DEVICE0_ASTATUS_SMP_ERROR_NOT_ADDRESSABLE              (0x12)
+/* SATA Access Status Codes  */
+#define MPI3_DEVICE0_ASTATUS_SIF_UNKNOWN                            (0x20)
+#define MPI3_DEVICE0_ASTATUS_SIF_AFFILIATION_CONFLICT               (0x21)
+#define MPI3_DEVICE0_ASTATUS_SIF_DIAG                               (0x22)
+#define MPI3_DEVICE0_ASTATUS_SIF_IDENTIFICATION                     (0x23)
+#define MPI3_DEVICE0_ASTATUS_SIF_CHECK_POWER                        (0x24)
+#define MPI3_DEVICE0_ASTATUS_SIF_PIO_SN                             (0x25)
+#define MPI3_DEVICE0_ASTATUS_SIF_MDMA_SN                            (0x26)
+#define MPI3_DEVICE0_ASTATUS_SIF_UDMA_SN                            (0x27)
+#define MPI3_DEVICE0_ASTATUS_SIF_ZONING_VIOLATION                   (0x28)
+#define MPI3_DEVICE0_ASTATUS_SIF_NOT_ADDRESSABLE                    (0x29)
+#define MPI3_DEVICE0_ASTATUS_SIF_MAX                                (0x2F)
+/* PCIe Access Status Codes  */
+#define MPI3_DEVICE0_ASTATUS_PCIE_UNKNOWN                           (0x30)
+#define MPI3_DEVICE0_ASTATUS_PCIE_MEM_SPACE_ACCESS                  (0x31)
+#define MPI3_DEVICE0_ASTATUS_PCIE_UNSUPPORTED                       (0x32)
+#define MPI3_DEVICE0_ASTATUS_PCIE_MSIX_REQUIRED                     (0x33)
+/* NVMe Access Status Codes  */
+#define MPI3_DEVICE0_ASTATUS_NVME_UNKNOWN                           (0x40)
+#define MPI3_DEVICE0_ASTATUS_NVME_READY_TIMEOUT                     (0x41)
+#define MPI3_DEVICE0_ASTATUS_NVME_DEVCFG_UNSUPPORTED                (0x42)
+#define MPI3_DEVICE0_ASTATUS_NVME_IDENTIFY_FAILED                   (0x43)
+#define MPI3_DEVICE0_ASTATUS_NVME_QCONFIG_FAILED                    (0x44)
+#define MPI3_DEVICE0_ASTATUS_NVME_QCREATION_FAILED                  (0x45)
+#define MPI3_DEVICE0_ASTATUS_NVME_EVENTCFG_FAILED                   (0x46)
+#define MPI3_DEVICE0_ASTATUS_NVME_GET_FEATURE_STAT_FAILED           (0x47)
+#define MPI3_DEVICE0_ASTATUS_NVME_IDLE_TIMEOUT                      (0x48)
+#define MPI3_DEVICE0_ASTATUS_NVME_CTRL_FAILURE_STATUS               (0x49)
+/* Virtual Device Access Status Codes  */
+#define MPI3_DEVICE0_ASTATUS_VD_UNKNOWN                             (0x50)
+
+/**** Defines for the Flags field ****/
+#define MPI3_DEVICE0_FLAGS_CONTROLLER_DEV_HANDLE        (0x0080)
+#define MPI3_DEVICE0_FLAGS_HIDDEN                       (0x0008)
+#define MPI3_DEVICE0_FLAGS_ATT_METHOD_MASK              (0x0006)
+#define MPI3_DEVICE0_FLAGS_ATT_METHOD_NOT_DIR_ATTACHED  (0x0000)
+#define MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTACHED      (0x0002)
+#define MPI3_DEVICE0_FLAGS_ATT_METHOD_VIRTUAL           (0x0004)
+#define MPI3_DEVICE0_FLAGS_DEVICE_PRESENT               (0x0001)
+
+/**** Defines for the SlotIndex field - use MPI3_SLOT_INDEX_ defines ****/
+
+/**** Defines for the DeviceForm field - use MPI3_DEVICE_DEVFORM_ defines ****/
+
+/**** Defines for the QueueDepth field ****/
+#define MPI3_DEVICE0_QUEUE_DEPTH_NOT_APPLICABLE         (0x0000)
+
+
+/*****************************************************************************
+ *              Device Page 1                                                *
+ ****************************************************************************/
+typedef struct _MPI3_DEVICE1_SAS_SATA_FORMAT {
+    U32                             Reserved00;             /* 0x00 */
+} MPI3_DEVICE1_SAS_SATA_FORMAT, MPI3_POINTER PTR_MPI3_DEVICE1_SAS_SATA_FORMAT,
+  Mpi3Device1SasSataFormat_t, MPI3_POINTER pMpi3Device1SasSataFormat_t;
+
+typedef struct _MPI3_DEVICE1_PCIE_FORMAT {
+    U16                             VendorID;               /* 0x00 */
+    U16                             DeviceID;               /* 0x02 */
+    U16                             SubsystemVendorID;      /* 0x04 */
+    U16                             SubsystemID;            /* 0x06 */
+    U32                             Reserved08;             /* 0x08 */
+    U8                              RevisionID;             /* 0x0C */
+    U8                              Reserved0D;             /* 0x0D */
+    U16                             PCIParameters;          /* 0x0E */
+} MPI3_DEVICE1_PCIE_FORMAT, MPI3_POINTER PTR_MPI3_DEVICE1_PCIE_FORMAT,
+  Mpi3Device1PcieFormat_t, MPI3_POINTER pMpi3Device1PcieFormat_t;
+
+/**** Defines for the PCIParameters field ****/
+#define MPI3_DEVICE1_PCIE_PARAMS_DATA_SIZE_128B              (0x0)
+#define MPI3_DEVICE1_PCIE_PARAMS_DATA_SIZE_256B              (0x1)
+#define MPI3_DEVICE1_PCIE_PARAMS_DATA_SIZE_512B              (0x2)
+#define MPI3_DEVICE1_PCIE_PARAMS_DATA_SIZE_1024B             (0x3)
+#define MPI3_DEVICE1_PCIE_PARAMS_DATA_SIZE_2048B             (0x4)
+#define MPI3_DEVICE1_PCIE_PARAMS_DATA_SIZE_4096B             (0x5)
+
+/*** MaxReadRequestSize, CurrentMaxPayloadSize, and MaxPayloadSizeSupported  ***/
+/***  all use the size definitions above - shifted to the proper position    ***/
+#define MPI3_DEVICE1_PCIE_PARAMS_MAX_READ_REQ_MASK           (0x01C0)
+#define MPI3_DEVICE1_PCIE_PARAMS_MAX_READ_REQ_SHIFT          (6)
+#define MPI3_DEVICE1_PCIE_PARAMS_CURR_MAX_PAYLOAD_MASK       (0x0038)
+#define MPI3_DEVICE1_PCIE_PARAMS_CURR_MAX_PAYLOAD_SHIFT      (3)
+#define MPI3_DEVICE1_PCIE_PARAMS_SUPP_MAX_PAYLOAD_MASK       (0x0007)
+#define MPI3_DEVICE1_PCIE_PARAMS_SUPP_MAX_PAYLOAD_SHIFT      (0)
+
+typedef struct _MPI3_DEVICE1_VD_FORMAT {
+    U32                             Reserved00;             /* 0x00 */
+} MPI3_DEVICE1_VD_FORMAT, MPI3_POINTER PTR_MPI3_DEVICE1_VD_FORMAT,
+  Mpi3Device1VdFormat_t, MPI3_POINTER pMpi3Device1VdFormat_t;
+
+typedef union _MPI3_DEVICE1_DEV_SPEC_FORMAT {
+    MPI3_DEVICE1_SAS_SATA_FORMAT    SasSataFormat;
+    MPI3_DEVICE1_PCIE_FORMAT        PcieFormat;
+    MPI3_DEVICE1_VD_FORMAT          VdFormat;
+} MPI3_DEVICE1_DEV_SPEC_FORMAT, MPI3_POINTER PTR_MPI3_DEVICE1_DEV_SPEC_FORMAT,
+  Mpi3Device1DevSpecFormat_t, MPI3_POINTER pMpi3Device1DevSpecFormat_t;
+
+typedef struct _MPI3_DEVICE_PAGE1 {
+    MPI3_CONFIG_PAGE_HEADER         Header;                 /* 0x00 */
+    U16                             DevHandle;              /* 0x08 */
+    U16                             Reserved0A;             /* 0x0A */
+    U32                             Reserved0C[12];         /* 0x0C */
+    U8                              Reserved3C[3];          /* 0x3C */
+    U8                              DeviceForm;             /* 0x3F */
+    MPI3_DEVICE1_DEV_SPEC_FORMAT    DeviceSpecific;         /* 0x40 */
+} MPI3_DEVICE_PAGE1, MPI3_POINTER PTR_MPI3_DEVICE_PAGE1,
+  Mpi3DevicePage1_t, MPI3_POINTER pMpi3DevicePage1_t;
+
+/**** Defines for the PageVersion field ****/
+#define MPI3_DEVICE1_PAGEVERSION                            (0x00)
+
+/**** Defines for the DeviceForm field - use MPI3_DEVICE_DEVFORM_ defines ****/
+
+#endif  /* MPI30_CNFG_H */
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
new file mode 100644
index 000000000000..b60a5899437e
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
@@ -0,0 +1,46 @@
+/*
+ *  Copyright 2016-2020 Broadcom Inc. All rights reserved.
+ *
+ *           Name: mpi30_sas.h
+ *    Description: Contains MPI Serial Attached SCSI structures and definitions
+ *  Creation Date: 12/08/2016
+ *        Version: 03.00.00
+ */
+#ifndef MPI30_SAS_H
+#define MPI30_SAS_H     1
+
+/*****************************************************************************
+ *              SAS Device Info Definitions                                  *
+ ****************************************************************************/
+#define MPI3_SAS_DEVICE_INFO_SSP_TARGET             (0x00000100)
+#define MPI3_SAS_DEVICE_INFO_STP_SATA_TARGET        (0x00000080)
+#define MPI3_SAS_DEVICE_INFO_SMP_TARGET             (0x00000040)
+#define MPI3_SAS_DEVICE_INFO_SSP_INITIATOR          (0x00000020)
+#define MPI3_SAS_DEVICE_INFO_STP_INITIATOR          (0x00000010)
+#define MPI3_SAS_DEVICE_INFO_SMP_INITIATOR          (0x00000008)
+#define MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK       (0x00000007)
+#define MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_NO_DEVICE  (0x00000000)
+#define MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_END_DEVICE (0x00000001)
+#define MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_EXPANDER   (0x00000002)
+
+/*****************************************************************************
+ *              SMP Passthrough Request Message                              *
+ ****************************************************************************/
+typedef struct _MPI3_SMP_PASSTHROUGH_REQUEST {
+    U16                     HostTag;                        /* 0x00 */
+    U8                      IOCUseOnly02;                   /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     IOCUseOnly04;                   /* 0x04 */
+    U8                      IOCUseOnly06;                   /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U16                     ChangeCount;                    /* 0x08 */
+    U8                      Reserved0A;                     /* 0x0A */
+    U8                      IOUnitPort;                     /* 0x0B */
+    U32                     Reserved0C[3];                  /* 0x0C */
+    U64                     SASAddress;                     /* 0x18 */
+    MPI3_SGE_SIMPLE         RequestSGE;                     /* 0x20 */
+    MPI3_SGE_SIMPLE         ResponseSGE;                    /* 0x30 */
+} MPI3_SMP_PASSTHROUGH_REQUEST, MPI3_POINTER PTR_MPI3_SMP_PASSTHROUGH_REQUEST,
+  Mpi3SmpPassthroughRequest_t, MPI3_POINTER pMpi3SmpPassthroughRequest_t;
+
+#endif  /* MPI30_SAS_H */
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 0fa38036dcf3..1f70a67d7868 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -134,6 +134,10 @@ extern struct list_head mrioc_list;
 #define MPI3MR_RSP_IO_QUEUED_ON_IOC \
 			MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC
 
+#define MPI3MR_DEFAULT_MDTS	(128 * 1024)
+/* Command retry count definitions */
+#define MPI3MR_DEV_RMHS_RETRY_COUNT 3
+
 /* SGE Flag definition */
 #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
@@ -313,6 +317,126 @@ struct mpi3mr_intr_info {
 	char name[MPI3MR_NAME_LENGTH];
 };
 
+/**
+ * struct tgt_dev_sas_sata - SAS/SATA device specific
+ * information cached from firmware given data
+ *
+ * @sas_address: World wide unique SAS address
+ * @dev_info: Device information bits
+ */
+struct tgt_dev_sas_sata {
+	u64 sas_address;
+	u16 dev_info;
+};
+
+/**
+ * struct tgt_dev_pcie - PCIe device specific information cached
+ * from firmware given data
+ *
+ * @mdts: Maximum data transfer size
+ * @capb: Device capabilities
+ * @pgsz: Device page size
+ * @abort_to: Timeout for abort TM
+ * @reset_to: Timeout for Target/LUN reset TM
+ */
+struct tgt_dev_pcie {
+	u32 mdts;
+	u16 capb;
+	u8 pgsz;
+	u8 abort_to;
+	u8 reset_to;
+};
+
+/**
+ * struct tgt_dev_volume - virtual device specific information
+ * cached from firmware given data
+ *
+ * @state: State of the VD
+ */
+struct tgt_dev_volume {
+	u8 state;
+};
+
+/**
+ * union _form_spec_inf - union of device specific information
+ */
+union _form_spec_inf {
+	struct tgt_dev_sas_sata sas_sata_inf;
+	struct tgt_dev_pcie pcie_inf;
+	struct tgt_dev_volume vol_inf;
+};
+
+
+
+/**
+ * struct mpi3mr_tgt_dev - target device data structure
+ *
+ * @list: List pointer
+ * @starget: Scsi_target pointer
+ * @dev_handle: FW device handle
+ * @parent_handle: FW parent device handle
+ * @slot: Slot number
+ * @encl_handle: FW enclosure handle
+ * @perst_id: FW assigned Persistent ID
+ * @dev_type: SAS/SATA/PCIE device type
+ * @is_hidden: Should be exposed to upper layers or not
+ * @host_exposed: Already exposed to host or not
+ * @q_depth: Device specific Queue Depth
+ * @wwid: World wide ID
+ * @dev_spec: Device type specific information
+ * @ref_count: Reference count
+ */
+struct mpi3mr_tgt_dev {
+	struct list_head list;
+	struct scsi_target *starget;
+	u16 dev_handle;
+	u16 parent_handle;
+	u16 slot;
+	u16 encl_handle;
+	u16 perst_id;
+	u8 dev_type;
+	u8 is_hidden;
+	u8 host_exposed;
+	u16 q_depth;
+	u64 wwid;
+	union _form_spec_inf dev_spec;
+	struct kref ref_count;
+};
+
+/**
+ * mpi3mr_tgtdev_get - k reference incrementor
+ * @s: Target device reference
+ *
+ * Increment target device reference count.
+ */
+static inline void mpi3mr_tgtdev_get(struct mpi3mr_tgt_dev *s)
+{
+	kref_get(&s->ref_count);
+}
+
+/**
+ * mpi3mr_free_tgtdev - target device memory dealloctor
+ * @r: k reference pointer of the target device
+ *
+ * Free target device memory when no reference.
+ */
+static inline void mpi3mr_free_tgtdev(struct kref *r)
+{
+	kfree(container_of(r, struct mpi3mr_tgt_dev, ref_count));
+}
+
+/**
+ * mpi3mr_tgtdev_put - k reference decrementor
+ * @s: Target device reference
+ *
+ * Decrement target device reference count.
+ */
+static inline void mpi3mr_tgtdev_put(struct mpi3mr_tgt_dev *s)
+{
+	kref_put(&s->ref_count, mpi3mr_free_tgtdev);
+}
+
+
 /**
  * struct mpi3mr_stgt_priv_data - SCSI target private structure
  *
@@ -362,6 +486,7 @@ typedef void (*DRV_CMD_CALLBACK)(struct mpi3mr_ioc *mrioc,
  * @done: Completeor for wakeup
  * @reply: Firmware reply for internal commands
  * @sensebuf: Sensebuf for SCSI IO commands
+ * @iou_rc: IO Unit control reason code
  * @state: Command State
  * @dev_handle: Firmware handle for device specific commands
  * @ioc_status: IOC status from the firmware
@@ -376,6 +501,7 @@ struct mpi3mr_drv_cmd {
 	struct completion done;
 	void *reply;
 	u8 *sensebuf;
+	u8 iou_rc;
 	u16 state;
 	u16 dev_handle;
 	u16 ioc_status;
@@ -480,6 +606,11 @@ struct scmd_priv {
  * @sense_buf_q_dma: Sense buffer queue DMA address
  * @sbq_lock: Sense buffer queue lock
  * @sbq_host_index: Sense buffer queuehost index
+ * @event_masks: Event mask bitmap
+ * @fwevt_worker_name: Firmware event worker thread name
+ * @fwevt_worker_thread: Firmware event worker thread
+ * @fwevt_lock: Firmware event lock
+ * @fwevt_list: Firmware event list
  * @watchdog_work_q_name: Fault watchdog worker thread name
  * @watchdog_work_q: Fault watchdog worker thread
  * @watchdog_work: Fault watchdog work
@@ -495,6 +626,12 @@ struct scmd_priv {
  * @chain_bitmap_sz: Chain buffer allocator bitmap size
  * @chain_bitmap: Chain buffer allocator bitmap
  * @chain_buf_lock: Chain buffer list lock
+ * @dev_rmhs_cmds: Command tracker for device removal commands
+ * @devrem_bitmap_sz: Device removal bitmap size
+ * @devrem_bitmap: Device removal bitmap
+ * @dev_handle_bitmap_sz: Device handle bitmap size
+ * @removepend_bitmap: Remove pending bitmap
+ * @delayed_rmhs_list: Delayed device removal list
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
  * @diagsave_timeout: Diagnostic information save timeout
@@ -578,6 +715,12 @@ struct mpi3mr_ioc {
 	dma_addr_t sense_buf_q_dma;
 	spinlock_t sbq_lock;
 	u32 sbq_host_index;
+	u32 event_masks[MPI3_EVENT_NOTIFY_EVENTMASK_WORDS];
+
+	char fwevt_worker_name[MPI3MR_NAME_LENGTH];
+	struct workqueue_struct	*fwevt_worker_thread;
+	spinlock_t fwevt_lock;
+	struct list_head fwevt_list;
 
 	char watchdog_work_q_name[20];
 	struct workqueue_struct *watchdog_work_q;
@@ -590,6 +733,8 @@ struct mpi3mr_ioc {
 	u8 stop_drv_processing;
 
 	u16 max_host_ios;
+	spinlock_t tgtdev_lock;
+	struct list_head tgtdev_list;
 
 	u32 chain_buf_count;
 	struct dma_pool *chain_buf_pool;
@@ -598,6 +743,13 @@ struct mpi3mr_ioc {
 	void *chain_bitmap;
 	spinlock_t chain_buf_lock;
 
+	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
+	u16 devrem_bitmap_sz;
+	void *devrem_bitmap;
+	u16 dev_handle_bitmap_sz;
+	void *removepend_bitmap;
+	struct list_head delayed_rmhs_list;
+
 	u8 reset_in_progress;
 	u8 unrecoverable;
 
@@ -610,6 +762,45 @@ struct mpi3mr_ioc {
 	u16 op_reply_q_offset;
 };
 
+/**
+ * struct mpi3mr_fwevt - Firmware event structure.
+ *
+ * @list: list head
+ * @work: Work structure
+ * @mrioc: Adapter instance reference
+ * @event_id: MPI3 firmware event ID
+ * @send_ack: Event acknowledgment required or not
+ * @process_evt: Bottomhalf processing required or not
+ * @evt_ctx: Event context to send in Ack
+ * @ref_count: kref count
+ * @event_data: Actual MPI3 event data
+ */
+struct mpi3mr_fwevt {
+	struct list_head list;
+	struct work_struct work;
+	struct mpi3mr_ioc *mrioc;
+	u16 event_id;
+	bool send_ack;
+	bool process_evt;
+	u32 evt_ctx;
+	struct kref ref_count;
+	char event_data[0] __aligned(4);
+};
+
+
+/**
+ * struct delayed_dev_rmhs_node - Delayed device removal node
+ *
+ * @list: list head
+ * @handle: Device handle
+ * @iou_rc: IO Unit Control Reason Code
+ */
+struct delayed_dev_rmhs_node {
+	struct list_head list;
+	u16 handle;
+	u8 iou_rc;
+};
+
 int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
 void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
 int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
@@ -629,6 +820,8 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
 				     u64 sense_buf_dma);
 
+void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
+			     Mpi3EventNotificationReply_t *event_reply);
 void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 				  Mpi3DefaultReplyDescriptor_t *reply_desc,
 				  u64 *reply_dma, u16 qidx);
@@ -641,5 +834,7 @@ void mpi3mr_ioc_disable_intr(struct mpi3mr_ioc *mrioc);
 void mpi3mr_ioc_enable_intr(struct mpi3mr_ioc *mrioc);
 
 enum mpi3mr_iocstate mpi3mr_get_iocstate(struct mpi3mr_ioc *mrioc);
+int mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
+			  u32 event_ctx);
 
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4f1524dcad4d..c3933c9b73fc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -160,6 +160,7 @@ static void mpi3mr_handle_events(struct mpi3mr_ioc *mrioc,
 	    (Mpi3EventNotificationReply_t *)def_reply;
 
 	mrioc->change_count = le16_to_cpu(event_reply->IOCChangeCount);
+	mpi3mr_os_handle_events(mrioc, event_reply);
 }
 
 static struct mpi3mr_drv_cmd *
@@ -2137,6 +2138,162 @@ static int mpi3mr_issue_iocinit(struct mpi3mr_ioc *mrioc)
 	return retval;
 }
 
+/**
+ * mpi3mr_unmask_events - Unmask events in event mask bitmap
+ * @mrioc: Adapter instance reference
+ * @event: MPI event ID
+ *
+ * Un mask the specific event by resetting the event_mask
+ * bitmap.
+ *
+ * Return: 0 on success, non-zero on failures.
+ */
+static void mpi3mr_unmask_events(struct mpi3mr_ioc *mrioc, u16 event)
+{
+	u32 desired_event;
+	u8 word;
+
+	if (event >= 128)
+		return;
+
+	desired_event = (1 << (event % 32));
+	word = event / 32;
+
+	mrioc->event_masks[word] &= ~desired_event;
+}
+
+/**
+ * mpi3mr_issue_event_notification - Send event notification
+ * @mrioc: Adapter instance reference
+ *
+ * Issue event notification MPI request through admin queue and
+ * wait for the completion of it or time out.
+ *
+ * Return: 0 on success, non-zero on failures.
+ */
+static int mpi3mr_issue_event_notification(struct mpi3mr_ioc *mrioc)
+{
+	Mpi3EventNotificationRequest_t evtnotify_req;
+	int retval = 0;
+	u8 i;
+
+	memset(&evtnotify_req, 0, sizeof(evtnotify_req));
+	mutex_lock(&mrioc->init_cmds.mutex);
+	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
+		retval = -1;
+		ioc_err(mrioc, "Issue EvtNotify: Init command is in use\n");
+		mutex_unlock(&mrioc->init_cmds.mutex);
+		goto out;
+	}
+	mrioc->init_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->init_cmds.is_waiting = 1;
+	mrioc->init_cmds.callback = NULL;
+	evtnotify_req.HostTag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
+	evtnotify_req.Function = MPI3_FUNCTION_EVENT_NOTIFICATION;
+	for (i = 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
+		evtnotify_req.EventMasks[i] =
+		    cpu_to_le32(mrioc->event_masks[i]);
+	init_completion(&mrioc->init_cmds.done);
+	retval = mpi3mr_admin_request_post(mrioc, &evtnotify_req,
+	    sizeof(evtnotify_req), 1);
+	if (retval) {
+		ioc_err(mrioc, "Issue EvtNotify: Admin Post failed\n");
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->init_cmds.done,
+	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
+	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		ioc_err(mrioc, "Issue EvtNotify: command timed out\n");
+		mpi3mr_set_diagsave(mrioc);
+		mpi3mr_issue_reset(mrioc,
+		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+		    MPI3MR_RESET_FROM_EVTNOTIFY_TIMEOUT);
+		mrioc->unrecoverable = 1;
+		retval = -1;
+		goto out_unlock;
+	}
+	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	    != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc,
+		    "Issue EvtNotify: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
+		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
+		    mrioc->init_cmds.ioc_loginfo);
+		retval = -1;
+		goto out_unlock;
+	}
+
+out_unlock:
+	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->init_cmds.mutex);
+out:
+	return retval;
+}
+
+/**
+ * mpi3mr_send_event_ack - Send event acknowledgment
+ * @event: MPI3 event ID
+ * @event_ctx: Event context
+ *
+ * Send event acknowledgment through admin queue and wait for
+ * it to complete.
+ *
+ * Return: 0 on success, non-zero on failures.
+ */
+int mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
+	u32 event_ctx)
+{
+	Mpi3EventAckRequest_t evtack_req;
+	int retval = 0;
+
+	memset(&evtack_req, 0, sizeof(evtack_req));
+	mutex_lock(&mrioc->init_cmds.mutex);
+	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
+		retval = -1;
+		ioc_err(mrioc, "Send EvtAck: Init command is in use\n");
+		mutex_unlock(&mrioc->init_cmds.mutex);
+		goto out;
+	}
+	mrioc->init_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->init_cmds.is_waiting = 1;
+	mrioc->init_cmds.callback = NULL;
+	evtack_req.HostTag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
+	evtack_req.Function = MPI3_FUNCTION_EVENT_ACK;
+	evtack_req.Event = event;
+	evtack_req.EventContext = cpu_to_le32(event_ctx);
+
+	init_completion(&mrioc->init_cmds.done);
+	retval = mpi3mr_admin_request_post(mrioc, &evtack_req,
+	    sizeof(evtack_req), 1);
+	if (retval) {
+		ioc_err(mrioc, "Send EvtAck: Admin Post failed\n");
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->init_cmds.done,
+	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
+	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		ioc_err(mrioc, "Issue EvtNotify: command timed out\n");
+		mpi3mr_soft_reset_handler(mrioc,
+		    MPI3MR_RESET_FROM_EVTACK_TIMEOUT, 1);
+		retval = -1;
+		goto out_unlock;
+	}
+	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	    != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc,
+		    "Send EvtAck: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
+		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
+		    mrioc->init_cmds.ioc_loginfo);
+		retval = -1;
+		goto out_unlock;
+	}
+
+out_unlock:
+	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->init_cmds.mutex);
+out:
+	return retval;
+}
+
 
 /**
  * mpi3mr_alloc_chain_bufs - Allocate chain buffers
@@ -2418,7 +2575,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	enum mpi3mr_iocstate ioc_state;
 	u64 base_info;
 	u32 timeout;
-	u32 ioc_status, ioc_config;
+	u32 ioc_status, ioc_config, i;
 	Mpi3IOCFactsData_t facts_data;
 
 	mrioc->change_count = 0;
@@ -2568,6 +2725,24 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
+	for (i = 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
+		mrioc->event_masks[i] = -1;
+
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_ADDED);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_INFO_CHANGED);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_STATUS_CHANGE);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
+
+	retval = mpi3mr_issue_event_notification(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "Failed to issue event notification %d\n",
+		    retval);
+		goto out_failed;
+	}
+
 	return retval;
 
 out_failed:
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 7b0d52481929..e0ca657bfff5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -125,6 +125,1284 @@ static void mpi3mr_clear_scmd_priv(struct mpi3mr_ioc *mrioc,
 	}
 }
 
+static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
+	struct mpi3mr_drv_cmd *cmdparam, u8 iou_rc);
+static void mpi3mr_fwevt_worker(struct work_struct *work);
+
+
+/**
+ * mpi3mr_fwevt_free - firmware event memory dealloctor
+ * @r: k reference pointer of the firmware event
+ *
+ * Free firmware event memory when no reference.
+ */
+static void mpi3mr_fwevt_free(struct kref *r)
+{
+	kfree(container_of(r, struct mpi3mr_fwevt, ref_count));
+}
+
+/**
+ * mpi3mr_fwevt_get - k reference incrementor
+ * @fwevt: Firmware event reference
+ *
+ * Increment firmware event reference count.
+ */
+static void mpi3mr_fwevt_get(struct mpi3mr_fwevt *fwevt)
+{
+	kref_get(&fwevt->ref_count);
+}
+
+/**
+ * mpi3mr_fwevt_put - k reference decrementor
+ * @fwevt: Firmware event reference
+ *
+ * Decrement firmware event reference count.
+ */
+static void mpi3mr_fwevt_put(struct mpi3mr_fwevt *fwevt)
+{
+	kref_put(&fwevt->ref_count, mpi3mr_fwevt_free);
+}
+
+/**
+ * mpi3mr_alloc_fwevt - Allocate firmware event
+ * @len: Length of firmware event data to allocate
+ *
+ * Allocate firmware event with required length and initialize
+ * the reference counter.
+ *
+ * Return: firmware event reference.
+ */
+static struct mpi3mr_fwevt *mpi3mr_alloc_fwevt(int len)
+{
+	struct mpi3mr_fwevt *fwevt;
+
+	fwevt = kzalloc(sizeof(*fwevt) + len, GFP_ATOMIC);
+	if (!fwevt)
+		return NULL;
+
+	kref_init(&fwevt->ref_count);
+	return fwevt;
+}
+
+/**
+ * mpi3mr_fwevt_add_to_list - Add firmware event to the list
+ * @mrioc: Adapter instance reference
+ * @fwevt: Firmware event reference
+ *
+ * Add the given firmware event to the firmware event list.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_fwevt_add_to_list(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_fwevt *fwevt)
+{
+	unsigned long flags;
+
+	if (mrioc->fwevt_worker_thread == NULL)
+		return;
+
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	/* get fwevt reference count while adding it to fwevt_list */
+	mpi3mr_fwevt_get(fwevt);
+	INIT_LIST_HEAD(&fwevt->list);
+	list_add_tail(&fwevt->list, &mrioc->fwevt_list);
+	INIT_WORK(&fwevt->work, mpi3mr_fwevt_worker);
+	/* get fwevt reference count while enqueueing it to worker queue */
+	mpi3mr_fwevt_get(fwevt);
+	queue_work(mrioc->fwevt_worker_thread, &fwevt->work);
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+}
+
+/**
+ * mpi3mr_fwevt_del_from_list - Delete firmware event from list
+ * @mrioc: Adapter instance reference
+ * @fwevt: Firmware event reference
+ *
+ * Delete the given firmware event from the firmware event list.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_fwevt_del_from_list(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_fwevt *fwevt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	if (!list_empty(&fwevt->list)) {
+		list_del_init(&fwevt->list);
+		/*
+		 * Put fwevt reference count after
+		 * removing it from fwevt_list
+		 */
+		mpi3mr_fwevt_put(fwevt);
+	}
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+}
+
+/**
+ * mpi3mr_dequeue_fwevt - Dequeue firmware event from the list
+ * @mrioc: Adapter instance reference
+ *
+ * Dequeue a firmware event from the firmware event list.
+ *
+ * Return: firmware event.
+ */
+static struct mpi3mr_fwevt *mpi3mr_dequeue_fwevt(
+	struct mpi3mr_ioc *mrioc)
+{
+	unsigned long flags;
+	struct mpi3mr_fwevt *fwevt = NULL;
+
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	if (!list_empty(&mrioc->fwevt_list)) {
+		fwevt = list_first_entry(&mrioc->fwevt_list,
+		    struct mpi3mr_fwevt, list);
+		list_del_init(&fwevt->list);
+		/*
+		 * Put fwevt reference count after
+		 * removing it from fwevt_list
+		 */
+		mpi3mr_fwevt_put(fwevt);
+	}
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+
+	return fwevt;
+}
+
+/**
+ * mpi3mr_cleanup_fwevt_list - Cleanup firmware event list
+ * @mrioc: Adapter instance reference
+ *
+ * Flush all pending firmware events from the firmware event
+ * list.
+ *
+ * Return: Nothing.
+ */
+void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3mr_fwevt *fwevt = NULL;
+
+	if ((list_empty(&mrioc->fwevt_list) && !mrioc->current_event) ||
+	    !mrioc->fwevt_worker_thread || in_interrupt())
+		return;
+
+	while ((fwevt = mpi3mr_dequeue_fwevt(mrioc)) ||
+	    (fwevt = mrioc->current_event)) {
+		/*
+		 * Wait on the fwevt to complete. If this returns 1, then
+		 * the event was never executed, and we need a put for the
+		 * reference the work had on the fwevt.
+		 *
+		 * If it did execute, we wait for it to finish, and the put will
+		 * happen from mpi3mr_process_fwevt()
+		 */
+		if (cancel_work_sync(&fwevt->work)) {
+			/*
+			 * Put fwevt reference count after
+			 * dequeuing it from worker queue
+			 */
+			mpi3mr_fwevt_put(fwevt);
+			/*
+			 * Put fwevt reference count to neutralize
+			 * kref_init increment
+			 */
+			mpi3mr_fwevt_put(fwevt);
+		}
+	}
+}
+
+/**
+ * mpi3mr_alloc_tgtdev - target device allocator
+ *
+ * Allocate target device instance and initialize the reference
+ * count
+ *
+ * Return: target device instance.
+ */
+static struct mpi3mr_tgt_dev *mpi3mr_alloc_tgtdev(void)
+{
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	tgtdev = kzalloc(sizeof(*tgtdev), GFP_ATOMIC);
+	if (!tgtdev)
+		return NULL;
+	kref_init(&tgtdev->ref_count);
+	return tgtdev;
+}
+
+/**
+ * mpi3mr_tgtdev_add_to_list -Add tgtdevice to the list
+ * @mrioc: Adapter instance reference
+ * @tgtdev: Target device
+ *
+ * Add the target device to the target device list
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_tgtdev_add_to_list(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_tgt_dev *tgtdev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	mpi3mr_tgtdev_get(tgtdev);
+	INIT_LIST_HEAD(&tgtdev->list);
+	list_add_tail(&tgtdev->list, &mrioc->tgtdev_list);
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+}
+
+/**
+ * mpi3mr_tgtdev_del_from_list -Delete tgtdevice from the list
+ * @mrioc: Adapter instance reference
+ * @tgtdev: Target device
+ *
+ * Remove the target device from the target device list
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_tgtdev_del_from_list(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_tgt_dev *tgtdev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	if (!list_empty(&tgtdev->list)) {
+		list_del_init(&tgtdev->list);
+		mpi3mr_tgtdev_put(tgtdev);
+	}
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+}
+
+/**
+ * __mpi3mr_get_tgtdev_by_handle -Get tgtdev from device handle
+ * @mrioc: Adapter instance reference
+ * @handle: Device handle
+ *
+ * Accessor to retrieve target device from the device handle.
+ * Non Lock version
+ *
+ * Return: Target device reference.
+ */
+static struct mpi3mr_tgt_dev  *__mpi3mr_get_tgtdev_by_handle(
+	struct mpi3mr_ioc *mrioc, u16 handle)
+{
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	assert_spin_locked(&mrioc->tgtdev_lock);
+	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list)
+		if (tgtdev->dev_handle == handle)
+			goto found_tgtdev;
+	return NULL;
+
+found_tgtdev:
+	mpi3mr_tgtdev_get(tgtdev);
+	return tgtdev;
+}
+
+/**
+ * mpi3mr_get_tgtdev_by_handle -Get tgtdev from device handle
+ * @mrioc: Adapter instance reference
+ * @handle: Device handle
+ *
+ * Accessor to retrieve target device from the device handle.
+ * Lock version
+ *
+ * Return: Target device reference.
+ */
+struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
+	struct mpi3mr_ioc *mrioc, u16 handle)
+{
+	struct mpi3mr_tgt_dev *tgtdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgtdev = __mpi3mr_get_tgtdev_by_handle(mrioc, handle);
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+	return tgtdev;
+}
+
+/**
+ * __mpi3mr_get_tgtdev_by_perst_id -Get tgtdev from persist ID
+ * @mrioc: Adapter instance reference
+ * @persist_id: Persistent ID
+ *
+ * Accessor to retrieve target device from the Persistent ID.
+ * Non Lock version
+ *
+ * Return: Target device reference.
+ */
+static struct mpi3mr_tgt_dev  *__mpi3mr_get_tgtdev_by_perst_id(
+	struct mpi3mr_ioc *mrioc, u16 persist_id)
+{
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	assert_spin_locked(&mrioc->tgtdev_lock);
+	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list)
+		if (tgtdev->perst_id == persist_id)
+			goto found_tgtdev;
+	return NULL;
+
+found_tgtdev:
+	mpi3mr_tgtdev_get(tgtdev);
+	return tgtdev;
+}
+
+/**
+ * mpi3mr_get_tgtdev_by_perst_id -Get tgtdev from persistent ID
+ * @mrioc: Adapter instance reference
+ * @persist_id: Persistent ID
+ *
+ * Accessor to retrieve target device from the Persistent ID.
+ * Lock version
+ *
+ * Return: Target device reference.
+ */
+struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_perst_id(
+	struct mpi3mr_ioc *mrioc, u16 persist_id)
+{
+	struct mpi3mr_tgt_dev *tgtdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgtdev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, persist_id);
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+	return tgtdev;
+}
+
+
+/**
+ * __mpi3mr_get_tgtdev_from_tgtpriv -Get tgtdev from tgt private
+ * @mrioc: Adapter instance reference
+ * @tgt_priv: Target private data
+ *
+ * Accessor to return target device from the target private
+ * data. Non Lock version
+ *
+ * Return: Target device reference.
+ */
+static struct mpi3mr_tgt_dev  *__mpi3mr_get_tgtdev_from_tgtpriv(
+	struct mpi3mr_ioc *mrioc, struct mpi3mr_stgt_priv_data *tgt_priv)
+{
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	assert_spin_locked(&mrioc->tgtdev_lock);
+	tgtdev = tgt_priv->tgt_dev;
+	if (tgtdev)
+		mpi3mr_tgtdev_get(tgtdev);
+	return tgtdev;
+}
+
+/**
+ * mpi3mr_remove_tgtdev_from_host - Remove dev from upper layers
+ * @mrioc: Adapter instance reference
+ * @tgtdev: Target device structure
+ *
+ * Checks whether the device is exposed to upper layers and if it
+ * is then remove the device from upper layers by calling
+ * scsi_remove_target().
+ *
+ * Return: 0 on success, non zero on failure.
+ */
+static void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_tgt_dev *tgtdev)
+{
+	struct mpi3mr_stgt_priv_data *tgt_priv;
+
+
+	ioc_info(mrioc, "%s :Removing handle(0x%04x), wwid(0x%016llx)\n",
+	    __func__, tgtdev->dev_handle, (unsigned long long) tgtdev->wwid);
+	if (tgtdev->starget && tgtdev->starget->hostdata) {
+		tgt_priv = tgtdev->starget->hostdata;
+		tgt_priv->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+	}
+
+	if (tgtdev->starget) {
+		scsi_remove_target(&tgtdev->starget->dev);
+		tgtdev->host_exposed = 0;
+	}
+	ioc_info(mrioc, "%s :Removed handle(0x%04x), wwid(0x%016llx)\n",
+	    __func__, tgtdev->dev_handle, (unsigned long long) tgtdev->wwid);
+}
+
+
+/**
+ * mpi3mr_report_tgtdev_to_host - Expose device to upper layers
+ * @mrioc: Adapter instance reference
+ * @perst_id: Persistent ID of the device
+ *
+ * Checks whether the device can be exposed to upper layers and
+ * if it is not then expose the device to upper layers by
+ * calling scsi_scan_target().
+ *
+ * Return: 0 on success, non zero on failure.
+ */
+static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
+	u16 perst_id)
+{
+	int retval = 0;
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	tgtdev = mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
+	if (!tgtdev) {
+		retval = -1;
+		goto out;
+	}
+	if (tgtdev->is_hidden) {
+		retval = -1;
+		goto out;
+	}
+	if (!tgtdev->host_exposed && !mrioc->reset_in_progress) {
+		tgtdev->host_exposed = 1;
+		scsi_scan_target(&mrioc->shost->shost_gendev, 0,
+		    tgtdev->perst_id,
+		    SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
+		if (!tgtdev->starget)
+			tgtdev->host_exposed = 0;
+	}
+out:
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
+	return retval;
+}
+
+/**
+ * mpi3mr_rfresh_tgtdevs - Refresh target device exposure
+ * @mrioc: Adapter instance reference
+ *
+ * This is executed post controller reset to identify any
+ * missing devices during reset and remove from the upper layers
+ * or expose any newly detected device to the upper layers.
+ *
+ * Return: Nothing.
+ */
+
+void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
+
+	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
+	    list) {
+		if ((tgtdev->dev_handle == MPI3MR_INVALID_DEV_HANDLE) &&
+		    tgtdev->host_exposed) {
+			mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+			mpi3mr_tgtdev_put(tgtdev);
+		}
+	}
+
+	tgtdev = NULL;
+	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
+		if ((tgtdev->dev_handle != MPI3MR_INVALID_DEV_HANDLE) &&
+		    !tgtdev->is_hidden && !tgtdev->host_exposed)
+			mpi3mr_report_tgtdev_to_host(mrioc, tgtdev->perst_id);
+	}
+}
+
+/**
+ * mpi3mr_update_tgtdev - DevStatusChange evt bottomhalf
+ * @mrioc: Adapter instance reference
+ * @tgtdev: Target device internal structure
+ * @dev_pg0: New device page0
+ *
+ * Update the information from the device page0 into the driver
+ * cached target device structure.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_tgt_dev *tgtdev, Mpi3DevicePage0_t *dev_pg0)
+{
+	u16 flags = 0;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
+
+	tgtdev->perst_id = le16_to_cpu(dev_pg0->PersistentID);
+	tgtdev->dev_handle = le16_to_cpu(dev_pg0->DevHandle);
+	tgtdev->dev_type = dev_pg0->DeviceForm;
+	tgtdev->encl_handle = le16_to_cpu(dev_pg0->EnclosureHandle);
+	tgtdev->parent_handle = le16_to_cpu(dev_pg0->ParentDevHandle);
+	tgtdev->slot = le16_to_cpu(dev_pg0->Slot);
+	tgtdev->q_depth = le16_to_cpu(dev_pg0->QueueDepth);
+	tgtdev->wwid = le64_to_cpu(dev_pg0->WWID);
+
+	flags = le16_to_cpu(dev_pg0->Flags);
+	tgtdev->is_hidden = (flags & MPI3_DEVICE0_FLAGS_HIDDEN);
+
+	if (tgtdev->starget && tgtdev->starget->hostdata) {
+		scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
+		    tgtdev->starget->hostdata;
+		scsi_tgt_priv_data->perst_id = tgtdev->perst_id;
+		scsi_tgt_priv_data->dev_handle = tgtdev->dev_handle;
+		scsi_tgt_priv_data->dev_type = tgtdev->dev_type;
+	}
+
+	switch (tgtdev->dev_type) {
+	case MPI3_DEVICE_DEVFORM_SAS_SATA:
+	{
+		Mpi3Device0SasSataFormat_t *sasinf =
+		    &dev_pg0->DeviceSpecific.SasSataFormat;
+		u16 dev_info = le16_to_cpu(sasinf->DeviceInfo);
+
+		tgtdev->dev_spec.sas_sata_inf.dev_info = dev_info;
+		tgtdev->dev_spec.sas_sata_inf.sas_address =
+		    le64_to_cpu(sasinf->SASAddress);
+		if ((dev_info & MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK) !=
+		    MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_END_DEVICE)
+			tgtdev->is_hidden = 1;
+		else if (!(dev_info & (MPI3_SAS_DEVICE_INFO_STP_SATA_TARGET |
+		    MPI3_SAS_DEVICE_INFO_SSP_TARGET)))
+			tgtdev->is_hidden = 1;
+		break;
+	}
+	case MPI3_DEVICE_DEVFORM_VD:
+	{
+		Mpi3Device0VdFormat_t *vdinf =
+		    &dev_pg0->DeviceSpecific.VdFormat;
+
+		tgtdev->dev_spec.vol_inf.state = vdinf->VdState;
+		if (vdinf->VdState == MPI3_DEVICE0_VD_STATE_OFFLINE)
+			tgtdev->is_hidden = 1;
+		break;
+	}
+	default:
+		break;
+	}
+}
+
+/**
+ * mpi3mr_devstatuschg_evt_bh - DevStatusChange evt bottomhalf
+ * @mrioc: Adapter instance reference
+ * @dev_pg0: New device page0
+ *
+ * Process Device Status Change event and based on device's new
+ * information, either expose the device to the upper layers, or
+ * remove the device from upper layers.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_devstatuschg_evt_bh(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_fwevt *fwevt)
+{
+	u16 dev_handle = 0;
+	u8 uhide = 0, delete = 0, cleanup = 0;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
+	Mpi3EventDataDeviceStatusChange_t *evtdata =
+	    (Mpi3EventDataDeviceStatusChange_t *)fwevt->event_data;
+
+
+	dev_handle = le16_to_cpu(evtdata->DevHandle);
+	ioc_info(mrioc,
+	    "%s :device status change: handle(0x%04x): reason code(0x%x)\n",
+	    __func__, dev_handle, evtdata->ReasonCode);
+	switch (evtdata->ReasonCode) {
+	case MPI3_EVENT_DEV_STAT_RC_HIDDEN:
+		delete = 1;
+		break;
+	case MPI3_EVENT_DEV_STAT_RC_NOT_HIDDEN:
+		uhide = 1;
+		break;
+	case MPI3_EVENT_DEV_STAT_RC_VD_NOT_RESPONDING:
+		delete = 1;
+		cleanup = 1;
+		break;
+	default:
+		ioc_info(mrioc, "%s :Unhandled reason code(0x%x)\n", __func__,
+		    evtdata->ReasonCode);
+		break;
+	}
+
+	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
+	if (!tgtdev)
+		goto out;
+	if (uhide) {
+		tgtdev->is_hidden = 0;
+		if (!tgtdev->host_exposed)
+			mpi3mr_report_tgtdev_to_host(mrioc, tgtdev->perst_id);
+	}
+	if (tgtdev->starget && tgtdev->starget->hostdata) {
+		scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
+		    tgtdev->starget->hostdata;
+		if (delete)
+			mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+	}
+	if (cleanup) {
+		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+		mpi3mr_tgtdev_put(tgtdev);
+	}
+
+out:
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
+}
+
+/**
+ * mpi3mr_devinfochg_evt_bh - DeviceInfoChange evt bottomhalf
+ * @mrioc: Adapter instance reference
+ * @dev_pg0: New device page0
+ *
+ * Process Device Info Change event and based on device's new
+ * information, either expose the device to the upper layers, or
+ * remove the device from upper layers or update the details of
+ * the device.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
+	Mpi3DevicePage0_t *dev_pg0)
+{
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	u16 dev_handle = 0, perst_id = 0;
+
+	perst_id = le16_to_cpu(dev_pg0->PersistentID);
+	dev_handle = le16_to_cpu(dev_pg0->DevHandle);
+	ioc_info(mrioc,
+	    "%s :Device info change: handle(0x%04x): persist_id(0x%x)\n",
+	    __func__, dev_handle, perst_id);
+	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
+	if (!tgtdev)
+		goto out;
+	mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0);
+	if (!tgtdev->is_hidden && !tgtdev->host_exposed)
+		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
+	if (tgtdev->is_hidden && tgtdev->host_exposed)
+		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+out:
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
+}
+
+/**
+ * mpi3mr_sastopochg_evt_bh - SASTopologyChange evt bottomhalf
+ * @mrioc: Adapter instance reference
+ * @fwevt: Firmware event reference
+ *
+ * Prints information about the SAS topology change event and
+ * for "not responding" event code, removes the device from the
+ * upper layers.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_fwevt *fwevt)
+{
+	Mpi3EventDataSasTopologyChangeList_t *event_data =
+	    (Mpi3EventDataSasTopologyChangeList_t *)fwevt->event_data;
+	int i;
+	u16 handle;
+	u8 reason_code;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+
+	for (i = 0; i < event_data->NumEntries; i++) {
+		handle = le16_to_cpu(event_data->PhyEntry[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
+		if (!tgtdev)
+			continue;
+
+		reason_code = event_data->PhyEntry[i].Status &
+		    MPI3_EVENT_SAS_TOPO_PHY_RC_MASK;
+
+		switch (reason_code) {
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING:
+			if (tgtdev->host_exposed)
+				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+			mpi3mr_tgtdev_put(tgtdev);
+			break;
+		default:
+			break;
+		}
+		if (tgtdev)
+			mpi3mr_tgtdev_put(tgtdev);
+	}
+}
+
+/**
+ * mpi3mr_fwevt_bh - Firmware event bottomhalf handler
+ * @mrioc: Adapter instance reference
+ * @fwevt: Firmware event reference
+ *
+ * Identifies the firmware event and calls corresponding bottomg
+ * half handler and sends event acknowledgment if required.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_fwevt *fwevt)
+{
+	mrioc->current_event = fwevt;
+	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
+
+	if (mrioc->stop_drv_processing)
+		goto out;
+
+	if (!fwevt->process_evt)
+		goto evt_ack;
+
+	switch (fwevt->event_id) {
+	case MPI3_EVENT_DEVICE_ADDED:
+	{
+		Mpi3DevicePage0_t *dev_pg0 =
+		    (Mpi3DevicePage0_t *) fwevt->event_data;
+		mpi3mr_report_tgtdev_to_host(mrioc,
+		    le16_to_cpu(dev_pg0->PersistentID));
+		break;
+	}
+	case MPI3_EVENT_DEVICE_INFO_CHANGED:
+	{
+		mpi3mr_devinfochg_evt_bh(mrioc,
+		    (Mpi3DevicePage0_t *) fwevt->event_data);
+		break;
+	}
+	case MPI3_EVENT_DEVICE_STATUS_CHANGE:
+	{
+		mpi3mr_devstatuschg_evt_bh(mrioc, fwevt);
+		break;
+	}
+	case MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
+	{
+		mpi3mr_sastopochg_evt_bh(mrioc, fwevt);
+		break;
+	}
+	default:
+		break;
+	}
+
+evt_ack:
+	if (fwevt->send_ack)
+		mpi3mr_send_event_ack(mrioc, fwevt->event_id,
+		    fwevt->evt_ctx);
+out:
+	/* Put fwevt reference count to neutralize kref_init increment */
+	mpi3mr_fwevt_put(fwevt);
+	mrioc->current_event = NULL;
+
+}
+
+/**
+ * mpi3mr_fwevt_worker - Firmware event worker
+ * @work: Work struct containing firmware event
+ *
+ * Extracts the firmware event and calls mpi3mr_fwevt_bh.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_fwevt_worker(struct work_struct *work)
+{
+	struct mpi3mr_fwevt *fwevt = container_of(work, struct mpi3mr_fwevt,
+	    work);
+	mpi3mr_fwevt_bh(fwevt->mrioc, fwevt);
+	/*
+	 * Put fwevt reference count after
+	 * dequeuing it from worker queue
+	 */
+	mpi3mr_fwevt_put(fwevt);
+}
+
+
+/**
+ * mpi3mr_create_tgtdev - Create and add a target device
+ * @mrioc: Adapter instance reference
+ * @dev_pg0: Device Page 0 data
+ *
+ * If the device specified by the device page 0 data is not
+ * present in the driver's internal list, allocate the memory
+ * for the device, populate the data and add to the list, else
+ * update the device data.  The key is persistent ID.
+ *
+ * Return: 0 on success, -ENOMEM on memory allocation failure
+ */
+static int mpi3mr_create_tgtdev(struct mpi3mr_ioc *mrioc,
+	Mpi3DevicePage0_t *dev_pg0)
+{
+	int retval = 0;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	u16 perst_id = 0;
+
+	perst_id = le16_to_cpu(dev_pg0->PersistentID);
+	tgtdev = mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
+	if (tgtdev) {
+		mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0);
+		mpi3mr_tgtdev_put(tgtdev);
+	} else {
+		tgtdev = mpi3mr_alloc_tgtdev();
+		if (!tgtdev)
+			return -ENOMEM;
+		mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0);
+		mpi3mr_tgtdev_add_to_list(mrioc, tgtdev);
+	}
+
+	return retval;
+}
+
+/**
+ * mpi3mr_flush_delayed_rmhs_list - Flush pending commands
+ * @mrioc: Adapter instance reference
+ * @cmdparam: Internal command tracker
+ *
+ * Flush pending commands in the delayed removal handshake list
+ * due to a controller reset or driver removal as a cleanup.
+ *
+ * Return: Nothing
+ */
+void mpi3mr_flush_delayed_rmhs_list(struct mpi3mr_ioc *mrioc)
+{
+	struct delayed_dev_rmhs_node *_rmhs_node;
+
+	while (!list_empty(&mrioc->delayed_rmhs_list)) {
+		_rmhs_node = list_entry(mrioc->delayed_rmhs_list.next,
+		    struct delayed_dev_rmhs_node, list);
+		list_del(&_rmhs_node->list);
+		kfree(_rmhs_node);
+	}
+}
+
+/**
+ * mpi3mr_dev_rmhs_complete_iou - Device removal IOUC completion
+ * @mrioc: Adapter instance reference
+ * @cmdparam: Internal command tracker
+ *
+ * Issues a target reset TM to the firmware from the device
+ * removal TM pend list or retry the removal handshake sequence
+ * based on the IOU control request IOC status.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_dev_rmhs_complete_iou(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd)
+{
+	u16 cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
+	struct delayed_dev_rmhs_node *delayed_dev_rmhs = NULL;
+
+	ioc_info(mrioc,
+	    "%s :dev_rmhs_iouctrl_complete:handle(0x%04x), ioc_status(0x%04x), loginfo(0x%08x)\n",
+	    __func__, drv_cmd->dev_handle, drv_cmd->ioc_status,
+	    drv_cmd->ioc_loginfo);
+	if (drv_cmd->ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		if (drv_cmd->retry_count < MPI3MR_DEV_RMHS_RETRY_COUNT) {
+			drv_cmd->retry_count++;
+			ioc_info(mrioc,
+			    "%s :dev_rmhs_iouctrl_complete: handle(0x%04x)retrying handshake retry=%d\n",
+			    __func__, drv_cmd->dev_handle,
+			    drv_cmd->retry_count);
+			mpi3mr_dev_rmhs_send_tm(mrioc, drv_cmd->dev_handle,
+			    drv_cmd, drv_cmd->iou_rc);
+			return;
+		}
+		ioc_err(mrioc,
+		    "%s :dev removal handshake failed after all retries: handle(0x%04x)\n",
+		    __func__, drv_cmd->dev_handle);
+	} else {
+		ioc_info(mrioc,
+		    "%s :dev removal handshake completed successfully: handle(0x%04x)\n",
+		    __func__, drv_cmd->dev_handle);
+		clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
+	}
+
+	if (!list_empty(&mrioc->delayed_rmhs_list)) {
+		delayed_dev_rmhs = list_entry(mrioc->delayed_rmhs_list.next,
+		    struct delayed_dev_rmhs_node, list);
+		drv_cmd->dev_handle = delayed_dev_rmhs->handle;
+		drv_cmd->retry_count = 0;
+		drv_cmd->iou_rc = delayed_dev_rmhs->iou_rc;
+		ioc_info(mrioc,
+		    "%s :dev_rmhs_iouctrl_complete: processing delayed TM: handle(0x%04x)\n",
+		    __func__, drv_cmd->dev_handle);
+		mpi3mr_dev_rmhs_send_tm(mrioc, drv_cmd->dev_handle, drv_cmd,
+		    drv_cmd->iou_rc);
+		list_del(&delayed_dev_rmhs->list);
+		kfree(delayed_dev_rmhs);
+		return;
+	}
+	drv_cmd->state = MPI3MR_CMD_NOTUSED;
+	drv_cmd->callback = NULL;
+	drv_cmd->retry_count = 0;
+	drv_cmd->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+	clear_bit(cmd_idx, mrioc->devrem_bitmap);
+}
+
+/**
+ * mpi3mr_dev_rmhs_complete_tm - Device removal TM completion
+ * @mrioc: Adapter instance reference
+ * @cmdparam: Internal command tracker
+ *
+ * Issues a target reset TM to the firmware from the device
+ * removal TM pend list or issue IO Unit control request as
+ * part of device removal or hidden acknowledgment handshake.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_dev_rmhs_complete_tm(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *drv_cmd)
+{
+	Mpi3IoUnitControlRequest_t iou_ctrl;
+	u16 cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
+	Mpi3SCSITaskMgmtReply_t *tm_reply = NULL;
+	int retval;
+
+	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
+		tm_reply = (Mpi3SCSITaskMgmtReply_t *)drv_cmd->reply;
+
+	if (tm_reply)
+		pr_info(IOCNAME
+		    "dev_rmhs_tr_complete:handle(0x%04x), ioc_status(0x%04x), loginfo(0x%08x), term_count(%d)\n",
+		    mrioc->name, drv_cmd->dev_handle, drv_cmd->ioc_status,
+		    drv_cmd->ioc_loginfo,
+		    le32_to_cpu(tm_reply->TerminationCount));
+
+	pr_info(IOCNAME "Issuing IOU CTL: handle(0x%04x) dev_rmhs idx(%d)\n",
+	    mrioc->name, drv_cmd->dev_handle, cmd_idx);
+
+	memset(&iou_ctrl, 0, sizeof(iou_ctrl));
+
+	drv_cmd->state = MPI3MR_CMD_PENDING;
+	drv_cmd->is_waiting = 0;
+	drv_cmd->callback = mpi3mr_dev_rmhs_complete_iou;
+	iou_ctrl.Operation = drv_cmd->iou_rc;
+	iou_ctrl.Param16[0] = cpu_to_le16(drv_cmd->dev_handle);
+	iou_ctrl.HostTag = cpu_to_le16(drv_cmd->host_tag);
+	iou_ctrl.Function = MPI3_FUNCTION_IO_UNIT_CONTROL;
+
+	retval = mpi3mr_admin_request_post(mrioc, &iou_ctrl, sizeof(iou_ctrl),
+	    1);
+	if (retval) {
+		pr_err(IOCNAME "Issue DevRmHsTMIOUCTL: Admin post failed\n",
+		    mrioc->name);
+		goto out_failed;
+	}
+
+	return;
+out_failed:
+	drv_cmd->state = MPI3MR_CMD_NOTUSED;
+	drv_cmd->callback = NULL;
+	drv_cmd->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+	drv_cmd->retry_count = 0;
+	clear_bit(cmd_idx, mrioc->devrem_bitmap);
+}
+
+/**
+ * mpi3mr_dev_rmhs_send_tm - Issue TM for device removal
+ * @mrioc: Adapter instance reference
+ * @handle: Device handle
+ * @cmdparam: Internal command tracker
+ * @iou_rc: IO Unit reason code
+ *
+ * Issues a target reset TM to the firmware or add it to a pend
+ * list as part of device removal or hidden acknowledgment
+ * handshake.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
+	struct mpi3mr_drv_cmd *cmdparam, u8 iou_rc)
+{
+	Mpi3SCSITaskMgmtRequest_t tm_req;
+	int retval = 0;
+	u16 cmd_idx = MPI3MR_NUM_DEVRMCMD;
+	u8 retrycount = 5;
+	struct mpi3mr_drv_cmd *drv_cmd = cmdparam;
+	struct delayed_dev_rmhs_node *delayed_dev_rmhs = NULL;
+
+	if (drv_cmd)
+		goto issue_cmd;
+	do {
+		cmd_idx = find_first_zero_bit(mrioc->devrem_bitmap,
+		    MPI3MR_NUM_DEVRMCMD);
+		if (cmd_idx < MPI3MR_NUM_DEVRMCMD) {
+			if (!test_and_set_bit(cmd_idx, mrioc->devrem_bitmap))
+				break;
+			cmd_idx = MPI3MR_NUM_DEVRMCMD;
+		}
+	} while (retrycount--);
+
+	if (cmd_idx >= MPI3MR_NUM_DEVRMCMD) {
+		delayed_dev_rmhs = kzalloc(sizeof(*delayed_dev_rmhs),
+		    GFP_ATOMIC);
+		if (!delayed_dev_rmhs)
+			return;
+		INIT_LIST_HEAD(&delayed_dev_rmhs->list);
+		delayed_dev_rmhs->handle = handle;
+		delayed_dev_rmhs->iou_rc = iou_rc;
+		list_add_tail(&delayed_dev_rmhs->list,
+		    &mrioc->delayed_rmhs_list);
+		ioc_info(mrioc, "%s :DevRmHs: tr:handle(0x%04x) is postponed\n",
+		    __func__, handle);
+		return;
+	}
+	drv_cmd = &mrioc->dev_rmhs_cmds[cmd_idx];
+
+issue_cmd:
+	cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
+	ioc_info(mrioc,
+	    "%s :Issuing TR TM: for devhandle 0x%04x with dev_rmhs %d\n",
+	    __func__, handle, cmd_idx);
+
+	memset(&tm_req, 0, sizeof(tm_req));
+	if (drv_cmd->state & MPI3MR_CMD_PENDING) {
+		ioc_err(mrioc, "%s :Issue TM: Command is in use\n", __func__);
+		goto out;
+	}
+	drv_cmd->state = MPI3MR_CMD_PENDING;
+	drv_cmd->is_waiting = 0;
+	drv_cmd->callback = mpi3mr_dev_rmhs_complete_tm;
+	drv_cmd->dev_handle = handle;
+	drv_cmd->iou_rc = iou_rc;
+	tm_req.DevHandle = cpu_to_le16(handle);
+	tm_req.TaskType = MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
+	tm_req.HostTag = cpu_to_le16(drv_cmd->host_tag);
+	tm_req.TaskHostTag = cpu_to_le16(MPI3MR_HOSTTAG_INVALID);
+	tm_req.Function = MPI3_FUNCTION_SCSI_TASK_MGMT;
+
+	set_bit(handle, mrioc->removepend_bitmap);
+	retval = mpi3mr_admin_request_post(mrioc, &tm_req, sizeof(tm_req), 1);
+	if (retval) {
+		ioc_err(mrioc, "%s :Issue DevRmHsTM: Admin Post failed\n",
+		    __func__);
+		goto out_failed;
+	}
+out:
+	return;
+out_failed:
+	drv_cmd->state = MPI3MR_CMD_NOTUSED;
+	drv_cmd->callback = NULL;
+	drv_cmd->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+	drv_cmd->retry_count = 0;
+	clear_bit(cmd_idx, mrioc->devrem_bitmap);
+}
+
+/**
+ * mpi3mr_sastopochg_evt_th - SASTopologyChange evt tophalf
+ * @mrioc: Adapter instance reference
+ * @event_reply: Event data
+ *
+ * Checks for the reason code and based on that either block I/O
+ * to device, or unblock I/O to the device, or start the device
+ * removal handshake with reason as remove with the firmware for
+ * SAS/SATA devices.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_sastopochg_evt_th(struct mpi3mr_ioc *mrioc,
+	Mpi3EventNotificationReply_t *event_reply)
+{
+	Mpi3EventDataSasTopologyChangeList_t *topo_evt =
+	    (Mpi3EventDataSasTopologyChangeList_t *)event_reply->EventData;
+	int i;
+	u16 handle;
+	u8 reason_code;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
+
+	for (i = 0; i < topo_evt->NumEntries; i++) {
+		handle = le16_to_cpu(topo_evt->PhyEntry[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		reason_code = topo_evt->PhyEntry[i].Status &
+		    MPI3_EVENT_SAS_TOPO_PHY_RC_MASK;
+		scsi_tgt_priv_data =  NULL;
+		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
+		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata)
+			scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
+			    tgtdev->starget->hostdata;
+		switch (reason_code) {
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING:
+			if (scsi_tgt_priv_data) {
+				scsi_tgt_priv_data->dev_removed = 1;
+				scsi_tgt_priv_data->dev_removedelay = 0;
+				atomic_set(&scsi_tgt_priv_data->block_io, 0);
+			}
+			mpi3mr_dev_rmhs_send_tm(mrioc, handle, NULL,
+			    MPI3_CTRL_OP_REMOVE_DEVICE);
+			break;
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_DELAY_NOT_RESPONDING:
+			if (scsi_tgt_priv_data) {
+				scsi_tgt_priv_data->dev_removedelay = 1;
+				atomic_inc(&scsi_tgt_priv_data->block_io);
+			}
+			break;
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_RESPONDING:
+			if (scsi_tgt_priv_data &&
+			    scsi_tgt_priv_data->dev_removedelay) {
+				scsi_tgt_priv_data->dev_removedelay = 0;
+				atomic_dec_if_positive
+				    (&scsi_tgt_priv_data->block_io);
+			}
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_PHY_CHANGED:
+		default:
+			break;
+		}
+		if (tgtdev)
+			mpi3mr_tgtdev_put(tgtdev);
+	}
+
+}
+
+/**
+ * mpi3mr_devstatuschg_evt_th - DeviceStatusChange evt tophalf
+ * @mrioc: Adapter instance reference
+ * @event_reply: Event data
+ *
+ * Checks for the reason code and based on that either block I/O
+ * to device, or unblock I/O to the device, or start the device
+ * removal handshake with reason as remove/hide acknowledgment
+ * with the firmware.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_devstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
+	Mpi3EventNotificationReply_t *event_reply)
+{
+	u16 dev_handle = 0;
+	u8 ublock = 0, block = 0, hide = 0, delete = 0, remove = 0;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
+	Mpi3EventDataDeviceStatusChange_t *evtdata =
+	    (Mpi3EventDataDeviceStatusChange_t *) event_reply->EventData;
+
+	if (mrioc->stop_drv_processing)
+		goto out;
+
+	dev_handle = le16_to_cpu(evtdata->DevHandle);
+
+	switch (evtdata->ReasonCode) {
+	case MPI3_EVENT_DEV_STAT_RC_INT_DEVICE_RESET_STRT:
+	case MPI3_EVENT_DEV_STAT_RC_INT_IT_NEXUS_RESET_STRT:
+		block = 1;
+		break;
+	case MPI3_EVENT_DEV_STAT_RC_HIDDEN:
+		delete = 1;
+		hide = 1;
+		break;
+	case MPI3_EVENT_DEV_STAT_RC_VD_NOT_RESPONDING:
+		delete = 1;
+		remove = 1;
+		break;
+	case MPI3_EVENT_DEV_STAT_RC_INT_DEVICE_RESET_CMP:
+	case MPI3_EVENT_DEV_STAT_RC_INT_IT_NEXUS_RESET_CMP:
+		ublock = 1;
+		break;
+	default:
+		break;
+	}
+
+	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
+	if (!tgtdev)
+		goto out;
+	if (hide)
+		tgtdev->is_hidden = hide;
+	if (tgtdev->starget && tgtdev->starget->hostdata) {
+		scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
+		    tgtdev->starget->hostdata;
+		if (block)
+			atomic_inc(&scsi_tgt_priv_data->block_io);
+		if (delete)
+			scsi_tgt_priv_data->dev_removed = 1;
+		if (ublock)
+			atomic_dec_if_positive(&scsi_tgt_priv_data->block_io);
+	}
+	if (remove)
+		mpi3mr_dev_rmhs_send_tm(mrioc, dev_handle, NULL,
+		    MPI3_CTRL_OP_REMOVE_DEVICE);
+	if (hide)
+		mpi3mr_dev_rmhs_send_tm(mrioc, dev_handle, NULL,
+		    MPI3_CTRL_OP_HIDDEN_ACK);
+
+out:
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
+}
+
+/**
+ * mpi3mr_os_handle_events - Firmware event handler
+ * @mrioc: Adapter instance reference
+ * @event_reply: Event data
+ *
+ * Identify whteher the event has to handled and acknowledged
+ * and either process the event in the tophalf and/or schedule a
+ * bottom half through mpi3mr_fwevt_worker.
+ *
+ * Return: Nothing
+ */
+void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
+	Mpi3EventNotificationReply_t *event_reply)
+{
+	u16 evt_type, sz;
+	struct mpi3mr_fwevt *fwevt = NULL;
+	bool ack_req = 0, process_evt_bh = 0;
+
+	if (mrioc->stop_drv_processing)
+		return;
+
+	if ((event_reply->MsgFlags & MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_MASK)
+	    == MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_REQUIRED)
+		ack_req = 1;
+
+	evt_type = event_reply->Event;
+
+	switch (evt_type) {
+	case MPI3_EVENT_DEVICE_ADDED:
+	{
+		Mpi3DevicePage0_t *dev_pg0 =
+		    (Mpi3DevicePage0_t *) event_reply->EventData;
+		if (mpi3mr_create_tgtdev(mrioc, dev_pg0))
+			ioc_err(mrioc,
+			    "%s :Failed to add device in the device add event\n",
+			    __func__);
+		else
+			process_evt_bh = 1;
+		break;
+	}
+	case MPI3_EVENT_DEVICE_STATUS_CHANGE:
+	{
+		process_evt_bh = 1;
+		mpi3mr_devstatuschg_evt_th(mrioc, event_reply);
+		break;
+	}
+	case MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
+	{
+		process_evt_bh = 1;
+		mpi3mr_sastopochg_evt_th(mrioc, event_reply);
+		break;
+	}
+	case MPI3_EVENT_DEVICE_INFO_CHANGED:
+	{
+		process_evt_bh = 1;
+		break;
+	}
+	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
+	case MPI3_EVENT_SAS_DISCOVERY:
+	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
+		break;
+	default:
+		ioc_info(mrioc, "%s :Event 0x%02x is not handled\n",
+		    __func__, evt_type);
+		break;
+	}
+	if (process_evt_bh || ack_req) {
+		sz = event_reply->EventDataLength * 4;
+		fwevt = mpi3mr_alloc_fwevt(sz);
+		if (!fwevt) {
+			ioc_info(mrioc, "%s :failure at %s:%d/%s()!\n",
+			    __func__, __FILE__, __LINE__, __func__);
+			return;
+		}
+
+		memcpy(fwevt->event_data, event_reply->EventData, sz);
+		fwevt->mrioc = mrioc;
+		fwevt->event_id = evt_type;
+		fwevt->send_ack = ack_req;
+		fwevt->process_evt = process_evt_bh;
+		fwevt->evt_ctx = le32_to_cpu(event_reply->EventContext);
+		mpi3mr_fwevt_add_to_list(mrioc, fwevt);
+	}
+
+}
+
 /**
  * mpi3mr_process_op_reply_desc - reply descriptor handler
  * @mrioc: Adapter instance reference
@@ -587,6 +1865,33 @@ static int mpi3mr_scan_finished(struct Scsi_Host *shost,
  */
 static void mpi3mr_slave_destroy(struct scsi_device *sdev)
 {
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
+	struct mpi3mr_tgt_dev *tgt_dev;
+	unsigned long flags;
+	struct scsi_target *starget;
+
+	if (!sdev->hostdata)
+		return;
+
+	starget = scsi_target(sdev);
+	shost = dev_to_shost(&starget->dev);
+	mrioc = shost_priv(shost);
+	scsi_tgt_priv_data = starget->hostdata;
+
+	scsi_tgt_priv_data->num_luns--;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+	if (tgt_dev && (!scsi_tgt_priv_data->num_luns))
+		tgt_dev->starget = NULL;
+	if (tgt_dev)
+		mpi3mr_tgtdev_put(tgt_dev);
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+
+	kfree(sdev->hostdata);
+	sdev->hostdata = NULL;
 }
 
 /**
@@ -599,6 +1904,35 @@ static void mpi3mr_slave_destroy(struct scsi_device *sdev)
  */
 static void mpi3mr_target_destroy(struct scsi_target *starget)
 {
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
+	struct mpi3mr_tgt_dev *tgt_dev;
+	unsigned long flags;
+
+	if (!starget->hostdata)
+		return;
+
+	shost = dev_to_shost(&starget->dev);
+	mrioc = shost_priv(shost);
+	scsi_tgt_priv_data = starget->hostdata;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgt_dev = __mpi3mr_get_tgtdev_from_tgtpriv(mrioc, scsi_tgt_priv_data);
+	if (tgt_dev && (tgt_dev->starget == starget) &&
+	    (tgt_dev->perst_id == starget->id))
+		tgt_dev->starget = NULL;
+	if (tgt_dev) {
+		scsi_tgt_priv_data->tgt_dev = NULL;
+		scsi_tgt_priv_data->perst_id = 0;
+		mpi3mr_tgtdev_put(tgt_dev);
+		mpi3mr_tgtdev_put(tgt_dev);
+	}
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+
+	kfree(starget->hostdata);
+	starget->hostdata = NULL;
+
 }
 
 /**
@@ -612,7 +1946,25 @@ static void mpi3mr_target_destroy(struct scsi_target *starget)
  */
 static int mpi3mr_slave_configure(struct scsi_device *sdev)
 {
+	struct scsi_target *starget;
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+	struct mpi3mr_tgt_dev *tgt_dev;
+	unsigned long flags;
 	int retval = 0;
+
+	starget = scsi_target(sdev);
+	shost = dev_to_shost(&starget->dev);
+	mrioc = shost_priv(shost);
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+	if (!tgt_dev)
+		return retval;
+
+	mpi3mr_tgtdev_put(tgt_dev);
+
 	return retval;
 }
 
@@ -626,7 +1978,37 @@ static int mpi3mr_slave_configure(struct scsi_device *sdev)
  */
 static int mpi3mr_slave_alloc(struct scsi_device *sdev)
 {
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
+	struct mpi3mr_tgt_dev *tgt_dev;
+	struct mpi3mr_sdev_priv_data *scsi_dev_priv_data;
+	unsigned long flags;
+	struct scsi_target *starget;
 	int retval = 0;
+
+	starget = scsi_target(sdev);
+	shost = dev_to_shost(&starget->dev);
+	mrioc = shost_priv(shost);
+	scsi_tgt_priv_data = starget->hostdata;
+
+	scsi_dev_priv_data = kzalloc(sizeof(*scsi_dev_priv_data), GFP_KERNEL);
+	if (!scsi_dev_priv_data)
+		return -ENOMEM;
+
+	scsi_dev_priv_data->lun_id = sdev->lun;
+	scsi_dev_priv_data->tgt_priv_data = scsi_tgt_priv_data;
+	sdev->hostdata = scsi_dev_priv_data;
+
+	scsi_tgt_priv_data->num_luns++;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+	if (tgt_dev && (tgt_dev->starget == NULL))
+		tgt_dev->starget = starget;
+	if (tgt_dev)
+		mpi3mr_tgtdev_put(tgt_dev);
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 	return retval;
 }
 
@@ -640,7 +2022,33 @@ static int mpi3mr_slave_alloc(struct scsi_device *sdev)
  */
 static int mpi3mr_target_alloc(struct scsi_target *starget)
 {
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
+	struct mpi3mr_tgt_dev *tgt_dev;
+	unsigned long flags;
 	int retval = -ENODEV;
+
+	scsi_tgt_priv_data = kzalloc(sizeof(*scsi_tgt_priv_data), GFP_KERNEL);
+	if (!scsi_tgt_priv_data)
+		return -ENOMEM;
+
+	starget->hostdata = scsi_tgt_priv_data;
+	scsi_tgt_priv_data->starget = starget;
+	scsi_tgt_priv_data->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+	if (tgt_dev && !tgt_dev->is_hidden) {
+		scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
+		scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
+		scsi_tgt_priv_data->dev_type = tgt_dev->dev_type;
+		scsi_tgt_priv_data->tgt_dev = tgt_dev;
+		tgt_dev->starget = starget;
+		atomic_set(&scsi_tgt_priv_data->block_io, 0);
+		retval = 0;
+	}
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 	return retval;
 }
 
@@ -857,9 +2265,15 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&mrioc->admin_req_lock);
 	spin_lock_init(&mrioc->reply_free_queue_lock);
 	spin_lock_init(&mrioc->sbq_lock);
+	spin_lock_init(&mrioc->fwevt_lock);
+	spin_lock_init(&mrioc->tgtdev_lock);
 	spin_lock_init(&mrioc->watchdog_lock);
 	spin_lock_init(&mrioc->chain_buf_lock);
 
+	INIT_LIST_HEAD(&mrioc->fwevt_list);
+	INIT_LIST_HEAD(&mrioc->tgtdev_list);
+	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
+
 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
 
 	if (pdev->revision)
@@ -877,6 +2291,17 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_channel = 1;
 	shost->max_id = 0xFFFFFFFF;
 
+	snprintf(mrioc->fwevt_worker_name, sizeof(mrioc->fwevt_worker_name),
+	    "%s%d_fwevt_wrkr", mrioc->driver_name, mrioc->id);
+	mrioc->fwevt_worker_thread = alloc_ordered_workqueue(
+	    mrioc->fwevt_worker_name, WQ_MEM_RECLAIM);
+	if (!mrioc->fwevt_worker_thread) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		retval = -ENODEV;
+		goto out_fwevtthread_failed;
+	}
+
 	mrioc->is_driver_loading = 1;
 	if (mpi3mr_init_ioc(mrioc)) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
@@ -903,6 +2328,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 addhost_failed:
 	mpi3mr_cleanup_ioc(mrioc);
 out_iocinit_failed:
+	destroy_workqueue(mrioc->fwevt_worker_thread);
+out_fwevtthread_failed:
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
@@ -924,14 +2351,30 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct mpi3mr_ioc *mrioc;
+	struct workqueue_struct	*wq;
+	unsigned long flags;
+	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
 
 	mrioc = shost_priv(shost);
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
 
 	mrioc->stop_drv_processing = 1;
+	mpi3mr_cleanup_fwevt_list(mrioc);
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	wq = mrioc->fwevt_worker_thread;
+	mrioc->fwevt_worker_thread = NULL;
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+	if (wq)
+		destroy_workqueue(wq);
 
 	scsi_remove_host(shost);
+	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
+	    list) {
+		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+		mpi3mr_tgtdev_put(tgtdev);
+	}
 
 	mpi3mr_cleanup_ioc(mrioc);
 
@@ -955,6 +2398,8 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct mpi3mr_ioc *mrioc;
+	struct workqueue_struct	*wq;
+	unsigned long flags;
 
 	if (!shost)
 		return;
@@ -963,6 +2408,13 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
 	mrioc->stop_drv_processing = 1;
+	mpi3mr_cleanup_fwevt_list(mrioc);
+	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	wq = mrioc->fwevt_worker_thread;
+	mrioc->fwevt_worker_thread = NULL;
+	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+	if (wq)
+		destroy_workqueue(wq);
 
 	mpi3mr_cleanup_ioc(mrioc);
 
-- 
2.18.1


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000732d0805b70ad0ea
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQRQYJKoZIhvcNAQcCoIIQNjCCEDICAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2aMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFRzCCBC+gAwIBAgIMNJ2hfsaqieGgTtOzMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTE0MTE0
NTE2WhcNMjIwOTE1MTE0NTE2WjCBkDELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRYwFAYDVQQDEw1LYXNo
eWFwIERlc2FpMSkwJwYJKoZIhvcNAQkBFhprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALcJrXmVmbWEd4eX2uEKGBI6v43LPHKbbncKqMGH
Dez52MTfr4QkOZYWM4Rqv8j6vb8LPlUc9k0CEnC9Yaj9ZzDOcR+gHfoZ3F1JXSVRWdguz25MiB6a
bU8odXAymhaig9sNJLxiWid3RORmG/w1Nceflo/72Cwttt0ytDTKdF987/aVGqMIxg3NnXM/cn+T
0wUiccp8WINUie4nuR9pzv5RKGqAzNYyo8krQ2URk+3fGm1cPRoFEVAkwrCs/FOs6LfggC2CC4LB
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg4fJstwuM
Ld+BmadiCSLGvUe9fl1MN2ewfPBN+gq+79EwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMjM4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBALa0OmQuybfulhqT1Iupx8Btoqv2
hzCB+BuLYFNbx8WwLSBa0I67lM9/LkKtQV7/3MBGMKsWShi3ks8SbtaNthsshR3MADEIjD2w5stW
1SsstS2e/5i0/vn+tUxQEmFBp4BYkQg7Gmr4jcSzo+tBtPIhgkkshvzo+FOYNBHfouOSfxMKKhy0
Bf+r69Pt/fGWk06z9lDKqc9EPvNrZ2JTbtYqc1LZOBaiVt9slFTWH8x7c6+tvYTnrLVKtpWPFmyx
Ez9sPLYlMbmQBnD8UZ05WbManq9UqeQ8HhhAW0XlvYvpHD2eu1O2zN9G+ezgl/XqGBy4NumG8VZB
vZkF+ZAG1zc=
--000000000000732d0805b70ad0ea--
