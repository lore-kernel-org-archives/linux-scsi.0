From: akpm@linux-foundation.org
Subject: [patch 21/25] scsi: fix ambiguous gdthtable definition
Date: Wed, 23 May 2007 14:41:52 -0700
Message-ID: <200705232141.l4NLfroP001231@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756577AbXEWWEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 18:04:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com, achim_leubner@adaptec.com

From: David Rientjes <rientjes@google.com>

Labeling a variable as __attribute_used__ is ambiguous: it means
__attribute__((unused)) for gcc <3.4 and __attribute__((used)) for gcc >=3.4. 
There is no such thing as labeling a variable as __attribute__((used)).  We
assume that we're simply suppressing a warning here if gdthtable[] is declared
but unreferenced.

Cc: Achim Leubner <achim_leubner@adaptec.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.c~scsi-fix-ambiguous-gdthtable-definition drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-fix-ambiguous-gdthtable-definition
+++ a/drivers/scsi/gdth.c
@@ -876,7 +876,7 @@ static int __init gdth_search_pci(gdth_p
 /* Vortex only makes RAID controllers.
  * We do not really want to specify all 550 ids here, so wildcard match.
  */
-static struct pci_device_id gdthtable[] __attribute_used__ = {
+static struct pci_device_id gdthtable[] __maybe_unused = {
     {PCI_VENDOR_ID_VORTEX,PCI_ANY_ID,PCI_ANY_ID, PCI_ANY_ID},
     {PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC,PCI_ANY_ID,PCI_ANY_ID}, 
     {PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC_XSCALE,PCI_ANY_ID,PCI_ANY_ID}, 
_
