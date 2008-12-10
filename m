From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 16/23]: Documentation for QLogic target driver
Date: Wed, 10 Dec 2008 21:54:15 +0300
Message-ID: <49401057.4030600@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYLJSzG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:55:06 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, linux-driver@qlogic.com, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains documentation for QLogic target mode add-on.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  /Documentation/scst/README.qla2x00t |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  1 file changed, 117 insertions(+)

diff -uprN orig/linux-2.6.27/Documentation/scst/README.qla2x00t linux-2.6.27/Documentation/scst/README.qla2x00t
--- orig/linux-2.6.27/Documentation/scst/README.qla2x00t
+++ linux-2.6.27/Documentation/scst/README.qla2x00t
@@ -0,0 +1,117 @@
+Target driver for Qlogic 2200/2300 Fibre Channel cards
+======================================================
+
+Version 1.0.1, XX XXXX 2008
+---------------------------
+
+This driver has all required features and looks to be quite stable (for
+beta) and useful. It consists from two parts: the target mode driver
+itself and the changed initiator driver from Linux kernel, which is,
+particularly, intended to perform all the initialization and shutdown
+tasks. This driver was changed to provide the target mode support and
+all necessary callbacks, but it's still capable to work as initiator
+only. Mode, when a host acts as the initiator and the target
+simultaneously, is supported as well.
+
+This version is compatible with SCST core version 1.0.1 and higher and
+Linux kernel 2.6.27 and higher. Backport patches to kernels earlier than
+2.6.27 are welcome.
+
+The original initiator driver was taken from the kernel 2.6.27.
+
+If you need to use this driver on kernels prior 2.6.27, it is
+recommended to use version 1.0.0.x of this driver, taken from branch
+1.0.0.x. For 2.6.26 you can also use version of this driver from SVN
+trunk/ revision 577.
+
+See also "ToDo" file for list of known issues and unimplemented 
+features.
+
+Installation
+------------
+
+Only vanilla kernels from kernel.org are supported, but it should work
+on vendors' kernels, if you manage to successfully compile on them. The
+main problem with vendor's kernels is that they often contain patches,
+which will appear only in the next version of the vanilla kernel,
+therefore it's quite hard to track such changes. Thus, if during
+compilation for some vendor kernel your compiler complains about
+redefinition of some symbol, you should either switch to vanilla kernel,
+or change as necessary the corresponding to that symbol "#if
+LINUX_VERSION_CODE" statement.
+
+At first, make sure that the link "/lib/modules/`you_kernel_version`/build" 
+points to the source code for your currently running kernel.
+
+Then you should replace (or link) by the initiator driver from this
+package "qla2xxx" subdirectory in kernel_source/drivers/scsi/ of the
+currently running kernel and using your favorite kernel configuration
+tool enable in the QLogic QLA2XXX Fibre Channel driver target mode
+support (CONFIG_SCSI_QLA2XXX_TARGET). Then rebuild the kernel and its
+modules. During this step you will compile the initiator driver. To
+install it, install the built kernel and its modules.
+
+Then edit qla2x00-target/Makefile and set SCST_INC_DIR variable to point
+to the directory, where SCST's public include files are located. If you
+install QLA2x00 target driver's source code in the SCST's directory,
+then SCST_INC_DIR will be set correctly for you.
+
+Also you can set SCST_DIR variable to the directory, where SCST was
+built, but this is optional. If you don't set it or set incorrectly,
+during the compilation you will get a bunch of harmless warnings like
+"WARNING: "scst_rx_data" [/XXX/qla2x00tgt.ko] undefined!"
+
+To compile the target driver, type 'make' in qla2x00-target/
+subdirectory. It will build qla2x00tgt.ko module.
+
+To install the target driver, type 'make install' in qla2x00-target/
+subdirectory. The target driver will be installed in
+/lib/modules/`you_kernel_version`/extra. To uninstall it, type 'make
+uninstall'.
+
+After the drivers are loaded and adapters successfully initialized by
+the initiator driver, including firmware image load, the target mode
+should be enabled via a sysfs interface on a per card basis. Under the
+appropriate scsi_host there is an entry target_mode_enabled, where you
+should write "1", like:
+
+echo "1" >/sys/class/scsi_host/host0/target_mode_enabled
+
+Then you should configure exported devices using the corresponding
+interface of SCST core. It is highly recommended to use scstadmin
+utility for that purpose.
+
+Compilation options
+-------------------
+
+There are the following compilation options, that could be commented
+in/out in Makefile:
+
+ - CONFIG_SCST_DEBUG - turns on some debugging code, including some logging.
+   Makes the driver considerably bigger and slower, producing large amount of
+   log data.
+
+ - CONFIG_SCST_TRACING - turns on ability to log events. Makes the driver
+   considerably bigger and leads to some performance loss.
+
+ - CONFIG_QLA_TGT_DEBUG_WORK_IN_THREAD - makes SCST process incoming
+   commands from the qla2x00t target driver and call the driver's
+   callbacks in internal SCST threads context instead of SIRQ context,
+   where those commands were received. Useful for debugging and lead to
+   some performance loss.
+   
+Credits
+-------
+
+Thanks to 
+
+ * Nathaniel Clark <nate@misrule.us> for porting to new 2.6 kernel
+initiator driver.
+
+ * Mark Buechler <mark.buechler@gmail.com> for the original
+WWN-based authentification, a lot of useful suggestions, bug reports and
+help in debugging.
+
+ * Ming Zhang <mingz@ele.uri.edu> for his fixes.
+
+Vladislav Bolkhovitin <vst@vlnb.net>, http://scst.sourceforge.net

