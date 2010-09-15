From: <kgudipat@brocade.com>
Subject: [PATCH 22/33] bfa: Add back cleaned up bfa to firmware interface header files.
Date: Wed, 15 Sep 2010 12:12:26 -0700
Message-ID: <1284577946-20599-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34496 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115Ab0IOTMv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 15:12:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Adding back the cleaned up bfa to firmware interface header files.
	  bfi.h, bfi_ms.h : Hold the structures for BFA to interact with the firwmare.
	  bfi_cbreg.h, bfi_ctreg.h: Hold the ASIC specific register information.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfi.h       |  579 ++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfi_cbreg.h |  304 +++++++++++++++++
 drivers/scsi/bfa/bfi_ctreg.h |  627 ++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfi_ms.h    |  765 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 2275 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfi.h
 create mode 100644 drivers/scsi/bfa/bfi_cbreg.h
 create mode 100644 drivers/scsi/bfa/bfi_ctreg.h
 create mode 100644 drivers/scsi/bfa/bfi_ms.h

diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
new file mode 100644
index 0000000..85f2224
--- /dev/null
+++ b/drivers/scsi/bfa/bfi.h
@@ -0,0 +1,579 @@
+/*
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_H__
+#define __BFI_H__
+
+#include "bfa_defs.h"
+#include "bfa_defs_svc.h"
+
+#pragma pack(1)
+
+/**
+ * BFI FW image type
+ */
+#define	BFI_FLASH_CHUNK_SZ			256	/*  Flash chunk size */
+#define	BFI_FLASH_CHUNK_SZ_WORDS	(BFI_FLASH_CHUNK_SZ/sizeof(u32))
+enum {
+	BFI_IMAGE_CB_FC,
+	BFI_IMAGE_CT_FC,
+	BFI_IMAGE_CT_CNA,
+	BFI_IMAGE_MAX,
+};
+
+/**
+ * Msg header common to all msgs
+ */
+struct bfi_mhdr_s {
+	u8		msg_class;	/*  @ref bfi_mclass_t		    */
+	u8		msg_id;		/*  msg opcode with in the class   */
+	union {
+		struct {
+			u8	rsvd;
+			u8	lpu_id;	/*  msg destination		    */
+		} h2i;
+		u16	i2htok;	/*  token in msgs to host	    */
+	} mtag;
+};
+
+#define bfi_h2i_set(_mh, _mc, _op, _lpuid) do {		\
+	(_mh).msg_class		= (_mc);      \
+	(_mh).msg_id		= (_op);      \
+	(_mh).mtag.h2i.lpu_id	= (_lpuid);      \
+} while (0)
+
+#define bfi_i2h_set(_mh, _mc, _op, _i2htok) do {		\
+	(_mh).msg_class		= (_mc);      \
+	(_mh).msg_id		= (_op);      \
+	(_mh).mtag.i2htok	= (_i2htok);      \
+} while (0)
+
+/*
+ * Message opcodes: 0-127 to firmware, 128-255 to host
+ */
+#define BFI_I2H_OPCODE_BASE	128
+#define BFA_I2HM(_x)		((_x) + BFI_I2H_OPCODE_BASE)
+
+/**
+ ****************************************************************************
+ *
+ * Scatter Gather Element and Page definition
+ *
+ ****************************************************************************
+ */
+
+#define BFI_SGE_INLINE	1
+#define BFI_SGE_INLINE_MAX	(BFI_SGE_INLINE + 1)
+
+/**
+ * SG Flags
+ */
+enum {
+	BFI_SGE_DATA		= 0,	/*  data address, not last	     */
+	BFI_SGE_DATA_CPL	= 1,	/*  data addr, last in current page */
+	BFI_SGE_DATA_LAST	= 3,	/*  data address, last		     */
+	BFI_SGE_LINK		= 2,	/*  link address		     */
+	BFI_SGE_PGDLEN		= 2,	/*  cumulative data length for page */
+};
+
+/**
+ * DMA addresses
+ */
+union bfi_addr_u {
+	struct {
+		u32	addr_lo;
+		u32	addr_hi;
+	} a32;
+};
+
+/**
+ * Scatter Gather Element
+ */
+struct bfi_sge_s {
+#ifdef __BIGENDIAN
+	u32	flags:2,
+			rsvd:2,
+			sg_len:28;
+#else
+	u32	sg_len:28,
+			rsvd:2,
+			flags:2;
+#endif
+	union bfi_addr_u sga;
+};
+
+/**
+ * Scatter Gather Page
+ */
+#define BFI_SGPG_DATA_SGES		7
+#define BFI_SGPG_SGES_MAX		(BFI_SGPG_DATA_SGES + 1)
+#define BFI_SGPG_RSVD_WD_LEN	8
+struct bfi_sgpg_s {
+	struct bfi_sge_s sges[BFI_SGPG_SGES_MAX];
+	u32	rsvd[BFI_SGPG_RSVD_WD_LEN];
+};
+
+/*
+ * Large Message structure - 128 Bytes size Msgs
+ */
+#define BFI_LMSG_SZ		128
+#define BFI_LMSG_PL_WSZ	\
+			((BFI_LMSG_SZ - sizeof(struct bfi_mhdr_s)) / 4)
+
+struct bfi_msg_s {
+	struct bfi_mhdr_s mhdr;
+	u32	pl[BFI_LMSG_PL_WSZ];
+};
+
+/**
+ * Mailbox message structure
+ */
+#define BFI_MBMSG_SZ		7
+struct bfi_mbmsg_s {
+	struct bfi_mhdr_s	mh;
+	u32		pl[BFI_MBMSG_SZ];
+};
+
+/**
+ * Message Classes
+ */
+enum bfi_mclass {
+	BFI_MC_IOC		= 1,	/*  IO Controller (IOC)	    */
+	BFI_MC_FCPORT		= 5,	/*  FC port			    */
+	BFI_MC_IOCFC		= 6,	/*  FC - IO Controller (IOC)	    */
+	BFI_MC_LL               = 7,    /*  Link Layer                      */
+	BFI_MC_UF		= 8,	/*  Unsolicited frame receive	    */
+	BFI_MC_FCXP		= 9,	/*  FC Transport		    */
+	BFI_MC_LPS		= 10,	/*  lport fc login services	    */
+	BFI_MC_RPORT		= 11,	/*  Remote port		    */
+	BFI_MC_ITNIM		= 12,	/*  I-T nexus (Initiator mode)	    */
+	BFI_MC_IOIM_READ	= 13,	/*  read IO (Initiator mode)	    */
+	BFI_MC_IOIM_WRITE	= 14,	/*  write IO (Initiator mode)	    */
+	BFI_MC_IOIM_IO		= 15,	/*  IO (Initiator mode)	    */
+	BFI_MC_IOIM		= 16,	/*  IO (Initiator mode)	    */
+	BFI_MC_IOIM_IOCOM	= 17,	/*  good IO completion		    */
+	BFI_MC_TSKIM		= 18,	/*  Initiator Task management	    */
+	BFI_MC_PORT		= 21,	/*  Physical port		    */
+	BFI_MC_MAX		= 32
+};
+
+#define BFI_IOC_MAX_CQS		4
+#define BFI_IOC_MAX_CQS_ASIC	8
+#define BFI_IOC_MSGLEN_MAX	32	/* 32 bytes */
+
+#define BFI_BOOT_TYPE_OFF		8
+#define BFI_BOOT_LOADER_OFF		12
+
+#define BFI_BOOT_TYPE_NORMAL		0
+#define	BFI_BOOT_TYPE_FLASH		1
+#define	BFI_BOOT_TYPE_MEMTEST		2
+
+#define BFI_BOOT_LOADER_OS		0
+#define BFI_BOOT_LOADER_BIOS		1
+#define BFI_BOOT_LOADER_UEFI		2
+
+/**
+ *----------------------------------------------------------------------
+ *				IOC
+ *----------------------------------------------------------------------
+ */
+
+enum bfi_ioc_h2i_msgs {
+	BFI_IOC_H2I_ENABLE_REQ		= 1,
+	BFI_IOC_H2I_DISABLE_REQ		= 2,
+	BFI_IOC_H2I_GETATTR_REQ		= 3,
+	BFI_IOC_H2I_DBG_SYNC		= 4,
+	BFI_IOC_H2I_DBG_DUMP		= 5,
+};
+
+enum bfi_ioc_i2h_msgs {
+	BFI_IOC_I2H_ENABLE_REPLY	= BFA_I2HM(1),
+	BFI_IOC_I2H_DISABLE_REPLY	= BFA_I2HM(2),
+	BFI_IOC_I2H_GETATTR_REPLY	= BFA_I2HM(3),
+	BFI_IOC_I2H_READY_EVENT		= BFA_I2HM(4),
+	BFI_IOC_I2H_HBEAT		= BFA_I2HM(5),
+};
+
+/**
+ * BFI_IOC_H2I_GETATTR_REQ message
+ */
+struct bfi_ioc_getattr_req_s {
+	struct bfi_mhdr_s	mh;
+	union bfi_addr_u	attr_addr;
+};
+
+struct bfi_ioc_attr_s {
+	wwn_t		mfg_pwwn;	/*  Mfg port wwn	   */
+	wwn_t		mfg_nwwn;	/*  Mfg node wwn	   */
+	mac_t		mfg_mac;	/*  Mfg mac		   */
+	u16	rsvd_a;
+	wwn_t		pwwn;
+	wwn_t		nwwn;
+	mac_t		mac;		/*  PBC or Mfg mac	   */
+	u16	rsvd_b;
+	mac_t		fcoe_mac;
+	u16	rsvd_c;
+	char		brcd_serialnum[STRSZ(BFA_MFG_SERIALNUM_SIZE)];
+	u8		pcie_gen;
+	u8		pcie_lanes_orig;
+	u8		pcie_lanes;
+	u8		rx_bbcredit;	/*  receive buffer credits */
+	u32	adapter_prop;	/*  adapter properties     */
+	u16	maxfrsize;	/*  max receive frame size */
+	char		asic_rev;
+	u8		rsvd_d;
+	char		fw_version[BFA_VERSION_LEN];
+	char		optrom_version[BFA_VERSION_LEN];
+	struct		bfa_mfg_vpd_s	vpd;
+	u32	card_type;	/*  card type			*/
+};
+
+/**
+ * BFI_IOC_I2H_GETATTR_REPLY message
+ */
+struct bfi_ioc_getattr_reply_s {
+	struct	bfi_mhdr_s	mh;	/*  Common msg header		*/
+	u8			status;	/*  cfg reply status		*/
+	u8			rsvd[3];
+};
+
+/**
+ * Firmware memory page offsets
+ */
+#define BFI_IOC_SMEM_PG0_CB	(0x40)
+#define BFI_IOC_SMEM_PG0_CT	(0x180)
+
+/**
+ * Firmware statistic offset
+ */
+#define BFI_IOC_FWSTATS_OFF	(0x6B40)
+#define BFI_IOC_FWSTATS_SZ	(4096)
+
+/**
+ * Firmware trace offset
+ */
+#define BFI_IOC_TRC_OFF		(0x4b00)
+#define BFI_IOC_TRC_ENTS	256
+
+#define BFI_IOC_FW_SIGNATURE	(0xbfadbfad)
+#define BFI_IOC_MD5SUM_SZ	4
+struct bfi_ioc_image_hdr_s {
+	u32	signature;	/*  constant signature */
+	u32	rsvd_a;
+	u32	exec;		/*  exec vector	*/
+	u32	param;		/*  parameters		*/
+	u32	rsvd_b[4];
+	u32	md5sum[BFI_IOC_MD5SUM_SZ];
+};
+
+/**
+ *  BFI_IOC_I2H_READY_EVENT message
+ */
+struct bfi_ioc_rdy_event_s {
+	struct bfi_mhdr_s	mh;		/*  common msg header */
+	u8			init_status;	/*  init event status */
+	u8			rsvd[3];
+};
+
+struct bfi_ioc_hbeat_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u32	   hb_count;	/*  current heart beat count	*/
+};
+
+/**
+ * IOC hardware/firmware state
+ */
+enum bfi_ioc_state {
+	BFI_IOC_UNINIT		= 0,	/*  not initialized		     */
+	BFI_IOC_INITING		= 1,	/*  h/w is being initialized	     */
+	BFI_IOC_HWINIT		= 2,	/*  h/w is initialized		     */
+	BFI_IOC_CFG		= 3,	/*  IOC configuration in progress   */
+	BFI_IOC_OP		= 4,	/*  IOC is operational		     */
+	BFI_IOC_DISABLING	= 5,	/*  IOC is being disabled	     */
+	BFI_IOC_DISABLED	= 6,	/*  IOC is disabled		     */
+	BFI_IOC_CFG_DISABLED	= 7,	/*  IOC is being disabled;transient */
+	BFI_IOC_FAIL		= 8,	/*  IOC heart-beat failure	     */
+	BFI_IOC_MEMTEST		= 9,	/*  IOC is doing memtest	     */
+};
+
+#define BFI_IOC_ENDIAN_SIG  0x12345678
+
+enum {
+	BFI_ADAPTER_TYPE_FC	= 0x01,		/*  FC adapters	   */
+	BFI_ADAPTER_TYPE_MK	= 0x0f0000,	/*  adapter type mask     */
+	BFI_ADAPTER_TYPE_SH	= 16,	        /*  adapter type shift    */
+	BFI_ADAPTER_NPORTS_MK	= 0xff00,	/*  number of ports mask  */
+	BFI_ADAPTER_NPORTS_SH	= 8,	        /*  number of ports shift */
+	BFI_ADAPTER_SPEED_MK	= 0xff,		/*  adapter speed mask    */
+	BFI_ADAPTER_SPEED_SH	= 0,	        /*  adapter speed shift   */
+	BFI_ADAPTER_PROTO	= 0x100000,	/*  prototype adapaters   */
+	BFI_ADAPTER_TTV		= 0x200000,	/*  TTV debug capable     */
+	BFI_ADAPTER_UNSUPP	= 0x400000,	/*  unknown adapter type  */
+};
+
+#define BFI_ADAPTER_GETP(__prop, __adap_prop)			\
+	(((__adap_prop) & BFI_ADAPTER_ ## __prop ## _MK) >>	\
+		BFI_ADAPTER_ ## __prop ## _SH)
+#define BFI_ADAPTER_SETP(__prop, __val)				\
+	((__val) << BFI_ADAPTER_ ## __prop ## _SH)
+#define BFI_ADAPTER_IS_PROTO(__adap_type)			\
+	((__adap_type) & BFI_ADAPTER_PROTO)
+#define BFI_ADAPTER_IS_TTV(__adap_type)				\
+	((__adap_type) & BFI_ADAPTER_TTV)
+#define BFI_ADAPTER_IS_UNSUPP(__adap_type)			\
+	((__adap_type) & BFI_ADAPTER_UNSUPP)
+#define BFI_ADAPTER_IS_SPECIAL(__adap_type)			\
+	((__adap_type) & (BFI_ADAPTER_TTV | BFI_ADAPTER_PROTO |	\
+			BFI_ADAPTER_UNSUPP))
+
+/**
+ * BFI_IOC_H2I_ENABLE_REQ & BFI_IOC_H2I_DISABLE_REQ messages
+ */
+struct bfi_ioc_ctrl_req_s {
+	struct bfi_mhdr_s	mh;
+	u8			ioc_class;
+	u8			rsvd[3];
+	u32		tv_sec;
+};
+#define bfi_ioc_enable_req_t struct bfi_ioc_ctrl_req_s;
+#define bfi_ioc_disable_req_t struct bfi_ioc_ctrl_req_s;
+
+/**
+ * BFI_IOC_I2H_ENABLE_REPLY & BFI_IOC_I2H_DISABLE_REPLY messages
+ */
+struct bfi_ioc_ctrl_reply_s {
+	struct bfi_mhdr_s	mh;		/*  Common msg header     */
+	u8			status;		/*  enable/disable status */
+	u8			rsvd[3];
+};
+#define bfi_ioc_enable_reply_t struct bfi_ioc_ctrl_reply_s;
+#define bfi_ioc_disable_reply_t struct bfi_ioc_ctrl_reply_s;
+
+#define BFI_IOC_MSGSZ   8
+/**
+ * H2I Messages
+ */
+union bfi_ioc_h2i_msg_u {
+	struct bfi_mhdr_s		mh;
+	struct bfi_ioc_ctrl_req_s	enable_req;
+	struct bfi_ioc_ctrl_req_s	disable_req;
+	struct bfi_ioc_getattr_req_s	getattr_req;
+	u32			mboxmsg[BFI_IOC_MSGSZ];
+};
+
+/**
+ * I2H Messages
+ */
+union bfi_ioc_i2h_msg_u {
+	struct bfi_mhdr_s		mh;
+	struct bfi_ioc_rdy_event_s	rdy_event;
+	u32			mboxmsg[BFI_IOC_MSGSZ];
+};
+
+
+/**
+ *----------------------------------------------------------------------
+ *				PBC
+ *----------------------------------------------------------------------
+ */
+
+#define BFI_PBC_MAX_BLUNS	8
+#define BFI_PBC_MAX_VPORTS	16
+
+/**
+ * PBC boot lun configuration
+ */
+struct bfi_pbc_blun_s {
+	wwn_t		tgt_pwwn;
+	lun_t		tgt_lun;
+};
+
+/**
+ * PBC virtual port configuration
+ */
+struct bfi_pbc_vport_s {
+	wwn_t		vp_pwwn;
+	wwn_t		vp_nwwn;
+};
+
+/**
+ * BFI pre-boot configuration information
+ */
+struct bfi_pbc_s {
+	u8		port_enabled;
+	u8		boot_enabled;
+	u8		nbluns;
+	u8		nvports;
+	u8		port_speed;
+	u8		rsvd_a;
+	u16	hss;
+	wwn_t		pbc_pwwn;
+	wwn_t		pbc_nwwn;
+	struct bfi_pbc_blun_s blun[BFI_PBC_MAX_BLUNS];
+	struct bfi_pbc_vport_s vport[BFI_PBC_MAX_VPORTS];
+};
+
+/**
+ *----------------------------------------------------------------------
+ *				MSGQ
+ *----------------------------------------------------------------------
+ */
+#define BFI_MSGQ_FULL(_q)	(((_q->pi + 1) % _q->q_depth) == _q->ci)
+#define BFI_MSGQ_EMPTY(_q)	(_q->pi == _q->ci)
+#define BFI_MSGQ_UPDATE_CI(_q)	(_q->ci = (_q->ci + 1) % _q->q_depth)
+#define BFI_MSGQ_UPDATE_PI(_q)	(_q->pi = (_q->pi + 1) % _q->q_depth)
+
+/* q_depth must be power of 2 */
+#define BFI_MSGQ_FREE_CNT(_q)	((_q->ci - _q->pi - 1) & (_q->q_depth - 1))
+
+enum bfi_msgq_h2i_msgs_e {
+	BFI_MSGQ_H2I_INIT_REQ	= 1,
+	BFI_MSGQ_H2I_DOORBELL	= 2,
+	BFI_MSGQ_H2I_SHUTDOWN	= 3,
+};
+
+enum bfi_msgq_i2h_msgs_e {
+	BFI_MSGQ_I2H_INIT_RSP	= 1,
+	BFI_MSGQ_I2H_DOORBELL	= 2,
+};
+
+
+/* Messages(commands/responsed/AENS will have the following header */
+struct bfi_msgq_mhdr_s {
+	u8		msg_class;
+	u8		msg_id;
+	u16	msg_token;
+	u16	num_entries;
+	u8		enet_id;
+	u8		rsvd[1];
+};
+
+#define bfi_msgq_mhdr_set(_mh, _mc, _mid, _tok, _enet_id) do {        \
+	(_mh).msg_class		= (_mc);      \
+	(_mh).msg_id		= (_mid);      \
+	(_mh).msg_token		= (_tok);      \
+	(_mh).enet_id		= (_enet_id);      \
+} while (0)
+
+/*
+ * Mailbox  for messaging interface
+ *
+*/
+#define BFI_MSGQ_CMD_ENTRY_SIZE		(64)    /* TBD */
+#define BFI_MSGQ_RSP_ENTRY_SIZE		(64)    /* TBD */
+#define BFI_MSGQ_MSG_SIZE_MAX		(2048)  /* TBD */
+
+struct bfi_msgq_s {
+	union bfi_addr_u addr;
+	u16 q_depth;     /* Total num of entries in the queue */
+	u8 rsvd[2];
+};
+
+/* BFI_ENET_MSGQ_CFG_REQ TBD init or cfg? */
+struct bfi_msgq_cfg_req_s {
+	struct bfi_mhdr_s mh;
+	struct bfi_msgq_s cmdq;
+	struct bfi_msgq_s rspq;
+};
+
+/* BFI_ENET_MSGQ_CFG_RSP */
+struct bfi_msgq_cfg_rsp_s {
+	struct bfi_mhdr_s mh;
+	u8 cmd_status;
+	u8 rsvd[3];
+};
+
+
+/* BFI_MSGQ_H2I_DOORBELL */
+struct bfi_msgq_h2i_db_s {
+	struct bfi_mhdr_s mh;
+	u16 cmdq_pi;
+	u16 rspq_ci;
+};
+
+/* BFI_MSGQ_I2H_DOORBELL */
+struct bfi_msgq_i2h_db_s {
+	struct bfi_mhdr_s mh;
+	u16 rspq_pi;
+	u16 cmdq_ci;
+};
+
+#pragma pack()
+
+/* BFI port specific */
+#pragma pack(1)
+
+enum bfi_port_h2i {
+	BFI_PORT_H2I_ENABLE_REQ         = (1),
+	BFI_PORT_H2I_DISABLE_REQ        = (2),
+	BFI_PORT_H2I_GET_STATS_REQ      = (3),
+	BFI_PORT_H2I_CLEAR_STATS_REQ    = (4),
+};
+
+enum bfi_port_i2h {
+	BFI_PORT_I2H_ENABLE_RSP         = BFA_I2HM(1),
+	BFI_PORT_I2H_DISABLE_RSP        = BFA_I2HM(2),
+	BFI_PORT_I2H_GET_STATS_RSP      = BFA_I2HM(3),
+	BFI_PORT_I2H_CLEAR_STATS_RSP    = BFA_I2HM(4),
+};
+
+/**
+ * Generic REQ type
+ */
+struct bfi_port_generic_req_s {
+	struct bfi_mhdr_s  mh;          /*  msg header		*/
+	u32     msgtag;         /*  msgtag for reply                */
+	u32     rsvd;
+};
+
+/**
+ * Generic RSP type
+ */
+struct bfi_port_generic_rsp_s {
+	struct bfi_mhdr_s  mh;          /*  common msg header               */
+	u8              status;         /*  port enable status              */
+	u8              rsvd[3];
+	u32     msgtag;         /*  msgtag for reply                */
+};
+
+/**
+ * BFI_PORT_H2I_GET_STATS_REQ
+ */
+struct bfi_port_get_stats_req_s {
+	struct bfi_mhdr_s  mh;          /*  common msg header               */
+	union bfi_addr_u   dma_addr;
+};
+
+union bfi_port_h2i_msg_u {
+	struct bfi_mhdr_s               mh;
+	struct bfi_port_generic_req_s   enable_req;
+	struct bfi_port_generic_req_s   disable_req;
+	struct bfi_port_get_stats_req_s getstats_req;
+	struct bfi_port_generic_req_s   clearstats_req;
+};
+
+union bfi_port_i2h_msg_u {
+	struct bfi_mhdr_s               mh;
+	struct bfi_port_generic_rsp_s   enable_rsp;
+	struct bfi_port_generic_rsp_s   disable_rsp;
+	struct bfi_port_generic_rsp_s   getstats_rsp;
+	struct bfi_port_generic_rsp_s   clearstats_rsp;
+};
+
+#pragma pack()
+
+#endif /* __BFI_H__ */
diff --git a/drivers/scsi/bfa/bfi_cbreg.h b/drivers/scsi/bfa/bfi_cbreg.h
new file mode 100644
index 0000000..6f03ed3
--- /dev/null
+++ b/drivers/scsi/bfa/bfi_cbreg.h
@@ -0,0 +1,304 @@
+
+/*
+ * bfi_cbreg.h crossbow host block register definitions
+ *
+ * !!! Do not edit. Auto generated. !!!
+ */
+
+#ifndef __BFI_CBREG_H__
+#define __BFI_CBREG_H__
+
+
+#define HOSTFN0_INT_STATUS               0x00014000
+#define __HOSTFN0_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN0_INT_STATUS_LVL_SH      20
+#define __HOSTFN0_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN0_INT_STATUS_LVL_SH)
+#define __HOSTFN0_INT_STATUS_P           0x000fffff
+#define HOSTFN0_INT_MSK                  0x00014004
+#define HOST_PAGE_NUM_FN0                0x00014008
+#define __HOST_PAGE_NUM_FN               0x000001ff
+#define HOSTFN1_INT_STATUS               0x00014100
+#define __HOSTFN1_INT_STAT_LVL_MK        0x00f00000
+#define __HOSTFN1_INT_STAT_LVL_SH        20
+#define __HOSTFN1_INT_STAT_LVL(_v)       ((_v) << __HOSTFN1_INT_STAT_LVL_SH)
+#define __HOSTFN1_INT_STAT_P             0x000fffff
+#define HOSTFN1_INT_MSK                  0x00014104
+#define HOST_PAGE_NUM_FN1                0x00014108
+#define APP_PLL_400_CTL_REG              0x00014204
+#define __P_400_PLL_LOCK                 0x80000000
+#define __APP_PLL_400_SRAM_USE_100MHZ    0x00100000
+#define __APP_PLL_400_RESET_TIMER_MK     0x000e0000
+#define __APP_PLL_400_RESET_TIMER_SH     17
+#define __APP_PLL_400_RESET_TIMER(_v)    ((_v) << __APP_PLL_400_RESET_TIMER_SH)
+#define __APP_PLL_400_LOGIC_SOFT_RESET   0x00010000
+#define __APP_PLL_400_CNTLMT0_1_MK       0x0000c000
+#define __APP_PLL_400_CNTLMT0_1_SH       14
+#define __APP_PLL_400_CNTLMT0_1(_v)      ((_v) << __APP_PLL_400_CNTLMT0_1_SH)
+#define __APP_PLL_400_JITLMT0_1_MK       0x00003000
+#define __APP_PLL_400_JITLMT0_1_SH       12
+#define __APP_PLL_400_JITLMT0_1(_v)      ((_v) << __APP_PLL_400_JITLMT0_1_SH)
+#define __APP_PLL_400_HREF               0x00000800
+#define __APP_PLL_400_HDIV               0x00000400
+#define __APP_PLL_400_P0_1_MK            0x00000300
+#define __APP_PLL_400_P0_1_SH            8
+#define __APP_PLL_400_P0_1(_v)           ((_v) << __APP_PLL_400_P0_1_SH)
+#define __APP_PLL_400_Z0_2_MK            0x000000e0
+#define __APP_PLL_400_Z0_2_SH            5
+#define __APP_PLL_400_Z0_2(_v)           ((_v) << __APP_PLL_400_Z0_2_SH)
+#define __APP_PLL_400_RSEL200500         0x00000010
+#define __APP_PLL_400_ENARST             0x00000008
+#define __APP_PLL_400_BYPASS             0x00000004
+#define __APP_PLL_400_LRESETN            0x00000002
+#define __APP_PLL_400_ENABLE             0x00000001
+#define APP_PLL_212_CTL_REG              0x00014208
+#define __P_212_PLL_LOCK                 0x80000000
+#define __APP_PLL_212_RESET_TIMER_MK     0x000e0000
+#define __APP_PLL_212_RESET_TIMER_SH     17
+#define __APP_PLL_212_RESET_TIMER(_v)    ((_v) << __APP_PLL_212_RESET_TIMER_SH)
+#define __APP_PLL_212_LOGIC_SOFT_RESET   0x00010000
+#define __APP_PLL_212_CNTLMT0_1_MK       0x0000c000
+#define __APP_PLL_212_CNTLMT0_1_SH       14
+#define __APP_PLL_212_CNTLMT0_1(_v)      ((_v) << __APP_PLL_212_CNTLMT0_1_SH)
+#define __APP_PLL_212_JITLMT0_1_MK       0x00003000
+#define __APP_PLL_212_JITLMT0_1_SH       12
+#define __APP_PLL_212_JITLMT0_1(_v)      ((_v) << __APP_PLL_212_JITLMT0_1_SH)
+#define __APP_PLL_212_HREF               0x00000800
+#define __APP_PLL_212_HDIV               0x00000400
+#define __APP_PLL_212_P0_1_MK            0x00000300
+#define __APP_PLL_212_P0_1_SH            8
+#define __APP_PLL_212_P0_1(_v)           ((_v) << __APP_PLL_212_P0_1_SH)
+#define __APP_PLL_212_Z0_2_MK            0x000000e0
+#define __APP_PLL_212_Z0_2_SH            5
+#define __APP_PLL_212_Z0_2(_v)           ((_v) << __APP_PLL_212_Z0_2_SH)
+#define __APP_PLL_212_RSEL200500         0x00000010
+#define __APP_PLL_212_ENARST             0x00000008
+#define __APP_PLL_212_BYPASS             0x00000004
+#define __APP_PLL_212_LRESETN            0x00000002
+#define __APP_PLL_212_ENABLE             0x00000001
+#define HOST_SEM0_REG                    0x00014230
+#define __HOST_SEMAPHORE                 0x00000001
+#define HOST_SEM1_REG                    0x00014234
+#define HOST_SEM2_REG                    0x00014238
+#define HOST_SEM3_REG                    0x0001423c
+#define HOST_SEM0_INFO_REG               0x00014240
+#define HOST_SEM1_INFO_REG               0x00014244
+#define HOST_SEM2_INFO_REG               0x00014248
+#define HOST_SEM3_INFO_REG               0x0001424c
+#define HOSTFN0_LPU0_CMD_STAT            0x00019000
+#define __HOSTFN0_LPU0_MBOX_INFO_MK      0xfffffffe
+#define __HOSTFN0_LPU0_MBOX_INFO_SH      1
+#define __HOSTFN0_LPU0_MBOX_INFO(_v)     ((_v) << __HOSTFN0_LPU0_MBOX_INFO_SH)
+#define __HOSTFN0_LPU0_MBOX_CMD_STATUS   0x00000001
+#define LPU0_HOSTFN0_CMD_STAT            0x00019008
+#define __LPU0_HOSTFN0_MBOX_INFO_MK      0xfffffffe
+#define __LPU0_HOSTFN0_MBOX_INFO_SH      1
+#define __LPU0_HOSTFN0_MBOX_INFO(_v)     ((_v) << __LPU0_HOSTFN0_MBOX_INFO_SH)
+#define __LPU0_HOSTFN0_MBOX_CMD_STATUS   0x00000001
+#define HOSTFN1_LPU1_CMD_STAT            0x00019014
+#define __HOSTFN1_LPU1_MBOX_INFO_MK      0xfffffffe
+#define __HOSTFN1_LPU1_MBOX_INFO_SH      1
+#define __HOSTFN1_LPU1_MBOX_INFO(_v)     ((_v) << __HOSTFN1_LPU1_MBOX_INFO_SH)
+#define __HOSTFN1_LPU1_MBOX_CMD_STATUS   0x00000001
+#define LPU1_HOSTFN1_CMD_STAT            0x0001901c
+#define __LPU1_HOSTFN1_MBOX_INFO_MK      0xfffffffe
+#define __LPU1_HOSTFN1_MBOX_INFO_SH      1
+#define __LPU1_HOSTFN1_MBOX_INFO(_v)     ((_v) << __LPU1_HOSTFN1_MBOX_INFO_SH)
+#define __LPU1_HOSTFN1_MBOX_CMD_STATUS   0x00000001
+#define CPE_Q0_DEPTH                     0x00010014
+#define CPE_Q0_PI                        0x0001001c
+#define CPE_Q0_CI                        0x00010020
+#define CPE_Q1_DEPTH                     0x00010034
+#define CPE_Q1_PI                        0x0001003c
+#define CPE_Q1_CI                        0x00010040
+#define CPE_Q2_DEPTH                     0x00010054
+#define CPE_Q2_PI                        0x0001005c
+#define CPE_Q2_CI                        0x00010060
+#define CPE_Q3_DEPTH                     0x00010074
+#define CPE_Q3_PI                        0x0001007c
+#define CPE_Q3_CI                        0x00010080
+#define CPE_Q4_DEPTH                     0x00010094
+#define CPE_Q4_PI                        0x0001009c
+#define CPE_Q4_CI                        0x000100a0
+#define CPE_Q5_DEPTH                     0x000100b4
+#define CPE_Q5_PI                        0x000100bc
+#define CPE_Q5_CI                        0x000100c0
+#define CPE_Q6_DEPTH                     0x000100d4
+#define CPE_Q6_PI                        0x000100dc
+#define CPE_Q6_CI                        0x000100e0
+#define CPE_Q7_DEPTH                     0x000100f4
+#define CPE_Q7_PI                        0x000100fc
+#define CPE_Q7_CI                        0x00010100
+#define RME_Q0_DEPTH                     0x00011014
+#define RME_Q0_PI                        0x0001101c
+#define RME_Q0_CI                        0x00011020
+#define RME_Q1_DEPTH                     0x00011034
+#define RME_Q1_PI                        0x0001103c
+#define RME_Q1_CI                        0x00011040
+#define RME_Q2_DEPTH                     0x00011054
+#define RME_Q2_PI                        0x0001105c
+#define RME_Q2_CI                        0x00011060
+#define RME_Q3_DEPTH                     0x00011074
+#define RME_Q3_PI                        0x0001107c
+#define RME_Q3_CI                        0x00011080
+#define RME_Q4_DEPTH                     0x00011094
+#define RME_Q4_PI                        0x0001109c
+#define RME_Q4_CI                        0x000110a0
+#define RME_Q5_DEPTH                     0x000110b4
+#define RME_Q5_PI                        0x000110bc
+#define RME_Q5_CI                        0x000110c0
+#define RME_Q6_DEPTH                     0x000110d4
+#define RME_Q6_PI                        0x000110dc
+#define RME_Q6_CI                        0x000110e0
+#define RME_Q7_DEPTH                     0x000110f4
+#define RME_Q7_PI                        0x000110fc
+#define RME_Q7_CI                        0x00011100
+#define PSS_CTL_REG                      0x00018800
+#define __PSS_I2C_CLK_DIV_MK             0x00030000
+#define __PSS_I2C_CLK_DIV_SH             16
+#define __PSS_I2C_CLK_DIV(_v)            ((_v) << __PSS_I2C_CLK_DIV_SH)
+#define __PSS_LMEM_INIT_DONE             0x00001000
+#define __PSS_LMEM_RESET                 0x00000200
+#define __PSS_LMEM_INIT_EN               0x00000100
+#define __PSS_LPU1_RESET                 0x00000002
+#define __PSS_LPU0_RESET                 0x00000001
+#define PSS_ERR_STATUS_REG               0x00018810
+#define __PSS_LMEM1_CORR_ERR             0x00000800
+#define __PSS_LMEM0_CORR_ERR             0x00000400
+#define __PSS_LMEM1_UNCORR_ERR           0x00000200
+#define __PSS_LMEM0_UNCORR_ERR           0x00000100
+#define __PSS_BAL_PERR                   0x00000080
+#define __PSS_DIP_IF_ERR                 0x00000040
+#define __PSS_IOH_IF_ERR                 0x00000020
+#define __PSS_TDS_IF_ERR                 0x00000010
+#define __PSS_RDS_IF_ERR                 0x00000008
+#define __PSS_SGM_IF_ERR                 0x00000004
+#define __PSS_LPU1_RAM_ERR               0x00000002
+#define __PSS_LPU0_RAM_ERR               0x00000001
+#define ERR_SET_REG                      0x00018818
+#define __PSS_ERR_STATUS_SET             0x00000fff
+
+
+/*
+ * These definitions are either in error/missing in spec. Its auto-generated
+ * from hard coded values in regparse.pl.
+ */
+#define __EMPHPOST_AT_4G_MK_FIX          0x0000001c
+#define __EMPHPOST_AT_4G_SH_FIX          0x00000002
+#define __EMPHPRE_AT_4G_FIX              0x00000003
+#define __SFP_TXRATE_EN_FIX              0x00000100
+#define __SFP_RXRATE_EN_FIX              0x00000080
+
+
+/*
+ * These register definitions are auto-generated from hard coded values
+ * in regparse.pl.
+ */
+#define HOSTFN0_LPU_MBOX0_0              0x00019200
+#define HOSTFN1_LPU_MBOX0_8              0x00019260
+#define LPU_HOSTFN0_MBOX0_0              0x00019280
+#define LPU_HOSTFN1_MBOX0_8              0x000192e0
+
+
+/*
+ * These register mapping definitions are auto-generated from mapping tables
+ * in regparse.pl.
+ */
+#define BFA_IOC0_HBEAT_REG               HOST_SEM0_INFO_REG
+#define BFA_IOC0_STATE_REG               HOST_SEM1_INFO_REG
+#define BFA_IOC1_HBEAT_REG               HOST_SEM2_INFO_REG
+#define BFA_IOC1_STATE_REG               HOST_SEM3_INFO_REG
+#define BFA_FW_USE_COUNT                 HOST_SEM4_INFO_REG
+
+#define CPE_Q_DEPTH(__n) \
+	(CPE_Q0_DEPTH + (__n) * (CPE_Q1_DEPTH - CPE_Q0_DEPTH))
+#define CPE_Q_PI(__n) \
+	(CPE_Q0_PI + (__n) * (CPE_Q1_PI - CPE_Q0_PI))
+#define CPE_Q_CI(__n) \
+	(CPE_Q0_CI + (__n) * (CPE_Q1_CI - CPE_Q0_CI))
+#define RME_Q_DEPTH(__n) \
+	(RME_Q0_DEPTH + (__n) * (RME_Q1_DEPTH - RME_Q0_DEPTH))
+#define RME_Q_PI(__n) \
+	(RME_Q0_PI + (__n) * (RME_Q1_PI - RME_Q0_PI))
+#define RME_Q_CI(__n) \
+	(RME_Q0_CI + (__n) * (RME_Q1_CI - RME_Q0_CI))
+
+#define CPE_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
+#define RME_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
+#define CPE_Q_MASK(__q)  ((__q) & 0x3)
+#define RME_Q_MASK(__q)  ((__q) & 0x3)
+
+
+/*
+ * PCI MSI-X vector defines
+ */
+enum {
+    BFA_MSIX_CPE_Q0 = 0,
+    BFA_MSIX_CPE_Q1 = 1,
+    BFA_MSIX_CPE_Q2 = 2,
+    BFA_MSIX_CPE_Q3 = 3,
+    BFA_MSIX_CPE_Q4 = 4,
+    BFA_MSIX_CPE_Q5 = 5,
+    BFA_MSIX_CPE_Q6 = 6,
+    BFA_MSIX_CPE_Q7 = 7,
+    BFA_MSIX_RME_Q0 = 8,
+    BFA_MSIX_RME_Q1 = 9,
+    BFA_MSIX_RME_Q2 = 10,
+    BFA_MSIX_RME_Q3 = 11,
+    BFA_MSIX_RME_Q4 = 12,
+    BFA_MSIX_RME_Q5 = 13,
+    BFA_MSIX_RME_Q6 = 14,
+    BFA_MSIX_RME_Q7 = 15,
+    BFA_MSIX_ERR_EMC = 16,
+    BFA_MSIX_ERR_LPU0 = 17,
+    BFA_MSIX_ERR_LPU1 = 18,
+    BFA_MSIX_ERR_PSS = 19,
+    BFA_MSIX_MBOX_LPU0 = 20,
+    BFA_MSIX_MBOX_LPU1 = 21,
+    BFA_MSIX_CB_MAX = 22,
+};
+
+/*
+ * And corresponding host interrupt status bit field defines
+ */
+#define __HFN_INT_CPE_Q0                   0x00000001U
+#define __HFN_INT_CPE_Q1                   0x00000002U
+#define __HFN_INT_CPE_Q2                   0x00000004U
+#define __HFN_INT_CPE_Q3                   0x00000008U
+#define __HFN_INT_CPE_Q4                   0x00000010U
+#define __HFN_INT_CPE_Q5                   0x00000020U
+#define __HFN_INT_CPE_Q6                   0x00000040U
+#define __HFN_INT_CPE_Q7                   0x00000080U
+#define __HFN_INT_RME_Q0                   0x00000100U
+#define __HFN_INT_RME_Q1                   0x00000200U
+#define __HFN_INT_RME_Q2                   0x00000400U
+#define __HFN_INT_RME_Q3                   0x00000800U
+#define __HFN_INT_RME_Q4                   0x00001000U
+#define __HFN_INT_RME_Q5                   0x00002000U
+#define __HFN_INT_RME_Q6                   0x00004000U
+#define __HFN_INT_RME_Q7                   0x00008000U
+#define __HFN_INT_ERR_EMC                  0x00010000U
+#define __HFN_INT_ERR_LPU0                 0x00020000U
+#define __HFN_INT_ERR_LPU1                 0x00040000U
+#define __HFN_INT_ERR_PSS                  0x00080000U
+#define __HFN_INT_MBOX_LPU0                0x00100000U
+#define __HFN_INT_MBOX_LPU1                0x00200000U
+#define __HFN_INT_MBOX1_LPU0               0x00400000U
+#define __HFN_INT_MBOX1_LPU1               0x00800000U
+#define __HFN_INT_CPE_MASK                 0x000000ffU
+#define __HFN_INT_RME_MASK                 0x0000ff00U
+
+
+/*
+ * crossbow memory map.
+ */
+#define PSS_SMEM_PAGE_START	0x8000
+#define PSS_SMEM_PGNUM(_pg0, _ma)	((_pg0) + ((_ma) >> 15))
+#define PSS_SMEM_PGOFF(_ma)	((_ma) & 0x7fff)
+
+/*
+ * End of crossbow memory map
+ */
+
+
+#endif /* __BFI_CBREG_H__ */
+
diff --git a/drivers/scsi/bfa/bfi_ctreg.h b/drivers/scsi/bfa/bfi_ctreg.h
new file mode 100644
index 0000000..62b86a4
--- /dev/null
+++ b/drivers/scsi/bfa/bfi_ctreg.h
@@ -0,0 +1,627 @@
+
+/*
+ * bfi_ctreg.h catapult host block register definitions
+ *
+ * !!! Do not edit. Auto generated. !!!
+ */
+
+#ifndef __BFI_CTREG_H__
+#define __BFI_CTREG_H__
+
+
+#define HOSTFN0_LPU_MBOX0_0		0x00019200
+#define HOSTFN1_LPU_MBOX0_8		0x00019260
+#define LPU_HOSTFN0_MBOX0_0		0x00019280
+#define LPU_HOSTFN1_MBOX0_8		0x000192e0
+#define HOSTFN2_LPU_MBOX0_0		0x00019400
+#define HOSTFN3_LPU_MBOX0_8		0x00019460
+#define LPU_HOSTFN2_MBOX0_0		0x00019480
+#define LPU_HOSTFN3_MBOX0_8		0x000194e0
+#define HOSTFN0_INT_STATUS		0x00014000
+#define __HOSTFN0_HALT_OCCURRED		0x01000000
+#define __HOSTFN0_INT_STATUS_LVL_MK	0x00f00000
+#define __HOSTFN0_INT_STATUS_LVL_SH	20
+#define __HOSTFN0_INT_STATUS_LVL(_v)	((_v) << __HOSTFN0_INT_STATUS_LVL_SH)
+#define __HOSTFN0_INT_STATUS_P_MK	0x000f0000
+#define __HOSTFN0_INT_STATUS_P_SH	16
+#define __HOSTFN0_INT_STATUS_P(_v)	((_v) << __HOSTFN0_INT_STATUS_P_SH)
+#define __HOSTFN0_INT_STATUS_F		0x0000ffff
+#define HOSTFN0_INT_MSK			0x00014004
+#define HOST_PAGE_NUM_FN0		0x00014008
+#define __HOST_PAGE_NUM_FN		0x000001ff
+#define HOST_MSIX_ERR_INDEX_FN0		0x0001400c
+#define __MSIX_ERR_INDEX_FN		0x000001ff
+#define HOSTFN1_INT_STATUS		0x00014100
+#define __HOSTFN1_HALT_OCCURRED		0x01000000
+#define __HOSTFN1_INT_STATUS_LVL_MK	0x00f00000
+#define __HOSTFN1_INT_STATUS_LVL_SH	20
+#define __HOSTFN1_INT_STATUS_LVL(_v)	((_v) << __HOSTFN1_INT_STATUS_LVL_SH)
+#define __HOSTFN1_INT_STATUS_P_MK	0x000f0000
+#define __HOSTFN1_INT_STATUS_P_SH	16
+#define __HOSTFN1_INT_STATUS_P(_v)	((_v) << __HOSTFN1_INT_STATUS_P_SH)
+#define __HOSTFN1_INT_STATUS_F		0x0000ffff
+#define HOSTFN1_INT_MSK			0x00014104
+#define HOST_PAGE_NUM_FN1		0x00014108
+#define HOST_MSIX_ERR_INDEX_FN1		0x0001410c
+#define APP_PLL_425_CTL_REG		0x00014204
+#define __P_425_PLL_LOCK		0x80000000
+#define __APP_PLL_425_SRAM_USE_100MHZ	0x00100000
+#define __APP_PLL_425_RESET_TIMER_MK	0x000e0000
+#define __APP_PLL_425_RESET_TIMER_SH	17
+#define __APP_PLL_425_RESET_TIMER(_v)	((_v) << __APP_PLL_425_RESET_TIMER_SH)
+#define __APP_PLL_425_LOGIC_SOFT_RESET	0x00010000
+#define __APP_PLL_425_CNTLMT0_1_MK	0x0000c000
+#define __APP_PLL_425_CNTLMT0_1_SH	14
+#define __APP_PLL_425_CNTLMT0_1(_v)	((_v) << __APP_PLL_425_CNTLMT0_1_SH)
+#define __APP_PLL_425_JITLMT0_1_MK	0x00003000
+#define __APP_PLL_425_JITLMT0_1_SH	12
+#define __APP_PLL_425_JITLMT0_1(_v)	((_v) << __APP_PLL_425_JITLMT0_1_SH)
+#define __APP_PLL_425_HREF		0x00000800
+#define __APP_PLL_425_HDIV		0x00000400
+#define __APP_PLL_425_P0_1_MK		0x00000300
+#define __APP_PLL_425_P0_1_SH		8
+#define __APP_PLL_425_P0_1(_v)		((_v) << __APP_PLL_425_P0_1_SH)
+#define __APP_PLL_425_Z0_2_MK		0x000000e0
+#define __APP_PLL_425_Z0_2_SH		5
+#define __APP_PLL_425_Z0_2(_v)		((_v) << __APP_PLL_425_Z0_2_SH)
+#define __APP_PLL_425_RSEL200500	0x00000010
+#define __APP_PLL_425_ENARST		0x00000008
+#define __APP_PLL_425_BYPASS		0x00000004
+#define __APP_PLL_425_LRESETN		0x00000002
+#define __APP_PLL_425_ENABLE		0x00000001
+#define APP_PLL_312_CTL_REG		0x00014208
+#define __P_312_PLL_LOCK		0x80000000
+#define __ENABLE_MAC_AHB_1		0x00800000
+#define __ENABLE_MAC_AHB_0		0x00400000
+#define __ENABLE_MAC_1			0x00200000
+#define __ENABLE_MAC_0			0x00100000
+#define __APP_PLL_312_RESET_TIMER_MK	0x000e0000
+#define __APP_PLL_312_RESET_TIMER_SH	17
+#define __APP_PLL_312_RESET_TIMER(_v)	((_v) << __APP_PLL_312_RESET_TIMER_SH)
+#define __APP_PLL_312_LOGIC_SOFT_RESET	0x00010000
+#define __APP_PLL_312_CNTLMT0_1_MK	0x0000c000
+#define __APP_PLL_312_CNTLMT0_1_SH	14
+#define __APP_PLL_312_CNTLMT0_1(_v)	((_v) << __APP_PLL_312_CNTLMT0_1_SH)
+#define __APP_PLL_312_JITLMT0_1_MK	0x00003000
+#define __APP_PLL_312_JITLMT0_1_SH	12
+#define __APP_PLL_312_JITLMT0_1(_v)	((_v) << __APP_PLL_312_JITLMT0_1_SH)
+#define __APP_PLL_312_HREF		0x00000800
+#define __APP_PLL_312_HDIV		0x00000400
+#define __APP_PLL_312_P0_1_MK		0x00000300
+#define __APP_PLL_312_P0_1_SH		8
+#define __APP_PLL_312_P0_1(_v)		((_v) << __APP_PLL_312_P0_1_SH)
+#define __APP_PLL_312_Z0_2_MK		0x000000e0
+#define __APP_PLL_312_Z0_2_SH		5
+#define __APP_PLL_312_Z0_2(_v)		((_v) << __APP_PLL_312_Z0_2_SH)
+#define __APP_PLL_312_RSEL200500	0x00000010
+#define __APP_PLL_312_ENARST		0x00000008
+#define __APP_PLL_312_BYPASS		0x00000004
+#define __APP_PLL_312_LRESETN		0x00000002
+#define __APP_PLL_312_ENABLE		0x00000001
+#define MBIST_CTL_REG			0x00014220
+#define __EDRAM_BISTR_START		0x00000004
+#define __MBIST_RESET			0x00000002
+#define __MBIST_START			0x00000001
+#define MBIST_STAT_REG			0x00014224
+#define __EDRAM_BISTR_STATUS		0x00000008
+#define __EDRAM_BISTR_DONE		0x00000004
+#define __MEM_BIT_STATUS		0x00000002
+#define __MBIST_DONE			0x00000001
+#define HOST_SEM0_REG			0x00014230
+#define __HOST_SEMAPHORE		0x00000001
+#define HOST_SEM1_REG			0x00014234
+#define HOST_SEM2_REG			0x00014238
+#define HOST_SEM3_REG			0x0001423c
+#define HOST_SEM0_INFO_REG		0x00014240
+#define HOST_SEM1_INFO_REG		0x00014244
+#define HOST_SEM2_INFO_REG		0x00014248
+#define HOST_SEM3_INFO_REG		0x0001424c
+#define ETH_MAC_SER_REG			0x00014288
+#define __APP_EMS_CKBUFAMPIN		0x00000020
+#define __APP_EMS_REFCLKSEL		0x00000010
+#define __APP_EMS_CMLCKSEL		0x00000008
+#define __APP_EMS_REFCKBUFEN2		0x00000004
+#define __APP_EMS_REFCKBUFEN1		0x00000002
+#define __APP_EMS_CHANNEL_SEL		0x00000001
+#define HOSTFN2_INT_STATUS		0x00014300
+#define __HOSTFN2_HALT_OCCURRED		0x01000000
+#define __HOSTFN2_INT_STATUS_LVL_MK	0x00f00000
+#define __HOSTFN2_INT_STATUS_LVL_SH	20
+#define __HOSTFN2_INT_STATUS_LVL(_v)	((_v) << __HOSTFN2_INT_STATUS_LVL_SH)
+#define __HOSTFN2_INT_STATUS_P_MK	0x000f0000
+#define __HOSTFN2_INT_STATUS_P_SH	16
+#define __HOSTFN2_INT_STATUS_P(_v)	((_v) << __HOSTFN2_INT_STATUS_P_SH)
+#define __HOSTFN2_INT_STATUS_F		0x0000ffff
+#define HOSTFN2_INT_MSK			0x00014304
+#define HOST_PAGE_NUM_FN2		0x00014308
+#define HOST_MSIX_ERR_INDEX_FN2		0x0001430c
+#define HOSTFN3_INT_STATUS		0x00014400
+#define __HALT_OCCURRED			0x01000000
+#define __HOSTFN3_INT_STATUS_LVL_MK	0x00f00000
+#define __HOSTFN3_INT_STATUS_LVL_SH	20
+#define __HOSTFN3_INT_STATUS_LVL(_v)	((_v) << __HOSTFN3_INT_STATUS_LVL_SH)
+#define __HOSTFN3_INT_STATUS_P_MK	0x000f0000
+#define __HOSTFN3_INT_STATUS_P_SH	16
+#define __HOSTFN3_INT_STATUS_P(_v)	((_v) << __HOSTFN3_INT_STATUS_P_SH)
+#define __HOSTFN3_INT_STATUS_F		0x0000ffff
+#define HOSTFN3_INT_MSK			0x00014404
+#define HOST_PAGE_NUM_FN3		0x00014408
+#define HOST_MSIX_ERR_INDEX_FN3		0x0001440c
+#define FNC_ID_REG			0x00014600
+#define __FUNCTION_NUMBER		0x00000007
+#define FNC_PERS_REG			0x00014604
+#define __F3_FUNCTION_ACTIVE		0x80000000
+#define __F3_FUNCTION_MODE		0x40000000
+#define __F3_PORT_MAP_MK		0x30000000
+#define __F3_PORT_MAP_SH		28
+#define __F3_PORT_MAP(_v)		((_v) << __F3_PORT_MAP_SH)
+#define __F3_VM_MODE			0x08000000
+#define __F3_INTX_STATUS_MK		0x07000000
+#define __F3_INTX_STATUS_SH		24
+#define __F3_INTX_STATUS(_v)		((_v) << __F3_INTX_STATUS_SH)
+#define __F2_FUNCTION_ACTIVE		0x00800000
+#define __F2_FUNCTION_MODE		0x00400000
+#define __F2_PORT_MAP_MK		0x00300000
+#define __F2_PORT_MAP_SH		20
+#define __F2_PORT_MAP(_v)		((_v) << __F2_PORT_MAP_SH)
+#define __F2_VM_MODE			0x00080000
+#define __F2_INTX_STATUS_MK		0x00070000
+#define __F2_INTX_STATUS_SH		16
+#define __F2_INTX_STATUS(_v)		((_v) << __F2_INTX_STATUS_SH)
+#define __F1_FUNCTION_ACTIVE		0x00008000
+#define __F1_FUNCTION_MODE		0x00004000
+#define __F1_PORT_MAP_MK		0x00003000
+#define __F1_PORT_MAP_SH		12
+#define __F1_PORT_MAP(_v)		((_v) << __F1_PORT_MAP_SH)
+#define __F1_VM_MODE			0x00000800
+#define __F1_INTX_STATUS_MK		0x00000700
+#define __F1_INTX_STATUS_SH		8
+#define __F1_INTX_STATUS(_v)		((_v) << __F1_INTX_STATUS_SH)
+#define __F0_FUNCTION_ACTIVE		0x00000080
+#define __F0_FUNCTION_MODE		0x00000040
+#define __F0_PORT_MAP_MK		0x00000030
+#define __F0_PORT_MAP_SH		4
+#define __F0_PORT_MAP(_v)		((_v) << __F0_PORT_MAP_SH)
+#define __F0_VM_MODE		0x00000008
+#define __F0_INTX_STATUS		0x00000007
+enum {
+	__F0_INTX_STATUS_MSIX		= 0x0,
+	__F0_INTX_STATUS_INTA		= 0x1,
+	__F0_INTX_STATUS_INTB		= 0x2,
+	__F0_INTX_STATUS_INTC		= 0x3,
+	__F0_INTX_STATUS_INTD		= 0x4,
+};
+#define OP_MODE				0x0001460c
+#define __APP_ETH_CLK_LOWSPEED		0x00000004
+#define __GLOBAL_CORECLK_HALFSPEED	0x00000002
+#define __GLOBAL_FCOE_MODE		0x00000001
+#define HOST_SEM4_REG			0x00014610
+#define HOST_SEM5_REG			0x00014614
+#define HOST_SEM6_REG			0x00014618
+#define HOST_SEM7_REG			0x0001461c
+#define HOST_SEM4_INFO_REG		0x00014620
+#define HOST_SEM5_INFO_REG		0x00014624
+#define HOST_SEM6_INFO_REG		0x00014628
+#define HOST_SEM7_INFO_REG		0x0001462c
+#define HOSTFN0_LPU0_MBOX0_CMD_STAT	0x00019000
+#define __HOSTFN0_LPU0_MBOX0_INFO_MK	0xfffffffe
+#define __HOSTFN0_LPU0_MBOX0_INFO_SH	1
+#define __HOSTFN0_LPU0_MBOX0_INFO(_v)	((_v) << __HOSTFN0_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN0_LPU0_MBOX0_CMD_STATUS 0x00000001
+#define HOSTFN0_LPU1_MBOX0_CMD_STAT	0x00019004
+#define __HOSTFN0_LPU1_MBOX0_INFO_MK	0xfffffffe
+#define __HOSTFN0_LPU1_MBOX0_INFO_SH	1
+#define __HOSTFN0_LPU1_MBOX0_INFO(_v)	((_v) << __HOSTFN0_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN0_LPU1_MBOX0_CMD_STATUS 0x00000001
+#define LPU0_HOSTFN0_MBOX0_CMD_STAT	0x00019008
+#define __LPU0_HOSTFN0_MBOX0_INFO_MK	0xfffffffe
+#define __LPU0_HOSTFN0_MBOX0_INFO_SH	1
+#define __LPU0_HOSTFN0_MBOX0_INFO(_v)	((_v) << __LPU0_HOSTFN0_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN0_MBOX0_CMD_STATUS 0x00000001
+#define LPU1_HOSTFN0_MBOX0_CMD_STAT	0x0001900c
+#define __LPU1_HOSTFN0_MBOX0_INFO_MK	0xfffffffe
+#define __LPU1_HOSTFN0_MBOX0_INFO_SH	1
+#define __LPU1_HOSTFN0_MBOX0_INFO(_v)	((_v) << __LPU1_HOSTFN0_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN0_MBOX0_CMD_STATUS 0x00000001
+#define HOSTFN1_LPU0_MBOX0_CMD_STAT	0x00019010
+#define __HOSTFN1_LPU0_MBOX0_INFO_MK	0xfffffffe
+#define __HOSTFN1_LPU0_MBOX0_INFO_SH	1
+#define __HOSTFN1_LPU0_MBOX0_INFO(_v)	((_v) << __HOSTFN1_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN1_LPU0_MBOX0_CMD_STATUS 0x00000001
+#define HOSTFN1_LPU1_MBOX0_CMD_STAT	0x00019014
+#define __HOSTFN1_LPU1_MBOX0_INFO_MK	0xfffffffe
+#define __HOSTFN1_LPU1_MBOX0_INFO_SH	1
+#define __HOSTFN1_LPU1_MBOX0_INFO(_v)	((_v) << __HOSTFN1_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN1_LPU1_MBOX0_CMD_STATUS 0x00000001
+#define LPU0_HOSTFN1_MBOX0_CMD_STAT	0x00019018
+#define __LPU0_HOSTFN1_MBOX0_INFO_MK	0xfffffffe
+#define __LPU0_HOSTFN1_MBOX0_INFO_SH	1
+#define __LPU0_HOSTFN1_MBOX0_INFO(_v)	((_v) << __LPU0_HOSTFN1_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN1_MBOX0_CMD_STATUS 0x00000001
+#define LPU1_HOSTFN1_MBOX0_CMD_STAT	0x0001901c
+#define __LPU1_HOSTFN1_MBOX0_INFO_MK	0xfffffffe
+#define __LPU1_HOSTFN1_MBOX0_INFO_SH	1
+#define __LPU1_HOSTFN1_MBOX0_INFO(_v)	((_v) << __LPU1_HOSTFN1_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN1_MBOX0_CMD_STATUS 0x00000001
+#define HOSTFN2_LPU0_MBOX0_CMD_STAT	0x00019150
+#define __HOSTFN2_LPU0_MBOX0_INFO_MK	0xfffffffe
+#define __HOSTFN2_LPU0_MBOX0_INFO_SH	1
+#define __HOSTFN2_LPU0_MBOX0_INFO(_v)	((_v) << __HOSTFN2_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN2_LPU0_MBOX0_CMD_STATUS 0x00000001
+#define HOSTFN2_LPU1_MBOX0_CMD_STAT	0x00019154
+#define __HOSTFN2_LPU1_MBOX0_INFO_MK	0xfffffffe
+#define __HOSTFN2_LPU1_MBOX0_INFO_SH	1
+#define __HOSTFN2_LPU1_MBOX0_INFO(_v)	((_v) << __HOSTFN2_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN2_LPU1_MBOX0BOX0_CMD_STATUS 0x00000001
+#define LPU0_HOSTFN2_MBOX0_CMD_STAT	0x00019158
+#define __LPU0_HOSTFN2_MBOX0_INFO_MK	0xfffffffe
+#define __LPU0_HOSTFN2_MBOX0_INFO_SH	1
+#define __LPU0_HOSTFN2_MBOX0_INFO(_v)	((_v) << __LPU0_HOSTFN2_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN2_MBOX0_CMD_STATUS 0x00000001
+#define LPU1_HOSTFN2_MBOX0_CMD_STAT	0x0001915c
+#define __LPU1_HOSTFN2_MBOX0_INFO_MK	0xfffffffe
+#define __LPU1_HOSTFN2_MBOX0_INFO_SH	1
+#define __LPU1_HOSTFN2_MBOX0_INFO(_v)	((_v) << __LPU1_HOSTFN2_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN2_MBOX0_CMD_STATUS 0x00000001
+#define HOSTFN3_LPU0_MBOX0_CMD_STAT	0x00019160
+#define __HOSTFN3_LPU0_MBOX0_INFO_MK	0xfffffffe
+#define __HOSTFN3_LPU0_MBOX0_INFO_SH	1
+#define __HOSTFN3_LPU0_MBOX0_INFO(_v)	((_v) << __HOSTFN3_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN3_LPU0_MBOX0_CMD_STATUS 0x00000001
+#define HOSTFN3_LPU1_MBOX0_CMD_STAT	0x00019164
+#define __HOSTFN3_LPU1_MBOX0_INFO_MK	0xfffffffe
+#define __HOSTFN3_LPU1_MBOX0_INFO_SH	1
+#define __HOSTFN3_LPU1_MBOX0_INFO(_v)	((_v) << __HOSTFN3_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN3_LPU1_MBOX0_CMD_STATUS 0x00000001
+#define LPU0_HOSTFN3_MBOX0_CMD_STAT	0x00019168
+#define __LPU0_HOSTFN3_MBOX0_INFO_MK	0xfffffffe
+#define __LPU0_HOSTFN3_MBOX0_INFO_SH	1
+#define __LPU0_HOSTFN3_MBOX0_INFO(_v)	((_v) << __LPU0_HOSTFN3_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN3_MBOX0_CMD_STATUS 0x00000001
+#define LPU1_HOSTFN3_MBOX0_CMD_STAT	0x0001916c
+#define __LPU1_HOSTFN3_MBOX0_INFO_MK	0xfffffffe
+#define __LPU1_HOSTFN3_MBOX0_INFO_SH	1
+#define __LPU1_HOSTFN3_MBOX0_INFO(_v)	((_v) << __LPU1_HOSTFN3_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN3_MBOX0_CMD_STATUS	0x00000001
+#define FW_INIT_HALT_P0			0x000191ac
+#define __FW_INIT_HALT_P		0x00000001
+#define FW_INIT_HALT_P1			0x000191bc
+#define CPE_PI_PTR_Q0			0x00038000
+#define __CPE_PI_UNUSED_MK		0xffff0000
+#define __CPE_PI_UNUSED_SH		16
+#define __CPE_PI_UNUSED(_v)		((_v) << __CPE_PI_UNUSED_SH)
+#define __CPE_PI_PTR			0x0000ffff
+#define CPE_PI_PTR_Q1			0x00038040
+#define CPE_CI_PTR_Q0			0x00038004
+#define __CPE_CI_UNUSED_MK		0xffff0000
+#define __CPE_CI_UNUSED_SH		16
+#define __CPE_CI_UNUSED(_v)		((_v) << __CPE_CI_UNUSED_SH)
+#define __CPE_CI_PTR			0x0000ffff
+#define CPE_CI_PTR_Q1			0x00038044
+#define CPE_DEPTH_Q0			0x00038008
+#define __CPE_DEPTH_UNUSED_MK		0xf8000000
+#define __CPE_DEPTH_UNUSED_SH		27
+#define __CPE_DEPTH_UNUSED(_v)		((_v) << __CPE_DEPTH_UNUSED_SH)
+#define __CPE_MSIX_VEC_INDEX_MK		0x07ff0000
+#define __CPE_MSIX_VEC_INDEX_SH		16
+#define __CPE_MSIX_VEC_INDEX(_v)	((_v) << __CPE_MSIX_VEC_INDEX_SH)
+#define __CPE_DEPTH			0x0000ffff
+#define CPE_DEPTH_Q1			0x00038048
+#define CPE_QCTRL_Q0			0x0003800c
+#define __CPE_CTRL_UNUSED30_MK		0xfc000000
+#define __CPE_CTRL_UNUSED30_SH		26
+#define __CPE_CTRL_UNUSED30(_v)		((_v) << __CPE_CTRL_UNUSED30_SH)
+#define __CPE_FUNC_INT_CTRL_MK		0x03000000
+#define __CPE_FUNC_INT_CTRL_SH		24
+#define __CPE_FUNC_INT_CTRL(_v)		((_v) << __CPE_FUNC_INT_CTRL_SH)
+enum {
+	__CPE_FUNC_INT_CTRL_DISABLE		= 0x0,
+	__CPE_FUNC_INT_CTRL_F2NF		= 0x1,
+	__CPE_FUNC_INT_CTRL_3QUART		= 0x2,
+	__CPE_FUNC_INT_CTRL_HALF		= 0x3,
+};
+#define __CPE_CTRL_UNUSED20_MK		0x00f00000
+#define __CPE_CTRL_UNUSED20_SH		20
+#define __CPE_CTRL_UNUSED20(_v)		((_v) << __CPE_CTRL_UNUSED20_SH)
+#define __CPE_SCI_TH_MK			0x000f0000
+#define __CPE_SCI_TH_SH			16
+#define __CPE_SCI_TH(_v)		((_v) << __CPE_SCI_TH_SH)
+#define __CPE_CTRL_UNUSED10_MK		0x0000c000
+#define __CPE_CTRL_UNUSED10_SH		14
+#define __CPE_CTRL_UNUSED10(_v)		((_v) << __CPE_CTRL_UNUSED10_SH)
+#define __CPE_ACK_PENDING		0x00002000
+#define __CPE_CTRL_UNUSED40_MK		0x00001c00
+#define __CPE_CTRL_UNUSED40_SH		10
+#define __CPE_CTRL_UNUSED40(_v)		((_v) << __CPE_CTRL_UNUSED40_SH)
+#define __CPE_PCIEID_MK			0x00000300
+#define __CPE_PCIEID_SH			8
+#define __CPE_PCIEID(_v)		((_v) << __CPE_PCIEID_SH)
+#define __CPE_CTRL_UNUSED00_MK		0x000000fe
+#define __CPE_CTRL_UNUSED00_SH		1
+#define __CPE_CTRL_UNUSED00(_v)		((_v) << __CPE_CTRL_UNUSED00_SH)
+#define __CPE_ESIZE			0x00000001
+#define CPE_QCTRL_Q1			0x0003804c
+#define __CPE_CTRL_UNUSED31_MK		0xfc000000
+#define __CPE_CTRL_UNUSED31_SH		26
+#define __CPE_CTRL_UNUSED31(_v)		((_v) << __CPE_CTRL_UNUSED31_SH)
+#define __CPE_CTRL_UNUSED21_MK		0x00f00000
+#define __CPE_CTRL_UNUSED21_SH		20
+#define __CPE_CTRL_UNUSED21(_v)		((_v) << __CPE_CTRL_UNUSED21_SH)
+#define __CPE_CTRL_UNUSED11_MK		0x0000c000
+#define __CPE_CTRL_UNUSED11_SH		14
+#define __CPE_CTRL_UNUSED11(_v)		((_v) << __CPE_CTRL_UNUSED11_SH)
+#define __CPE_CTRL_UNUSED41_MK		0x00001c00
+#define __CPE_CTRL_UNUSED41_SH		10
+#define __CPE_CTRL_UNUSED41(_v)		((_v) << __CPE_CTRL_UNUSED41_SH)
+#define __CPE_CTRL_UNUSED01_MK		0x000000fe
+#define __CPE_CTRL_UNUSED01_SH		1
+#define __CPE_CTRL_UNUSED01(_v)		((_v) << __CPE_CTRL_UNUSED01_SH)
+#define RME_PI_PTR_Q0			0x00038020
+#define __LATENCY_TIME_STAMP_MK		0xffff0000
+#define __LATENCY_TIME_STAMP_SH		16
+#define __LATENCY_TIME_STAMP(_v)	((_v) << __LATENCY_TIME_STAMP_SH)
+#define __RME_PI_PTR			0x0000ffff
+#define RME_PI_PTR_Q1			0x00038060
+#define RME_CI_PTR_Q0			0x00038024
+#define __DELAY_TIME_STAMP_MK		0xffff0000
+#define __DELAY_TIME_STAMP_SH		16
+#define __DELAY_TIME_STAMP(_v)		((_v) << __DELAY_TIME_STAMP_SH)
+#define __RME_CI_PTR			0x0000ffff
+#define RME_CI_PTR_Q1			0x00038064
+#define RME_DEPTH_Q0			0x00038028
+#define __RME_DEPTH_UNUSED_MK		0xf8000000
+#define __RME_DEPTH_UNUSED_SH		27
+#define __RME_DEPTH_UNUSED(_v)		((_v) << __RME_DEPTH_UNUSED_SH)
+#define __RME_MSIX_VEC_INDEX_MK		0x07ff0000
+#define __RME_MSIX_VEC_INDEX_SH		16
+#define __RME_MSIX_VEC_INDEX(_v)	((_v) << __RME_MSIX_VEC_INDEX_SH)
+#define __RME_DEPTH			0x0000ffff
+#define RME_DEPTH_Q1			0x00038068
+#define RME_QCTRL_Q0			0x0003802c
+#define __RME_INT_LATENCY_TIMER_MK	0xff000000
+#define __RME_INT_LATENCY_TIMER_SH	24
+#define __RME_INT_LATENCY_TIMER(_v)	((_v) << __RME_INT_LATENCY_TIMER_SH)
+#define __RME_INT_DELAY_TIMER_MK	0x00ff0000
+#define __RME_INT_DELAY_TIMER_SH	16
+#define __RME_INT_DELAY_TIMER(_v)	((_v) << __RME_INT_DELAY_TIMER_SH)
+#define __RME_INT_DELAY_DISABLE		0x00008000
+#define __RME_DLY_DELAY_DISABLE		0x00004000
+#define __RME_ACK_PENDING		0x00002000
+#define __RME_FULL_INTERRUPT_DISABLE	0x00001000
+#define __RME_CTRL_UNUSED10_MK		0x00000c00
+#define __RME_CTRL_UNUSED10_SH		10
+#define __RME_CTRL_UNUSED10(_v)		((_v) << __RME_CTRL_UNUSED10_SH)
+#define __RME_PCIEID_MK			0x00000300
+#define __RME_PCIEID_SH			8
+#define __RME_PCIEID(_v)		((_v) << __RME_PCIEID_SH)
+#define __RME_CTRL_UNUSED00_MK		0x000000fe
+#define __RME_CTRL_UNUSED00_SH		1
+#define __RME_CTRL_UNUSED00(_v)		((_v) << __RME_CTRL_UNUSED00_SH)
+#define __RME_ESIZE			0x00000001
+#define RME_QCTRL_Q1			0x0003806c
+#define __RME_CTRL_UNUSED11_MK		0x00000c00
+#define __RME_CTRL_UNUSED11_SH		10
+#define __RME_CTRL_UNUSED11(_v)		((_v) << __RME_CTRL_UNUSED11_SH)
+#define __RME_CTRL_UNUSED01_MK		0x000000fe
+#define __RME_CTRL_UNUSED01_SH		1
+#define __RME_CTRL_UNUSED01(_v)		((_v) << __RME_CTRL_UNUSED01_SH)
+#define PSS_CTL_REG			0x00018800
+#define __PSS_I2C_CLK_DIV_MK		0x007f0000
+#define __PSS_I2C_CLK_DIV_SH		16
+#define __PSS_I2C_CLK_DIV(_v)		((_v) << __PSS_I2C_CLK_DIV_SH)
+#define __PSS_LMEM_INIT_DONE		0x00001000
+#define __PSS_LMEM_RESET		0x00000200
+#define __PSS_LMEM_INIT_EN		0x00000100
+#define __PSS_LPU1_RESET		0x00000002
+#define __PSS_LPU0_RESET		0x00000001
+#define PSS_ERR_STATUS_REG		0x00018810
+#define __PSS_LPU1_TCM_READ_ERR		0x00200000
+#define __PSS_LPU0_TCM_READ_ERR		0x00100000
+#define __PSS_LMEM5_CORR_ERR		0x00080000
+#define __PSS_LMEM4_CORR_ERR		0x00040000
+#define __PSS_LMEM3_CORR_ERR		0x00020000
+#define __PSS_LMEM2_CORR_ERR		0x00010000
+#define __PSS_LMEM1_CORR_ERR		0x00008000
+#define __PSS_LMEM0_CORR_ERR		0x00004000
+#define __PSS_LMEM5_UNCORR_ERR		0x00002000
+#define __PSS_LMEM4_UNCORR_ERR		0x00001000
+#define __PSS_LMEM3_UNCORR_ERR		0x00000800
+#define __PSS_LMEM2_UNCORR_ERR		0x00000400
+#define __PSS_LMEM1_UNCORR_ERR		0x00000200
+#define __PSS_LMEM0_UNCORR_ERR		0x00000100
+#define __PSS_BAL_PERR			0x00000080
+#define __PSS_DIP_IF_ERR		0x00000040
+#define __PSS_IOH_IF_ERR		0x00000020
+#define __PSS_TDS_IF_ERR		0x00000010
+#define __PSS_RDS_IF_ERR		0x00000008
+#define __PSS_SGM_IF_ERR		0x00000004
+#define __PSS_LPU1_RAM_ERR		0x00000002
+#define __PSS_LPU0_RAM_ERR		0x00000001
+#define ERR_SET_REG			0x00018818
+#define __PSS_ERR_STATUS_SET		0x003fffff
+#define PMM_1T_RESET_REG_P0		0x0002381c
+#define __PMM_1T_RESET_P		0x00000001
+#define PMM_1T_RESET_REG_P1		0x00023c1c
+#define HQM_QSET0_RXQ_DRBL_P0		0x00038000
+#define __RXQ0_ADD_VECTORS_P		0x80000000
+#define __RXQ0_STOP_P			0x40000000
+#define __RXQ0_PRD_PTR_P		0x0000ffff
+#define HQM_QSET1_RXQ_DRBL_P0		0x00038080
+#define __RXQ1_ADD_VECTORS_P		0x80000000
+#define __RXQ1_STOP_P			0x40000000
+#define __RXQ1_PRD_PTR_P		0x0000ffff
+#define HQM_QSET0_RXQ_DRBL_P1		0x0003c000
+#define HQM_QSET1_RXQ_DRBL_P1		0x0003c080
+#define HQM_QSET0_TXQ_DRBL_P0		0x00038020
+#define __TXQ0_ADD_VECTORS_P		0x80000000
+#define __TXQ0_STOP_P			0x40000000
+#define __TXQ0_PRD_PTR_P		0x0000ffff
+#define HQM_QSET1_TXQ_DRBL_P0		0x000380a0
+#define __TXQ1_ADD_VECTORS_P		0x80000000
+#define __TXQ1_STOP_P			0x40000000
+#define __TXQ1_PRD_PTR_P		0x0000ffff
+#define HQM_QSET0_TXQ_DRBL_P1		0x0003c020
+#define HQM_QSET1_TXQ_DRBL_P1		0x0003c0a0
+#define HQM_QSET0_IB_DRBL_1_P0		0x00038040
+#define __IB1_0_ACK_P			0x80000000
+#define __IB1_0_DISABLE_P		0x40000000
+#define __IB1_0_COALESCING_CFG_P_MK	0x00ff0000
+#define __IB1_0_COALESCING_CFG_P_SH	16
+#define __IB1_0_COALESCING_CFG_P(_v)	((_v) << __IB1_0_COALESCING_CFG_P_SH)
+#define __IB1_0_NUM_OF_ACKED_EVENTS_P	0x0000ffff
+#define HQM_QSET1_IB_DRBL_1_P0		0x000380c0
+#define __IB1_1_ACK_P			0x80000000
+#define __IB1_1_DISABLE_P		0x40000000
+#define __IB1_1_COALESCING_CFG_P_MK	0x00ff0000
+#define __IB1_1_COALESCING_CFG_P_SH	16
+#define __IB1_1_COALESCING_CFG_P(_v)	((_v) << __IB1_1_COALESCING_CFG_P_SH)
+#define __IB1_1_NUM_OF_ACKED_EVENTS_P	0x0000ffff
+#define HQM_QSET0_IB_DRBL_1_P1		0x0003c040
+#define HQM_QSET1_IB_DRBL_1_P1		0x0003c0c0
+#define HQM_QSET0_IB_DRBL_2_P0		0x00038060
+#define __IB2_0_ACK_P			0x80000000
+#define __IB2_0_DISABLE_P		0x40000000
+#define __IB2_0_COALESCING_CFG_P_MK	0x00ff0000
+#define __IB2_0_COALESCING_CFG_P_SH	16
+#define __IB2_0_COALESCING_CFG_P(_v)	((_v) << __IB2_0_COALESCING_CFG_P_SH)
+#define __IB2_0_NUM_OF_ACKED_EVENTS_P	0x0000ffff
+#define HQM_QSET1_IB_DRBL_2_P0		0x000380e0
+#define __IB2_1_ACK_P			0x80000000
+#define __IB2_1_DISABLE_P		0x40000000
+#define __IB2_1_COALESCING_CFG_P_MK	0x00ff0000
+#define __IB2_1_COALESCING_CFG_P_SH	16
+#define __IB2_1_COALESCING_CFG_P(_v)	((_v) << __IB2_1_COALESCING_CFG_P_SH)
+#define __IB2_1_NUM_OF_ACKED_EVENTS_P	0x0000ffff
+#define HQM_QSET0_IB_DRBL_2_P1		0x0003c060
+#define HQM_QSET1_IB_DRBL_2_P1		0x0003c0e0
+
+
+/*
+ * These definitions are either in error/missing in spec. Its auto-generated
+ * from hard coded values in regparse.pl.
+ */
+#define __EMPHPOST_AT_4G_MK_FIX		0x0000001c
+#define __EMPHPOST_AT_4G_SH_FIX		0x00000002
+#define __EMPHPRE_AT_4G_FIX		0x00000003
+#define __SFP_TXRATE_EN_FIX		0x00000100
+#define __SFP_RXRATE_EN_FIX		0x00000080
+
+
+/*
+ * These register definitions are auto-generated from hard coded values
+ * in regparse.pl.
+ */
+
+
+/*
+ * These register mapping definitions are auto-generated from mapping tables
+ * in regparse.pl.
+ */
+#define BFA_IOC0_HBEAT_REG		HOST_SEM0_INFO_REG
+#define BFA_IOC0_STATE_REG		HOST_SEM1_INFO_REG
+#define BFA_IOC1_HBEAT_REG		HOST_SEM2_INFO_REG
+#define BFA_IOC1_STATE_REG		HOST_SEM3_INFO_REG
+#define BFA_FW_USE_COUNT		 HOST_SEM4_INFO_REG
+
+#define CPE_DEPTH_Q(__n) \
+	(CPE_DEPTH_Q0 + (__n) * (CPE_DEPTH_Q1 - CPE_DEPTH_Q0))
+#define CPE_QCTRL_Q(__n) \
+	(CPE_QCTRL_Q0 + (__n) * (CPE_QCTRL_Q1 - CPE_QCTRL_Q0))
+#define CPE_PI_PTR_Q(__n) \
+	(CPE_PI_PTR_Q0 + (__n) * (CPE_PI_PTR_Q1 - CPE_PI_PTR_Q0))
+#define CPE_CI_PTR_Q(__n) \
+	(CPE_CI_PTR_Q0 + (__n) * (CPE_CI_PTR_Q1 - CPE_CI_PTR_Q0))
+#define RME_DEPTH_Q(__n) \
+	(RME_DEPTH_Q0 + (__n) * (RME_DEPTH_Q1 - RME_DEPTH_Q0))
+#define RME_QCTRL_Q(__n) \
+	(RME_QCTRL_Q0 + (__n) * (RME_QCTRL_Q1 - RME_QCTRL_Q0))
+#define RME_PI_PTR_Q(__n) \
+	(RME_PI_PTR_Q0 + (__n) * (RME_PI_PTR_Q1 - RME_PI_PTR_Q0))
+#define RME_CI_PTR_Q(__n) \
+	(RME_CI_PTR_Q0 + (__n) * (RME_CI_PTR_Q1 - RME_CI_PTR_Q0))
+#define HQM_QSET_RXQ_DRBL_P0(__n) (HQM_QSET0_RXQ_DRBL_P0 + (__n) \
+	* (HQM_QSET1_RXQ_DRBL_P0 - HQM_QSET0_RXQ_DRBL_P0))
+#define HQM_QSET_TXQ_DRBL_P0(__n) (HQM_QSET0_TXQ_DRBL_P0 + (__n) \
+	* (HQM_QSET1_TXQ_DRBL_P0 - HQM_QSET0_TXQ_DRBL_P0))
+#define HQM_QSET_IB_DRBL_1_P0(__n) (HQM_QSET0_IB_DRBL_1_P0 + (__n) \
+	* (HQM_QSET1_IB_DRBL_1_P0 - HQM_QSET0_IB_DRBL_1_P0))
+#define HQM_QSET_IB_DRBL_2_P0(__n) (HQM_QSET0_IB_DRBL_2_P0 + (__n) \
+	* (HQM_QSET1_IB_DRBL_2_P0 - HQM_QSET0_IB_DRBL_2_P0))
+#define HQM_QSET_RXQ_DRBL_P1(__n) (HQM_QSET0_RXQ_DRBL_P1 + (__n) \
+	* (HQM_QSET1_RXQ_DRBL_P1 - HQM_QSET0_RXQ_DRBL_P1))
+#define HQM_QSET_TXQ_DRBL_P1(__n) (HQM_QSET0_TXQ_DRBL_P1 + (__n) \
+	* (HQM_QSET1_TXQ_DRBL_P1 - HQM_QSET0_TXQ_DRBL_P1))
+#define HQM_QSET_IB_DRBL_1_P1(__n) (HQM_QSET0_IB_DRBL_1_P1 + (__n) \
+	* (HQM_QSET1_IB_DRBL_1_P1 - HQM_QSET0_IB_DRBL_1_P1))
+#define HQM_QSET_IB_DRBL_2_P1(__n) (HQM_QSET0_IB_DRBL_2_P1 + (__n) \
+	* (HQM_QSET1_IB_DRBL_2_P1 - HQM_QSET0_IB_DRBL_2_P1))
+
+#define CPE_Q_NUM(__fn, __q) (((__fn) << 2) + (__q))
+#define RME_Q_NUM(__fn, __q) (((__fn) << 2) + (__q))
+#define CPE_Q_MASK(__q) ((__q) & 0x3)
+#define RME_Q_MASK(__q) ((__q) & 0x3)
+
+
+/*
+ * PCI MSI-X vector defines
+ */
+enum {
+	BFA_MSIX_CPE_Q0 = 0,
+	BFA_MSIX_CPE_Q1 = 1,
+	BFA_MSIX_CPE_Q2 = 2,
+	BFA_MSIX_CPE_Q3 = 3,
+	BFA_MSIX_RME_Q0 = 4,
+	BFA_MSIX_RME_Q1 = 5,
+	BFA_MSIX_RME_Q2 = 6,
+	BFA_MSIX_RME_Q3 = 7,
+	BFA_MSIX_LPU_ERR = 8,
+	BFA_MSIX_CT_MAX = 9,
+};
+
+/*
+ * And corresponding host interrupt status bit field defines
+ */
+#define __HFN_INT_CPE_Q0		0x00000001U
+#define __HFN_INT_CPE_Q1		0x00000002U
+#define __HFN_INT_CPE_Q2		0x00000004U
+#define __HFN_INT_CPE_Q3		0x00000008U
+#define __HFN_INT_CPE_Q4		0x00000010U
+#define __HFN_INT_CPE_Q5		0x00000020U
+#define __HFN_INT_CPE_Q6		0x00000040U
+#define __HFN_INT_CPE_Q7		0x00000080U
+#define __HFN_INT_RME_Q0		0x00000100U
+#define __HFN_INT_RME_Q1		0x00000200U
+#define __HFN_INT_RME_Q2		0x00000400U
+#define __HFN_INT_RME_Q3		0x00000800U
+#define __HFN_INT_RME_Q4		0x00001000U
+#define __HFN_INT_RME_Q5		0x00002000U
+#define __HFN_INT_RME_Q6		0x00004000U
+#define __HFN_INT_RME_Q7		0x00008000U
+#define __HFN_INT_ERR_EMC		0x00010000U
+#define __HFN_INT_ERR_LPU0		0x00020000U
+#define __HFN_INT_ERR_LPU1		0x00040000U
+#define __HFN_INT_ERR_PSS		0x00080000U
+#define __HFN_INT_MBOX_LPU0		0x00100000U
+#define __HFN_INT_MBOX_LPU1		0x00200000U
+#define __HFN_INT_MBOX1_LPU0		0x00400000U
+#define __HFN_INT_MBOX1_LPU1		0x00800000U
+#define __HFN_INT_LL_HALT		0x01000000U
+#define __HFN_INT_CPE_MASK		0x000000ffU
+#define __HFN_INT_RME_MASK		0x0000ff00U
+
+
+/*
+ * catapult memory map.
+ */
+#define LL_PGN_HQM0		0x0096
+#define LL_PGN_HQM1		0x0097
+#define PSS_SMEM_PAGE_START	0x8000
+#define PSS_SMEM_PGNUM(_pg0, _ma)	((_pg0) + ((_ma) >> 15))
+#define PSS_SMEM_PGOFF(_ma)	((_ma) & 0x7fff)
+
+/*
+ * End of catapult memory map
+ */
+
+
+#endif /* __BFI_CTREG_H__ */
diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
new file mode 100644
index 0000000..69ac85f
--- /dev/null
+++ b/drivers/scsi/bfa/bfi_ms.h
@@ -0,0 +1,765 @@
+/*
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_MS_H__
+#define __BFI_MS_H__
+
+#include "bfi.h"
+#include "bfa_fc.h"
+#include "bfa_defs_svc.h"
+
+#pragma pack(1)
+
+enum bfi_iocfc_h2i_msgs {
+	BFI_IOCFC_H2I_CFG_REQ		= 1,
+	BFI_IOCFC_H2I_SET_INTR_REQ	= 2,
+	BFI_IOCFC_H2I_UPDATEQ_REQ	= 3,
+};
+
+enum bfi_iocfc_i2h_msgs {
+	BFI_IOCFC_I2H_CFG_REPLY		= BFA_I2HM(1),
+	BFI_IOCFC_I2H_UPDATEQ_RSP	= BFA_I2HM(3),
+};
+
+struct bfi_iocfc_cfg_s {
+	u8	num_cqs;	/*  Number of CQs to be used	*/
+	u8	 sense_buf_len;	/*  SCSI sense length	    */
+	u16	rsvd_1;
+	u32	endian_sig;	/*  endian signature of host     */
+
+	/**
+	 * Request and response circular queue base addresses, size and
+	 * shadow index pointers.
+	 */
+	union bfi_addr_u  req_cq_ba[BFI_IOC_MAX_CQS];
+	union bfi_addr_u  req_shadow_ci[BFI_IOC_MAX_CQS];
+	u16    req_cq_elems[BFI_IOC_MAX_CQS];
+	union bfi_addr_u  rsp_cq_ba[BFI_IOC_MAX_CQS];
+	union bfi_addr_u  rsp_shadow_pi[BFI_IOC_MAX_CQS];
+	u16    rsp_cq_elems[BFI_IOC_MAX_CQS];
+
+	union bfi_addr_u  stats_addr;	/*  DMA-able address for stats	  */
+	union bfi_addr_u  cfgrsp_addr;	/*  config response dma address  */
+	union bfi_addr_u  ioim_snsbase;  /*  IO sense buffer base address */
+	struct bfa_iocfc_intr_attr_s intr_attr; /*  IOC interrupt attributes */
+};
+
+/**
+ * Boot target wwn information for this port. This contains either the stored
+ * or discovered boot target port wwns for the port.
+ */
+struct bfi_iocfc_bootwwns {
+	wwn_t		wwn[BFA_BOOT_BOOTLUN_MAX];
+	u8		nwwns;
+	u8		rsvd[7];
+};
+
+struct bfi_iocfc_cfgrsp_s {
+	struct bfa_iocfc_fwcfg_s	fwcfg;
+	struct bfa_iocfc_intr_attr_s	intr_attr;
+	struct bfi_iocfc_bootwwns	bootwwns;
+	struct bfi_pbc_s		pbc_cfg;
+};
+
+/**
+ * BFI_IOCFC_H2I_CFG_REQ message
+ */
+struct bfi_iocfc_cfg_req_s {
+	struct bfi_mhdr_s      mh;
+	union bfi_addr_u      ioc_cfg_dma_addr;
+};
+
+
+/**
+ * BFI_IOCFC_I2H_CFG_REPLY message
+ */
+struct bfi_iocfc_cfg_reply_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header	  */
+	u8	 cfg_success;	/*  cfg reply status	   */
+	u8	 lpu_bm;		/*  LPUs assigned for this IOC */
+	u8	 rsvd[2];
+};
+
+
+/**
+ * BFI_IOCFC_H2I_SET_INTR_REQ message
+ */
+struct bfi_iocfc_set_intr_req_s {
+	struct bfi_mhdr_s mh;		/*  common msg header		*/
+	u8		coalesce;	/*  enable intr coalescing	*/
+	u8		rsvd[3];
+	u16	delay;		/*  delay timer 0..1125us	*/
+	u16	latency;	/*  latency timer 0..225us	*/
+};
+
+
+/**
+ * BFI_IOCFC_H2I_UPDATEQ_REQ message
+ */
+struct bfi_iocfc_updateq_req_s {
+	struct bfi_mhdr_s mh;		/*  common msg header		*/
+	u32 reqq_ba;		/*  reqq base addr		*/
+	u32 rspq_ba;		/*  rspq base addr		*/
+	u32 reqq_sci;		/*  reqq shadow ci		*/
+	u32 rspq_spi;		/*  rspq shadow pi		*/
+};
+
+
+/**
+ * BFI_IOCFC_I2H_UPDATEQ_RSP message
+ */
+struct bfi_iocfc_updateq_rsp_s {
+	struct bfi_mhdr_s mh;		/*  common msg header	*/
+	u8	status;			/*  updateq  status	*/
+	u8	rsvd[3];
+};
+
+
+/**
+ * H2I Messages
+ */
+union bfi_iocfc_h2i_msg_u {
+	struct bfi_mhdr_s		mh;
+	struct bfi_iocfc_cfg_req_s	cfg_req;
+	struct bfi_iocfc_updateq_req_s updateq_req;
+	u32 mboxmsg[BFI_IOC_MSGSZ];
+};
+
+
+/**
+ * I2H Messages
+ */
+union bfi_iocfc_i2h_msg_u {
+	struct bfi_mhdr_s		mh;
+	struct bfi_iocfc_cfg_reply_s	cfg_reply;
+	struct bfi_iocfc_updateq_rsp_s updateq_rsp;
+	u32 mboxmsg[BFI_IOC_MSGSZ];
+};
+
+
+enum bfi_fcport_h2i {
+	BFI_FCPORT_H2I_ENABLE_REQ		= (1),
+	BFI_FCPORT_H2I_DISABLE_REQ		= (2),
+	BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ	= (3),
+	BFI_FCPORT_H2I_STATS_GET_REQ		= (4),
+	BFI_FCPORT_H2I_STATS_CLEAR_REQ		= (5),
+};
+
+
+enum bfi_fcport_i2h {
+	BFI_FCPORT_I2H_ENABLE_RSP		= BFA_I2HM(1),
+	BFI_FCPORT_I2H_DISABLE_RSP		= BFA_I2HM(2),
+	BFI_FCPORT_I2H_SET_SVC_PARAMS_RSP	= BFA_I2HM(3),
+	BFI_FCPORT_I2H_STATS_GET_RSP		= BFA_I2HM(4),
+	BFI_FCPORT_I2H_STATS_CLEAR_RSP		= BFA_I2HM(5),
+	BFI_FCPORT_I2H_EVENT			= BFA_I2HM(6),
+	BFI_FCPORT_I2H_TRUNK_SCN		= BFA_I2HM(7),
+	BFI_FCPORT_I2H_ENABLE_AEN		= BFA_I2HM(8),
+	BFI_FCPORT_I2H_DISABLE_AEN		= BFA_I2HM(9),
+};
+
+
+/**
+ * Generic REQ type
+ */
+struct bfi_fcport_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header			    */
+	u32	   msgtag;	/*  msgtag for reply		    */
+};
+
+/**
+ * Generic RSP type
+ */
+struct bfi_fcport_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		    */
+	u8		   status;	/*  port enable status		    */
+	u8		   rsvd[3];
+	u32	   msgtag;	/*  msgtag for reply		    */
+};
+
+/**
+ * BFI_FCPORT_H2I_ENABLE_REQ
+ */
+struct bfi_fcport_enable_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header			    */
+	u32	   rsvd1;
+	wwn_t		   nwwn;	/*  node wwn of physical port	    */
+	wwn_t		   pwwn;	/*  port wwn of physical port	    */
+	struct bfa_port_cfg_s port_cfg; /*  port configuration	    */
+	union bfi_addr_u   stats_dma_addr; /*  DMA address for stats	    */
+	u32	   msgtag;	/*  msgtag for reply		    */
+	u32	   rsvd2;
+};
+
+/**
+ * BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ
+ */
+struct bfi_fcport_set_svc_params_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header */
+	u16	   tx_bbcredit;	/*  Tx credits */
+	u16	   rsvd;
+};
+
+/**
+ * BFI_FCPORT_I2H_EVENT
+ */
+struct bfi_fcport_event_s {
+	struct bfi_mhdr_s	mh;	/*  common msg header */
+	struct bfa_port_link_s	link_state;
+};
+
+/**
+ * BFI_FCPORT_I2H_TRUNK_SCN
+ */
+struct bfi_fcport_trunk_link_s {
+	wwn_t			trunk_wwn;
+	u8			fctl;		/* bfa_trunk_link_fctl_t */
+	u8			state;		/* bfa_trunk_link_state_t */
+	u8			speed;		/* bfa_port_speed_t */
+	u8			rsvd;
+	u32		deskew;
+};
+
+#define BFI_FCPORT_MAX_LINKS	2
+struct bfi_fcport_trunk_scn_s {
+	struct bfi_mhdr_s	mh;
+	u8			trunk_state;	/* bfa_trunk_state_t */
+	u8			trunk_speed;	/* bfa_port_speed_t */
+	u8			rsvd_a[2];
+	struct bfi_fcport_trunk_link_s tlink[BFI_FCPORT_MAX_LINKS];
+};
+
+/**
+ * fcport H2I message
+ */
+union bfi_fcport_h2i_msg_u {
+	struct bfi_mhdr_s			*mhdr;
+	struct bfi_fcport_enable_req_s		*penable;
+	struct bfi_fcport_req_s			*pdisable;
+	struct bfi_fcport_set_svc_params_req_s	*psetsvcparams;
+	struct bfi_fcport_req_s			*pstatsget;
+	struct bfi_fcport_req_s			*pstatsclear;
+};
+
+/**
+ * fcport I2H message
+ */
+union bfi_fcport_i2h_msg_u {
+	struct bfi_msg_s			*msg;
+	struct bfi_fcport_rsp_s			*penable_rsp;
+	struct bfi_fcport_rsp_s			*pdisable_rsp;
+	struct bfi_fcport_rsp_s			*psetsvcparams_rsp;
+	struct bfi_fcport_rsp_s			*pstatsget_rsp;
+	struct bfi_fcport_rsp_s			*pstatsclear_rsp;
+	struct bfi_fcport_event_s		*event;
+	struct bfi_fcport_trunk_scn_s		*trunk_scn;
+};
+
+enum bfi_fcxp_h2i {
+	BFI_FCXP_H2I_SEND_REQ = 1,
+};
+
+enum bfi_fcxp_i2h {
+	BFI_FCXP_I2H_SEND_RSP = BFA_I2HM(1),
+};
+
+#define BFA_FCXP_MAX_SGES	2
+
+/**
+ * FCXP send request structure
+ */
+struct bfi_fcxp_send_req_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		    */
+	u16	fcxp_tag;	/*  driver request tag		    */
+	u16	max_frmsz;	/*  max send frame size	    */
+	u16	vf_id;		/*  vsan tag if applicable	    */
+	u16	rport_fw_hndl;	/*  FW Handle for the remote port  */
+	u8	 class;		/*  FC class used for req/rsp	    */
+	u8	 rsp_timeout;	/*  timeout in secs, 0-no response */
+	u8	 cts;		/*  continue sequence		    */
+	u8	 lp_tag;	/*  lport tag			    */
+	struct fchs_s	fchs;	/*  request FC header structure    */
+	u32	req_len;	/*  request payload length	    */
+	u32	rsp_maxlen;	/*  max response length expected   */
+	struct bfi_sge_s   req_sge[BFA_FCXP_MAX_SGES];	/*  request buf    */
+	struct bfi_sge_s   rsp_sge[BFA_FCXP_MAX_SGES];	/*  response buf   */
+};
+
+/**
+ * FCXP send response structure
+ */
+struct bfi_fcxp_send_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		    */
+	u16	fcxp_tag;	/*  send request tag		    */
+	u8	 req_status;	/*  request status		    */
+	u8	 rsvd;
+	u32	rsp_len;	/*  actual response length	    */
+	u32	residue_len;	/*  residual response length	    */
+	struct fchs_s	fchs;	/*  response FC header structure   */
+};
+
+enum bfi_uf_h2i {
+	BFI_UF_H2I_BUF_POST = 1,
+};
+
+enum bfi_uf_i2h {
+	BFI_UF_I2H_FRM_RCVD = BFA_I2HM(1),
+};
+
+#define BFA_UF_MAX_SGES	2
+
+struct bfi_uf_buf_post_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		*/
+	u16	buf_tag;	/*  buffer tag			*/
+	u16	buf_len;	/*  total buffer length	*/
+	struct bfi_sge_s   sge[BFA_UF_MAX_SGES]; /*  buffer DMA SGEs	*/
+};
+
+struct bfi_uf_frm_rcvd_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		*/
+	u16	buf_tag;	/*  buffer tag			*/
+	u16	rsvd;
+	u16	frm_len;	/*  received frame length	*/
+	u16	xfr_len;	/*  tranferred length		*/
+};
+
+enum bfi_lps_h2i_msgs {
+	BFI_LPS_H2I_LOGIN_REQ	= 1,
+	BFI_LPS_H2I_LOGOUT_REQ	= 2,
+};
+
+enum bfi_lps_i2h_msgs {
+	BFI_LPS_H2I_LOGIN_RSP	= BFA_I2HM(1),
+	BFI_LPS_H2I_LOGOUT_RSP	= BFA_I2HM(2),
+	BFI_LPS_H2I_CVL_EVENT	= BFA_I2HM(3),
+};
+
+struct bfi_lps_login_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		alpa;
+	u16	pdu_size;
+	wwn_t		pwwn;
+	wwn_t		nwwn;
+	u8		fdisc;
+	u8		auth_en;
+	u8		rsvd[2];
+};
+
+struct bfi_lps_login_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		status;
+	u8		lsrjt_rsn;
+	u8		lsrjt_expl;
+	wwn_t		port_name;
+	wwn_t		node_name;
+	u16	bb_credit;
+	u8		f_port;
+	u8		npiv_en;
+	u32	lp_pid:24;
+	u32	auth_req:8;
+	mac_t		lp_mac;
+	mac_t		fcf_mac;
+	u8		ext_status;
+	u8		brcd_switch;	/*  attached peer is brcd switch */
+};
+
+struct bfi_lps_logout_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		rsvd[3];
+	wwn_t		port_name;
+};
+
+struct bfi_lps_logout_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		status;
+	u8		rsvd[2];
+};
+
+struct bfi_lps_cvl_event_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		rsvd[3];
+};
+
+union bfi_lps_h2i_msg_u {
+	struct bfi_mhdr_s		*msg;
+	struct bfi_lps_login_req_s	*login_req;
+	struct bfi_lps_logout_req_s	*logout_req;
+};
+
+union bfi_lps_i2h_msg_u {
+	struct bfi_msg_s		*msg;
+	struct bfi_lps_login_rsp_s	*login_rsp;
+	struct bfi_lps_logout_rsp_s	*logout_rsp;
+	struct bfi_lps_cvl_event_s	*cvl_event;
+};
+
+enum bfi_rport_h2i_msgs {
+	BFI_RPORT_H2I_CREATE_REQ = 1,
+	BFI_RPORT_H2I_DELETE_REQ = 2,
+	BFI_RPORT_H2I_SET_SPEED_REQ  = 3,
+};
+
+enum bfi_rport_i2h_msgs {
+	BFI_RPORT_I2H_CREATE_RSP = BFA_I2HM(1),
+	BFI_RPORT_I2H_DELETE_RSP = BFA_I2HM(2),
+	BFI_RPORT_I2H_QOS_SCN    = BFA_I2HM(3),
+};
+
+struct bfi_rport_create_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16	bfa_handle;	/*  host rport handle		*/
+	u16	max_frmsz;	/*  max rcv pdu size		*/
+	u32	pid:24,	/*  remote port ID		*/
+		lp_tag:8;	/*  local port tag		*/
+	u32	local_pid:24,	/*  local port ID		*/
+		cisc:8;
+	u8	fc_class;	/*  supported FC classes	*/
+	u8	vf_en;		/*  virtual fabric enable	*/
+	u16	vf_id;		/*  virtual fabric ID		*/
+};
+
+struct bfi_rport_create_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		status;		/*  rport creation status	*/
+	u8		rsvd[3];
+	u16	bfa_handle;	/*  host rport handle		*/
+	u16	fw_handle;	/*  firmware rport handle	*/
+	struct bfa_rport_qos_attr_s qos_attr;  /* QoS Attributes */
+};
+
+struct bfa_rport_speed_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16	fw_handle;	/*  firmware rport handle	*/
+	u8		speed;		/*  rport's speed via RPSC	*/
+	u8		rsvd;
+};
+
+struct bfi_rport_delete_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16	fw_handle;	/*  firmware rport handle	*/
+	u16	rsvd;
+};
+
+struct bfi_rport_delete_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16	bfa_handle;	/*  host rport handle		*/
+	u8		status;		/*  rport deletion status	*/
+	u8		rsvd;
+};
+
+struct bfi_rport_qos_scn_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16	bfa_handle;	/*  host rport handle		*/
+	u16	rsvd;
+	struct bfa_rport_qos_attr_s old_qos_attr;  /* Old QoS Attributes */
+	struct bfa_rport_qos_attr_s new_qos_attr;  /* New QoS Attributes */
+};
+
+union bfi_rport_h2i_msg_u {
+	struct bfi_msg_s		*msg;
+	struct bfi_rport_create_req_s	*create_req;
+	struct bfi_rport_delete_req_s	*delete_req;
+	struct bfi_rport_speed_req_s	*speed_req;
+};
+
+union bfi_rport_i2h_msg_u {
+	struct bfi_msg_s		*msg;
+	struct bfi_rport_create_rsp_s	*create_rsp;
+	struct bfi_rport_delete_rsp_s	*delete_rsp;
+	struct bfi_rport_qos_scn_s	*qos_scn_evt;
+};
+
+/*
+ * Initiator mode I-T nexus interface defines.
+ */
+
+enum bfi_itnim_h2i {
+	BFI_ITNIM_H2I_CREATE_REQ = 1,	/*  i-t nexus creation */
+	BFI_ITNIM_H2I_DELETE_REQ = 2,	/*  i-t nexus deletion */
+};
+
+enum bfi_itnim_i2h {
+	BFI_ITNIM_I2H_CREATE_RSP = BFA_I2HM(1),
+	BFI_ITNIM_I2H_DELETE_RSP = BFA_I2HM(2),
+	BFI_ITNIM_I2H_SLER_EVENT = BFA_I2HM(3),
+};
+
+struct bfi_itnim_create_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16	fw_handle;	/*  f/w handle for itnim	 */
+	u8	class;		/*  FC class for IO		 */
+	u8	seq_rec;	/*  sequence recovery support	 */
+	u8	msg_no;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_create_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16	bfa_handle;	/*  bfa handle for itnim	 */
+	u8	status;		/*  fcp request status		 */
+	u8	seq_id;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_delete_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16	fw_handle;	/*  f/w itnim handle		 */
+	u8	seq_id;		/*  seq id of the msg		 */
+	u8	rsvd;
+};
+
+struct bfi_itnim_delete_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16	bfa_handle;	/*  bfa handle for itnim	 */
+	u8	status;		/*  fcp request status		 */
+	u8	seq_id;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_sler_event_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16	bfa_handle;	/*  bfa handle for itnim	 */
+	u16	rsvd;
+};
+
+union bfi_itnim_h2i_msg_u {
+	struct bfi_itnim_create_req_s *create_req;
+	struct bfi_itnim_delete_req_s *delete_req;
+	struct bfi_msg_s	*msg;
+};
+
+union bfi_itnim_i2h_msg_u {
+	struct bfi_itnim_create_rsp_s *create_rsp;
+	struct bfi_itnim_delete_rsp_s *delete_rsp;
+	struct bfi_itnim_sler_event_s *sler_event;
+	struct bfi_msg_s	*msg;
+};
+
+/*
+ * Initiator mode IO interface defines.
+ */
+
+enum bfi_ioim_h2i {
+	BFI_IOIM_H2I_IOABORT_REQ = 1,	/*  IO abort request	 */
+	BFI_IOIM_H2I_IOCLEANUP_REQ = 2,	/*  IO cleanup request	 */
+};
+
+enum bfi_ioim_i2h {
+	BFI_IOIM_I2H_IO_RSP = BFA_I2HM(1),	/*  non-fp IO response	 */
+	BFI_IOIM_I2H_IOABORT_RSP = BFA_I2HM(2),	/*  ABORT rsp	 */
+};
+
+/**
+ * IO command DIF info
+ */
+struct bfi_ioim_dif_s {
+	u32	dif_info[4];
+};
+
+/**
+ * FCP IO messages overview
+ *
+ * @note
+ * - Max CDB length supported is 64 bytes.
+ * - SCSI Linked commands and SCSI bi-directional Commands not
+ *	supported.
+ *
+ */
+struct bfi_ioim_req_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		 */
+	u16	io_tag;		/*  I/O tag			 */
+	u16	rport_hdl;	/*  itnim/rport firmware handle */
+	struct fcp_cmnd_s	cmnd;	/*  IO request info	*/
+
+	/**
+	 * SG elements array within the IO request must be double word
+	 * aligned. This aligment is required to optimize SGM setup for the IO.
+	 */
+	struct bfi_sge_s	sges[BFI_SGE_INLINE_MAX];
+	u8	io_timeout;
+	u8	dif_en;
+	u8	rsvd_a[2];
+	struct bfi_ioim_dif_s  dif;
+};
+
+/**
+ *	This table shows various IO status codes from firmware and their
+ *	meaning. Host driver can use these status codes to further process
+ *	IO completions.
+ *
+ *	BFI_IOIM_STS_OK		: IO completed with error free SCSI &
+ *					transport status.
+ *					 io-tag can be reused.
+ *
+ *	BFA_IOIM_STS_SCSI_ERR		: IO completed with scsi error.
+ *	- io-tag can be reused.
+ *
+ *	BFI_IOIM_STS_HOST_ABORTED	: IO was aborted successfully due to
+ *						host request.
+ *					- io-tag cannot be reused yet.
+ *
+ *	BFI_IOIM_STS_ABORTED		: IO was aborted successfully
+ *						internally by f/w.
+ *					- io-tag cannot be reused yet.
+ *
+ *	BFI_IOIM_STS_TIMEDOUT	: IO timedout and ABTS/RRQ is happening
+ *					in the firmware and
+ *					- io-tag cannot be reused yet.
+ *
+ *	BFI_IOIM_STS_SQER_NEEDED	: Firmware could not recover the IO
+ *					  with sequence level error
+ *	logic and hence host needs to retry
+ *					  this IO with a different IO tag
+ *					- io-tag cannot be used yet.
+ *
+ *	BFI_IOIM_STS_NEXUS_ABORT	: Second Level Error Recovery from host
+ *					  is required because 2 consecutive ABTS
+ *					  timedout and host needs logout and
+ *					  re-login with the target
+ *					- io-tag cannot be used yet.
+ *
+ *	BFI_IOIM_STS_UNDERRUN	: IO completed with SCSI status good,
+ *					  but the data tranferred is less than
+ *					  the fcp data length in the command.
+ *					  ex. SCSI INQUIRY where transferred
+ *					  data length and residue count in FCP
+ *					  response accounts for total fcp-dl
+ *					  - io-tag can be reused.
+ *
+ *	BFI_IOIM_STS_OVERRUN	: IO completed with SCSI status good,
+ *					  but the data transerred is more than
+ *					  fcp data length in the command. ex.
+ *					  TAPE IOs where blocks can of unequal
+ *					  lengths.
+ *					- io-tag can be reused.
+ *
+ *	BFI_IOIM_STS_RES_FREE	: Firmware has completed using io-tag
+ *					  during abort process
+ *					- io-tag can be reused.
+ *
+ *	BFI_IOIM_STS_PROTO_ERR	: Firmware detected a protocol error.
+ *					  ex target sent more data than
+ *					  requested, or there was data frame
+ *					  loss and other reasons
+ *					- io-tag cannot be used yet.
+ *
+ *	BFI_IOIM_STS_DIF_ERR	: Firwmare detected DIF error. ex: DIF
+ *					CRC err or Ref Tag err or App tag err.
+ *					- io-tag can be reused.
+ *
+ *	BFA_IOIM_STS_TSK_MGT_ABORT	: IO was aborted because of Task
+ *					  Management command from the host
+ *					  - io-tag can be reused.
+ *
+ *	BFI_IOIM_STS_UTAG		: Firmware does not know about this
+ *					  io_tag.
+ *					- io-tag can be reused.
+ */
+enum bfi_ioim_status {
+	BFI_IOIM_STS_OK = 0,
+	BFI_IOIM_STS_HOST_ABORTED = 1,
+	BFI_IOIM_STS_ABORTED = 2,
+	BFI_IOIM_STS_TIMEDOUT = 3,
+	BFI_IOIM_STS_RES_FREE = 4,
+	BFI_IOIM_STS_SQER_NEEDED = 5,
+	BFI_IOIM_STS_PROTO_ERR = 6,
+	BFI_IOIM_STS_UTAG = 7,
+	BFI_IOIM_STS_PATHTOV = 8,
+};
+
+#define BFI_IOIM_SNSLEN	(256)
+/**
+ * I/O response message
+ */
+struct bfi_ioim_rsp_s {
+	struct bfi_mhdr_s	mh;	/*  common msg header		*/
+	u16	io_tag;		/*  completed IO tag		 */
+	u16	bfa_rport_hndl;	/*  releated rport handle	 */
+	u8	io_status;	/*  IO completion status	 */
+	u8	reuse_io_tag;	/*  IO tag can be reused	*/
+	u16	abort_tag;	/*  host abort request tag	*/
+	u8		scsi_status;	/*  scsi status from target	 */
+	u8		sns_len;	/*  scsi sense length		 */
+	u8		resid_flags;	/*  IO residue flags		 */
+	u8		rsvd_a;
+	u32	residue;	/*  IO residual length in bytes */
+	u32	rsvd_b[3];
+};
+
+struct bfi_ioim_abort_req_s {
+	struct bfi_mhdr_s  mh;	/*  Common msg header  */
+	u16	io_tag;	/*  I/O tag	*/
+	u16	abort_tag;	/*  unique request tag */
+};
+
+/*
+ * Initiator mode task management command interface defines.
+ */
+
+enum bfi_tskim_h2i {
+	BFI_TSKIM_H2I_TM_REQ	= 1, /*  task-mgmt command	*/
+	BFI_TSKIM_H2I_ABORT_REQ = 2, /*  task-mgmt command	*/
+};
+
+enum bfi_tskim_i2h {
+	BFI_TSKIM_I2H_TM_RSP = BFA_I2HM(1),
+};
+
+struct bfi_tskim_req_s {
+	struct bfi_mhdr_s  mh;	/*  Common msg header	*/
+	u16	tsk_tag;	/*  task management tag	*/
+	u16	itn_fhdl;	/*  itn firmware handle	*/
+	lun_t	lun;	/*  LU number	*/
+	u8	tm_flags;	/*  see enum fcp_tm_cmnd	*/
+	u8	t_secs;	/*  Timeout value in seconds	*/
+	u8	rsvd[2];
+};
+
+struct bfi_tskim_abortreq_s {
+	struct bfi_mhdr_s  mh;	/*  Common msg header	*/
+	u16	tsk_tag;	/*  task management tag	*/
+	u16	rsvd;
+};
+
+enum bfi_tskim_status {
+	/*
+	 * Following are FCP-4 spec defined status codes,
+	 * **DO NOT CHANGE THEM **
+	 */
+	BFI_TSKIM_STS_OK	= 0,
+	BFI_TSKIM_STS_NOT_SUPP = 4,
+	BFI_TSKIM_STS_FAILED	= 5,
+
+	/**
+	 * Defined by BFA
+	 */
+	BFI_TSKIM_STS_TIMEOUT  = 10,	/*  TM request timedout	*/
+	BFI_TSKIM_STS_ABORTED  = 11,	/*  Aborted on host request */
+};
+
+struct bfi_tskim_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		 */
+	u16	tsk_tag;	/*  task mgmt cmnd tag		 */
+	u8	tsk_status;	/*  @ref bfi_tskim_status */
+	u8	rsvd;
+};
+
+#pragma pack()
+
+#endif /* __BFI_MS_H__ */
-- 
1.7.3.rc1

