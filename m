From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: dc395x: can't write to tape
Date: Thu, 6 Jan 2005 05:18:25 -0500
Message-ID: <200501060518.25782.andrex@alumni.utexas.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([216.148.227.85]:58759 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S262804AbVAFKSn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2005 05:18:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a Travan NS-20 tape drive connected to a Tekram DC395UW controller.  
Both have worked without trouble for years.  My kernel is 2.6.7, and I use 
the dc395x driver (built as a module) from the kernel source. 

Since about a month ago, I can't write a tar archive to tape.  The operation 
aborts before completion:

# tar -vv --one-file-system --file=/dev/st0 --create / /boot /home
tar: Removing leading `/' from member names
tar: /dev/st0: Wrote only 0 of 10240 bytes
tar: Error is not recoverable: exiting now

I've cleaned the drive with the approved head cleaner, tried three 
different tapes, and retensioned each tape before writing.  Still no joy.  I 
haven't rebuilt my kernel since the problem started, so it seems likely to be 
a hardware problem.

/var/log/kern.log says

Jan  5 22:50:18 helium kernel: dc395x: sg_update_list: sg_to_virt failed
Jan  5 22:50:18 helium kernel: st0: Error with sense data: Info fld=0x67, 
Current st0: sense = f0  4
Jan  5 22:50:18 helium kernel: ASC=80 ASCQ=98
Jan  5 22:50:18 helium kernel: Raw sense data:0xf0 0x00 0x04 0x00 0x00 0x00 
0x67 0x0a 0x00 0x00 0x00 0x00 0x80 0x98 0x00 0x00 0x00 0x00
Jan  5 22:50:18 helium kernel: st0: Error with sense data: Current st0: sense 
= 70  4
Jan  5 22:50:18 helium kernel: ASC=80 ASCQ=98
Jan  5 22:50:18 helium kernel: Raw sense data:0x70 0x00 0x04 0x00 0x00 0x00 
0x00 0x0a 0x00 0x00 0x00 0x00 0x80 0x98 0x00 0x00 0x00 0x00
Jan  5 22:50:18 helium kernel: st0: Error on write filemark.
Jan  5 22:50:18 helium kernel: st0: Error with sense data: Info 
fld=0xffffff63, Current st0: sense = f0  4
Jan  5 22:50:18 helium kernel: ASC=80 ASCQ=98
Jan  5 22:50:18 helium kernel: Raw sense data:0xf0 0x00 0x04 0xff 0xff 0xff 
0x63 0x0a 0x00 0x00 0x00 0x00 0x80 0x98 0x00 0x00 0x00 0x00

Question: from this log output, can anyone tell if my problem is more 
likely in the controller, or in the tape drive?  I realize there's not a lot 
of data there... unfortunately even that doesn't mean anything to me.

To get more information, I uncommented

#define DEBUG_MASK (DBG_0|DBG_1|DBG_SG|DBG_FIFO|DBG_PIO)

in drivers/scsi/dc395x.c, rebuilt and reinserted the module, and tried to tar 
again.  But this resulted in multi-GB log files, so if there's a smaller 
subset of debug options that would be useful, please let me know and I'll try 
again.

I'd like very much to keep using this tape drive for several more years.  It's 
noisy and slow, but 10 GB/tape still isn't bad, and to replace the drive and 
6 tapes would cost around $400, even today.

OTOH, SCSI cards are cheap and I wouldn't mind junking my old DC395 if it's at 
fault.

Thanks in advance for any light you can shed.
Andrew.
