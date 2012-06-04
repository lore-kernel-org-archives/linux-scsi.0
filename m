From: Girish K S <girish.shivananjappa@linaro.org>
Subject: [PATCH V4 0/2] Add support for pci/non-pci probing for UFS
Date: Mon,  4 Jun 2012 17:13:06 +0530
Message-ID: <1338810188-30248-1-git-send-email-girish.shivananjappa@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33423 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2FDLnY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jun 2012 07:43:24 -0400
Received: by pbbrp8 with SMTP id rp8so5878465pbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jun 2012 04:43:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org, svenkatr@ti.com, Girish K S <girish.shivananjappa@linaro.org>

The existing UFS driver is tightly bound to only pci specific devices.
It cannot work for non-pci devices.

"SCSI: UFS: Create separate UFS core and pci modules" patch splits the
ufs driver into core driver and pci probe driver.

"SCSI: UFS: Add platform support for ufs host controller" patch adds
support for the platform probing for non-pci devices

changes in v4:
	-Rebased to the latest linux-next/master branch.
	-Removed the Copyright string from the module probe function and
deleted redundant code from ufshcd-pltfm.c suspend/resume functions.

changes in v3:
	-Modified the ufshcd.c ufshcd-pci.c ufshcd0pltfm.c to follow the
driver module initialization standard. suggested by venkatraman.

changes in v2:
	-Reduced the number of patches from 4 to 2. merged the core and
pci probing modules as single patch. suggested by Christoph Hellwig.

changes in v1:
	-Changes suggested by Namjae to split the driver as 3 independent
modules and retain the author's name in the files created by me.

Girish K S (2):
  SCSI: UFS: Create separate UFS core and pci modules
  SCSI: UFS: Add platform support for ufs host controller

 drivers/scsi/ufs/Kconfig        |   32 +++-
 drivers/scsi/ufs/Makefile       |    2 +
 drivers/scsi/ufs/ufs.h          |  103 +++++++++++
 drivers/scsi/ufs/ufshcd-pci.c   |  206 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfm.c |  176 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c       |  370 ++++++++++-----------------------------
 6 files changed, 609 insertions(+), 280 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c

-- 
1.7.4.1

