Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A77FA3740
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 21:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJVVhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 17:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJVVhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 17:37:08 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A703FA01A;
        Sat, 22 Oct 2022 14:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1666474619;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=pxGRSZ1v1hPpxgBZWeqPDzvMA+Ms7cKLZyQDWCA/9do=;
    b=VTHlOE1KaaOCmxC4S5xMfIBW3vXH2JFDlwbaWCMAt+wvnGcrBYTfoc9NJJh0Oh9Mk8
    HfBRz3Vjz3jg+zj4Mc1rN+xZsdFetY5bDMT0SprC4TWIznkABcpWJngJohADq+vr8FI2
    fZurZlQs8J4IYgHPU07X22C3Q0fx7KGUeitv8ughV4pqEl5iIukB+O8n2QAc229cY4i+
    45CXOKrYAUwftdK/H2scz19x/gjexJr1JZ7TU7JShCbPyBQPXtfKgXwXLuKwh0RT+k7s
    zJx0kiw8yJyNrF6No0GbGOhn2y6R4u+KGAxgKUfzAE2Bf0F9ruGImySo4Lq3MyR6JNeg
    l0SA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD/R51xABQjgP5pGGXp2Dw="
X-RZG-CLASS-ID: mo00
Received: from linux..
    by smtp.strato.de (RZmta 48.2.0 DYNA|AUTH)
    with ESMTPSA id zad98cy9MLawnUS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 22 Oct 2022 23:36:58 +0200 (CEST)
From:   Bean Huo <beanhuo@iokpp.de>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] Changes for ufshcd.c
Date:   Sat, 22 Oct 2022 23:36:47 +0200
Message-Id: <20221022213650.626766-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

v3--v4:
    1. Change patch 1/3 title
    2. Fix one typo in patch 3/3
    3. Fix coding type issue in  patch 2/3 based on Bart's comment

v2--v3:
    1. Add patch 3/3
    2. Add remove unused parameter param_offset in patch 1/3 based on Daejun's comment
    3. Further optimized patch 2/3 based on Bart's comment

v1--v2:
    1. change in ufshcd_lu_init() in  patch 2/2:
        1) Remove duplicate parameter initialization
        2) Move lun parameter initialization before kmalloc()


Bean Huo (3):
  scsi: ufs: core: Revert "WB is only available on LUN #0 to #7"
  scsi: ufs: core: Cleanup ufshcd_slave_alloc()
  scsi: ufs: core: Use is_visible to control UFS unit descriptor sysfs
    nodes

 drivers/ufs/core/ufs-sysfs.c   |  21 ++++-
 drivers/ufs/core/ufshcd-priv.h |   6 +-
 drivers/ufs/core/ufshcd.c      | 152 ++++++++++++---------------------
 3 files changed, 74 insertions(+), 105 deletions(-)

-- 
2.34.1

