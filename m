From: Michael Cree <mcree@orcon.net.nz>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Sun, 09 Dec 2007 13:51:47 +1300
Message-ID: <475B3C23.6010304@orcon.net.nz>
References: <20071208050517.EC35EDBA2@gherkin.frus.com> <1197128912.5483.51.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loadbalancer2.orcon.net.nz ([219.88.242.4]:54685 "EHLO
	mx5.orcon.net.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753297AbXLIAv6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Dec 2007 19:51:58 -0500
Received: from Debian-exim by mx5.orcon.net.nz with local (Exim 4.67)
	(envelope-from <mcree@orcon.net.nz>)
	id 1J1AOj-00011s-0R
	for linux-scsi@vger.kernel.org; Sun, 09 Dec 2007 13:51:57 +1300
In-Reply-To: <1197128912.5483.51.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Bob Tracy <rct@frus.com>, Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com

Kay Sievers wrote:
> On Fri, 2007-12-07 at 23:05 -0600, Bob Tracy wrote:
>> Kay Sievers wrote:
>>> Is the udev daemon (still) running while it fails?
>> Yes, and there's something else I forgot to mention that may be
>> significant...  For the bad case, in addition to udevd, "ps -ef"
>> shows a "sh -e /lib/udev/net.agent" running with a PPID of 1.  This
>> process doesn't exit until I reboot.  If this is normal under the
>> circumstances, please disregard.
> 
> Does SysRq-T show where it hangs?

Ummm... No.  I didn't have the CONFIG_MAGIC_SYSRQ flag set, so I set it, 
and recompiled the kernel.  Guess what - now the system comes up 
normally without any problem.  The block devices appear in /dev.  To 
recap: without CONFIG_MAGIC_SYSRQ on the 2.6.24-rc3 kernel the missing 
block devices error in /dev occurs and the init scripts fall over on 
startup, and with CONFIG_MAGIC_SYSRQ the system comes up normally.

To answer the earlier questions about distro, and udev version, my 
system is similar to Bob's, except that I am running Debian 
testing/lenny which comes with udev version 114 (dpkg reports udev 
version 0.114-2).  I am running an EV67 variant CPU.

I do not run an initramfs - I have the necessary drivers for the various 
discs compiled into the kernel and use the root kernel option to point 
to the required root partition.

When running the broken kernel udev is running (according to 'ps') and 
executing /sbin/udevtrigger manually generates a number of errors of the 
form:

scsi_id[<pid>]: scsi_id: unable to access '/block'

The missing /dev/* entries do not appear.

Cheerz
Michael.
