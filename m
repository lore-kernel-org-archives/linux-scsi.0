From: Anton Blanchard <anton@samba.org>
Subject: [SCSI] lpfc: Don't force CONFIG_GENERIC_CSUM on
Date: Thu, 8 Aug 2013 17:47:34 +1000
Message-ID: <20130808174734.3c4fd0cd@kryten>
References: <20130805202017.651b6cfd@kryten>
	<5202C94F.5070701@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:42357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab3HHHrg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Aug 2013 03:47:36 -0400
In-Reply-To: <5202C94F.5070701@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, JBottomley@parallels.com, sfr@canb.auug.org.au


Hi Randy,

> I reported:
> """
> on i386:
> # CONFIG_CRC_T10DIF is not set
> 
> 
> drivers/built-in.o: In function `lpfc_bg_crc':
> (.text+0x3cb3c9): undefined reference to `crc_t10dif'
> """
> 
> and then James Bottomley provided the patch.
> I don't know why he added GENERIC_CSUM to it.

Thanks for investigating this. How does this patch look?

Anton
--

[SCSI] lpfc: Don't force CONFIG_GENERIC_CSUM on

We want ppc64 to be able to select between optimised assembly
checksum routines in big endian and the generic lib/checksum.c
routines in little endian.

The lpfc driver is forcing CONFIG_GENERIC_CSUM on which means
we are unable to make the decision to enable it in the arch
Kconfig. If the option exists it is always forced on.

This got introduced in 3.10 via commit 6a7252fdb0c3 ([SCSI] lpfc:
fix up Kconfig dependencies). I spoke to Randy about it and
the original issue was with CRC_T10DIF not being defined.

As such, remove the select of CONFIG_GENERIC_CSUM.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@vger.kernel.org> # 3.10
---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 48b2918..92ff027 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1353,7 +1353,6 @@ config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
 	select SCSI_FC_ATTRS
-	select GENERIC_CSUM
 	select CRC_T10DIF
 	help
           This lpfc driver supports the Emulex LightPulse
