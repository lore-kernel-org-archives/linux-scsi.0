From: Giuliano Pochini <pochini@shiny.it>
Subject: sg_io(READ_TOC) crash
Date: Sat, 22 Nov 2008 18:41:12 +0100
Message-ID: <20081122184112.3914d595.pochini@shiny.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:1371 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbYKVRxK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Nov 2008 12:53:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


With very few CDs readcd (cdrtools) causes a hard lock up. I tracked the
bug down to block/scsi_ioctl.c::sg_io() when blk_execute_rq() is called. I
guess it crashes in block/blk-exec.c::blk_execute_rq_nowait() while the
spinlock is held. I need help to locate the bug.

My box is a dual G4 with an IDE DVD-RW:
Linux Jay 2.6.27 #2 SMP Wed Oct 15 00:33:06 CEST 2008 ppc 7455, altivec supported PowerMac3,6 GNU/Linux

The same CD on an x86 box does not crash.

The following is a simple program to reproduce the bug when that CD is in:

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <scsi/sg.h>

int main() {
  int fd, ret;
  sg_io_hdr_t sg_io;
  unsigned char databuffer[256];
  unsigned char sensebuffer[SG_MAX_SENSE];

  fd=open("/dev/hdf", O_RDONLY);
  if (fd<0) {
    printf("error: %s\n", strerror(errno));
    return(errno);
  }

  memset(&sg_io, 0, sizeof(sg_io));
  sg_io.interface_id = 'S';
  sg_io.dxfer_direction = SG_DXFER_FROM_DEV;
  sg_io.cmd_len = 10;
  sg_io.mx_sb_len = SG_MAX_SENSE;
  sg_io.dxfer_len = 191;
  sg_io.dxferp = databuffer;
  sg_io.cmdp = (unsigned char [10]){0x43, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0xbf, 0x00};
  sg_io.sbp = sensebuffer;
  sg_io.timeout = 10*1000;
  sg_io.flags |= SG_FLAG_DIRECT_IO;
  ret = ioctl(fd, SG_IO, &sg_io);
  close(fd);
  return(0);
}


--
Giuliano.
