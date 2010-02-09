From: scameron@beardog.cce.hp.com
Subject: [PATCH] hpsa: fix hpsa_pci_init section mismatch
Date: Tue, 9 Feb 2010 08:46:13 -0600
Message-ID: <20100209144613.GI14493@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:36582 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab0BIOnq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2010 09:43:46 -0500
Received: from g5t0029.atlanta.hp.com (g5t0029.atlanta.hp.com [16.228.8.141])
	by g5t0006.atlanta.hp.com (Postfix) with ESMTP id 5F049C31C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Feb 2010 14:43:45 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g5t0029.atlanta.hp.com (Postfix) with ESMTP id 39E1B200C4
	for <linux-scsi@vger.kernel.org>; Tue,  9 Feb 2010 14:43:30 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [127.0.0.1])
	by beardog.cce.hp.com (8.13.8/8.13.8) with ESMTP id o19EkDcm019393
	for <linux-scsi@vger.kernel.org>; Tue, 9 Feb 2010 08:46:13 -0600
Received: (from scameron@localhost)
	by beardog.cce.hp.com (8.13.8/8.13.8/Submit) id o19EkDH5019392
	for linux-scsi@vger.kernel.org; Tue, 9 Feb 2010 08:46:13 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

hpsa_pci_init() calls hpsa_interrupt_mode() which is a __devinit function.
 hpsa_pci_init() is only called by hpsa_init_one() which is also
__devinit, so mark it __devinit as well.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: "Stephen M.Cameron" <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~drivers-scsi-hpsac-fix-section-mismatch drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~drivers-scsi-hpsac-fix-section-mismatch
+++ a/drivers/scsi/hpsa.c
@@ -3111,7 +3111,7 @@ default_int_mode:
 	return;
 }
 
-static int hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
+static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 {
 	ushort subsystem_vendor_id, subsystem_device_id, command;
 	__u32 board_id, scratchpad = 0;
_
