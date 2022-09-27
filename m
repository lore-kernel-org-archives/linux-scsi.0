Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B55C54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 15:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiI0Ph5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 11:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiI0Pha (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 11:37:30 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB66481C3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 08:36:25 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 3so9763947pga.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 08:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=ENsxjBVLvcS9Sl/erSmzP+QvgvvXtgtHf/5YnhDAvHI=;
        b=VMxLQw+YzPOn2ZG207xNCd7dLUdSahvAo2cuZvccakSqdgflshCiO1x7gfYWchdJ7V
         MCbKf+oPmAXIPER4u7KiJyyz7pAcid/j6/AlL50WeYv/o2l8dj+CX7bohhgd6tHED0Ww
         VMT71agF2P2Am58mJrlx0azMo4TcSPcfRKByBmJl//FaKLgerEtYxKuFwTXtZHb5FLfl
         yhyajQl/AQ+9ykGvVPVSv+D+3GIKNbUm2Mit6c6d1/fe2Er8ssiIFJRXmnJf2LTqc1jU
         5qdhgsGc7x4OP7dpnBunyb2WPnVW5doGUv3OcRPtdGreBu3hN1KBDzTdqoETRdQhu9/b
         G5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ENsxjBVLvcS9Sl/erSmzP+QvgvvXtgtHf/5YnhDAvHI=;
        b=ra3n7BvsdFTMIsII9IuqU9zoKAoGVu8DkdFUEVvIANE0SJnZWyL1dvEFXfafP/fL6H
         aCWSMpsFVNtCglmDaoS4YkiwPIrNOEg0LIpQd8OBeqztyuEohNsezbTL/EWDyrjtCd2n
         PPY7Cm5sJwlNw44kLM1cEuMt4PJzeCnM6spI5TPR1b5EhARpDYZaMJ7pMSGn4ETAZLtL
         amPk2HCyEs9XJqPom44b1o+I+/H5/DIbMwIzNh3hAhM2Twc3T3oZpHnzqGGTp8tWLv0t
         x+CBeEuJoVW+GVDBiv4i2az//cgMxwJsGGpfYvLHW0nGqHs+tj4fidPPPejBjrWlzVYH
         ao7Q==
X-Gm-Message-State: ACrzQf2jlHbQAPdiEqX7nU7eJXNMpnLpcbB9m4YHpbPdp2J2+gjV3yKT
        kwvrEov8wKVqybGDIIJwaLfpRQ==
X-Google-Smtp-Source: AMsMyM4AesfztARYj7VKlI8kwy86tANKtLJm/3jYH/7q0idxBuYkgELKcxtj7x5R4ivUtTFXDoPKoA==
X-Received: by 2002:a05:6a02:205:b0:41b:96dc:bb2a with SMTP id bh5-20020a056a02020500b0041b96dcbb2amr25106581pgb.116.1664292971298;
        Tue, 27 Sep 2022 08:36:11 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id w16-20020aa79a10000000b0053639773ad8sm1933087pfj.119.2022.09.27.08.36.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Sep 2022 08:36:10 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     bhelgaas@google.com, ruscur@russell.cc, oohall@gmail.com,
        fancer.lancer@gmail.com, jdmason@kudzu.us, dave.jiang@intel.com,
        allenbh@gmail.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     chenzhuo.1@bytedance.com, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ntb@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/9] PCI/AER: Fix and optimize usage of status clearing api
Date:   Tue, 27 Sep 2022 23:35:15 +0800
Message-Id: <20220927153524.49172-1-chenzhuo.1@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello.

Here comes patch v2, which contains some fixes and optimizations of
aer api usage. The original version can be found on the mailing list.

Changes since v1:
- Modifications to comments proposed by Bjorn. Split patch into more
  obvious parts.

Zhuo Chen (9):
  PCI/AER: Add pci_aer_clear_uncorrect_error_status() to PCI core
  PCI/DPC: Use pci_aer_clear_uncorrect_error_status() to clear
    uncorrectable error status
  NTB: Change to use pci_aer_clear_uncorrect_error_status()
  scsi: lpfc: Change to use pci_aer_clear_uncorrect_error_status()
  PCI/AER: Unexport pci_aer_clear_nonfatal_status()
  PCI/AER: Move check inside pcie_clear_device_status().
  PCI/AER: Use pcie_aer_is_native() to judge whether OS owns AER
  PCI/ERR: Clear fatal status when pci_channel_io_frozen
  PCI/AER: Refine status clearing process with api

 drivers/ntb/hw/idt/ntb_hw_idt.c |  4 +--
 drivers/pci/pci.c               |  7 +++--
 drivers/pci/pci.h               |  2 ++
 drivers/pci/pcie/aer.c          | 45 +++++++++++++++++++--------------
 drivers/pci/pcie/dpc.c          |  3 +--
 drivers/pci/pcie/err.c          | 15 ++++-------
 drivers/pci/pcie/portdrv_core.c |  3 +--
 drivers/scsi/lpfc/lpfc_attr.c   |  4 +--
 include/linux/aer.h             |  4 +--
 9 files changed, 46 insertions(+), 41 deletions(-)

-- 
2.30.1 (Apple Git-130)

