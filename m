From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: [PATCH] ips: sg chaining support to the path to non I/O
 commands
Date: Fri, 22 Feb 2008 23:50:43 +0900
Message-ID: <20080222235040U.tomof@acm.org>
References: <20080219184131V.tomof@acm.org>
	<532ABFBDAAC3A34EB12EBA6CEC2838F439A58D14@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:51854 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbYBVPAa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 10:00:30 -0500
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F439A58D14@ADPE2K703.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark_Salyzyn@adaptec.com
Cc: tomof@acm.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, lnxninja@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp

On Tue, 19 Feb 2008 04:39:00 -0800
"Salyzyn, Mark" <Mark_Salyzyn@adaptec.com> wrote:

> ACK

Thanks!


> Other RAID drivers (eg: aacraid) makes the assumption that commands
> in these paths (INQUIRY, READ CAPACITY, MODE SENSE etc spoofing) are
> single scatter gather elements and have yet to be bitten. I agree
> with Fujita-san about the practical unlikelihood. The fix does not
> incur any change in code overhead, so it is worth hardening!
>
> Can one create a request via /dev/sg for a buffer smaller than 256
> and manage to create a multi-element scatter gather?

I think that we can do post 2.6.24 since we relaxed the default
alignment requirements (from 511 to 3). So a buffer more than 8 bytes
can leads to multi-element scatter gathers though it rarely happens.

Shortly I will submit the helper functions to copy data between sg
list and a buffer. It can replace aac_internal_transfer but it's not
for scsi-rc-fixes. If you worry that aac_internal_transfer can't
handle multiple sg entries, you can do something like this, I think:


diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index ae5f74f..73fa7c2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -455,6 +455,12 @@ static int aac_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+static int aac_slave_alloc(struct scsi_device *sdev)
+{
+	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
+	return 0;
+}
+
 /**
  *	aac_change_queue_depth		-	alter queue depths
  *	@sdev:	SCSI device we are considering
@@ -1015,6 +1021,7 @@ static struct scsi_host_template aac_driver_template = {
 	.queuecommand			= aac_queuecommand,
 	.bios_param			= aac_biosparm,
 	.shost_attrs			= aac_attrs,
+	.slave_alloc			= aac_slave_alloc,
 	.slave_configure		= aac_slave_configure,
 	.change_queue_depth		= aac_change_queue_depth,
 	.sdev_attrs			= aac_dev_attrs,



=
Here's a malicious version of sg_inq, which tries to create multiple
sg entries:

=
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <scsi/sg.h>

#define INQ_REPLY_LEN 96
#define INQ_CMD_LEN 6

int main(int argc, char **argv)
{
	struct sg_io_hdr hdr;
	unsigned char scb[INQ_CMD_LEN] = {0x12, 0, 0, 0, INQ_REPLY_LEN, 0};
	unsigned char sense[32];
	void *buf;
	int offset = 4096 - 4;
	int fd, ret;

	buf = valloc(8192);

	memset(&hdr, 0, sizeof(hdr));

	hdr.interface_id = 'S';
	hdr.cmd_len = sizeof(scb);
	hdr.mx_sb_len = sizeof(sense);
	hdr.dxfer_direction = SG_DXFER_FROM_DEV;
	hdr.dxfer_len = INQ_REPLY_LEN;
	hdr.dxferp = buf + offset;
	hdr.cmdp = scb;
	hdr.sbp = sense;
	hdr.flags |= SG_FLAG_DIRECT_IO;

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "fail to open %s\n", argv[1]);
		return fd;
	}

	ret = ioctl(fd, SG_IO, &hdr);
	if (ret < 0) {
		fprintf(stderr, "fail to ioctl %d\n", ret);
		return ret;
	}

	return ret;
}
