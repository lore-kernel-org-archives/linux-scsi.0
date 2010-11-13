From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
Date: Sat, 13 Nov 2010 00:01:43 -0600
Message-ID: <1289628103.3015.608.camel@mulgrave.site>
References: <1289606118.3015.539.camel@mulgrave.site>
	 <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
	 <20101113042821.GE18258@parisc-linux.org>
	 <AANLkTik_eXv1_ZaqD01CoT6igzjBZtmECD0e+QUkMhxP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab0KMGBw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Nov 2010 01:01:52 -0500
In-Reply-To: <AANLkTik_eXv1_ZaqD01CoT6igzjBZtmECD0e+QUkMhxP@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, 2010-11-12 at 20:42 -0800, Linus Torvalds wrote:
> On Fri, Nov 12, 2010 at 8:28 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > Actually, it'd be even better if we took away an argument.
> >
> > int queuecommand(struct scsi_cmnd *cmd);
> >
> > Every single driver sets cmd->scsi_done = done;
> 
> .. and i that's all they really ever do with it, I guess that that
> would indeed be an improvement.
> 
> I still do think that passing in shost is actually a good idea, since
> you'll normally be needing it for locking and other things anyway
> (looking at the libata-scsi.c one, for example, the very first thing
> it wants to do is to look up the port from the shost pointer).
> 
> Having to inevitably do that silly double dereference
> ("cmd->device->host") seems bogus. Passing in the host you want to
> queue something on seems to be natural, and avoids that nasty chain of
> dereferences, so it really should improve the code.
> 
> I don't think there are any drivers that don't want that host pointer
> pretty much immediately, even if they can elide the locking. But I
> admit I only looked at two (qla4xxx driver does the exact same thing:
> the very first thing in the queuecommand function is
> "to_qla_host(cmd->device->host)", but it wants that hostdata thing
> too, so whatever.)
> 
> So the shost pointer is certainly a lot more useful than the 'done'
> function pointer.  So yeah, I'd switch them around - pass the 'done'
> thing indirectly, and the shost directly.

I'd like to get rid of done too.  I'm ambivalent on whether we pass in
the host or not, but I did it anyway.

The patch is reasonably small but there are a few driver prototypes to
clean up as well.  How does the attached look? If OK, I'll fold it in
and resubmit the pull.

I think I picked up all the non-x86 drivers that don't show up under
allmodconfig, but it would be nice to incubate this in next for another
couple of days to be sure.

James

---

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 5861683..727d022 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -62,8 +62,8 @@ static int cciss_scsi_proc_info(
 		int length, 	   /* length of data in buffer */
 		int func);	   /* 0 == read, 1 == write */
 
-static int cciss_scsi_queue_command (struct scsi_cmnd *cmd,
-		void (* done)(struct scsi_cmnd *));
+static int cciss_scsi_queue_command (struct Scsi_Host *h,
+				     struct scsi_cmnd *cmd);
 static int cciss_eh_device_reset_handler(struct scsi_cmnd *);
 static int cciss_eh_abort_handler(struct scsi_cmnd *);
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 12a1301..f672491 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -167,7 +167,7 @@ MODULE_LICENSE("GPL");
 #include "53c700_d.h"
 
 
-STATIC int NCR_700_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+STATIC int NCR_700_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *);
 STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_bus_reset(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 73f237a..649fcb3 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1319,7 +1319,7 @@ static inline void BusLogic_IncrementSizeBucket(BusLogic_CommandSizeBuckets_T Co
 */
 
 static const char *BusLogic_DriverInfo(struct Scsi_Host *);
-static int BusLogic_QueueCommand(struct scsi_cmnd *, void (*CompletionRoutine) (struct scsi_cmnd *));
+static int BusLogic_QueueCommand(struct Scsi_Host *h, struct scsi_cmnd *);
 static int BusLogic_BIOSDiskParameters(struct scsi_device *, struct block_device *, sector_t, int *);
 static int BusLogic_ProcDirectoryInfo(struct Scsi_Host *, char *, char **, off_t, int, int);
 static int BusLogic_SlaveConfigure(struct scsi_device *);
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index bdc468c..fd40a32 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -313,7 +313,7 @@ static void NCR5380_print(struct Scsi_Host *instance);
 #endif
 static int NCR5380_abort(Scsi_Cmnd * cmd);
 static int NCR5380_bus_reset(Scsi_Cmnd * cmd);
-static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
+static int NCR5380_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
 static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
 	char *buffer, char **start, off_t offset, int length, int inout);
 
diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index 1db5385..b871d2b 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -132,7 +132,7 @@ struct ccb {			/* Command Control Block 5.3 */
 };
 
 static int aha1542_detect(struct scsi_host_template *);
-static int aha1542_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
+static int aha1542_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int aha1542_bus_reset(Scsi_Cmnd * SCpnt);
 static int aha1542_dev_reset(Scsi_Cmnd * SCpnt);
 static int aha1542_host_reset(Scsi_Cmnd * SCpnt);
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 2e2d6da..17e3df4 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -85,8 +85,7 @@ static int arcmsr_abort(struct scsi_cmnd *);
 static int arcmsr_bus_reset(struct scsi_cmnd *);
 static int arcmsr_bios_param(struct scsi_device *sdev,
 		struct block_device *bdev, sector_t capacity, int *info);
-static int arcmsr_queue_command(struct scsi_cmnd *cmd,
-					void (*done) (struct scsi_cmnd *));
+static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int arcmsr_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
 static void arcmsr_remove(struct pci_dev *pdev);
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index b65f4cf..377cfb7 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -331,23 +331,21 @@ extern int fas216_init (struct Scsi_Host *instance);
  */
 extern int fas216_add (struct Scsi_Host *instance, struct device *dev);
 
-/* Function: int fas216_queue_command(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+/* Function: int fas216_queue_command(struct Scsi_Host *h, struct scsi_cmnd *SCpnt)
  * Purpose : queue a command for adapter to process.
- * Params  : SCpnt - Command to queue
- *	     done  - done function to call once command is complete
+ * Params  : h - host adapter
+ *	   : SCpnt - Command to queue
  * Returns : 0 - success, else error
  */
-extern int fas216_queue_command(struct scsi_cmnd *,
-				void (*done)(struct scsi_cmnd *));
+extern int fas216_queue_command(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);
 
-/* Function: int fas216_noqueue_command(istruct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+/* Function: int fas216_noqueue_command(struct Scsi_Host *h, struct scsi_cmnd *SCpnt)
  * Purpose : queue a command for adapter to process, and process it to completion.
- * Params  : SCpnt - Command to queue
- *	     done  - done function to call once command is complete
+ * Params  : h - host adapter
+ *	   : SCpnt - Command to queue
  * Returns : 0 - success, else error
  */
-extern int fas216_noqueue_command(struct scsi_cmnd *,
-				  void (*done)(struct scsi_cmnd *));
+extern int fas216_noqueue_command(struct Scsi_Host *, struct scsi_cmnd *)
 
 /* Function: irqreturn_t fas216_intr (FAS216_Info *info)
  * Purpose : handle interrupts from the interface to progress a command
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 4b8103e..8ca967d 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -30,8 +30,7 @@ DEFINE_IDR(bfad_im_port_index);
 struct scsi_transport_template *bfad_im_scsi_transport_template;
 struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 static void bfad_im_itnim_work_handler(struct work_struct *work);
-static int bfad_im_queuecommand(struct scsi_cmnd *cmnd,
-				void (*done)(struct scsi_cmnd *));
+static int bfad_im_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmnd);
 static int bfad_im_slave_alloc(struct scsi_device *sdev);
 static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
 				struct bfad_itnim_s *itnim);
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index 337746d..beded71 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -29,7 +29,7 @@
  */
 
 static int adpt_detect(struct scsi_host_template * sht);
-static int adpt_queue(struct scsi_cmnd * cmd, void (*cmdcomplete) (struct scsi_cmnd *));
+static int adpt_queue(struct Scsi_Host *h, struct scsi_cmnd * cmd);
 static int adpt_abort(struct scsi_cmnd * cmd);
 static int adpt_reset(struct scsi_cmnd* cmd);
 static int adpt_release(struct Scsi_Host *host);
diff --git a/drivers/scsi/dtc.h b/drivers/scsi/dtc.h
index 0b205f8..cdc6212 100644
--- a/drivers/scsi/dtc.h
+++ b/drivers/scsi/dtc.h
@@ -36,7 +36,7 @@ static int dtc_abort(Scsi_Cmnd *);
 static int dtc_biosparam(struct scsi_device *, struct block_device *,
 		         sector_t, int*);
 static int dtc_detect(struct scsi_host_template *);
-static int dtc_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
+static int dtc_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
 static int dtc_bus_reset(Scsi_Cmnd *);
 
 #ifndef CMD_PER_LUN
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index f9d61d4..53925ac 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -505,8 +505,7 @@
 
 static int eata2x_detect(struct scsi_host_template *);
 static int eata2x_release(struct Scsi_Host *);
-static int eata2x_queuecommand(struct scsi_cmnd *,
-			       void (*done) (struct scsi_cmnd *));
+static int eata2x_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int eata2x_eh_abort(struct scsi_cmnd *);
 static int eata2x_eh_host_reset(struct scsi_cmnd *);
 static int eata2x_bios_param(struct scsi_device *, struct block_device *,
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index cbb20b1..92f1850 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -246,7 +246,7 @@ void fnic_set_port_id(struct fc_lport *, u32, struct fc_frame *);
 void fnic_update_mac(struct fc_lport *, u8 *new);
 void fnic_update_mac_locked(struct fnic *, u8 *new);
 
-int fnic_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fnic_abort_cmd(struct scsi_cmnd *);
 int fnic_device_reset(struct scsi_cmnd *);
 int fnic_host_reset(struct scsi_cmnd *);
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index 921764c..1bcdb7b 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -46,7 +46,7 @@
 static int generic_NCR5380_abort(Scsi_Cmnd *);
 static int generic_NCR5380_detect(struct scsi_host_template *);
 static int generic_NCR5380_release_resources(struct Scsi_Host *);
-static int generic_NCR5380_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
+static int generic_NCR5380_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
 static int generic_NCR5380_bus_reset(Scsi_Cmnd *);
 static const char* generic_NCR5380_info(struct Scsi_Host *);
 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 98aad81..7636570 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -185,7 +185,7 @@ static long gdth_unlocked_ioctl(struct file *filep, unsigned int cmd,
 			        unsigned long arg);
 
 static void gdth_flush(gdth_ha_str *ha);
-static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
+static int gdth_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
 				struct gdth_cmndinfo *cmndinfo);
 static void gdth_scsi_done(struct scsi_cmnd *scp);
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e50039b..3759d11 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -143,8 +143,7 @@ static void fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 	void *buff, size_t size, u8 page_code, unsigned char *scsi3addr,
 	int cmd_type);
 
-static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
-		void (*done)(struct scsi_cmnd *));
+static int hpsa_scsi_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static void hpsa_scan_start(struct Scsi_Host *);
 static int hpsa_scan_finished(struct Scsi_Host *sh,
 	unsigned long elapsed_time);
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index bc90b40..67fc8ff 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -39,7 +39,7 @@
 #include <scsi/scsi_host.h>
 
 /* Common forward declarations for all Linux-versions: */
-static int ibmmca_queuecommand (Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
+static int ibmmca_queuecommand (struct Scsi_Host *, struct scsi_cmnd *);
 static int ibmmca_abort (Scsi_Cmnd *);
 static int ibmmca_host_reset (Scsi_Cmnd *);
 static int ibmmca_biosparam (struct scsi_device *, struct block_device *, sector_t, int *);
diff --git a/drivers/scsi/in2000.h b/drivers/scsi/in2000.h
index 0fb8b06..5821e1f 100644
--- a/drivers/scsi/in2000.h
+++ b/drivers/scsi/in2000.h
@@ -396,7 +396,7 @@ struct IN2000_hostdata {
 							   flags)
 
 static int in2000_detect(struct scsi_host_template *) in2000__INIT;
-static int in2000_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
+static int in2000_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int in2000_abort(Scsi_Cmnd *);
 static void in2000_setup(char *, int *) in2000__INIT;
 static int in2000_biosparam(struct scsi_device *, struct block_device *,
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index f76c819..b2511ac 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -232,7 +232,7 @@ static int ips_detect(struct scsi_host_template *);
 static int ips_release(struct Scsi_Host *);
 static int ips_eh_abort(struct scsi_cmnd *);
 static int ips_eh_reset(struct scsi_cmnd *);
-static int ips_queue(struct scsi_cmnd *, void (*)(struct scsi_cmnd *));
+static int ips_queue(struct Scsi_Host *, struct scsi_cmnd *);
 static const char *ips_info(struct Scsi_Host *);
 static irqreturn_t do_ipsintr(int, void *);
 static int ips_hainit(ips_ha_t *);
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index ca7dc61..9aa0485 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4458,7 +4458,7 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 
 	scb->idx = CMDID_INT_CMDS;
 
-	megaraid_queue(scmd, mega_internal_done);
+	megaraid_queue_lck(scmd, mega_internal_done);
 
 	wait_for_completion(&adapter->int_waitq);
 
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 2b4a048..f564474 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -987,7 +987,7 @@ static int mega_query_adapter(adapter_t *);
 static int issue_scb(adapter_t *, scb_t *);
 static int mega_setup_mailbox(adapter_t *);
 
-static int megaraid_queue (Scsi_Cmnd *, void (*)(Scsi_Cmnd *));
+static int megaraid_queue (struct Scsi_Host *, struct scsi_cmnd *);
 static scb_t * mega_build_cmd(adapter_t *, Scsi_Cmnd *, int *);
 static void __mega_runpendq(adapter_t *);
 static int issue_scb_block(adapter_t *, u_char *);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index dea0860..5708cb2 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -113,8 +113,7 @@ static int megaraid_mbox_fire_sync_cmd(adapter_t *);
 static void megaraid_mbox_display_scb(adapter_t *, scb_t *);
 static void megaraid_mbox_setup_device_map(adapter_t *);
 
-static int megaraid_queue_command(struct scsi_cmnd *,
-		void (*)(struct scsi_cmnd *));
+static int megaraid_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
 static scb_t *megaraid_mbox_build_cmd(adapter_t *, struct scsi_cmnd *, int *);
 static void megaraid_mbox_runpendq(adapter_t *, scb_t *);
 static void megaraid_mbox_prepare_pthru(adapter_t *, scb_t *,
diff --git a/drivers/scsi/pas16.h b/drivers/scsi/pas16.h
index 8dc5b1a..a04281c 100644
--- a/drivers/scsi/pas16.h
+++ b/drivers/scsi/pas16.h
@@ -118,7 +118,7 @@ static int pas16_abort(Scsi_Cmnd *);
 static int pas16_biosparam(struct scsi_device *, struct block_device *,
 			   sector_t, int*);
 static int pas16_detect(struct scsi_host_template *);
-static int pas16_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
+static int pas16_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
 static int pas16_bus_reset(Scsi_Cmnd *);
 
 #ifndef CMD_PER_LUN
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index d68c9f2..7fc9a9d 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -299,8 +299,7 @@ static        int        nsp_proc_info  (
 					 off_t   offset,
 					 int     length,
 					 int     inout);
-static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
-			    void (* done)(struct scsi_cmnd *SCpnt));
+static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);
 
 /* Error handler */
 /*static int nsp_eh_abort       (struct scsi_cmnd *SCpnt);*/
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 35f3f5d..1644eab 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -179,8 +179,7 @@ static int qla2xxx_slave_alloc(struct scsi_device *);
 static int qla2xxx_scan_finished(struct Scsi_Host *, unsigned long time);
 static void qla2xxx_scan_start(struct Scsi_Host *);
 static void qla2xxx_slave_destroy(struct scsi_device *);
-static int qla2xxx_queuecommand(struct scsi_cmnd *cmd,
-		void (*fn)(struct scsi_cmnd *));
+static int qla2xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_target_reset(struct scsi_cmnd *);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4a3223d..0d48fb4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -79,8 +79,7 @@ static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
 /*
  * SCSI host template entry points
  */
-static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
-				void (*done) (struct scsi_cmnd *));
+static int qla4xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
diff --git a/drivers/scsi/qlogicfas408.h b/drivers/scsi/qlogicfas408.h
index 2606264..2f6c0a1 100644
--- a/drivers/scsi/qlogicfas408.h
+++ b/drivers/scsi/qlogicfas408.h
@@ -103,8 +103,7 @@ struct qlogicfas408_priv {
 #define get_priv_by_host(x) (struct qlogicfas408_priv *)&((x)->hostdata[0])
 
 irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id);
-int qlogicfas408_queuecommand(struct scsi_cmnd * cmd,
-			      void (*done) (struct scsi_cmnd *));
+int qlogicfas408_queuecommand(struct Scsi_Host *h, struct scsi_cmnd * cmd);
 int qlogicfas408_biosparam(struct scsi_device * disk,
 			   struct block_device *dev,
 			   sector_t capacity, int ip[]);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e3d0629..2aeb2e9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -742,7 +742,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		scsi_done(cmd);
 	} else {
 		trace_scsi_dispatch_cmd_start(cmd);
-		rtn = host->hostt->queuecommand(cmd, scsi_done);
+		cmd->scsi_done = scsi_done;
+		rtn = host->hostt->queuecommand(host, cmd);
 	}
 
 	if (rtn) {
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d0e765f..433e699 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -788,7 +788,8 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	shost->eh_action = &done;
 
 	scsi_log_send(scmd);
-	shost->hostt->queuecommand(scmd, scsi_eh_done);
+	scmd->scsi_done = scsi_eh_done;
+	shost->hostt->queuecommand(shost, scmd);
 
 	timeleft = wait_for_completion_timeout(&done, timeout);
 
diff --git a/drivers/scsi/sun3_scsi.h b/drivers/scsi/sun3_scsi.h
index b29a9d6..bcefd84 100644
--- a/drivers/scsi/sun3_scsi.h
+++ b/drivers/scsi/sun3_scsi.h
@@ -51,8 +51,7 @@ static int sun3scsi_abort(struct scsi_cmnd *);
 static int sun3scsi_detect (struct scsi_host_template *);
 static const char *sun3scsi_info (struct Scsi_Host *);
 static int sun3scsi_bus_reset(struct scsi_cmnd *);
-static int sun3scsi_queue_command(struct scsi_cmnd *,
-				  void (*done)(struct scsi_cmnd *));
+static int sun3scsi_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
 static int sun3scsi_release (struct Scsi_Host *);
 
 #ifndef CMD_PER_LUN
diff --git a/drivers/scsi/sym53c416.h b/drivers/scsi/sym53c416.h
index 77860d0..387de5d 100644
--- a/drivers/scsi/sym53c416.h
+++ b/drivers/scsi/sym53c416.h
@@ -25,7 +25,7 @@
 static int sym53c416_detect(struct scsi_host_template *);
 static const char *sym53c416_info(struct Scsi_Host *);
 static int sym53c416_release(struct Scsi_Host *);
-static int sym53c416_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
+static int sym53c416_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int sym53c416_host_reset(Scsi_Cmnd *);
 static int sym53c416_bios_param(struct scsi_device *, struct block_device *,
 		sector_t, int *);
diff --git a/drivers/scsi/t128.h b/drivers/scsi/t128.h
index 76a069b..ada1115 100644
--- a/drivers/scsi/t128.h
+++ b/drivers/scsi/t128.h
@@ -96,8 +96,7 @@ static int t128_abort(struct scsi_cmnd *);
 static int t128_biosparam(struct scsi_device *, struct block_device *,
 			  sector_t, int*);
 static int t128_detect(struct scsi_host_template *);
-static int t128_queue_command(struct scsi_cmnd *,
-			      void (*done)(struct scsi_cmnd *));
+static int t128_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
 static int t128_bus_reset(struct scsi_cmnd *);
 
 #ifndef CMD_PER_LUN
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 968dc5ae..edfc5da 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -433,7 +433,7 @@
 
 static int u14_34f_detect(struct scsi_host_template *);
 static int u14_34f_release(struct Scsi_Host *);
-static int u14_34f_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int u14_34f_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int u14_34f_eh_abort(struct scsi_cmnd *);
 static int u14_34f_eh_host_reset(struct scsi_cmnd *);
 static int u14_34f_bios_param(struct scsi_device *, struct block_device *,
diff --git a/drivers/scsi/ultrastor.h b/drivers/scsi/ultrastor.h
index a692905..165c18b 100644
--- a/drivers/scsi/ultrastor.h
+++ b/drivers/scsi/ultrastor.h
@@ -15,8 +15,7 @@
 
 static int ultrastor_detect(struct scsi_host_template *);
 static const char *ultrastor_info(struct Scsi_Host *shpnt);
-static int ultrastor_queuecommand(struct scsi_cmnd *,
-				void (*done)(struct scsi_cmnd *));
+static int ultrastor_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int ultrastor_abort(struct scsi_cmnd *);
 static int ultrastor_host_reset(struct scsi_cmnd *);
 static int ultrastor_biosparam(struct scsi_device *, struct block_device *,
diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
index 1ed5f3b..3b463d7 100644
--- a/drivers/scsi/wd33c93.h
+++ b/drivers/scsi/wd33c93.h
@@ -343,8 +343,7 @@ struct WD33C93_hostdata {
 void wd33c93_init (struct Scsi_Host *instance, const wd33c93_regs regs,
          dma_setup_t setup, dma_stop_t stop, int clock_freq);
 int wd33c93_abort (struct scsi_cmnd *cmd);
-int wd33c93_queuecommand (struct scsi_cmnd *cmd,
-		void (*done)(struct scsi_cmnd *));
+int wd33c93_queuecommand (struct Scsi_Host *h, struct scsi_cmnd *cmd);
 void wd33c93_intr (struct Scsi_Host *instance);
 int wd33c93_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 int wd33c93_host_reset (struct scsi_cmnd *);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 15b77b8..d947b12 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -986,7 +986,7 @@ extern void ata_host_init(struct ata_host *, struct device *,
 			  unsigned long, struct ata_port_operations *);
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
-extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
+extern int ata_scsi_queuecmd(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
 			    int cmd, void __user *arg);
 extern void ata_sas_port_destroy(struct ata_port *);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index f986ab7..5c4c167 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1006,8 +1006,7 @@ void fc_fcp_destroy(struct fc_lport *);
 /*
  * SCSI INTERACTION LAYER
  *****************************/
-int fc_queuecommand(struct scsi_cmnd *,
-		    void (*done)(struct scsi_cmnd *));
+int fc_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fc_eh_abort(struct scsi_cmnd *);
 int fc_eh_device_reset(struct scsi_cmnd *);
 int fc_eh_host_reset(struct scsi_cmnd *);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index ae5196a..b81d969 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -341,8 +341,7 @@ extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
 extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
-extern int iscsi_queuecommand(struct scsi_cmnd *sc,
-			      void (*done)(struct scsi_cmnd *));
+extern int iscsi_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *sc);
 
 /*
  * iSCSI host helpers.
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3dec194..90ce527 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -621,8 +621,7 @@ int sas_set_phy_speed(struct sas_phy *phy,
 int sas_phy_enable(struct sas_phy *phy, int enabled);
 int sas_phy_reset(struct sas_phy *phy, int hard_reset);
 int sas_queue_up(struct sas_task *task);
-extern int sas_queuecommand(struct scsi_cmnd *,
-		     void (*scsi_done)(struct scsi_cmnd *));
+extern int sas_queuecommand(struct Scsi_Host * ,struct scsi_cmnd *);
 extern int sas_target_alloc(struct scsi_target *);
 extern int sas_slave_alloc(struct scsi_device *);
 extern int sas_slave_configure(struct scsi_device *);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index cea74ba..e7e3858 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -127,8 +127,7 @@ struct scsi_host_template {
 	 *
 	 * STATUS: REQUIRED
 	 */
-	int (* queuecommand)(struct scsi_cmnd *,
-			     void (*done)(struct scsi_cmnd *));
+	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
 
 	/*
 	 * The transfer functions are used to queue a scsi command to
@@ -511,15 +510,13 @@ struct scsi_host_template {
  *
  */
 #define DEF_SCSI_QCMD(func_name) \
-	int func_name(struct scsi_cmnd *cmd,				\
-		      void (*done)(struct scsi_cmnd *))			\
+	int func_name(struct Scsi_Host *shost, struct scsi_cmnd *cmd)	\
 	{								\
 		unsigned long irq_flags;				\
 		int rc;							\
-		struct Scsi_Host *shost = cmd->device->host;		\
 		spin_lock_irqsave(shost->host_lock, irq_flags);		\
 		scsi_cmd_get_serial(shost, cmd);			\
-		rc = func_name##_lck (cmd, done);			\
+		rc = func_name##_lck (cmd, cmd->scsi_done);			\
 		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
 		return rc;						\
 	}


