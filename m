From: Michael Cree <mcree@orcon.net.nz>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Sat, 08 Dec 2007 09:43:27 +1300
Message-ID: <4759B06F.60108@orcon.net.nz>
References: <20071207145526.B561CDBA2@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loadbalancer2.orcon.net.nz ([219.88.242.4]:36124 "EHLO
	mx5.orcon.net.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753337AbXLGUne (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 15:43:34 -0500
Received: from Debian-exim by mx5.orcon.net.nz with local (Exim 4.67)
	(envelope-from <mcree@orcon.net.nz>)
	id 1J0k2m-0001HC-GH
	for linux-scsi@vger.kernel.org; Sat, 08 Dec 2007 09:43:32 +1300
In-Reply-To: <20071207145526.B561CDBA2@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@frus.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com

Bob Tracy wrote:
> That was quick :-).  Backing out the sysctl_check.c diff gives me a
> working kernel.  Beats the #$%@! out of me how/why, though.
> 
> Michael Cree: could you try backing out the diff below from your
> 2.6.24-rc3 tree and see if things are now working for you?

Yes (conference is now over).  I backed out the sysctl_check patch from 
2.6.24-rc3 and, indeed, got a working kernel.

The working kernel (was probably 2.6.24-rc3 less sysctl_check patch, but 
might have been a 2.6.23 variant) has the following in /sys/block

alpha:~# ls -l /sys/block/
total 0
drwxr-xr-x  5 root root 0 2007-12-08 08:55 fd0
drwxr-xr-x  6 root root 0 2007-12-08 08:55 hde
drwxr-xr-x  5 root root 0 2007-12-08 08:55 hdf
drwxr-xr-x 10 root root 0 2007-12-08 08:55 sda
drwxr-xr-x  9 root root 0 2007-12-08 08:55 sdb
alpha:~# ls -l /sys/block/sda
total 0
-r--r--r-- 1 root root 8192 2007-12-08 08:55 capability
-r--r--r-- 1 root root 8192 2007-12-08 08:55 dev
lrwxrwxrwx 1 root root    0 2007-12-08 08:55 device -> 
../../devices/pci0001:01/0001:01:06.0/host0/target0:0:1/0:0:1:0
drwxr-xr-x 2 root root    0 2007-12-08 08:55 holders
drwxr-xr-x 3 root root    0 2007-12-08 08:55 queue
-r--r--r-- 1 root root 8192 2007-12-08 08:55 range
-r--r--r-- 1 root root 8192 2007-12-08 08:55 removable
drwxr-xr-x 3 root root    0 2007-12-08 08:55 sda1
drwxr-xr-x 3 root root    0 2007-12-08 08:55 sda2
drwxr-xr-x 3 root root    0 2007-12-08 08:55 sda3
drwxr-xr-x 3 root root    0 2007-12-08 08:55 sda4
drwxr-xr-x 3 root root    0 2007-12-08 08:55 sda5
-r--r--r-- 1 root root 8192 2007-12-08 08:55 size
drwxr-xr-x 2 root root    0 2007-12-08 08:55 slaves
-r--r--r-- 1 root root 8192 2007-12-08 08:55 stat
lrwxrwxrwx 1 root root    0 2007-12-08 08:55 subsystem -> ../../block
--w------- 1 root root 8192 2007-12-08 08:55 uevent
alpha:~# grep . /sys/block/sda/*/dev
/sys/block/sda/sda1/dev:8:1
/sys/block/sda/sda2/dev:8:2
/sys/block/sda/sda3/dev:8:3
/sys/block/sda/sda4/dev:8:4
/sys/block/sda/sda5/dev:8:5



The broken kernel (2.6.24-rc3) has the following in /sys/block

alpha:~# ls -l /sys/block/
total 0
drwxr-xr-x  5 root root 0 Dec  8 09:22 fd0
drwxr-xr-x  6 root root 0 Dec  8 09:22 hde
drwxr-xr-x  5 root root 0 Dec  8 09:23 hdf
drwxr-xr-x 10 root root 0 Dec  8 09:22 sda
drwxr-xr-x  9 root root 0 Dec  8 09:23 sdb
alpha:~# ls -l /sys/block/sda
total 0
-r--r--r-- 1 root root 8192 Dec  8 09:22 capability
-r--r--r-- 1 root root 8192 Dec  8 09:22 dev
lrwxrwxrwx 1 root root    0 Dec  8 09:23 device -> 
../../devices/pci0001:01/0001:01:06.0/host0/target0:0:1/0:0:1:0
drwxr-xr-x 2 root root    0 Dec  8 09:22 holders
drwxr-xr-x 3 root root    0 Dec  8 09:22 queue
-r--r--r-- 1 root root 8192 Dec  8 09:22 range
-r--r--r-- 1 root root 8192 Dec  8 09:22 removable
drwxr-xr-x 3 root root    0 Dec  8 09:22 sda1
drwxr-xr-x 3 root root    0 Dec  8 09:22 sda2
drwxr-xr-x 3 root root    0 Dec  8 09:22 sda3
drwxr-xr-x 3 root root    0 Dec  8 09:22 sda4
drwxr-xr-x 3 root root    0 Dec  8 09:22 sda5
-r--r--r-- 1 root root 8192 Dec  8 09:22 size
drwxr-xr-x 2 root root    0 Dec  8 09:22 slaves
-r--r--r-- 1 root root 8192 Dec  8 09:22 stat
lrwxrwxrwx 1 root root    0 Dec  8 09:22 subsystem -> ../../block
--w------- 1 root root 8192 Dec  8 09:22 uevent
alpha:~# grep . /sys/block/sda/*/dev
/sys/block/sda/sda1/dev:8:1
/sys/block/sda/sda2/dev:8:2
/sys/block/sda/sda3/dev:8:3
/sys/block/sda/sda4/dev:8:4
/sys/block/sda/sda5/dev:8:5

I failed to spot any difference (other than the formatting of the dates) 
between the two!

Cheers
Michael.

