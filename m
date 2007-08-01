From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: git-scsi-misc build error
Date: Thu, 2 Aug 2007 07:22:19 +0900
Message-ID: <20070801082602J.tomof@acm.org>
References: <20070731152732.ae8d251d.akpm@linux-foundation.org>
	<1185921052.3468.51.camel@localhost.localdomain>
	<20070731154134.ccea0265.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:49648 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbXHAWW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Aug 2007 18:22:29 -0400
In-Reply-To: <20070731154134.ccea0265.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@SteelEye.com, tomof@acm.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, 31 Jul 2007 15:41:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 31 Jul 2007 17:30:52 -0500
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Tue, 2007-07-31 at 15:27 -0700, Andrew Morton wrote:
> > > ERROR: "scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko] undefined!
> > > ERROR: "scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko] undefined!
> > > 
> > > This bug was reported about seven times against 2.6.23-rc1-mm1's
> > > git-scsi-target, and now it has been moved into git-scsi-misc.
> > 
> > Yes ... Tomo's on the hook for a better fix, which is promised.
> > 
> 
> mutter.
> 
> Please, nothing which uses Kconfig `select'.  They regularly go wrong.
> 
> Please copy me on that fix so I know when to drop this one.

Really sorry about this issue that I should have fixed a long time
ago. The following patch was merged to scsi-misc. Hopefully it will
fix the issue.

---
>From 00924b31df30e4ddcf9ba9b5082171e5e46b9eb0 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 2 Aug 2007 00:03:11 +0900
Subject: [PATCH] scsi_transport_srp: remove tgt dependencies

it's better to remove tgt dependencies in srp transport class since
most people want only initiator support.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/Kconfig                       |   11 +++++++++--
 drivers/scsi/scsi_transport_srp.c          |   10 +++++-----
 drivers/scsi/scsi_transport_srp_internal.h |   25 +++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 7 deletions(-)
 create mode 100644 drivers/scsi/scsi_transport_srp_internal.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4562273..7877dfd 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -291,11 +291,18 @@ source "drivers/scsi/libsas/Kconfig"
 
 config SCSI_SRP_ATTRS
 	tristate "SRP Transport Attributes"
-	depends on SCSI && SCSI_TGT
+	depends on SCSI
 	help
 	  If you wish to export transport-specific information about
 	  each attached SRP device to sysfs, say Y.
 
+config SCSI_SRP_TGT_ATTRS
+	bool "SCSI target support for SRP Transport Attributes"
+	depends on SCSI_SRP_ATTRS
+	depends on SCSI_TGT = y || SCSI_TGT = SCSI_SRP_ATTRS
+	help
+		If you want to use SCSI target mode drivers enable this option.
+
 endmenu
 
 menuconfig SCSI_LOWLEVEL
@@ -848,7 +855,7 @@ config SCSI_IBMVSCSI
 
 config SCSI_IBMVSCSIS
 	tristate "IBM Virtual SCSI Server support"
-	depends on PPC_PSERIES && SCSI_TGT && SCSI_SRP && SCSI_SRP_ATTRS
+	depends on PPC_PSERIES && SCSI_SRP && SCSI_SRP_TGT_ATTRS
 	help
 	  This is the SRP target driver for IBM pSeries virtual environments.
 
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index cdd001a..430501e 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -30,7 +30,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_srp.h>
-#include <scsi/scsi_tgt.h>
+#include "scsi_transport_srp_internal.h"
 
 struct srp_host_attrs {
 	atomic_t next_port_id;
@@ -223,8 +223,8 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 	}
 
 	if (ids->roles == SRP_RPORT_ROLE_INITIATOR) {
-		ret = scsi_tgt_it_nexus_create(shost, (unsigned long)rport,
-					       rport->port_id);
+		ret = srp_tgt_it_nexus_create(shost, (unsigned long)rport,
+					      rport->port_id);
 		if (ret) {
 			device_del(&rport->dev);
 			transport_destroy_device(&rport->dev);
@@ -251,8 +251,8 @@ void srp_rport_del(struct srp_rport *rport)
 	struct device *dev = &rport->dev;
 
 	if (rport->roles == SRP_RPORT_ROLE_INITIATOR)
-		scsi_tgt_it_nexus_destroy(dev_to_shost(dev->parent),
-					  (unsigned long)rport);
+		srp_tgt_it_nexus_destroy(dev_to_shost(dev->parent),
+					 (unsigned long)rport);
 
 	transport_remove_device(dev);
 	device_del(dev);
diff --git a/drivers/scsi/scsi_transport_srp_internal.h b/drivers/scsi/scsi_transport_srp_internal.h
new file mode 100644
index 0000000..8a79747
--- /dev/null
+++ b/drivers/scsi/scsi_transport_srp_internal.h
@@ -0,0 +1,25 @@
+#include <scsi/scsi_tgt.h>
+
+#ifdef CONFIG_SCSI_SRP_TGT_ATTRS
+static inline int srp_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
+					  char *initiator)
+{
+	return scsi_tgt_it_nexus_create(shost, itn_id, initiator);
+}
+
+static inline int srp_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
+{
+	return scsi_tgt_it_nexus_destroy(shost, itn_id);
+}
+
+#else
+static inline int srp_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
+					  char *initiator)
+{
+	return 0;
+}
+static inline int srp_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
+{
+	return 0;
+}
+#endif
-- 
1.5.2.4

