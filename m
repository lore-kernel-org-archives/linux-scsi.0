From: linux-scsi-031126@amos.mailshell.com
Subject: 2.6test10: Annoying "CDROM not ready" messages once a second
Date: Wed, 26 Nov 2003 15:41:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031126134041.25698.qmail@mailshell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www11.mailshell.com ([209.157.66.249]:47246 "HELO mailshell.com")
	by vger.kernel.org with SMTP id S262569AbTKZNkp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 08:40:45 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I've just moved to 2.6test10 from test9 and startted getting messages
like:

sr0: CDROM not ready.  Make sure there is a disc in the drive.

Once a second.  From googling around I see that it's a very old problem
but I haven't found a solution for it.

It seems to come from drivers/scsi/sr_ioctl.c line 139, where there
is:

      138                         if (!cgc->quiet)
      139                                 printk(KERN_INFO "%s: CDROM not
ready.
      139 Make sure there is a disc in the drive.\n", cd->cdi.name);
      140 #ifdef DEBUG
      141                         print_req_sense("sr", SRpnt);
      142 #endif
      143                         err = -ENOMEDIUM;

But I don't see where can I set cgc->quiet to be non-zero.

For now I stick some CD in the drive to keep this quite, but I'd rather
not do this because if the machine reboots it delays on trying to boot
from the CD.

My system is an AMD Athlon, no SCSI devices (I need generic SCSI only
for cd burning software and USB access, I'm aware that it's supposed to
be gone in 2.6 but the software I use is still not aware of this).
Preemption enabled (no problems from that part).

Please CC me with replys, I'm not on the list.

Thanks,

--Amos Shapira


