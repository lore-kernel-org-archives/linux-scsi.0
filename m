From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: pass through support through bsg interface - sample application
Date: Fri, 5 Sep 2008 12:18:52 -0700
Message-ID: <DB1A62A8-47F0-4504-A40A-D7BB161FED85@qlogic.com>
References: <E2859F0D-AFB4-473C-9599-8F963ED365BD@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v928.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:58425 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYIETSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2008 15:18:55 -0400
In-Reply-To: <E2859F0D-AFB4-473C-9599-8F963ED365BD@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, Robert W Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>

Hi,

Also, just for sharing purpose, here is the source of the application  
that I've used to test the pass through support.
It issues a couple of ELS/CT service requests to the qla2xxx module  
via bsg.

Thank you,
Seokmann
---
/*
  * QLogic Fibre Channel HBA Driver
  * Copyright (c) 2008 QLogic Corporation
  */
typedef signed int __s32;
typedef unsigned short __u16;
typedef unsigned int __u32;
typedef unsigned long __u64;
typedef unsigned char __u8;
typedef __u32 __be32;
typedef __u16 __be16;
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <scsi/scsi.h>
#include <scsi/sg.h>
#include "/lib/modules/2.6.27-rc4/source/include/linux/bsg.h"

struct fc_frame_header {
	__u8          fh_r_ctl;	/* routing control */
	__u8          fh_d_id[3];	/* Destination ID */

	__u8          fh_cs_ctl;	/* class of service control / pri */
	__u8          fh_s_id[3];	/* Source ID */

	__u8          fh_type;		/* see enum fc_fh_type below */
	__u8          fh_f_ctl[3];	/* frame control */

	__u8          fh_seq_id;	/* sequence ID */
	__u8          fh_df_ctl;	/* data field control */
	__be16        fh_seq_cnt;	/* sequence count */

	__be16        fh_ox_id;		/* originator exchange ID */
	__be16        fh_rx_id;		/* responder exchange ID */
	__be32        fh_parm_offset;	/* parameter or relative offset */
};

/* TBD - fc_els_hdr to move to ~/include/scsi/fc/fc_els.h */
struct fc_els_hdr {
	__u8	els_cmd;
	__u8	els_param[3];
};

/* NOTE - fc_ct_hdr is already defined in open-fcoe-upstream branch */
/*
  * Fibre Channel Services - Common Transport.
  * From T11.org FC-GS-2 Rev 5.3 November 1998.
  */

struct fc_ct_hdr {
	__u8		ct_rev;		/* revision */
	__u8		ct_in_id[3];	/* N_Port ID of original requestor */
	__u8		ct_fs_type;	/* type of fibre channel service */
	__u8		ct_fs_subtype;	/* subtype */
	__u8		ct_options;
	__u8		_ct_resvd1;
	__be16		ct_cmd;		/* command / response code */
	__be16		ct_mr_size;	/* maximum / residual size */
	__u8		_ct_resvd2;
	__u8		ct_reason;	/* reject reason */
	__u8		ct_explan;	/* reason code explanation */
	__u8		ct_vendor;	/* vendor unique data */
};

struct fc_ct_frame {
	struct fc_frame_header fc_hdr;
	struct fc_ct_hdr ct_hdr;
	unsigned int ct_cmd[1];
};

struct fc_els_frame {
	struct fc_frame_header fc_hdr;
	struct fc_els_hdr els_hdr;
	unsigned int els_cmd[4];
};

#define FC_SERVICE_TIMEOUT 10

void
els_echo(int fd, char *dev)
{
	int i;
	char cdb[] = "FC Service CDB";
	char inq_data[] = "FC Service DATA OUT";
	char response[64];
	struct sg_io_v4 sg_io;
	struct fc_els_frame els;
	int res;

	els.fc_hdr.fh_r_ctl = 0x22; /* ELS */
	els.fc_hdr.fh_d_id[2] = 0;
	els.fc_hdr.fh_d_id[1] = 0;
	els.fc_hdr.fh_d_id[0] = 0;
	els.fc_hdr.fh_cs_ctl = 0;
	els.fc_hdr.fh_s_id[2] = 0x01;
	els.fc_hdr.fh_s_id[1] = 0x0a;
	els.fc_hdr.fh_s_id[0] = 0x01;
	els.fc_hdr.fh_type = 0x01; /* ELS type */
	els.fc_hdr.fh_f_ctl[2] = 0;
	els.fc_hdr.fh_f_ctl[1] = 0;
	els.fc_hdr.fh_f_ctl[0] = 0;
	els.fc_hdr.fh_seq_id = 0;
	els.fc_hdr.fh_df_ctl = 0;
	els.fc_hdr.fh_seq_cnt = 0;
	els.fc_hdr.fh_ox_id = 0xcafe;
	els.fc_hdr.fh_rx_id = 0xdead;
	els.fc_hdr.fh_parm_offset = 0;

	els.els_hdr.els_cmd = 0x10; /* ELS cmd - echo */
	els.els_hdr.els_param[2] = 0;
	els.els_hdr.els_param[1] = 0;
	els.els_hdr.els_param[0] = 0;

	els.els_cmd[0] = 0xcafecafe;
	els.els_cmd[1] = 0xc8c8c8c8;
	els.els_cmd[2] = 0xdeaddead;
	els.els_cmd[3] = 0xaceaceac;

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = cdb;
	sg_io.dout_xfer_len = sizeof(struct fc_frame_header) +
	    sizeof (struct fc_els_hdr) + 16;
	sg_io.dout_xferp = &els;
	sg_io.din_xfer_len = sizeof(struct fc_els_frame) -
	    sizeof(struct fc_frame_header);
	sg_io.din_xferp = response;

	sg_io.timeout = 100;

	memset(response, 0x0, sizeof (response));

	res = ioctl(fd, SG_IO, &sg_io);
	if (res < 0) {
		printf("ERROR: nothing could be written to %s, error = %d\n",
		    dev, res);
	}

	printf("result of IOCTL:\n");
	for (i=0;i<sizeof (response); i++) {
		printf("%2x ", response[i]);
		if ((i % 4) == 3)
			printf("\n");
	}
}

void
els_rnid(int fd, char *dev)
{
	int i;
	char cdb[] = "FC Service CDB";
	char inq_data[] = "FC Service DATA OUT";
	char response[76];
	struct sg_io_v4 sg_io;
	struct fc_els_frame els;
	int res;

	els.fc_hdr.fh_r_ctl = 0x22; /* ELS */
	els.fc_hdr.fh_d_id[2] = 0;
	els.fc_hdr.fh_d_id[1] = 0;
	els.fc_hdr.fh_d_id[0] = 0;
	els.fc_hdr.fh_cs_ctl = 0;
	els.fc_hdr.fh_s_id[2] = 0x01;
	els.fc_hdr.fh_s_id[1] = 0x0a;
	els.fc_hdr.fh_s_id[0] = 0x01;
	els.fc_hdr.fh_type = 0x01; /* ELS type */
	els.fc_hdr.fh_f_ctl[2] = 0;
	els.fc_hdr.fh_f_ctl[1] = 0;
	els.fc_hdr.fh_f_ctl[0] = 0;
	els.fc_hdr.fh_seq_id = 0;
	els.fc_hdr.fh_df_ctl = 0;
	els.fc_hdr.fh_seq_cnt = 0;
	els.fc_hdr.fh_ox_id = 0xcafe;
	els.fc_hdr.fh_rx_id = 0xdead;
	els.fc_hdr.fh_parm_offset = 0;

	els.els_hdr.els_cmd = 0x78; /* ELS cmd - rnid */
	els.els_hdr.els_param[2] = 0;
	els.els_hdr.els_param[1] = 0;
	els.els_hdr.els_param[0] = 0;

	els.els_cmd[0] = 0x00000000;

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = cdb;
	sg_io.dout_xfer_len = sizeof(struct fc_frame_header) +
	    sizeof (struct fc_els_hdr) + 4;
	sg_io.dout_xferp = &els;
	sg_io.din_xfer_len = 76;
	sg_io.din_xferp = response;

	sg_io.timeout = 100;

	memset(response, 0x0, sizeof (response));

	res = ioctl(fd, SG_IO, &sg_io);
	if (res < 0) {
		printf("ERROR: nothing could be written to %s, error = %d\n",
		    dev, res);
	}

	printf("result of IOCTL:\n");
	for (i=0;i<sizeof (response); i++) {
		printf("%2x ", response[i]);
		if ((i % 4) == 3)
			printf("\n");
	}
}

void
els_read_timeout_value(int fd, char *dev)
{
	int i;
	char cdb[] = "FC Service CDB";
	char inq_data[] = "FC Service DATA OUT";
	char response[16];
	struct sg_io_v4 sg_io;
	struct fc_els_frame els;
	int res;

	els.fc_hdr.fh_r_ctl = 0x22; /* ELS */
	els.fc_hdr.fh_d_id[2] = 0;
	els.fc_hdr.fh_d_id[1] = 0;
	els.fc_hdr.fh_d_id[0] = 0;
	els.fc_hdr.fh_cs_ctl = 0;
	els.fc_hdr.fh_s_id[2] = 0x01;
	els.fc_hdr.fh_s_id[1] = 0x0a;
	els.fc_hdr.fh_s_id[0] = 0x01;
	els.fc_hdr.fh_type = 0x01; /* ELS type */
	els.fc_hdr.fh_f_ctl[2] = 0;
	els.fc_hdr.fh_f_ctl[1] = 0;
	els.fc_hdr.fh_f_ctl[0] = 0;
	els.fc_hdr.fh_seq_id = 0;
	els.fc_hdr.fh_df_ctl = 0;
	els.fc_hdr.fh_seq_cnt = 0;
	els.fc_hdr.fh_ox_id = 0xcafe;
	els.fc_hdr.fh_rx_id = 0xdead;
	els.fc_hdr.fh_parm_offset = 0;

	els.els_hdr.els_cmd = 0x0e; /* ELS cmd - read timeout value */
	els.els_hdr.els_param[2] = 0;
	els.els_hdr.els_param[1] = 0;
	els.els_hdr.els_param[0] = 0;

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = cdb;
	sg_io.dout_xfer_len = sizeof(struct fc_frame_header) +
	    sizeof (struct fc_els_hdr);
	sg_io.dout_xferp = &els;
	sg_io.din_xfer_len = sizeof(response);
	sg_io.din_xferp = response;

	sg_io.timeout = 100;

	memset(response, 0x0, sizeof (response));

	res = ioctl(fd, SG_IO, &sg_io);
	if (res < 0) {
		printf("ERROR: nothing could be written to %s, error = %d\n",
		    dev, res);
	}

	printf("result of IOCTL:\n");
	for (i=0;i<sizeof (response); i++) {
		printf("%2x ", response[i]);
		if ((i % 4) == 3)
			printf("\n");
	}
}

void
els_loop_status(int fd, char *dev)
{
	int i;
	char cdb[] = "FC Service CDB";
	char inq_data[] = "FC Service DATA OUT";
	char response[164];
	struct sg_io_v4 sg_io;
	struct fc_els_frame els;
	int res;

	els.fc_hdr.fh_r_ctl = 0x22; /* ELS */
	els.fc_hdr.fh_d_id[2] = 0;
	els.fc_hdr.fh_d_id[1] = 0;
	els.fc_hdr.fh_d_id[0] = 0;
	els.fc_hdr.fh_cs_ctl = 0;
	els.fc_hdr.fh_s_id[2] = 0x01;
	els.fc_hdr.fh_s_id[1] = 0x0a;
	els.fc_hdr.fh_s_id[0] = 0x01;
	els.fc_hdr.fh_type = 0x01; /* ELS type */
	els.fc_hdr.fh_f_ctl[2] = 0;
	els.fc_hdr.fh_f_ctl[1] = 0;
	els.fc_hdr.fh_f_ctl[0] = 0;
	els.fc_hdr.fh_seq_id = 0;
	els.fc_hdr.fh_df_ctl = 0;
	els.fc_hdr.fh_seq_cnt = 0;
	els.fc_hdr.fh_ox_id = 0xcafe;
	els.fc_hdr.fh_rx_id = 0xdead;
	els.fc_hdr.fh_parm_offset = 0;

	els.els_hdr.els_cmd = 0x72; /* ELS cmd - loop_status*/
	els.els_hdr.els_param[2] = 0;
	els.els_hdr.els_param[1] = 0;
	els.els_hdr.els_param[0] = 0;

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = cdb;
	sg_io.dout_xfer_len = sizeof(struct fc_frame_header) +
	    sizeof (struct fc_els_hdr);
	sg_io.dout_xferp = &els;
	sg_io.din_xfer_len = sizeof(response);
	sg_io.din_xferp = response;

	sg_io.timeout = 100;

	memset(response, 0x0, sizeof (response));

	res = ioctl(fd, SG_IO, &sg_io);
	if (res < 0) {
		printf("ERROR: nothing could be written to %s, error = %d\n",
		    dev, res);
	}

	printf("result of IOCTL:\n");
	for (i=0;i<sizeof (response); i++) {
		printf("%2x ", response[i]);
		if ((i % 4) == 3)
			printf("\n");
	}
}

int
ct_ga_nxt(int fd, char *dev)
{
	int i;
	struct fc_ct_frame ct;
	struct sg_io_v4 sg_io;
	char cdb[] = "FC Service CDB";
	char response[632];
	int res;

	memset(&ct, 0x0, sizeof (struct fc_ct_frame));

	/* prepare CT request - Get All Next (GA_NXT) */
	/*
	 * R_CTL : -----------
	 *         |xxxx|xxxx|
	 *         -----------
	 *           ^    ^
	 *           |    |- R_Bits[3:0] 0x02 - Extended Link Data
	 *           |    |- R_Bits[3:0] 0x03 - FC-4 Link Data (FC-CT)
	 *           |------ INFO[7:4] 0x02 - ELS/FC-CT Request
	 */
	ct.fc_hdr.fh_r_ctl = 0x23;
	ct.fc_hdr.fh_d_id[2] = 0;
	ct.fc_hdr.fh_d_id[1] = 0;
	ct.fc_hdr.fh_d_id[0] = 0;
	ct.fc_hdr.fh_cs_ctl = 0;
	ct.fc_hdr.fh_s_id[2] = 0x01;
	ct.fc_hdr.fh_s_id[1] = 0x0a;
	ct.fc_hdr.fh_s_id[0] = 0x00;
	/*
	 * TYPE :
	 *     0x00 - Basic Link Service
	 *     0x01 - Extended Link Service
	 *     0x20 - FC-CT Generic Srvices
	 */
	ct.fc_hdr.fh_type = 0x20;
	ct.fc_hdr.fh_f_ctl[2] = 0;
	ct.fc_hdr.fh_f_ctl[1] = 0;
	ct.fc_hdr.fh_f_ctl[0] = 0;
	ct.fc_hdr.fh_seq_id = 0;
	ct.fc_hdr.fh_df_ctl = 0;
	ct.fc_hdr.fh_seq_cnt = 0;
	ct.fc_hdr.fh_ox_id = 0xcafe;
	ct.fc_hdr.fh_rx_id = 0xdead;
	ct.fc_hdr.fh_parm_offset = 0;
	ct.ct_hdr.ct_rev = 1;
	ct.ct_hdr.ct_in_id[2] = 0x00;
	ct.ct_hdr.ct_in_id[1] = 0x00;
	ct.ct_hdr.ct_in_id[0] = 0x00;
	ct.ct_hdr.ct_fs_type = 0xFC;
	ct.ct_hdr.ct_fs_subtype = 0x02;
	ct.ct_hdr.ct_options = 0x0;
	ct.ct_hdr.ct_cmd = 0x1;          /* GA_NXT = 0x100 in BE */
	// ct.ct_hdr.ct_mr_size = 0x7802;   /* 0x278 in BE */

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = cdb;
	sg_io.dout_xfer_len = sizeof(struct fc_frame_header) +
	    sizeof (struct fc_ct_hdr);
	sg_io.dout_xferp = &ct;
	sg_io.din_xfer_len = sizeof(response);
	sg_io.din_xferp = response;

	sg_io.timeout = 100;

	memset(response, 0x0, sizeof (response));

	res = ioctl(fd, SG_IO, &sg_io);
	if (res < 0) {
		printf("ERROR: nothing could be written to %s, error = %d\n",
		    dev, res);
	}

	printf("result of IOCTL:\n");
	for (i=0;i<sizeof (response); i++) {
		printf("%2x ", response[i]);
		if ((i % 4) == 3)
			printf("\n");
	}
}

int
ct_gfpn_id(int fd, char *dev)
{
	int i;
	struct fc_ct_frame ct;
	struct sg_io_v4 sg_io;
	char cdb[] = "FC Service CDB";
	char response[24];
	int res;

	memset(&ct, 0x0, sizeof (struct fc_ct_frame));

	/* prepare CT request - Get All Next (GA_NXT) */
	/*
	 * R_CTL : -----------
	 *         |xxxx|xxxx|
	 *         -----------
	 *           ^    ^
	 *           |    |- R_Bits[3:0] 0x02 - Extended Link Data
	 *           |    |- R_Bits[3:0] 0x03 - FC-4 Link Data (FC-CT)
	 *           |------ INFO[7:4] 0x02 - ELS/FC-CT Request
	 */
	ct.fc_hdr.fh_r_ctl = 0x23;
	ct.fc_hdr.fh_d_id[2] = 0;
	ct.fc_hdr.fh_d_id[1] = 0;
	ct.fc_hdr.fh_d_id[0] = 0;
	ct.fc_hdr.fh_cs_ctl = 0;
	ct.fc_hdr.fh_s_id[2] = 0x01;
	ct.fc_hdr.fh_s_id[1] = 0x0a;
	ct.fc_hdr.fh_s_id[0] = 0x00;
	/*
	 * TYPE :
	 *     0x00 - Basic Link Service
	 *     0x01 - Extended Link Service
	 *     0x20 - FC-CT Generic Srvices
	 */
	ct.fc_hdr.fh_type = 0x20;
	ct.fc_hdr.fh_f_ctl[2] = 0;
	ct.fc_hdr.fh_f_ctl[1] = 0;
	ct.fc_hdr.fh_f_ctl[0] = 0;
	ct.fc_hdr.fh_seq_id = 0;
	ct.fc_hdr.fh_df_ctl = 0;
	ct.fc_hdr.fh_seq_cnt = 0;
	ct.fc_hdr.fh_ox_id = 0xcafe;
	ct.fc_hdr.fh_rx_id = 0xdead;
	ct.fc_hdr.fh_parm_offset = 0;
	ct.ct_hdr.ct_rev = 1;
	ct.ct_hdr.ct_in_id[2] = 0x00;
	ct.ct_hdr.ct_in_id[1] = 0x00;
	ct.ct_hdr.ct_in_id[0] = 0x00;
	ct.ct_hdr.ct_fs_type = 0xFC;
	ct.ct_hdr.ct_fs_subtype = 0x02;
	ct.ct_hdr.ct_options = 0x0;
	ct.ct_hdr.ct_cmd = 0x1c01;       /* GFPN_ID = 0x011c in BE */
	// ct.ct_hdr.ct_mr_size = 0x1800;   /* 0x18 in BE */

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = cdb;
	sg_io.dout_xfer_len = sizeof(struct fc_frame_header) +
	    sizeof (struct fc_ct_hdr);
	sg_io.dout_xferp = &ct;
	sg_io.din_xfer_len = sizeof(response);
	sg_io.din_xferp = response;

	sg_io.timeout = 100;

	memset(response, 0x0, sizeof (response));

	res = ioctl(fd, SG_IO, &sg_io);
	if (res < 0) {
		printf("ERROR: nothing could be written to %s, error = %d\n",
		    dev, res);
	}

	printf("result of IOCTL:\n");
	for (i=0;i<sizeof (response); i++) {
		printf("%2x ", response[i]);
		if ((i % 4) == 3)
			printf("\n");
	}
}

int
main(int argc, char **argv)
{
	int i;
	int fd;
	char cdb[] = "FC Service CDB";
	char inq_data[] = "FC Service DATA OUT";
	char sense_data[] = "FC Service DATA IN";
	char response[16];

	if (argc < 2) {
		printf("ERROR: specify rport (f.e. /dev/rport-6:0-0\n");
		return 1;
	}
	fd = open(argv[1], O_RDWR);
	if (fd < 0) {
		printf("ERROR: failed opening %s\n", argv[1]);
		return;
	}

	els_echo(fd, argv[1]);
	// els_rnid(fd, argv[1]);
	// els_read_timeout_value(fd, argv[1]);
	// els_loop_status(fd, argv[1]);
	ct_ga_nxt(fd, argv[1]);
	ct_gfpn_id(fd, argv[1]);

	close(fd);
}
---
