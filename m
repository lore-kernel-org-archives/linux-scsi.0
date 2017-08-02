From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.13-rc3
Date: Wed, 02 Aug 2017 07:24:00 -0700
Message-ID: <1501683840.2741.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This seven is mostly minor build, Kconfig and error leg fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: lpfc: fix linking against modular NVMe support

Dan Carpenter (1):
      scsi: qedi: Fix return code in qedi_ep_connect()

Hannes Reinecke (1):
      scsi: scsi_transport_fc: return -EBUSY for deleted vport

Jakub Kicinski (1):
      scsi: aic7xxx: fix firmware build with O=path

Nilesh Javali (1):
      scsi: qedi: Add ISCSI_BOOT_SYSFS to Kconfig

Shu Wang (1):
      scsi: megaraid_sas: fix memleak in megasas_alloc_cmdlist_fusion

Varun Prakash (1):
      scsi: libcxgbi: add check for valid cxgbi_task_data

And the diffstat:

 drivers/scsi/Kconfig                        |  2 ++
 drivers/scsi/aic7xxx/Makefile               | 12 +++----
 drivers/scsi/aic7xxx/aicasm/Makefile        | 53 ++++++++++++++++-------------
 drivers/scsi/cxgbi/libcxgbi.c               |  7 ++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  6 +++-
 drivers/scsi/qedi/Kconfig                   |  1 +
 drivers/scsi/qedi/qedi_iscsi.c              |  8 ++---
 drivers/scsi/scsi_transport_fc.c            |  6 ++--
 8 files changed, 58 insertions(+), 37 deletions(-)

with full diff below.

James

---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d384f4f86c26..f4538d7a3016 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1230,6 +1230,8 @@ config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
 	depends on SCSI_FC_ATTRS
+	depends on NVME_TARGET_FC || NVME_TARGET_FC=n
+	depends on NVME_FC || NVME_FC=n
 	select CRC_T10DIF
 	---help---
           This lpfc driver supports the Emulex LightPulse
diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index 741d81861d17..07b60a780c06 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -55,9 +55,9 @@ aicasm-7xxx-opts-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT) := \
 
 ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
 $(obj)/aic7xxx_seq.h: $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
-	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic7xxx_reg.h \
+	$(obj)/aicasm/aicasm -I$(srctree)/$(src) -r $(obj)/aic7xxx_reg.h \
 			      $(aicasm-7xxx-opts-y) -o $(obj)/aic7xxx_seq.h \
-			      $(src)/aic7xxx.seq
+			      $(srctree)/$(src)/aic7xxx.seq
 
 $(aic7xxx-gen-y): $(obj)/aic7xxx_seq.h
 else
@@ -72,14 +72,14 @@ aicasm-79xx-opts-$(CONFIG_AIC79XX_REG_PRETTY_PRINT) := \
 
 ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
 $(obj)/aic79xx_seq.h: $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
-	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic79xx_reg.h \
+	$(obj)/aicasm/aicasm -I$(srctree)/$(src) -r $(obj)/aic79xx_reg.h \
 			      $(aicasm-79xx-opts-y) -o $(obj)/aic79xx_seq.h \
-			      $(src)/aic79xx.seq
+			      $(srctree)/$(src)/aic79xx.seq
 
 $(aic79xx-gen-y): $(obj)/aic79xx_seq.h
 else
 $(obj)/aic79xx_reg_print.c: $(src)/aic79xx_reg_print.c_shipped
 endif
 
-$(obj)/aicasm/aicasm: $(src)/aicasm/*.[chyl]
-	$(MAKE) -C $(src)/aicasm
+$(obj)/aicasm/aicasm: $(srctree)/$(src)/aicasm/*.[chyl]
+	$(MAKE) -C $(srctree)/$(src)/aicasm OUTDIR=$(shell pwd)/$(obj)/aicasm/
diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/aicasm/Makefile
index b98c5c1056c3..45e2d49c1fff 100644
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -1,19 +1,21 @@
 PROG=	aicasm
 
+OUTDIR ?= ./
+
 .SUFFIXES= .l .y .c .h
 
 CSRCS=	aicasm.c aicasm_symbol.c
 YSRCS=	aicasm_gram.y aicasm_macro_gram.y
 LSRCS=	aicasm_scan.l aicasm_macro_scan.l
 
-GENHDRS=	aicdb.h $(YSRCS:.y=.h)
-GENSRCS=	$(YSRCS:.y=.c) $(LSRCS:.l=.c)
+GENHDRS=	$(addprefix ${OUTDIR}/,aicdb.h $(YSRCS:.y=.h))
+GENSRCS=	$(addprefix ${OUTDIR}/,$(YSRCS:.y=.c) $(LSRCS:.l=.c))
 
 SRCS=	${CSRCS} ${GENSRCS}
 LIBS=	-ldb
 clean-files:= ${GENSRCS} ${GENHDRS} $(YSRCS:.y=.output) $(PROG)
 # Override default kernel CFLAGS.  This is a userland app.
-AICASM_CFLAGS:= -I/usr/include -I.
+AICASM_CFLAGS:= -I/usr/include -I. -I$(OUTDIR)
 LEX= flex
 YACC= bison
 YFLAGS= -d
@@ -32,22 +34,25 @@ YFLAGS+= -t -v
 LFLAGS= -d
 endif
 
-$(PROG):  ${GENHDRS} $(SRCS)
-	$(AICASM_CC) $(AICASM_CFLAGS) $(SRCS) -o $(PROG) $(LIBS)
+$(PROG):  $(OUTDIR) ${GENHDRS} $(SRCS)
+	$(AICASM_CC) $(AICASM_CFLAGS) $(SRCS) -o $(OUTDIR)/$(PROG) $(LIBS)
+
+$(OUTDIR):
+	mkdir -p $(OUTDIR)
 
-aicdb.h:
+$(OUTDIR)/aicdb.h:
 	@if [ -e "/usr/include/db4/db_185.h" ]; then		\
-		echo "#include <db4/db_185.h>" > aicdb.h;	\
+		echo "#include <db4/db_185.h>" > $@;	\
 	 elif [ -e "/usr/include/db3/db_185.h" ]; then		\
-		echo "#include <db3/db_185.h>" > aicdb.h;	\
+		echo "#include <db3/db_185.h>" > $@;	\
 	 elif [ -e "/usr/include/db2/db_185.h" ]; then		\
-		echo "#include <db2/db_185.h>" > aicdb.h;	\
+		echo "#include <db2/db_185.h>" > $@;	\
 	 elif [ -e "/usr/include/db1/db_185.h" ]; then		\
-		echo "#include <db1/db_185.h>" > aicdb.h;	\
+		echo "#include <db1/db_185.h>" > $@;	\
 	 elif [ -e "/usr/include/db/db_185.h" ]; then		\
-		echo "#include <db/db_185.h>" > aicdb.h;	\
+		echo "#include <db/db_185.h>" > $@;	\
 	 elif [ -e "/usr/include/db_185.h" ]; then		\
-		echo "#include <db_185.h>" > aicdb.h;		\
+		echo "#include <db_185.h>" > $@;		\
 	 else							\
 		echo "*** Install db development libraries";	\
 	 fi
@@ -58,23 +63,23 @@ clean:
 # Create a dependency chain in generated files
 # to avoid concurrent invocations of the single
 # rule that builds them all.
-aicasm_gram.c: aicasm_gram.h
-aicasm_gram.c aicasm_gram.h: aicasm_gram.y
+$(OUTDIR)/aicasm_gram.c: $(OUTDIR)/aicasm_gram.h
+$(OUTDIR)/aicasm_gram.c $(OUTDIR)/aicasm_gram.h: aicasm_gram.y
 	$(YACC) $(YFLAGS) -b $(<:.y=) $<
-	mv $(<:.y=).tab.c $(<:.y=.c)
-	mv $(<:.y=).tab.h $(<:.y=.h)
+	mv $(<:.y=).tab.c $(OUTDIR)/$(<:.y=.c)
+	mv $(<:.y=).tab.h $(OUTDIR)/$(<:.y=.h)
 
 # Create a dependency chain in generated files
 # to avoid concurrent invocations of the single
 # rule that builds them all.
-aicasm_macro_gram.c: aicasm_macro_gram.h
-aicasm_macro_gram.c aicasm_macro_gram.h: aicasm_macro_gram.y
+$(OUTDIR)/aicasm_macro_gram.c: $(OUTDIR)/aicasm_macro_gram.h
+$(OUTDIR)/aicasm_macro_gram.c $(OUTDIR)/aicasm_macro_gram.h: aicasm_macro_gram.y
 	$(YACC) $(YFLAGS) -b $(<:.y=) -p mm $<
-	mv $(<:.y=).tab.c $(<:.y=.c)
-	mv $(<:.y=).tab.h $(<:.y=.h)
+	mv $(<:.y=).tab.c $(OUTDIR)/$(<:.y=.c)
+	mv $(<:.y=).tab.h $(OUTDIR)/$(<:.y=.h)
 
-aicasm_scan.c: aicasm_scan.l
-	$(LEX) $(LFLAGS) -o$@ $<
+$(OUTDIR)/aicasm_scan.c: aicasm_scan.l
+	$(LEX) $(LFLAGS) -o $@ $<
 
-aicasm_macro_scan.c: aicasm_macro_scan.l
-	$(LEX) $(LFLAGS) -Pmm -o$@ $<
+$(OUTDIR)/aicasm_macro_scan.c: aicasm_macro_scan.l
+	$(LEX) $(LFLAGS) -Pmm -o $@ $<
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index e4c83b7c96a8..1a4cfa562a60 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2128,6 +2128,13 @@ void cxgbi_cleanup_task(struct iscsi_task *task)
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
 
+	if (!tcp_task || !tdata || (tcp_task->dd_data != tdata)) {
+		pr_info("task 0x%p,0x%p, tcp_task 0x%p, tdata 0x%p/0x%p.\n",
+			task, task->sc, tcp_task,
+			tcp_task ? tcp_task->dd_data : NULL, tdata);
+		return;
+	}
+
 	log_debug(1 << CXGBI_DBG_ISCSI,
 		"task 0x%p, skb 0x%p, itt 0x%x.\n",
 		task, tdata->skb, task->hdr_itt);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f990ab4d45e1..985510628f56 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -425,7 +425,7 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 int
 megasas_alloc_cmdlist_fusion(struct megasas_instance *instance)
 {
-	u32 max_mpt_cmd, i;
+	u32 max_mpt_cmd, i, j;
 	struct fusion_context *fusion;
 
 	fusion = instance->ctrl_context;
@@ -450,11 +450,15 @@ megasas_alloc_cmdlist_fusion(struct megasas_instance *instance)
 		fusion->cmd_list[i] = kzalloc(sizeof(struct megasas_cmd_fusion),
 					      GFP_KERNEL);
 		if (!fusion->cmd_list[i]) {
+			for (j = 0; j < i; j++)
+				kfree(fusion->cmd_list[j]);
+			kfree(fusion->cmd_list);
 			dev_err(&instance->pdev->dev,
 				"Failed from %s %d\n",  __func__, __LINE__);
 			return -ENOMEM;
 		}
 	}
+
 	return 0;
 }
 int
diff --git a/drivers/scsi/qedi/Kconfig b/drivers/scsi/qedi/Kconfig
index 21331453db7b..2ff753ce6e27 100644
--- a/drivers/scsi/qedi/Kconfig
+++ b/drivers/scsi/qedi/Kconfig
@@ -5,6 +5,7 @@ config QEDI
 	select SCSI_ISCSI_ATTRS
 	select QED_LL2
 	select QED_ISCSI
+	select ISCSI_BOOT_SYSFS
 	---help---
 	This driver supports iSCSI offload for the QLogic FastLinQ
 	41000 Series Converged Network Adapters.
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 80edd28b635f..37da9a8b43b1 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -824,7 +824,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	u32 iscsi_cid = QEDI_CID_RESERVED;
 	u16 len = 0;
 	char *buf = NULL;
-	int ret;
+	int ret, tmp;
 
 	if (!shost) {
 		ret = -ENXIO;
@@ -940,10 +940,10 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 
 ep_rel_conn:
 	qedi->ep_tbl[iscsi_cid] = NULL;
-	ret = qedi_ops->release_conn(qedi->cdev, qedi_ep->handle);
-	if (ret)
+	tmp = qedi_ops->release_conn(qedi->cdev, qedi_ep->handle);
+	if (tmp)
 		QEDI_WARN(&qedi->dbg_ctx, "release_conn returned %d\n",
-			  ret);
+			  tmp);
 ep_free_sq:
 	qedi_free_sq(qedi, qedi_ep);
 ep_conn_exit:
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 7e24aa30c3b0..892fbd9800d9 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1286,7 +1286,7 @@ store_fc_vport_delete(struct device *dev, struct device_attribute *attr,
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)) {
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING | FC_VPORT_DELETING)) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		return -EBUSY;
 	}
@@ -2430,8 +2430,10 @@ fc_remove_host(struct Scsi_Host *shost)
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	/* Remove any vports */
-	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers)
+	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers) {
+		vport->flags |= FC_VPORT_DELETING;
 		fc_queue_work(shost, &vport->vport_delete_work);
+	}
 
 	/* Remove any remote ports */
 	list_for_each_entry_safe(rport, next_rport,
