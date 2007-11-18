From: Mark Lord <liml@rtr.ca>
Subject: Re: Process Scheduling Issue using sg/libata
Date: Sun, 18 Nov 2007 09:32:28 -0500
Message-ID: <47404CFC.7050405@rtr.ca>
References: <8202f4270711161649v75d06d35kd1d56e36d272a883@mail.gmail.com>	 <473E6E62.9090309@rtr.ca>	 <8202f4270711162320s2eb1d48dwb1430f4a779809a9@mail.gmail.com>	 <473F15E1.5030601@rtr.ca>	 <8202f4270711171120nddf24a8m8d1ece8c41b6c1ab@mail.gmail.com>	 <473F4724.6010107@rtr.ca> <8202f4270711172248x5d7abb0aq7a6e1bf2dad44e5e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000707090408090205050003"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:4971 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbXKROcb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Nov 2007 09:32:31 -0500
In-Reply-To: <8202f4270711172248x5d7abb0aq7a6e1bf2dad44e5e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fajun Chen <fajunchen@gmail.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

This is a multi-part message in MIME format.
--------------000707090408090205050003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Fajun Chen wrote:
> On 11/17/07, Mark Lord <liml@rtr.ca> wrote:
..
>> What you probably intended to do instead, was to use mmap to just allocate
>> some page-aligned RAM, not to actually mmap'd any on-disk data.  Right?
>>
>> Here's how that's done:
>>
>>       read_buffer = (U8 *)mmap(NULL, buf_sz, PROT_READ | PROT_WRITE,
>>                              MAP_SHARED|MAP_ANONYMOUS, -1, 0);
>>
> What I intended to do is to write data into disc or read data from
> disc via SG_IO as requested by my user-space application. I don't want
> any automatically scheduled kernel task to sync data with disc.
..

Right.  Then you definitely do NOT want to mmap your device,
because that's exactly what would otherwise happen, by design!


> I've experimented with memory mapping using MAP_ANONYMOUS as you
> suggested, the good news is that it does free up the cpu load and my
> system is much more responsive with the change.
..

Yes, that's what we expected to see.


> The bad news is that
> the data read back from disc (PIO or DMA read) seems to be invisible
> to user-space application. For instance, read buffer is all zeros
> after Identify Device command. Is this expected side effect of
> MAP_ANONYMOUS option?
..

No, that would be a side effect of some other bug in the code.

Here (attached) is a working program that performs (PACKET)IDENTIFY DEVICE
commands, using a mmap() buffer to receive the data.

Cheers

--------------000707090408090205050003
Content-Type: text/x-csrc;
 name="sg_identify.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_identify.c"

/*
 * This code is copyright 2007 by Mark Lord,
 * and is made available to all under the terms
 * of the GNU General Public License v2.
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>

#include <linux/fs.h>
#include <linux/hdreg.h>
#include <scsi/scsi.h>
#include <scsi/sg.h>
#include <sys/mman.h>

typedef unsigned long long u64;

enum {
	ATA_CMD_PIO_IDENTIFY		= 0xec,
	ATA_CMD_PIO_PIDENTIFY		= 0xa1,

	/* normal sector size (bytes) for PIO/DMA */
	ATA_SECT_SIZE			= 512,

	ATA_16				= 0x85,
	ATA_16_LEN			= 16,

	ATA_DEV_REG_LBA			= (1 << 6),

	ATA_LBA48			= 1,

	/* data transfer protocols; only basic PIO and DMA actually work */
	ATA_PROTO_NON_DATA		= ( 3 << 1),
	ATA_PROTO_PIO_IN		= ( 4 << 1),
	ATA_PROTO_PIO_OUT		= ( 5 << 1),
	ATA_PROTO_DMA			= ( 6 << 1),
	ATA_PROTO_UDMA_IN		= (11 << 1), /* unsupported */
	ATA_PROTO_UDMA_OUT		= (12 << 1), /* unsupported */
};

/*
 * Taskfile layout for ATA_16 cdb (LBA28/LBA48):
 *
 *	cdb[ 4] = feature
 *	cdb[ 6] = nsect
 *	cdb[ 8] = lbal
 *	cdb[10] = lbam
 *	cdb[12] = lbah
 *	cdb[13] = device
 *	cdb[14] = command
 *
 * "high order byte" (hob) fields for LBA48 commands:
 *
 *	cdb[ 3] = hob_feature
 *	cdb[ 5] = hob_nsect
 *	cdb[ 7] = hob_lbal
 *	cdb[ 9] = hob_lbam
 *	cdb[11] = hob_lbah
 *
 * dxfer_direction choices:
 *
 *	SG_DXFER_TO_DEV		(writing to drive)
 *	SG_DXFER_FROM_DEV	(reading from drive)
 *	SG_DXFER_NONE		(non-data commands)
 */

static int sg_issue (int fd, unsigned char ata_op, void *buf)
{
	unsigned char cdb[ATA_16_LEN]
		= { ATA_16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	unsigned char sense[32];
	unsigned int nsects = 1;
	struct sg_io_hdr hdr;

	cdb[ 1] = ATA_PROTO_PIO_IN;
	cdb[ 6] = nsects;
	cdb[14] = ata_op;

	memset(&hdr, 0, sizeof(struct sg_io_hdr));
	hdr.interface_id	= 'S';
	hdr.cmd_len		= ATA_16_LEN;
	hdr.mx_sb_len		= sizeof(sense);
	hdr.dxfer_direction	= SG_DXFER_FROM_DEV;
	hdr.dxfer_len		= nsects * ATA_SECT_SIZE;
	hdr.dxferp		= buf;
	hdr.cmdp		= cdb;
	hdr.sbp			= sense;
	hdr.timeout		= 5000; /* milliseconds */

	memset(sense, 0, sizeof(sense));
	if (ioctl(fd, SG_IO, &hdr) < 0) {
		perror("ioctl(SG_IO)");
		return (-1);
	}
	if (hdr.status == 0 && hdr.host_status == 0 && hdr.driver_status == 0)
		return 0; /* success */

	if (hdr.status > 0) {
		unsigned char *d = sense + 8;
		/* SCSI status is non-zero */
		fprintf(stderr, "SG_IO error: SCSI sense=0x%x/%02x/%02x, ATA=0x%02x/%02x\n",
			sense[1] & 0xf, sense[2], sense[3], d[13], d[3]);
		return -1;
	}
	/* some other error we don't know about yet */
	fprintf(stderr, "SG_IO returned: SCSI status=0x%x, host_status=0x%x, driver_status=0x%x\n",
		hdr.status, hdr.host_status, hdr.driver_status);
	return -1;
}

int main (int argc, char *argv[])
{
	const char *devpath;
	int i, rc, fd;
#if 0
	unsigned short id[ATA_SECT_SIZE / 2];
	memset(id, 0, sizeof(id));
#else
	unsigned short *id;
	id = mmap(NULL, getpagesize(), PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0);
	if (id == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
#endif
	if (argc != 2) {
		fprintf(stderr, "%s: bad/missing parm: expected <devpath>\n", argv[0]);
		exit(1);
	}
	devpath = argv[1];

	fd = open(devpath, O_RDWR|O_NONBLOCK);
	if (fd == -1) {
		perror(devpath);
		exit(1);
	}
	rc = sg_issue(fd, ATA_CMD_PIO_IDENTIFY, id);
	if (rc != 0)
		rc = sg_issue(fd, ATA_CMD_PIO_PIDENTIFY, id);
	if (rc == 0) {
		unsigned short *d = id;
		for (i = 0; i < (256/8); ++i) {
			printf("%04x %04x %04x %04x %04x %04x %04x %04x\n",
				d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7]);
			d += 8;
		}
		exit(0);
	}
	exit(1);
}

--------------000707090408090205050003--
