From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ADVANSYS] Add basic highmem/DMA support
Date: Wed, 23 Jun 2004 15:13:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040623141335.GA23365@infradead.org>
References: <20040508003906.GA26338@gondor.apana.org.au> <20040519103800.GA9891@gondor.apana.org.au> <1086026538.2004.7.camel@mulgrave> <40D69F56.2000307@torque.net> <1087828082.1797.17.camel@mulgrave> <40D924A5.5020705@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:17303 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265135AbUFWONq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 10:13:46 -0400
Content-Disposition: inline
In-Reply-To: <40D924A5.5020705@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Herbert Xu <herbert@gondor.apana.org.au>, Gene Heskett <gene.heskett@verizon.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

There were actually two patches to advansys in that timeframe.  Although
it's much more likely that the dma api patch is the culprit can you test
with the compat code cleanup patch below reversed?:


# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/04 09:13:16-05:00 hch@lst.de 
#   [PATCH] kill dead compat code in advansys
#   
#   I actually wanted to fix up the check_region usage there but got lost
#   in the mess.  Let's start by kicking out the 2.2 compat and using scsi
#   layer constants instead of their own redefinitions first.
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# drivers/scsi/advansys.c
#   2004/06/04 06:19:50-05:00 hch@lst.de +119 -508
#   kill dead compat code in advansys
# 
diff -Nru a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c	2004-06-23 07:12:13 -07:00
+++ b/drivers/scsi/advansys.c	2004-06-23 07:12:13 -07:00
@@ -756,27 +756,6 @@
 
 */
 
-
-/*
- * --- Linux Version
- */
-
-#ifndef LINUX_VERSION_CODE
-#include <linux/version.h>
-#endif /* LINUX_VERSION_CODE */
-
-/* Convert Linux Version, Patch-level, Sub-level to LINUX_VERSION_CODE. */
-#define ASC_LINUX_VERSION(V, P, S)    (((V) * 65536) + ((P) * 256) + (S))
-#define ASC_LINUX_KERNEL22 (LINUX_VERSION_CODE < ASC_LINUX_VERSION(2,4,0))
-#define ASC_LINUX_KERNEL24 (LINUX_VERSION_CODE >= ASC_LINUX_VERSION(2,4,0))
-
-/* Driver supported only in version 2.2 and version >= 2.4. */
-#if LINUX_VERSION_CODE < ASC_LINUX_VERSION(2,2,0) || \
-    (LINUX_VERSION_CODE > ASC_LINUX_VERSION(2,3,0) && \
-     LINUX_VERSION_CODE < ASC_LINUX_VERSION(2,4,0))
-#error "AdvanSys driver supported only in 2.2 and 2.4 or greater kernels."
-#endif
-
 /*
  * --- Linux Include Files
  */
@@ -875,9 +854,6 @@
 
 typedef unsigned char uchar;
 
-#ifndef NULL
-#define NULL     (0)
-#endif
 #ifndef TRUE
 #define TRUE     (1)
 #endif
@@ -987,49 +963,6 @@
 #define ASC_MIN_SENSE_LEN   14
 #define ASC_MAX_CDB_LEN     12
 #define ASC_SCSI_RESET_HOLD_TIME_US  60
-#define SCSICMD_TestUnitReady     0x00
-#define SCSICMD_Rewind            0x01
-#define SCSICMD_Rezero            0x01
-#define SCSICMD_RequestSense      0x03
-#define SCSICMD_Format            0x04
-#define SCSICMD_FormatUnit        0x04
-#define SCSICMD_Read6             0x08
-#define SCSICMD_Write6            0x0A
-#define SCSICMD_Seek6             0x0B
-#define SCSICMD_Inquiry           0x12
-#define SCSICMD_Verify6           0x13
-#define SCSICMD_ModeSelect6       0x15
-#define SCSICMD_ModeSense6        0x1A
-#define SCSICMD_StartStopUnit     0x1B
-#define SCSICMD_LoadUnloadTape    0x1B
-#define SCSICMD_ReadCapacity      0x25
-#define SCSICMD_Read10            0x28
-#define SCSICMD_Write10           0x2A
-#define SCSICMD_Seek10            0x2B
-#define SCSICMD_Erase10           0x2C
-#define SCSICMD_WriteAndVerify10  0x2E
-#define SCSICMD_Verify10          0x2F
-#define SCSICMD_WriteBuffer       0x3B
-#define SCSICMD_ReadBuffer        0x3C
-#define SCSICMD_ReadLong          0x3E
-#define SCSICMD_WriteLong         0x3F
-#define SCSICMD_ReadTOC           0x43
-#define SCSICMD_ReadHeader        0x44
-#define SCSICMD_ModeSelect10      0x55
-#define SCSICMD_ModeSense10       0x5A
-
-/* Inquiry Data Peripheral Device Types */
-#define SCSI_TYPE_DASD     0x00
-#define SCSI_TYPE_SASD     0x01
-#define SCSI_TYPE_PRN      0x02
-#define SCSI_TYPE_PROC     0x03
-#define SCSI_TYPE_WORM     0x04
-#define SCSI_TYPE_CDROM    0x05
-#define SCSI_TYPE_SCANNER  0x06
-#define SCSI_TYPE_OPTMEM   0x07
-#define SCSI_TYPE_MED_CHG  0x08
-#define SCSI_TYPE_COMM     0x09
-#define SCSI_TYPE_UNKNOWN  0x1F
 
 #define ADV_INQ_CLOCKING_ST_ONLY    0x0
 #define ADV_INQ_CLOCKING_DT_ONLY    0x1
@@ -1048,36 +981,11 @@
 #define ASC_SCSIDIR_T2H      0x08
 #define ASC_SCSIDIR_H2T      0x10
 #define ASC_SCSIDIR_NODATA   0x18
-#define SCSI_SENKEY_NO_SENSE      0x00
-#define SCSI_SENKEY_UNDEFINED     0x01
-#define SCSI_SENKEY_NOT_READY     0x02
-#define SCSI_SENKEY_MEDIUM_ERR    0x03
-#define SCSI_SENKEY_HW_ERR        0x04
-#define SCSI_SENKEY_ILLEGAL       0x05
-#define SCSI_SENKEY_ATTENTION     0x06
-#define SCSI_SENKEY_PROTECTED     0x07
-#define SCSI_SENKEY_BLANK         0x08
-#define SCSI_SENKEY_V_UNIQUE      0x09
-#define SCSI_SENKEY_CPY_ABORT     0x0A
-#define SCSI_SENKEY_ABORT         0x0B
-#define SCSI_SENKEY_EQUAL         0x0C
-#define SCSI_SENKEY_VOL_OVERFLOW  0x0D
-#define SCSI_SENKEY_MISCOMP       0x0E
-#define SCSI_SENKEY_RESERVED      0x0F
 #define SCSI_ASC_NOMEDIA          0x3A
 #define ASC_SRB_HOST(x)  ((uchar)((uchar)(x) >> 4))
 #define ASC_SRB_TID(x)   ((uchar)((uchar)(x) & (uchar)0x0F))
 #define ASC_SRB_LUN(x)   ((uchar)((uint)(x) >> 13))
 #define PUT_CDB1(x)   ((uchar)((uint)(x) >> 8))
-#define SS_GOOD              0x00
-#define SS_CHK_CONDITION     0x02
-#define SS_CONDITION_MET     0x04
-#define SS_TARGET_BUSY       0x08
-#define SS_INTERMID          0x10
-#define SS_INTERMID_COND_MET 0x14
-#define SS_RSERV_CONFLICT    0x18
-#define SS_CMD_TERMINATED    0x22
-#define SS_QUEUE_FULL        0x28
 #define MS_CMD_DONE    0x00
 #define MS_EXTEND      0x01
 #define MS_SDTR_LEN    0x03
@@ -1086,26 +994,6 @@
 #define MS_WDTR_CODE   0x03
 #define MS_MDP_LEN    0x05
 #define MS_MDP_CODE   0x00
-#define M1_SAVE_DATA_PTR        0x02
-#define M1_RESTORE_PTRS         0x03
-#define M1_DISCONNECT           0x04
-#define M1_INIT_DETECTED_ERR    0x05
-#define M1_ABORT                0x06
-#define M1_MSG_REJECT           0x07
-#define M1_NO_OP                0x08
-#define M1_MSG_PARITY_ERR       0x09
-#define M1_LINK_CMD_DONE        0x0A
-#define M1_LINK_CMD_DONE_WFLAG  0x0B
-#define M1_BUS_DVC_RESET        0x0C
-#define M1_ABORT_TAG            0x0D
-#define M1_CLR_QUEUE            0x0E
-#define M1_INIT_RECOVERY        0x0F
-#define M1_RELEASE_RECOVERY     0x10
-#define M1_KILL_IO_PROC         0x11
-#define M2_QTAG_MSG_SIMPLE      0x20
-#define M2_QTAG_MSG_HEAD        0x21
-#define M2_QTAG_MSG_ORDERED     0x22
-#define M2_IGNORE_WIDE_RESIDUE  0x23
 
 /*
  * Inquiry data structure and bitfield macros
@@ -3582,19 +3470,6 @@
 
 #define NO_ISA_DMA              0xff        /* No ISA DMA Channel Used */
 
-/*
- * If the Linux kernel version supports freeing initialization code
- * and data after loading, define macros for this purpose. These macros
- * are not used when the driver is built as a module, cf. linux/init.h.
- */
-#if ASC_LINUX_KERNEL24
-#define ASC_INITFUNC(type, func)        type __init func
-#elif ASC_LINUX_KERNEL22
-#define ASC_INITFUNC(type, func)        __initfunc(type func)
-#endif
-#define ASC_INITDATA                    __initdata
-#define ASC_INIT                        __init
-
 #define ASC_INFO_SIZE           128            /* advansys_info() line size */
 
 #ifdef CONFIG_PROC_FS
@@ -3611,8 +3486,6 @@
         } \
         cp += len; \
     }
-
-#define ASC_MIN(a, b) (((a) < (b)) ? (a) : (b))
 #endif /* CONFIG_PROC_FS */
 
 /* Asc Library return codes */
@@ -3686,53 +3559,6 @@
 /* Return non-zero, if the queue is empty. */
 #define ASC_QUEUE_EMPTY(ascq)    ((ascq)->q_tidmask == 0)
 
-/* PCI configuration declarations */
-
-#define PCI_BASE_CLASS_PREDEFINED               0x00
-#define PCI_BASE_CLASS_MASS_STORAGE             0x01
-#define PCI_BASE_CLASS_NETWORK                  0x02
-#define PCI_BASE_CLASS_DISPLAY                  0x03
-#define PCI_BASE_CLASS_MULTIMEDIA               0x04
-#define PCI_BASE_CLASS_MEMORY_CONTROLLER        0x05
-#define PCI_BASE_CLASS_BRIDGE_DEVICE            0x06
-
-/* MASS STORAGE */
-#define PCI_SUB_CLASS_SCSI_CONTROLLER           0x00
-#define PCI_SUB_CLASS_IDE_CONTROLLER            0x01
-#define PCI_SUB_CLASS_FLOPPY_DISK_CONTROLLER    0x02
-#define PCI_SUB_CLASS_IPI_BUS_CONTROLLER        0x03
-#define PCI_SUB_CLASS_OTHER_MASS_CONTROLLER     0x80
-
-/* NETWORK CONTROLLER */
-#define PCI_SUB_CLASS_ETHERNET_CONTROLLER       0x00
-#define PCI_SUB_CLASS_TOKEN_RING_CONTROLLER     0x01
-#define PCI_SUB_CLASS_FDDI_CONTROLLER           0x02
-#define PCI_SUB_CLASS_OTHER_NETWORK_CONTROLLER  0x80
-
-/* DISPLAY CONTROLLER */
-#define PCI_SUB_CLASS_VGA_CONTROLLER            0x00
-#define PCI_SUB_CLASS_XGA_CONTROLLER            0x01
-#define PCI_SUB_CLASS_OTHER_DISPLAY_CONTROLLER  0x80
-
-/* MULTIMEDIA CONTROLLER */
-#define PCI_SUB_CLASS_VIDEO_DEVICE              0x00
-#define PCI_SUB_CLASS_AUDIO_DEVICE              0x01
-#define PCI_SUB_CLASS_OTHER_MULTIMEDIA_DEVICE   0x80
-
-/* MEMORY CONTROLLER */
-#define PCI_SUB_CLASS_RAM_CONTROLLER            0x00
-#define PCI_SUB_CLASS_FLASH_CONTROLLER          0x01
-#define PCI_SUB_CLASS_OTHER_MEMORY_CONTROLLER   0x80
-
-/* BRIDGE CONTROLLER */
-#define PCI_SUB_CLASS_HOST_BRIDGE_CONTROLLER    0x00
-#define PCI_SUB_CLASS_ISA_BRIDGE_CONTROLLER     0x01
-#define PCI_SUB_CLASS_EISA_BRIDGE_CONTROLLER    0x02
-#define PCI_SUB_CLASS_MC_BRIDGE_CONTROLLER      0x03
-#define PCI_SUB_CLASS_PCI_TO_PCI_BRIDGE_CONTROLLER    0x04
-#define PCI_SUB_CLASS_PCMCIA_BRIDGE_CONTROLLER  0x05
-#define PCI_SUB_CLASS_OTHER_BRIDGE_CONTROLLER   0x80
-
 #define PCI_MAX_SLOT            0x1F
 #define PCI_MAX_BUS             0xFF
 #define PCI_IOADDRESS_MASK      0xFFFE
@@ -3745,25 +3571,6 @@
 #define ASC_PCI_DEVICE_ID_2500  0x2500  /* ASC-38C0800 */
 #define ASC_PCI_DEVICE_ID_2700  0x2700  /* ASC-38C1600 */
 
-/* PCI IO Port Addresses to generate special cycle */
-
-#define PCI_CONFIG_ADDRESS_MECH1          0x0CF8
-#define PCI_CONFIG_DATA_MECH1             0x0CFC
-
-#define PCI_CONFIG_FORWARD_REGISTER       0x0CFA    /* 0=type 0; 1=type 1; */
-
-#define PCI_CONFIG_BUS_NUMBER_MASK        0x00FF0000
-#define PCI_CONFIG_DEVICE_FUNCTION_MASK   0x0000FF00
-#define PCI_CONFIG_REGISTER_NUMBER_MASK   0x000000F8
-
-#define PCI_DEVICE_FOUND                0x0000
-#define PCI_DEVICE_NOT_FOUND            0xffff
-
-#define SUBCLASS_OFFSET         0x0A
-#define CLASSCODE_OFFSET        0x0B
-#define VENDORID_OFFSET         0x00
-#define DEVICEID_OFFSET         0x02
-
 #ifndef ADVANSYS_STATS
 #define ASC_STATS(shp, counter)
 #define ASC_STATS_ADD(shp, counter, count)
@@ -4146,19 +3953,6 @@
 
 /* Note: All driver global data should be initialized. */
 
-#if ASC_LINUX_KERNEL22
-#ifdef CONFIG_PROC_FS
-struct proc_dir_entry proc_scsi_advansys =
-{
-    PROC_SCSI_ADVANSYS,              /* unsigned short low_ino */
-    8,                               /* unsigned short namelen */
-    "advansys",                      /* const char *name */
-    S_IFDIR | S_IRUGO | S_IXUGO,     /* mode_t mode */
-    2                                /* nlink_t nlink */
-};
-#endif /* CONFIG_PROC_FS */
-#endif /* ASC_LINUX_KERNEL22 */
-
 /* Number of boards detected in system. */
 STATIC int asc_board_count = 0;
 STATIC struct Scsi_Host    *asc_host[ASC_NUM_BOARD_SUPPORTED] = { 0 };
@@ -4173,7 +3967,7 @@
 STATIC ASC_SG_HEAD asc_sg_head = { 0 };
 
 /* List of supported bus types. */
-STATIC ushort asc_bus[ASC_NUM_BUS] ASC_INITDATA = {
+STATIC ushort asc_bus[ASC_NUM_BUS] __initdata = {
     ASC_IS_ISA,
     ASC_IS_VL,
     ASC_IS_EISA,
@@ -4506,10 +4300,8 @@
  * it must not call SCSI mid-level functions including scsi_malloc()
  * and scsi_free().
  */
-ASC_INITFUNC(
-int,
+int __init
 advansys_detect(Scsi_Host_Template *tpnt)
-)
 {
     static int          detect_called = ASC_FALSE;
     int                 iop;
@@ -4552,12 +4344,6 @@
 
     ASC_DBG(1, "advansys_detect: begin\n");
 
-#if ASC_LINUX_KERNEL24
-    tpnt->proc_name = "advansys";
-#elif ASC_LINUX_KERNEL22
-    tpnt->proc_dir = &proc_scsi_advansys;
-#endif
-
     asc_board_count = 0;
 
     /*
@@ -4683,13 +4469,9 @@
                             NULL) {
                             pci_device_id_cnt++;
                         } else {
-#if ASC_LINUX_KERNEL24
                             if (pci_enable_device(pci_devp) == 0) {
                                 pci_devicep[pci_card_cnt_max++] = pci_devp;
                             }
-#elif ASC_LINUX_KERNEL22
-                            pci_devicep[pci_card_cnt_max++] = pci_devp;
-#endif
                         }
                     }
 
@@ -4726,11 +4508,7 @@
                     ASC_DBG2(2,
                         "advansys_detect: devfn %d, bus number %d\n",
                         pci_devp->devfn, pci_devp->bus->number);
-#if ASC_LINUX_KERNEL24
                     iop = pci_resource_start(pci_devp, 0);
-#elif ASC_LINUX_KERNEL22
-                    iop = pci_devp->base_address[0] & PCI_IOADDRESS_MASK;
-#endif
                     ASC_DBG2(1,
                         "advansys_detect: vendorID %X, deviceID %X\n",
                         pci_devp->vendor, pci_devp->device);
@@ -4854,11 +4632,7 @@
                     iolen = ADV_38C1600_IOLEN;
                 }
 #ifdef CONFIG_PCI
-#if ASC_LINUX_KERNEL24
                 pci_memory_address = pci_resource_start(pci_devp, 1);
-#elif ASC_LINUX_KERNEL22
-                pci_memory_address = pci_devp->base_address[1];
-#endif
                 ASC_DBG1(1, "advansys_detect: pci_memory_address: 0x%lx\n",
                     (ulong) pci_memory_address);
                 if ((boardp->ioremap_addr =
@@ -5326,11 +5100,7 @@
 
             /* BIOS start address. */
             if (ASC_NARROW_BOARD(boardp)) {
-#if ASC_LINUX_KERNEL24
                 shp->base =
-#elif ASC_LINUX_KERNEL22
-                shp->base = (char *)
-#endif
                         ((ulong) AscGetChipBiosAddress(
                             asc_dvc_varp->iop_base,
                             asc_dvc_varp->bus_type));
@@ -5365,11 +5135,7 @@
                      * Convert x86 realmode code segment to a linear
                      * address by shifting left 4.
                      */
-                    shp->base =
-#if ASC_LINUX_KERNEL22
-                        (char *)
-#endif
-                        ((ulong) boardp->bios_codeseg << 4);
+                    shp->base = ((ulong) boardp->bios_codeseg << 4);
                 } else {
                     shp->base = 0;
                 }
@@ -5390,7 +5156,6 @@
             ASC_DBG2(2,
                 "advansys_detect: request_region port 0x%lx, len 0x%x\n",
                 (ulong) shp->io_port, boardp->asc_n_io_port);
-#if ASC_LINUX_KERNEL24
             if (request_region(shp->io_port, boardp->asc_n_io_port,
                                "advansys") == NULL) {
                 ASC_PRINT3(
@@ -5403,9 +5168,6 @@
                 asc_board_count--;
                 continue;
             }
-#elif ASC_LINUX_KERNEL22
-            request_region(shp->io_port, boardp->asc_n_io_port, "advansys");
-#endif
 
             /* Register DMA Channel for Narrow boards. */
             shp->dma_channel = NO_ISA_DMA; /* Default to no ISA DMA. */
@@ -6154,10 +5916,8 @@
  * ints[2] - second argument
  * ...
  */
-ASC_INITFUNC(
-void,
+void __init
 advansys_setup(char *str, int *ints)
-)
 {
     int    i;
 
@@ -6687,9 +6447,9 @@
      */
     if ((boardp->dvc_var.asc_dvc_var.cur_dvc_qng[scp->device->id] > 0) &&
         (boardp->reqcnt[scp->device->id] % 255) == 0) {
-        asc_scsi_q.q2.tag_code = M2_QTAG_MSG_ORDERED;
+        asc_scsi_q.q2.tag_code = MSG_ORDERED_TAG;
     } else {
-        asc_scsi_q.q2.tag_code = M2_QTAG_MSG_SIMPLE;
+        asc_scsi_q.q2.tag_code = MSG_SIMPLE_TAG;
     }
 
     /*
@@ -7123,14 +6883,13 @@
          * If an INQUIRY command completed successfully, then call
          * the AscInquiryHandling() function to set-up the device.
          */
-        if (scp->cmnd[0] == SCSICMD_Inquiry && scp->device->lun == 0 &&
+        if (scp->cmnd[0] == INQUIRY && scp->device->lun == 0 &&
             (scp->request_bufflen - qdonep->remain_bytes) >= 8)
         {
             AscInquiryHandling(asc_dvc_varp, scp->device->id & 0x7,
                 (ASC_SCSI_INQUIRY *) scp->request_buffer);
         }
 
-#if ASC_LINUX_KERNEL24
         /*
          * Check for an underrun condition.
          *
@@ -7143,15 +6902,14 @@
             (unsigned) qdonep->remain_bytes);
             scp->resid = qdonep->remain_bytes;
         }
-#endif
         break;
 
     case QD_WITH_ERROR:
         ASC_DBG(2, "asc_isr_callback: QD_WITH_ERROR\n");
         switch (qdonep->d3.host_stat) {
         case QHSTA_NO_ERROR:
-            if (qdonep->d3.scsi_stat == SS_CHK_CONDITION) {
-                ASC_DBG(2, "asc_isr_callback: SS_CHK_CONDITION\n");
+            if (qdonep->d3.scsi_stat == SAM_STAT_CHECK_CONDITION) {
+                ASC_DBG(2, "asc_isr_callback: SAM_STAT_CHECK_CONDITION\n");
                 ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
                     sizeof(scp->sense_buffer));
                 /*
@@ -7229,9 +6987,7 @@
     Scsi_Cmnd           *scp;
     struct Scsi_Host    *shp;
     int                 i;
-#if ASC_LINUX_KERNEL24
     ADV_DCNT            resid_cnt;
-#endif
 
 
     ASC_DBG2(1, "adv_isr_callback: adv_dvc_varp 0x%lx, scsiqp 0x%lx\n",
@@ -7314,7 +7070,6 @@
         ASC_DBG(2, "adv_isr_callback: QD_NO_ERROR\n");
         scp->result = 0;
 
-#if ASC_LINUX_KERNEL24
         /*
          * Check for an underrun condition.
          *
@@ -7328,15 +7083,14 @@
                 (ulong) resid_cnt);
             scp->resid = resid_cnt;
         }
-#endif
         break;
 
     case QD_WITH_ERROR:
         ASC_DBG(2, "adv_isr_callback: QD_WITH_ERROR\n");
         switch (scsiqp->host_status) {
         case QHSTA_NO_ERROR:
-            if (scsiqp->scsi_status == SS_CHK_CONDITION) {
-                ASC_DBG(2, "adv_isr_callback: SS_CHK_CONDITION\n");
+            if (scsiqp->scsi_status == SAM_STAT_CHECK_CONDITION) {
+                ASC_DBG(2, "adv_isr_callback: SAM_STAT_CHECK_CONDITION\n");
                 ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
                     sizeof(scp->sense_buffer));
                 /*
@@ -8902,7 +8656,7 @@
             (unsigned) offset, (unsigned) advoffset, cplen);
     if (offset <= advoffset) {
         /* Read offset below current offset, copy everything. */
-        cnt = ASC_MIN(cplen, leftlen);
+        cnt = min(cplen, leftlen);
         ASC_DBG3(2, "asc_proc_copy: curbuf 0x%lx, cp 0x%lx, cnt %d\n",
                 (ulong) curbuf, (ulong) cp, cnt);
         memcpy(curbuf, cp, cnt);
@@ -8910,7 +8664,7 @@
         /* Read offset within current range, partial copy. */
         cnt = (advoffset + cplen) - offset;
         cp = (cp + cplen) - cnt;
-        cnt = ASC_MIN(cnt, leftlen);
+        cnt = min(cnt, leftlen);
         ASC_DBG3(2, "asc_proc_copy: curbuf 0x%lx, cp 0x%lx, cnt %d\n",
                 (ulong) curbuf, (ulong) cp, cnt);
         memcpy(curbuf, cp, cnt);
@@ -8943,7 +8697,7 @@
         (void) printk(s);
         ret = 0;
     } else {
-        ret = ASC_MIN(buflen, ret);
+        ret = min(buflen, ret);
         memcpy(buf, s, ret);
     }
     va_end(args);
@@ -9046,12 +8800,10 @@
 /*
  * Read a PCI configuration byte.
  */
-ASC_INITFUNC(
-STATIC uchar,
+STATIC uchar __init
 DvcReadPCIConfigByte(
         ASC_DVC_VAR *asc_dvc,
         ushort offset)
-)
 {
 #ifdef CONFIG_PCI
     uchar byte_data;
@@ -9065,13 +8817,11 @@
 /*
  * Write a PCI configuration byte.
  */
-ASC_INITFUNC(
-STATIC void,
+STATIC void __init
 DvcWritePCIConfigByte(
         ASC_DVC_VAR *asc_dvc,
         ushort offset,
         uchar  byte_data)
-)
 {
 #ifdef CONFIG_PCI
     pci_write_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, byte_data);
@@ -9082,13 +8832,10 @@
  * Return the BIOS address of the adapter at the specified
  * I/O port and with the specified bus type.
  */
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscGetChipBiosAddress(
         PortAddr iop_base,
-        ushort bus_type
-)
-)
+        ushort bus_type)
 {
     ushort  cfg_lsw;
     ushort  bios_addr;
@@ -9163,12 +8910,10 @@
 /*
  * Read a PCI configuration byte.
  */
-ASC_INITFUNC(
-STATIC uchar,
+STATIC uchar __init
 DvcAdvReadPCIConfigByte(
         ADV_DVC_VAR *asc_dvc,
         ushort offset)
-)
 {
 #ifdef CONFIG_PCI
     uchar byte_data;
@@ -9182,13 +8927,11 @@
 /*
  * Write a PCI configuration byte.
  */
-ASC_INITFUNC(
-STATIC void,
+STATIC void __init
 DvcAdvWritePCIConfigByte(
         ADV_DVC_VAR *asc_dvc,
         ushort offset,
         uchar  byte_data)
-)
 {
 #ifdef CONFIG_PCI
     pci_write_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, byte_data);
@@ -9402,16 +9145,6 @@
         s->host_busy, s->host_no,
         (unsigned) s->last_reset);
 
-#if ASC_LINUX_KERNEL24
-    printk(
-" hostt 0x%lx\n",
-        (ulong) s->hostt);
-#elif ASC_LINUX_KERNEL22
-    printk(
-" host_queue 0x%lx, hostt 0x%lx, block 0x%lx,\n",
-        (ulong) s->host_queue, (ulong) s->hostt, (ulong) s->block);
-#endif
-
     printk(
 " base 0x%lx, io_port 0x%lx, n_io_port %u, irq 0x%x,\n",
         (ulong) s->base, (ulong) s->io_port, s->n_io_port, s->irq);
@@ -9448,11 +9181,9 @@
 
     asc_prt_hex(" CDB", s->cmnd, s->cmd_len);
 
-#if ASC_LINUX_KERNEL24
     printk (
 "sc_data_direction %u, resid %d\n",
         s->sc_data_direction, s->resid);
-#endif
 
     printk(
 " use_sg %u, sglist_len %u, abort_reason 0x%x\n",
@@ -9467,15 +9198,9 @@
 " timeout_per_command %d, timeout_total %d, timeout %d\n",
         s->timeout_per_command, s->timeout_total, s->timeout);
 
-#if ASC_LINUX_KERNEL24
     printk(
 " internal_timeout %u, flags %u\n",
         s->internal_timeout, s->flags);
-#elif ASC_LINUX_KERNEL22
-    printk(
-" internal_timeout %u, flags %u, this_count %d\n",
-        s->internal_timeout, s->flags,s->this_count);
-#endif
 
     printk(
 " scsi_done 0x%lx, done 0x%lx, host_scribble 0x%lx, result 0x%x\n",
@@ -9832,12 +9557,9 @@
  * --- Asc Library Functions
  */
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscGetEisaChipCfg(
-                     PortAddr iop_base
-)
-)
+                     PortAddr iop_base)
 {
     PortAddr            eisa_cfg_iop;
 
@@ -9846,13 +9568,11 @@
     return (inpw(eisa_cfg_iop));
 }
 
-ASC_INITFUNC(
-STATIC uchar,
+STATIC uchar __init
 AscSetChipScsiID(
                     PortAddr iop_base,
                     uchar new_host_id
 )
-)
 {
     ushort              cfg_lsw;
 
@@ -9866,12 +9586,9 @@
     return (AscGetChipScsiID(iop_base));
 }
 
-ASC_INITFUNC(
-STATIC uchar,
+STATIC uchar __init
 AscGetChipScsiCtrl(
-                      PortAddr iop_base
-)
-)
+		PortAddr iop_base)
 {
     uchar               sc;
 
@@ -9881,13 +9598,11 @@
     return (sc);
 }
 
-ASC_INITFUNC(
-STATIC uchar,
+STATIC uchar __init
 AscGetChipVersion(
                      PortAddr iop_base,
                      ushort bus_type
 )
-)
 {
     if ((bus_type & ASC_IS_EISA) != 0) {
         PortAddr            eisa_iop;
@@ -9900,12 +9615,9 @@
     return (AscGetChipVerNo(iop_base));
 }
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscGetChipBusType(
-                     PortAddr iop_base
-)
-)
+                     PortAddr iop_base)
 {
     ushort              chip_ver;
 
@@ -9985,22 +9697,19 @@
     return (0);
 }
 
-STATIC PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] ASC_INITDATA =
+STATIC PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __initdata =
 {
     0x100, ASC_IOADR_1, 0x120, ASC_IOADR_2, 0x140, ASC_IOADR_3, ASC_IOADR_4,
     ASC_IOADR_5, ASC_IOADR_6, ASC_IOADR_7, ASC_IOADR_8
 };
 
 #ifdef CONFIG_ISA
-STATIC uchar _isa_pnp_inited ASC_INITDATA = 0;
+STATIC uchar _isa_pnp_inited __initdata = 0;
 
-ASC_INITFUNC(
-STATIC PortAddr,
+STATIC PortAddr __init
 AscSearchIOPortAddr(
                        PortAddr iop_beg,
-                       ushort bus_type
-)
-)
+                       ushort bus_type)
 {
     if (bus_type & ASC_IS_VL) {
         while ((iop_beg = AscSearchIOPortAddr11(iop_beg)) != 0) {
@@ -10031,12 +9740,10 @@
     return (0);
 }
 
-ASC_INITFUNC(
-STATIC PortAddr,
+STATIC PortAddr __init
 AscSearchIOPortAddr11(
                          PortAddr s_addr
 )
-)
 {
     int                 i;
     PortAddr            iop_base;
@@ -10062,11 +9769,8 @@
     return (0);
 }
 
-ASC_INITFUNC(
-STATIC void,
-AscSetISAPNPWaitForKey(
-    void)
-)
+STATIC void __init
+AscSetISAPNPWaitForKey(void)
 {
     outp(ASC_ISA_PNP_PORT_ADDR, 0x02);
     outp(ASC_ISA_PNP_PORT_WRITE, 0x02);
@@ -10074,25 +9778,20 @@
 }
 #endif /* CONFIG_ISA */
 
-ASC_INITFUNC(
-STATIC void,
+STATIC void __init
 AscToggleIRQAct(
                    PortAddr iop_base
 )
-)
 {
     AscSetChipStatus(iop_base, CIW_IRQ_ACT);
     AscSetChipStatus(iop_base, 0);
     return;
 }
 
-ASC_INITFUNC(
-STATIC uchar,
+STATIC uchar __init
 AscGetChipIRQ(
                  PortAddr iop_base,
-                 ushort bus_type
-)
-)
+                 ushort bus_type)
 {
     ushort              cfg_lsw;
     uchar               chip_irq;
@@ -10122,14 +9821,11 @@
     return ((uchar) (chip_irq + ASC_MIN_IRQ_NO));
 }
 
-ASC_INITFUNC(
-STATIC uchar,
+STATIC uchar __init
 AscSetChipIRQ(
                  PortAddr iop_base,
                  uchar irq_no,
-                 ushort bus_type
-)
-)
+                 ushort bus_type)
 {
     ushort              cfg_lsw;
 
@@ -10164,12 +9860,9 @@
 }
 
 #ifdef CONFIG_ISA
-ASC_INITFUNC(
-STATIC void,
+STATIC void __init
 AscEnableIsaDma(
-                   uchar dma_channel
-)
-)
+                   uchar dma_channel)
 {
     if (dma_channel < 4) {
         outp(0x000B, (ushort) (0xC0 | dma_channel));
@@ -10330,7 +10023,7 @@
             return (0);
         } else {
 
-            ext_msg.msg_type = M1_MSG_REJECT;
+            ext_msg.msg_type = MESSAGE_REJECT;
             AscMemWordCopyPtrToLram(iop_base,
                                  ASCV_MSGOUT_BEG,
                                  (uchar *) &ext_msg,
@@ -10430,7 +10123,7 @@
                              (ushort) ASCV_SCSIBUSY_B, scsi_busy);
             asc_dvc->queue_full_or_busy |= target_id;
 
-            if (scsi_status == SS_QUEUE_FULL) {
+            if (scsi_status == SAM_STAT_TASK_SET_FULL) {
                 if (cur_dvc_qng > ASC_MIN_TAGGED_CMD) {
                     cur_dvc_qng -= 1;
                     asc_dvc->max_dvc_qng[tid_no] = cur_dvc_qng;
@@ -10777,7 +10470,7 @@
             } else {
                 if ((AscReadLramByte(iop_base,
                           (ushort) (q_addr + (ushort) ASC_SCSIQ_CDB_BEG)) ==
-                     SCSICMD_StartStopUnit)) {
+                     START_STOP)) {
                     asc_dvc->unit_not_ready &= ~target_id;
                     if (scsiq->d3.done_stat != QD_NO_ERROR) {
                         asc_dvc->start_motor &= ~target_id;
@@ -11050,14 +10743,14 @@
 #define ASC_SYN_OFFSET_ONE_DISABLE_LIST  16
 STATIC uchar _syn_offset_one_disable_cmd[ASC_SYN_OFFSET_ONE_DISABLE_LIST] =
 {
-    SCSICMD_Inquiry,
-    SCSICMD_RequestSense,
-    SCSICMD_ReadCapacity,
-    SCSICMD_ReadTOC,
-    SCSICMD_ModeSelect6,
-    SCSICMD_ModeSense6,
-    SCSICMD_ModeSelect10,
-    SCSICMD_ModeSense10,
+    INQUIRY,
+    REQUEST_SENSE,
+    READ_CAPACITY,
+    READ_TOC,
+    MODE_SELECT,
+    MODE_SENSE,
+    MODE_SELECT_10,
+    MODE_SENSE_10,
     0xFF,
     0xFF,
     0xFF,
@@ -11110,7 +10803,7 @@
     target_ix = scsiq->q2.target_ix;
     tid_no = ASC_TIX_TO_TID(target_ix);
     n_q_required = 1;
-    if (scsiq->cdbptr[0] == SCSICMD_RequestSense) {
+    if (scsiq->cdbptr[0] == REQUEST_SENSE) {
         if ((asc_dvc->init_sdtr & scsiq->q1.target_id) != 0) {
             asc_dvc->sdtr_done &= ~scsiq->q1.target_id;
             sdtr_data = AscGetMCodeInitSDTRAtID(iop_base, tid_no);
@@ -11179,7 +10872,7 @@
         }
     }
     if (disable_syn_offset_one_fix) {
-        scsiq->q2.tag_code &= ~M2_QTAG_MSG_SIMPLE;
+        scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
         scsiq->q2.tag_code |= (ASC_TAG_FLAG_DISABLE_ASYN_USE_SYN_FIX |
                                ASC_TAG_FLAG_DISABLE_DISCONNECT);
     } else {
@@ -11188,8 +10881,8 @@
     if ((scsiq->q1.cntl & QC_SG_HEAD) != 0) {
         if (asc_dvc->bug_fix_cntl) {
             if (asc_dvc->bug_fix_cntl & ASC_BUG_FIX_IF_NOT_DWB) {
-                if ((scsi_cmd == SCSICMD_Read6) ||
-                    (scsi_cmd == SCSICMD_Read10)) {
+                if ((scsi_cmd == READ_6) ||
+                    (scsi_cmd == READ_10)) {
                     addr =
                         (ADV_PADDR) le32_to_cpu(
                             sg_head->sg_list[sg_entry_cnt_minus_one].addr) +
@@ -11238,8 +10931,8 @@
     } else {
         if (asc_dvc->bug_fix_cntl) {
             if (asc_dvc->bug_fix_cntl & ASC_BUG_FIX_IF_NOT_DWB) {
-                if ((scsi_cmd == SCSICMD_Read6) ||
-                    (scsi_cmd == SCSICMD_Read10)) {
+                if ((scsi_cmd == READ_6) ||
+                    (scsi_cmd == READ_10)) {
                     addr = le32_to_cpu(scsiq->q1.data_addr) +
                         le32_to_cpu(scsiq->q1.data_cnt);
                     extra_bytes = (uchar) ((ushort) addr & 0x0003);
@@ -11410,7 +11103,7 @@
     }
     q_addr = ASC_QNO_TO_QADDR(q_no);
     if ((scsiq->q1.target_id & asc_dvc->use_tagged_qng) == 0) {
-        scsiq->q2.tag_code &= ~M2_QTAG_MSG_SIMPLE;
+        scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG ;
     }
     scsiq->q1.status = QS_FREE;
     AscMemWordCopyPtrToLram(iop_base,
@@ -11907,12 +11600,9 @@
 }
 
 #ifdef CONFIG_ISA
-ASC_INITFUNC(
-STATIC ASC_DCNT,
+STATIC ASC_DCNT __init
 AscGetEisaProductID(
-                       PortAddr iop_base
-)
-)
+                       PortAddr iop_base)
 {
     PortAddr            eisa_iop;
     ushort              product_id_high, product_id_low;
@@ -11926,12 +11616,9 @@
     return (product_id);
 }
 
-ASC_INITFUNC(
-STATIC PortAddr,
+STATIC PortAddr __init
 AscSearchIOPortAddrEISA(
-                           PortAddr iop_base
-)
-)
+                           PortAddr iop_base)
 {
     ASC_DCNT            eisa_product_id;
 
@@ -12125,12 +11812,9 @@
     return (AscIsChipHalted(iop_base));
 }
 
-ASC_INITFUNC(
-STATIC ASC_DCNT,
+STATIC ASC_DCNT __init
 AscGetMaxDmaCount(
-                     ushort bus_type
-)
-)
+                     ushort bus_type)
 {
     if (bus_type & ASC_IS_ISA)
         return (ASC_MAX_ISA_DMA_COUNT);
@@ -12140,12 +11824,9 @@
 }
 
 #ifdef CONFIG_ISA
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscGetIsaDmaChannel(
-                       PortAddr iop_base
-)
-)
+                       PortAddr iop_base)
 {
     ushort              channel;
 
@@ -12157,13 +11838,10 @@
     return (channel + 4);
 }
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscSetIsaDmaChannel(
                        PortAddr iop_base,
-                       ushort dma_channel
-)
-)
+                       ushort dma_channel)
 {
     ushort              cfg_lsw;
     uchar               value;
@@ -12181,13 +11859,10 @@
     return (0);
 }
 
-ASC_INITFUNC(
-STATIC uchar,
+STATIC uchar __init
 AscSetIsaDmaSpeed(
                      PortAddr iop_base,
-                     uchar speed_value
-)
-)
+                     uchar speed_value)
 {
     speed_value &= 0x07;
     AscSetBank(iop_base, 1);
@@ -12196,12 +11871,10 @@
     return (AscGetIsaDmaSpeed(iop_base));
 }
 
-ASC_INITFUNC(
-STATIC uchar,
+STATIC uchar __init
 AscGetIsaDmaSpeed(
                      PortAddr iop_base
 )
-)
 {
     uchar               speed_value;
 
@@ -12213,12 +11886,10 @@
 }
 #endif /* CONFIG_ISA */
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscReadPCIConfigWord(
     ASC_DVC_VAR *asc_dvc,
     ushort pci_config_offset)
-)
 {
     uchar       lsb, msb;
 
@@ -12227,12 +11898,10 @@
     return ((ushort) ((msb << 8) | lsb));
 }
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscInitGetConfig(
         ASC_DVC_VAR *asc_dvc
 )
-)
 {
     ushort              warn_code;
     PortAddr            iop_base;
@@ -12312,12 +11981,10 @@
     return(warn_code);
 }
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscInitSetConfig(
                     ASC_DVC_VAR *asc_dvc
 )
-)
 {
     ushort              warn_code = 0;
 
@@ -12333,12 +12000,10 @@
     return (warn_code);
 }
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscInitFromAscDvcVar(
                         ASC_DVC_VAR *asc_dvc
 )
-)
 {
     PortAddr            iop_base;
     ushort              cfg_msw;
@@ -12438,12 +12103,9 @@
     return (warn_code);
 }
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscInitAscDvcVar(
-                    ASC_DVC_VAR *asc_dvc
-)
-)
+                    ASC_DVC_VAR *asc_dvc)
 {
     int                 i;
     PortAddr            iop_base;
@@ -12553,12 +12215,8 @@
     return (warn_code);
 }
 
-ASC_INITFUNC(
-STATIC ushort,
-AscInitFromEEP(
-                  ASC_DVC_VAR *asc_dvc
-)
-)
+STATIC ushort __init
+AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 {
     ASCEEP_CONFIG       eep_config_buf;
     ASCEEP_CONFIG       *eep_config;
@@ -12774,12 +12432,9 @@
     return (warn_code);
 }
 
-ASC_INITFUNC(
-STATIC int,
+STATIC int __init
 AscTestExternalLram(
-                       ASC_DVC_VAR *asc_dvc
-)
-)
+                       ASC_DVC_VAR *asc_dvc)
 {
     PortAddr            iop_base;
     ushort              q_addr;
@@ -12801,13 +12456,11 @@
     return (sta);
 }
 
-ASC_INITFUNC(
-STATIC int,
+STATIC int __init
 AscWriteEEPCmdReg(
                      PortAddr iop_base,
                      uchar cmd_reg
 )
-)
 {
     uchar               read_back;
     int                 retry;
@@ -12826,13 +12479,11 @@
     }
 }
 
-ASC_INITFUNC(
-STATIC int,
+STATIC int __init
 AscWriteEEPDataReg(
                       PortAddr iop_base,
                       ushort data_reg
 )
-)
 {
     ushort              read_back;
     int                 retry;
@@ -12851,35 +12502,24 @@
     }
 }
 
-ASC_INITFUNC(
-STATIC void,
-AscWaitEEPRead(
-                  void
-)
-)
+STATIC void __init
+AscWaitEEPRead(void)
 {
     DvcSleepMilliSecond(1);
     return;
 }
 
-ASC_INITFUNC(
-STATIC void,
-AscWaitEEPWrite(
-                   void
-)
-)
+STATIC void __init
+AscWaitEEPWrite(void)
 {
     DvcSleepMilliSecond(20);
     return;
 }
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscReadEEPWord(
                   PortAddr iop_base,
-                  uchar addr
-)
-)
+                  uchar addr)
 {
     ushort              read_wval;
     uchar               cmd_reg;
@@ -12894,14 +12534,11 @@
     return (read_wval);
 }
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscWriteEEPWord(
                    PortAddr iop_base,
                    uchar addr,
-                   ushort word_val
-)
-)
+                   ushort word_val)
 {
     ushort              read_wval;
 
@@ -12921,13 +12558,10 @@
     return (read_wval);
 }
 
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AscGetEEPConfig(
                    PortAddr iop_base,
-                   ASCEEP_CONFIG * cfg_buf, ushort bus_type
-)
-)
+                   ASCEEP_CONFIG * cfg_buf, ushort bus_type)
 {
     ushort              wval;
     ushort              sum;
@@ -12973,13 +12607,10 @@
     return (sum);
 }
 
-ASC_INITFUNC(
-STATIC int,
+STATIC int __init
 AscSetEEPConfigOnce(
                        PortAddr iop_base,
-                       ASCEEP_CONFIG * cfg_buf, ushort bus_type
-)
-)
+                       ASCEEP_CONFIG * cfg_buf, ushort bus_type)
 {
     int                 n_error;
     ushort              *wbuf;
@@ -13071,13 +12702,11 @@
     return (n_error);
 }
 
-ASC_INITFUNC(
-STATIC int,
+STATIC int __init
 AscSetEEPConfig(
                    PortAddr iop_base,
                    ASCEEP_CONFIG * cfg_buf, ushort bus_type
 )
-)
 {
     int            retry;
     int            n_error;
@@ -13111,17 +12740,17 @@
     {
         if (!(asc_dvc->init_sdtr & tid_bits))
         {
-            if ((dvc_type == SCSI_TYPE_CDROM) &&
+            if ((dvc_type == TYPE_ROM) &&
                 (AscCompareString((uchar *) inq->vendor_id,
                     (uchar *) "HP ", 3) == 0))
             {
                 asc_dvc->pci_fix_asyn_xfer_always |= tid_bits;
             }
             asc_dvc->pci_fix_asyn_xfer |= tid_bits;
-            if ((dvc_type == SCSI_TYPE_PROC) ||
-                (dvc_type == SCSI_TYPE_SCANNER) ||
-                (dvc_type == SCSI_TYPE_CDROM) ||
-                (dvc_type == SCSI_TYPE_SASD))
+            if ((dvc_type == TYPE_PROCESSOR) ||
+                (dvc_type == TYPE_SCANNER) ||
+                (dvc_type == TYPE_ROM) ||
+                (dvc_type == TYPE_TAPE))
             {
                 asc_dvc->pci_fix_asyn_xfer &= ~tid_bits;
             }
@@ -14515,7 +14144,7 @@
  * unswapped on big-endian platforms.
  */
 STATIC ADVEEP_3550_CONFIG
-Default_3550_EEPROM_Config ASC_INITDATA = {
+Default_3550_EEPROM_Config __initdata = {
     ADV_EEPROM_BIOS_ENABLE,     /* cfg_lsw */
     0x0000,                     /* cfg_msw */
     0xFFFF,                     /* disc_enable */
@@ -14553,7 +14182,7 @@
 };
 
 STATIC ADVEEP_3550_CONFIG
-ADVEEP_3550_Config_Field_IsChar ASC_INITDATA = {
+ADVEEP_3550_Config_Field_IsChar __initdata = {
     0,                          /* cfg_lsw */
     0,                          /* cfg_msw */
     0,                          /* -disc_enable */
@@ -14591,7 +14220,7 @@
 };
 
 STATIC ADVEEP_38C0800_CONFIG
-Default_38C0800_EEPROM_Config ASC_INITDATA = {
+Default_38C0800_EEPROM_Config __initdata = {
     ADV_EEPROM_BIOS_ENABLE,     /* 00 cfg_lsw */
     0x0000,                     /* 01 cfg_msw */
     0xFFFF,                     /* 02 disc_enable */
@@ -14656,7 +14285,7 @@
 };
 
 STATIC ADVEEP_38C0800_CONFIG
-ADVEEP_38C0800_Config_Field_IsChar ASC_INITDATA = {
+ADVEEP_38C0800_Config_Field_IsChar __initdata = {
     0,                          /* 00 cfg_lsw */
     0,                          /* 01 cfg_msw */
     0,                          /* 02 disc_enable */
@@ -14721,7 +14350,7 @@
 };
 
 STATIC ADVEEP_38C1600_CONFIG
-Default_38C1600_EEPROM_Config ASC_INITDATA = {
+Default_38C1600_EEPROM_Config __initdata = {
     ADV_EEPROM_BIOS_ENABLE,     /* 00 cfg_lsw */
     0x0000,                     /* 01 cfg_msw */
     0xFFFF,                     /* 02 disc_enable */
@@ -14786,7 +14415,7 @@
 };
 
 STATIC ADVEEP_38C1600_CONFIG
-ADVEEP_38C1600_Config_Field_IsChar ASC_INITDATA = {
+ADVEEP_38C1600_Config_Field_IsChar __initdata = {
     0,                          /* 00 cfg_lsw */
     0,                          /* 01 cfg_msw */
     0,                          /* 02 disc_enable */
@@ -14858,10 +14487,8 @@
  * For a non-fatal error return a warning code. If there are no warnings
  * then 0 is returned.
  */
-ASC_INITFUNC(
-STATIC int,
+STATIC int __init
 AdvInitGetConfig(ADV_DVC_VAR *asc_dvc)
-)
 {
     ushort      warn_code;
     AdvPortAddr iop_base;
@@ -16845,10 +16472,8 @@
  *
  * Note: Chip is stopped on entry.
  */
-ASC_INITFUNC(
-STATIC int,
+STATIC int __init
 AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
-)
 {
     AdvPortAddr         iop_base;
     ushort              warn_code;
@@ -17019,10 +16644,8 @@
  *
  * Note: Chip is stopped on entry.
  */
-ASC_INITFUNC(
-STATIC int,
+STATIC int __init
 AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
-)
 {
     AdvPortAddr              iop_base;
     ushort                   warn_code;
@@ -17254,10 +16877,8 @@
  *
  * Note: Chip is stopped on entry.
  */
-ASC_INITFUNC(
-STATIC int,
+STATIC int __init
 AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
-)
 {
     AdvPortAddr              iop_base;
     ushort                   warn_code;
@@ -17522,10 +17143,8 @@
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AdvGet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
-)
 {
     ushort              wval, chksum;
     ushort              *wbuf;
@@ -17570,11 +17189,9 @@
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AdvGet38C0800EEPConfig(AdvPortAddr iop_base,
                        ADVEEP_38C0800_CONFIG *cfg_buf)
-)
 {
     ushort              wval, chksum;
     ushort              *wbuf;
@@ -17619,11 +17236,9 @@
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AdvGet38C1600EEPConfig(AdvPortAddr iop_base,
                        ADVEEP_38C1600_CONFIG *cfg_buf)
-)
 {
     ushort              wval, chksum;
     ushort              *wbuf;
@@ -17666,10 +17281,8 @@
 /*
  * Read the EEPROM from specified location
  */
-ASC_INITFUNC(
-STATIC ushort,
+STATIC ushort __init
 AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
-)
 {
     AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
         ASC_EEP_CMD_READ | eep_word_addr);
@@ -17680,10 +17293,8 @@
 /*
  * Wait for EEPROM command to complete
  */
-ASC_INITFUNC(
-STATIC void,
+STATIC void __init
 AdvWaitEEPCmd(AdvPortAddr iop_base)
-)
 {
     int eep_delay_ms;
 
@@ -18335,7 +17946,7 @@
          * the device, otherwise may erroneously set *_able bits.
          */
         if (scsiq->done_status == QD_NO_ERROR &&
-            scsiq->cdb[0] == SCSICMD_Inquiry &&
+            scsiq->cdb[0] == INQUIRY &&
             scsiq->target_lun == 0 &&
             (scsiq->cdb[1] & ADV_INQ_RTN_VPD_AND_CMDDT)
                 == ADV_INQ_RTN_STD_INQUIRY_DATA)
