From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH] scsi: qla4xxx driver depends on NET
Date: Mon, 12 Sep 2011 15:31:34 -0700
Message-ID: <CA93D5F9.8FBF%vikas.chaudhary@qlogic.com>
References: <4E6BFD2E.4020908@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:30689
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755334Ab1ILWde convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2011 18:33:34 -0400
In-Reply-To: <4E6BFD2E.4020908@xenotime.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>, scsi <linux-scsi@vger.kernel.org>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ravi Anand <ravi.anand@qlogic.com>, Dept_iscsi_driver <iscsi-driver@qlogic.com>



On 10/09/11 5:13 PM, "Randy Dunlap" <rdunlap@xenotime.net> wrote:

>From: Randy Dunlap <rdunlap@xenotime.net>
>
>When CONFIG_NET is disabled, SCSI_QLA_ISCSI selects SCSI_ISCSI_ATTRS,
>which uses network interfaces, so the build fails with multiple errors:
>
>warning: (ISCSI_TCP && SCSI_CXGB3_ISCSI && SCSI_CXGB4_ISCSI &&
>SCSI_QLA_ISCSI && INFINIBAND_ISER) selects SCSI_ISCSI_ATTRS which has
>unmet direct dependencies (SCSI && NET)
>
>ERROR: "skb_trim" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
>ERROR: "netlink_kernel_create" [drivers/scsi/scsi_transport_iscsi.ko]
>undefined!
>ERROR: "netlink_kernel_release" [drivers/scsi/scsi_transport_iscsi.ko]
>undefined!
>ERROR: "skb_pull" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
>ERROR: "init_net" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
>ERROR: "__alloc_skb" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
>ERROR: "netlink_broadcast" [drivers/scsi/scsi_transport_iscsi.ko]
>undefined!
>ERROR: "kfree_skb" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
>ERROR: "skb_put" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
>ERROR: "sysfs_format_mac" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
>
>so make SCSI_QLA_ISCSI also depend on NET to prevent the build errors.
>
>Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>Cc:    Ravi Anand <ravi.anand@qlogic.com>
>Cc:    Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>Cc:    iscsi-driver@qlogic.com
>---
> drivers/scsi/qla4xxx/Kconfig |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>--- lnx-31-rc5.orig/drivers/scsi/qla4xxx/Kconfig
>+++ lnx-31-rc5/drivers/scsi/qla4xxx/Kconfig
>@@ -1,6 +1,6 @@
> config SCSI_QLA_ISCSI
>     tristate "QLogic ISP4XXX and ISP82XX host adapter family support"
>-    depends on PCI && SCSI
>+    depends on PCI && SCSI && NET
>     select SCSI_ISCSI_ATTRS
>     ---help---
>     This driver supports the QLogic 40xx (ISP4XXX) and 8022 (ISP82XX)

Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

