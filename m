From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Fri, 11 Jun 2004 10:23:21 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40C8FB79.1050706@torque.net>
References: <1086710016.3647.4.camel@patibmrh9>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:41989 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263448AbUFKBaE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 21:30:04 -0400
In-Reply-To: <1086710016.3647.4.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> Doug G:
> 
> Did I do something wrong, or does "everyone know" already,
> 
> SCSI pass thru in 2.6 omits ide-floppy, except if we do resort to the
> ide-scsi deprecated there?

Pat,
In lk 2.6 the ide-scsi driver is "deprecated" for cd/dvd device types
but not other device types that use the ATAPI protocol. The ide-scsi
driver is in the same group as the usb-storage and sbp2 drivers which
bridge between the SCSI stack and other subsystem stacks. The
ongoing problems we have with this group of drivers is as much to
do with their technical complexity (spanning two different driver
architectures) as it is to do with the politics of kernel
development.

Anyway ide-scsi probably needs some repair work in lk 2.6. Both
Willem Riede and I have tried. IMO the ide-scsi driver looks ok
from the scsi subsystem side ....

> Or more specifically,
> 
> Can ioctl SG_IO fetch the offset 7 Additional Length field of op x03
> "REQUEST SENSE" data?
> 
> Naively I thought yes of course, I know that works with /dev/scd$n.
> 
> But then I tried a /dev/hd$v ide-floppy.  No joy.  perror tells me ioctl
> SG_IO fails via "Invalid argument", dmesg has no comment.  sg_scan you
> know.  ~/bin/sgio source is the trivial exercise quoted in source far
> below, specifically with an O_NONBLOCK|O_RDWR open as you can see.

My method with the SG_IO ioctl was to yield errnos
if the SCSI command could not be sent (or was rejected
at the point of transmission). So if there is an errno
there will be no sense buffer (or any other valid
response data). It is only when a response to the SCSI
command is received that errno will be clear (and the
various status variables should be checked).

> $ sudo sg3_utils-1.06/sg_scan /dev/hdd /dev/scd0
> sg_scan: device /dev/hdd failed on scsi ioctl, skip: Input/output error
> /dev/scd0: scsi0 channel=0 id=0 lun=0 [em]
> $
> $ sudo ~/bin/sgio /dev/hdd /dev/scd0 | strings
> ioctl SG_IO: Invalid argument
> Iomega  RRD             74.B
> $
> 
> $ uname -srm
> Linux 2.6.7-rc2 i686
> $ lsmod | grep ide
> ide_floppy             17664  0
> $ sudo mount /dev/hdd /mnt/hdd
> $ sudo umount /dev/hdd
> $ alias xstrings="tr -d ' \r\n' | perl -wpe 's/(..)/chr hex \$1/eg' |
> strings"
> $ sudo cat /proc/ide/hdd/identify | xstrings
> 803048B34F460C1E
> 25.Q    IOMEGA  ZIP 250       ATAPI
> (c) Copyright IOMEGA 2002
> 601//320
> $

Perhaps you could sent me the "strace" of this failure so
I can have a closer look at what is going on.

> Pat LaVarre
> 
> P.S. I fell into trying all this when a friend not yet living in Linux
> noticed my recent linux-ide report of a SATAPI host choking over an
> available sense length rudely not aligned to four bytes.

The underlying serial protocols used by sATA and SAS do
seem to be in units of "dwords" (i.e. 4 byte quantities).
I have noticed several SCSI standards changing the maximum
allocation length of a one byte field (e.g. in an INQUIRY
and MODE SENSE(6) ) from 255 to 252. The intent seems to be
to have lengths that are multiples of 4.

> ----- ~/bin/sgio.c
> 
> #include <fcntl.h>
> #include <scsi/sg.h>
> #include <stdio.h>
> #include <sys/ioctl.h>
> #include <string.h>
> #include <unistd.h>
> 
> static unsigned char static_cdb[0x100];
> static unsigned char static_data[0x1000];
> static unsigned char static_sense[0x100];
> 
> static void populate(sg_io_hdr_t * sih)
> {
> 	memset(sih, '\0', sizeof *sih);
> 	sih->interface_id = 'S';
> 
> 	memset(&static_cdb, '\0', sizeof static_cdb);
> 	sih->cmdp = static_cdb;
> 	sih->cmd_len = 6;
> 	memcpy(sih->cmdp, "\x12\0\0\0\x24\0", sih->cmd_len);
> 
> 	memset(&static_data, '\0', sizeof static_data);
> 	sih->dxferp = static_data;
> 	sih->dxfer_len = 0x24;
> 	sih->dxfer_direction = SG_DXFER_NONE;
> 	sih->dxfer_direction = SG_DXFER_TO_DEV;
> 	sih->dxfer_direction = SG_DXFER_FROM_DEV;

The three above lines look a bit strange :-)

> 	memset(&static_sense, '\0', sizeof static_sense);
> 	sih->sbp = static_sense;
> 	sih->mx_sb_len = 0x12; /* SATAPI may need 4 byte alignment */
> 	sih->timeout = 30 * 1000; /* ms */
> 
> 	; /* sih->iovec_count sih->flags sih->pack_id sih->usr_ptr */
> 	; /* sih->status sih->masked_status sih->msg_status */
> 	; /* sih->sb_len_wr sih->host_status sih->drive_status */
> 	; /* sih->resid sih->duration sih->info */
> }
> 
> static void talk(int fd)
> {
> 	static sg_io_hdr_t static_sih;
> 	sg_io_hdr_t * sih = &static_sih;
> 	int ii;
> 	populate(sih);
> 	ii = ioctl(fd, SG_IO, sih);
> 	if (ii < 0) {
> 		perror("ioctl SG_IO");
> 	} else {
> 		fwrite(sih->dxferp, sih->dxfer_len, 1, stdout);
> 		if ((sih->info & SG_INFO_OK_MASK) != SG_INFO_OK) {
> 			fprintf(stderr, "x %X %X %X\n",
> 				sih->info, sih->resid, sih->sb_len_wr);
> 		}
> 	}
> }
> 
> int main(int argc, char * argv[])
> {
> 	int ix = 0;
> 	--argc; ++argv;
> 	for (ix = 0; ix < argc; ++ix)
> 	{
> 		int fd = open(argv[ix], O_NONBLOCK|O_RDWR);
> 		if (fd < 0) {
> 			perror("open");
> 		} else {
> 			int vn = 0;
> 			if (0 <= ioctl(fd, SG_GET_VERSION_NUM, &vn)) {
> 				if (vn < 30000) {
> 					perror("ioctl SG_GET_VERSION_NUM");
> 					continue;
> 				}

Note: I have started to drop this SG_GET_VERSION_NUM ioctl()
check. It is still needed in the special case where the sg
driver is working asynchronously (i.e. sending commands with
write() and receiving the response with read() ).

> 			}
> 			talk(fd);
> 			close(fd);
> 		}
> 	}
> 	return 0;
> }

Doug Gilbert


