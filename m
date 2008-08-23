From: jeykholt@cisco.com
Subject: [RFC][PATCH 4/6] fnic: add resource, interrupt,
	and firmware interfaces.
Date: Fri, 22 Aug 2008 19:52:44 -0700
Message-ID: <20080823025244.13569.69272.stgit@feynman.nuovasystems.com>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31910 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbYHWCwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 22:52:51 -0400
In-Reply-To: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jre@nuovasystems.com, ajoglekar@nuovasystems.com

fnic: add resource, interrupt, and firmware interfaces.

fnic_res.[ch]: gets host config, maps PCI resources, allocates descriptor rings.
fnic_isr.c: handles interrupts.  Also contains setup and teardown code.
fcpio.h: defines firmware interfaces

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---
 drivers/scsi/fnic/fcpio.h    |  743 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_isr.c |  345 ++++++++++++++++++++
 drivers/scsi/fnic/fnic_res.c |  367 +++++++++++++++++++++
 drivers/scsi/fnic/fnic_res.h |  199 +++++++++++
 4 files changed, 1654 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/fnic/fcpio.h
 create mode 100644 drivers/scsi/fnic/fnic_isr.c
 create mode 100644 drivers/scsi/fnic/fnic_res.c
 create mode 100644 drivers/scsi/fnic/fnic_res.h


diff --git a/drivers/scsi/fnic/fcpio.h b/drivers/scsi/fnic/fcpio.h
new file mode 100644
index 0000000..3c8ca70
--- /dev/null
+++ b/drivers/scsi/fnic/fcpio.h
@@ -0,0 +1,743 @@
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#ifndef _FCPIO_H_
+#define _FCPIO_H_
+
+#include <linux/if_ether.h>
+
+/*
+ * This header file includes all of the data structures used for
+ * communication by the host driver to the fcp firmware.
+ */
+
+/*
+ * Exchange and sequence id space allocated to the host driver
+ */
+#define FCPIO_HOST_EXCH_RANGE_START         0x1000
+#define FCPIO_HOST_EXCH_RANGE_END           0x1fff
+#define FCPIO_HOST_SEQ_ID_RANGE_START       0x80
+#define FCPIO_HOST_SEQ_ID_RANGE_END         0xff
+
+/*
+ * Command entry type
+ */
+enum fcpio_type {
+	/*
+	 * Initiator request types
+	 */
+	FCPIO_ICMND_16 = 0x1,
+	FCPIO_ICMND_32,
+	FCPIO_ICMND_CMPL,
+	FCPIO_ITMF,
+	FCPIO_ITMF_CMPL,
+
+	/*
+	 * Target request types
+	 */
+	FCPIO_TCMND_16 = 0x11,
+	FCPIO_TCMND_32,
+	FCPIO_TDATA,
+	FCPIO_TXRDY,
+	FCPIO_TRSP,
+	FCPIO_TDRSP_CMPL,
+	FCPIO_TTMF,
+	FCPIO_TTMF_ACK,
+	FCPIO_TABORT,
+	FCPIO_TABORT_CMPL,
+
+	/*
+	 * Misc request types
+	 */
+	FCPIO_ACK = 0x20,
+	FCPIO_RESET,
+	FCPIO_RESET_CMPL,
+	FCPIO_FLOGI_REG,
+	FCPIO_FLOGI_REG_CMPL,
+	FCPIO_ECHO,
+	FCPIO_ECHO_CMPL,
+	FCPIO_LUNMAP_CHNG,
+	FCPIO_LUNMAP_REQ,
+	FCPIO_LUNMAP_REQ_CMPL,
+};
+
+/*
+ * Header status codes from the firmware
+ */
+enum fcpio_status {
+	FCPIO_SUCCESS = 0,              /* request was successful */
+
+	/*
+	 * If a request to the firmware is rejected, the original request
+	 * header will be returned with the status set to one of the following:
+	 */
+	FCPIO_INVALID_HEADER,    /* header contains invalid data */
+	FCPIO_OUT_OF_RESOURCE,   /* out of resources to complete request */
+	FCPIO_INVALID_PARAM,     /* some parameter in request is invalid */
+	FCPIO_REQ_NOT_SUPPORTED, /* request type is not supported */
+	FCPIO_IO_NOT_FOUND,      /* requested I/O was not found */
+
+	/*
+	 * Once a request is processed, the firmware will usually return
+	 * a cmpl message type.  In cases where errors occurred,
+	 * the header status field would be filled in with one of the following:
+	 */
+	FCPIO_ABORTED = 0x41,     /* request was aborted */
+	FCPIO_TIMEOUT,            /* request was timed out */
+	FCPIO_SGL_INVALID,        /* request was aborted due to sgl error */
+	FCPIO_MSS_INVALID,        /* request was aborted due to mss error */
+	FCPIO_DATA_CNT_MISMATCH,  /* recv/sent more/less data than exp. */
+	FCPIO_FW_ERR,             /* request was terminated due to fw error */
+	FCPIO_ITMF_REJECTED,      /* itmf req was rejected by remote node */
+	FCPIO_ITMF_FAILED,        /* itmf req was failed by remote node */
+	FCPIO_ITMF_INCORRECT_LUN, /* itmf req targeted incorrect LUN */
+	FCPIO_CMND_REJECTED,      /* request was invalid and rejected */
+	FCPIO_NO_PATH_AVAIL,      /* no paths to the lun was available */
+	FCPIO_PATH_FAILED,        /* i/o sent to current path failed */
+	FCPIO_LUNMAP_CHNG_PEND,   /* i/o rejected due to lunmap change */
+};
+
+/*
+ * The header command tag.  All host requests will use the "tag" field
+ * to mark commands with a unique tag.  When the firmware responds to
+ * a host request, it will copy the tag field into the response.
+ *
+ * The only firmware requests that will use the rx_id/ox_id fields instead
+ * of the tag field will be the target command and target task management
+ * requests.  These two requests do not have corresponding host requests
+ * since they come directly from the FC initiator on the network.
+ */
+struct fcpio_tag {
+	union {
+		u32 req_id;
+		struct {
+			u16 rx_id;
+			u16 ox_id;
+		} ex_id;
+	} u;
+};
+
+static inline void
+fcpio_tag_id_enc(struct fcpio_tag *tag, u32 id)
+{
+	tag->u.req_id = id;
+}
+
+static inline void
+fcpio_tag_id_dec(struct fcpio_tag *tag, u32 *id)
+{
+	*id = tag->u.req_id;
+}
+
+static inline void
+fcpio_tag_exid_enc(struct fcpio_tag *tag, u16 ox_id, u16 rx_id)
+{
+	tag->u.ex_id.rx_id = rx_id;
+	tag->u.ex_id.ox_id = ox_id;
+}
+
+static inline void
+fcpio_tag_exid_dec(struct fcpio_tag *tag, u16 *ox_id, u16 *rx_id)
+{
+	*rx_id = tag->u.ex_id.rx_id;
+	*ox_id = tag->u.ex_id.ox_id;
+}
+
+/*
+ * The header for an fcpio request, whether from the firmware or from the
+ * host driver
+ */
+struct fcpio_header {
+	u8            type;           /* enum fcpio_type */
+	u8            status;         /* header status entry */
+	u16           _resvd;         /* reserved */
+	struct fcpio_tag    tag;      /* header tag */
+};
+
+static inline void
+fcpio_header_enc(struct fcpio_header *hdr,
+		 u8 type, u8 status,
+		 struct fcpio_tag tag)
+{
+	hdr->type = type;
+	hdr->status = status;
+	hdr->_resvd = 0;
+	hdr->tag = tag;
+}
+
+static inline void
+fcpio_header_dec(struct fcpio_header *hdr,
+		 u8 *type, u8 *status,
+		 struct fcpio_tag *tag)
+{
+	*type = hdr->type;
+	*status = hdr->status;
+	*tag = hdr->tag;
+}
+
+#define CDB_16      16
+#define CDB_32      32
+#define LUN_ADDRESS 8
+
+/*
+ * fcpio_icmnd_16: host -> firmware request
+ *
+ * used for sending out an initiator SCSI 16-byte command
+ */
+struct fcpio_icmnd_16 {
+	u32	  lunmap_id;		/* index into lunmap table */
+	u8	  special_req_flags;	/* special exchange request flags */
+	u8	  _resvd0[3];	        /* reserved */
+	u32	  sgl_cnt;		/* scatter-gather list count */
+	u32	  sense_len;		/* sense buffer length */
+	u64	  sgl_addr;		/* scatter-gather list addr */
+	u64	  sense_addr;		/* sense buffer address */
+	u8	  crn;			/* SCSI Command Reference No. */
+	u8	  pri_ta;		/* SCSI Priority and Task attribute */
+	u8	  _resvd1;		/* reserved: should be 0 */
+	u8	  flags;		/* command flags */
+	u8	  scsi_cdb[CDB_16];	/* SCSI Cmnd Descriptor Block */
+	u32	  data_len;		/* length of data expected */
+	u8	  lun[LUN_ADDRESS];	/* FC vNIC only: LUN address */
+	u8	  _resvd2;		/* reserved */
+	u8	  d_id[3];		/* FC vNIC only: Target D_ID */
+	u16	  mss;			/* FC vNIC only: max burst */
+	u16	  _resvd3;		/* reserved */
+	u32	  r_a_tov;		/* FC vNIC only: Res. Alloc Timeout */
+	u32	  e_d_tov;	        /* FC vNIC only: Err Detect Timeout */
+};
+
+/*
+ * Special request flags
+ */
+#define FCPIO_ICMND_SRFLAG_RETRY 0x01   /* Enable Retry handling on exchange */
+
+/*
+ * Priority/Task Attribute settings
+ */
+#define FCPIO_ICMND_PTA_SIMPLE      0   /* simple task attribute */
+#define FCPIO_ICMND_PTA_HEADQ       1   /* head of queue task attribute */
+#define FCPIO_ICMND_PTA_ORDERED     2   /* ordered task attribute */
+#define FCPIO_ICMND_PTA_ACA         4   /* auto contingent allegiance */
+#define FCPIO_ICMND_PRI_SHIFT       3   /* priority field starts in bit 3 */
+
+/*
+ * Command flags
+ */
+#define FCPIO_ICMND_RDDATA      0x02    /* read data */
+#define FCPIO_ICMND_WRDATA      0x01    /* write data */
+
+/*
+ * fcpio_icmnd_32: host -> firmware request
+ *
+ * used for sending out an initiator SCSI 32-byte command
+ */
+struct fcpio_icmnd_32 {
+	u32   lunmap_id;              /* index into lunmap table */
+	u8    special_req_flags;      /* special exchange request flags */
+	u8    _resvd0[3];             /* reserved */
+	u32   sgl_cnt;                /* scatter-gather list count */
+	u32   sense_len;              /* sense buffer length */
+	u64   sgl_addr;               /* scatter-gather list addr */
+	u64   sense_addr;             /* sense buffer address */
+	u8    crn;                    /* SCSI Command Reference No. */
+	u8    pri_ta;                 /* SCSI Priority and Task attribute */
+	u8    _resvd1;                /* reserved: should be 0 */
+	u8    flags;                  /* command flags */
+	u8    scsi_cdb[CDB_32];       /* SCSI Cmnd Descriptor Block */
+	u32   data_len;               /* length of data expected */
+	u8    lun[LUN_ADDRESS];       /* FC vNIC only: LUN address */
+	u8    _resvd2;                /* reserved */
+	u8    d_id[3];		      /* FC vNIC only: Target D_ID */
+	u16   mss;                    /* FC vNIC only: max burst */
+	u16   _resvd3;                /* reserved */
+	u32   r_a_tov;                /* FC vNIC only: Res. Alloc Timeout */
+	u32   e_d_tov;                /* FC vNIC only: Error Detect Timeout */
+};
+
+/*
+ * fcpio_itmf: host -> firmware request
+ *
+ * used for requesting the firmware to abort a request and/or send out
+ * a task management function
+ *
+ * The t_tag field is only needed when the request type is ABT_TASK.
+ */
+struct fcpio_itmf {
+	u32   lunmap_id;              /* index into lunmap table */
+	u32   tm_req;                 /* SCSI Task Management request */
+	u32   t_tag;                  /* header tag of fcpio to be aborted */
+	u32   _resvd;                 /* _reserved */
+	u8    lun[LUN_ADDRESS];       /* FC vNIC only: LUN address */
+	u8    _resvd1;                /* reserved */
+	u8    d_id[3];		      /* FC vNIC only: Target D_ID */
+	u32   r_a_tov;                /* FC vNIC only: R_A_TOV in msec */
+	u32   e_d_tov;                /* FC vNIC only: E_D_TOV in msec */
+};
+
+/*
+ * Task Management request
+ */
+enum fcpio_itmf_tm_req_type {
+	FCPIO_ITMF_ABT_TASK_TERM = 0x01,    /* abort task and terminate */
+	FCPIO_ITMF_ABT_TASK,                /* abort task and issue abts */
+	FCPIO_ITMF_ABT_TASK_SET,            /* abort task set */
+	FCPIO_ITMF_CLR_TASK_SET,            /* clear task set */
+	FCPIO_ITMF_LUN_RESET,               /* logical unit reset task mgmt */
+	FCPIO_ITMF_CLR_ACA,                 /* Clear ACA condition */
+};
+
+/*
+ * fcpio_tdata: host -> firmware request
+ *
+ * used for requesting the firmware to send out a read data transfer for a
+ * target command
+ */
+struct fcpio_tdata {
+	u16   rx_id;                  /* FC rx_id of target command */
+	u16   flags;                  /* command flags */
+	u32   rel_offset;             /* data sequence relative offset */
+	u32   sgl_cnt;                /* scatter-gather list count */
+	u32   data_len;               /* length of data expected to send */
+	u64   sgl_addr;               /* scatter-gather list address */
+};
+
+/*
+ * Command flags
+ */
+#define FCPIO_TDATA_SCSI_RSP    0x01    /* send a scsi resp. after last frame */
+
+/*
+ * fcpio_txrdy: host -> firmware request
+ *
+ * used for requesting the firmware to send out a write data transfer for a
+ * target command
+ */
+struct fcpio_txrdy {
+	u16   rx_id;                  /* FC rx_id of target command */
+	u16   _resvd0;                /* reserved */
+	u32   rel_offset;             /* data sequence relative offset */
+	u32   sgl_cnt;                /* scatter-gather list count */
+	u32   data_len;               /* length of data expected to send */
+	u64   sgl_addr;               /* scatter-gather list address */
+};
+
+/*
+ * fcpio_trsp: host -> firmware request
+ *
+ * used for requesting the firmware to send out a response for a target
+ * command
+ */
+struct fcpio_trsp {
+	u16   rx_id;                  /* FC rx_id of target command */
+	u16   _resvd0;                /* reserved */
+	u32   sense_len;              /* sense data buffer length */
+	u64   sense_addr;             /* sense data buffer address */
+	u16   _resvd1;                /* reserved */
+	u8    flags;                  /* response request flags */
+	u8    scsi_status;            /* SCSI status */
+	u32   residual;               /* SCSI data residual value of I/O */
+};
+
+/*
+ * resposnse request flags
+ */
+#define FCPIO_TRSP_RESID_UNDER  0x08   /* residual is valid and is underflow */
+#define FCPIO_TRSP_RESID_OVER   0x04   /* residual is valid and is overflow */
+
+/*
+ * fcpio_ttmf_ack: host -> firmware response
+ *
+ * used by the host to indicate to the firmware it has received and processed
+ * the target tmf request
+ */
+struct fcpio_ttmf_ack {
+	u16   rx_id;                  /* FC rx_id of target command */
+	u16   _resvd0;                /* reserved */
+	u32   tmf_status;             /* SCSI task management status */
+};
+
+/*
+ * fcpio_tabort: host -> firmware request
+ *
+ * used by the host to request the firmware to abort a target request that was
+ * received by the firmware
+ */
+struct fcpio_tabort {
+	u16   rx_id;                  /* rx_id of the target request */
+};
+
+/*
+ * fcpio_reset: host -> firmware request
+ *
+ * used by the host to signal a reset of the driver to the firmware
+ * and to request firmware to clean up all outstanding I/O
+ */
+struct fcpio_reset {
+	u32   _resvd;
+};
+
+/*
+ * fcpio_flogi_reg: host -> firmware request
+ *
+ * fc vnic only
+ * used by the host to notify the firmware of the lif's s_id
+ * and destination mac address format
+ */
+struct fcpio_flogi_reg {
+	u8 resvd;
+	u8 s_id[3];			/* FC vNIC only: Source S_ID */
+	u8 fcf_mac[ETH_ALEN];		/* FCF Target destination gateway mac */
+	u8 ha_mac[ETH_ALEN];		/* Host adapter source mac */
+	u32 r_a_tov;			/* R_A_TOV in msec */
+	u32 e_d_tov;			/* E_D_TOV in msec */
+};
+
+/*
+ * fcpio_echo: host -> firmware request
+ *
+ * sends a heartbeat echo request to the firmware
+ */
+struct fcpio_echo {
+	u32 _resvd;
+};
+
+/*
+ * fcpio_lunmap_req: host -> firmware request
+ *
+ * scsi vnic only
+ * sends a request to retrieve the lunmap table for scsi vnics
+ */
+struct fcpio_lunmap_req {
+	u64 addr;                     /* address of the buffer */
+	u32 len;                      /* len of the buffer */
+};
+
+/*
+ * Basic structure for all fcpio structures that are sent from the host to the
+ * firmware.  They are 128 bytes per structure.
+ */
+#define FCPIO_HOST_REQ_LEN      128     /* expected length of host requests */
+
+struct fcpio_host_req {
+	struct fcpio_header hdr;
+
+	union {
+		/*
+		 * Defines space needed for request
+		 */
+		u8 buf[FCPIO_HOST_REQ_LEN - sizeof(struct fcpio_header)];
+
+		/*
+		 * Initiator host requests
+		 */
+		struct fcpio_icmnd_16               icmnd_16;
+		struct fcpio_icmnd_32               icmnd_32;
+		struct fcpio_itmf                   itmf;
+
+		/*
+		 * Target host requests
+		 */
+		struct fcpio_tdata                  tdata;
+		struct fcpio_txrdy                  txrdy;
+		struct fcpio_trsp                   trsp;
+		struct fcpio_ttmf_ack               ttmf_ack;
+		struct fcpio_tabort                 tabort;
+
+		/*
+		 * Misc requests
+		 */
+		struct fcpio_reset                  reset;
+		struct fcpio_flogi_reg              flogi_reg;
+		struct fcpio_echo                   echo;
+		struct fcpio_lunmap_req             lunmap_req;
+	} u;
+};
+
+/*
+ * fcpio_icmnd_cmpl: firmware -> host response
+ *
+ * used for sending the host a response to an initiator command
+ */
+struct fcpio_icmnd_cmpl {
+	u8    _resvd0[6];             /* reserved */
+	u8    flags;                  /* response flags */
+	u8    scsi_status;            /* SCSI status */
+	u32   residual;               /* SCSI data residual length */
+	u32   sense_len;              /* SCSI sense length */
+};
+
+/*
+ * response flags
+ */
+#define FCPIO_ICMND_CMPL_RESID_UNDER    0x08    /* resid under and valid */
+#define FCPIO_ICMND_CMPL_RESID_OVER     0x04    /* resid over and valid */
+
+/*
+ * fcpio_itmf_cmpl: firmware -> host response
+ *
+ * used for sending the host a response for a itmf request
+ */
+struct fcpio_itmf_cmpl {
+	u32    _resvd;                /* reserved */
+};
+
+/*
+ * fcpio_tcmnd_16: firmware -> host request
+ *
+ * used by the firmware to notify the host of an incoming target SCSI 16-Byte
+ * request
+ */
+struct fcpio_tcmnd_16 {
+	u8    lun[LUN_ADDRESS];       /* FC vNIC only: LUN address */
+	u8    crn;                    /* SCSI Command Reference No. */
+	u8    pri_ta;                 /* SCSI Priority and Task attribute */
+	u8    _resvd2;                /* reserved: should be 0 */
+	u8    flags;                  /* command flags */
+	u8    scsi_cdb[CDB_16];       /* SCSI Cmnd Descriptor Block */
+	u32   data_len;               /* length of data expected */
+	u8    _resvd1;                /* reserved */
+	u8    d_id[3];		      /* FC vNIC only: Target D_ID */
+};
+
+/*
+ * Priority/Task Attribute settings
+ */
+#define FCPIO_TCMND_PTA_SIMPLE      0   /* simple task attribute */
+#define FCPIO_TCMND_PTA_HEADQ       1   /* head of queue task attribute */
+#define FCPIO_TCMND_PTA_ORDERED     2   /* ordered task attribute */
+#define FCPIO_TCMND_PTA_ACA         4   /* auto contingent allegiance */
+#define FCPIO_TCMND_PRI_SHIFT       3   /* priority field starts in bit 3 */
+
+/*
+ * Command flags
+ */
+#define FCPIO_TCMND_RDDATA      0x02    /* read data */
+#define FCPIO_TCMND_WRDATA      0x01    /* write data */
+
+/*
+ * fcpio_tcmnd_32: firmware -> host request
+ *
+ * used by the firmware to notify the host of an incoming target SCSI 32-Byte
+ * request
+ */
+struct fcpio_tcmnd_32 {
+	u8    lun[LUN_ADDRESS];       /* FC vNIC only: LUN address */
+	u8    crn;                    /* SCSI Command Reference No. */
+	u8    pri_ta;                 /* SCSI Priority and Task attribute */
+	u8    _resvd2;                /* reserved: should be 0 */
+	u8    flags;                  /* command flags */
+	u8    scsi_cdb[CDB_32];       /* SCSI Cmnd Descriptor Block */
+	u32   data_len;               /* length of data expected */
+	u8    _resvd0;                /* reserved */
+	u8    s_id[3];		      /* FC vNIC only: Source S_ID */
+};
+
+/*
+ * fcpio_tdrsp_cmpl: firmware -> host response
+ *
+ * used by the firmware to notify the host of a response to a host target
+ * command
+ */
+struct fcpio_tdrsp_cmpl {
+	u16   rx_id;                  /* rx_id of the target request */
+	u16   _resvd0;                /* reserved */
+};
+
+/*
+ * fcpio_ttmf: firmware -> host request
+ *
+ * used by the firmware to notify the host of an incoming task management
+ * function request
+ */
+struct fcpio_ttmf {
+	u8    _resvd0;                /* reserved */
+	u8    s_id[3];		      /* FC vNIC only: Source S_ID */
+	u8    lun[LUN_ADDRESS];       /* FC vNIC only: LUN address */
+	u8    crn;                    /* SCSI Command Reference No. */
+	u8    _resvd2[3];             /* reserved */
+	u32   tmf_type;               /* task management request type */
+};
+
+/*
+ * Task Management request
+ */
+#define FCPIO_TTMF_CLR_ACA      0x40    /* Clear ACA condition */
+#define FCPIO_TTMF_LUN_RESET    0x10    /* logical unit reset task mgmt */
+#define FCPIO_TTMF_CLR_TASK_SET 0x04    /* clear task set */
+#define FCPIO_TTMF_ABT_TASK_SET 0x02    /* abort task set */
+#define FCPIO_TTMF_ABT_TASK     0x01    /* abort task */
+
+/*
+ * fcpio_tabort_cmpl: firmware -> host response
+ *
+ * used by the firmware to respond to a host's tabort request
+ */
+struct fcpio_tabort_cmpl {
+	u16   rx_id;                  /* rx_id of the target request */
+	u16   _resvd0;                /* reserved */
+};
+
+/*
+ * fcpio_ack: firmware -> host response
+ *
+ * used by firmware to notify the host of the last work request received
+ */
+struct fcpio_ack {
+	u16  request_out;             /* last host entry received */
+	u16  _resvd;
+};
+
+/*
+ * fcpio_reset_cmpl: firmware -> host response
+ *
+ * use by firmware to respond to the host's reset request
+ */
+struct fcpio_reset_cmpl {
+	u16   vnic_id;
+};
+
+/*
+ * fcpio_flogi_reg_cmpl: firmware -> host response
+ *
+ * fc vnic only
+ * response to the fcpio_flogi_reg request
+ */
+struct fcpio_flogi_reg_cmpl {
+	u32 _resvd;
+};
+
+/*
+ * fcpio_echo_cmpl: firmware -> host response
+ *
+ * response to the fcpio_echo request
+ */
+struct fcpio_echo_cmpl {
+	u32 _resvd;
+};
+
+/*
+ * fcpio_lunmap_chng: firmware -> host notification
+ *
+ * scsi vnic only
+ * notifies the host that the lunmap tables have changed
+ */
+struct fcpio_lunmap_chng {
+	u32 _resvd;
+};
+
+/*
+ * fcpio_lunmap_req_cmpl: firmware -> host response
+ *
+ * scsi vnic only
+ * response for lunmap table request from the host
+ */
+struct fcpio_lunmap_req_cmpl {
+	u32 _resvd;
+};
+
+/*
+ * Basic structure for all fcpio structures that are sent from the firmware to
+ * the host.  They are 64 bytes per structure.
+ */
+#define FCPIO_FW_REQ_LEN        64      /* expected length of fw requests */
+struct fcpio_fw_req {
+	struct fcpio_header hdr;
+
+	union {
+		/*
+		 * Defines space needed for request
+		 */
+		u8 buf[FCPIO_FW_REQ_LEN - sizeof(struct fcpio_header)];
+
+		/*
+		 * Initiator firmware responses
+		 */
+		struct fcpio_icmnd_cmpl         icmnd_cmpl;
+		struct fcpio_itmf_cmpl          itmf_cmpl;
+
+		/*
+		 * Target firmware new requests
+		 */
+		struct fcpio_tcmnd_16           tcmnd_16;
+		struct fcpio_tcmnd_32           tcmnd_32;
+
+		/*
+		 * Target firmware responses
+		 */
+		struct fcpio_tdrsp_cmpl         tdrsp_cmpl;
+		struct fcpio_ttmf               ttmf;
+		struct fcpio_tabort_cmpl        tabort_cmpl;
+
+		/*
+		 * Firmware response to work received
+		 */
+		struct fcpio_ack                ack;
+
+		/*
+		 * Misc requests
+		 */
+		struct fcpio_reset_cmpl         reset_cmpl;
+		struct fcpio_flogi_reg_cmpl     flogi_reg_cmpl;
+		struct fcpio_echo_cmpl          echo_cmpl;
+		struct fcpio_lunmap_chng        lunmap_chng;
+		struct fcpio_lunmap_req_cmpl    lunmap_req_cmpl;
+	} u;
+};
+
+/*
+ * Access routines to encode and decode the color bit, which is the most
+ * significant bit of the MSB of the structure
+ */
+static inline void fcpio_color_enc(struct fcpio_fw_req *fw_req, u8 color)
+{
+	u8 *c = ((u8 *) fw_req) + sizeof(struct fcpio_fw_req) - 1;
+
+	if (color)
+		*c |= 0x80;
+	else
+		*c &= ~0x80;
+}
+
+static inline void fcpio_color_dec(struct fcpio_fw_req *fw_req, u8 *color)
+{
+	u8 *c = ((u8 *) fw_req) + sizeof(struct fcpio_fw_req) - 1;
+
+	*color = *c >> 7;
+}
+
+/*
+ * Lunmap table entry for scsi vnics
+ */
+#define FCPIO_LUNMAP_TABLE_SIZE     256
+#define FCPIO_FLAGS_LUNMAP_VALID    0x80
+#define FCPIO_FLAGS_BOOT            0x01
+struct fcpio_lunmap_entry {
+	u8    bus;
+	u8    target;
+	u8    lun;
+	u8    path_cnt;
+	u16   flags;
+	u16   update_cnt;
+};
+
+struct fcpio_lunmap_tbl {
+	u32                   update_cnt;
+	struct fcpio_lunmap_entry   lunmaps[FCPIO_LUNMAP_TABLE_SIZE];
+};
+
+#endif /* _FCPIO_H_ */
diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
new file mode 100644
index 0000000..814a1d7
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -0,0 +1,345 @@
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/skbuff.h>
+#include <linux/mempool.h>
+#include <linux/interrupt.h>
+#include <scsi/libfc/libfc.h>
+#include <scsi/libfc/fc_frame.h>
+#include "vnic_dev.h"
+#include "vnic_intr.h"
+#include "vnic_stats.h"
+#include "fnic_io.h"
+#include "fnic.h"
+
+static irqreturn_t fnic_isr_legacy(int irq, void *data)
+{
+	struct fnic *fnic = (struct fnic *)data;
+	u32 pba;
+	unsigned long  work_done = 0;
+	int i;
+
+	/* mask all interrupts*/
+	for (i = 0; i < fnic->intr_count; i++)
+		vnic_intr_mask(&fnic->intr[i]);
+
+	pba = vnic_intr_legacy_pba(fnic->legacy_pba);
+	if (!pba) {
+		for (i = 0; i < fnic->intr_count; i++)
+			vnic_intr_unmask(&fnic->intr[i]);
+		return IRQ_NONE;	/* not our interrupt */
+	}
+
+	/* Check for notify */
+	if (pba & (1 << FNIC_INTX_NOTIFY))
+		fnic_notify_check(fnic);
+
+	/* Check for errors */
+	if (pba & (1 << FNIC_INTX_ERR))
+		fnic_log_q_error(fnic);
+
+	/* Check for data */
+	if (pba & (1 << FNIC_INTX_WQ_RQ_COPYWQ)) {
+		work_done += fnic_wq_copy_cmpl_handler(fnic, 8);
+		work_done += fnic_wq_cmpl_handler(fnic, 4);
+		work_done += fnic_rq_cmpl_handler(fnic, 4);
+	}
+
+	/*Now return the credit debt to HW.*/
+	vnic_intr_return_credits(&fnic->intr[FNIC_INTX_WQ_RQ_COPYWQ],
+				 work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+
+	/* unmask notification and error interrupts */
+	vnic_intr_unmask(&fnic->intr[FNIC_INTX_NOTIFY]);
+	vnic_intr_unmask(&fnic->intr[FNIC_INTX_ERR]);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fnic_isr_msi(int irq, void *data)
+{
+	struct fnic *fnic = (struct fnic *)data;
+	unsigned long  work_done = 0;
+
+	/* handle FCS frames and IOs */
+	work_done += fnic_wq_copy_cmpl_handler(fnic, 8);
+	work_done += fnic_wq_cmpl_handler(fnic, 4);
+	work_done += fnic_rq_cmpl_handler(fnic, 4);
+
+	/*Now return the credit debt to HW.*/
+	vnic_intr_return_credits(&fnic->intr[0],
+				 work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fnic_isr_msix_rq(int irq, void *data)
+{
+	struct fnic *fnic = (struct fnic *)data;
+	unsigned long  rq_work_done = 0;
+
+	rq_work_done = fnic_rq_cmpl_handler(fnic, 4);
+	vnic_intr_return_credits(&fnic->intr[FNIC_MSIX_RQ],
+				 rq_work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fnic_isr_msix_wq(int irq, void *data)
+{
+	struct fnic *fnic = (struct fnic *)data;
+	unsigned long  wq_work_done = 0;
+
+	wq_work_done = fnic_wq_cmpl_handler(fnic, 4);
+	vnic_intr_return_credits(&fnic->intr[FNIC_MSIX_WQ],
+				 wq_work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fnic_isr_msix_wq_copy(int irq, void *data)
+{
+	struct fnic *fnic = (struct fnic *)data;
+	unsigned long  wq_copy_work_done = 0;
+
+	wq_copy_work_done = fnic_wq_copy_cmpl_handler(fnic, 8);
+	vnic_intr_return_credits(&fnic->intr[FNIC_MSIX_WQ_COPY],
+				 wq_copy_work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fnic_isr_msix_err_notify(int irq, void *data)
+{
+	struct fnic *fnic = (struct fnic *)data;
+
+	fnic_log_q_error(fnic);
+	fnic_notify_check(fnic);
+	vnic_intr_unmask(&fnic->intr[FNIC_MSIX_ERR_NOTIFY]);
+
+	return IRQ_HANDLED;
+}
+
+void fnic_free_intr(struct fnic *fnic)
+{
+	int i;
+	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
+	case VNIC_DEV_INTR_MODE_INTX:
+	case VNIC_DEV_INTR_MODE_MSI:
+		free_irq(fnic->pdev->irq, fnic);
+		break;
+
+	case VNIC_DEV_INTR_MODE_MSIX:
+		for (i = 0; i < ARRAY_SIZE(fnic->msix); i++)
+			if (fnic->msix[i].requested)
+				free_irq(fnic->msix_entry[i].vector,
+					 fnic->msix[i].devid);
+		break;
+
+	default:
+		break;
+	}
+}
+
+int fnic_request_intr(struct fnic *fnic)
+{
+	int err = 0;
+	int i;
+
+	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
+
+	case VNIC_DEV_INTR_MODE_INTX:
+		err = request_irq(fnic->pdev->irq, &fnic_isr_legacy,
+				  IRQF_SHARED, DRV_NAME, fnic);
+		break;
+
+	case VNIC_DEV_INTR_MODE_MSI:
+		err = request_irq(fnic->pdev->irq, &fnic_isr_msi,
+				  0, fnic->lport->ifname, fnic);
+		break;
+
+	case VNIC_DEV_INTR_MODE_MSIX:
+
+		sprintf(fnic->msix[FNIC_MSIX_RQ].devname,
+			"%.11s-fcs-rq", fnic->lport->ifname);
+		fnic->msix[FNIC_MSIX_RQ].isr = fnic_isr_msix_rq;
+		fnic->msix[FNIC_MSIX_RQ].devid = fnic;
+
+		sprintf(fnic->msix[FNIC_MSIX_WQ].devname,
+			"%.11s-fcs-wq", fnic->lport->ifname);
+		fnic->msix[FNIC_MSIX_WQ].isr = fnic_isr_msix_wq;
+		fnic->msix[FNIC_MSIX_WQ].devid = fnic;
+
+		sprintf(fnic->msix[FNIC_MSIX_WQ_COPY].devname,
+			"%.11s-scsi-wq", fnic->lport->ifname);
+		fnic->msix[FNIC_MSIX_WQ_COPY].isr = fnic_isr_msix_wq_copy;
+		fnic->msix[FNIC_MSIX_WQ_COPY].devid = fnic;
+
+		sprintf(fnic->msix[FNIC_MSIX_ERR_NOTIFY].devname,
+			"%.11s-err-notify", fnic->lport->ifname);
+		fnic->msix[FNIC_MSIX_ERR_NOTIFY].isr =
+			fnic_isr_msix_err_notify;
+		fnic->msix[FNIC_MSIX_ERR_NOTIFY].devid = fnic;
+
+		for (i = 0; i < ARRAY_SIZE(fnic->msix); i++) {
+			err = request_irq(fnic->msix_entry[i].vector,
+					  fnic->msix[i].isr, 0,
+					  fnic->msix[i].devname,
+					  fnic->msix[i].devid);
+			if (err) {
+				printk(KERN_ERR PFX "MSIX: request_irq"
+				       " failed %d\n", err);
+				fnic_free_intr(fnic);
+				break;
+			}
+			fnic->msix[i].requested = 1;
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	return err;
+}
+
+int fnic_set_intr_mode(struct fnic *fnic)
+{
+	unsigned int n = ARRAY_SIZE(fnic->rq);
+	unsigned int m = ARRAY_SIZE(fnic->wq);
+	unsigned int o = ARRAY_SIZE(fnic->wq_copy);
+	unsigned int i;
+
+	/* Set interrupt mode (INTx, MSI, MSI-X) depending
+	 * system capabilities.
+	 *
+	 * Try MSI-X first
+	 *
+	 * We need n RQs, m WQs, o Copy WQs, n+m+o CQs, and n+m+o+1 INTRs
+	 * (last INTR is used for WQ/RQ errors and notification area)
+	 */
+
+	BUG_ON(ARRAY_SIZE(fnic->msix_entry) < n + m + o + 1);
+	for (i = 0; i < n + m + o + 1; i++)
+		fnic->msix_entry[i].entry = i;
+
+	if (fnic->rq_count >= n &&
+	    fnic->raw_wq_count >= m &&
+	    fnic->wq_copy_count >= o &&
+	    fnic->cq_count >= n + m + o) {
+		if (!pci_enable_msix(fnic->pdev, fnic->msix_entry,
+				    n + m + o + 1)) {
+			fnic->rq_count = n;
+			fnic->raw_wq_count = m;
+			fnic->wq_copy_count = o;
+			fnic->wq_count = m + o;
+			fnic->cq_count = n + m + o;
+			fnic->intr_count = n + m + o + 1;
+			fnic->err_intr_offset = FNIC_MSIX_ERR_NOTIFY;
+
+			printk(KERN_DEBUG PFX "Using MSI-X Interrupts\n");
+			vnic_dev_set_intr_mode(fnic->vdev,
+					       VNIC_DEV_INTR_MODE_MSIX);
+			return 0;
+		}
+	}
+
+	/* Next try MSI
+	 *
+	 * We need 1 RQ, 1 WQ, 1 WQ_COPY, 3 CQs, and 1 INTR
+	 */
+	if (fnic->rq_count >= 1 &&
+	    fnic->raw_wq_count >= 1 &&
+	    fnic->wq_copy_count >= 1 &&
+	    fnic->cq_count >= 3 &&
+	    fnic->intr_count >= 1 &&
+	    !pci_enable_msi(fnic->pdev)) {
+
+		fnic->rq_count = 1;
+		fnic->raw_wq_count = 1;
+		fnic->wq_copy_count = 1;
+		fnic->wq_count = 2;
+		fnic->cq_count = 3;
+		fnic->intr_count = 1;
+		fnic->err_intr_offset = 0;
+
+		printk(KERN_DEBUG PFX "Using MSI Interrupts\n");
+		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_MSI);
+
+		return 0;
+	}
+
+	/* Next try INTx
+	 *
+	 * We need 1 RQ, 1 WQ, 1 WQ_COPY, 3 CQs, and 3 INTRs
+	 * 1 INTR is used for all 3 queues, 1 INTR for queue errors
+	 * 1 INTR for notification area
+	 */
+
+	if (fnic->rq_count >= 1 &&
+	    fnic->raw_wq_count >= 1 &&
+	    fnic->wq_copy_count >= 1 &&
+	    fnic->cq_count >= 3 &&
+	    fnic->intr_count >= 3) {
+
+		fnic->rq_count = 1;
+		fnic->raw_wq_count = 1;
+		fnic->wq_copy_count = 1;
+		fnic->cq_count = 3;
+		fnic->intr_count = 3;
+
+		printk(KERN_DEBUG PFX "Using Legacy Interrupts\n");
+		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_INTX);
+
+		return 0;
+	}
+
+	vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_UNKNOWN);
+
+	return -EINVAL;
+}
+
+void fnic_clear_intr_mode(struct fnic *fnic)
+{
+	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
+	case VNIC_DEV_INTR_MODE_MSIX:
+		pci_disable_msix(fnic->pdev);
+		break;
+	case VNIC_DEV_INTR_MODE_MSI:
+		pci_disable_msi(fnic->pdev);
+		break;
+	default:
+		break;
+	}
+
+	vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_INTX);
+}
+
diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
new file mode 100644
index 0000000..b557f14
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_res.c
@@ -0,0 +1,367 @@
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include "wq_enet_desc.h"
+#include "rq_enet_desc.h"
+#include "cq_enet_desc.h"
+#include "vnic_resource.h"
+#include "vnic_dev.h"
+#include "vnic_wq.h"
+#include "vnic_rq.h"
+#include "vnic_cq.h"
+#include "vnic_intr.h"
+#include "vnic_stats.h"
+#include "vnic_nic.h"
+#include "fnic.h"
+
+int fnic_get_vnic_config(struct fnic *fnic)
+{
+	struct vnic_fc_config *c = &fnic->config;
+	int err;
+
+#define GET_CONFIG(m) \
+	do { \
+		err = vnic_dev_spec(fnic->vdev, \
+				    offsetof(struct vnic_fc_config, m), \
+				    sizeof(c->m), &c->m); \
+		if (err) { \
+			printk(KERN_ERR PFX "Error getting %s, %d\n", #m, \
+			       err); \
+			return err; \
+		} \
+	} while (0);
+
+	GET_CONFIG(node_wwn);
+	GET_CONFIG(port_wwn);
+	GET_CONFIG(wq_enet_desc_count);
+	GET_CONFIG(wq_copy_desc_count);
+	GET_CONFIG(rq_desc_count);
+	GET_CONFIG(maxdatafieldsize);
+	GET_CONFIG(ed_tov);
+	GET_CONFIG(ra_tov);
+	GET_CONFIG(intr_timer);
+	GET_CONFIG(intr_timer_type);
+
+	c->wq_enet_desc_count =
+		min_t(u32, VNIC_FNIC_MAX_WQ_DESCS,
+		max_t(u32, VNIC_FNIC_MIN_WQ_DESCS,
+		c->wq_enet_desc_count));
+	c->wq_enet_desc_count = ALIGN(c->wq_enet_desc_count, 16);
+
+	c->wq_copy_desc_count =
+		min_t(u32, VNIC_FNIC_MAX_WQ_COPY_DESCS,
+		max_t(u32, VNIC_FNIC_MIN_WQ_COPY_DESCS,
+		c->wq_copy_desc_count));
+	c->wq_copy_desc_count = ALIGN(c->wq_copy_desc_count, 16);
+
+	c->rq_desc_count =
+		min_t(u32, VNIC_FNIC_MAX_RQ_DESCS,
+		max_t(u32, VNIC_FNIC_MIN_RQ_DESCS,
+		c->rq_desc_count));
+	c->rq_desc_count = ALIGN(c->rq_desc_count, 16);
+
+	c->maxdatafieldsize =
+		min_t(u16, VNIC_FNIC_MAX_MTU,
+		max_t(u16, VNIC_FNIC_MIN_MTU,
+		c->maxdatafieldsize));
+
+	if (!c->ed_tov)
+		c->ed_tov = 2000;
+
+	if (!c->ra_tov)
+		c->ra_tov = 10000;
+
+	c->intr_timer = min_t(u16, VNIC_INTR_TIMER_MAX, c->intr_timer);
+	c->intr_timer_type = c->intr_timer_type;
+
+	printk(KERN_INFO PFX "vNIC MAC addr %02x:%02x:%02x:%02x:%02x:%02x "
+		"wq/wq_copy/rq %d/%d/%d\n",
+		fnic->mac_addr[0], fnic->mac_addr[1], fnic->mac_addr[2],
+		fnic->mac_addr[3], fnic->mac_addr[4], fnic->mac_addr[5],
+		c->wq_enet_desc_count, c->wq_copy_desc_count, c->rq_desc_count);
+	printk(KERN_INFO PFX "vNIC node wwn %llx port wwn %llx\n",
+		c->node_wwn, c->port_wwn);
+	printk(KERN_INFO PFX "vNIC ed_tov %d ra_tov %d\n",
+		c->ed_tov, c->ra_tov);
+	printk(KERN_INFO PFX "vNIC mtu %d intr timer %d\n",
+		c->maxdatafieldsize, c->intr_timer);
+
+	return 0;
+}
+
+int fnic_set_nic_cfg(struct fnic *fnic, u8 rss_default_cpu, u8 rss_hash_type,
+	u8 rss_hash_bits, u8 rss_base_cpu, u8 rss_enable, u8 tso_ipid_split_en,
+	u8 ig_vlan_strip_en)
+{
+	u64 a0, a1;
+	u32 nic_cfg;
+	int wait = 1000;
+
+	vnic_set_nic_cfg(&nic_cfg, rss_default_cpu,
+		rss_hash_type, rss_hash_bits, rss_base_cpu,
+		rss_enable, tso_ipid_split_en, ig_vlan_strip_en);
+
+	a0 = nic_cfg;
+	a1 = 0;
+
+	return vnic_dev_cmd(fnic->vdev, CMD_NIC_CFG, &a0, &a1, wait);
+}
+
+void fnic_get_res_counts(struct fnic *fnic)
+{
+	fnic->wq_count = vnic_dev_get_res_count(fnic->vdev, RES_TYPE_WQ);
+	fnic->raw_wq_count = fnic->wq_count - 1;
+	fnic->wq_copy_count = fnic->wq_count - fnic->raw_wq_count;
+	fnic->rq_count = vnic_dev_get_res_count(fnic->vdev, RES_TYPE_RQ);
+	fnic->cq_count = vnic_dev_get_res_count(fnic->vdev, RES_TYPE_CQ);
+	fnic->intr_count = vnic_dev_get_res_count(fnic->vdev,
+		RES_TYPE_INTR_CTRL);
+}
+
+void fnic_free_vnic_resources(struct fnic *fnic)
+{
+	unsigned int i;
+
+	for (i = 0; i < fnic->raw_wq_count; i++)
+		vnic_wq_free(&fnic->wq[i]);
+
+	for (i = 0; i < fnic->wq_copy_count; i++)
+		vnic_wq_copy_free(&fnic->wq_copy[i]);
+
+	for (i = 0; i < fnic->rq_count; i++)
+		vnic_rq_free(&fnic->rq[i]);
+
+	for (i = 0; i < fnic->cq_count; i++)
+		vnic_cq_free(&fnic->cq[i]);
+
+	for (i = 0; i < fnic->intr_count; i++)
+		vnic_intr_free(&fnic->intr[i]);
+}
+
+int fnic_alloc_vnic_resources(struct fnic *fnic)
+{
+	enum vnic_dev_intr_mode intr_mode;
+	unsigned int mask_on_assertion;
+	unsigned int interrupt_offset;
+	unsigned int error_interrupt_enable;
+	unsigned int error_interrupt_offset;
+	unsigned int i, cq_index;
+	unsigned int wq_copy_cq_desc_count;
+	int err;
+
+	intr_mode = vnic_dev_get_intr_mode(fnic->vdev);
+
+	printk(KERN_INFO PFX "vNIC interrupt mode: %s\n",
+		intr_mode == VNIC_DEV_INTR_MODE_INTX ? "legacy PCI INTx" :
+		intr_mode == VNIC_DEV_INTR_MODE_MSI ? "MSI" :
+		intr_mode == VNIC_DEV_INTR_MODE_MSIX ? "MSI-X" : "unknown");
+
+	printk(KERN_INFO PFX "vNIC resources avail: "
+	       "wq %d cp_wq %d raw_wq %d rq %d cq %d intr %d\n",
+	       fnic->wq_count, fnic->wq_copy_count, fnic->raw_wq_count,
+	       fnic->rq_count, fnic->cq_count, fnic->intr_count);
+
+	/* Allocate Raw WQ used for FCS frames */
+	for (i = 0; i < fnic->raw_wq_count; i++) {
+		err = vnic_wq_alloc(fnic->vdev, &fnic->wq[i], i,
+			fnic->config.wq_enet_desc_count,
+			sizeof(struct wq_enet_desc));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	/* Allocate Copy WQs used for SCSI IOs */
+	for (i = 0; i < fnic->wq_copy_count; i++) {
+		err = vnic_wq_copy_alloc(fnic->vdev, &fnic->wq_copy[i],
+			(fnic->raw_wq_count + i),
+			fnic->config.wq_copy_desc_count,
+			sizeof(struct fcpio_host_req));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	/* RQ for receiving FCS frames */
+	for (i = 0; i < fnic->rq_count; i++) {
+		err = vnic_rq_alloc(fnic->vdev, &fnic->rq[i], i,
+			fnic->config.rq_desc_count,
+			sizeof(struct rq_enet_desc));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	/* CQ for each RQ */
+	for (i = 0; i < fnic->rq_count; i++) {
+		cq_index = i;
+		err = vnic_cq_alloc(fnic->vdev,
+			&fnic->cq[cq_index], cq_index,
+			fnic->config.rq_desc_count,
+			sizeof(struct cq_enet_rq_desc));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	/* CQ for each WQ */
+	for (i = 0; i < fnic->raw_wq_count; i++) {
+		cq_index = fnic->rq_count + i;
+		err = vnic_cq_alloc(fnic->vdev, &fnic->cq[cq_index], cq_index,
+			fnic->config.wq_enet_desc_count,
+			sizeof(struct cq_enet_wq_desc));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	/* CQ for each COPY WQ */
+	wq_copy_cq_desc_count = (fnic->config.wq_copy_desc_count * 3);
+	for (i = 0; i < fnic->wq_copy_count; i++) {
+		cq_index = fnic->raw_wq_count + fnic->rq_count + i;
+		err = vnic_cq_alloc(fnic->vdev, &fnic->cq[cq_index],
+			cq_index,
+			wq_copy_cq_desc_count,
+			sizeof(struct fcpio_fw_req));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	for (i = 0; i < fnic->intr_count; i++) {
+		err = vnic_intr_alloc(fnic->vdev, &fnic->intr[i], i);
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	fnic->legacy_pba = vnic_dev_get_res(fnic->vdev,
+				RES_TYPE_INTR_PBA_LEGACY, 0);
+
+	if (!fnic->legacy_pba && intr_mode == VNIC_DEV_INTR_MODE_INTX) {
+		printk(KERN_ERR "Failed to hook legacy pba resource\n");
+		err = -ENODEV;
+		goto err_out_cleanup;
+	}
+
+	/* Init RQ/WQ resources.
+	 *
+	 * RQ[0 to n-1] point to CQ[0 to n-1]
+	 * WQ[0 to m-1] point to CQ[n to n+m-1]
+	 * WQ_COPY[0 to k-1] points to CQ[n+m to n+m+k-1]
+	 *
+	 * Note for copy wq we always initialize with cq_index = 0
+	 *
+	 * Error interrupt is not enabled for MSI.
+	 */
+
+	switch (intr_mode) {
+	case VNIC_DEV_INTR_MODE_INTX:
+	case VNIC_DEV_INTR_MODE_MSIX:
+		error_interrupt_enable = 1;
+		error_interrupt_offset = fnic->err_intr_offset;
+		break;
+	default:
+		error_interrupt_enable = 0;
+		error_interrupt_offset = 0;
+		break;
+	}
+
+	for (i = 0; i < fnic->rq_count; i++) {
+		cq_index = i;
+		vnic_rq_init(&fnic->rq[i],
+			     cq_index,
+			     error_interrupt_enable,
+			     error_interrupt_offset);
+	}
+
+	for (i = 0; i < fnic->raw_wq_count; i++) {
+		cq_index = i + fnic->rq_count;
+		vnic_wq_init(&fnic->wq[i],
+			     cq_index,
+			     error_interrupt_enable,
+			     error_interrupt_offset);
+	}
+
+	for (i = 0; i < fnic->wq_copy_count; i++) {
+		vnic_wq_copy_init(&fnic->wq_copy[i],
+				  0 /* cq_index 0 - always */,
+				  error_interrupt_enable,
+				  error_interrupt_offset);
+	}
+
+	for (i = 0; i < fnic->cq_count; i++) {
+
+		switch (intr_mode) {
+		case VNIC_DEV_INTR_MODE_MSIX:
+			interrupt_offset = i;
+			break;
+		default:
+			interrupt_offset = 0;
+			break;
+		}
+
+		vnic_cq_init(&fnic->cq[i],
+			0 /* flow_control_enable */,
+			1 /* color_enable */,
+			0 /* cq_head */,
+			0 /* cq_tail */,
+			1 /* cq_tail_color */,
+			1 /* interrupt_enable */,
+			1 /* cq_entry_enable */,
+			0 /* cq_message_enable */,
+			interrupt_offset,
+			0 /* cq_message_addr */);
+	}
+
+	/* Init INTR resources
+	 *
+	 * mask_on_assertion is not used for INTx due to the level-
+	 * triggered nature of INTx
+	 */
+
+	switch (intr_mode) {
+	case VNIC_DEV_INTR_MODE_MSI:
+	case VNIC_DEV_INTR_MODE_MSIX:
+		mask_on_assertion = 1;
+		break;
+	default:
+		mask_on_assertion = 0;
+		break;
+	}
+
+	for (i = 0; i < fnic->intr_count; i++) {
+		vnic_intr_init(&fnic->intr[i],
+			fnic->config.intr_timer,
+			fnic->config.intr_timer_type,
+			mask_on_assertion);
+	}
+
+	/* init the stats memory by making the first call here */
+	err = vnic_dev_stats_dump(fnic->vdev, &fnic->stats);
+	if (err) {
+		printk(KERN_ERR "vnic_dev_stats_dump failed - x%x\n", err);
+		goto err_out_cleanup;
+	}
+
+	/* Clear LIF stats */
+	vnic_dev_stats_clear(fnic->vdev);
+
+	return 0;
+
+err_out_cleanup:
+	fnic_free_vnic_resources(fnic);
+
+	return err;
+}
diff --git a/drivers/scsi/fnic/fnic_res.h b/drivers/scsi/fnic/fnic_res.h
new file mode 100644
index 0000000..b41d760
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_res.h
@@ -0,0 +1,199 @@
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#ifndef _FNIC_RES_H_
+#define _FNIC_RES_H_
+
+#include "wq_enet_desc.h"
+#include "rq_enet_desc.h"
+#include "vnic_wq.h"
+#include "vnic_rq.h"
+#include "fnic_io.h"
+#include "fcpio.h"
+#include "vnic_wq_copy.h"
+#include "vnic_cq_copy.h"
+
+static inline void fnic_queue_wq_desc(struct vnic_wq *wq,
+				      void *os_buf, dma_addr_t dma_addr,
+				      unsigned int len, unsigned int fc_eof,
+				      int vlan_tag_insert,
+				      unsigned int vlan_tag,
+				      int cq_entry, int sop, int eop)
+{
+	struct wq_enet_desc *desc = vnic_wq_next_desc(wq);
+
+	wq_enet_desc_enc(desc,
+			 cpu_to_le64((u64)dma_addr | VNIC_PADDR_TARGET),
+			 cpu_to_le16(len),
+			 0, /* mss_or_csum_offset */
+			 cpu_to_le16(fc_eof),
+			 0, /* offload_mode */
+			 (u8)eop, (u8)cq_entry,
+			 1, /* fcoe_encap */
+			 (u8)vlan_tag_insert,
+			 cpu_to_le16(vlan_tag),
+			 0 /* loopback */);
+
+	vnic_wq_post(wq, os_buf, dma_addr, len, sop, eop);
+}
+
+static inline void fnic_queue_wq_copy_desc_icmnd_16(struct vnic_wq_copy *wq,
+						    u32 req_id,
+						    u32 lunmap_id, u8 spl_flags,
+						    u32 sgl_cnt, u32 sense_len,
+						    u64 sgl_addr, u64 sns_addr,
+						    u8 crn, u8 pri_ta,
+						    u8 flags, u8 *scsi_cdb,
+						    u32 data_len, u8 *lun,
+						    u32 d_id, u16 mss,
+						    u32 ratov, u32 edtov)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_ICMND_16; /* enum fcpio_type */
+	desc->hdr.status = 0;            /* header status entry */
+	desc->hdr._resvd = 0;            /* reserved */
+	desc->hdr.tag.u.req_id = req_id; /* id for this request */
+
+	desc->u.icmnd_16.lunmap_id = lunmap_id; /* index into lunmap table */
+	desc->u.icmnd_16.special_req_flags = spl_flags; /* exch req flags */
+	desc->u.icmnd_16._resvd0[0] = 0;        /* reserved */
+	desc->u.icmnd_16._resvd0[1] = 0;        /* reserved */
+	desc->u.icmnd_16._resvd0[2] = 0;        /* reserved */
+	desc->u.icmnd_16.sgl_cnt = sgl_cnt;     /* scatter-gather list count */
+	desc->u.icmnd_16.sense_len = sense_len; /* sense buffer length */
+	desc->u.icmnd_16.sgl_addr = sgl_addr;   /* scatter-gather list addr */
+	desc->u.icmnd_16.sense_addr = sns_addr; /* sense buffer address */
+	desc->u.icmnd_16.crn = crn;             /* SCSI Command Reference No.*/
+	desc->u.icmnd_16.pri_ta = pri_ta; 	/* SCSI Pri & Task attribute */
+	desc->u.icmnd_16._resvd1 = 0;           /* reserved: should be 0 */
+	desc->u.icmnd_16.flags = flags;         /* command flags */
+	memcpy(desc->u.icmnd_16.scsi_cdb, scsi_cdb, CDB_16);    /* SCSI CDB */
+	desc->u.icmnd_16.data_len = data_len;   /* length of data expected */
+	memcpy(desc->u.icmnd_16.lun, lun, LUN_ADDRESS);  /* LUN address */
+	desc->u.icmnd_16._resvd2 = 0;          	/* reserved */
+	hton24(desc->u.icmnd_16.d_id, d_id);	/* FC vNIC only: Target D_ID */
+	desc->u.icmnd_16.mss = mss;            	/* FC vNIC only: max burst */
+	desc->u.icmnd_16.r_a_tov = ratov; /*FC vNIC only: Res. Alloc Timeout */
+	desc->u.icmnd_16.e_d_tov = edtov; /*FC vNIC only: Err Detect Timeout */
+
+	vnic_wq_copy_post(wq);
+}
+
+static inline void fnic_queue_wq_copy_desc_itmf(struct vnic_wq_copy *wq,
+						u32 req_id, u32 lunmap_id,
+						u32 tm_req, u32 tm_id, u8 *lun,
+						u32 d_id, u32 r_a_tov,
+						u32 e_d_tov)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_ITMF;     /* enum fcpio_type */
+	desc->hdr.status = 0;            /* header status entry */
+	desc->hdr._resvd = 0;            /* reserved */
+	desc->hdr.tag.u.req_id = req_id; /* id for this request */
+
+	desc->u.itmf.lunmap_id = lunmap_id; /* index into lunmap table */
+	desc->u.itmf.tm_req = tm_req;       /* SCSI Task Management request */
+	desc->u.itmf.t_tag = tm_id;         /* tag of fcpio to be aborted */
+	desc->u.itmf._resvd = 0;
+	memcpy(desc->u.itmf.lun, lun, LUN_ADDRESS);  /* LUN address */
+	desc->u.itmf._resvd1 = 0;
+	hton24(desc->u.itmf.d_id, d_id);    /* FC vNIC only: Target D_ID */
+	desc->u.itmf.r_a_tov = r_a_tov;     /* FC vNIC only: R_A_TOV in msec */
+	desc->u.itmf.e_d_tov = e_d_tov;     /* FC vNIC only: E_D_TOV in msec */
+
+	vnic_wq_copy_post(wq);
+}
+
+static inline void fnic_queue_wq_copy_desc_flogi_reg(struct vnic_wq_copy *wq,
+						     u32 req_id, u32 s_id,
+						     u8 *fcf_mac, u8 *src_mac,
+						     u32 ratov, u32 edtov)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_FLOGI_REG;     /* enum fcpio_type */
+	desc->hdr.status = 0;                 /* header status entry */
+	desc->hdr._resvd = 0;                 /* reserved */
+	desc->hdr.tag.u.req_id = req_id;      /* id for this request */
+
+	hton24(desc->u.flogi_reg.s_id, s_id);
+	memcpy(desc->u.flogi_reg.fcf_mac, fcf_mac, ETH_ALEN);
+	memcpy(desc->u.flogi_reg.ha_mac, src_mac, ETH_ALEN);
+	desc->u.flogi_reg.r_a_tov = ratov;
+	desc->u.flogi_reg.e_d_tov = edtov;
+
+	vnic_wq_copy_post(wq);
+}
+
+static inline void fnic_queue_wq_copy_desc_fw_reset(struct vnic_wq_copy *wq,
+						    u32 req_id)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_RESET;     /* enum fcpio_type */
+	desc->hdr.status = 0;             /* header status entry */
+	desc->hdr._resvd = 0;             /* reserved */
+	desc->hdr.tag.u.req_id = req_id;  /* id for this request */
+
+	vnic_wq_copy_post(wq);
+}
+
+static inline void fnic_queue_wq_copy_desc_lunmap(struct vnic_wq_copy *wq,
+						  u32 req_id, u64 lunmap_addr,
+						  u32 lunmap_len)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_LUNMAP_REQ;	/* enum fcpio_type */
+	desc->hdr.status = 0;			/* header status entry */
+	desc->hdr._resvd = 0;			/* reserved */
+	desc->hdr.tag.u.req_id = req_id;	/* id for this request */
+
+	desc->u.lunmap_req.addr = lunmap_addr;	/* address of the buffer */
+	desc->u.lunmap_req.len = lunmap_len;	/* len of the buffer */
+
+	vnic_wq_copy_post(wq);
+}
+
+static inline void fnic_queue_rq_desc(struct vnic_rq *rq,
+				      void *os_buf, dma_addr_t dma_addr,
+				      u16 len)
+{
+	struct rq_enet_desc *desc = vnic_rq_next_desc(rq);
+
+	rq_enet_desc_enc(desc,
+		cpu_to_le64((u64)dma_addr | VNIC_PADDR_TARGET),
+		RQ_ENET_TYPE_ONLY_SOP,
+		cpu_to_le16(len));
+
+	vnic_rq_post(rq, os_buf, 0, dma_addr, len);
+}
+
+
+struct fnic;
+
+int fnic_get_vnic_config(struct fnic *);
+int fnic_alloc_vnic_resources(struct fnic *);
+void fnic_free_vnic_resources(struct fnic *);
+void fnic_get_res_counts(struct fnic *);
+int fnic_set_nic_cfg(struct fnic *fnic, u8 rss_default_cpu, u8 rss_hash_type,
+	u8 rss_hash_bits, u8 rss_base_cpu, u8 rss_enable, u8 tso_ipid_split_en,
+	u8 ig_vlan_strip_en);
+
+#endif /* _FNIC_RES_H_ */


