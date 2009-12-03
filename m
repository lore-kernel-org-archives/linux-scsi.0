From: Pravin Bathija <pbathija@amcc.com>
Subject: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit resources.
Date: Wed,  2 Dec 2009 17:51:46 -0800
Message-ID: <1259805106-23636-1-git-send-email-pbathija@amcc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sdcmail01.amcc.com ([198.137.200.72]:2490 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZLCBvk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2009 20:51:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org, Eric.Moore@lsi.com, Pravin Bathija <pbathija@amcc.com>

    Powerpc 44x uses 36 bit real address while the real address defined
    in MPT Fusion driver is of type 32 bit. This causes ioremap to fail and driver
    fails to initialize. This fix changes the data types representing the real
    address from unsigned long 32-bit types to resource_size_t which is 64-bit. The
    driver has been tested, the disks get discovered correctly and can do IO.

Signed-off-by: Pravin Bathija <pbathija@amcc.com>
Acked-by: Feng Kan <fkan@amcc.com>
Acked-by: Fushen Chen <fchen@amcc.com>
Acked-by: Loc Ho <lho@amcc.com>
Acked-by: Tirumala Reddy Marri <tmarri@amcc.com>
Acked-by: Victor Gallardo <vgallardo@amcc.com>
---
 drivers/message/fusion/mptbase.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5d496a9..9f14a60 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1511,7 +1511,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 {
 	u8		__iomem *mem;
 	int		 ii;
-	unsigned long	 mem_phys;
+	resource_size_t	 mem_phys;
 	unsigned long	 port;
 	u32		 msize;
 	u32		 psize;
-- 
1.5.5

