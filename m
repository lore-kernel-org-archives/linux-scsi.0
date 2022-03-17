Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCB8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 03:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiCQD3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 23:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbiCQD3Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 23:29:25 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAF511A32
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 20:28:02 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g19so5737360pfc.9
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 20:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VUOcnGCmkI9MgS52qXIb3FlhfMOUv2lQTH15zVr9Ia8=;
        b=PwJ4qSum2YwEz5mm0VtPaQBrwVeKB7O/bU3EDytHiRRP18QZNFHHy6a14b5xpQcFn3
         cW6BEVXYkmPGdjdjFlNdlDEdnGa6oJr87wo/ETSmUcw5n0CO8QmrasJ0ppStgbPm5er4
         Mcu1LoX1/I3/tS/aXKsf0DJNseK+AYDhUA848ykbL1UwDQcuEGRRU48m4Sqfv+5Y6S26
         xlD+k2By/widTEo2vUDWY43b1phT6YxyJIYt7H3nqMkoHS13yvGI7QTZjOaZdoNpqTtf
         ZngVl/UgDXaZl1m/saVsP/DIaoZXfh0W4urXG3uerb0t4n54LE16St2XfdVvQTi/yUZw
         dhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VUOcnGCmkI9MgS52qXIb3FlhfMOUv2lQTH15zVr9Ia8=;
        b=UkKDpjYVgsX94txYwR0UR2RSLu9xuX4VGZNWO3cWIpksWSuUwHjjZQECqs7mfT0laT
         5KABFBpWylm99FfToJOL6EsQ+y2UxlfumuL2XYkVSppV7EtapAFsutzhG9R+fFUhOYRV
         J1WLfpeWFRov4l8cMDmyqLpkAUnjjvE9PJzMc0CyTQQ2ZWCLFbU4YkkOSbEgZYLBaWBL
         rOlljsWtmgWaDFVQCc8obXKQv2lIz13F+Qt7LpU0y9x+3f8uoeGWNKaIDpG3vjLSu/xF
         LHF2A1nZ+TzX7DtSF/BV8lLAm/qzBYano1FjLcGln4LEx1XfwDVpGuDHfo9CwjzsDrQZ
         wr5A==
X-Gm-Message-State: AOAM5336YHQ7abc8OXPCuU9P97eQQK/COek+g4nxmEzIzL2y2lUOqlox
        cyuEqEJQwYohw4g/84j3Sy/C8oBANLw=
X-Google-Smtp-Source: ABdhPJwiJNpfNtviOGsFca7VCD3mD0fW0xWv8Bh3J6z6Fi+Gi8/TMi2RqCgoa5f/U8xuS9gFcCQZ8g==
X-Received: by 2002:aa7:82d9:0:b0:4fa:2c7f:41e with SMTP id f25-20020aa782d9000000b004fa2c7f041emr2406010pfn.1.1647487667949;
        Wed, 16 Mar 2022 20:27:47 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm5017511pfc.190.2022.03.16.20.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 20:27:47 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/4] lpfc: Update lpfc to revision 14.2.0.1
Date:   Wed, 16 Mar 2022 20:27:33 -0700
Message-Id: <20220317032737.45308-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.1

This patch set contains 3 fixes for errors detected during eeh error
injection.

The patches were cut against Martin's 5.18/scsi-staging tree

James Smart (4):
  lpfc: Improve PCI EEH Error and Recovery Handling
  lpfc: Fix unload hang after back to back PCI EEH faults
  lpfc: Fix queue failures when recovering from PCI parity error
  lpfc: Update lpfc version to 14.2.0.1

 drivers/scsi/lpfc/lpfc.h         |   7 +-
 drivers/scsi/lpfc/lpfc_crtn.h    |   3 +
 drivers/scsi/lpfc/lpfc_hbadisc.c | 120 +++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_init.c    |  88 ++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_nvme.c    |  27 ++++---
 drivers/scsi/lpfc/lpfc_sli.c     |  65 +++++++++++------
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 7 files changed, 232 insertions(+), 80 deletions(-)

-- 
2.26.2

