From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: use set_host_byte instead of open-coding it
Date: Tue, 10 Oct 2017 17:29:39 +0200
Message-ID: <20171010152939.21353-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

Call set_host_byte() instead of open-coding it.

Converted using this simple Coccinelle spatch

<SmPL>
@@
local idexpression struct scsi_cmnd *c;
expression E1;
@@

- c->result = E1 << 16;
+ set_host_byte(c, E1);
</SmPL>

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
Martin, this path should be applied on top of
http://lkml.kernel.org/r/20171009113319.9505-1-jthumshirn@suse.de
the above is a bug fix and possibly stable material.
---
 drivers/ata/libata-scsi.c                       |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c             |  2 +-
 drivers/message/fusion/mptfc.c                  |  4 +-
 drivers/message/fusion/mptsas.c                 |  2 +-
 drivers/message/fusion/mptscsih.c               | 53 +++++++++++-----------
 drivers/message/fusion/mptspi.c                 |  4 +-
 drivers/scsi/53c700.c                           |  2 +-
 drivers/scsi/BusLogic.c                         | 12 ++---
 drivers/scsi/NCR5380.c                          | 16 +++----
 drivers/scsi/aacraid/aachba.c                   | 12 ++---
 drivers/scsi/aacraid/linit.c                    |  4 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c              |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c              |  2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                |  2 +-
 drivers/scsi/arm/acornscsi.c                    |  4 +-
 drivers/scsi/bfa/bfad_im.c                      |  4 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |  6 +--
 drivers/scsi/dc395x.c                           |  8 ++--
 drivers/scsi/eata.c                             |  4 +-
 drivers/scsi/eata_pio.c                         |  4 +-
 drivers/scsi/esas2r/esas2r_main.c               |  8 ++--
 drivers/scsi/esp_scsi.c                         |  6 +--
 drivers/scsi/fnic/fnic_scsi.c                   | 12 ++---
 drivers/scsi/hpsa.c                             | 46 ++++++++++----------
 drivers/scsi/hptiop.c                           |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                  |  2 +-
 drivers/scsi/imm.c                              |  2 +-
 drivers/scsi/ips.c                              | 16 +++----
 drivers/scsi/libfc/fc_fcp.c                     | 10 ++---
 drivers/scsi/libiscsi.c                         | 22 +++++-----
 drivers/scsi/libsas/sas_scsi_host.c             |  6 +--
 drivers/scsi/megaraid/megaraid_sas_base.c       | 12 ++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c     | 12 ++---
 drivers/scsi/mesh.c                             |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            | 58 ++++++++++++-------------
 drivers/scsi/nsp32.c                            | 32 +++++++-------
 drivers/scsi/pcmcia/nsp_cs.c                    | 10 ++---
 drivers/scsi/pcmcia/sym53c500_cs.c              | 10 ++---
 drivers/scsi/ppa.c                              |  4 +-
 drivers/scsi/ps3rom.c                           |  4 +-
 drivers/scsi/qedf/qedf_io.c                     |  8 ++--
 drivers/scsi/qla2xxx/qla_iocb.c                 |  4 +-
 drivers/scsi/qla2xxx/qla_isr.c                  |  2 +-
 drivers/scsi/qla2xxx/qla_os.c                   | 16 +++----
 drivers/scsi/qla4xxx/ql4_isr.c                  | 22 +++++-----
 drivers/scsi/qla4xxx/ql4_os.c                   |  6 +--
 drivers/scsi/qlogicfas408.c                     |  2 +-
 drivers/scsi/qlogicpti.c                        |  2 +-
 drivers/scsi/scsi_lib.c                         |  4 +-
 drivers/scsi/snic/snic_scsi.c                   |  2 +-
 drivers/scsi/stex.c                             |  2 +-
 drivers/scsi/storvsc_drv.c                      |  2 +-
 drivers/scsi/wd33c93.c                          |  8 ++--
 drivers/scsi/wd719x.c                           |  2 +-
 drivers/scsi/xen-scsifront.c                    |  2 +-
 drivers/staging/rts5208/rtsx.c                  |  2 +-
 drivers/staging/rts5208/rtsx_transport.c        |  4 +-
 drivers/staging/unisys/visorhba/visorhba_main.c |  8 ++--
 drivers/usb/image/microtek.c                    |  4 +-
 drivers/usb/storage/isd200.c                    | 12 ++---
 drivers/usb/storage/scsiglue.c                  |  2 +-
 drivers/usb/storage/transport.c                 | 14 +++---
 drivers/usb/storage/uas.c                       | 12 ++---
 63 files changed, 285 insertions(+), 284 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 44ba292f2cd7..37253d5f1502 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4331,7 +4331,7 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
  bad_cdb_len:
 	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
 		scmd->cmd_len, scsi_op, dev->cdb_len);
-	scmd->result = DID_ERROR << 16;
+	set_host_byte(scmd, DID_ERROR);
 	scmd->scsi_done(scmd);
 	return 0;
 }
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fa5ccdb3bb2a..c775aa8fcd67 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2644,7 +2644,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	else
 		ret = FAILED;
 	srp_free_req(ch, req, scmnd, 0);
-	scmnd->result = DID_ABORT << 16;
+	set_host_byte(scmnd, DID_ABORT);
 	scmnd->scsi_done(scmnd);
 
 	return ret;
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 6d461ca97150..d8b27127f6b9 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -649,7 +649,7 @@ mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
 
 	if (!vdevice || !vdevice->vtarget) {
-		SCpnt->result = DID_NO_CONNECT << 16;
+		set_host_byte(SCpnt, DID_NO_CONNECT);
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
@@ -664,7 +664,7 @@ mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 	/* dd_data is null until finished adding target */
 	ri = *((struct mptfc_rport_info **)rport->dd_data);
 	if (unlikely(!ri)) {
-		SCpnt->result = DID_IMM_RETRY << 16;
+		set_host_byte(SCpnt, DID_IMM_RETRY);
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 345f6035599e..1915eeabf3d7 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1901,7 +1901,7 @@ mptsas_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
 
 	if (!vdevice || !vdevice->vtarget || vdevice->vtarget->deleted) {
-		SCpnt->result = DID_NO_CONNECT << 16;
+		set_host_byte(SCpnt, DID_NO_CONNECT);
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 6ba07c7feb92..7e307ba434bc 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -634,13 +634,13 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 
 		if (!vdevice || !vdevice->vtarget ||
 		    vdevice->vtarget->deleted) {
-			sc->result = DID_NO_CONNECT << 16;
+			set_host_byte(sc, DID_NO_CONNECT);
 			goto out;
 		}
 	}
 
 	sc->host_scribble = NULL;
-	sc->result = DID_OK << 16;		/* Set default reply as OK */
+	set_host_byte(sc, DID_OK);		/* Set default reply as OK */
 	pScsiReq = (SCSIIORequest_t *) mf;
 	pScsiReply = (SCSIIOReply_t *) mr;
 
@@ -712,16 +712,16 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 
 		case MPI_IOCSTATUS_SCSI_INVALID_BUS:		/* 0x0041 */
 		case MPI_IOCSTATUS_SCSI_INVALID_TARGETID:	/* 0x0042 */
-			sc->result = DID_BAD_TARGET << 16;
+			set_host_byte(sc, DID_BAD_TARGET);
 			break;
 
 		case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE:	/* 0x0043 */
 			/* Spoof to SCSI Selection Timeout! */
 			if (ioc->bus_type != FC)
-				sc->result = DID_NO_CONNECT << 16;
+				set_host_byte(sc, DID_NO_CONNECT);
 			/* else fibre, just stall until rescan event */
 			else
-				sc->result = DID_REQUEUE << 16;
+				set_host_byte(sc, DID_REQUEUE);
 
 			if (hd->sel_timeout[pScsiReq->TargetID] < 0xFFFF)
 				hd->sel_timeout[pScsiReq->TargetID]++;
@@ -779,7 +779,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 				 * DID_RESET to permit retry of the command,
 				 * just not an infinite number of them
 				 */
-				sc->result = DID_ERROR << 16;
+				set_host_byte(sc, DID_ERROR);
 				break;
 			}
 
@@ -791,20 +791,20 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			/* Linux handles an unsolicited DID_RESET better
 			 * than an unsolicited DID_ABORT.
 			 */
-			sc->result = DID_RESET << 16;
+			set_host_byte(sc, DID_RESET);
 			break;
 
 		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
 			if (ioc->bus_type == FC)
-				sc->result = DID_ERROR << 16;
+				set_host_byte(sc, DID_ERROR);
 			else
-				sc->result = DID_RESET << 16;
+				set_host_byte(sc, DID_RESET);
 			break;
 
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
 			scsi_set_resid(sc, scsi_bufflen(sc) - xfer_cnt);
 			if((xfer_cnt==0)||(sc->underflow > xfer_cnt))
-				sc->result=DID_SOFT_ERROR << 16;
+				set_host_byte(sc, DID_SOFT_ERROR);
 			else /* Sufficient data transfer occurred */
 				sc->result = (DID_OK << 16) | scsi_status;
 			dreplyprintk(ioc, printk(MYIOC_s_DEBUG_FMT
@@ -837,8 +837,8 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 					    pScsiReq->CDB[0] == VERIFY_16) {
 						if (scsi_bufflen(sc) !=
 							xfer_cnt) {
-							sc->result =
-							DID_SOFT_ERROR << 16;
+							set_host_byte(sc,
+								      DID_SOFT_ERROR);
 						    printk(KERN_WARNING "Errata"
 						    "on LSI53C1030 occurred."
 						    "sc->req_bufflen=0x%02x,"
@@ -853,16 +853,17 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 					if (scsi_status == SAM_STAT_BUSY)
 						sc->result = SAM_STAT_BUSY;
 					else
-						sc->result = DID_SOFT_ERROR << 16;
+						set_host_byte(sc,
+							      DID_SOFT_ERROR);
 				}
 				if (scsi_state & (MPI_SCSI_STATE_AUTOSENSE_FAILED | MPI_SCSI_STATE_NO_SCSI_STATUS)) {
 					/* What to do?
 				 	*/
-					sc->result = DID_SOFT_ERROR << 16;
+					set_host_byte(sc, DID_SOFT_ERROR);
 				}
 				else if (scsi_state & MPI_SCSI_STATE_TERMINATED) {
 					/*  Not real sure here either...  */
-					sc->result = DID_RESET << 16;
+					set_host_byte(sc, DID_RESET);
 				}
 			}
 
@@ -955,11 +956,11 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 				/*
 				 * What to do?
 				 */
-				sc->result = DID_SOFT_ERROR << 16;
+				set_host_byte(sc, DID_SOFT_ERROR);
 			}
 			else if (scsi_state & MPI_SCSI_STATE_TERMINATED) {
 				/*  Not real sure here either...  */
-				sc->result = DID_RESET << 16;
+				set_host_byte(sc, DID_RESET);
 			}
 			else if (scsi_state & MPI_SCSI_STATE_QUEUE_TAG_REJECTED) {
 				/* Device Inq. data indicates that it supports
@@ -979,7 +980,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			break;
 
 		case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR:		/* 0x0047 */
-			sc->result = DID_SOFT_ERROR << 16;
+			set_host_byte(sc, DID_SOFT_ERROR);
 			break;
 
 		case MPI_IOCSTATUS_INVALID_FUNCTION:		/* 0x0001 */
@@ -994,7 +995,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			/*
 			 * What to do?
 			 */
-			sc->result = DID_SOFT_ERROR << 16;
+			set_host_byte(sc, DID_SOFT_ERROR);
 			break;
 
 		}	/* switch(status) */
@@ -1049,7 +1050,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 		if ((unsigned char *)mf != sc->host_scribble)
 			continue;
 		scsi_dma_unmap(sc);
-		sc->result = DID_RESET << 16;
+		set_host_byte(sc, DID_RESET);
 		sc->host_scribble = NULL;
 		dtmprintk(ioc, sdev_printk(KERN_INFO, sc->device, MYIOC_s_FMT
 		    "completing cmds: fw_channel %d, fw_id %d, sc=%p, mf = %p, "
@@ -1112,7 +1113,7 @@ mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
 			mpt_free_msg_frame(ioc, (MPT_FRAME_HDR *)mf);
 			scsi_dma_unmap(sc);
 			sc->host_scribble = NULL;
-			sc->result = DID_NO_CONNECT << 16;
+			set_host_byte(sc, DID_NO_CONNECT);
 			dtmprintk(ioc, sdev_printk(KERN_INFO, sc->device,
 			   MYIOC_s_FMT "completing cmds: fw_channel %d, "
 			   "fw_id %d, sc=%p, mf = %p, idx=%x\n", ioc->name,
@@ -1690,7 +1691,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = shost_priv(SCpnt->device->host)) == NULL) {
-		SCpnt->result = DID_RESET << 16;
+		set_host_byte(SCpnt, DID_RESET);
 		SCpnt->scsi_done(SCpnt);
 		printk(KERN_ERR MYNAM ": task abort: "
 		    "can't locate host! (sc=%p)\n", SCpnt);
@@ -1707,7 +1708,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "task abort: device has been deleted (sc=%p)\n",
 		    ioc->name, SCpnt));
-		SCpnt->result = DID_NO_CONNECT << 16;
+		set_host_byte(SCpnt, DID_NO_CONNECT);
 		SCpnt->scsi_done(SCpnt);
 		retval = SUCCESS;
 		goto out;
@@ -1719,7 +1720,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "task abort: hidden raid component (sc=%p)\n",
 		    ioc->name, SCpnt));
-		SCpnt->result = DID_RESET << 16;
+		set_host_byte(SCpnt, DID_RESET);
 		retval = FAILED;
 		goto out;
 	}
@@ -1730,7 +1731,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "task abort: raid volume (sc=%p)\n",
 		    ioc->name, SCpnt));
-		SCpnt->result = DID_RESET << 16;
+		set_host_byte(SCpnt, DID_RESET);
 		retval = FAILED;
 		goto out;
 	}
@@ -1741,7 +1742,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		/* Cmd not found in ScsiLookup.
 		 * Do OS callback.
 		 */
-		SCpnt->result = DID_RESET << 16;
+		set_host_byte(SCpnt, DID_RESET);
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: "
 		   "Command not in the active list! (sc=%p)\n", ioc->name,
 		   SCpnt));
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 9a336a161d9f..d97f9c50d1fe 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -786,14 +786,14 @@ mptspi_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	if (!vdevice || !vdevice->vtarget) {
-		SCpnt->result = DID_NO_CONNECT << 16;
+		set_host_byte(SCpnt, DID_NO_CONNECT);
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
 
 	if (SCpnt->device->channel == 1 &&
 		mptscsih_is_phys_disk(ioc, 0, SCpnt->device->id) == 0) {
-		SCpnt->result = DID_NO_CONNECT << 16;
+		set_host_byte(SCpnt, DID_NO_CONNECT);
 		SCpnt->scsi_done(SCpnt);
 		return 0;
 	}
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 6be77b3aa8a5..2fa357306a57 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1565,7 +1565,7 @@ NCR_700_intr(int irq, void *dev_id)
 				 * command again otherwise we'll
 				 * deadlock on the
 				 * hostdata->state_lock */
-				SCp->result = DID_RESET << 16;
+				set_host_byte(SCp, DID_RESET);
 				SCp->scsi_done(SCp);
 			}
 			mdelay(25);
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 35380a58d3f0..ea3a45d48871 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2795,7 +2795,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 					command = ccb->command;
 					blogic_dealloc_ccb(ccb, 1);
 					adapter->active_cmds[tgt_id]--;
-					command->result = DID_RESET << 16;
+					set_host_byte(command, DID_RESET);
 					command->scsi_done(command);
 				}
 			adapter->bdr_pend[tgt_id] = NULL;
@@ -2816,13 +2816,13 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 				    .cmds_complete++;
 				adapter->tgt_flags[ccb->tgt_id]
 				    .cmd_good = true;
-				command->result = DID_OK << 16;
+				set_host_byte(command, DID_OK);
 				break;
 			case BLOGIC_CMD_ABORT_BY_HOST:
 				blogic_warn("CCB #%ld to Target %d Aborted\n",
 					adapter, ccb->serial, ccb->tgt_id);
 				blogic_inc_count(&adapter->tgt_stats[ccb->tgt_id].aborts_done);
-				command->result = DID_ABORT << 16;
+				set_host_byte(command, DID_ABORT);
 				break;
 			case BLOGIC_CMD_COMPLETE_ERROR:
 				command->result = blogic_resultcode(adapter,
@@ -3045,7 +3045,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 	   occurred.
 	 */
 	if (cdb[0] == REQUEST_SENSE && command->sense_buffer[0] != 0) {
-		command->result = DID_OK << 16;
+		set_host_byte(command, DID_OK);
 		comp_cb(command);
 		return 0;
 	}
@@ -3063,7 +3063,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 		spin_lock_irq(adapter->scsi_host->host_lock);
 		ccb = blogic_alloc_ccb(adapter);
 		if (ccb == NULL) {
-			command->result = DID_ERROR << 16;
+			set_host_byte(command, DID_ERROR);
 			comp_cb(command);
 			return 0;
 		}
@@ -3214,7 +3214,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 						ccb)) {
 				blogic_warn("Still unable to write Outgoing Mailbox - " "Host Adapter Dead?\n", adapter);
 				blogic_dealloc_ccb(ccb, 1);
-				command->result = DID_ERROR << 16;
+				set_host_byte(command, DID_ERROR);
 				command->scsi_done(command);
 			}
 		}
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 8a0812221d72..14c67e5d46aa 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1117,7 +1117,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		/* Can't touch cmd if it has been reclaimed by the scsi ML */
 		if (hostdata->selecting) {
-			cmd->result = DID_BAD_TARGET << 16;
+			set_host_byte(cmd, DID_BAD_TARGET);
 			complete_cmd(instance, cmd);
 			dsprintk(NDEBUG_SELECTION, instance, "target did not respond within 250ms\n");
 			cmd = NULL;
@@ -1167,7 +1167,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
 	if (len) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance, "IDENTIFY message transfer failed\n");
 		cmd = NULL;
@@ -1707,7 +1707,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				shost_printk(KERN_DEBUG, instance, "NDEBUG_NO_DATAOUT set, attempted DATAOUT aborted\n");
 				sink = 1;
 				do_abort(instance);
-				cmd->result = DID_ERROR << 16;
+				set_host_byte(cmd, DID_ERROR);
 				complete_cmd(instance, cmd);
 				hostdata->connected = NULL;
 				return;
@@ -1756,7 +1756,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						cmd->device->borken = 1;
 						sink = 1;
 						do_abort(instance);
-						cmd->result = DID_ERROR << 16;
+						set_host_byte(cmd, DID_ERROR);
 						/* XXX - need to source or sink data here, as appropriate */
 					}
 				} else {
@@ -1956,7 +1956,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (msgout == ABORT) {
 					hostdata->connected = NULL;
-					cmd->result = DID_ERROR << 16;
+					set_host_byte(cmd, DID_ERROR);
 					complete_cmd(instance, cmd);
 					maybe_release_dma_irq(instance);
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
@@ -2233,7 +2233,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 	if (list_del_cmd(&hostdata->unissued, cmd)) {
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: removed %p from issue queue\n", cmd);
-		cmd->result = DID_ABORT << 16;
+		set_host_byte(cmd, DID_ABORT);
 		cmd->scsi_done(cmd); /* No tag or busy flag to worry about */
 		goto out;
 	}
@@ -2242,7 +2242,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: cmd %p == selecting\n", cmd);
 		hostdata->selecting = NULL;
-		cmd->result = DID_ABORT << 16;
+		set_host_byte(cmd, DID_ABORT);
 		complete_cmd(instance, cmd);
 		goto out;
 	}
@@ -2332,7 +2332,7 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
 	 */
 
 	if (list_del_cmd(&hostdata->unissued, cmd)) {
-		cmd->result = DID_RESET << 16;
+		set_host_byte(cmd, DID_RESET);
 		cmd->scsi_done(cmd);
 	}
 
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index af3e4d3f9735..56259025d49d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -627,7 +627,7 @@ static int aac_probe_container_callback2(struct scsi_cmnd * scsicmd)
 	if ((fsa_dev_ptr[scmd_id(scsicmd)].valid & 1))
 		return aac_scsi_cmd(scsicmd);
 
-	scsicmd->result = DID_NO_CONNECT << 16;
+	set_host_byte(scsicmd, DID_NO_CONNECT);
 	scsicmd->scsi_done(scsicmd);
 	return 0;
 }
@@ -2709,7 +2709,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		if (scmd_channel(scsicmd) == CONTAINER_CHANNEL) {
 			if((cid >= dev->maximum_num_containers) ||
 					(scsicmd->device->lun != 0)) {
-				scsicmd->result = DID_NO_CONNECT << 16;
+				set_host_byte(scsicmd, DID_NO_CONNECT);
 				goto scsi_done_ret;
 			}
 
@@ -2743,7 +2743,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				(dev->hba_map[bus][cid].expose
 						== AAC_HIDE_DISK)){
 				if (scsicmd->cmnd[0] == INQUIRY) {
-					scsicmd->result = DID_NO_CONNECT << 16;
+					set_host_byte(scsicmd, DID_NO_CONNECT);
 					goto scsi_done_ret;
 				}
 			}
@@ -2760,7 +2760,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 					return -1;
 				return aac_send_srb_fib(scsicmd);
 			} else {
-				scsicmd->result = DID_NO_CONNECT << 16;
+				set_host_byte(scsicmd, DID_NO_CONNECT);
 				goto scsi_done_ret;
 			}
 		}
@@ -3674,7 +3674,7 @@ static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	if (scmd_id(scsicmd) >= dev->maximum_num_physicals ||
 			scsicmd->device->lun > 7) {
-		scsicmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scsicmd, DID_NO_CONNECT);
 		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
@@ -3716,7 +3716,7 @@ static int aac_send_hba_fib(struct scsi_cmnd *scsicmd)
 	dev = shost_priv(scsicmd->device->host);
 	if (scmd_id(scsicmd) >= dev->maximum_num_physicals ||
 			scsicmd->device->lun > AAC_MAX_LUN - 1) {
-		scsicmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scsicmd, DID_NO_CONNECT);
 		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 62beb2596466..f0c0ff92dfd7 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1960,9 +1960,9 @@ static void aac_flush_ios(struct aac_dev *aac)
 			scsi_dma_unmap(cmd);
 
 			if (aac->handle_pci_error)
-				cmd->result = DID_NO_CONNECT << 16;
+				set_host_byte(cmd, DID_NO_CONNECT);
 			else
-				cmd->result = DID_RESET << 16;
+				set_host_byte(cmd, DID_RESET);
 
 			cmd->scsi_done(cmd);
 		}
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 2588b8f84ba0..c2781b17a037 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -582,7 +582,7 @@ ahd_linux_queue_lck(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
 	cmd->scsi_done = scsi_done;
-	cmd->result = CAM_REQ_INPROG << 16;
+	set_host_byte(cmd, CAM_REQ_INPROG);
 	rtn = ahd_linux_run_command(ahd, dev, cmd);
 
 	return rtn;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index acd687f4554e..60034fd8bbd3 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -530,7 +530,7 @@ ahc_linux_queue_lck(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd
 	ahc_lock(ahc, &flags);
 	if (ahc->platform_data->qfrozen == 0) {
 		cmd->scsi_done = scsi_done;
-		cmd->result = CAM_REQ_INPROG << 16;
+		set_host_byte(cmd, CAM_REQ_INPROG);
 		rtn = ahc_linux_run_command(ahc, dev, cmd);
 	}
 	ahc_unlock(ahc, &flags);
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index af032c46ec0e..20cf2372c15f 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1054,7 +1054,7 @@ static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 
 	struct scsi_cmnd *pcmd = ccb->pcmd;
 	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
-	pcmd->result = DID_OK << 16;
+	set_host_byte(pcmd, DID_OK);
 	if (sensebuffer) {
 		int sense_data_length =
 			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 421fe869a11e..8650e85805fd 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2483,7 +2483,7 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
     if (acornscsi_cmdtype(SCpnt->cmnd[0]) == CMD_WRITE && (NO_WRITE & (1 << SCpnt->device->id))) {
 	printk(KERN_CRIT "scsi%d.%c: WRITE attempted with NO_WRITE flag set\n",
 	    host->host->host_no, '0' + SCpnt->device->id);
-	SCpnt->result = DID_NO_CONNECT << 16;
+	set_host_byte(SCpnt, DID_NO_CONNECT);
 	done(SCpnt);
 	return 0;
     }
@@ -2505,7 +2505,7 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
 	unsigned long flags;
 
 	if (!queue_add_cmd_ordered(&host->queues.issue, SCpnt)) {
-	    SCpnt->result = DID_ERROR << 16;
+	    set_host_byte(SCpnt, DID_ERROR);
 	    done(SCpnt);
 	    return 0;
 	}
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 24e657a4ec80..d22b9e2b1904 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -1233,9 +1233,9 @@ bfad_im_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd
 
 	if (bfad->bfad_flags & BFAD_EEH_BUSY) {
 		if (bfad->bfad_flags & BFAD_EEH_PCI_CHANNEL_IO_PERM_FAILURE)
-			cmnd->result = DID_NO_CONNECT << 16;
+			set_host_byte(cmnd, DID_NO_CONNECT);
 		else
-			cmnd->result = DID_REQUEUE << 16;
+			set_host_byte(cmnd, DID_REQUEUE);
 		done(cmnd);
 		return 0;
 	}
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 5b6153f23f01..289f94b667ba 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -198,7 +198,7 @@ static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_req, int err_code)
 		return;
 	}
 
-	sc_cmd->result = err_code << 16;
+	set_host_byte(sc_cmd, err_code);
 
 	BNX2FC_IO_DBG(io_req, "sc=%p, result=0x%x, retries=%d, allowed=%d\n",
 		sc_cmd, host_byte(sc_cmd->result), sc_cmd->retries,
@@ -1521,7 +1521,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 	case FC_GOOD:
 		if (io_req->cdb_status == 0) {
 			/* Good IO completion */
-			sc_cmd->result = DID_OK << 16;
+			set_host_byte(sc_cmd, DID_OK);
 		} else {
 			/* Transport status is good, SCSI status not good */
 			sc_cmd->result = (DID_OK << 16) | io_req->cdb_status;
@@ -1915,7 +1915,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 	case FC_GOOD:
 		if (io_req->cdb_status == 0) {
 			/* Good IO completion */
-			sc_cmd->result = DID_OK << 16;
+			set_host_byte(sc_cmd, DID_OK);
 		} else {
 			/* Transport status is good, SCSI status not good */
 			BNX2FC_IO_DBG(io_req, "scsi_cmpl: cdb_status = %d"
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 5ee7f44cf869..5ba7f4f72265 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1090,7 +1090,7 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct s
 		cmd, cmd->device->id, (u8)cmd->device->lun, cmd->cmnd[0]);
 
 	/* Assume BAD_TARGET; will be cleared later */
-	cmd->result = DID_BAD_TARGET << 16;
+	set_host_byte(cmd, DID_BAD_TARGET);
 
 	/* ignore invalid targets */
 	if (cmd->device->id >= acb->scsi_host->max_id ||
@@ -1385,7 +1385,7 @@ static int dc395x_eh_abort(struct scsi_cmnd *cmd)
 		free_tag(dcb, srb);
 		srb_free_insert(acb, srb);
 		dprintkl(KERN_DEBUG, "eh_abort: Command was waiting\n");
-		cmd->result = DID_ABORT << 16;
+		set_host_byte(cmd, DID_ABORT);
 		return SUCCESS;
 	}
 	srb = find_cmd(cmd, &dcb->srb_going_list);
@@ -3379,7 +3379,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		}
 
 		if (status == (CHECK_CONDITION << 1)) {
-			cmd->result = DID_BAD_TARGET << 16;
+			set_host_byte(cmd, DID_BAD_TARGET);
 			goto ckc_e;
 		}
 		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE2\n");
@@ -3422,7 +3422,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		} else if (status == SCSI_STAT_SEL_TIMEOUT) {
 			srb->adapter_status = H_SEL_TIMEOUT;
 			srb->target_status = 0;
-			cmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(cmd, DID_NO_CONNECT);
 		} else {
 			srb->adapter_status = 0;
 			SET_RES_DID(cmd->result, DID_ERROR);
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 6501c330d8c8..957efb0ea374 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1998,7 +1998,7 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 		if (ha->cp_stat[i] == IN_RESET) {
 			SCpnt = ha->cp[i].SCpnt;
 			unmap_dma(i, ha);
-			SCpnt->result = DID_RESET << 16;
+			set_host_byte(SCpnt, DID_RESET);
 			SCpnt->host_scribble = NULL;
 
 			/* This mailbox is still waiting for its interrupt */
@@ -2012,7 +2012,7 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 		else if (ha->cp_stat[i] == ABORTING) {
 			SCpnt = ha->cp[i].SCpnt;
 			unmap_dma(i, ha);
-			SCpnt->result = DID_RESET << 16;
+			set_host_byte(SCpnt, DID_RESET);
 			SCpnt->host_scribble = NULL;
 
 			/* This mailbox was never queued to the adapter */
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 4299fa485622..b9419291810d 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -378,7 +378,7 @@ static int eata_pio_queue_lck(struct scsi_cmnd *cmd,
 								 * are to transfer */
 
 	if (eata_pio_send_command(base, EATA_CMD_PIO_SEND_CP)) {
-		cmd->result = DID_BUS_BUSY << 16;
+		set_host_byte(cmd, DID_BUS_BUSY);
 		scmd_printk(KERN_NOTICE, cmd,
 			"eata_pio_queue pid 0x%p, HBA busy, "
 			"returning DID_BUS_BUSY, done.\n", cmd);
@@ -487,7 +487,7 @@ static int eata_pio_host_reset(struct scsi_cmnd *cmd)
 			continue;
 
 		sp = HD(cmd)->ccb[x].cmd;
-		sp->result = DID_RESET << 16;
+		set_host_byte(sp, DID_RESET);
 
 		/* This mailbox is terminated */
 		printk(KERN_WARNING "eata_pio_reset: reset ccb %d.\n", x);
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 81f226be3e3b..e3901120f3d1 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -883,10 +883,10 @@ int esas2r_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	unsigned bufflen;
 
 	/* Assume success, if it fails we will fix the result later. */
-	cmd->result = DID_OK << 16;
+	set_host_byte(cmd, DID_OK);
 
 	if (unlikely(test_bit(AF_DEGRADED_MODE, &a->flags))) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		cmd->scsi_done(cmd);
 		return 0;
 	}
@@ -1047,7 +1047,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 	esas2r_log(ESAS2R_LOG_INFO, "eh_abort (%p)", cmd);
 
 	if (test_bit(AF_DEGRADED_MODE, &a->flags)) {
-		cmd->result = DID_ABORT << 16;
+		set_host_byte(cmd, DID_ABORT);
 
 		scsi_set_resid(cmd, 0);
 
@@ -1113,7 +1113,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 	 * freed it, or we didn't find it at all.  Either way, success!
 	 */
 
-	cmd->result = DID_ABORT << 16;
+	set_host_byte(cmd, DID_ABORT);
 
 	scsi_set_resid(cmd, 0);
 
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index c3fc34b9964d..f2ff43704a04 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2037,7 +2037,7 @@ static void esp_reset_cleanup_one(struct esp *esp, struct esp_cmd_entry *ent)
 
 	esp_unmap_dma(esp, cmd);
 	esp_free_lun_tag(ent, cmd->device->hostdata);
-	cmd->result = DID_RESET << 16;
+	set_host_byte(cmd, DID_RESET);
 
 	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
 		esp->ops->unmap_single(esp, ent->sense_dma,
@@ -2067,7 +2067,7 @@ static void esp_reset_cleanup(struct esp *esp)
 		struct scsi_cmnd *cmd = ent->cmd;
 
 		list_del(&ent->list);
-		cmd->result = DID_RESET << 16;
+		set_host_byte(cmd, DID_RESET);
 		cmd->scsi_done(cmd);
 		esp_put_ent(esp, ent);
 	}
@@ -2540,7 +2540,7 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 		 */
 		list_del(&ent->list);
 
-		cmd->result = DID_ABORT << 16;
+		set_host_byte(cmd, DID_ABORT);
 		cmd->scsi_done(cmd);
 
 		esp_put_ent(esp, ent);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 242e2ee494a1..abf7b0e10f8c 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -450,7 +450,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	if (!rport) {
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 				"returning DID_NO_CONNECT for IO as rport is NULL\n");
-		sc->result = DID_NO_CONNECT << 16;
+		set_host_byte(sc, DID_NO_CONNECT);
 		done(sc);
 		return 0;
 	}
@@ -472,7 +472,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 			rport->port_id);
 
 		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
-		sc->result = DID_NO_CONNECT<<16;
+		set_host_byte(sc, DID_NO_CONNECT);
 		done(sc);
 		return 0;
 	}
@@ -482,7 +482,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 			"rport 0x%x in state 0x%x, returning DID_IMM_RETRY\n",
 			rport->port_id, rp->rp_state);
 
-		sc->result = DID_IMM_RETRY << 16;
+		set_host_byte(sc, DID_IMM_RETRY);
 		done(sc);
 		return 0;
 	}
@@ -1401,7 +1401,7 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 		mempool_free(io_req, fnic->io_req_pool);
 
 cleanup_scsi_cmd:
-		sc->result = DID_TRANSPORT_DISRUPTED << 16;
+		set_host_byte(sc, DID_TRANSPORT_DISRUPTED);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			      "%s: sc duration = %lu DID_TRANSPORT_DISRUPTED\n",
 			      __func__, (jiffies - start_time));
@@ -1471,7 +1471,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 	mempool_free(io_req, fnic->io_req_pool);
 
 wq_copy_cleanup_scsi_cmd:
-	sc->result = DID_NO_CONNECT << 16;
+	set_host_byte(sc, DID_NO_CONNECT);
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "wq_copy_cleanup_handler:"
 		      " DID_NO_CONNECT\n");
 
@@ -2250,7 +2250,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		 */
 		if (sc->scsi_done) {
 			/* Set result to let upper SCSI layer retry */
-			sc->result = DID_RESET << 16;
+			set_host_byte(sc, DID_RESET);
 			sc->scsi_done(sc);
 		}
 	}
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9abe81021484..c0bf9cb52956 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2340,7 +2340,7 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 			 * of the disk to get the same device node.
 			 */
 			if (dev->physical_device && dev->expose_device) {
-				cmd->result = DID_NO_CONNECT << 16;
+				set_host_byte(cmd, DID_NO_CONNECT);
 				dev->removed = 1;
 				h->drv_req_rescan = 1;
 				dev_warn(&h->pdev->dev,
@@ -2508,13 +2508,13 @@ static void complete_scsi_command(struct CommandList *cp)
 	h = cp->h;
 
 	if (!cmd->device) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		return hpsa_cmd_free_and_done(h, cp, cmd);
 	}
 
 	dev = cmd->device->hostdata;
 	if (!dev) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		return hpsa_cmd_free_and_done(h, cp, cmd);
 	}
 	c2 = &h->ioaccel2_cmd_pool[cp->cmdindex];
@@ -2534,7 +2534,7 @@ static void complete_scsi_command(struct CommandList *cp)
 	if (cp->cmd_type == CMD_IOACCEL2 || cp->cmd_type == CMD_IOACCEL1) {
 		if (dev->physical_device && dev->expose_device &&
 			dev->removed) {
-			cmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(cmd, DID_NO_CONNECT);
 			return hpsa_cmd_free_and_done(h, cp, cmd);
 		}
 		if (likely(cp->phys_disk != NULL))
@@ -2548,7 +2548,7 @@ static void complete_scsi_command(struct CommandList *cp)
 	 */
 	if (unlikely(ei->CommandStatus == CMD_CTLR_LOCKUP)) {
 		/* DID_NO_CONNECT will prevent a retry */
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		return hpsa_cmd_free_and_done(h, cp, cmd);
 	}
 
@@ -2655,60 +2655,60 @@ static void complete_scsi_command(struct CommandList *cp)
 		 * This is kind of a shame because it means that any other
 		 * CMD_INVALID (e.g. driver bug) will get interpreted as a
 		 * missing target. */
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 	}
 		break;
 	case CMD_PROTOCOL_ERR:
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		dev_warn(&h->pdev->dev, "CDB %16phN : protocol error\n",
 				cp->Request.CDB);
 		break;
 	case CMD_HARDWARE_ERR:
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		dev_warn(&h->pdev->dev, "CDB %16phN : hardware error\n",
 			cp->Request.CDB);
 		break;
 	case CMD_CONNECTION_LOST:
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		dev_warn(&h->pdev->dev, "CDB %16phN : connection lost\n",
 			cp->Request.CDB);
 		break;
 	case CMD_ABORTED:
-		cmd->result = DID_ABORT << 16;
+		set_host_byte(cmd, DID_ABORT);
 		break;
 	case CMD_ABORT_FAILED:
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		dev_warn(&h->pdev->dev, "CDB %16phN : abort failed\n",
 			cp->Request.CDB);
 		break;
 	case CMD_UNSOLICITED_ABORT:
-		cmd->result = DID_SOFT_ERROR << 16; /* retry the command */
+		set_host_byte(cmd, DID_SOFT_ERROR); /* retry the command */
 		dev_warn(&h->pdev->dev, "CDB %16phN : unsolicited abort\n",
 			cp->Request.CDB);
 		break;
 	case CMD_TIMEOUT:
-		cmd->result = DID_TIME_OUT << 16;
+		set_host_byte(cmd, DID_TIME_OUT);
 		dev_warn(&h->pdev->dev, "CDB %16phN timed out\n",
 			cp->Request.CDB);
 		break;
 	case CMD_UNABORTABLE:
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		dev_warn(&h->pdev->dev, "Command unabortable\n");
 		break;
 	case CMD_TMF_STATUS:
 		if (hpsa_evaluate_tmf_status(h, cp)) /* TMF failed? */
-			cmd->result = DID_ERROR << 16;
+			set_host_byte(cmd, DID_ERROR);
 		break;
 	case CMD_IOACCEL_DISABLED:
 		/* This only handles the direct pass-through case since RAID
 		 * offload is handled above.  Just attempt a retry.
 		 */
-		cmd->result = DID_SOFT_ERROR << 16;
+		set_host_byte(cmd, DID_SOFT_ERROR);
 		dev_warn(&h->pdev->dev,
 				"cp %p had HP SSD Smart Path error\n", cp);
 		break;
 	default:
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		dev_warn(&h->pdev->dev, "cp %p returned unknown status %x\n",
 				cp, ei->CommandStatus);
 	}
@@ -5422,7 +5422,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 	cmd = c->scsi_cmd;
 	dev = cmd->device->hostdata;
 	if (!dev) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		return hpsa_cmd_free_and_done(c->h, c, cmd);
 	}
 	if (c->reset_pending)
@@ -5443,7 +5443,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 				 * Try again via scsi mid layer, which will
 				 * then get SCSI_MLQUEUE_HOST_BUSY.
 				 */
-				cmd->result = DID_IMM_RETRY << 16;
+				set_host_byte(cmd, DID_IMM_RETRY);
 				return hpsa_cmd_free_and_done(h, c, cmd);
 			}
 			/* else, fall thru and resubmit down CISS path */
@@ -5459,7 +5459,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 		 * hpsa_ciss_submit will have already freed c
 		 * if it encountered a dma mapping failure.
 		 */
-		cmd->result = DID_IMM_RETRY << 16;
+		set_host_byte(cmd, DID_IMM_RETRY);
 		cmd->scsi_done(cmd);
 	}
 }
@@ -5480,13 +5480,13 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 
 	dev = cmd->device->hostdata;
 	if (!dev) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		cmd->scsi_done(cmd);
 		return 0;
 	}
 
 	if (dev->removed) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		cmd->scsi_done(cmd);
 		return 0;
 	}
@@ -5494,7 +5494,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
 
 	if (unlikely(lockup_detected(h))) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		cmd->scsi_done(cmd);
 		return 0;
 	}
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 2fad7f03aa02..e320a2ac7974 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1038,7 +1038,7 @@ static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 	if (scp->device->channel ||
 			(scp->device->id > hba->max_devices) ||
 			((scp->device->id == (hba->max_devices-1)) && scp->device->lun)) {
-		scp->result = DID_BAD_TARGET << 16;
+		set_host_byte(scp, DID_BAD_TARGET);
 		free_req(hba, _req);
 		goto cmd_done;
 	}
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index b491af31a5f8..f1b13785c4c7 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1665,7 +1665,7 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 		scmd_printk(KERN_ERR, cmnd,
 			    "Failed to map DMA buffer for command. rc=%d\n", rc);
 
-	cmnd->result = DID_ERROR << 16;
+	set_host_byte(cmnd, DID_ERROR);
 	done(cmnd);
 	return 0;
 }
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 87c94191033b..47308d3b0417 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -922,7 +922,7 @@ static int imm_queuecommand_lck(struct scsi_cmnd *cmd,
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
 	cmd->scsi_done = done;
-	cmd->result = DID_ERROR << 16;	/* default return code */
+	set_host_byte(cmd, DID_ERROR);	/* default return code */
 	cmd->SCp.phase = 0;	/* bus free */
 
 	schedule_delayed_work(&dev->imm_tq, 0);
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 67621308eb9c..8ca2a509c77b 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -979,7 +979,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 			  ips_name, ha->host_num);
 
 		while ((scsi_cmd = ips_removeq_wait_head(&ha->scb_waitlist))) {
-			scsi_cmd->result = DID_ERROR << 16;
+			set_host_byte(scsi_cmd, DID_ERROR);
 			scsi_cmd->scsi_done(scsi_cmd);
 		}
 
@@ -1060,13 +1060,13 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 
 	if (ips_is_passthru(SC)) {
 		if (ha->copp_waitlist.count == IPS_MAX_IOCTL_QUEUE) {
-			SC->result = DID_BUS_BUSY << 16;
+			set_host_byte(SC, DID_BUS_BUSY);
 			done(SC);
 
 			return (0);
 		}
 	} else if (ha->scb_waitlist.count == IPS_MAX_QUEUE) {
-		SC->result = DID_BUS_BUSY << 16;
+		set_host_byte(SC, DID_BUS_BUSY);
 		done(SC);
 
 		return (0);
@@ -1083,7 +1083,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 	/* Check for command to initiator IDs */
 	if ((scmd_channel(SC) > 0)
 	    && (scmd_id(SC) == ha->ha_id[scmd_channel(SC)])) {
-		SC->result = DID_NO_CONNECT << 16;
+		set_host_byte(SC, DID_NO_CONNECT);
 		done(SC);
 
 		return (0);
@@ -1100,13 +1100,13 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 		if ((pt->CoppCP.cmd.reset.op_code == IPS_CMD_RESET_CHANNEL) &&
 		    (pt->CoppCP.cmd.reset.adapter_flag == 1)) {
 			if (ha->scb_activelist.count != 0) {
-				SC->result = DID_BUS_BUSY << 16;
+				set_host_byte(SC, DID_BUS_BUSY);
 				done(SC);
 				return (0);
 			}
 			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
 			__ips_eh_reset(SC);
-			SC->result = DID_OK << 16;
+			set_host_byte(SC, DID_OK);
 			SC->scsi_done(SC);
 			return (0);
 		}
@@ -1115,7 +1115,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 		scratch = kmalloc(sizeof (ips_copp_wait_item_t), GFP_ATOMIC);
 
 		if (!scratch) {
-			SC->result = DID_ERROR << 16;
+			set_host_byte(SC, DID_ERROR);
 			done(SC);
 
 			return (0);
@@ -1612,7 +1612,7 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 		       &ips_num_controllers, sizeof (int));
 		ips_scmd_buf_write(SC, ha->ioctl_data,
 				   sizeof (ips_passthru_t) + sizeof (int));
-		SC->result = DID_OK << 16;
+		set_host_byte(SC, DID_OK);
 
 		return (IPS_SUCCESS_IMM);
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 772c35a5c49e..9e5118ba6965 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1890,7 +1890,7 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 		 * rport is transitioning from blocked/deleted to
 		 * online
 		 */
-		sc_cmd->result = DID_IMM_RETRY << 16;
+		set_host_byte(sc_cmd, DID_IMM_RETRY);
 		sc_cmd->scsi_done(sc_cmd);
 		goto out;
 	}
@@ -2003,7 +2003,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			/*
 			 * good I/O status
 			 */
-			sc_cmd->result = DID_OK << 16;
+			set_host_byte(sc_cmd, DID_OK);
 			if (fsp->scsi_resid)
 				CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
 		} else {
@@ -2017,7 +2017,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 	case FC_ERROR:
 		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
 			   "due to FC_ERROR\n");
-		sc_cmd->result = DID_ERROR << 16;
+		set_host_byte(sc_cmd, DID_ERROR);
 		break;
 	case FC_DATA_UNDRUN:
 		if ((fsp->cdb_status == 0) && !(fsp->req_flags & FC_SRB_READ)) {
@@ -2026,11 +2026,11 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			 * underrun.
 			 */
 			if (fsp->state & FC_SRB_RCV_STATUS) {
-				sc_cmd->result = DID_OK << 16;
+				set_host_byte(sc_cmd, DID_OK);
 			} else {
 				FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml"
 					   " due to FC_DATA_UNDRUN (trans)\n");
-				sc_cmd->result = DID_ERROR << 16;
+				set_host_byte(sc_cmd, DID_ERROR);
 			}
 		} else {
 			/*
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9cba4913b43c..80768efc6cdd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -636,7 +636,7 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	else
 		state = ISCSI_TASK_ABRT_TMF;
 
-	sc->result = err << 16;
+	set_host_byte(sc, err);
 	if (!scsi_bidi_cmnd(sc))
 		scsi_set_resid(sc, scsi_bufflen(sc));
 	else {
@@ -868,7 +868,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	}
 
 	if (rhdr->response != ISCSI_STATUS_CMD_COMPLETED) {
-		sc->result = DID_ERROR << 16;
+		set_host_byte(sc, DID_ERROR);
 		goto out;
 	}
 
@@ -880,7 +880,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			iscsi_conn_printk(KERN_ERR,  conn,
 					 "Got CHECK_CONDITION but invalid data "
 					 "buffer size of %d\n", datalen);
-			sc->result = DID_BAD_TARGET << 16;
+			set_host_byte(sc, DID_BAD_TARGET);
 			goto out;
 		}
 
@@ -1698,23 +1698,23 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		case ISCSI_STATE_FAILED:
 		case ISCSI_STATE_IN_RECOVERY:
 			reason = FAILURE_SESSION_IN_RECOVERY;
-			sc->result = DID_IMM_RETRY << 16;
+			set_host_byte(sc, DID_IMM_RETRY);
 			break;
 		case ISCSI_STATE_LOGGING_OUT:
 			reason = FAILURE_SESSION_LOGGING_OUT;
-			sc->result = DID_IMM_RETRY << 16;
+			set_host_byte(sc, DID_IMM_RETRY);
 			break;
 		case ISCSI_STATE_RECOVERY_FAILED:
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
-			sc->result = DID_TRANSPORT_FAILFAST << 16;
+			set_host_byte(sc, DID_TRANSPORT_FAILFAST);
 			break;
 		case ISCSI_STATE_TERMINATE:
 			reason = FAILURE_SESSION_TERMINATE;
-			sc->result = DID_NO_CONNECT << 16;
+			set_host_byte(sc, DID_NO_CONNECT);
 			break;
 		default:
 			reason = FAILURE_SESSION_FREED;
-			sc->result = DID_NO_CONNECT << 16;
+			set_host_byte(sc, DID_NO_CONNECT);
 		}
 		goto fault;
 	}
@@ -1722,13 +1722,13 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	conn = session->leadconn;
 	if (!conn) {
 		reason = FAILURE_SESSION_FREED;
-		sc->result = DID_NO_CONNECT << 16;
+		set_host_byte(sc, DID_NO_CONNECT);
 		goto fault;
 	}
 
 	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
 		reason = FAILURE_SESSION_IN_RECOVERY;
-		sc->result = DID_REQUEUE << 16;
+		set_host_byte(sc, DID_REQUEUE);
 		goto fault;
 	}
 
@@ -1750,7 +1750,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 				reason = FAILURE_OOM;
 				goto prepd_reject;
 			} else {
-				sc->result = DID_ABORT << 16;
+				set_host_byte(sc, DID_ABORT);
 				goto prepd_fault;
 			}
 		}
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index ea8ad06ff582..acdc5b63760e 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -186,7 +186,7 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* If the device fell off, no sense in issuing commands */
 	if (test_bit(SAS_DEV_GONE, &dev->state)) {
-		cmd->result = DID_BAD_TARGET << 16;
+		set_host_byte(cmd, DID_BAD_TARGET);
 		goto out_done;
 	}
 
@@ -211,9 +211,9 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	ASSIGN_SAS_TASK(cmd, NULL);
 	sas_free_task(task);
 	if (res == -SAS_QUEUE_FULL)
-		cmd->result = DID_SOFT_ERROR << 16; /* retry */
+		set_host_byte(cmd, DID_SOFT_ERROR); /* retry */
 	else
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 out_done:
 	cmd->scsi_done(cmd);
 	return 0;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e518dadc8161..d409924d3364 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1665,7 +1665,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	    scmd->device->host->hostdata;
 
 	if (instance->unload == 1) {
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -1680,21 +1680,21 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		    (DID_REQUEUE << 16)) {
 			return SCSI_MLQUEUE_HOST_BUSY;
 		} else {
-			scmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(scmd, DID_NO_CONNECT);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
 	}
 
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
 
 	mr_device_priv_data = scmd->device->hostdata;
 	if (!mr_device_priv_data) {
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -1711,14 +1711,14 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	if (MEGASAS_IS_LOGICAL(scmd->device) &&
 	    (scmd->device->id >= instance->fw_supported_vd_count ||
 		scmd->device->lun)) {
-		scmd->result = DID_BAD_TARGET << 16;
+		set_host_byte(scmd, DID_BAD_TARGET);
 		goto out_done;
 	}
 
 	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) &&
 	    MEGASAS_IS_LOGICAL(scmd->device) &&
 	    (!instance->fw_sync_cache_support)) {
-		scmd->result = DID_OK << 16;
+		set_host_byte(scmd, DID_OK);
 		goto out_done;
 	}
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 11bd2e698b84..db89e23eaade 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1493,7 +1493,7 @@ map_cmd_status(struct fusion_context *fusion,
 	switch (status) {
 
 	case MFI_STAT_OK:
-		scmd->result = DID_OK << 16;
+		set_host_byte(scmd, DID_OK);
 		break;
 
 	case MFI_STAT_SCSI_IO_FAILED:
@@ -1531,13 +1531,13 @@ map_cmd_status(struct fusion_context *fusion,
 
 	case MFI_STAT_LD_OFFLINE:
 	case MFI_STAT_DEVICE_NOT_FOUND:
-		scmd->result = DID_BAD_TARGET << 16;
+		set_host_byte(scmd, DID_BAD_TARGET);
 		break;
 	case MFI_STAT_CONFIG_SEQ_MISMATCH:
-		scmd->result = DID_IMM_RETRY << 16;
+		set_host_byte(scmd, DID_IMM_RETRY);
 		break;
 	default:
-		scmd->result = DID_ERROR << 16;
+		set_host_byte(scmd, DID_ERROR);
 		break;
 	}
 }
@@ -4008,7 +4008,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	if (!mr_device_priv_data) {
 		sdev_printk(KERN_INFO, scmd->device, "device been deleted! "
 			"scmd(%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		ret = SUCCESS;
 		goto out;
 	}
@@ -4091,7 +4091,7 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	if (!mr_device_priv_data) {
 		sdev_printk(KERN_INFO, scmd->device, "device been deleted! "
 			"scmd(%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		ret = SUCCESS;
 		goto out;
 	}
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 1753e42826dd..4ff15fb6aa48 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -992,7 +992,7 @@ static void handle_reset(struct mesh_state *ms)
 	for (tgt = 0; tgt < 8; ++tgt) {
 		tp = &ms->tgts[tgt];
 		if ((cmd = tp->current_req) != NULL) {
-			cmd->result = DID_RESET << 16;
+			set_host_byte(cmd, DID_RESET);
 			tp->current_req = NULL;
 			mesh_completed(ms, cmd);
 		}
@@ -1002,7 +1002,7 @@ static void handle_reset(struct mesh_state *ms)
 	ms->current_req = NULL;
 	while ((cmd = ms->request_q) != NULL) {
 		ms->request_q = (struct scsi_cmnd *) cmd->host_scribble;
-		cmd->result = DID_RESET << 16;
+		set_host_byte(cmd, DID_RESET);
 		mesh_completed(ms, cmd);
 	}
 	ms->phase = idle;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 22998cbd538f..153641683e65 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2474,7 +2474,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		sdev_printk(KERN_INFO, scmd->device,
 			"device been deleted! scmd(%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		scmd->scsi_done(scmd);
 		r = SUCCESS;
 		goto out;
@@ -2483,7 +2483,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 	/* search for the command */
 	smid = _scsih_scsi_lookup_find_by_scmd(ioc, scmd);
 	if (!smid) {
-		scmd->result = DID_RESET << 16;
+		set_host_byte(scmd, DID_RESET);
 		r = SUCCESS;
 		goto out;
 	}
@@ -2492,7 +2492,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 	if (sas_device_priv_data->sas_target->flags &
 	    MPT_TARGET_FLAGS_RAID_COMPONENT ||
 	    sas_device_priv_data->sas_target->flags & MPT_TARGET_FLAGS_VOLUME) {
-		scmd->result = DID_RESET << 16;
+		set_host_byte(scmd, DID_RESET);
 		r = FAILED;
 		goto out;
 	}
@@ -2536,7 +2536,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		sdev_printk(KERN_INFO, scmd->device,
 			"device been deleted! scmd(%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		scmd->scsi_done(scmd);
 		r = SUCCESS;
 		goto out;
@@ -2554,7 +2554,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		handle = sas_device_priv_data->sas_target->handle;
 
 	if (!handle) {
-		scmd->result = DID_RESET << 16;
+		set_host_byte(scmd, DID_RESET);
 		r = FAILED;
 		goto out;
 	}
@@ -2598,7 +2598,7 @@ scsih_target_reset(struct scsi_cmnd *scmd)
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		starget_printk(KERN_INFO, starget, "target been deleted! scmd(%p)\n",
 			scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		scmd->scsi_done(scmd);
 		r = SUCCESS;
 		goto out;
@@ -2616,7 +2616,7 @@ scsih_target_reset(struct scsi_cmnd *scmd)
 		handle = sas_device_priv_data->sas_target->handle;
 
 	if (!handle) {
-		scmd->result = DID_RESET << 16;
+		set_host_byte(scmd, DID_RESET);
 		r = FAILED;
 		goto out;
 	}
@@ -3958,9 +3958,9 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		mpt3sas_base_free_smid(ioc, smid);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
-			scmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(scmd, DID_NO_CONNECT);
 		else
-			scmd->result = DID_RESET << 16;
+			set_host_byte(scmd, DID_RESET);
 		scmd->scsi_done(scmd);
 	}
 	dtmprintk(ioc, pr_info(MPT3SAS_FMT "completing %d cmds\n",
@@ -4092,13 +4092,13 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
 
 	if (ioc->pci_error_recovery || ioc->remove_host) {
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -4121,7 +4121,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	/* invalid device handle */
 	handle = sas_target_priv_data->handle;
 	if (handle == MPT3SAS_INVALID_DEVICE_HANDLE) {
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -4133,7 +4133,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	/* device has been deleted */
 	else if (sas_target_priv_data->deleted) {
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		scmd->scsi_done(scmd);
 		return 0;
 	/* device busy with task management */
@@ -4694,14 +4694,14 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
 	if (mpi_reply == NULL) {
-		scmd->result = DID_OK << 16;
+		set_host_byte(scmd, DID_OK);
 		goto out;
 	}
 
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
 	     sas_device_priv_data->sas_target->deleted) {
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		goto out;
 	}
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
@@ -4783,38 +4783,38 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		break;
 
 	case MPI2_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
-		scmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(scmd, DID_NO_CONNECT);
 		break;
 
 	case MPI2_IOCSTATUS_SCSI_IOC_TERMINATED:
 		if (sas_device_priv_data->block) {
-			scmd->result = DID_TRANSPORT_DISRUPTED << 16;
+			set_host_byte(scmd, DID_TRANSPORT_DISRUPTED);
 			goto out;
 		}
 		if (log_info == 0x31110630) {
 			if (scmd->retries > 2) {
-				scmd->result = DID_NO_CONNECT << 16;
+				set_host_byte(scmd, DID_NO_CONNECT);
 				scsi_device_set_state(scmd->device,
 				    SDEV_OFFLINE);
 			} else {
-				scmd->result = DID_SOFT_ERROR << 16;
+				set_host_byte(scmd, DID_SOFT_ERROR);
 				scmd->device->expecting_cc_ua = 1;
 			}
 			break;
 		} else if (log_info == VIRTUAL_IO_FAILED_RETRY) {
-			scmd->result = DID_RESET << 16;
+			set_host_byte(scmd, DID_RESET);
 			break;
 		}
-		scmd->result = DID_SOFT_ERROR << 16;
+		set_host_byte(scmd, DID_SOFT_ERROR);
 		break;
 	case MPI2_IOCSTATUS_SCSI_TASK_TERMINATED:
 	case MPI2_IOCSTATUS_SCSI_EXT_TERMINATED:
-		scmd->result = DID_RESET << 16;
+		set_host_byte(scmd, DID_RESET);
 		break;
 
 	case MPI2_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
 		if ((xfer_cnt == 0) || (scmd->underflow > xfer_cnt))
-			scmd->result = DID_SOFT_ERROR << 16;
+			set_host_byte(scmd, DID_SOFT_ERROR);
 		else
 			scmd->result = (DID_OK << 16) | scsi_status;
 		break;
@@ -4829,12 +4829,12 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 			if (scsi_status == SAM_STAT_BUSY)
 				scmd->result = SAM_STAT_BUSY;
 			else
-				scmd->result = DID_SOFT_ERROR << 16;
+				set_host_byte(scmd, DID_SOFT_ERROR);
 		} else if (scsi_state & (MPI2_SCSI_STATE_AUTOSENSE_FAILED |
 		     MPI2_SCSI_STATE_NO_SCSI_STATUS))
-			scmd->result = DID_SOFT_ERROR << 16;
+			set_host_byte(scmd, DID_SOFT_ERROR);
 		else if (scsi_state & MPI2_SCSI_STATE_TERMINATED)
-			scmd->result = DID_RESET << 16;
+			set_host_byte(scmd, DID_RESET);
 		else if (!xfer_cnt && scmd->cmnd[0] == REPORT_LUNS) {
 			mpi_reply->SCSIState = MPI2_SCSI_STATE_AUTOSENSE_VALID;
 			mpi_reply->SCSIStatus = SAM_STAT_CHECK_CONDITION;
@@ -4856,9 +4856,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		    MPI2_SCSITASKMGMT_RSP_INVALID_FRAME ||
 		    (scsi_state & (MPI2_SCSI_STATE_AUTOSENSE_FAILED |
 		     MPI2_SCSI_STATE_NO_SCSI_STATUS)))
-			scmd->result = DID_SOFT_ERROR << 16;
+			set_host_byte(scmd, DID_SOFT_ERROR);
 		else if (scsi_state & MPI2_SCSI_STATE_TERMINATED)
-			scmd->result = DID_RESET << 16;
+			set_host_byte(scmd, DID_RESET);
 		break;
 
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
@@ -4877,7 +4877,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	case MPI2_IOCSTATUS_SCSI_TASK_MGMT_FAILED:
 	case MPI2_IOCSTATUS_INSUFFICIENT_POWER:
 	default:
-		scmd->result = DID_SOFT_ERROR << 16;
+		set_host_byte(scmd, DID_SOFT_ERROR);
 		break;
 
 	}
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 107e191bf023..c19f94d4c01a 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -470,7 +470,7 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 	if (phase != BUSMON_BUS_FREE) {
 		nsp32_msg(KERN_WARNING, "bus busy");
 		show_busphase(phase & BUSMON_PHASE_MASK);
-		SCpnt->result = DID_BUS_BUSY << 16;
+		set_host_byte(SCpnt, DID_BUS_BUSY);
 		return FALSE;
 	}
 
@@ -482,7 +482,7 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 	 */
 	if (data->msgout_len == 0) {
 		nsp32_msg(KERN_ERR, "SCSI MsgOut without any message!");
-		SCpnt->result = DID_ERROR << 16;
+		set_host_byte(SCpnt, DID_ERROR);
 		return FALSE;
 	} else if (data->msgout_len > 0 && data->msgout_len <= 3) {
 		msgout = 0;
@@ -606,7 +606,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	phase = nsp32_read1(base, SCSI_BUS_MONITOR);
 	if(((phase & BUSMON_BSY) == 1) || (phase & BUSMON_SEL) == 1) {
 		nsp32_msg(KERN_WARNING, "bus busy");
-		SCpnt->result = DID_BUS_BUSY << 16;
+		set_host_byte(SCpnt, DID_BUS_BUSY);
 		status = 1;
 		goto out;
         }
@@ -642,7 +642,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	 */
 	if (data->msgout_len == 0) {
 		nsp32_msg(KERN_ERR, "SCSI MsgOut without any message!");
-		SCpnt->result = DID_ERROR << 16;
+		set_host_byte(SCpnt, DID_ERROR);
 		status = 1;
 		goto out;
 	} else if (data->msgout_len > 0 && data->msgout_len <= 3) {
@@ -772,11 +772,11 @@ static int nsp32_arbitration(struct scsi_cmnd *SCpnt, unsigned int base)
 
 	if (arbit & ARBIT_WIN) {
 		/* Arbitration succeeded */
-		SCpnt->result = DID_OK << 16;
+		set_host_byte(SCpnt, DID_OK);
 		nsp32_index_write1(base, EXT_PORT, LED_ON); /* PCI LED on */
 	} else if (arbit & ARBIT_FAIL) {
 		/* Arbitration failed */
-		SCpnt->result = DID_BUS_BUSY << 16;
+		set_host_byte(SCpnt, DID_BUS_BUSY);
 		status = FALSE;
 	} else {
 		/*
@@ -784,7 +784,7 @@ static int nsp32_arbitration(struct scsi_cmnd *SCpnt, unsigned int base)
 		 * something lock up! guess no connection.
 		 */
 		nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "arbit timeout");
-		SCpnt->result = DID_NO_CONNECT << 16;
+		set_host_byte(SCpnt, DID_NO_CONNECT);
 		status = FALSE;
         }
 
@@ -920,7 +920,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	if (data->CurrentSC != NULL) {
 		nsp32_msg(KERN_ERR, "Currentsc != NULL. Cancel this command request");
 		data->CurrentSC = NULL;
-		SCpnt->result   = DID_NO_CONNECT << 16;
+		set_host_byte(SCpnt, DID_NO_CONNECT);
 		done(SCpnt);
 		return 0;
 	}
@@ -928,7 +928,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	/* check target ID is not same as this initiator ID */
 	if (scmd_id(SCpnt) == SCpnt->device->host->this_id) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "target==host???");
-		SCpnt->result = DID_BAD_TARGET << 16;
+		set_host_byte(SCpnt, DID_BAD_TARGET);
 		done(SCpnt);
 		return 0;
 	}
@@ -936,7 +936,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	/* check target LUN is allowable value */
 	if (SCpnt->device->lun >= MAX_LUN) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "no more lun");
-		SCpnt->result = DID_BAD_TARGET << 16;
+		set_host_byte(SCpnt, DID_BAD_TARGET);
 		done(SCpnt);
 		return 0;
 	}
@@ -968,7 +968,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	ret = nsp32_setup_sg_table(SCpnt);
 	if (ret == FALSE) {
 		nsp32_msg(KERN_ERR, "SGT fail");
-		SCpnt->result = DID_ERROR << 16;
+		set_host_byte(SCpnt, DID_ERROR);
 		nsp32_scsi_done(SCpnt);
 		return 0;
 	}
@@ -1191,7 +1191,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 		nsp32_msg(KERN_INFO, "card disconnect");
 		if (data->CurrentSC != NULL) {
 			nsp32_msg(KERN_INFO, "clean up current SCSI command");
-			SCpnt->result = DID_BAD_TARGET << 16;
+			set_host_byte(SCpnt, DID_BAD_TARGET);
 			nsp32_scsi_done(SCpnt);
 		}
 		goto out;
@@ -1209,7 +1209,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 		nsp32_msg(KERN_INFO, "detected someone do bus reset");
 		nsp32_do_bus_reset(data);
 		if (SCpnt != NULL) {
-			SCpnt->result = DID_RESET << 16;
+			set_host_byte(SCpnt, DID_RESET);
 			nsp32_scsi_done(SCpnt);
 		}
 		goto out;
@@ -1237,7 +1237,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 			nsp32_dbg(NSP32_DEBUG_INTR,
 				  "selection timeout occurred");
 
-			SCpnt->result = DID_TIME_OUT << 16;
+			set_host_byte(SCpnt, DID_TIME_OUT);
 			nsp32_scsi_done(SCpnt);
 			goto out;
 		}
@@ -1699,7 +1699,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 
 		/* DID_ERROR? */
 		//SCpnt->result   = (DID_OK << 16) | (SCpnt->SCp.Message << 8) | (SCpnt->SCp.Status << 0);
-		SCpnt->result = DID_ERROR << 16;
+		set_host_byte(SCpnt, DID_ERROR);
 		nsp32_scsi_done(SCpnt);
 		return TRUE;
 	}
@@ -2836,7 +2836,7 @@ static int nsp32_eh_abort(struct scsi_cmnd *SCpnt)
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
 	nsp32_write2(base, BM_CNT,           0);
 
-	SCpnt->result = DID_ABORT << 16;
+	set_host_byte(SCpnt, DID_ABORT);
 	nsp32_scsi_done(SCpnt);
 
 	nsp32_dbg(NSP32_DEBUG_BUSRESET, "abort success");
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 5fb6eefc6541..f048cdfca73e 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -203,7 +203,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
 
 	if (data->CurrentSC != NULL) {
 		nsp_msg(KERN_DEBUG, "CurrentSC!=NULL this can't be happen");
-		SCpnt->result   = DID_BAD_TARGET << 16;
+		set_host_byte(SCpnt, DID_BAD_TARGET);
 		nsp_scsi_done(SCpnt);
 		return 0;
 	}
@@ -250,7 +250,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
 
 	if (nsphw_start_selection(SCpnt) == FALSE) {
 		nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "selection fail");
-		SCpnt->result   = DID_BUS_BUSY << 16;
+		set_host_byte(SCpnt, DID_BUS_BUSY);
 		nsp_scsi_done(SCpnt);
 		return 0;
 	}
@@ -1084,7 +1084,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 				data->SelectionTimeOut = 0;
 				nsp_index_write(base, SCSIBUSCTRL, 0);
 
-				tmpSC->result   = DID_TIME_OUT << 16;
+				set_host_byte(tmpSC, DID_TIME_OUT);
 				nsp_scsi_done(tmpSC);
 
 				return IRQ_HANDLED;
@@ -1110,7 +1110,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		// *sync_neg = SYNC_NOT_YET;
 		if ((phase & BUSMON_PHASE_MASK) != BUSPHASE_MESSAGE_IN) {
 
-			tmpSC->result	= DID_ABORT << 16;
+			set_host_byte(tmpSC, DID_ABORT);
 			nsp_scsi_done(tmpSC);
 			return IRQ_HANDLED;
 		}
@@ -1153,7 +1153,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		nsp_msg(KERN_DEBUG, "unexpected bus free. irq_status=0x%x, phase=0x%x, irq_phase=0x%x", irq_status, phase, irq_phase);
 
 		*sync_neg       = SYNC_NG;
-		tmpSC->result   = DID_ERROR << 16;
+		set_host_byte(tmpSC, DID_ERROR);
 		nsp_scsi_done(tmpSC);
 		return IRQ_HANDLED;
 	}
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 20011c8afbb5..f1b41398ae55 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -382,32 +382,32 @@ SYM53C500_intr(int irq, void *dev_id)
 
 	if (int_reg & 0x80) {	/* SCSI reset intr */
 		DEB(printk("SYM53C500: reset intr received\n"));
-		curSC->result = DID_RESET << 16;
+		set_host_byte(curSC, DID_RESET);
 		goto idle_out;
 	}
 
 	if (pio_status & 0x80) {
 		printk("SYM53C500: Warning: PIO error!\n");
-		curSC->result = DID_ERROR << 16;
+		set_host_byte(curSC, DID_ERROR);
 		goto idle_out;
 	}
 
 	if (status & 0x20) {		/* Parity error */
 		printk("SYM53C500: Warning: parity error!\n");
-		curSC->result = DID_PARITY << 16;
+		set_host_byte(curSC, DID_PARITY);
 		goto idle_out;
 	}
 
 	if (status & 0x40) {		/* Gross error */
 		printk("SYM53C500: Warning: gross error!\n");
-		curSC->result = DID_ERROR << 16;
+		set_host_byte(curSC, DID_ERROR);
 		goto idle_out;
 	}
 
 	if (int_reg & 0x20) {		/* Disconnect */
 		DEB(printk("SYM53C500: disconnect intr received\n"));
 		if (curSC->SCp.phase != message_in) {	/* Unexpected disconnect */
-			curSC->result = DID_NO_CONNECT << 16;
+			set_host_byte(curSC, DID_NO_CONNECT);
 		} else {	/* Command complete, return status and message */
 			curSC->result = (curSC->SCp.Status & 0xff)
 			    | ((curSC->SCp.Message & 0xff) << 8) | (DID_OK << 16);
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 7be5823ab036..88764aa3bd02 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -760,7 +760,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 		cmd->SCp.phase++;
 
 	case 6:		/* Phase 6 - Read status/message */
-		cmd->result = DID_OK << 16;
+		set_host_byte(cmd, DID_OK);
 		/* Check for data overrun */
 		if (ppa_wait(dev) != (unsigned char) 0xf0) {
 			ppa_fail(dev, DID_ERROR);
@@ -795,7 +795,7 @@ static int ppa_queuecommand_lck(struct scsi_cmnd *cmd,
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
 	cmd->scsi_done = done;
-	cmd->result = DID_ERROR << 16;	/* default return code */
+	set_host_byte(cmd, DID_ERROR);	/* default return code */
 	cmd->SCp.phase = 0;	/* bus free */
 
 	schedule_delayed_work(&dev->ppa_tq, 0);
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 4924424d20fe..f8102317447d 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -314,7 +314,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 
 			scsi_set_resid(cmd, scsi_bufflen(cmd) - len);
 		}
-		cmd->result = DID_OK << 16;
+		set_host_byte(cmd, DID_OK);
 		goto done;
 	}
 
@@ -327,7 +327,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 	}
 
 	if (decode_lv1_status(status, &sense_key, &asc, &ascq)) {
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		goto done;
 	}
 
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index ded386036c27..e5fa7e501479 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -926,7 +926,7 @@ qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
 
 	if (test_bit(QEDF_UNLOADING, &qedf->flags) ||
 	    test_bit(QEDF_DBG_STOP_IO, &qedf->flags)) {
-		sc_cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(sc_cmd, DID_NO_CONNECT);
 		sc_cmd->scsi_done(sc_cmd);
 		return 0;
 	}
@@ -1124,7 +1124,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		    "FCP I/O protocol failure xid=0x%x fcp_rsp_len=%d "
 		    "fcp_rsp_code=%d.\n", io_req->xid, io_req->fcp_rsp_len,
 		    io_req->fcp_rsp_code);
-		sc_cmd->result = DID_BUS_BUSY << 16;
+		set_host_byte(sc_cmd, DID_BUS_BUSY);
 		goto out;
 	}
 
@@ -1162,7 +1162,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	case FC_GOOD:
 		if (io_req->cdb_status == 0) {
 			/* Good I/O completion */
-			sc_cmd->result = DID_OK << 16;
+			set_host_byte(sc_cmd, DID_OK);
 		} else {
 			refcount = kref_read(&io_req->refcount);
 			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
@@ -1248,7 +1248,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 
 	qedf_unmap_sg_list(qedf, io_req);
 
-	sc_cmd->result = result << 16;
+	set_host_byte(sc_cmd, result);
 	refcount = kref_read(&io_req->refcount);
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO, "%d:0:%d:%lld: Completing "
 	    "sc_cmd=%p result=0x%08x op=0x%02x lba=0x%02x%02x%02x%02x, "
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 2f94159186d7..864569557b1d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1928,13 +1928,13 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 
 	/* Check for host side state */
 	if (!qpair->online) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		return QLA_INTERFACE_ERROR;
 	}
 
 	if (!qpair->difdix_supported &&
 		scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		return QLA_INTERFACE_ERROR;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9d9668aac6f6..7e3ec970cc5f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2090,7 +2090,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 		    cmd->device->sector_size);
 
 		scsi_set_resid(cmd, resid);
-		cmd->result = DID_OK << 16;
+		set_host_byte(cmd, DID_OK);
 
 		/* Update protection tag */
 		if (scsi_prot_sg_count(cmd)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5b2437a5ea44..06c8da761b5e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -836,7 +836,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	uint16_t hwq;
 
 	if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags))) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		goto qc24_fail_command;
 	}
 
@@ -858,11 +858,11 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 			ql_dbg(ql_dbg_aer, vha, 0x9010,
 			    "PCI Channel IO permanent failure, exiting "
 			    "cmd=%p.\n", cmd);
-			cmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(cmd, DID_NO_CONNECT);
 		} else {
 			ql_dbg(ql_dbg_aer, vha, 0x9011,
 			    "EEH_Busy, Requeuing the cmd=%p.\n", cmd);
-			cmd->result = DID_REQUEUE << 16;
+			set_host_byte(cmd, DID_REQUEUE);
 		}
 		goto qc24_fail_command;
 	}
@@ -881,12 +881,12 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 			ql_dbg(ql_dbg_io, vha, 0x3004,
 			    "DIF Cap not reg, fail DIF capable cmd's:%p.\n",
 			    cmd);
-			cmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(cmd, DID_NO_CONNECT);
 			goto qc24_fail_command;
 	}
 
 	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		goto qc24_fail_command;
 	}
 
@@ -897,7 +897,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 			    "Returning DNC, fcport_state=%d loop_state=%d.\n",
 			    atomic_read(&fcport->state),
 			    atomic_read(&base_vha->loop_state));
-			cmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(cmd, DID_NO_CONNECT);
 			goto qc24_fail_command;
 		}
 		goto qc24_target_busy;
@@ -972,7 +972,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	}
 
 	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		goto qc24_fail_command;
 	}
 
@@ -983,7 +983,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 			    "Returning DNC, fcport_state=%d loop_state=%d.\n",
 			    atomic_read(&fcport->state),
 			    atomic_read(&base_vha->loop_state));
-			cmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(cmd, DID_NO_CONNECT);
 			goto qc24_fail_command;
 		}
 		goto qc24_target_busy;
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index d2cd33d8d67f..e736748bdf3c 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -146,7 +146,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 
 	ddb_entry = srb->ddb;
 	if (ddb_entry == NULL) {
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		goto status_entry_exit;
 	}
 
@@ -158,7 +158,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 	case SCS_COMPLETE:
 
 		if (sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_OVER) {
-			cmd->result = DID_ERROR << 16;
+			set_host_byte(cmd, DID_ERROR);
 			break;
 		}
 
@@ -167,7 +167,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			if (!scsi_status && ((scsi_bufflen(cmd) - residual) <
 				cmd->underflow)) {
 
-				cmd->result = DID_ERROR << 16;
+				set_host_byte(cmd, DID_ERROR);
 
 				DEBUG2(printk("scsi%ld:%d:%d:%llu: %s: "
 					"Mid-layer Data underrun0, "
@@ -193,7 +193,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 	case SCS_INCOMPLETE:
 		/* Always set the status to DID_ERROR, since
 		 * all conditions result in that status anyway */
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		break;
 
 	case SCS_RESET_OCCURRED:
@@ -201,7 +201,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			      ha->host_no, cmd->device->channel,
 			      cmd->device->id, cmd->device->lun, __func__));
 
-		cmd->result = DID_RESET << 16;
+		set_host_byte(cmd, DID_RESET);
 		break;
 
 	case SCS_ABORTED:
@@ -209,7 +209,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			      ha->host_no, cmd->device->channel,
 			      cmd->device->id, cmd->device->lun, __func__));
 
-		cmd->result = DID_RESET << 16;
+		set_host_byte(cmd, DID_RESET);
 		break;
 
 	case SCS_TIMEOUT:
@@ -217,7 +217,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			      ha->host_no, cmd->device->channel,
 			      cmd->device->id, cmd->device->lun));
 
-		cmd->result = DID_TRANSPORT_DISRUPTED << 16;
+		set_host_byte(cmd, DID_TRANSPORT_DISRUPTED);
 
 		/*
 		 * Mark device missing so that we won't continue to send
@@ -237,7 +237,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 				      cmd->device->channel, cmd->device->id,
 				      cmd->device->lun, __func__));
 
-			cmd->result = DID_ERROR << 16;
+			set_host_byte(cmd, DID_ERROR);
 			break;
 		}
 
@@ -267,7 +267,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 						   scsi_bufflen(cmd),
 						   residual));
 
-				cmd->result = DID_ERROR << 16;
+				set_host_byte(cmd, DID_ERROR);
 				break;
 			}
 
@@ -325,7 +325,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 		if (iscsi_is_session_online(ddb_entry->sess))
 			qla4xxx_mark_device_missing(ddb_entry->sess);
 
-		cmd->result = DID_TRANSPORT_DISRUPTED << 16;
+		set_host_byte(cmd, DID_TRANSPORT_DISRUPTED);
 		break;
 
 	case SCS_QUEUE_FULL:
@@ -344,7 +344,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 		break;
 
 	default:
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		break;
 	}
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 64c6fa563fdb..2131fe0dc885 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4065,14 +4065,14 @@ static int qla4xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	if (test_bit(AF_EEH_BUSY, &ha->flags)) {
 		if (test_bit(AF_PCI_CHANNEL_IO_PERM_FAILURE, &ha->flags))
-			cmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(cmd, DID_NO_CONNECT);
 		else
-			cmd->result = DID_REQUEUE << 16;
+			set_host_byte(cmd, DID_REQUEUE);
 		goto qc_fail_command;
 	}
 
 	if (!sess) {
-		cmd->result = DID_IMM_RETRY << 16;
+		set_host_byte(cmd, DID_IMM_RETRY);
 		goto qc_fail_command;
 	}
 
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 8b471a925b43..66573dd4ef83 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -444,7 +444,7 @@ static int qlogicfas408_queuecommand_lck(struct scsi_cmnd *cmd,
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
 	if (scmd_id(cmd) == priv->qinitid) {
-		cmd->result = DID_BAD_TARGET << 16;
+		set_host_byte(cmd, DID_BAD_TARGET);
 		done(cmd);
 		return 0;
 	}
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index cec9a14982e6..d892a0594ed1 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1172,7 +1172,7 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 			Cmnd->result =
 			    qlogicpti_return_status(sts, qpti->qpti_id);
 		else
-			Cmnd->result = DID_ERROR << 16;
+			set_host_byte(Cmnd, DID_ERROR);
 
 		if (scsi_bufflen(Cmnd))
 			dma_unmap_sg(&qpti->op->dev,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9cf6a80fe297..f38bd910d237 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1590,7 +1590,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	starget = scsi_target(sdev);
 	shost = sdev->host;
 	scsi_init_cmd_errh(cmd);
-	cmd->result = DID_NO_CONNECT << 16;
+	set_host_byte(cmd, DID_NO_CONNECT);
 	atomic_inc(&cmd->device->iorequest_cnt);
 
 	/*
@@ -1664,7 +1664,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		/* in SDEV_DEL we error all commands. DID_NO_CONNECT
 		 * returns an immediate error upwards, and signals
 		 * that the device is no longer present */
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		goto done;
 	}
 
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index d8a376b7882d..dc6a2d0a9d91 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2496,7 +2496,7 @@ snic_scsi_cleanup(struct snic *snic, int ex_tag)
 		snic_release_req_buf(snic, rqi, sc);
 
 cleanup:
-		sc->result = DID_TRANSPORT_DISRUPTED << 16;
+		set_host_byte(sc, DID_TRANSPORT_DISRUPTED);
 		SNIC_HOST_INFO(snic->shost,
 			       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, Tag %d flags 0x%llx rqi %p duration %u msecs\n",
 			       sc, sc->request->tag, CMD_FLAGS(sc), rqi,
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 9b20643ab49d..f4f2d6109c1c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -656,7 +656,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		break;
 	case INQUIRY:
 		if (lun >= host->max_lun) {
-			cmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(cmd, DID_NO_CONNECT);
 			done(cmd);
 			return 0;
 		}
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5e7200f05873..ead26330a764 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1515,7 +1515,7 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 	 * this. So, don't send it.
 	 */
 	case SET_WINDOW:
-		scmnd->result = ILLEGAL_REQUEST << 16;
+		set_host_byte(scmnd, ILLEGAL_REQUEST);
 		allowed = false;
 		break;
 	default:
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 74be04f2357c..1c147a7f9424 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -862,7 +862,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 			hostdata->selecting = NULL;
 		}
 
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->state = S_UNCONNECTED;
 		cmd->scsi_done(cmd);
@@ -1602,7 +1602,7 @@ wd33c93_host_reset(struct scsi_cmnd * SCpnt)
 	hostdata->outgoing_len = 0;
 
 	reset_wd33c93(instance);
-	SCpnt->result = DID_RESET << 16;
+	set_host_byte(SCpnt, DID_RESET);
 	enable_irq(instance->irq);
 	spin_unlock_irq(instance->host_lock);
 	return SUCCESS;
@@ -1637,7 +1637,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 				hostdata->input_Q =
 				    (struct scsi_cmnd *) cmd->host_scribble;
 			cmd->host_scribble = NULL;
-			cmd->result = DID_ABORT << 16;
+			set_host_byte(cmd, DID_ABORT);
 			printk
 			    ("scsi%d: Abort - removing command from input_Q. ",
 			     instance->host_no);
@@ -1711,7 +1711,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->connected = NULL;
 		hostdata->state = S_UNCONNECTED;
-		cmd->result = DID_ABORT << 16;
+		set_host_byte(cmd, DID_ABORT);
 
 /*      sti();*/
 		wd33c93_execute(instance);
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 2a9da2e0ea6b..8df90c55283c 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -193,7 +193,7 @@ static void wd719x_finish_cmd(struct scsi_cmnd *cmd, int result)
 				 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 		scsi_dma_unmap(cmd);
 	}
-	cmd->result = result << 16;
+	set_host_byte(cmd, result);
 	cmd->scsi_done(cmd);
 }
 
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 36f59a1be7e9..c7f8ea404a4b 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -551,7 +551,7 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		if (err == -ENOMEM)
 			return SCSI_MLQUEUE_HOST_BUSY;
-		sc->result = DID_ERROR << 16;
+		set_host_byte(sc, DID_ERROR);
 		sc->scsi_done(sc);
 		return 0;
 	}
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index 89e2cfe7d1cc..116e861b680d 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -145,7 +145,7 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	/* fail the command if we are disconnecting */
 	if (rtsx_chk_stat(chip, RTSX_STAT_DISCONNECT)) {
 		dev_info(&dev->pci->dev, "Fail command during disconnect\n");
-		srb->result = DID_NO_CONNECT << 16;
+		set_host_byte(srb, DID_NO_CONNECT);
 		done(srb);
 		return 0;
 	}
diff --git a/drivers/staging/rts5208/rtsx_transport.c b/drivers/staging/rts5208/rtsx_transport.c
index 8b57e17ee6d3..2321c0d8764a 100644
--- a/drivers/staging/rts5208/rtsx_transport.c
+++ b/drivers/staging/rts5208/rtsx_transport.c
@@ -172,14 +172,14 @@ void rtsx_invoke_transport(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	 */
 	if (rtsx_chk_stat(chip, RTSX_STAT_ABORT)) {
 		dev_dbg(rtsx_dev(chip), "-- command was aborted\n");
-		srb->result = DID_ABORT << 16;
+		set_host_byte(srb, DID_ABORT);
 		goto handle_errors;
 	}
 
 	/* if there is a transport error, reset and don't auto-sense */
 	if (result == TRANSPORT_ERROR) {
 		dev_dbg(rtsx_dev(chip), "-- transport indicates error, resetting\n");
-		srb->result = DID_ERROR << 16;
+		set_host_byte(srb, DID_ERROR);
 		goto handle_errors;
 	}
 
diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index 419dba89af06..9fba649c5044 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -388,7 +388,7 @@ static int visorhba_abort_handler(struct scsi_cmnd *scsicmd)
 		atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
 	rtn = forward_taskmgmt_command(TASK_MGMT_ABORT_TASK, scsidev);
 	if (rtn == SUCCESS) {
-		scsicmd->result = DID_ABORT << 16;
+		set_host_byte(scsicmd, DID_ABORT);
 		scsicmd->scsi_done(scsicmd);
 	}
 	return rtn;
@@ -415,7 +415,7 @@ static int visorhba_device_reset_handler(struct scsi_cmnd *scsicmd)
 		atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
 	rtn = forward_taskmgmt_command(TASK_MGMT_LUN_RESET, scsidev);
 	if (rtn == SUCCESS) {
-		scsicmd->result = DID_RESET << 16;
+		set_host_byte(scsicmd, DID_RESET);
 		scsicmd->scsi_done(scsicmd);
 	}
 	return rtn;
@@ -444,7 +444,7 @@ static int visorhba_bus_reset_handler(struct scsi_cmnd *scsicmd)
 	}
 	rtn = forward_taskmgmt_command(TASK_MGMT_BUS_RESET, scsidev);
 	if (rtn == SUCCESS) {
-		scsicmd->result = DID_RESET << 16;
+		set_host_byte(scsicmd, DID_RESET);
 		scsicmd->scsi_done(scsicmd);
 	}
 	return rtn;
@@ -760,7 +760,7 @@ static void visorhba_serverdown_complete(struct visorhba_devdata *devdata)
 		switch (pendingdel->cmdtype) {
 		case CMD_SCSI_TYPE:
 			scsicmd = pendingdel->sent;
-			scsicmd->result = DID_RESET << 16;
+			set_host_byte(scsicmd, DID_RESET);
 			if (scsicmd->scsi_done)
 				scsicmd->scsi_done(scsicmd);
 			break;
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 0b21ba757bba..fd49c47495f2 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -582,7 +582,7 @@ mts_scsi_queuecommand_lck(struct scsi_cmnd *srb, mts_scsi_cmnd_callback callback
 
 		MTS_DEBUG("this device doesn't exist\n");
 
-		srb->result = DID_BAD_TARGET << 16;
+		set_host_byte(srb, DID_BAD_TARGET);
 
 		if(likely(callback != NULL))
 			callback(srb);
@@ -609,7 +609,7 @@ mts_scsi_queuecommand_lck(struct scsi_cmnd *srb, mts_scsi_cmnd_callback callback
 
 	if(unlikely(res)){
 		MTS_ERROR("error %d submitting URB\n",(int)res);
-		srb->result = DID_ERROR << 16;
+		set_host_byte(srb, DID_ERROR);
 
 		if(likely(callback != NULL))
 			callback(srb);
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 6a7720e66595..2e08d10d53cf 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -657,13 +657,13 @@ static void isd200_invoke_transport( struct us_data *us,
 
 	case USB_STOR_TRANSPORT_ERROR:
 		usb_stor_dbg(us, "-- transport indicates transport error\n");
-		srb->result = DID_ERROR << 16;
+		set_host_byte(srb, DID_ERROR);
 		/* Need reset here */
 		return;
     
 	default:
 		usb_stor_dbg(us, "-- transport indicates unknown error\n");
-		srb->result = DID_ERROR << 16;
+		set_host_byte(srb, DID_ERROR);
 		/* Need reset here */
 		return;
 	}
@@ -692,7 +692,7 @@ static void isd200_invoke_transport( struct us_data *us,
 			if ((srb->sense_buffer[2] & 0xf) == 0x0)
 				srb->result = SAM_STAT_GOOD;
 		} else {
-			srb->result = DID_ERROR << 16;
+			set_host_byte(srb, DID_ERROR);
 			/* Need reset here */
 		}
 	}
@@ -710,7 +710,7 @@ static void isd200_invoke_transport( struct us_data *us,
 	 * following an abort
 	 */
 	Handle_Abort:
-	srb->result = DID_ABORT << 16;
+	set_host_byte(srb, DID_ABORT);
 
 	/* permit the reset transfer to take place */
 	clear_bit(US_FLIDX_ABORTING, &us->dflags);
@@ -1430,7 +1430,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 	default:
 		usb_stor_dbg(us, "Unsupported SCSI command - 0x%X\n",
 			     srb->cmnd[0]);
-		srb->result = DID_ERROR << 16;
+		set_host_byte(srb, DID_ERROR);
 		sendToTransport = 0;
 		break;
 	}
@@ -1531,7 +1531,7 @@ static void isd200_ata_command(struct scsi_cmnd *srb, struct us_data *us)
 
 	if (us->extra == NULL) {
 		usb_stor_dbg(us, "ERROR Driver not initialized\n");
-		srb->result = DID_ERROR << 16;
+		set_host_byte(srb, DID_ERROR);
 		return;
 	}
 
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 8cd2926fb1fe..122bb939d831 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -387,7 +387,7 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	/* fail the command if we are disconnecting */
 	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
 		usb_stor_dbg(us, "Fail command during disconnect\n");
-		srb->result = DID_NO_CONNECT << 16;
+		set_host_byte(srb, DID_NO_CONNECT);
 		done(srb);
 		return 0;
 	}
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index a3ccb899df60..d95afdfa101a 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -627,14 +627,14 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 		usb_stor_dbg(us, "-- command was aborted\n");
-		srb->result = DID_ABORT << 16;
+		set_host_byte(srb, DID_ABORT);
 		goto Handle_Errors;
 	}
 
 	/* if there is a transport error, reset and don't auto-sense */
 	if (result == USB_STOR_TRANSPORT_ERROR) {
 		usb_stor_dbg(us, "-- transport indicates error, resetting\n");
-		srb->result = DID_ERROR << 16;
+		set_host_byte(srb, DID_ERROR);
 		goto Handle_Errors;
 	}
 
@@ -738,7 +738,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 			usb_stor_dbg(us, "-- auto-sense aborted\n");
-			srb->result = DID_ABORT << 16;
+			set_host_byte(srb, DID_ABORT);
 
 			/* If SANE_SENSE caused this problem, disable it */
 			if (sense_size != US_SENSE_SIZE) {
@@ -772,7 +772,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			 * multi-target device, since failure of an
 			 * auto-sense is perfectly valid
 			 */
-			srb->result = DID_ERROR << 16;
+			set_host_byte(srb, DID_ERROR);
 			if (!(us->fflags & US_FL_SCM_MULT_TARG))
 				goto Handle_Errors;
 			return;
@@ -853,7 +853,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			 * entering an infinite retry loop.
 			 */
 			else {
-				srb->result = DID_ERROR << 16;
+				set_host_byte(srb, DID_ERROR);
 				if ((sshdr.response_code & 0x72) == 0x72)
 					srb->sense_buffer[1] = HARDWARE_ERROR;
 				else
@@ -886,7 +886,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		 */
 		if (test_bit(US_FLIDX_REDO_READ10, &us->dflags)) {
 			clear_bit(US_FLIDX_REDO_READ10, &us->dflags);
-			srb->result = DID_IMM_RETRY << 16;
+			set_host_byte(srb, DID_IMM_RETRY);
 			srb->sense_buffer[0] = 0;
 		}
 	}
@@ -894,7 +894,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/* Did we transfer less than the minimum amount required? */
 	if ((srb->result == SAM_STAT_GOOD || srb->sense_buffer[2] == 0) &&
 			scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
-		srb->result = DID_ERROR << 16;
+		set_host_byte(srb, DID_ERROR);
 
 	last_sector_hacks(us, srb);
 	return;
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 63cf981ed81c..44afa5faab22 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -143,7 +143,7 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 		uas_log_cmd_state(cmnd, __func__, 0);
 		/* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
 		cmdinfo->state &= ~COMMAND_INFLIGHT;
-		cmnd->result = result << 16;
+		set_host_byte(cmnd, result);
 		err = uas_try_complete(cmnd, __func__);
 		WARN_ON(err != 0);
 	}
@@ -252,17 +252,17 @@ static bool uas_evaluate_response_iu(struct response_iu *riu, struct scsi_cmnd *
 
 	switch (response_code) {
 	case RC_INCORRECT_LUN:
-		cmnd->result = DID_BAD_TARGET << 16;
+		set_host_byte(cmnd, DID_BAD_TARGET);
 		break;
 	case RC_TMF_SUCCEEDED:
-		cmnd->result = DID_OK << 16;
+		set_host_byte(cmnd, DID_OK);
 		break;
 	case RC_TMF_NOT_SUPPORTED:
-		cmnd->result = DID_TARGET_FAILURE << 16;
+		set_host_byte(cmnd, DID_TARGET_FAILURE);
 		break;
 	default:
 		uas_log_cmd_state(cmnd, "response iu", response_code);
-		cmnd->result = DID_ERROR << 16;
+		set_host_byte(cmnd, DID_ERROR);
 		break;
 	}
 
@@ -640,7 +640,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	spin_lock_irqsave(&devinfo->lock, flags);
 
 	if (devinfo->resetting) {
-		cmnd->result = DID_ERROR << 16;
+		set_host_byte(cmnd, DID_ERROR);
 		cmnd->scsi_done(cmnd);
 		spin_unlock_irqrestore(&devinfo->lock, flags);
 		return 0;
-- 
2.13.6
