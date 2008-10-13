From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [PATCH 0/2] FC pass through support via bsg interface - revised
Date: Mon, 13 Oct 2008 10:53:18 -0700
Message-ID: <B5FBFF85-C7C0-44F7-905F-9029C54F4F56@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-5-800062317
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:9203 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbYJMRxW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Oct 2008 13:53:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Robert W Love <robert.w.love@intel.com>


--Apple-Mail-5-800062317
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Hi,

Base on feedback as below, here is revised one for pass through support.
http://marc.info/?l=linux-scsi&m=122123825918741&w=2
http://marc.info/?t=121908849700001&r=1&w=2

Also, the attached file is updated sample application along with GPL  
license.

--Apple-Mail-5-800062317
Content-Disposition: attachment;
	filename=issue-service.c
Content-Type: application/octet-stream;
	x-unix-mode=0755;
	name="issue-service.c"
Content-Transfer-Encoding: 7bit

/*
 * QLogic Fibre Channel HBA Driver
 * Copyright (c) 2008 QLogic Corporation
 *
 * issue-service.c -- sample utility to issue ELS/CT pass through services
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/dma-mapping.h>
#include <linux/dmapool.h>
#include <linux/delay.h>
#include <linux/interrupt.h>
#include <linux/kthread.h>
#include <linux/of.h>
#include <linux/stringify.h>
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

/* NOTE - fc_els_hdr to move to ~/include/scsi/fc/fc_els.h */
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
	struct fc_ct_hdr ct_hdr;
	unsigned int ct_cmd[1];
};

struct fc_els_frame {
	struct fc_els_hdr els_hdr;
	unsigned int els_srv_param[4];
};

#define FC_SERVICE_TIMEOUT 10

void
els_echo(int fd, char *dev)
{
	int i;
	char cdb[16];
	char request_sense[18];
	// char response[0x8192];
	char response[64];
	struct sg_io_v4 sg_io;
	struct fc_els_frame els;
	int res;

	els.els_hdr.els_cmd = 0x10; /* ELS cmd - echo */
	els.els_hdr.els_param[2] = 0;
	els.els_hdr.els_param[1] = 0;
	els.els_hdr.els_param[0] = 0;

	els.els_srv_param[0] = 0xcafecafe;
	els.els_srv_param[1] = 0xc8c8c8c8;
	els.els_srv_param[2] = 0xdeaddead;
	els.els_srv_param[3] = 0xaceaceac;

	cdb[0] = 0x01; /* ELS type */

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = (__u64) cdb;
	sg_io.dout_xfer_len = sizeof (struct fc_els_frame);
	sg_io.dout_xferp = (__u64) &els;


	/******************* to test multiple SG feature ********************/
	// sg_io.din_xfer_len = 0x8192;
	sg_io.din_xfer_len = sizeof(struct fc_els_frame);



	sg_io.din_xferp = (__u64) response;
	sg_io.max_response_len = sizeof(request_sense);
	sg_io.response = (__u64) request_sense;

	sg_io.timeout = 20000;

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
	char cdb[16];
	char response[68];
	struct sg_io_v4 sg_io;
	struct fc_els_frame els;
	int res;

	els.els_hdr.els_cmd = 0x78; /* ELS cmd - rnid */
	els.els_hdr.els_param[2] = 0;
	els.els_hdr.els_param[1] = 0;
	els.els_hdr.els_param[0] = 0;

	els.els_srv_param[0] = 0x00000000; /* common node-identification data */

	cdb[0] = 0x01; /* ELS type */

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = (__u64) cdb;
	sg_io.dout_xfer_len = 8; /* size of request = 8 */
	sg_io.dout_xferp = (__u64) &els;
	sg_io.din_xfer_len = sizeof(response); /* common node-identification data + 4 */
	sg_io.din_xferp = (__u64) response;

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
	char cdb[16];
	char response[16];
	struct sg_io_v4 sg_io;
	struct fc_els_frame els;
	int res;

	els.els_hdr.els_cmd = 0x0e; /* ELS cmd - read timeout value */
	els.els_hdr.els_param[2] = 0;
	els.els_hdr.els_param[1] = 0;
	els.els_hdr.els_param[0] = 0;

	cdb[0] = 0x01; /* ELS type */

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = (__u64) cdb;
	sg_io.dout_xfer_len = 4;
	sg_io.dout_xferp = (__u64) &els;
	sg_io.din_xfer_len = sizeof(response);
	sg_io.din_xferp = (__u64) response;

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
	char cdb[16];
	char response[168];
	struct sg_io_v4 sg_io;
	struct fc_els_frame els;
	int res;

	els.els_hdr.els_cmd = 0x72; /* ELS cmd - loop_status*/
	els.els_hdr.els_param[2] = 0;
	els.els_hdr.els_param[1] = 0;
	els.els_hdr.els_param[0] = 0;

	cdb[0] = 0x01; /* ELS type */

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = (__u64) cdb;
	sg_io.dout_xfer_len = 4;
	sg_io.dout_xferp = (__u64) &els;
	sg_io.din_xfer_len = sizeof(response);
	sg_io.din_xferp = (__u64) response;

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
	char cdb[16];
	char response[632];
	struct sg_io_v4 sg_io;
	struct fc_ct_frame ct;
	int res;

	ct.ct_hdr.ct_rev = 1;
	ct.ct_hdr.ct_in_id[2] = 0x00;
	ct.ct_hdr.ct_in_id[1] = 0x00;
	ct.ct_hdr.ct_in_id[0] = 0x00;
	ct.ct_hdr.ct_fs_type = 0xFC;
	ct.ct_hdr.ct_fs_subtype = 0x02;
	ct.ct_hdr.ct_options = 0x0;
	ct.ct_hdr.ct_cmd = 0x1;          /* GA_NXT = 0x100 in BE */
	ct.ct_hdr.ct_mr_size = 0x7802;   /* 0x278 in BE */

	cdb[0] = 0x20; /* CT type */

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = (__u64) cdb;
	sg_io.dout_xfer_len = 20;
	sg_io.dout_xferp = (__u64) &ct;
	sg_io.din_xfer_len = sizeof(response);
	sg_io.din_xferp = (__u64) response;

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
	char cdb[16];
	char response[24];
	struct sg_io_v4 sg_io;
	struct fc_ct_frame ct;
	int res;

	ct.ct_hdr.ct_rev = 1;
	ct.ct_hdr.ct_in_id[2] = 0x00;
	ct.ct_hdr.ct_in_id[1] = 0x00;
	ct.ct_hdr.ct_in_id[0] = 0x00;
	ct.ct_hdr.ct_fs_type = 0xFC;
	ct.ct_hdr.ct_fs_subtype = 0x02;
	ct.ct_hdr.ct_options = 0x0;
	ct.ct_hdr.ct_cmd = 0x1c01;       /* GFPN_ID = 0x011c in BE */
	ct.ct_hdr.ct_mr_size = 0x1800;   /* 0x18 in BE */

	cdb[0] = 0x20; /* CT type */

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = (__u64) cdb;
	sg_io.dout_xfer_len = 20;
	sg_io.dout_xferp = (__u64) &ct;
	sg_io.din_xfer_len = sizeof(response);
	sg_io.din_xferp = (__u64) response;

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
	// ct_gfpn_id(fd, argv[1]);

	close(fd);
}

--Apple-Mail-5-800062317
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit


Thank you,
Seokmann


--Apple-Mail-5-800062317--
