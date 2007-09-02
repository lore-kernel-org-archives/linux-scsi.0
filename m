From: Andrew Morton <akpm@linux-foundation.org>
Subject: Fw: data disclosure in ioctl sg inquiry
Date: Sun, 2 Sep 2007 04:56:01 -0700
Message-ID: <20070902045601.5a18ae56.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sun__2_Sep_2007_04_56_01_-0700_7fv1EXQCu/XP+bhu"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964895AbXIBL4F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Sep 2007 07:56:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Luciano Rocha <strange@nsk.no-ip.org>

This is a multi-part message in MIME format.

--Multipart=_Sun__2_Sep_2007_04_56_01_-0700_7fv1EXQCu/XP+bhu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit



Begin forwarded message:

Date: Mon, 27 Aug 2007 15:01:33 +0100
From: Luciano Rocha <strange@nsk.no-ip.org>
To: linux-kernel@vger.kernel.org
Subject: data disclosure in ioctl sg inquiry



(Please keep me CC'ed. Thanks.)

Hello,

While testing the SG INQUIRY command to a locked hard drive, connected
with USB, I noted that the command result included garbage that seemed
part of some other's process memory. Like bash functions, command
arguments, etc..

I make sure to memset the buffers before running the ioctl, so this seem
to be data leaked from the kernel.

Most of the code is verbatim from the example in the SCSI Generic HOWTO
(<http://tldp.org/HOWTO/SCSI-Generic-HOWTO/pexample.html>).

I include the code I used and sample output with data from running
processes (or files?).

I can't reproduce this on a firewire connected HDD, but I can with
another USB connecte one (not locked).

Regards,
Luciano Rocha

-- 
lfr
0/0



--Multipart=_Sun__2_Sep_2007_04_56_01_-0700_7fv1EXQCu/XP+bhu
Content-Type: text/plain;
 name="out"
Content-Disposition: attachment;
 filename="out"
Content-Transfer-Encoding: 7bit

# sda is firewire, unlocked, sdb is usb, locked, and sdc is usb, unlocked
$ ./keytool /dev/sda
Some of the INQUIRY command's response:
00 00 04 02 1f 00 00 00 53 41 4d 53 55 4e 47 20  ........SAMSUNG 
48 44 35 30 31 4c 4a 20 20 20 20 20 20 20 20 20  HD501LJ         
43 52 31 30 00 00 00 00 00 00 00 00 00 00 00 00  CR10............
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00 00 00 00 00 00 00 00 00 1d c0 ff ff ff c1 ff  ................
INQUIRY duration=3 millisecs, resid=0
# always the same output for sda


$ ./keytool /dev/sdb
Some of the INQUIRY command's response:
00 00 00 00 1f 00 00 00 4d 41 58 54 4f 52 20 53  ........MAXTOR S
54 4d 33 32 35 30 38 32 30 41 20 20 20 20 20 20  TM3250820A      
33 2e 41 41 11 00 00 00 23 31 31 38 38 32 32 32  3.AA....#1188222
33 34 30 00 11 00 00 00 48 00 12 08 28 00 12 08  340.....H...(...
00 00 00 00 59 00 00 00 64 69 66 66 20 2d 75 72  ....Y...diff -ur
20 2d 2d 65 78 63 6c 75 64 65 20 2e 73 76 6e 20   --exclude .svn 
INQUIRY duration=3 millisecs, resid=60
$ ./keytool /dev/sdb
Some of the INQUIRY command's response:
00 00 00 00 1f 00 00 00 4d 41 58 54 4f 52 20 53  ........MAXTOR S
54 4d 33 32 35 30 38 32 30 41 20 20 20 20 20 20  TM3250820A      
33 2e 41 41 2e 70 6c 20 73 79 6e 63 20 78 70 74  3.AA.pl sync xpt
6f 20 7a 62 72 20 7c 20 6c 65 73 73 00 4c 11 08  o zbr | less.L..
f0 c8 11 08 11 00 00 00 23 31 31 38 38 32 32 32  ........#1188222
33 34 30 00 11 00 00 00 68 c0 11 08 48 c0 11 08  340.....h...H...
INQUIRY duration=3 millisecs, resid=60
$ ./keytool /dev/sdb
Some of the INQUIRY command's response:
00 00 00 00 1f 00 00 00 4d 41 58 54 4f 52 20 53  ........MAXTOR S
54 4d 33 32 35 30 38 32 30 41 20 20 20 20 20 20  TM3250820A      
33 2e 41 41 21 00 00 00 10 2f 12 08 18 2f 12 08  3.AA!..../.../..
00 00 00 00 00 00 00 00 00 00 00 00 24 00 00 00  ............$...
01 00 00 00 19 00 00 00 98 1b 12 08 6d 65 2f 6c  ............me/l
75 63 69 61 6e 6f 00 7d 22 00 10 08 19 00 00 00  uciano.}".......
INQUIRY duration=0 millisecs, resid=60


$ ./keytool /dev/sdc
Some of the INQUIRY command's response:
00 00 00 00 23 00 00 00 57 44 43 20 57 44 32 35  ....#...WDC WD25
30 30 42 42 2d 30 30 52 44 41 30 20 20 20 20 20  00BB-00RDA0     
32 30 2e 30 06 7b 25 07 08 3a 11 08 40 e9 12 08  20.0.{%..:..@...
10 3a 11 08 3b 00 00 00 28 f8 11 08 11 00 00 00  .:..;...(.......
df df df df df df df df 30 00 00 00 11 00 00 00  ........0.......
80 54 13 08 18 20 00 00 00 00 00 00 19 00 00 00  .T... ..........
INQUIRY duration=0 millisecs, resid=56
$ ./keytool /dev/sdc
Some of the INQUIRY command's response:
00 00 00 00 23 00 00 00 57 44 43 20 57 44 32 35  ....#...WDC WD25
30 30 42 42 2d 30 30 52 44 41 30 20 20 20 20 20  00BB-00RDA0     
32 30 2e 30 06 7b 25 07 73 73 68 20 70 00 11 45  20.0.{%.ssh p..E
00 00 00 00 11 00 00 00 23 31 31 38 38 32 30 32  ........#1188202
34 32 30 00 11 00 00 00 58 e0 12 08 38 e0 12 08  420.....X...8...
00 00 00 00 21 00 00 00 63 64 20 2f 70 72 69 76  ....!...cd /priv
INQUIRY duration=3 millisecs, resid=56

...



--Multipart=_Sun__2_Sep_2007_04_56_01_-0700_7fv1EXQCu/XP+bhu
Content-Type: text/plain;
 name="keytool.c"
Content-Disposition: attachment;
 filename="keytool.c"
Content-Transfer-Encoding: 7bit

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>

#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

#include <error.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <scsi/sg.h>
#include <linux/hdreg.h>

static void dump(const unsigned char *b, int l)
{
	int i;

	while (l) {
		for (i = 0; i < l && i < 16; ++i)
			printf("%02x ", b[i]);
		printf(" ");
		for (i = 0; i < l && i < 16; ++i) {
			if (b[i] < 0x20 || b[i] > 0x7e) {
				printf(".");
			} else {
				printf("%c", b[i]);
			}
		}
		printf("\n");
		b += i;
		l -= i;
	}
}

enum { INQ_REPLY_LEN = 96, INQ_CMD_CODE = 0x12, INQ_CMD_LEN = 6 };

static void hdd_ident(const char *device)
{
	unsigned char inqCmdBlk[INQ_CMD_LEN] = {
		INQ_CMD_CODE, 0, 0, 0, INQ_REPLY_LEN, 0
	};
	unsigned char inqBuff[INQ_REPLY_LEN];
	unsigned char sense_buffer[32];
	union {
		struct hd_driveid drv;
		sg_io_hdr_t sg;
	} u;
	int fd;
	int k;

	fd = open(device, O_RDONLY);
	if (fd < 0) error(1, errno, "couldn't open %s", device);

	if (ioctl(fd, HDIO_GET_IDENTITY, &u.drv) >= 0) {
		printf("serial: '%.*s'\n", sizeof u.drv.serial_no,
				u.drv.serial_no);
		printf("model:  '%.*s'\n", sizeof u.drv.model, u.drv.model);
	} else if (ioctl(fd, SG_GET_VERSION_NUM, &k) < 0 || k < 30000) {
		error(1, 0, "device %s isn't an IDE or SCSI device", device);
	} else {
		memset(&u.sg, 0, sizeof u.sg);
		memset(inqBuff, 0, sizeof inqBuff);
		memset(sense_buffer, 0, sizeof sense_buffer);
		u.sg.interface_id = 'S';
		u.sg.cmd_len = sizeof(inqCmdBlk);
		/* u.sg.iovec_count = 0; */  /* memset takes care of this */
		u.sg.mx_sb_len = sizeof(sense_buffer);
		u.sg.dxfer_direction = SG_DXFER_FROM_DEV;
		u.sg.dxfer_len = INQ_REPLY_LEN;
		u.sg.dxferp = inqBuff;
		u.sg.cmdp = inqCmdBlk;
		u.sg.sbp = sense_buffer;
		u.sg.timeout = 20000;     /* 20000 millisecs == 20 seconds */
		/* u.sg.flags = 0; */     /* take defaults: indirect IO, etc */
		/* u.sg.pack_id = 0; */
		/* u.sg.usr_ptr = NULL; */

		if (ioctl(fd, SG_IO, &u.sg) < 0)
			error(1, errno, "couldn't inquire %s", device);

		/* now for the error processing */
		if ((u.sg.info & SG_INFO_OK_MASK) != SG_INFO_OK) {
			if (u.sg.sb_len_wr > 0) {
				printf("INQUIRY sense data: ");
				for (k = 0; k < u.sg.sb_len_wr; ++k) {
					if ((k > 0) && (0 == (k % 10)))
						printf("\n  ");
					printf("0x%02x ", sense_buffer[k]);
				}
				printf("\n");
			}
			if (u.sg.masked_status)
				printf("INQUIRY SCSI status=0x%x\n",
						u.sg.status);
			if (u.sg.host_status)
				printf("INQUIRY host_status=0x%x\n",
						u.sg.host_status);
			if (u.sg.driver_status)
				printf("INQUIRY driver_status=0x%x\n",
						u.sg.driver_status);
		} else {  /* assume INQUIRY response is present */
			printf("Some of the INQUIRY command's response:\n");
			dump(inqBuff, sizeof inqBuff);
			printf("INQUIRY duration=%u millisecs, resid=%d\n",
					u.sg.duration, u.sg.resid);
		}
	}
	close(fd);

}

int main(int argc, char *argv[])
{
	char *device;
	char *eeprom;

	while (*++argv) {
		hdd_ident(*argv);
	}
	return 0;
}



--Multipart=_Sun__2_Sep_2007_04_56_01_-0700_7fv1EXQCu/XP+bhu--
