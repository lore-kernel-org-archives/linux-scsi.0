From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] - mptfusion - fix panic loading driver statically
	compile d
Date: Thu, 28 Apr 2005 15:28:04 -0700
Message-ID: <1114727284.5022.25.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C0225D199@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62150 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262304AbVD1W2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 18:28:09 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C0225D199@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Thu, 2005-04-28 at 16:15 -0600, Moore, Eric Dean wrote:
> This patch can also be found at this URL:
> ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.01/
> 
> Changelog:
> (1) For statically linked drivers, fusion_init was not called,
> added call from mpt_register so its called when one of the scsi lld load.
> (2) little endian fix in mpt_put_msg_frame/mpt_get_msg_frame
> (3) Clarify help desc in Kconfig for FUSION_MAX_SGE.

Surely this is just a simple link order problem?  Can't we solve it like
the attached?

James

--- k/drivers/message/fusion/Makefile  (mode:100644)
+++ l/drivers/message/fusion/Makefile  (mode:100644)
@@ -32,7 +32,7 @@
 
 #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-} LSI_LOGIC
 
-obj-$(CONFIG_FUSION_SPI)	+= mptspi.o mptscsih.o mptbase.o
-obj-$(CONFIG_FUSION_FC)		+= mptfc.o mptscsih.o mptbase.o
+obj-$(CONFIG_FUSION_SPI)	+=  mptbase.o mptspi.o mptscsih.o
+obj-$(CONFIG_FUSION_FC)		+=  mptbase.o mptfc.o mptscsih.o
 obj-$(CONFIG_FUSION_CTL)	+= mptctl.o
 obj-$(CONFIG_FUSION_LAN)	+= mptlan.o


