From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v3 0/2] mpt2sas/mpt3sas resource cleanup fixes
Date: Thu,  8 Aug 2013 16:45:37 -0400
Message-ID: <1375994739-11146-1-git-send-email-joe.lawrence@stratus.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.17]:52420 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966438Ab3HHUpu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 16:45:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sreekanth.Reddy@lsi.com, Joe Lawrence <joe.lawrence@stratus.com>

Hi Sreekanth,

Here are the patches that address your offlist feedback and testing of
earlier patchset versions.

I tested with as many early exits as I could think of inside of
mpt2sas_base_map_resources to verify, so I believe all error paths
should be safe and message-log-friendly.

Regards,

Joe

---

Changes from v2 (offlist):
  - Clear ioc->bars if pci_enable_device_mem fails.
  - pci_release_selected_regions verifies non-zero bar pointer, so as
    long as it's cleared when not actually enabled, we don't need to
    check it first.

Changes from v1:
  - Verify that the PCI device is enabled before disabling it.
  - Verify that the PCI BARs have been enabled before releasing them. 

Joe Lawrence (2):
  mpt2sas: fix cleanup on controller resource mapping failure
  mpt3sas: fix cleanup on controller resource mapping failure

 drivers/scsi/mpt2sas/mpt2sas_base.c  | 27 +++++++++++++++++----------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 27 +++++++++++++++++----------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  1 +
 4 files changed, 36 insertions(+), 20 deletions(-)

-- 
1.8.3.1

