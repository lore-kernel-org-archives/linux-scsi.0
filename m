From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Fw: 2.6.14: aic7xxx broken with blktool
Date: Fri, 28 Oct 2005 23:23:06 +1000
Message-ID: <4362263A.1060009@torque.net>
References: <20051028040227.37dfef86.akpm@osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:64690 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751381AbVJ1NWM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 09:22:12 -0400
In-Reply-To: <20051028040227.37dfef86.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Meelis Roos <mroos@linux.ee>

Andrew Morton wrote:
> 
> Begin forwarded message:
> 
> Date: Fri, 28 Oct 2005 12:03:12 +0300 (EEST)
> From: Meelis Roos <mroos@linux.ee>
> To: Linux Kernel list <linux-kernel@vger.kernel.org>
> Subject: 2.6.14: aic7xxx broken with blktool
> 
> 
> I'm using blktool to find info about installed disks. With Debian's 
> 2.6.8, "blktool /dev/sda id" worked fine. With 2.6.14 it's broken (see 
> below). Adaptec 2940UW with a 4.5G Quantum Viking II disk.
> 
> It outputs random data from memory as a response to the scsi command, 
> different recent strings different times.
> 
> Otherwise the disk works OK.
> 
> blktools is from Debian Sarge, package version 4-2, and works fine with 
> 2.6.8-2-686-smp kernel from Debian.

As the log indicated, a command was aborted, possibly the
INQUIRY. blktool (version 4.2) doesn't seem to do any SG_IO
error processing, so if an error was returned then it
would not have known and just assumed the INQUIRY response
buffer had been filled. sdparm is a little more rigorous
in the error checking area and it has been burnt by the
block layer SG_IO yielding a false positive. So I now
prefill the INQUIRY response buffer with 0x7f in buf[0]
and zero in the rest.

My guess is that the kernel problem is with the aic7xxx
driver in lk 2.6.14 .


While glancing at blktool scsi.c (version 4.2) I was
surprised by the brevity of handle_scsi_wcache() which
implements "wcache on|off" for SCSI disks. It ain't
that simple and a test indicated that version doesn't
work.

Doug Gilbert
