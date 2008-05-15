From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: 2.6.26-rc2-mm1 (SCSI_DH build errors)
Date: Thu, 15 May 2008 12:56:14 -0700
Message-ID: <1210881374.21974.285.camel@chandra-ubuntu>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	 <20080514141348.e71feed6.randy.dunlap@oracle.com>
	 <1210862779.15852.4.camel@localhost.localdomain>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-BJearIvH68NmH0wgeTAh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41311 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764707AbYEOTyb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 15:54:31 -0400
In-Reply-To: <1210862779.15852.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, hare@suse.de, scsi <linux-scsi@vger.kernel.org>


--=-BJearIvH68NmH0wgeTAh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi James, Andrew,

Here is a patch to remove the automatic "select" of scsi_dh for
dm-multipath.

Sorry about the mishap.

chandra
On Thu, 2008-05-15 at 15:46 +0100, James Bottomley wrote:
> On Wed, 2008-05-14 at 14:13 -0700, Randy Dunlap wrote:
> > On Wed, 14 May 2008 01:01:29 -0700 Andrew Morton wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/
> > 
> > SCSI_DH has some problems when CONFIG_SCSI=n:
> > 
> > drivers/built-in.o: In function `activate_path':
> > dm-mpath.c:(.text+0x18a292): undefined reference to `scsi_dh_activate'
> > drivers/built-in.o: In function `multipath_ctr':
> > dm-mpath.c:(.text+0x18a6f0): undefined reference to `scsi_dh_handler_exist'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > 
> > 
> > #
> > # SCSI device support
> > #
> > CONFIG_RAID_ATTRS=y
> > # CONFIG_SCSI is not set
> > # CONFIG_SCSI_DMA is not set
> > # CONFIG_SCSI_NETLINK is not set
> > CONFIG_SCSI_DH=y
> > CONFIG_SCSI_DH_RDAC=y
> > CONFIG_SCSI_DH_HP_SW=y
> > CONFIG_SCSI_DH_EMC=y
> 
> This is one more of those annoying selects.  The SCSI_DH Kconfig file is
> correctly dependent on SCSI:
> 
> menuconfig SCSI_DH
> 	tristate "SCSI Device Handlers"
> 	depends on SCSI
> 	default n
> 	help
> 
> but we've also got a select in md/Kconfig:
> 
> config DM_MULTIPATH
> 	tristate "Multipath target"
> 	depends on BLK_DEV_DM
> 	select SCSI_DH
> 
> Which ignores the dependency.
> 
> My best guess for fixing this is either to make the select a depends or
> just drop it altogether (after all, it's possible to have multipath on
> non-SCSI devices).
> 
> James
> 
> 

--=-BJearIvH68NmH0wgeTAh
Content-Disposition: attachment; filename=remove_select_on_multipath
Content-Type: text/plain; name=remove_select_on_multipath; charset=utf-8
Content-Transfer-Encoding: 7bit

Do not automatically "select" SCSI_DH for dm-multipath. If SCSI_DH
doesn't exist,just do not allow  hardware handlers to be used.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

Index: scsi-misc-2.6/drivers/md/Kconfig
===================================================================
--- scsi-misc-2.6.orig/drivers/md/Kconfig
+++ scsi-misc-2.6/drivers/md/Kconfig
@@ -252,7 +252,6 @@ config DM_ZERO
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
-	select SCSI_DH
 	---help---
 	  Allow volume managers to support multipath hardware.
 
Index: scsi-misc-2.6/drivers/md/dm-mpath.c
===================================================================
--- scsi-misc-2.6.orig/drivers/md/dm-mpath.c
+++ scsi-misc-2.6/drivers/md/dm-mpath.c
@@ -664,6 +664,8 @@ static int parse_hw_handler(struct arg_s
 	request_module("scsi_dh_%s", m->hw_handler_name);
 	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
 		ti->error = "unknown hardware handler type";
+		kfree(m->hw_handler_name);
+		m->hw_handler_name = NULL;
 		return -EINVAL;
 	}
 	consume(as, hw_argc - 1);
Index: scsi-misc-2.6/include/scsi/scsi_dh.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_dh.h
+++ scsi-misc-2.6/include/scsi/scsi_dh.h
@@ -54,6 +54,16 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
-
+#ifdef CONFIG_SCSI_DH
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
+#else
+inline int scsi_dh_activate(struct request_queue *req)
+{
+	return 0;
+}
+inline int scsi_dh_handler_exist(const char *name)
+{
+	return 0;
+}
+#endif

--=-BJearIvH68NmH0wgeTAh--

