From: "Thomas Schmitt" <scdbackup@gmx.net>
Subject: PROBLEM: cdrom.c : cdrom_get_last_written() yields up to 3 different values
Date: Wed, 09 Mar 2016 14:19:29 +0100
Message-ID: <402957494985385949@scdbackup.webframe.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54359 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582AbcCINTB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2016 08:19:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org

cdrom.c : cdrom_get_last_written() yields up to 3 different values

----------------------------------------------------------------------
Full description of the problem:

Depending on the capabilities of the optical drive involved, the function
cdrom_get_last_written() can yield up to 3 different results with the same CD.
The function has 4 callers with at least 2 different expectations.

This is not one of the known drive quirks but a matter of slightly different
semantics of the different SCSI reply fields used.

With a TAO CD there are three possible outcomes:
  payload size - 1, payload size, payload size + 2

With a SAO CD there are 2 different results:
  payload size - 1, payload size

--------------------------
The 3 result variants are:

1) If the drive does not sufficiently react on GET DISC INFORMATION
  or READ TRACK INFORMATION, then the function falls back to label
  "use_toc:" which uses READ TOC/PMA/ATIP to inquire the start of the
  Lead-out:
    toc.cdte_addr.lba

  This is the payload size of the TAO CD plus 2 run-out blocks.

  With a SAO CD it is the payload size.

  None of my 7 drives would go this path.

2) If the reply to READ TRACK INFORMATION of the last track does not have
  the LRA_V bit set (i.e. the Last Recorded Address field is not valid),
  then the function falls back to the reply fields Logical Track Start Address
  and Logical Track Size:
     be32_to_cpu(ti.track_start) + be32_to_cpu(ti.track_size)

  This is the payload size of the TAO CD on 6 of my 7 drives.
  (One of them has LRA_V set, though, and thus takes path 3.
   My oldest DVD-ROM returns payload + run-out, which is equal to the
   Lead-out start reported by READ TOC/PMA/ATIP. For this lie, the kernel
   is not to blame.)

  With SAO this is the payload size.

3) If the READ TRACK INFORMATION reply has LRA_V set, then the function
  uses the value of the reply field Last Recorded Address:
    be32_to_cpu(ti.last_rec_address)
  This reply field is promised by MMC-5 only for [HD]DVD-R[W] and BD-R
  media. (See MMC-5, 6.27.3.18 "Last Recorded Address".)

  It is supposed to be the address of the last payload block.
  I.e. payload size - 1. SAO and TAO alike.

  Only one of my drives has the LRA_V bit set with CD-RW.

------------------
The 4 callers are:

a) drivers/scsi/sr.c : get_sectorsize()
  Obviously expects payload size.
  (This is the one i am actually interested in.)

b) drivers/ide/ide-cd.c : ide_cd_read_toc()
  Obviously expects payload size.

c) drivers/cdrom/cdrom.c : cdrom_get_next_writable()
  Falls back to cdrom_get_last_written() and adds 7 to the value.
  (I am curious about the reasoning for 7 and whether it shall
   be added to payload size or to payload size - 1.)

d) drivers/cdrom/cdrom.c : mmc_ioctl_cdrom_last_written()  
  Implements ioctl(CDROM_LAST_WRITTEN) which promises "get last block
  written on disc" in include/uapi/linux/cdrom.h.
  So this expects payload size - 1.

No caller seems to expect payload size + 2.

----------------------------------------------------------------------
Source inspected:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git

(I came to the problem when i examined the possibility to let the
 last block address from READ TRACK INFORMATION override the reply
 of READ CAPACITY if it gets deceived by TAO tracks.
 It would fix the TAO CD end problems for 4 of my 5 lying drives.)

----------------------------------------------------------------------
Hardware behavior:

Example READ TRACK INFORMATION transactions of my drives (libburn log)
with a TAO CD with 51623 payload blocks:

'TSSTcorp' 'DVD-ROM SH-D162C' reports 0xc9a9 = 51625:
  READ TRACK INFORMATION
  52 01 00 00 00 01 00 00 22 00
  From drive: 34b
  00 2e 01 01 00 04 01 00 00 00 00 00 00 00 c9 a9 00 00 00 00
  00 00 00 00 00 00 c9 a9 00 a2 00 00 00 00

'TSSTcorp' 'CDDVDW SH-S223B' reports 0xc9a7 = 51623:
  READ TRACK INFORMATION
  52 01 00 00 00 01 00 00 22 00
  From drive: 34b
  00 1a 01 01 00 04 81 00 00 00 00 00 ff ff ff ff 00 00 00 00
  00 00 00 00 00 00 c9 a7 00 a2 00 00 00 00

'HL-DT-ST' 'BDDVDRW GGC-H20L'
'HL-DT-ST' 'DVDRAM GH24NSC0'
'HL-DT-ST' 'BD-RE GGW-H20L'
'HL-DT-ST' 'BD-RE BH16NS40' report 0xc9a7 = 51623:
  READ TRACK INFORMATION
  52 01 00 00 00 01 00 00 22 00
  From drive: 34b
  00 22 01 01 00 04 01 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 c9 a7 00 00 00 00 00 00

'Optiarc ' 'BD RW BD-5300S' reports LRA_V == 1 and
                            Last Recorded Address 0xc9a6 = 51622:
  READ TRACK INFORMATION
  52 01 00 00 00 01 00 00 22 00
  From drive: 34b
  00 2e 01 01 00 04 81 02 00 00 00 00 ff ff ff ff 00 00 00 00
  00 00 00 00 00 00 c9 a7 00 00 c9 a6 00 00

All look the same with READ TOC/PMA/ATIP format 2 ("raw"):

  READ TOC/PMA/ATIP
  43 02 02 00 00 00 00 00 30 00
  From drive: 48b
  00 2e 01 01 01 14 00 a0 00 00 00 00 01 00 00 01 14 00 a1 00
  00 00 00 01 00 00 01 14 00 a2 00 00 00 00 0b 1e 19 01 14 00
  01 00 00 00 00 00 02 00

which means:
  Lead-out start ("a2") at 0x0b minutes, 0x1e seconds, 0x19 frames - 150
  = 51775 - 150 = 51625

----------------------------------------------------------------------

Have a nice day :)

Thomas

