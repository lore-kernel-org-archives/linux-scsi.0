From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [RFC] [PATCH 1/5] qla4xxx: Add IPv6 support and misc
Date: Wed, 02 May 2007 19:05:07 -0700
Message-ID: <1178157907.20898.38.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:38102 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767295AbXECBFE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2007 21:05:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>


Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>

---
 drivers/scsi/qla4xxx/ql4_def.h     |   84 ++++---
 drivers/scsi/qla4xxx/ql4_fw.h      |  426 +++++++++++++++---------------------

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 6f4cf2d..7bbc2ab 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -122,8 +122,7 @@ #define MAX_REQS_SERVICED_PER_INTR	16
 
 #define ISCSI_IPADDR_SIZE		4	/* IP address size */
 #define ISCSI_ALIAS_SIZE		32	/* ISCSI Alais name size */
-#define ISCSI_NAME_SIZE			255	/* ISCSI Name size -
-						 * usually a string */
+#define ISCSI_NAME_SIZE			0xE0	/* ISCSI Name size */
 
 #define LSDW(x) ((u32)((u64)(x)))
 #define MSDW(x) ((u32)((((u64)(x)) >> 16) >> 16))
@@ -159,6 +158,7 @@ struct srb {
 	struct ddb_entry	*ddb;
 	uint16_t flags;		/* (1) Status flags. */
 
+#define SRB_SCSI_PASSTHRU	BIT_2	/* for scsi passthru cmds */
 #define SRB_DMA_VALID		BIT_3	/* DMA Buffer mapped. */
 #define SRB_GOT_SENSE		BIT_4	/* sense data recieved. */
 	uint8_t state;		/* (1) Status flags. */
@@ -187,9 +187,21 @@ #define SRB_ERR_OTHER	   4
 	u_long u_start;		/* Time when we handed the cmd to F/W */
 };
 
-	/*
-	 * Device Database (DDB) structure
-	 */
+/*
+ * Asynchronous Event Queue structure
+ */
+struct aen {
+        uint32_t mbox_sts[MBOX_AEN_REG_COUNT];
+};
+
+struct ql4_aen_log {
+        int count;
+        struct aen entry[MAX_AEN_ENTRIES];
+};
+
+/*
+ * Device Database (DDB) structure
+ */
 struct ddb_entry {
 	struct list_head list;	/* ddb list */
 	struct scsi_qla_host *ha;
@@ -254,13 +266,6 @@ #define DF_NO_RELOGIN		1	/* Do not relog
 #define DF_ISNS_DISCOVERED	2	/* Device was discovered via iSNS */
 #define DF_FO_MASKED		3
 
-/*
- * Asynchronous Event Queue structure
- */
-struct aen {
-	uint32_t mbox_sts[MBOX_AEN_REG_COUNT];
-};
-
 
 #include "ql4_fw.h"
 #include "ql4_nvram.h"
@@ -270,31 +275,36 @@ #include "ql4_nvram.h"
  */
 struct scsi_qla_host {
 	/* Linux adapter configuration data */
-	struct Scsi_Host *host; /* pointer to host data */
-	uint32_t tot_ddbs;
 	unsigned long flags;
 
-#define AF_ONLINE		      0 /* 0x00000001 */
-#define AF_INIT_DONE		      1 /* 0x00000002 */
-#define AF_MBOX_COMMAND		      2 /* 0x00000004 */
-#define AF_MBOX_COMMAND_DONE	      3 /* 0x00000008 */
-#define AF_INTERRUPTS_ON	      6 /* 0x00000040 Not Used */
-#define AF_GET_CRASH_RECORD	      7 /* 0x00000080 */
-#define AF_LINK_UP		      8 /* 0x00000100 */
-#define AF_IRQ_ATTACHED		     10 /* 0x00000400 */
-#define AF_ISNS_CMD_IN_PROCESS	     12 /* 0x00001000 */
-#define AF_ISNS_CMD_DONE	     13 /* 0x00002000 */
+#define AF_ONLINE			0 /* 0x00000001 */
+#define AF_INIT_DONE			1 /* 0x00000002 */
+#define AF_MBOX_COMMAND			2 /* 0x00000004 */
+#define AF_MBOX_COMMAND_DONE		3 /* 0x00000008 */
+#define AF_INTERRUPTS_ON		6 /* 0x00000040 */
+#define AF_GET_CRASH_RECORD		7 /* 0x00000080 */
+#define AF_LINK_UP			8 /* 0x00000100 */
+#define AF_IRQ_ATTACHED			10 /* 0x00000400 */
+#define AF_DISABLE_ACB_COMPLETE		11 /* 0x00000800 */
 
 	unsigned long dpc_flags;
 
-#define DPC_RESET_HA		      1 /* 0x00000002 */
-#define DPC_RETRY_RESET_HA	      2 /* 0x00000004 */
-#define DPC_RELOGIN_DEVICE	      3 /* 0x00000008 */
-#define DPC_RESET_HA_DESTROY_DDB_LIST 4 /* 0x00000010 */
-#define DPC_RESET_HA_INTR	      5 /* 0x00000020 */
-#define DPC_ISNS_RESTART	      7 /* 0x00000080 */
-#define DPC_AEN			      9 /* 0x00000200 */
-#define DPC_GET_DHCP_IP_ADDR	     15 /* 0x00008000 */
+#define DPC_RESET_HA			1 /* 0x00000002 */
+#define DPC_RETRY_RESET_HA		2 /* 0x00000004 */
+#define DPC_RELOGIN_DEVICE		3 /* 0x00000008 */
+#define DPC_RESET_HA_DESTROY_DDB_LIST	4 /* 0x00000010 */
+#define DPC_RESET_HA_INTR		5 /* 0x00000020 */
+#define DPC_ISNS_RESTART		7 /* 0x00000080 */
+#define DPC_AEN				9 /* 0x00000200 */
+#define DPC_GET_DHCP_IP_ADDR		15 /* 0x00008000 */
+
+	int (*ql4cmd)(struct scsi_qla_host *ha, struct srb * srb);
+	int (*ql4mbx)(struct scsi_qla_host *ha, uint8_t inCount,
+			uint8_t outCount, uint32_t *mbx_cmd,
+			uint32_t *mbx_sts);
+
+	struct Scsi_Host *host; /* pointer to host data */
+	uint32_t tot_ddbs;
 
 	uint16_t	iocb_cnt;
 	uint16_t	iocb_hiwat;
@@ -344,6 +354,7 @@ #define MIN_IOBASE_LEN		0x100
 	uint32_t firmware_version[2];
 	uint32_t patch_number;
 	uint32_t build_number;
+	uint32_t board_id;
 
 	/* --- From Init_FW --- */
 	/* init_cb_t *init_cb; */
@@ -363,7 +374,6 @@ #define MIN_IOBASE_LEN		0x100
 
 	/* --- From GetFwState --- */
 	uint32_t firmware_state;
-	uint32_t board_id;
 	uint32_t addl_fw_state;
 
 	/* Linux kernel thread */
@@ -414,6 +424,8 @@ #define MEM_ALIGN_VALUE \
 	uint16_t aen_out;
 	struct aen aen_q[MAX_AEN_ENTRIES];
 
+	struct ql4_aen_log aen_log;/* tracks all aens */
+
 	/* This mutex protects several threads to do mailbox commands
 	 * concurrently.
 	 */
@@ -585,10 +597,4 @@ #define PROCESS_ALL_AENS	 0
 #define FLUSH_DDB_CHANGED_AENS	 1
 #define RELOGIN_DDB_CHANGED_AENS 2
 
-#include "ql4_version.h"
-#include "ql4_glbl.h"
-#include "ql4_dbg.h"
-#include "ql4_inline.h"
-
-
 #endif	/*_QLA4XXX_H */
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 4eea8c5..9bb3d1d 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -20,143 +20,23 @@ #define MAX_DEV_DB_ENTRIES 512
  *************************************************************************/
 
 struct port_ctrl_stat_regs {
-	__le32 ext_hw_conf;	/*  80 x50  R/W */
-	__le32 intChipConfiguration; /*	 84 x54 */
-	__le32 port_ctrl;	/*  88 x58 */
-	__le32 port_status;	/*  92 x5c */
-	__le32 HostPrimMACHi;	/*  96 x60 */
-	__le32 HostPrimMACLow;	/* 100 x64 */
-	__le32 HostSecMACHi;	/* 104 x68 */
-	__le32 HostSecMACLow;	/* 108 x6c */
-	__le32 EPPrimMACHi;	/* 112 x70 */
-	__le32 EPPrimMACLow;	/* 116 x74 */
-	__le32 EPSecMACHi;	/* 120 x78 */
-	__le32 EPSecMACLow;	/* 124 x7c */
-	__le32 HostPrimIPHi;	/* 128 x80 */
-	__le32 HostPrimIPMidHi; /* 132 x84 */
-	__le32 HostPrimIPMidLow;	/* 136 x88 */
-	__le32 HostPrimIPLow;	/* 140 x8c */
-	__le32 HostSecIPHi;	/* 144 x90 */
-	__le32 HostSecIPMidHi;	/* 148 x94 */
-	__le32 HostSecIPMidLow; /* 152 x98 */
-	__le32 HostSecIPLow;	/* 156 x9c */
-	__le32 EPPrimIPHi;	/* 160 xa0 */
-	__le32 EPPrimIPMidHi;	/* 164 xa4 */
-	__le32 EPPrimIPMidLow;	/* 168 xa8 */
-	__le32 EPPrimIPLow;	/* 172 xac */
-	__le32 EPSecIPHi;	/* 176 xb0 */
-	__le32 EPSecIPMidHi;	/* 180 xb4 */
-	__le32 EPSecIPMidLow;	/* 184 xb8 */
-	__le32 EPSecIPLow;	/* 188 xbc */
-	__le32 IPReassemblyTimeout; /* 192 xc0 */
-	__le32 EthMaxFramePayload; /* 196 xc4 */
-	__le32 TCPMaxWindowSize; /* 200 xc8 */
-	__le32 TCPCurrentTimestampHi; /* 204 xcc */
-	__le32 TCPCurrentTimestampLow; /* 208 xd0 */
-	__le32 LocalRAMAddress; /* 212 xd4 */
-	__le32 LocalRAMData;	/* 216 xd8 */
-	__le32 PCSReserved1;	/* 220 xdc */
-	__le32 gp_out;		/* 224 xe0 */
-	__le32 gp_in;		/* 228 xe4 */
-	__le32 ProbeMuxAddr;	/* 232 xe8 */
-	__le32 ProbeMuxData;	/* 236 xec */
-	__le32 ERMQueueBaseAddr0; /* 240 xf0 */
-	__le32 ERMQueueBaseAddr1; /* 244 xf4 */
-	__le32 MACConfiguration; /* 248 xf8 */
-	__le32 port_err_status; /* 252 xfc  COR */
+	__le32 ext_hw_conf;	/* 0x50  R/W */
+	__le32 rsrvd0;		/* 0x54 */
+	__le32 port_ctrl;	/* 0x58 */
+	__le32 port_status;	/* 0x5c */
+	__le32 rsrvd1[32];	/* 0x60-0xdf */
+	__le32 gp_out;		/* 0xe0 */
+	__le32 gp_in;		/* 0xe4 */
+	__le32 rsrvd2[5];	/* 0xe8-0xfb */
+	__le32 port_err_status; /* 0xfc */
 };
 
 struct host_mem_cfg_regs {
-	__le32 NetRequestQueueOut; /*  80 x50 */
-	__le32 NetRequestQueueOutAddrHi; /*  84 x54 */
-	__le32 NetRequestQueueOutAddrLow; /*  88 x58 */
-	__le32 NetRequestQueueBaseAddrHi; /*  92 x5c */
-	__le32 NetRequestQueueBaseAddrLow; /*  96 x60 */
-	__le32 NetRequestQueueLength; /* 100 x64 */
-	__le32 NetResponseQueueIn; /* 104 x68 */
-	__le32 NetResponseQueueInAddrHi; /* 108 x6c */
-	__le32 NetResponseQueueInAddrLow; /* 112 x70 */
-	__le32 NetResponseQueueBaseAddrHi; /* 116 x74 */
-	__le32 NetResponseQueueBaseAddrLow; /* 120 x78 */
-	__le32 NetResponseQueueLength; /* 124 x7c */
-	__le32 req_q_out;	/* 128 x80 */
-	__le32 RequestQueueOutAddrHi; /* 132 x84 */
-	__le32 RequestQueueOutAddrLow; /* 136 x88 */
-	__le32 RequestQueueBaseAddrHi; /* 140 x8c */
-	__le32 RequestQueueBaseAddrLow; /* 144 x90 */
-	__le32 RequestQueueLength; /* 148 x94 */
-	__le32 ResponseQueueIn; /* 152 x98 */
-	__le32 ResponseQueueInAddrHi; /* 156 x9c */
-	__le32 ResponseQueueInAddrLow; /* 160 xa0 */
-	__le32 ResponseQueueBaseAddrHi; /* 164 xa4 */
-	__le32 ResponseQueueBaseAddrLow; /* 168 xa8 */
-	__le32 ResponseQueueLength; /* 172 xac */
-	__le32 NetRxLargeBufferQueueOut; /* 176 xb0 */
-	__le32 NetRxLargeBufferQueueBaseAddrHi; /* 180 xb4 */
-	__le32 NetRxLargeBufferQueueBaseAddrLow; /* 184 xb8 */
-	__le32 NetRxLargeBufferQueueLength; /* 188 xbc */
-	__le32 NetRxLargeBufferLength; /* 192 xc0 */
-	__le32 NetRxSmallBufferQueueOut; /* 196 xc4 */
-	__le32 NetRxSmallBufferQueueBaseAddrHi; /* 200 xc8 */
-	__le32 NetRxSmallBufferQueueBaseAddrLow; /* 204 xcc */
-	__le32 NetRxSmallBufferQueueLength; /* 208 xd0 */
-	__le32 NetRxSmallBufferLength; /* 212 xd4 */
-	__le32 HMCReserved0[10]; /* 216 xd8 */
+	__le32 rsrvd0[12];	/* 0x50-0x79 */
+	__le32 req_q_out;	/* 0x80 */
+	__le32 rsrvd1[31];	/* 0x84-0xFF */
 };
 
-struct local_ram_cfg_regs {
-	__le32 BufletSize;	/*  80 x50 */
-	__le32 BufletMaxCount;	/*  84 x54 */
-	__le32 BufletCurrCount; /*  88 x58 */
-	__le32 BufletPauseThresholdCount; /*  92 x5c */
-	__le32 BufletTCPWinThresholdHi; /*  96 x60 */
-	__le32 BufletTCPWinThresholdLow; /* 100 x64 */
-	__le32 IPHashTableBaseAddr; /* 104 x68 */
-	__le32 IPHashTableSize; /* 108 x6c */
-	__le32 TCPHashTableBaseAddr; /* 112 x70 */
-	__le32 TCPHashTableSize; /* 116 x74 */
-	__le32 NCBAreaBaseAddr; /* 120 x78 */
-	__le32 NCBMaxCount;	/* 124 x7c */
-	__le32 NCBCurrCount;	/* 128 x80 */
-	__le32 DRBAreaBaseAddr; /* 132 x84 */
-	__le32 DRBMaxCount;	/* 136 x88 */
-	__le32 DRBCurrCount;	/* 140 x8c */
-	__le32 LRCReserved[28]; /* 144 x90 */
-};
-
-struct prot_stat_regs {
-	__le32 MACTxFrameCount; /*  80 x50   R */
-	__le32 MACTxByteCount;	/*  84 x54   R */
-	__le32 MACRxFrameCount; /*  88 x58   R */
-	__le32 MACRxByteCount;	/*  92 x5c   R */
-	__le32 MACCRCErrCount;	/*  96 x60   R */
-	__le32 MACEncErrCount;	/* 100 x64   R */
-	__le32 MACRxLengthErrCount; /* 104 x68	 R */
-	__le32 IPTxPacketCount; /* 108 x6c   R */
-	__le32 IPTxByteCount;	/* 112 x70   R */
-	__le32 IPTxFragmentCount; /* 116 x74   R */
-	__le32 IPRxPacketCount; /* 120 x78   R */
-	__le32 IPRxByteCount;	/* 124 x7c   R */
-	__le32 IPRxFragmentCount; /* 128 x80   R */
-	__le32 IPDatagramReassemblyCount; /* 132 x84   R */
-	__le32 IPV6RxPacketCount; /* 136 x88   R */
-	__le32 IPErrPacketCount; /* 140 x8c   R */
-	__le32 IPReassemblyErrCount; /* 144 x90	  R */
-	__le32 TCPTxSegmentCount; /* 148 x94   R */
-	__le32 TCPTxByteCount;	/* 152 x98   R */
-	__le32 TCPRxSegmentCount; /* 156 x9c   R */
-	__le32 TCPRxByteCount;	/* 160 xa0   R */
-	__le32 TCPTimerExpCount; /* 164 xa4   R */
-	__le32 TCPRxAckCount;	/* 168 xa8   R */
-	__le32 TCPTxAckCount;	/* 172 xac   R */
-	__le32 TCPRxErrOOOCount; /* 176 xb0   R */
-	__le32 PSReserved0;	/* 180 xb4 */
-	__le32 TCPRxWindowProbeUpdateCount; /* 184 xb8	 R */
-	__le32 ECCErrCorrectionCount; /* 188 xbc   R */
-	__le32 PSReserved1[16]; /* 192 xc0 */
-};
-
-
 /*  remote register set (access via PCI memory read/write) */
 struct isp_reg {
 #define MBOX_REG_COUNT 8
@@ -207,11 +87,7 @@ #define MBOX_REG_COUNT 8
 			union {
 				struct port_ctrl_stat_regs p0;
 				struct host_mem_cfg_regs p1;
-				struct local_ram_cfg_regs p2;
-				struct prot_stat_regs p3;
-				__le32 r_union[44];
 			};
-
 		} __attribute__ ((packed)) isp4022;
 	} u2;
 };				/* 256 x100 */
@@ -296,6 +172,7 @@ #define NVR_WRITE_ENABLE			0x00000010	/*
 /*  ISP Semaphore definitions */
 
 /*  ISP General Purpose Output definitions */
+#define GPOR_TOPCAT_RESET			0x00000004
 
 /*  shadow registers (DMA'd from HA to system memory.  read only) */
 struct shadow_regs {
@@ -337,6 +214,7 @@ union external_hw_config_reg {
 
 /*  Mailbox command definitions */
 #define MBOX_CMD_ABOUT_FW			0x0009
+#define MBOX_CMD_PING				0x000B
 #define MBOX_CMD_LUN_RESET			0x0016
 #define MBOX_CMD_GET_MANAGEMENT_DATA		0x001E
 #define MBOX_CMD_GET_FW_STATUS			0x001F
@@ -364,6 +242,17 @@ #define DDB_DS_LOGIN_IN_PROCESS			0x07
 #define MBOX_CMD_GET_FW_STATE			0x0069
 #define MBOX_CMD_GET_INIT_FW_CTRL_BLOCK_DEFAULTS 0x006A
 #define MBOX_CMD_RESTORE_FACTORY_DEFAULTS	0x0087
+#define MBOX_CMD_SET_ACB			0x0088
+#define MBOX_CMD_GET_ACB			0x0089
+#define MBOX_CMD_DISABLE_ACB			0x008A
+#define MBOX_CMD_GET_IPV6_NEIGHBOR_CACHE	0x008B
+#define MBOX_CMD_GET_IPV6_DEST_CACHE		0x008C
+#define MBOX_CMD_GET_IPV6_DEF_ROUTER_LIST	0x008D
+#define MBOX_CMD_GET_IPV6_LCL_PREFIX_LIST	0x008E
+#define MBOX_CMD_SET_IPV6_NEIGHBOR_CACHE	0x0090
+#define MBOX_CMD_GET_IP_ADDR_STATE		0x0091
+#define MBOX_CMD_SEND_IPV6_ROUTER_SOL		0x0092
+#define MBOX_CMD_GET_DB_ENTRY_CURRENT_IP_ADDR	0x0093
 
 /* Mailbox 1 */
 #define FW_STATE_READY				0x0000
@@ -409,6 +298,16 @@ #define MBOX_ASTS_IP_ADDRESS_CHANGED		0x
 #define MBOX_ASTS_DHCP_LEASE_EXPIRED		0x801D
 #define MBOX_ASTS_DHCP_LEASE_ACQUIRED		0x801F
 #define MBOX_ASTS_ISNS_UNSOLICITED_PDU_RECEIVED 0x8021
+#define MBOX_ASTS_DUPLICATE_IP			0x8025
+#define MBOX_ASTS_ARP_COMPLETE			0x8026
+#define MBOX_ASTS_SUBNET_STATE_CHANGE		0x8027
+#define MBOX_ASTS_RESPONSE_QUEUE_FULL		0x8028
+#define MBOX_ASTS_IP_ADDR_STATE_CHANGED		0x8029
+#define MBOX_ASTS_IPV6_PREFIX_EXPIRED		0x802B
+#define MBOX_ASTS_IPV6_ND_PREFIX_IGNORED	0x802C
+#define MBOX_ASTS_IPV6_LCL_PREFIX_IGNORED	0x802D
+#define MBOX_ASTS_ICMPV6_ERROR_MSG_RCVD		0x802E
+
 #define ISNS_EVENT_DATA_RECEIVED		0x0000
 #define ISNS_EVENT_CONNECTION_OPENED		0x0001
 #define ISNS_EVENT_CONNECTION_FAILED		0x0002
@@ -418,137 +317,166 @@ #define MBOX_ASTS_SUBNET_STATE_CHANGE		0
 /*************************************************************************/
 
 /* Host Adapter Initialization Control Block (from host) */
-struct init_fw_ctrl_blk {
-	uint8_t Version;	/* 00 */
-	uint8_t Control;	/* 01 */
+struct addr_ctrl_blk {
+	uint8_t version;	/* 00 */
+	uint8_t control;	/* 01 */
 
-	uint16_t FwOptions;	/* 02-03 */
+	uint16_t fw_options;	/* 02-03 */
 #define	 FWOPT_HEARTBEAT_ENABLE		  0x1000
 #define	 FWOPT_SESSION_MODE		  0x0040
 #define	 FWOPT_INITIATOR_MODE		  0x0020
 #define	 FWOPT_TARGET_MODE		  0x0010
 
-	uint16_t ExecThrottle;	/* 04-05 */
-	uint8_t RetryCount;	/* 06 */
-	uint8_t RetryDelay;	/* 07 */
-	uint16_t MaxEthFrPayloadSize;	/* 08-09 */
-	uint16_t AddFwOptions;	/* 0A-0B */
-
-	uint8_t HeartbeatInterval;	/* 0C */
-	uint8_t InstanceNumber; /* 0D */
-	uint16_t RES2;		/* 0E-0F */
-	uint16_t ReqQConsumerIndex;	/* 10-11 */
-	uint16_t ComplQProducerIndex;	/* 12-13 */
-	uint16_t ReqQLen;	/* 14-15 */
-	uint16_t ComplQLen;	/* 16-17 */
-	uint32_t ReqQAddrLo;	/* 18-1B */
-	uint32_t ReqQAddrHi;	/* 1C-1F */
-	uint32_t ComplQAddrLo;	/* 20-23 */
-	uint32_t ComplQAddrHi;	/* 24-27 */
-	uint32_t ShadowRegBufAddrLo;	/* 28-2B */
-	uint32_t ShadowRegBufAddrHi;	/* 2C-2F */
-
-	uint16_t iSCSIOptions;	/* 30-31 */
-
-	uint16_t TCPOptions;	/* 32-33 */
-
-	uint16_t IPOptions;	/* 34-35 */
-
-	uint16_t MaxPDUSize;	/* 36-37 */
-	uint16_t RcvMarkerInt;	/* 38-39 */
-	uint16_t SndMarkerInt;	/* 3A-3B */
-	uint16_t InitMarkerlessInt;	/* 3C-3D */
-	uint16_t FirstBurstSize;	/* 3E-3F */
-	uint16_t DefaultTime2Wait;	/* 40-41 */
-	uint16_t DefaultTime2Retain;	/* 42-43 */
-	uint16_t MaxOutStndngR2T;	/* 44-45 */
-	uint16_t KeepAliveTimeout;	/* 46-47 */
-	uint16_t PortNumber;	/* 48-49 */
-	uint16_t MaxBurstSize;	/* 4A-4B */
-	uint32_t RES4;		/* 4C-4F */
-	uint8_t IPAddr[4];	/* 50-53 */
-	uint8_t RES5[12];	/* 54-5F */
-	uint8_t SubnetMask[4];	/* 60-63 */
-	uint8_t RES6[12];	/* 64-6F */
-	uint8_t GatewayIPAddr[4];	/* 70-73 */
-	uint8_t RES7[12];	/* 74-7F */
-	uint8_t PriDNSIPAddr[4];	/* 80-83 */
-	uint8_t SecDNSIPAddr[4];	/* 84-87 */
-	uint8_t RES8[8];	/* 88-8F */
-	uint8_t Alias[32];	/* 90-AF */
-	uint8_t TargAddr[8];	/* B0-B7 *//* /FIXME: Remove?? */
-	uint8_t CHAPNameSecretsTable[8];	/* B8-BF */
-	uint8_t EthernetMACAddr[6];	/* C0-C5 */
-	uint16_t TargetPortalGroup;	/* C6-C7 */
-	uint8_t SendScale;	/* C8	 */
-	uint8_t RecvScale;	/* C9	 */
-	uint8_t TypeOfService;	/* CA	 */
-	uint8_t Time2Live;	/* CB	 */
-	uint16_t VLANPriority;	/* CC-CD */
-	uint16_t Reserved8;	/* CE-CF */
-	uint8_t SecIPAddr[4];	/* D0-D3 */
-	uint8_t Reserved9[12];	/* D4-DF */
-	uint8_t iSNSIPAddr[4];	/* E0-E3 */
-	uint16_t iSNSServerPortNumber;	/* E4-E5 */
-	uint8_t Reserved10[10]; /* E6-EF */
-	uint8_t SLPDAIPAddr[4]; /* F0-F3 */
-	uint8_t Reserved11[12]; /* F4-FF */
-	uint8_t iSCSINameString[256];	/* 100-1FF */
+	uint16_t exec_throttle;	/* 04-05 */
+	uint8_t zio_count;	/* 06 */
+	uint8_t res0;	/* 07 */
+	uint16_t eth_mtu_size;	/* 08-09 */
+	uint16_t add_fw_options;	/* 0A-0B */
+
+	uint8_t hb_interval;	/* 0C */
+	uint8_t inst_num; /* 0D */
+	uint16_t res1;		/* 0E-0F */
+	uint16_t rqq_consumer_idx;	/* 10-11 */
+	uint16_t compq_producer_idx;	/* 12-13 */
+	uint16_t rqq_len;	/* 14-15 */
+	uint16_t compq_len;	/* 16-17 */
+	uint32_t rqq_addr_lo;	/* 18-1B */
+	uint32_t rqq_addr_hi;	/* 1C-1F */
+	uint32_t compq_addr_lo;	/* 20-23 */
+	uint32_t compq_addr_hi;	/* 24-27 */
+	uint32_t shdwreg_addr_lo;	/* 28-2B */
+	uint32_t shdwreg_addr_hi;	/* 2C-2F */
+
+	uint16_t iscsi_opts;	/* 30-31 */
+	uint16_t ipv4_tcp_opts;	/* 32-33 */
+	uint16_t ipv4_ip_opts;	/* 34-35 */
+
+	uint16_t iscsi_max_pdu_size;	/* 36-37 */
+	uint8_t ipv4_tos;	/* 38 */
+	uint8_t ipv4_ttl;	/* 39 */
+	uint8_t acb_version;	/* 3A */
+	uint8_t res2;	/* 3B */
+	uint16_t def_timeout;	/* 3C-3D */
+	uint16_t iscsi_fburst_len;	/* 3E-3F */
+	uint16_t iscsi_def_time2wait;	/* 40-41 */
+	uint16_t iscsi_def_time2retain;	/* 42-43 */
+	uint16_t iscsi_max_outstnd_r2t;	/* 44-45 */
+	uint16_t conn_ka_timeout;	/* 46-47 */
+	uint16_t ipv4_port;	/* 48-49 */
+	uint16_t iscsi_max_burst_len;	/* 4A-4B */
+	uint32_t res5;		/* 4C-4F */
+	uint8_t ipv4_addr[4];	/* 50-53 */
+	uint16_t ipv4_vlan_tag;	/* 54-55 */
+	uint8_t ipv4_addr_state;	/* 56 */
+	uint8_t ipv4_cacheid;	/* 57 */
+	uint8_t res6[8];	/* 58-5F */
+	uint8_t ipv4_subnet[4];	/* 60-63 */
+	uint8_t res7[12];	/* 64-6F */
+	uint8_t ipv4_gw_addr[4];	/* 70-73 */
+	uint8_t res8[0xc];	/* 74-7F */
+	uint8_t pri_dns_srvr_ip[4];/* 80-83 */
+	uint8_t sec_dns_srvr_ip[4];/* 84-87 */
+	uint16_t min_eph_port;	/* 88-89 */
+	uint16_t max_eph_port;	/* 8A-8B */
+	uint8_t res9[4];	/* 8C-8F */
+	uint8_t iscsi_alias[32];/* 90-AF */
+	uint8_t res9_1[0x16];	/* B0-C5 */
+	uint16_t tgt_portal_grp;/* C6-C7 */
+	uint8_t abort_timer;	/* C8	 */
+	uint8_t ipv4_tcp_wsf;	/* C9	 */
+	uint8_t res10[6];	/* CA-CF */
+	uint8_t ipv4_sec_ip_addr[4];	/* D0-D3 */
+	uint8_t ipv4_dhcp_vid_len;	/* D4 */
+	uint8_t ipv4_dhcp_vid[11];	/* D5-DF */
+	uint8_t res11[20];	/* E0-F3 */
+	uint8_t ipv4_dhcp_alt_cid_len;	/* F4 */
+	uint8_t ipv4_dhcp_alt_cid[11];	/* F5-FF */
+	uint8_t iscsi_name[224];	/* 100-1DF */
+	uint8_t res12[32];	/* 1E0-1FF */
+	uint32_t cookie;	/* 200-203 */
+	uint16_t ipv6_port;	/* 204-205 */
+	uint16_t ipv6_opts;	/* 206-207 */
+	uint16_t ipv6_addtl_opts;	/* 208-209 */
+	uint16_t ipv6_tcp_opts;	/* 20A-20B */
+	uint8_t ipv6_tcp_wsf;	/* 20C */
+	uint16_t ipv6_flow_lbl;	/* 20D-20F */
+	uint8_t ipv6_gw_addr[16];	/* 210-21F */
+	uint16_t ipv6_vlan_tag;	/* 220-221 */
+	uint8_t ipv6_lnk_lcl_addr_state;/* 222 */
+	uint8_t ipv6_addr0_state;	/* 223 */
+	uint8_t ipv6_addr1_state;	/* 224 */
+	uint8_t ipv6_gw_state;	/* 225 */
+	uint8_t ipv6_traffic_class;	/* 226 */
+	uint8_t ipv6_hop_limit;	/* 227 */
+	uint8_t ipv6_if_id[8];	/* 228-22F */
+	uint8_t ipv6_addr0[16];	/* 230-23F */
+	uint8_t ipv6_addr1[16];	/* 240-24F */
+	uint32_t ipv6_nd_reach_time;	/* 250-253 */
+	uint32_t ipv6_nd_rexmit_timer;	/* 254-257 */
+	uint32_t ipv6_nd_stale_timeout;	/* 258-25B */
+	uint8_t ipv6_dup_addr_detect_count;	/* 25C */
+	uint8_t ipv6_cache_id;	/* 25D */
+	uint8_t res13[18];	/* 25E-26F */
+	uint32_t ipv6_gw_advrt_mtu;	/* 270-273 */
+	uint8_t res14[140];	/* 274-2FF */
+};
+
+struct init_fw_ctrl_blk {
+	struct addr_ctrl_blk pri;
+	struct addr_ctrl_blk sec;
 };
 
 /*************************************************************************/
 
 struct dev_db_entry {
-	uint8_t options;	/* 00 */
+	uint16_t options;	/* 00-01 */
 #define DDB_OPT_DISC_SESSION  0x10
 #define DDB_OPT_TARGET	      0x02 /* device is a target */
 
-	uint8_t control;	/* 01 */
-
-	uint16_t exeThrottle;	/* 02-03 */
-	uint16_t exeCount;	/* 04-05 */
-	uint8_t retryCount;	/* 06	 */
-	uint8_t retryDelay;	/* 07	 */
-	uint16_t iSCSIOptions;	/* 08-09 */
-
-	uint16_t TCPOptions;	/* 0A-0B */
-
-	uint16_t IPOptions;	/* 0C-0D */
-
-	uint16_t maxPDUSize;	/* 0E-0F */
-	uint16_t rcvMarkerInt;	/* 10-11 */
-	uint16_t sndMarkerInt;	/* 12-13 */
-	uint16_t iSCSIMaxSndDataSegLen; /* 14-15 */
-	uint16_t firstBurstSize;	/* 16-17 */
-	uint16_t minTime2Wait;	/* 18-19 : RA :default_time2wait */
-	uint16_t maxTime2Retain;	/* 1A-1B */
-	uint16_t maxOutstndngR2T;	/* 1C-1D */
-	uint16_t keepAliveTimeout;	/* 1E-1F */
-	uint8_t ISID[6];	/* 20-25 big-endian, must be converted
+	uint16_t exec_throttle;	/* 02-03 */
+	uint16_t exec_count;	/* 04-05 */
+	uint16_t res0;	/* 06-07 */
+	uint16_t iscsi_options;	/* 08-09 */
+	uint16_t tcp_options;	/* 0A-0B */
+	uint16_t ip_options;	/* 0C-0D */
+	uint16_t iscsi_max_rcv_data_seg_len;	/* 0E-0F */
+	uint32_t res1;	/* 10-13 */
+	uint16_t iscsi_max_snd_data_seg_len;	/* 14-15 */
+	uint16_t iscsi_first_burst_len;	/* 16-17 */
+	uint16_t iscsi_def_time2wait;	/* 18-19 */
+	uint16_t iscsi_def_time2retain;	/* 1A-1B */
+	uint16_t iscsi_max_outsnd_r2t;	/* 1C-1D */
+	uint16_t ka_timeout;	/* 1E-1F */
+	uint8_t isid[6];	/* 20-25 big-endian, must be converted
 				 * to little-endian */
-	uint16_t TSID;		/* 26-27 */
-	uint16_t portNumber;	/* 28-29 */
-	uint16_t maxBurstSize;	/* 2A-2B */
-	uint16_t taskMngmntTimeout;	/* 2C-2D */
-	uint16_t reserved1;	/* 2E-2F */
-	uint8_t ipAddr[0x10];	/* 30-3F */
-	uint8_t iSCSIAlias[0x20];	/* 40-5F */
-	uint8_t targetAddr[0x20];	/* 60-7F */
-	uint8_t userID[0x20];	/* 80-9F */
-	uint8_t password[0x20]; /* A0-BF */
-	uint8_t iscsiName[0x100];	/* C0-1BF : xxzzy Make this a
+	uint16_t tsid;		/* 26-27 */
+	uint16_t port;	/* 28-29 */
+	uint16_t iscsi_max_burst_len;	/* 2A-2B */
+	uint16_t def_timeout;	/* 2C-2D */
+	uint16_t res2;	/* 2E-2F */
+	uint8_t ip_addr[0x10];	/* 30-3F */
+	uint8_t iscsi_alias[0x20];	/* 40-5F */
+	uint8_t tgt_addr[0x20];	/* 60-7F */
+	uint16_t mss;	/* 80-81 */
+	uint16_t res3;	/* 82-83 */
+	uint16_t lcl_port;	/* 84-85 */
+	uint8_t ipv4_tos;	/* 86 */
+	uint16_t ipv6_flow_lbl;	/* 87-89 */
+	uint8_t res4[0x36];	/* 8A-BF */
+	uint8_t iscsi_name[0xE0];	/* C0-19F : xxzzy Make this a
 					 * pointer to a string so we
 					 * don't have to reserve soooo
 					 * much RAM */
-	uint16_t ddbLink;	/* 1C0-1C1 */
-	uint16_t CHAPTableIndex; /* 1C2-1C3 */
-	uint16_t TargetPortalGroup; /* 1C4-1C5 */
-	uint16_t reserved2[2];	/* 1C6-1C7 */
-	uint32_t statSN;	/* 1C8-1CB */
-	uint32_t expStatSN;	/* 1CC-1CF */
-	uint16_t reserved3[0x2C]; /* 1D0-1FB */
-	uint16_t ddbValidCookie; /* 1FC-1FD */
-	uint16_t ddbValidSize;	/* 1FE-1FF */
+	uint8_t ipv6_addr[0x10];/* 1A0-1AF */
+	uint8_t res5[0x10];	/* 1B0-1BF */
+	uint16_t ddb_link;	/* 1C0-1C1 */
+	uint16_t chap_tbl_idx;	/* 1C2-1C3 */
+	uint16_t tgt_portal_grp; /* 1C4-1C5 */
+	uint8_t tcp_xmt_wsf;	/* 1C6 */
+	uint8_t tcp_rcv_wsf;	/* 1C7 */
+	uint32_t stat_sn;	/* 1C8-1CB */
+	uint32_t exp_stat_sn;	/* 1CC-1CF */
+	uint8_t res6[0x30];	/* 1D0-1FF */
 };
 
 /*************************************************************************/

