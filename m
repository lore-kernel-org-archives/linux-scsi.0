From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 4/4] target: Minimize SCSI header #include directives
Date: Tue, 7 Apr 2015 14:34:13 +0200
Message-ID: <5523CEC5.7080105@sandisk.com>
References: <5523CE55.3090401@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0091.outbound.protection.outlook.com ([157.56.110.91]:10589
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753565AbbDGMeW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2015 08:34:22 -0400
In-Reply-To: <5523CE55.3090401@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

Only include SCSI initiator header files in target code that needs
these header files, namely the SCSI pass-through code and the tcm_loop
driver. Change SCSI_SENSE_BUFFERSIZE into TRANSPORT_SENSE_BUFFER in
target code because the former is intended for initiator code and the
latter for target code.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 Documentation/target/tcm_mod_builder.py    | 7 ++-----
 drivers/infiniband/ulp/srpt/ib_srpt.c      | 1 +
 drivers/infiniband/ulp/srpt/ib_srpt.h      | 2 +-
 drivers/target/iscsi/iscsi_target.c        | 2 +-
 drivers/target/iscsi/iscsi_target_device.c | 1 -
 drivers/target/iscsi/iscsi_target_tmr.c    | 2 +-
 drivers/target/sbp/sbp_target.c            | 2 +-
 drivers/target/target_core_alua.c          | 3 +--
 drivers/target/target_core_device.c        | 4 ++--
 drivers/target/target_core_fabric_lib.c    | 2 --
 drivers/target/target_core_file.c          | 3 +--
 drivers/target/target_core_iblock.c        | 3 +--
 drivers/target/target_core_pr.c            | 3 +--
 drivers/target/target_core_pscsi.c         | 2 --
 drivers/target/target_core_pscsi.h         | 6 +++---
 drivers/target/target_core_rd.c            | 3 +--
 drivers/target/target_core_sbc.c           | 2 +-
 drivers/target/target_core_spc.c           | 3 ++-
 drivers/target/target_core_stat.c          | 3 ---
 drivers/target/target_core_tmr.c           | 2 --
 drivers/target/target_core_tpg.c           | 3 +--
 drivers/target/target_core_transport.c     | 4 +---
 drivers/target/target_core_ua.c            | 3 +--
 drivers/target/target_core_user.c          | 5 +++--
 drivers/target/target_core_xcopy.c         | 3 +--
 drivers/target/tcm_fc/tfc_cmd.c            | 4 ----
 drivers/target/tcm_fc/tfc_conf.c           | 4 ----
 drivers/target/tcm_fc/tfc_io.c             | 4 ----
 drivers/target/tcm_fc/tfc_sess.c           | 4 ----
 drivers/usb/gadget/legacy/tcm_usb_gadget.c | 1 -
 drivers/usb/gadget/legacy/tcm_usb_gadget.h | 1 -
 drivers/vhost/scsi.c                       | 3 ++-
 drivers/xen/xen-scsiback.c                 | 5 +----
 include/target/iscsi/iscsi_target_core.h   | 1 -
 include/target/target_core_base.h          | 3 +--
 include/trace/events/target.h              | 2 +-
 36 files changed, 32 insertions(+), 74 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 2b47704..cd9d124 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -558,11 +558,8 @@ def tcm_mod_dump_fabric_ops(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 	buf += "#include <linux/string.h>\n"
 	buf += "#include <linux/ctype.h>\n"
 	buf += "#include <asm/unaligned.h>\n"
-	buf += "#include <scsi/scsi.h>\n"
-	buf += "#include <scsi/scsi_host.h>\n"
-	buf += "#include <scsi/scsi_device.h>\n"
-	buf += "#include <scsi/scsi_cmnd.h>\n"
-	buf += "#include <scsi/libfc.h>\n\n"
+	buf += "#include <scsi/scsi_common.h>\n"
+	buf += "#include <scsi/scsi_proto.h>\n"
 	buf += "#include <target/target_core_base.h>\n"
 	buf += "#include <target/target_core_fabric.h>\n"
 	buf += "#include <target/target_core_configfs.h>\n\n"
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6e0a477..e95145a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -41,6 +41,7 @@
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
+#include <scsi/scsi_proto.h>
 #include <scsi/scsi_tcq.h>
 #include <target/configfs_macros.h>
 #include <target/target_core_base.h>
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 3dae156..d85c0c2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -245,7 +245,7 @@ struct srpt_send_ioctx {
 	u8			n_rdma;
 	u8			n_rbuf;
 	bool			queue_status_only;
-	u8			sense_data[SCSI_SENSE_BUFFERSIZE];
+	u8			sense_data[TRANSPORT_SENSE_BUFFER];
 };
 
 /**
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2accb6e..168ac7d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -23,7 +23,7 @@
 #include <linux/module.h>
 #include <linux/idr.h>
 #include <asm/unaligned.h>
-#include <scsi/scsi_device.h>
+#include <scsi/scsi_proto.h>
 #include <scsi/iscsi_proto.h>
 #include <scsi/scsi_tcq.h>
 #include <target/target_core_base.h>
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index 34c3cd1..5fabcd3 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -17,7 +17,6 @@
  * GNU General Public License for more details.
  ******************************************************************************/
 
-#include <scsi/scsi_device.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index b0224a7..fe9a582 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -17,7 +17,7 @@
  ******************************************************************************/
 
 #include <asm/unaligned.h>
-#include <scsi/scsi_device.h>
+#include <scsi/scsi_proto.h>
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 9512af6..30aecb9 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -30,7 +30,7 @@
 #include <linux/ctype.h>
 #include <linux/firewire.h>
 #include <linux/firewire-constants.h>
-#include <scsi/scsi.h>
+#include <scsi/scsi_proto.h>
 #include <scsi/scsi_tcq.h>
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 75cbde1..29904a9 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -28,8 +28,7 @@
 #include <linux/configfs.h>
 #include <linux/export.h>
 #include <linux/file.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_proto.h>
 #include <asm/unaligned.h>
 
 #include <target/target_core_base.h>
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 79b4ec3..4015cbd 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -35,8 +35,8 @@
 #include <linux/export.h>
 #include <net/sock.h>
 #include <net/tcp.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_device.h>
+#include <scsi/scsi_common.h>
+#include <scsi/scsi_proto.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 35bfe77..fdf31ef 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -29,8 +29,6 @@
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
 #include <linux/export.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 44620fb..23e4152 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -31,8 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/module.h>
 #include <linux/falloc.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
+#include <scsi/scsi_proto.h>
 #include <asm/unaligned.h>
 
 #include <target/target_core_base.h>
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d4a4b0f..d862711 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -35,8 +35,7 @@
 #include <linux/genhd.h>
 #include <linux/file.h>
 #include <linux/module.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
+#include <scsi/scsi_proto.h>
 #include <asm/unaligned.h>
 
 #include <target/target_core_base.h>
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 2de6fb8..2fc16b8 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -28,8 +28,7 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/file.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_proto.h>
 #include <asm/unaligned.h>
 
 #include <target/target_core_base.h>
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 39e2b03..98e64a2 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -36,9 +36,7 @@
 #include <linux/module.h>
 #include <asm/unaligned.h>
 
-#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
index 1bd757d..8fee9b0 100644
--- a/drivers/target/target_core_pscsi.h
+++ b/drivers/target/target_core_pscsi.h
@@ -16,13 +16,13 @@
 #define PS_TIMEOUT_OTHER	(500*HZ)
 
 #include <linux/device.h>
-#include <scsi/scsi_driver.h>
-#include <scsi/scsi_device.h>
 #include <linux/kref.h>
 #include <linux/kobject.h>
 
+struct scsi_device;
+
 struct pscsi_plugin_task {
-	unsigned char pscsi_sense[SCSI_SENSE_BUFFERSIZE];
+	unsigned char pscsi_sense[TRANSPORT_SENSE_BUFFER];
 	int	pscsi_direction;
 	int	pscsi_result;
 	u32	pscsi_resid;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 98e83ac..0a03597 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -29,8 +29,7 @@
 #include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
+#include <scsi/scsi_proto.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 3e72974..95defa7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -25,7 +25,7 @@
 #include <linux/ratelimit.h>
 #include <linux/crc-t10dif.h>
 #include <asm/unaligned.h>
-#include <scsi/scsi.h>
+#include <scsi/scsi_proto.h>
 #include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 6c8bd6b..9ebae02 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -24,7 +24,8 @@
 #include <linux/module.h>
 #include <asm/unaligned.h>
 
-#include <scsi/scsi.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_common.h>
 #include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 0353899..40f6c13 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -33,9 +33,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/configfs.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_host.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index fa5e157..e0201c9 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -27,8 +27,6 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/export.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 0696de9..3ec3a3f 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -32,8 +32,7 @@
 #include <linux/export.h>
 #include <net/sock.h>
 #include <net/tcp.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_proto.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ac3cbab..7f36556 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -37,9 +37,7 @@
 #include <asm/unaligned.h>
 #include <net/sock.h>
 #include <net/tcp.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_proto.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 1738b16..e44cc94 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -25,8 +25,7 @@
 
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_proto.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 1a1bcf7..2a291ba 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -19,12 +19,13 @@
 #include <linux/spinlock.h>
 #include <linux/module.h>
 #include <linux/idr.h>
+#include <linux/kernel.h>
 #include <linux/timer.h>
 #include <linux/parser.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
 #include <linux/uio_driver.h>
 #include <net/genetlink.h>
+#include <scsi/scsi_common.h>
+#include <scsi/scsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/target_core_backend.h>
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 33ac39b..409ad9a 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -25,8 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/configfs.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_proto.h>
 #include <asm/unaligned.h>
 
 #include <target/target_core_base.h>
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index edcafa4..1bf78e7 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -30,10 +30,6 @@
 #include <linux/hash.h>
 #include <linux/percpu_ida.h>
 #include <asm/unaligned.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index efdcb96..2536846 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -34,10 +34,6 @@
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <asm/unaligned.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_cmnd.h>
 #include <scsi/libfc.h>
 
 #include <target/target_core_base.h>
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 583e755..fe585d1 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -39,10 +39,6 @@
 #include <linux/hash.h>
 #include <linux/ratelimit.h>
 #include <asm/unaligned.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_cmnd.h>
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
 
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index ccee7e3..f2a616d 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -32,10 +32,6 @@
 #include <linux/rculist.h>
 #include <linux/kref.h>
 #include <asm/unaligned.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_cmnd.h>
 #include <scsi/libfc.h>
 
 #include <target/target_core_base.h>
diff --git a/drivers/usb/gadget/legacy/tcm_usb_gadget.c b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
index 6e0a019..889623c 100644
--- a/drivers/usb/gadget/legacy/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
@@ -16,7 +16,6 @@
 #include <linux/usb/composite.h>
 #include <linux/usb/gadget.h>
 #include <linux/usb/storage.h>
-#include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
diff --git a/drivers/usb/gadget/legacy/tcm_usb_gadget.h b/drivers/usb/gadget/legacy/tcm_usb_gadget.h
index 8289219..9fb3544 100644
--- a/drivers/usb/gadget/legacy/tcm_usb_gadget.h
+++ b/drivers/usb/gadget/legacy/tcm_usb_gadget.h
@@ -6,7 +6,6 @@
 #include <linux/usb/composite.h>
 #include <linux/usb/uas.h>
 #include <linux/usb/storage.h>
-#include <scsi/scsi.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 71df240..694843f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -37,7 +37,8 @@
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <asm/unaligned.h>
-#include <scsi/scsi.h>
+#include <scsi/scsi_common.h>
+#include <scsi/scsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/target_core_fabric_configfs.h>
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 42bd55a..4796854 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -47,10 +47,7 @@
 
 #include <generated/utsrelease.h>
 
-#include <scsi/scsi.h>
-#include <scsi/scsi_dbg.h>
-#include <scsi/scsi_eh.h>
-#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_host.h> /* SG_ALL */
 
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index d3583d3..9d98498 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -5,7 +5,6 @@
 #include <linux/configfs.h>
 #include <net/sock.h>
 #include <net/tcp.h>
-#include <scsi/scsi_cmnd.h>
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7a6e55f..bc6e6fa 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -6,7 +6,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
 #include <linux/percpu_ida.h>
-#include <scsi/scsi_cmnd.h>
 #include <net/sock.h>
 #include <net/tcp.h>
 
@@ -25,7 +24,7 @@
  * From include/scsi/scsi_cmnd.h:SCSI_SENSE_BUFFERSIZE, currently
  * defined 96, but the real limit is 252 (or 260 including the header)
  */
-#define TRANSPORT_SENSE_BUFFER			SCSI_SENSE_BUFFERSIZE
+#define TRANSPORT_SENSE_BUFFER			96
 /* Used by transport_send_check_condition_and_sense() */
 #define SPC_SENSE_KEY_OFFSET			2
 #define SPC_ADD_SENSE_LEN_OFFSET		7
diff --git a/include/trace/events/target.h b/include/trace/events/target.h
index 04c3c6e..50fea66 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -6,7 +6,7 @@
 
 #include <linux/tracepoint.h>
 #include <linux/trace_seq.h>
-#include <scsi/scsi.h>
+#include <scsi/scsi_proto.h>
 #include <scsi/scsi_tcq.h>
 #include <target/target_core_base.h>
 
-- 
2.1.4

