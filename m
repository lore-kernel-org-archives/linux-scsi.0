From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 1/7] aic94xx: sas header file merge
Date: Tue, 06 Jun 2006 16:40:49 -0700
Message-ID: <1149637249.25278.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:36804 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751364AbWFFXlJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jun 2006 19:41:09 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Nf8Mp020090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 19:41:08 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k56Nf55x186742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:41:06 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k56Nf5aQ020365
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:41:05 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Nf4DC020355
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:41:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Merge sas header files into libsas.h and sas.h and move them into the
include/scsi dir

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

---
Index: linux-2.6.17-rc5/include/scsi/sas/sas.h
===================================================================
--- linux-2.6.17-rc5.orig/include/scsi/sas/sas.h	2006-06-02
17:50:25.000000000 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,164 +0,0 @@
-/*
- * SAS structures and definitions header file
- *
- * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
- * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
- * $Id: //depot/sas-class/sas.h#25 $
- */
-
-#ifndef _SAS_H_
-#define _SAS_H_
-
-#include <linux/types.h>
-#include <asm/byteorder.h>
-
-#define SAS_ADDR_SIZE        8
-#define HASHED_SAS_ADDR_SIZE 3
-#define SAS_ADDR(_sa) ((unsigned long long) be64_to_cpu(*(__be64
*)(_sa)))
-
-enum sas_oob_mode {
-	OOB_NOT_CONNECTED,
-	SATA_OOB_MODE,
-	SAS_OOB_MODE
-};
-
-/* See sas_discover.c if you plan on changing these.
- */
-enum sas_dev_type {
-	NO_DEVICE   = 0,	  /* protocol */
-	SAS_END_DEV = 1,	  /* protocol */
-	EDGE_DEV    = 2,	  /* protocol */
-	FANOUT_DEV  = 3,	  /* protocol */
-	SAS_HA      = 4,
-	SATA_DEV    = 5,
-	SATA_PM     = 7,
-	SATA_PM_PORT= 8,
-};
-
-enum sas_phy_linkrate {
-	PHY_LINKRATE_NONE = 0,
-	PHY_LINKRATE_UNKNOWN = 0,
-	PHY_DISABLED,
-	PHY_RESET_PROBLEM,
-	PHY_SPINUP_HOLD,
-	PHY_PORT_SELECTOR,
-	PHY_LINKRATE_1_5 = 0x08,
-	PHY_LINKRATE_G1  = PHY_LINKRATE_1_5,
-	PHY_LINKRATE_3   = 0x09,
-	PHY_LINKRATE_G2  = PHY_LINKRATE_3,
-	PHY_LINKRATE_6   = 0x0A,
-};
-
-/* Partly from IDENTIFY address frame. */
-enum sas_proto {
-	SATA_PROTO    = 1,
-	SAS_PROTO_SMP = 2,	  /* protocol */
-	SAS_PROTO_STP = 4,	  /* protocol */
-	SAS_PROTO_SSP = 8,	  /* protocol */
-	SAS_PROTO_ALL = 0xE,
-};
-
-/* From the spec; local phys only */
-enum phy_func {
-	PHY_FUNC_NOP,
-	PHY_FUNC_LINK_RESET,		  /* Enables the phy */
-	PHY_FUNC_HARD_RESET,
-	PHY_FUNC_DISABLE,
-	PHY_FUNC_CLEAR_ERROR_LOG = 5,
-	PHY_FUNC_CLEAR_AFFIL,
-	PHY_FUNC_TX_SATA_PS_SIGNAL,
-	PHY_FUNC_RELEASE_SPINUP_HOLD = 0x10, /* LOCAL PORT ONLY! */
-};
-
-#include <scsi/sas/sas_frames.h>
-
-/* SAS LLDD would need to report only _very_few_ of those, like
BROADCAST.
- * Most of those are here for completeness.
- */
-enum sas_prim {
-	SAS_PRIM_AIP_NORMAL = 1,
-	SAS_PRIM_AIP_R0     = 2,
-	SAS_PRIM_AIP_R1     = 3,
-	SAS_PRIM_AIP_R2     = 4,
-	SAS_PRIM_AIP_WC     = 5,
-	SAS_PRIM_AIP_WD     = 6,
-	SAS_PRIM_AIP_WP     = 7,
-	SAS_PRIM_AIP_RWP    = 8,
-
-	SAS_PRIM_BC_CH      = 9,
-	SAS_PRIM_BC_RCH0    = 10,
-	SAS_PRIM_BC_RCH1    = 11,
-	SAS_PRIM_BC_R0      = 12,
-	SAS_PRIM_BC_R1      = 13,
-	SAS_PRIM_BC_R2      = 14,
-	SAS_PRIM_BC_R3      = 15,
-	SAS_PRIM_BC_R4      = 16,
-
-	SAS_PRIM_NOTIFY_ENSP= 17,
-	SAS_PRIM_NOTIFY_R0  = 18,
-	SAS_PRIM_NOTIFY_R1  = 19,
-	SAS_PRIM_NOTIFY_R2  = 20,
-
-	SAS_PRIM_CLOSE_CLAF = 21,
-	SAS_PRIM_CLOSE_NORM = 22,
-	SAS_PRIM_CLOSE_R0   = 23,
-	SAS_PRIM_CLOSE_R1   = 24,
-
-	SAS_PRIM_OPEN_RTRY  = 25,
-	SAS_PRIM_OPEN_RJCT  = 26,
-	SAS_PRIM_OPEN_ACPT  = 27,
-
-	SAS_PRIM_DONE       = 28,
-	SAS_PRIM_BREAK      = 29,
-
-	SATA_PRIM_DMAT      = 33,
-	SATA_PRIM_PMNAK     = 34,
-	SATA_PRIM_PMACK     = 35,
-	SATA_PRIM_PMREQ_S   = 36,
-	SATA_PRIM_PMREQ_P   = 37,
-	SATA_SATA_R_ERR     = 38,
-};
-
-enum sas_open_rej_reason {
-	/* Abandon open */
-	SAS_OREJ_UNKNOWN   = 0,
-	SAS_OREJ_BAD_DEST  = 1,
-	SAS_OREJ_CONN_RATE = 2,
-	SAS_OREJ_EPROTO    = 3,
-	SAS_OREJ_RESV_AB0  = 4,
-	SAS_OREJ_RESV_AB1  = 5,
-	SAS_OREJ_RESV_AB2  = 6,
-	SAS_OREJ_RESV_AB3  = 7,
-	SAS_OREJ_WRONG_DEST= 8,
-	SAS_OREJ_STP_NORES = 9,
-
-	/* Retry open */
-	SAS_OREJ_NO_DEST   = 10,
-	SAS_OREJ_PATH_BLOCKED = 11,
-	SAS_OREJ_RSVD_CONT0 = 12,
-	SAS_OREJ_RSVD_CONT1 = 13,
-	SAS_OREJ_RSVD_INIT0 = 14,
-	SAS_OREJ_RSVD_INIT1 = 15,
-	SAS_OREJ_RSVD_STOP0 = 16,
-	SAS_OREJ_RSVD_STOP1 = 17,
-	SAS_OREJ_RSVD_RETRY = 18,
-};
-#endif /* _SAS_H_ */
Index: linux-2.6.17-rc5/include/scsi/sas/sas_class.h
===================================================================
--- linux-2.6.17-rc5.orig/include/scsi/sas/sas_class.h	2006-06-02
17:50:25.000000000 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,312 +0,0 @@
-/*
- * Serial Attached SCSI (SAS) class header file
- *
- * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
- * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
- * $Id: //depot/sas-class/sas_class.h#66 $
- */
-
-#ifndef _SAS_CLASS_H_
-#define _SAS_CLASS_H_
-
-#include <linux/list.h>
-#include <linux/pci.h>
-#include <asm/semaphore.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/sas/sas.h>
-#include <scsi/scsi_transport_sas.h>
-
-struct block_device;
-
-enum sas_class {
-	SAS,
-	EXPANDER
-};
-
-enum sas_phy_role {
-	PHY_ROLE_NONE = 0,
-	PHY_ROLE_TARGET = 0x40,
-	PHY_ROLE_INITIATOR = 0x80,
-};
-
-enum sas_phy_type {
-        PHY_TYPE_PHYSICAL,
-        PHY_TYPE_VIRTUAL
-};
-
-/* The events are mnemonically described in sas_dump.c
- * so when updating/adding events here, please also
- * update the other file too.
- */
-enum ha_event {
-	HAE_RESET = 0U,
-};
-#define HA_NUM_EVENTS 1
-
-enum port_event {
-	PORTE_BYTES_DMAED     = 0U,
-	PORTE_BROADCAST_RCVD  = 1,
-	PORTE_LINK_RESET_ERR  = 2,
-	PORTE_TIMER_EVENT     = 3,
-	PORTE_HARD_RESET      = 4,
-};
-#define PORT_NUM_EVENTS 5
-
-enum phy_event {
-	PHYE_LOSS_OF_SIGNAL   = 0U,
-	PHYE_OOB_DONE         = 1,
-	PHYE_OOB_ERROR        = 2,
-	PHYE_SPINUP_HOLD      = 3, /* hot plug SATA, no COMWAKE sent */
-};
-#define PHY_NUM_EVENTS 4
-
-enum discover_event {
-	DISCE_DISCOVER_DOMAIN   = 0U,
-	DISCE_REVALIDATE_DOMAIN = 1,
-	DISCE_PORT_GONE         = 2,
-};
-#define DISC_NUM_EVENTS 3
-
-struct asd_sas_port;
-
-/* The phy pretty much is controlled by the LLDD.
- * The class only reads those fields.
- */
-struct asd_sas_phy {
-/* private: */
-	/* protected by ha->event_lock */
-	struct work_struct   port_events[PORT_NUM_EVENTS];
-	struct work_struct   phy_events[PHY_NUM_EVENTS];
-
-	u32 port_events_pending;
-	u32 phy_events_pending;
-
-	int error;
-
-	struct sas_phy *phy;
-
-/* public: */
-	/* The following are class:RO, driver:R/W */
-	int            enabled;	  /* must be set */
-
-	int            id;	  /* must be set */
-	enum sas_class class;
-	enum sas_proto iproto;
-	enum sas_proto tproto;
-
-	enum sas_phy_type  type;
-	enum sas_phy_role  role;
-	enum sas_oob_mode  oob_mode;
-	enum sas_phy_linkrate linkrate;
-
-	u8   *sas_addr;		  /* must be set */
-	u8   attached_sas_addr[SAS_ADDR_SIZE]; /* class:RO, driver: R/W */
-
-	spinlock_t     frame_rcvd_lock;
-	u8             *frame_rcvd; /* must be set */
-	int            frame_rcvd_size;
-
-	spinlock_t     sas_prim_lock;
-	u32            sas_prim;
-
-	struct list_head port_phy_el; /* driver:RO */
-	struct asd_sas_port      *port; /* Class:RW, driver: RO */
-
-	struct sas_ha_struct *ha; /* may be set; the class sets it anyway */
-
-	void *lldd_phy;		  /* not touched by the sas_class_code */
-};
-
-struct sas_discovery {
-	spinlock_t disc_event_lock;
-	struct work_struct disc_work[DISC_NUM_EVENTS];
-	u32    pending;
-	u8     fanout_sas_addr[8];
-	u8     eeds_a[8];
-	u8     eeds_b[8];
-	int    max_level;
-};
-
-struct domain_device;
-
-/* The port struct is Class:RW, driver:RO */
-struct asd_sas_port {
-/* private: */
-	struct completion port_gone_completion;
-
-	struct sas_discovery disc;
-	struct domain_device *port_dev;
-	spinlock_t dev_list_lock;
-	struct list_head dev_list;
-	enum   sas_phy_linkrate linkrate;
-
-	struct sas_phy *phy;
-	struct work_struct work;
-
-/* public: */
-	int id;
-
-	enum sas_class   class;
-	u8               sas_addr[SAS_ADDR_SIZE];
-	u8               attached_sas_addr[SAS_ADDR_SIZE];
-	enum sas_proto   iproto;
-	enum sas_proto   tproto;
-
-	enum sas_oob_mode oob_mode;
-
-	spinlock_t       phy_list_lock;
-	struct list_head phy_list;
-	int              num_phys;
-	u32              phy_mask;
-
-	struct sas_ha_struct *ha;
-
-	struct sas_port	*port;
-
-	void *lldd_port;	  /* not touched by the sas class code */
-};
-
-struct sas_task;
-
-struct scsi_core {
-	struct Scsi_Host *shost;
-
-	spinlock_t        task_queue_lock;
-	struct list_head  task_queue;
-	int               task_queue_size;
-
-	struct semaphore  queue_thread_sema;
-	int               queue_thread_kill;
-};
-
-struct sas_ha_struct {
-/* private: */
-	spinlock_t       event_lock;
-	struct work_struct ha_events[HA_NUM_EVENTS];
-	u32		 pending;
-
-	struct scsi_core core;
-
-/* public: */
-	char *sas_ha_name;
-	struct pci_dev *pcidev;	  /* should be set */
-	struct module *lldd_module; /* should be set */
-
-	u8 *sas_addr;		  /* must be set */
-	u8 hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
-
-	spinlock_t      phy_port_lock;
-	struct asd_sas_phy  **sas_phy; /* array of valid pointers, must be set
*/
-	struct asd_sas_port **sas_port; /* array of valid pointers, must be
set */
-	int             num_phys; /* must be set, gt 0, static */
-
-	/* The class calls this to send a task for execution. */
-	int lldd_max_execute_num;
-	int lldd_queue_size;
-
-	/* LLDD calls these to notify the class of an event. */
-	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
-	void (*notify_port_event)(struct asd_sas_phy *, enum port_event);
-	void (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
-
-	void *lldd_ha;		  /* not touched by sas class code */
-};
-
-struct sas_domain_function_template {
-	/* The class calls these to notify the LLDD of an event. */
-	void (*lldd_port_formed)(struct asd_sas_phy *);
-	void (*lldd_port_deformed)(struct asd_sas_phy *);
-
-	/* The class calls these when a device is found or gone. */
-	int  (*lldd_dev_found)(struct domain_device *);
-	void (*lldd_dev_gone)(struct domain_device *);
-
-	int (*lldd_execute_task)(struct sas_task *, int num,
-				 unsigned long gfp_flags);
-
-	/* Task Management Functions. Must be called from process context. */
-	int (*lldd_abort_task)(struct sas_task *);
-	int (*lldd_abort_task_set)(struct domain_device *, u8 *lun);
-	int (*lldd_clear_aca)(struct domain_device *, u8 *lun);
-	int (*lldd_clear_task_set)(struct domain_device *, u8 *lun);
-	int (*lldd_I_T_nexus_reset)(struct domain_device *);
-	int (*lldd_lu_reset)(struct domain_device *, u8 *lun);
-	int (*lldd_query_task)(struct sas_task *);
-
-	/* Port and Adapter management */
-	int (*lldd_clear_nexus_port)(struct asd_sas_port *);
-	int (*lldd_clear_nexus_ha)(struct sas_ha_struct *);
-
-	/* Phy management */
-	int (*lldd_control_phy)(struct asd_sas_phy *, enum phy_func);
-};
-
-
-#define SHOST_TO_SAS_HA(_shost) (*(struct sas_ha_struct
**)(_shost)->hostdata)
-
-static inline struct domain_device *
-starget_to_domain_dev(struct scsi_target *starget) {
-	return starget->hostdata;
-}
-
-static inline struct domain_device *
-sdev_to_domain_dev(struct scsi_device *sdev) {
-	return starget_to_domain_dev(sdev->sdev_target);
-}
-
-static inline struct domain_device *
-cmd_to_domain_dev(struct scsi_cmnd *cmd)
-{
-	return sdev_to_domain_dev(cmd->device);
-}
-
-void sas_hash_addr(u8 *hashed, const u8 *sas_addr);
-
-/* Before calling a notify event, LLDD should use this function
- * when the link is severed (possibly from its tasklet).
- * The idea is that the Class only reads those, while the LLDD,
- * can R/W these (thus avoiding a race).
- */
-static inline void sas_phy_disconnected(struct asd_sas_phy *phy)
-{
-	phy->oob_mode = OOB_NOT_CONNECTED;
-	phy->linkrate = PHY_LINKRATE_NONE;
-}
-
-extern int sas_register_ha(struct sas_ha_struct *);
-extern int sas_unregister_ha(struct sas_ha_struct *);
-
-extern int sas_queuecommand(struct scsi_cmnd *cmd,
-		     void (*scsi_done)(struct scsi_cmnd *));
-extern int sas_target_alloc(struct scsi_target *starget);
-extern int sas_slave_alloc(struct scsi_device *scsi_dev);
-extern int sas_slave_configure(struct scsi_device *scsi_dev);
-extern void sas_slave_destroy(struct scsi_device *scsi_dev);
-extern int sas_change_queue_depth(struct scsi_device *scsi_dev, int
new_depth);
-extern int sas_change_queue_type(struct scsi_device *scsi_dev, int qt);
-extern int sas_bios_param(struct scsi_device *scsi_dev,
-			  struct block_device *bdev,
-			  sector_t capacity, int *hsc);
-extern struct scsi_transport_template *
-sas_domain_attach_transport(struct sas_domain_function_template *);
-extern void sas_domain_release_transport(struct scsi_transport_template
*);
-#endif /* _SAS_CLASS_H_ */
Index: linux-2.6.17-rc5/include/scsi/sas/sas_discover.h
===================================================================
--- linux-2.6.17-rc5.orig/include/scsi/sas/sas_discover.h	2006-06-02
17:50:25.000000000 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,157 +0,0 @@
-/*
- * Serial Attached SCSI (SAS) Discover process header file
- *
- * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
- * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
02110-1301  USA
- *
- * $Id: //depot/sas-class/sas_discover.h#41 $
- */
-
-#ifndef _SAS_DISCOVER_H_
-#define _SAS_DISCOVER_H_
-
-#include <scsi/sas/sas_class.h>
-#include <scsi/sas/sas_frames.h>
-
-/* ---------- SMP ---------- */
-
-#define SMP_REPORT_GENERAL       0x00
-#define SMP_REPORT_MANUF_INFO    0x01
-#define SMP_READ_GPIO_REG        0x02
-#define SMP_DISCOVER             0x10
-#define SMP_REPORT_PHY_ERR_LOG   0x11
-#define SMP_REPORT_PHY_SATA      0x12
-#define SMP_REPORT_ROUTE_INFO    0x13
-#define SMP_WRITE_GPIO_REG       0x82
-#define SMP_CONF_ROUTE_INFO      0x90
-#define SMP_PHY_CONTROL          0x91
-#define SMP_PHY_TEST_FUNCTION    0x92
-
-#define SMP_RESP_FUNC_ACC        0x00
-#define SMP_RESP_FUNC_UNK        0x01
-#define SMP_RESP_FUNC_FAILED     0x02
-#define SMP_RESP_INV_FRM_LEN     0x03
-#define SMP_RESP_NO_PHY          0x10
-#define SMP_RESP_NO_INDEX        0x11
-#define SMP_RESP_PHY_NO_SATA     0x12
-#define SMP_RESP_PHY_UNK_OP      0x13
-#define SMP_RESP_PHY_UNK_TESTF   0x14
-#define SMP_RESP_PHY_TEST_INPROG 0x15
-#define SMP_RESP_PHY_VACANT      0x16
-
-/* ---------- Domain Devices ---------- */
-
-/* See sas_discover.c before changing these.
- */
-
-/* ---------- SATA device ---------- */
-
-enum ata_command_set {
-	ATA_COMMAND_SET   = 0,
-	ATAPI_COMMAND_SET = 1,
-};
-
-struct domain_device;
-
-struct sata_device {
-	enum   ata_command_set command_set;
-	struct smp_resp        rps_resp; /* report_phy_sata_resp */
-	__le16 *identify_device;
-	__le16 *identify_packet_device;
-
-	u8     port_no;	       /* port number, if this is a PM (Port) */
-	struct list_head children; /* PM Ports if this is a PM */
-};
-
-#include <scsi/sas/sas_expander.h>
-
-/* ---------- Domain device ---------- */
-
-struct domain_device {
-	enum sas_dev_type dev_type;
-
-	enum sas_phy_linkrate linkrate;
-	enum sas_phy_linkrate min_linkrate;
-	enum sas_phy_linkrate max_linkrate;
-
-	int  pathways;
-
-	struct domain_device *parent;
-	struct list_head siblings; /* devices on the same level */
-	struct asd_sas_port *port;	  /* shortcut to root of the tree */
-
-	struct list_head dev_list_node;
-
-	enum sas_proto    iproto;
-	enum sas_proto    tproto;
-
-	struct sas_rphy *rphy;
-
-	u8  sas_addr[SAS_ADDR_SIZE];
-	u8  hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
-
-	u8  frame_rcvd[32];
-
-	union {
-		struct expander_device ex_dev;
-		struct sata_device     sata_dev; /* STP & directly attached */
-	};
-
-	void *lldd_dev;
-};
-
-#define list_for_each_entry_reverse_safe(pos, n, head, member)		\
-	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
-		n = list_entry(pos->member.prev, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
-	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
-
-
-static inline void sas_init_dev(struct domain_device *dev)
-{
-	INIT_LIST_HEAD(&dev->siblings);
-	INIT_LIST_HEAD(&dev->dev_list_node);
-	switch (dev->dev_type) {
-	case SAS_END_DEV:
-		break;
-	case EDGE_DEV:
-	case FANOUT_DEV:
-		INIT_LIST_HEAD(&dev->ex_dev.children);
-		break;
-	case SATA_DEV:
-	case SATA_PM:
-	case SATA_PM_PORT:
-		INIT_LIST_HEAD(&dev->sata_dev.children);
-		break;
-	default:
-		break;
-	}
-}
-
-void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port
*port);
-int  sas_discover_event(struct asd_sas_port *sas_port, enum
discover_event ev);
-
-int  sas_discover_sata(struct domain_device *dev);
-int  sas_discover_end_dev(struct domain_device *dev);
-
-void sas_unregister_dev(struct domain_device *dev);
-
-void sas_unregister_devices(struct sas_ha_struct *sas_ha);
-
-#endif /* _SAS_DISCOVER_H_ */
Index: linux-2.6.17-rc5/include/scsi/sas/sas_expander.h
===================================================================
--- linux-2.6.17-rc5.orig/include/scsi/sas/sas_expander.h	2006-06-02
17:50:25.000000000 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,98 +0,0 @@
-/*
- * Serial Attached SCSI (SAS) Expander discovery and configuration
- *
- * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
- * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
02110-1301  USA
- *
- * $Id: //depot/sas-class/sas_expander.h#19 $
- */
-
-#ifndef _SAS_EXPANDER_H_
-#define _SAS_EXPANDER_H_
-
-#define ETASK 0xFA
-
-#define to_dom_device(_obj) container_of(_obj, struct domain_device,
dev_obj)
-#define to_dev_attr(_attr)  container_of(_attr, struct
domain_dev_attribute,\
-                                         attr)
-
-/* ---------- Expander device ---------- */
-
-enum routing_attribute {
-	DIRECT_ROUTING,
-	SUBTRACTIVE_ROUTING,
-	TABLE_ROUTING,
-};
-
-enum ex_phy_state {
-	PHY_EMPTY,
-	PHY_VACANT,
-	PHY_NOT_PRESENT,
-	PHY_DEVICE_DISCOVERED
-};
-
-struct ex_phy {
-	int    phy_id;
-
-	enum ex_phy_state phy_state;
-
-	enum sas_dev_type attached_dev_type;
-	enum sas_phy_linkrate linkrate;
-
-	u8   attached_sata_host:1;
-	u8   attached_sata_dev:1;
-	u8   attached_sata_ps:1;
-
-	enum sas_proto attached_tproto;
-	enum sas_proto attached_iproto;
-
-	u8   attached_sas_addr[SAS_ADDR_SIZE];
-	u8   attached_phy_id;
-
-	u8   phy_change_count;
-	enum routing_attribute routing_attr;
-	u8   virtual:1;
-
-	int  last_da_index;
-
-	struct sas_phy *phy;
-	struct sas_port *port;
-};
-
-struct expander_device {
-	struct list_head children;
-
-	u16    ex_change_count;
-	u16    max_route_indexes;
-	u8     num_phys;
-	u8     configuring:1;
-	u8     conf_route_table:1;
-	u8     enclosure_logical_id[8];
-
-	struct ex_phy *ex_phy;
-	struct sas_port **ex_port;
-};
-
-int  sas_discover_root_expander(struct domain_device *dev);
-
-void sas_init_ex_attr(void);
-
-int  sas_ex_revalidate_domain(struct domain_device *port_dev);
-
-#endif /* _SAS_EXPANDER_H_ */
Index: linux-2.6.17-rc5/include/scsi/sas/sas_frames.h
===================================================================
--- linux-2.6.17-rc5.orig/include/scsi/sas/sas_frames.h	2006-06-02
17:50:25.000000000 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,97 +0,0 @@
-/*
- * SAS Frames
- *
- * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
- * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
- * $Id: //depot/sas-class/sas_frames.h#5 $
- */
-
-#ifndef _SAS_FRAMES_
-#define _SAS_FRAMES_
-
-#define SMP_REQUEST             0x40
-#define SMP_RESPONSE            0x41
-
-#define SSP_DATA                0x01
-#define SSP_XFER_RDY            0x05
-#define SSP_COMMAND             0x06
-#define SSP_RESPONSE            0x07
-#define SSP_TASK                0x16
-
-struct  dev_to_host_fis {
-	u8     fis_type;	  /* 0x34 */
-	u8     flags;
-	u8     status;
-	u8     error;
-
-	u8     lbal;
-	union { u8 lbam; u8 byte_count_low; };
-	union { u8 lbah; u8 byte_count_high; };
-	u8     device;
-
-	u8     lbal_exp;
-	u8     lbam_exp;
-	u8     lbah_exp;
-	u8     _r_a;
-
-	union { u8  sector_count; u8 interrupt_reason; };
-	u8     sector_count_exp;
-	u8     _r_b;
-	u8     _r_c;
-
-	u32    _r_d;
-} __attribute__ ((packed));
-
-struct host_to_dev_fis {
-	u8     fis_type;	  /* 0x27 */
-	u8     flags;
-	u8     command;
-	u8     features;
-
-	u8     lbal;
-	union { u8 lbam; u8 byte_count_low; };
-	union { u8 lbah; u8 byte_count_high; };
-	u8     device;
-
-	u8     lbal_exp;
-	u8     lbam_exp;
-	u8     lbah_exp;
-	u8     features_exp;
-
-	union { u8  sector_count; u8 interrupt_reason; };
-	u8     sector_count_exp;
-	u8     _r_a;
-	u8     control;
-
-	u32    _r_b;
-} __attribute__ ((packed));
-
-/* Prefer to have code clarity over header file clarity.
- */
-#ifdef __LITTLE_ENDIAN_BITFIELD
-#include <scsi/sas/sas_frames_le.h>
-#elif defined(__BIG_ENDIAN_BITFIELD)
-#include <scsi/sas/sas_frames_be.h>
-#else
-#error "Bitfield order not defined!"
-#endif
-
-#endif /* _SAS_FRAMES_ */
Index: linux-2.6.17-rc5/include/scsi/sas/sas_frames_be.h
===================================================================
--- linux-2.6.17-rc5.orig/include/scsi/sas/sas_frames_be.h	2006-06-02
17:50:25.000000000 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,222 +0,0 @@
-/*
- * SAS Frames Big endian bitfield order
- *
- * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
- * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
- * $Id: //depot/sas-class/sas_frames_be.h#11 $
- */
-
-#ifndef _SAS_FRAMES_BE_H_
-#define _SAS_FRAMES_BE_H_
-
-#ifndef __BIG_ENDIAN_BITFIELD
-#error "Wrong header file included!"
-#endif
-
-struct sas_identify_frame {
-	/* Byte 0 */
-	u8  _un0:1;
-	u8  dev_type:3;
-	u8  frame_type:4;
-
-	/* Byte 1 */
-	u8  _un1;
-
-	/* Byte 2 */
-	union {
-		struct {
-			u8  _un247:4;
-			u8  ssp_iport:1;
-			u8  stp_iport:1;
-			u8  smp_iport:1;
-			u8  _un20:1;
-		};
-		u8 initiator_bits;
-	};
-
-	/* Byte 3 */
-	union {
-		struct {
-			u8 _un347:4;
-			u8 ssp_tport:1;
-			u8 stp_tport:1;
-			u8 smp_tport:1;
-			u8 _un30:1;
-		};
-		u8 target_bits;
-	};
-
-	/* Byte 4 - 11 */
-	u8 _un4_11[8];
-
-	/* Byte 12 - 19 */
-	u8 sas_addr[SAS_ADDR_SIZE];
-
-	/* Byte 20 */
-	u8 phy_id;
-
-	u8 _un21_27[7];
-
-	__be32 crc;
-} __attribute__ ((packed));
-
-struct ssp_frame_hdr {
-	u8     frame_type;
-	u8     hashed_dest_addr[HASHED_SAS_ADDR_SIZE];
-	u8     _r_a;
-	u8     hashed_src_addr[HASHED_SAS_ADDR_SIZE];
-	__be16 _r_b;
-
-	u8     _r_c:5;
-	u8     retry_data_frames:1;
-	u8     retransmit:1;
-	u8     changing_data_ptr:1;
-
-	u8     _r_d:6;
-	u8     num_fill_bytes:2;
-
-	u32    _r_e;
-	__be16 tag;
-	__be16 tptt;
-	__be32 data_offs;
-} __attribute__ ((packed));
-
-struct ssp_response_iu {
-	u8     _r_a[10];
-
-	u8     _r_b:6;
-	u8     datapres:2;
-
-	u8     status;
-
-	u32    _r_c;
-
-	__be32 sense_data_len;
-	__be32 response_data_len;
-
-	u8     resp_data[0];
-	u8     sense_data[0];
-} __attribute__ ((packed));
-
-/* ---------- SMP ---------- */
-
-struct report_general_resp {
-	__be16  change_count;
-	__be16  route_indexes;
-	u8      _r_a;
-	u8      num_phys;
-
-	u8      _r_b:6;
-	u8      configuring:1;
-	u8      conf_route_table:1;
-
-	u8      _r_c;
-
-	u8      enclosure_logical_id[8];
-
-	u8      _r_d[12];
-} __attribute__ ((packed));
-
-struct discover_resp {
-	u8    _r_a[5];
-
-	u8    phy_id;
-	__be16 _r_b;
-
-	u8    _r_d:1;
-	u8    attached_dev_type:3;
-	u8    _r_c:4;
-
-	u8    _r_e:4;
-	u8    linkrate:4;
-
-	u8    _r_f:4;
-	u8    iproto:3;
-	u8    attached_sata_host:1;
-
-	u8    attached_sata_ps:1;
-	u8    _r_g:3;
-	u8    tproto:3;
-	u8    attached_sata_dev:1;
-
-	u8    sas_addr[8];
-	u8    attached_sas_addr[8];
-	u8    attached_phy_id;
-
-	u8    _r_h[7];
-
-	u8    pmin_linkrate:4;
-	u8    hmin_linkrate:4;
-	u8    pmax_linkrate:4;
-	u8    hmax_linkrate:4;
-
-	u8    change_count;
-
-	u8    virtual:1;
-	u8    _r_i:3;
-	u8    pptv:4;
-
-	u8    _r_j:4;
-	u8    routing_attr:4;
-
-	u8    conn_type;
-	u8    conn_el_index;
-	u8    conn_phy_link;
-
-	u8    _r_k[8];
-} __attribute__ ((packed));
-
-struct report_phy_sata_resp {
-	u8    _r_a[5];
-
-	u8    phy_id;
-	u8    _r_b;
-
-	u8    _r_c:6;
-	u8    affil_supp:1;
-	u8    affil_valid:1;
-
-	u32   _r_d;
-
-	u8    stp_sas_addr[8];
-
-	struct dev_to_host_fis fis;
-
-	u32   _r_e;
-
-	u8    affil_stp_ini_addr[8];
-
-	__be32 crc;
-} __attribute__ ((packed));
-
-struct smp_resp {
-	u8    frame_type;
-	u8    function;
-	u8    result;
-	u8    reserved;
-	union {
-		struct report_general_resp  rg;
-		struct discover_resp        disc;
-		struct report_phy_sata_resp rps;
-	};
-} __attribute__ ((packed));
-
-#endif /* _SAS_FRAMES_BE_H_ */
Index: linux-2.6.17-rc5/include/scsi/sas/sas_frames_le.h
===================================================================
--- linux-2.6.17-rc5.orig/include/scsi/sas/sas_frames_le.h	2006-06-02
17:50:25.000000000 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,223 +0,0 @@
-/*
- * SAS Frames Little endian bitfield order
- *
- * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
- * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
- * $Id: //depot/sas-class/sas_frames_le.h#10 $
- */
-
-#ifndef _SAS_FRAMES_LE_H_
-#define _SAS_FRAMES_LE_H_
-
-#ifndef __LITTLE_ENDIAN_BITFIELD
-#error "Wrong header file included!"
-#endif
-
-struct sas_identify_frame {
-	/* Byte 0 */
-	u8  frame_type:4;
-	u8  dev_type:3;
-	u8  _un0:1;
-
-	/* Byte 1 */
-	u8  _un1;
-
-	/* Byte 2 */
-	union {
-		struct {
-			u8  _un20:1;
-			u8  smp_iport:1;
-			u8  stp_iport:1;
-			u8  ssp_iport:1;
-			u8  _un247:4;
-		};
-		u8 initiator_bits;
-	};
-
-	/* Byte 3 */
-	union {
-		struct {
-			u8  _un30:1;
-			u8 smp_tport:1;
-			u8 stp_tport:1;
-			u8 ssp_tport:1;
-			u8 _un347:4;
-		};
-		u8 target_bits;
-	};
-
-	/* Byte 4 - 11 */
-	u8 _un4_11[8];
-
-	/* Byte 12 - 19 */
-	u8 sas_addr[SAS_ADDR_SIZE];
-
-	/* Byte 20 */
-	u8 phy_id;
-
-	u8 _un21_27[7];
-
-	__be32 crc;
-} __attribute__ ((packed));
-
-struct ssp_frame_hdr {
-	u8     frame_type;
-	u8     hashed_dest_addr[HASHED_SAS_ADDR_SIZE];
-	u8     _r_a;
-	u8     hashed_src_addr[HASHED_SAS_ADDR_SIZE];
-	__be16 _r_b;
-
-	u8     changing_data_ptr:1;
-	u8     retransmit:1;
-	u8     retry_data_frames:1;
-	u8     _r_c:5;
-
-	u8     num_fill_bytes:2;
-	u8     _r_d:6;
-
-	u32    _r_e;
-	__be16 tag;
-	__be16 tptt;
-	__be32 data_offs;
-} __attribute__ ((packed));
-
-struct ssp_response_iu {
-	u8     _r_a[10];
-
-	u8     datapres:2;
-	u8     _r_b:6;
-
-	u8     status;
-
-	u32    _r_c;
-
-	__be32 sense_data_len;
-	__be32 response_data_len;
-
-	u8     resp_data[0];
-	u8     sense_data[0];
-} __attribute__ ((packed));
-
-/* ---------- SMP ---------- */
-
-struct report_general_resp {
-	__be16  change_count;
-	__be16  route_indexes;
-	u8      _r_a;
-	u8      num_phys;
-
-	u8      conf_route_table:1;
-	u8      configuring:1;
-	u8      _r_b:6;
-
-	u8      _r_c;
-
-	u8      enclosure_logical_id[8];
-
-	u8      _r_d[12];
-} __attribute__ ((packed));
-
-struct discover_resp {
-	u8    _r_a[5];
-
-	u8    phy_id;
-	__be16 _r_b;
-
-	u8    _r_c:4;
-	u8    attached_dev_type:3;
-	u8    _r_d:1;
-
-	u8    linkrate:4;
-	u8    _r_e:4;
-
-	u8    attached_sata_host:1;
-	u8    iproto:3;
-	u8    _r_f:4;
-
-	u8    attached_sata_dev:1;
-	u8    tproto:3;
-	u8    _r_g:3;
-	u8    attached_sata_ps:1;
-
-	u8    sas_addr[8];
-	u8    attached_sas_addr[8];
-	u8    attached_phy_id;
-
-	u8    _r_h[7];
-
-	u8    hmin_linkrate:4;
-	u8    pmin_linkrate:4;
-	u8    hmax_linkrate:4;
-	u8    pmax_linkrate:4;
-
-	u8    change_count;
-
-	u8    pptv:4;
-	u8    _r_i:3;
-	u8    virtual:1;
-
-	u8    routing_attr:4;
-	u8    _r_j:4;
-
-	u8    conn_type;
-	u8    conn_el_index;
-	u8    conn_phy_link;
-
-	u8    _r_k[8];
-} __attribute__ ((packed));
-
-struct report_phy_sata_resp {
-	u8    _r_a[5];
-
-	u8    phy_id;
-	u8    _r_b;
-
-	u8    affil_valid:1;
-	u8    affil_supp:1;
-	u8    _r_c:6;
-
-	u32    _r_d;
-
-	u8    stp_sas_addr[8];
-
-	struct dev_to_host_fis fis;
-
-	u32   _r_e;
-
-	u8    affil_stp_ini_addr[8];
-
-	__be32 crc;
-} __attribute__ ((packed));
-
-struct smp_resp {
-	u8    frame_type;
-	u8    function;
-	u8    result;
-	u8    reserved;
-	union {
-		struct report_general_resp  rg;
-		struct discover_resp        disc;
-		struct report_phy_sata_resp rps;
-	};
-} __attribute__ ((packed));
-
-#endif /* _SAS_FRAMES_LE_H_ */
-
Index: linux-2.6.17-rc5/include/scsi/sas/sas_task.h
===================================================================
--- linux-2.6.17-rc5.orig/include/scsi/sas/sas_task.h	2006-06-02
17:50:25.000000000 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,236 +0,0 @@
-/*
- * Serial Attached SCSI (SAS) Task interface
- *
- * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
- * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
02110-1301  USA
- *
- * $Id: //depot/sas-class/sas_task.h#27 $
- */
-
-#ifndef _SAS_TASK_H_
-#define _SAS_TASK_H_
-
-#include <linux/timer.h>
-#include <linux/pci.h>
-#include <scsi/sas/sas_discover.h>
-
-/* SAM TMFs */
-#define TMF_ABORT_TASK      0x01
-#define TMF_ABORT_TASK_SET  0x02
-#define TMF_CLEAR_TASK_SET  0x04
-#define TMF_LU_RESET        0x08
-#define TMF_CLEAR_ACA       0x40
-#define TMF_QUERY_TASK      0x80
-
-/* SAS TMF responses */
-#define TMF_RESP_FUNC_COMPLETE   0x00
-#define TMF_RESP_INVALID_FRAME   0x02
-#define TMF_RESP_FUNC_ESUPP      0x04
-#define TMF_RESP_FUNC_FAILED     0x05
-#define TMF_RESP_FUNC_SUCC       0x08
-#define TMF_RESP_NO_LUN          0x09
-#define TMF_RESP_OVERLAPPED_TAG  0x0A
-
-/*
-      service_response |  SAS_TASK_COMPLETE  |  SAS_TASK_UNDELIVERED |
-  exec_status          |                     |                       |
-  ---------------------+---------------------+-----------------------+
-       SAM_...         |         X           |                       |
-       DEV_NO_RESPONSE |         X           |           X           |
-       INTERRUPTED     |         X           |                       |
-       QUEUE_FULL      |                     |           X           |
-       DEVICE_UNKNOWN  |                     |           X           |
-       SG_ERR          |                     |           X           |
-  ---------------------+---------------------+-----------------------+
- */
-
-enum service_response {
-	SAS_TASK_COMPLETE,
-	SAS_TASK_UNDELIVERED = -1,
-};
-
-enum exec_status {
-	SAM_GOOD         = 0,
-	SAM_CHECK_COND   = 2,
-	SAM_COND_MET     = 4,
-	SAM_BUSY         = 8,
-	SAM_INTERMEDIATE = 0x10,
-	SAM_IM_COND_MET  = 0x12,
-	SAM_RESV_CONFLICT= 0x14,
-	SAM_TASK_SET_FULL= 0x28,
-	SAM_ACA_ACTIVE   = 0x30,
-	SAM_TASK_ABORTED = 0x40,
-
-	SAS_DEV_NO_RESPONSE = 0x80,
-	SAS_DATA_UNDERRUN,
-	SAS_DATA_OVERRUN,
-	SAS_INTERRUPTED,
-	SAS_QUEUE_FULL,
-	SAS_DEVICE_UNKNOWN,
-	SAS_SG_ERR,
-	SAS_OPEN_REJECT,
-	SAS_OPEN_TO,
-	SAS_PROTO_RESPONSE,
-	SAS_PHY_DOWN,
-	SAS_NAK_R_ERR,
-	SAS_PENDING,
-	SAS_ABORTED_TASK,
-};
-
-/* When a task finishes with a response, the LLDD examines the
- * response:
- * 	- For an ATA task task_status_struct::stat is set to
- * SAS_PROTO_RESPONSE, and the task_status_struct::buf is set to the
- * contents of struct ata_task_resp.
- * 	- For SSP tasks, if no data is present or status/TMF response
- * is valid, task_status_struct::stat is set.  If data is present
- * (SENSE data), the LLDD copies up to SAS_STATUS_BUF_SIZE, sets
- * task_status_struct::buf_valid_size, and task_status_struct::stat is
- * set to SAM_CHECK_COND.
- *
- * "buf" has format SCSI Sense for SSP task, or struct ata_task_resp
- * for ATA task.
- *
- * "frame_len" is the total frame length, which could be more or less
- * than actually copied.
- *
- * Tasks ending with response, always set the residual field.
- */
-struct ata_task_resp {
-	u16  frame_len;
-	u8   ending_fis[24];	  /* dev to host or data-in */
-	u32  sstatus;
-	u32  serror;
-	u32  scontrol;
-	u32  sactive;
-};
-
-#define SAS_STATUS_BUF_SIZE 96
-
-struct task_status_struct {
-	enum service_response resp;
-	enum exec_status      stat;
-	int  buf_valid_size;
-
-	u8   buf[SAS_STATUS_BUF_SIZE];
-
-	u32  residual;
-	enum sas_open_rej_reason open_rej_reason;
-};
-
-/* ATA and ATAPI task queuable to a SAS LLDD.
- */
-struct sas_ata_task {
-	struct host_to_dev_fis fis;
-	u8     atapi_packet[16];  /* 0 if not ATAPI task */
-
-	u8     retry_count;	  /* hardware retry, should be > 0 */
-
-	u8     dma_xfer:1;	  /* PIO:0 or DMA:1 */
-	u8     use_ncq:1;
-	u8     set_affil_pol:1;
-	u8     stp_affil_pol:1;
-
-	u8     device_control_reg_update:1;
-};
-
-struct sas_smp_task {
-	struct scatterlist smp_req;
-	struct scatterlist smp_resp;
-};
-
-enum task_attribute {
-	TASK_ATTR_SIMPLE = 0,
-	TASK_ATTR_HOQ    = 1,
-	TASK_ATTR_ORDERED= 2,
-	TASK_ATTR_ACA    = 4,
-};
-
-struct sas_ssp_task {
-	u8     retry_count;	  /* hardware retry, should be > 0 */
-
-	u8     LUN[8];
-	u8     enable_first_burst:1;
-	enum   task_attribute task_attr;
-	u8     task_prio;
-	u8     cdb[16];
-};
-
-#define SAS_TASK_STATE_PENDING  1
-#define SAS_TASK_STATE_DONE     2
-#define SAS_TASK_STATE_ABORTED  4
-
-struct sas_task {
-	struct domain_device *dev;
-	struct list_head      list;
-
-	spinlock_t   task_state_lock;
-	unsigned     task_state_flags;
-
-	enum   sas_proto      task_proto;
-
-	/* Used by the discovery code. */
-	struct timer_list     timer;
-	struct completion     completion;
-
-	union {
-		struct sas_ata_task ata_task;
-		struct sas_smp_task smp_task;
-		struct sas_ssp_task ssp_task;
-	};
-
-	struct scatterlist *scatter;
-	int    num_scatter;
-	u32    total_xfer_len;
-	u8     data_dir:2;	  /* Use PCI_DMA_... */
-
-	struct task_status_struct task_status;
-	void   (*task_done)(struct sas_task *task);
-
-	void   *lldd_task;	  /* for use by LLDDs */
-	void   *uldd_task;
-};
-
-static inline struct sas_task *sas_alloc_task(unsigned long flags)
-{
-	extern kmem_cache_t *sas_task_cache;
-	struct sas_task *task = kmem_cache_alloc(sas_task_cache, flags);
-
-	if (task) {
-		memset(task, 0, sizeof(*task));
-		INIT_LIST_HEAD(&task->list);
-		spin_lock_init(&task->task_state_lock);
-		task->task_state_flags = SAS_TASK_STATE_PENDING;
-		init_timer(&task->timer);
-		init_completion(&task->completion);
-	}
-
-	return task;
-}
-
-static inline void sas_free_task(struct sas_task *task)
-{
-	if (task) {
-		extern kmem_cache_t *sas_task_cache;
-		BUG_ON(!list_empty(&task->list));
-		kmem_cache_free(sas_task_cache, task);
-	}
-}
-
-#endif /* _SAS_TASK_H_ */
Index: linux-2.6.17-rc5/include/scsi/libsas.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.17-rc5/include/scsi/libsas.h	2006-06-06 14:19:43.000000000
-0700
@@ -0,0 +1,629 @@
+/*
+ * SAS host prototypes and structures header file
+ *
+ * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
+ * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+ *
+ */
+
+#ifndef _LIBSAS_H_
+#define _LIBSAS_H_
+
+
+#include <linux/timer.h>
+#include <linux/pci.h>
+#include <scsi/sas.h>
+#include <linux/list.h>
+#include <asm/semaphore.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_transport_sas.h>
+
+struct block_device;
+
+enum sas_class {
+	SAS,
+	EXPANDER
+};
+
+enum sas_phy_role {
+	PHY_ROLE_NONE = 0,
+	PHY_ROLE_TARGET = 0x40,
+	PHY_ROLE_INITIATOR = 0x80,
+};
+
+enum sas_phy_type {
+        PHY_TYPE_PHYSICAL,
+        PHY_TYPE_VIRTUAL
+};
+
+/* The events are mnemonically described in sas_dump.c
+ * so when updating/adding events here, please also
+ * update the other file too.
+ */
+enum ha_event {
+	HAE_RESET             = 0U,
+	HA_NUM_EVENTS         = 1,
+};
+
+enum port_event {
+	PORTE_BYTES_DMAED     = 0U,
+	PORTE_BROADCAST_RCVD  = 1,
+	PORTE_LINK_RESET_ERR  = 2,
+	PORTE_TIMER_EVENT     = 3,
+	PORTE_HARD_RESET      = 4,
+	PORT_NUM_EVENTS       = 5,
+};
+
+enum phy_event {
+	PHYE_LOSS_OF_SIGNAL   = 0U,
+	PHYE_OOB_DONE         = 1,
+	PHYE_OOB_ERROR        = 2,
+	PHYE_SPINUP_HOLD      = 3, /* hot plug SATA, no COMWAKE sent */
+	PHY_NUM_EVENTS        = 4,
+};
+
+enum discover_event {
+	DISCE_DISCOVER_DOMAIN   = 0U,
+	DISCE_REVALIDATE_DOMAIN = 1,
+	DISCE_PORT_GONE         = 2,
+	DISC_NUM_EVENTS 	= 3,
+};
+
+/* ---------- Expander Devices ---------- */
+
+#define ETASK 0xFA
+
+#define to_dom_device(_obj) container_of(_obj, struct domain_device,
dev_obj)
+#define to_dev_attr(_attr)  container_of(_attr, struct
domain_dev_attribute,\
+                                         attr)
+
+enum routing_attribute {
+	DIRECT_ROUTING,
+	SUBTRACTIVE_ROUTING,
+	TABLE_ROUTING,
+};
+
+enum ex_phy_state {
+	PHY_EMPTY,
+	PHY_VACANT,
+	PHY_NOT_PRESENT,
+	PHY_DEVICE_DISCOVERED
+};
+
+struct ex_phy {
+	int    phy_id;
+
+	enum ex_phy_state phy_state;
+
+	enum sas_dev_type attached_dev_type;
+	enum sas_phy_linkrate linkrate;
+
+	u8   attached_sata_host:1;
+	u8   attached_sata_dev:1;
+	u8   attached_sata_ps:1;
+
+	enum sas_proto attached_tproto;
+	enum sas_proto attached_iproto;
+
+	u8   attached_sas_addr[SAS_ADDR_SIZE];
+	u8   attached_phy_id;
+
+	u8   phy_change_count;
+	enum routing_attribute routing_attr;
+	u8   virtual:1;
+
+	int  last_da_index;
+
+	struct sas_phy *phy;
+	struct sas_port *port;
+};
+
+struct expander_device {
+	struct list_head children;
+
+	u16    ex_change_count;
+	u16    max_route_indexes;
+	u8     num_phys;
+	u8     configuring:1;
+	u8     conf_route_table:1;
+	u8     enclosure_logical_id[8];
+
+	struct ex_phy *ex_phy;
+	struct sas_port **ex_port;
+};
+
+/* ---------- SATA device ---------- */
+enum ata_command_set {
+        ATA_COMMAND_SET   = 0,
+        ATAPI_COMMAND_SET = 1,
+};
+
+struct sata_device {
+        enum   ata_command_set command_set;
+        struct smp_resp        rps_resp; /* report_phy_sata_resp */
+        __le16 *identify_device;
+        __le16 *identify_packet_device;
+
+        u8     port_no;        /* port number, if this is a PM (Port)
*/
+        struct list_head children; /* PM Ports if this is a PM */
+};
+
+/* ---------- Domain device ---------- */
+struct domain_device {
+        enum sas_dev_type dev_type;
+
+        enum sas_phy_linkrate linkrate;
+        enum sas_phy_linkrate min_linkrate;
+        enum sas_phy_linkrate max_linkrate;
+
+        int  pathways;
+
+        struct domain_device *parent;
+        struct list_head siblings; /* devices on the same level */
+        struct asd_sas_port *port;        /* shortcut to root of the
tree */
+
+        struct list_head dev_list_node;
+
+        enum sas_proto    iproto;
+        enum sas_proto    tproto;
+
+        struct sas_rphy *rphy;
+
+        u8  sas_addr[SAS_ADDR_SIZE];
+        u8  hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
+
+        u8  frame_rcvd[32];
+
+        union {
+                struct expander_device ex_dev;
+                struct sata_device     sata_dev; /* STP & directly
attached */
+        };
+
+        void *lldd_dev;
+};
+
+struct sas_discovery {
+	spinlock_t disc_event_lock;
+	struct work_struct disc_work[DISC_NUM_EVENTS];
+	unsigned long    pending;
+	u8     fanout_sas_addr[8];
+	u8     eeds_a[8];
+	u8     eeds_b[8];
+	int    max_level;
+};
+
+
+/* The port struct is Class:RW, driver:RO */
+struct asd_sas_port {
+/* private: */
+	struct completion port_gone_completion;
+
+	struct sas_discovery disc;
+	struct domain_device *port_dev;
+	spinlock_t dev_list_lock;
+	struct list_head dev_list;
+	enum   sas_phy_linkrate linkrate;
+
+	struct sas_phy *phy;
+	struct work_struct work;
+
+/* public: */
+	int id;
+
+	enum sas_class   class;
+	u8               sas_addr[SAS_ADDR_SIZE];
+	u8               attached_sas_addr[SAS_ADDR_SIZE];
+	enum sas_proto   iproto;
+	enum sas_proto   tproto;
+
+	enum sas_oob_mode oob_mode;
+
+	spinlock_t       phy_list_lock;
+	struct list_head phy_list;
+	int              num_phys;
+	u32              phy_mask;
+
+	struct sas_ha_struct *ha;
+
+	struct sas_port	*port;
+
+	void *lldd_port;	  /* not touched by the sas class code */
+};
+
+/* The phy pretty much is controlled by the LLDD.
+ * The class only reads those fields.
+ */
+struct asd_sas_phy {
+/* private: */
+	/* protected by ha->event_lock */
+	struct work_struct   port_events[PORT_NUM_EVENTS];
+	struct work_struct   phy_events[PHY_NUM_EVENTS];
+
+	unsigned long port_events_pending;
+	unsigned long phy_events_pending;
+
+	int error;
+
+	struct sas_phy *phy;
+
+/* public: */
+	/* The following are class:RO, driver:R/W */
+	int            enabled;	  /* must be set */
+
+	int            id;	  /* must be set */
+	enum sas_class class;
+	enum sas_proto iproto;
+	enum sas_proto tproto;
+
+	enum sas_phy_type  type;
+	enum sas_phy_role  role;
+	enum sas_oob_mode  oob_mode;
+	enum sas_phy_linkrate linkrate;
+
+	u8   *sas_addr;		  /* must be set */
+	u8   attached_sas_addr[SAS_ADDR_SIZE]; /* class:RO, driver: R/W */
+
+	spinlock_t     frame_rcvd_lock;
+	u8             *frame_rcvd; /* must be set */
+	int            frame_rcvd_size;
+
+	spinlock_t     sas_prim_lock;
+	u32            sas_prim;
+
+	struct list_head port_phy_el; /* driver:RO */
+	struct asd_sas_port      *port; /* Class:RW, driver: RO */
+
+	struct sas_ha_struct *ha; /* may be set; the class sets it anyway */
+
+	void *lldd_phy;		  /* not touched by the sas_class_code */
+};
+
+struct scsi_core {
+	struct Scsi_Host *shost;
+
+	spinlock_t        task_queue_lock;
+	struct list_head  task_queue;
+	int               task_queue_size;
+
+	struct semaphore  queue_thread_sema;
+	int               queue_thread_kill;
+};
+
+struct sas_ha_struct {
+/* private: */
+	spinlock_t       event_lock;
+	struct work_struct ha_events[HA_NUM_EVENTS];
+	unsigned long	 pending;
+
+	struct scsi_core core;
+
+/* public: */
+	char *sas_ha_name;
+	struct pci_dev *pcidev;	  /* should be set */
+	struct module *lldd_module; /* should be set */
+
+	u8 *sas_addr;		  /* must be set */
+	u8 hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
+
+	spinlock_t      phy_port_lock;
+	struct asd_sas_phy  **sas_phy; /* array of valid pointers, must be set
*/
+	struct asd_sas_port **sas_port; /* array of valid pointers, must be
set */
+	int             num_phys; /* must be set, gt 0, static */
+
+	/* The class calls this to send a task for execution. */
+	int lldd_max_execute_num;
+	int lldd_queue_size;
+
+	/* LLDD calls these to notify the class of an event. */
+	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
+	void (*notify_port_event)(struct asd_sas_phy *, enum port_event);
+	void (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
+
+	void *lldd_ha;		  /* not touched by sas class code */
+};
+
+#define SHOST_TO_SAS_HA(_shost) (*(struct sas_ha_struct
**)(_shost)->hostdata)
+
+static inline struct domain_device *
+starget_to_domain_dev(struct scsi_target *starget) {
+	return starget->hostdata;
+}
+
+static inline struct domain_device *
+sdev_to_domain_dev(struct scsi_device *sdev) {
+	return starget_to_domain_dev(sdev->sdev_target);
+}
+
+static inline struct domain_device *
+cmd_to_domain_dev(struct scsi_cmnd *cmd)
+{
+	return sdev_to_domain_dev(cmd->device);
+}
+
+void sas_hash_addr(u8 *hashed, const u8 *sas_addr);
+
+/* Before calling a notify event, LLDD should use this function
+ * when the link is severed (possibly from its tasklet).
+ * The idea is that the Class only reads those, while the LLDD,
+ * can R/W these (thus avoiding a race).
+ */
+static inline void sas_phy_disconnected(struct asd_sas_phy *phy)
+{
+	phy->oob_mode = OOB_NOT_CONNECTED;
+	phy->linkrate = PHY_LINKRATE_NONE;
+}
+
+/* ---------- Tasks ---------- */
+/*
+      service_response |  SAS_TASK_COMPLETE  |  SAS_TASK_UNDELIVERED |
+  exec_status          |                     |                       |
+  ---------------------+---------------------+-----------------------+
+       SAM_...         |         X           |                       |
+       DEV_NO_RESPONSE |         X           |           X           |
+       INTERRUPTED     |         X           |                       |
+       QUEUE_FULL      |                     |           X           |
+       DEVICE_UNKNOWN  |                     |           X           |
+       SG_ERR          |                     |           X           |
+  ---------------------+---------------------+-----------------------+
+ */
+
+enum service_response {
+	SAS_TASK_COMPLETE,
+	SAS_TASK_UNDELIVERED = -1,
+};
+
+enum exec_status {
+	SAM_GOOD         = 0,
+	SAM_CHECK_COND   = 2,
+	SAM_COND_MET     = 4,
+	SAM_BUSY         = 8,
+	SAM_INTERMEDIATE = 0x10,
+	SAM_IM_COND_MET  = 0x12,
+	SAM_RESV_CONFLICT= 0x14,
+	SAM_TASK_SET_FULL= 0x28,
+	SAM_ACA_ACTIVE   = 0x30,
+	SAM_TASK_ABORTED = 0x40,
+
+	SAS_DEV_NO_RESPONSE = 0x80,
+	SAS_DATA_UNDERRUN,
+	SAS_DATA_OVERRUN,
+	SAS_INTERRUPTED,
+	SAS_QUEUE_FULL,
+	SAS_DEVICE_UNKNOWN,
+	SAS_SG_ERR,
+	SAS_OPEN_REJECT,
+	SAS_OPEN_TO,
+	SAS_PROTO_RESPONSE,
+	SAS_PHY_DOWN,
+	SAS_NAK_R_ERR,
+	SAS_PENDING,
+	SAS_ABORTED_TASK,
+};
+
+/* When a task finishes with a response, the LLDD examines the
+ * response:
+ * 	- For an ATA task task_status_struct::stat is set to
+ * SAS_PROTO_RESPONSE, and the task_status_struct::buf is set to the
+ * contents of struct ata_task_resp.
+ * 	- For SSP tasks, if no data is present or status/TMF response
+ * is valid, task_status_struct::stat is set.  If data is present
+ * (SENSE data), the LLDD copies up to SAS_STATUS_BUF_SIZE, sets
+ * task_status_struct::buf_valid_size, and task_status_struct::stat is
+ * set to SAM_CHECK_COND.
+ *
+ * "buf" has format SCSI Sense for SSP task, or struct ata_task_resp
+ * for ATA task.
+ *
+ * "frame_len" is the total frame length, which could be more or less
+ * than actually copied.
+ *
+ * Tasks ending with response, always set the residual field.
+ */
+struct ata_task_resp {
+	u16  frame_len;
+	u8   ending_fis[24];	  /* dev to host or data-in */
+	u32  sstatus;
+	u32  serror;
+	u32  scontrol;
+	u32  sactive;
+};
+
+#define SAS_STATUS_BUF_SIZE 96
+
+struct task_status_struct {
+	enum service_response resp;
+	enum exec_status      stat;
+	int  buf_valid_size;
+
+	u8   buf[SAS_STATUS_BUF_SIZE];
+
+	u32  residual;
+	enum sas_open_rej_reason open_rej_reason;
+};
+
+/* ATA and ATAPI task queuable to a SAS LLDD.
+ */
+struct sas_ata_task {
+	struct host_to_dev_fis fis;
+	u8     atapi_packet[16];  /* 0 if not ATAPI task */
+
+	u8     retry_count;	  /* hardware retry, should be > 0 */
+
+	u8     dma_xfer:1;	  /* PIO:0 or DMA:1 */
+	u8     use_ncq:1;
+	u8     set_affil_pol:1;
+	u8     stp_affil_pol:1;
+
+	u8     device_control_reg_update:1;
+};
+
+struct sas_smp_task {
+	struct scatterlist smp_req;
+	struct scatterlist smp_resp;
+};
+
+enum task_attribute {
+	TASK_ATTR_SIMPLE = 0,
+	TASK_ATTR_HOQ    = 1,
+	TASK_ATTR_ORDERED= 2,
+	TASK_ATTR_ACA    = 4,
+};
+
+struct sas_ssp_task {
+	u8     retry_count;	  /* hardware retry, should be > 0 */
+
+	u8     LUN[8];
+	u8     enable_first_burst:1;
+	enum   task_attribute task_attr;
+	u8     task_prio;
+	u8     cdb[16];
+};
+
+struct sas_task {
+	struct domain_device *dev;
+	struct list_head      list;
+
+	spinlock_t   task_state_lock;
+	unsigned     task_state_flags;
+
+	enum   sas_proto      task_proto;
+
+	/* Used by the discovery code. */
+	struct timer_list     timer;
+	struct completion     completion;
+
+	union {
+		struct sas_ata_task ata_task;
+		struct sas_smp_task smp_task;
+		struct sas_ssp_task ssp_task;
+	};
+
+	struct scatterlist *scatter;
+	int    num_scatter;
+	u32    total_xfer_len;
+	u8     data_dir:2;	  /* Use PCI_DMA_... */
+
+	struct task_status_struct task_status;
+	void   (*task_done)(struct sas_task *);
+
+	void   *lldd_task;	  /* for use by LLDDs */
+	void   *uldd_task;
+};
+
+
+
+#define SAS_TASK_STATE_PENDING  1
+#define SAS_TASK_STATE_DONE     2
+#define SAS_TASK_STATE_ABORTED  4
+
+static inline struct sas_task *sas_alloc_task(unsigned long flags)
+{
+	extern kmem_cache_t *sas_task_cache;
+	struct sas_task *task = kmem_cache_alloc(sas_task_cache, flags);
+
+	if (task) {
+		memset(task, 0, sizeof(*task));
+		INIT_LIST_HEAD(&task->list);
+		spin_lock_init(&task->task_state_lock);
+		task->task_state_flags = SAS_TASK_STATE_PENDING;
+		init_timer(&task->timer);
+		init_completion(&task->completion);
+	}
+
+	return task;
+}
+
+static inline void sas_free_task(struct sas_task *task)
+{
+	if (task) {
+		extern kmem_cache_t *sas_task_cache;
+		BUG_ON(!list_empty(&task->list));
+		kmem_cache_free(sas_task_cache, task);
+	}
+}
+
+struct sas_domain_function_template {
+	/* The class calls these to notify the LLDD of an event. */
+	void (*lldd_port_formed)(struct asd_sas_phy *);
+	void (*lldd_port_deformed)(struct asd_sas_phy *);
+
+	/* The class calls these when a device is found or gone. */
+	int  (*lldd_dev_found)(struct domain_device *);
+	void (*lldd_dev_gone)(struct domain_device *);
+
+	int (*lldd_execute_task)(struct sas_task *, int num,
+				 unsigned long gfp_flags);
+
+	/* Task Management Functions. Must be called from process context. */
+	int (*lldd_abort_task)(struct sas_task *);
+	int (*lldd_abort_task_set)(struct domain_device *, u8 *lun);
+	int (*lldd_clear_aca)(struct domain_device *, u8 *lun);
+	int (*lldd_clear_task_set)(struct domain_device *, u8 *lun);
+	int (*lldd_I_T_nexus_reset)(struct domain_device *);
+	int (*lldd_lu_reset)(struct domain_device *, u8 *lun);
+	int (*lldd_query_task)(struct sas_task *);
+
+	/* Port and Adapter management */
+	int (*lldd_clear_nexus_port)(struct asd_sas_port *);
+	int (*lldd_clear_nexus_ha)(struct sas_ha_struct *);
+
+	/* Phy management */
+	int (*lldd_control_phy)(struct asd_sas_phy *, enum phy_func);
+};
+
+extern int sas_register_ha(struct sas_ha_struct *);
+extern int sas_unregister_ha(struct sas_ha_struct *);
+
+extern int sas_queuecommand(struct scsi_cmnd *,
+		     void (*scsi_done)(struct scsi_cmnd *));
+extern int sas_target_alloc(struct scsi_target *);
+extern int sas_slave_alloc(struct scsi_device *);
+extern int sas_slave_configure(struct scsi_device *);
+extern void sas_slave_destroy(struct scsi_device *);
+extern int sas_change_queue_depth(struct scsi_device *, int new_depth);
+extern int sas_change_queue_type(struct scsi_device *, int qt);
+extern int sas_bios_param(struct scsi_device *,
+			  struct block_device *,
+			  sector_t capacity, int *hsc);
+extern struct scsi_transport_template *
+sas_domain_attach_transport(struct sas_domain_function_template *);
+extern void sas_domain_release_transport(struct scsi_transport_template
*);
+
+int  sas_discover_root_expander(struct domain_device *);
+
+void sas_init_ex_attr(void);
+
+int  sas_ex_revalidate_domain(struct domain_device *);
+
+
+void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
+int  sas_discover_event(struct asd_sas_port *, enum discover_event ev);
+
+int  sas_discover_sata(struct domain_device *);
+int  sas_discover_end_dev(struct domain_device *);
+
+void sas_unregister_dev(struct domain_device *);
+
+void sas_unregister_devices(struct sas_ha_struct *);
+
+void sas_init_dev(struct domain_device *);
+
+#endif /* _SASLIB_H_ */
Index: linux-2.6.17-rc5/include/scsi/sas.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.17-rc5/include/scsi/sas.h	2006-06-02 17:51:22.000000000
-0700
@@ -0,0 +1,644 @@
+/*
+ * SAS structures and definitions header file
+ *
+ * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
+ * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+ *
+ */
+
+#ifndef _SAS_H_
+#define _SAS_H_
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+#define SAS_ADDR_SIZE        8
+#define HASHED_SAS_ADDR_SIZE 3
+#define SAS_ADDR(_sa) ((unsigned long long) be64_to_cpu(*(__be64
*)(_sa)))
+
+#define SMP_REQUEST             0x40
+#define SMP_RESPONSE            0x41
+
+#define SSP_DATA                0x01
+#define SSP_XFER_RDY            0x05
+#define SSP_COMMAND             0x06
+#define SSP_RESPONSE            0x07
+#define SSP_TASK                0x16
+
+#define SMP_REPORT_GENERAL       0x00
+#define SMP_REPORT_MANUF_INFO    0x01
+#define SMP_READ_GPIO_REG        0x02
+#define SMP_DISCOVER             0x10
+#define SMP_REPORT_PHY_ERR_LOG   0x11
+#define SMP_REPORT_PHY_SATA      0x12
+#define SMP_REPORT_ROUTE_INFO    0x13
+#define SMP_WRITE_GPIO_REG       0x82
+#define SMP_CONF_ROUTE_INFO      0x90
+#define SMP_PHY_CONTROL          0x91
+#define SMP_PHY_TEST_FUNCTION    0x92
+
+#define SMP_RESP_FUNC_ACC        0x00
+#define SMP_RESP_FUNC_UNK        0x01
+#define SMP_RESP_FUNC_FAILED     0x02
+#define SMP_RESP_INV_FRM_LEN     0x03
+#define SMP_RESP_NO_PHY          0x10
+#define SMP_RESP_NO_INDEX        0x11
+#define SMP_RESP_PHY_NO_SATA     0x12
+#define SMP_RESP_PHY_UNK_OP      0x13
+#define SMP_RESP_PHY_UNK_TESTF   0x14
+#define SMP_RESP_PHY_TEST_INPROG 0x15
+#define SMP_RESP_PHY_VACANT      0x16
+
+/* SAM TMFs */
+#define TMF_ABORT_TASK      0x01
+#define TMF_ABORT_TASK_SET  0x02
+#define TMF_CLEAR_TASK_SET  0x04
+#define TMF_LU_RESET        0x08
+#define TMF_CLEAR_ACA       0x40
+#define TMF_QUERY_TASK      0x80
+
+/* SAS TMF responses */
+#define TMF_RESP_FUNC_COMPLETE   0x00
+#define TMF_RESP_INVALID_FRAME   0x02
+#define TMF_RESP_FUNC_ESUPP      0x04
+#define TMF_RESP_FUNC_FAILED     0x05
+#define TMF_RESP_FUNC_SUCC       0x08
+#define TMF_RESP_NO_LUN          0x09
+#define TMF_RESP_OVERLAPPED_TAG  0x0A
+
+enum sas_oob_mode {
+	OOB_NOT_CONNECTED,
+	SATA_OOB_MODE,
+	SAS_OOB_MODE
+};
+
+/* See sas_discover.c if you plan on changing these.
+ */
+enum sas_dev_type {
+	NO_DEVICE   = 0,	  /* protocol */
+	SAS_END_DEV = 1,	  /* protocol */
+	EDGE_DEV    = 2,	  /* protocol */
+	FANOUT_DEV  = 3,	  /* protocol */
+	SAS_HA      = 4,
+	SATA_DEV    = 5,
+	SATA_PM     = 7,
+	SATA_PM_PORT= 8,
+};
+
+enum sas_phy_linkrate {
+	PHY_LINKRATE_NONE = 0,
+	PHY_LINKRATE_UNKNOWN = 0,
+	PHY_DISABLED,
+	PHY_RESET_PROBLEM,
+	PHY_SPINUP_HOLD,
+	PHY_PORT_SELECTOR,
+	PHY_LINKRATE_1_5 = 0x08,
+	PHY_LINKRATE_G1  = PHY_LINKRATE_1_5,
+	PHY_LINKRATE_3   = 0x09,
+	PHY_LINKRATE_G2  = PHY_LINKRATE_3,
+	PHY_LINKRATE_6   = 0x0A,
+};
+
+/* Partly from IDENTIFY address frame. */
+enum sas_proto {
+	SATA_PROTO    = 1,
+	SAS_PROTO_SMP = 2,	  /* protocol */
+	SAS_PROTO_STP = 4,	  /* protocol */
+	SAS_PROTO_SSP = 8,	  /* protocol */
+	SAS_PROTO_ALL = 0xE,
+};
+
+/* From the spec; local phys only */
+enum phy_func {
+	PHY_FUNC_NOP,
+	PHY_FUNC_LINK_RESET,		  /* Enables the phy */
+	PHY_FUNC_HARD_RESET,
+	PHY_FUNC_DISABLE,
+	PHY_FUNC_CLEAR_ERROR_LOG = 5,
+	PHY_FUNC_CLEAR_AFFIL,
+	PHY_FUNC_TX_SATA_PS_SIGNAL,
+	PHY_FUNC_RELEASE_SPINUP_HOLD = 0x10, /* LOCAL PORT ONLY! */
+};
+
+/* SAS LLDD would need to report only _very_few_ of those, like
BROADCAST.
+ * Most of those are here for completeness.
+ */
+enum sas_prim {
+	SAS_PRIM_AIP_NORMAL = 1,
+	SAS_PRIM_AIP_R0     = 2,
+	SAS_PRIM_AIP_R1     = 3,
+	SAS_PRIM_AIP_R2     = 4,
+	SAS_PRIM_AIP_WC     = 5,
+	SAS_PRIM_AIP_WD     = 6,
+	SAS_PRIM_AIP_WP     = 7,
+	SAS_PRIM_AIP_RWP    = 8,
+
+	SAS_PRIM_BC_CH      = 9,
+	SAS_PRIM_BC_RCH0    = 10,
+	SAS_PRIM_BC_RCH1    = 11,
+	SAS_PRIM_BC_R0      = 12,
+	SAS_PRIM_BC_R1      = 13,
+	SAS_PRIM_BC_R2      = 14,
+	SAS_PRIM_BC_R3      = 15,
+	SAS_PRIM_BC_R4      = 16,
+
+	SAS_PRIM_NOTIFY_ENSP= 17,
+	SAS_PRIM_NOTIFY_R0  = 18,
+	SAS_PRIM_NOTIFY_R1  = 19,
+	SAS_PRIM_NOTIFY_R2  = 20,
+
+	SAS_PRIM_CLOSE_CLAF = 21,
+	SAS_PRIM_CLOSE_NORM = 22,
+	SAS_PRIM_CLOSE_R0   = 23,
+	SAS_PRIM_CLOSE_R1   = 24,
+
+	SAS_PRIM_OPEN_RTRY  = 25,
+	SAS_PRIM_OPEN_RJCT  = 26,
+	SAS_PRIM_OPEN_ACPT  = 27,
+
+	SAS_PRIM_DONE       = 28,
+	SAS_PRIM_BREAK      = 29,
+
+	SATA_PRIM_DMAT      = 33,
+	SATA_PRIM_PMNAK     = 34,
+	SATA_PRIM_PMACK     = 35,
+	SATA_PRIM_PMREQ_S   = 36,
+	SATA_PRIM_PMREQ_P   = 37,
+	SATA_SATA_R_ERR     = 38,
+};
+
+enum sas_open_rej_reason {
+	/* Abandon open */
+	SAS_OREJ_UNKNOWN   = 0,
+	SAS_OREJ_BAD_DEST  = 1,
+	SAS_OREJ_CONN_RATE = 2,
+	SAS_OREJ_EPROTO    = 3,
+	SAS_OREJ_RESV_AB0  = 4,
+	SAS_OREJ_RESV_AB1  = 5,
+	SAS_OREJ_RESV_AB2  = 6,
+	SAS_OREJ_RESV_AB3  = 7,
+	SAS_OREJ_WRONG_DEST= 8,
+	SAS_OREJ_STP_NORES = 9,
+
+	/* Retry open */
+	SAS_OREJ_NO_DEST   = 10,
+	SAS_OREJ_PATH_BLOCKED = 11,
+	SAS_OREJ_RSVD_CONT0 = 12,
+	SAS_OREJ_RSVD_CONT1 = 13,
+	SAS_OREJ_RSVD_INIT0 = 14,
+	SAS_OREJ_RSVD_INIT1 = 15,
+	SAS_OREJ_RSVD_STOP0 = 16,
+	SAS_OREJ_RSVD_STOP1 = 17,
+	SAS_OREJ_RSVD_RETRY = 18,
+};
+
+struct  dev_to_host_fis {
+	u8     fis_type;	  /* 0x34 */
+	u8     flags;
+	u8     status;
+	u8     error;
+
+	u8     lbal;
+	union { u8 lbam; u8 byte_count_low; };
+	union { u8 lbah; u8 byte_count_high; };
+	u8     device;
+
+	u8     lbal_exp;
+	u8     lbam_exp;
+	u8     lbah_exp;
+	u8     _r_a;
+
+	union { u8  sector_count; u8 interrupt_reason; };
+	u8     sector_count_exp;
+	u8     _r_b;
+	u8     _r_c;
+
+	u32    _r_d;
+} __attribute__ ((packed));
+
+struct host_to_dev_fis {
+	u8     fis_type;	  /* 0x27 */
+	u8     flags;
+	u8     command;
+	u8     features;
+
+	u8     lbal;
+	union { u8 lbam; u8 byte_count_low; };
+	union { u8 lbah; u8 byte_count_high; };
+	u8     device;
+
+	u8     lbal_exp;
+	u8     lbam_exp;
+	u8     lbah_exp;
+	u8     features_exp;
+
+	union { u8  sector_count; u8 interrupt_reason; };
+	u8     sector_count_exp;
+	u8     _r_a;
+	u8     control;
+
+	u32    _r_b;
+} __attribute__ ((packed));
+
+/* Prefer to have code clarity over header file clarity.
+ */
+#ifdef __LITTLE_ENDIAN_BITFIELD
+struct sas_identify_frame {
+	/* Byte 0 */
+	u8  frame_type:4;
+	u8  dev_type:3;
+	u8  _un0:1;
+
+	/* Byte 1 */
+	u8  _un1;
+
+	/* Byte 2 */
+	union {
+		struct {
+			u8  _un20:1;
+			u8  smp_iport:1;
+			u8  stp_iport:1;
+			u8  ssp_iport:1;
+			u8  _un247:4;
+		};
+		u8 initiator_bits;
+	};
+
+	/* Byte 3 */
+	union {
+		struct {
+			u8  _un30:1;
+			u8 smp_tport:1;
+			u8 stp_tport:1;
+			u8 ssp_tport:1;
+			u8 _un347:4;
+		};
+		u8 target_bits;
+	};
+
+	/* Byte 4 - 11 */
+	u8 _un4_11[8];
+
+	/* Byte 12 - 19 */
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	/* Byte 20 */
+	u8 phy_id;
+
+	u8 _un21_27[7];
+
+	__be32 crc;
+} __attribute__ ((packed));
+
+struct ssp_frame_hdr {
+	u8     frame_type;
+	u8     hashed_dest_addr[HASHED_SAS_ADDR_SIZE];
+	u8     _r_a;
+	u8     hashed_src_addr[HASHED_SAS_ADDR_SIZE];
+	__be16 _r_b;
+
+	u8     changing_data_ptr:1;
+	u8     retransmit:1;
+	u8     retry_data_frames:1;
+	u8     _r_c:5;
+
+	u8     num_fill_bytes:2;
+	u8     _r_d:6;
+
+	u32    _r_e;
+	__be16 tag;
+	__be16 tptt;
+	__be32 data_offs;
+} __attribute__ ((packed));
+
+struct ssp_response_iu {
+	u8     _r_a[10];
+
+	u8     datapres:2;
+	u8     _r_b:6;
+
+	u8     status;
+
+	u32    _r_c;
+
+	__be32 sense_data_len;
+	__be32 response_data_len;
+
+	u8     resp_data[0];
+	u8     sense_data[0];
+} __attribute__ ((packed));
+
+/* ---------- SMP ---------- */
+
+struct report_general_resp {
+	__be16  change_count;
+	__be16  route_indexes;
+	u8      _r_a;
+	u8      num_phys;
+
+	u8      conf_route_table:1;
+	u8      configuring:1;
+	u8      _r_b:6;
+
+	u8      _r_c;
+
+	u8      enclosure_logical_id[8];
+
+	u8      _r_d[12];
+} __attribute__ ((packed));
+
+struct discover_resp {
+	u8    _r_a[5];
+
+	u8    phy_id;
+	__be16 _r_b;
+
+	u8    _r_c:4;
+	u8    attached_dev_type:3;
+	u8    _r_d:1;
+
+	u8    linkrate:4;
+	u8    _r_e:4;
+
+	u8    attached_sata_host:1;
+	u8    iproto:3;
+	u8    _r_f:4;
+
+	u8    attached_sata_dev:1;
+	u8    tproto:3;
+	u8    _r_g:3;
+	u8    attached_sata_ps:1;
+
+	u8    sas_addr[8];
+	u8    attached_sas_addr[8];
+	u8    attached_phy_id;
+
+	u8    _r_h[7];
+
+	u8    hmin_linkrate:4;
+	u8    pmin_linkrate:4;
+	u8    hmax_linkrate:4;
+	u8    pmax_linkrate:4;
+
+	u8    change_count;
+
+	u8    pptv:4;
+	u8    _r_i:3;
+	u8    virtual:1;
+
+	u8    routing_attr:4;
+	u8    _r_j:4;
+
+	u8    conn_type;
+	u8    conn_el_index;
+	u8    conn_phy_link;
+
+	u8    _r_k[8];
+} __attribute__ ((packed));
+
+struct report_phy_sata_resp {
+	u8    _r_a[5];
+
+	u8    phy_id;
+	u8    _r_b;
+
+	u8    affil_valid:1;
+	u8    affil_supp:1;
+	u8    _r_c:6;
+
+	u32    _r_d;
+
+	u8    stp_sas_addr[8];
+
+	struct dev_to_host_fis fis;
+
+	u32   _r_e;
+
+	u8    affil_stp_ini_addr[8];
+
+	__be32 crc;
+} __attribute__ ((packed));
+
+struct smp_resp {
+	u8    frame_type;
+	u8    function;
+	u8    result;
+	u8    reserved;
+	union {
+		struct report_general_resp  rg;
+		struct discover_resp        disc;
+		struct report_phy_sata_resp rps;
+	};
+} __attribute__ ((packed));
+
+#elif defined(__BIG_ENDIAN_BITFIELD)
+struct sas_identify_frame {
+	/* Byte 0 */
+	u8  _un0:1;
+	u8  dev_type:3;
+	u8  frame_type:4;
+
+	/* Byte 1 */
+	u8  _un1;
+
+	/* Byte 2 */
+	union {
+		struct {
+			u8  _un247:4;
+			u8  ssp_iport:1;
+			u8  stp_iport:1;
+			u8  smp_iport:1;
+			u8  _un20:1;
+		};
+		u8 initiator_bits;
+	};
+
+	/* Byte 3 */
+	union {
+		struct {
+			u8 _un347:4;
+			u8 ssp_tport:1;
+			u8 stp_tport:1;
+			u8 smp_tport:1;
+			u8 _un30:1;
+		};
+		u8 target_bits;
+	};
+
+	/* Byte 4 - 11 */
+	u8 _un4_11[8];
+
+	/* Byte 12 - 19 */
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	/* Byte 20 */
+	u8 phy_id;
+
+	u8 _un21_27[7];
+
+	__be32 crc;
+} __attribute__ ((packed));
+
+struct ssp_frame_hdr {
+	u8     frame_type;
+	u8     hashed_dest_addr[HASHED_SAS_ADDR_SIZE];
+	u8     _r_a;
+	u8     hashed_src_addr[HASHED_SAS_ADDR_SIZE];
+	__be16 _r_b;
+
+	u8     _r_c:5;
+	u8     retry_data_frames:1;
+	u8     retransmit:1;
+	u8     changing_data_ptr:1;
+
+	u8     _r_d:6;
+	u8     num_fill_bytes:2;
+
+	u32    _r_e;
+	__be16 tag;
+	__be16 tptt;
+	__be32 data_offs;
+} __attribute__ ((packed));
+
+struct ssp_response_iu {
+	u8     _r_a[10];
+
+	u8     _r_b:6;
+	u8     datapres:2;
+
+	u8     status;
+
+	u32    _r_c;
+
+	__be32 sense_data_len;
+	__be32 response_data_len;
+
+	u8     resp_data[0];
+	u8     sense_data[0];
+} __attribute__ ((packed));
+
+/* ---------- SMP ---------- */
+
+struct report_general_resp {
+	__be16  change_count;
+	__be16  route_indexes;
+	u8      _r_a;
+	u8      num_phys;
+
+	u8      _r_b:6;
+	u8      configuring:1;
+	u8      conf_route_table:1;
+
+	u8      _r_c;
+
+	u8      enclosure_logical_id[8];
+
+	u8      _r_d[12];
+} __attribute__ ((packed));
+
+struct discover_resp {
+	u8    _r_a[5];
+
+	u8    phy_id;
+	__be16 _r_b;
+
+	u8    _r_d:1;
+	u8    attached_dev_type:3;
+	u8    _r_c:4;
+
+	u8    _r_e:4;
+	u8    linkrate:4;
+
+	u8    _r_f:4;
+	u8    iproto:3;
+	u8    attached_sata_host:1;
+
+	u8    attached_sata_ps:1;
+	u8    _r_g:3;
+	u8    tproto:3;
+	u8    attached_sata_dev:1;
+
+	u8    sas_addr[8];
+	u8    attached_sas_addr[8];
+	u8    attached_phy_id;
+
+	u8    _r_h[7];
+
+	u8    pmin_linkrate:4;
+	u8    hmin_linkrate:4;
+	u8    pmax_linkrate:4;
+	u8    hmax_linkrate:4;
+
+	u8    change_count;
+
+	u8    virtual:1;
+	u8    _r_i:3;
+	u8    pptv:4;
+
+	u8    _r_j:4;
+	u8    routing_attr:4;
+
+	u8    conn_type;
+	u8    conn_el_index;
+	u8    conn_phy_link;
+
+	u8    _r_k[8];
+} __attribute__ ((packed));
+
+struct report_phy_sata_resp {
+	u8    _r_a[5];
+
+	u8    phy_id;
+	u8    _r_b;
+
+	u8    _r_c:6;
+	u8    affil_supp:1;
+	u8    affil_valid:1;
+
+	u32   _r_d;
+
+	u8    stp_sas_addr[8];
+
+	struct dev_to_host_fis fis;
+
+	u32   _r_e;
+
+	u8    affil_stp_ini_addr[8];
+
+	__be32 crc;
+} __attribute__ ((packed));
+
+struct smp_resp {
+	u8    frame_type;
+	u8    function;
+	u8    result;
+	u8    reserved;
+	union {
+		struct report_general_resp  rg;
+		struct discover_resp        disc;
+		struct report_phy_sata_resp rps;
+	};
+} __attribute__ ((packed));
+
+#else
+#error "Bitfield order not defined!"
+#endif
+
+#endif /* _SAS_H_ */
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_hwi.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-06-05
12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-06-06
15:21:28.000000000 -0700
@@ -29,8 +29,6 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 
-#include <scsi/sas/sas_task.h>
-
 #include "aic94xx.h"
 #include "aic94xx_reg.h"
 #include "aic94xx_hwi.h"
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_hwi.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_hwi.h	2006-06-05
12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_hwi.h	2006-06-06
15:21:28.000000000 -0700
@@ -32,7 +32,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 
-#include <scsi/sas/sas_class.h>
+#include <scsi/libsas.h>
 
 #include "aic94xx.h"
 #include "aic94xx_sas.h"
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_sas.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_sas.h	2006-06-05
12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_sas.h	2006-06-06
15:21:28.000000000 -0700
@@ -28,8 +28,7 @@
 #ifndef _AIC94XX_SAS_H_
 #define _AIC94XX_SAS_H_
 
-#include <scsi/sas/sas_class.h>
-#include <scsi/sas/sas_discover.h>
+#include <scsi/libsas.h>
 
 /* ---------- DDBs ---------- */
 /* DDBs are device descriptor blocks which describe a device in the
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_task.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_task.c	2006-06-05
12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_task.c	2006-06-06
15:21:28.000000000 -0700
@@ -26,8 +26,6 @@
  */
 
 #include <linux/spinlock.h>
-#include <scsi/sas/sas_task.h>
-#include <scsi/sas/sas_frames.h>
 #include "aic94xx.h"
 #include "aic94xx_sas.h"
 #include "aic94xx_hwi.h"
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_discover.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_discover.c	2006-06-05
12:37:15.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_discover.c	2006-06-06
15:21:32.000000000 -0700
@@ -28,8 +28,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_eh.h>
 #include "sas_internal.h"
-#include <scsi/sas/sas_task.h>
-#include <scsi/sas/sas_discover.h>
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_event.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_event.c	2006-06-05
12:37:09.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_event.c	2006-06-06
15:21:28.000000000 -0700
@@ -66,7 +66,6 @@
 #include <scsi/scsi_host.h>
 #include "sas_internal.h"
 #include "sas_dump.h"
-#include <scsi/sas/sas_discover.h>
 
 static void notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event
event)
 {
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_expander.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_expander.c	2006-06-05
12:37:09.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_expander.c	2006-06-06
15:21:28.000000000 -0700
@@ -27,8 +27,6 @@
 #include <linux/scatterlist.h>
 
 #include "sas_internal.h"
-#include <scsi/sas/sas_task.h>
-#include <scsi/sas/sas_discover.h>
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_init.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_init.c	2006-06-05
12:37:09.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_init.c	2006-06-06
15:21:28.000000000 -0700
@@ -34,7 +34,6 @@
 #include <scsi/scsi_transport_sas.h>
 
 #include "sas_internal.h"
-#include <scsi/sas/sas_task.h>
 
 #include "../scsi_sas_internal.h"
 
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_internal.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_internal.h	2006-06-05
12:37:09.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_internal.h	2006-06-06
15:26:09.000000000 -0700
@@ -27,7 +27,7 @@
 #ifndef _SAS_INTERNAL_H_
 #define _SAS_INTERNAL_H_
 
-#include <scsi/sas/sas_class.h>
+#include <scsi/libsas.h>
 #include <scsi/scsi_host.h>
 
 #define sas_printk(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ##
__VA_ARGS__)
@@ -71,7 +71,8 @@
 
 void sas_hae_reset(void *);
 
-static inline void sas_queue_event(int event, spinlock_t *lock, u32
*pending,
+static inline void sas_queue_event(int event, spinlock_t *lock, 
+				   unsigned long *pending,
 				   struct work_struct *work,
 				   struct Scsi_Host *shost)
 {
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_port.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_port.c	2006-06-05
12:37:09.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_port.c	2006-06-06
15:21:28.000000000 -0700
@@ -24,7 +24,6 @@
  */
 
 #include "sas_internal.h"
-#include <scsi/sas/sas_discover.h>
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_scsi_host.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_scsi_host.c	2006-06-05
12:37:09.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_scsi_host.c	2006-06-06
15:21:28.000000000 -0700
@@ -25,8 +25,6 @@
  */
 
 #include "sas_internal.h"
-#include <scsi/sas/sas_discover.h>
-#include <scsi/sas/sas_task.h>
 
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
Index: linux-2.6.17-rc5/drivers/scsi/sas/expander_conf.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/expander_conf.c	2006-06-02
15:47:49.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/expander_conf.c	2006-06-06
14:03:02.000000000 -0700
@@ -50,7 +50,7 @@
 #include <byteswap.h>
 #include <stdint.h>
 #include <stdlib.h>
-#include <scsi/sas/sas.h>
+#include <scsi/sas.h>
 
 #define LEFT_FIELD_SIZE 25
 
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_tmf.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_tmf.c	2006-06-05
12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_tmf.c	2006-06-06
15:21:28.000000000 -0700
@@ -26,7 +26,6 @@
  */
 
 #include <linux/spinlock.h>
-#include <scsi/sas/sas_task.h>
 #include "aic94xx.h"
 #include "aic94xx_sas.h"
 #include "aic94xx_hwi.h"
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx.h	2006-06-05
12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx.h	2006-06-06
14:56:03.000000000 -0700
@@ -30,7 +30,7 @@
 
 #include <linux/slab.h>
 #include <linux/ctype.h>
-#include <scsi/sas/sas_discover.h>
+#include <scsi/libsas.h>
 
 #define ASD_DRIVER_NAME		"aic94xx"
 #define ASD_DRIVER_DESCRIPTION	"Adaptec aic94xx SAS/SATA driver"


