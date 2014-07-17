From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] tgt: remove SCSI_TGT and SCSI_FC_TGT_ATTRS
Date: Thu, 17 Jul 2014 12:42:39 +0200
Message-ID: <1405593759.4808.43.camel@x220>
References: <1405326544.8281.17.camel@x220> <20140714083154.GA21756@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:49308 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755488AbaGQKmm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2014 06:42:42 -0400
In-Reply-To: <20140714083154.GA21756@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The Kconfig symbols SCSI_TGT and SCSI_FC_TGT_ATTRS are unused since
commit 73685a458f2e ("tgt: removal"). Setting them has no effect. Remove
these symbols.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by running "make oldconfig" on a Fedora 20 based .config.
That .config has CONFIG_SCSI_TGT set to 'm' and CONFIG_SCSI_FC_TGT_ATTRS
set to 'y'. This patch only makes both symbols disappear from
the .config, which is what we want. Please shout if that's not enough
testing in your opinion.

Note that the commit explanation references a linux-next commit ID. If
that patch gets rebased before entering mainline that won't be a ID
found in the mainline repository anymore!

 drivers/scsi/Kconfig | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 1fa07e4221f7..18a3358eb1d4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -40,13 +40,6 @@ config SCSI_DMA
 	bool
 	default n
 
-config SCSI_TGT
-	tristate "SCSI target support"
-	depends on SCSI
-	---help---
-	  If you want to use SCSI target mode drivers enable this option.
-	  If you choose M, the module will be called scsi_tgt.
-
 config SCSI_NETLINK
 	bool
 	default	n
@@ -271,13 +264,6 @@ config SCSI_FC_ATTRS
 	  each attached FiberChannel device to sysfs, say Y.
 	  Otherwise, say N.
 
-config SCSI_FC_TGT_ATTRS
-	bool "SCSI target support for FiberChannel Transport Attributes"
-	depends on SCSI_FC_ATTRS
-	depends on SCSI_TGT = y || SCSI_TGT = SCSI_FC_ATTRS
-	help
-		If you want to use SCSI target mode drivers enable this option.
-
 config SCSI_ISCSI_ATTRS
 	tristate "iSCSI Transport Attributes"
 	depends on SCSI && NET
-- 
1.9.3

