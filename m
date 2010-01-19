From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] PVSCSI: fix signedness warning with newer compilers
Date: Tue, 19 Jan 2010 10:24:40 -0800
Message-ID: <20100119182439.GB21866@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53016 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab0ASSY4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2010 13:24:56 -0500
Received: by pwj9 with SMTP id 9so2570832pwj.21
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2010 10:24:56 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org

From: Dmitry Torokhov <dtor@vmware.com>

pvscsi_setup_msix() expects 'irq' argument to be an int but is being
passed unsigned int. Unsigned int is more proper type for IRQ number
so let's use it. This shuts off a compile warning with recent
compilers.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Acked-by: Alok Kataria <akataria@vmware.com>
---
 drivers/scsi/vmw_pvscsi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index d2604c8..e4ac582 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1069,7 +1069,8 @@ static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
 		free_pages((unsigned long)ctx->sgl, get_order(SGL_SIZE));
 }
 
-static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter, int *irq)
+static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter,
+			     unsigned int *irq)
 {
 	struct msix_entry entry = { 0, PVSCSI_VECTOR_COMPLETION };
 	int ret;
