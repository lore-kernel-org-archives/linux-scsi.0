From: Joachim Geiler <Joachim.Geiler@t-online.de>
Subject: Re: cdrom_ioctl() hanging in 2.6.3
Date: Mon, 23 Feb 2004 20:58:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <c1dlvr$hc3$1@sea.gmane.org>
References: <20040222134723.7de65a50.akpm@osdl.org> <c1c43f$pm4$1@sea.gmane.org>
Reply-To: Joachim.Geiler@t-online.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.224.249]:59326 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S262006AbUBWT5u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 14:57:50 -0500
Received: from list by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1AvMD8-0005Xs-00
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2004 20:57:50 +0100
Received: from p50912f78.dip.t-dialin.net ([80.145.47.120])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon Feb 23 19:57:50 2004
Received: from Joachim.Geiler by p50912f78.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon Feb 23 19:57:50 2004
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Joachim Geiler wrote:

> Andrew Morton wrote:
> 
>> 
>> Gents,
>> 
>> apparently KDE's `k3b' command is consistently hanging when accessing a
>> SCSI CDROM.  See http://bugs.kde.org/show_bug.cgi?id=75553
>> 
>> Frank has generated a stack backtrace, below.
>> 
>> Is this an adaptec driver problem, or a generic thing?
>> 
>> Thanks.

Hello again,

I did a strace of the syscalls of k3b before it hangs (kernel 2.6.3mm2). I
think the following tail of the trace may be of interest:


lstat64("/dev/sr0", {st_mode=S_IFBLK|0660, st_rdev=makedev(11, 0), ...}) = 0
open("/dev/sr0", O_RDONLY|O_NONBLOCK)   = 12
fstat64(12, {st_mode=S_IFBLK|0660, st_rdev=makedev(11, 0), ...}) = 0
ioctl(12, 0x5321, 0x1)                  = 12
close(12)                               = 0
open("/dev/sr0", O_RDONLY|O_NONBLOCK)   = 12
fstat64(12, {st_mode=S_IFBLK|0660, st_rdev=makedev(11, 0), ...}) = 0
ioctl(12, 0x5382, 0xbfffdc58)           = 0
ioctl(12, 0x5386, 0xbfffdd24)           = 0
close(12)                               = 0
open("/dev/sr0", O_RDONLY|O_NONBLOCK)   = 12
ioctl(12, 0x5393 <unfinished ...>

Here the process hangs in D state....

/dev/sr0 is a yamaha cdrw 6416 at symbios 53c875.


Joachim
 

