From: Pat LaVarre <p.lavarre@ieee.org>
Subject: sense visible despite ide-floppy in 2.6 maybe
Date: 08 Jun 2004 09:53:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086710016.3647.4.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:39581 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265233AbUFHPxr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 11:53:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug G:

Did I do something wrong, or does "everyone know" already,

SCSI pass thru in 2.6 omits ide-floppy, except if we do resort to the
ide-scsi deprecated there?

Or more specifically,

Can ioctl SG_IO fetch the offset 7 Additional Length field of op x03
"REQUEST SENSE" data?

Naively I thought yes of course, I know that works with /dev/scd$n.

But then I tried a /dev/hd$v ide-floppy.  No joy.  perror tells me ioctl
SG_IO fails via "Invalid argument", dmesg has no comment.  sg_scan you
know.  ~/bin/sgio source is the trivial exercise quoted in source far
below, specifically with an O_NONBLOCK|O_RDWR open as you can see.

$ sudo sg3_utils-1.06/sg_scan /dev/hdd /dev/scd0
sg_scan: device /dev/hdd failed on scsi ioctl, skip: Input/output error
/dev/scd0: scsi0 channel=0 id=0 lun=0 [em]
$
$ sudo ~/bin/sgio /dev/hdd /dev/scd0 | strings
ioctl SG_IO: Invalid argument
Iomega  RRD             74.B
$

$ uname -srm
Linux 2.6.7-rc2 i686
$ lsmod | grep ide
ide_floppy             17664  0
$ sudo mount /dev/hdd /mnt/hdd
$ sudo umount /dev/hdd
$ alias xstrings="tr -d ' \r\n' | perl -wpe 's/(..)/chr hex \$1/eg' |
strings"
$ sudo cat /proc/ide/hdd/identify | xstrings
803048B34F460C1E
25.Q    IOMEGA  ZIP 250       ATAPI
(c) Copyright IOMEGA 2002
601//320
$

Pat LaVarre

P.S. I fell into trying all this when a friend not yet living in Linux
noticed my recent linux-ide report of a SATAPI host choking over an
available sense length rudely not aligned to four bytes.

----- ~/bin/sgio.c

#include <fcntl.h>
#include <scsi/sg.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <string.h>
#include <unistd.h>

static unsigned char static_cdb[0x100];
static unsigned char static_data[0x1000];
static unsigned char static_sense[0x100];

static void populate(sg_io_hdr_t * sih)
{
	memset(sih, '\0', sizeof *sih);
	sih->interface_id = 'S';

	memset(&static_cdb, '\0', sizeof static_cdb);
	sih->cmdp = static_cdb;
	sih->cmd_len = 6;
	memcpy(sih->cmdp, "\x12\0\0\0\x24\0", sih->cmd_len);

	memset(&static_data, '\0', sizeof static_data);
	sih->dxferp = static_data;
	sih->dxfer_len = 0x24;
	sih->dxfer_direction = SG_DXFER_NONE;
	sih->dxfer_direction = SG_DXFER_TO_DEV;
	sih->dxfer_direction = SG_DXFER_FROM_DEV;

	memset(&static_sense, '\0', sizeof static_sense);
	sih->sbp = static_sense;
	sih->mx_sb_len = 0x12; /* SATAPI may need 4 byte alignment */
	sih->timeout = 30 * 1000; /* ms */

	; /* sih->iovec_count sih->flags sih->pack_id sih->usr_ptr */
	; /* sih->status sih->masked_status sih->msg_status */
	; /* sih->sb_len_wr sih->host_status sih->drive_status */
	; /* sih->resid sih->duration sih->info */
}

static void talk(int fd)
{
	static sg_io_hdr_t static_sih;
	sg_io_hdr_t * sih = &static_sih;
	int ii;
	populate(sih);
	ii = ioctl(fd, SG_IO, sih);
	if (ii < 0) {
		perror("ioctl SG_IO");
	} else {
		fwrite(sih->dxferp, sih->dxfer_len, 1, stdout);
		if ((sih->info & SG_INFO_OK_MASK) != SG_INFO_OK) {
			fprintf(stderr, "x %X %X %X\n",
				sih->info, sih->resid, sih->sb_len_wr);
		}
	}
}

int main(int argc, char * argv[])
{
	int ix = 0;
	--argc; ++argv;
	for (ix = 0; ix < argc; ++ix)
	{
		int fd = open(argv[ix], O_NONBLOCK|O_RDWR);
		if (fd < 0) {
			perror("open");
		} else {
			int vn = 0;
			if (0 <= ioctl(fd, SG_GET_VERSION_NUM, &vn)) {
				if (vn < 30000) {
					perror("ioctl SG_GET_VERSION_NUM");
					continue;
				}
			}
			talk(fd);
			close(fd);
		}
	}
	return 0;
}


