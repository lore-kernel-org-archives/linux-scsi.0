From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: arcmsr & areca-1660 - strange behaviour under heavy load
Date: Sun, 24 Feb 2008 16:10:34 -0800
Message-ID: <20080224161034.f494fc7f.akpm@linux-foundation.org>
References: <alpine.LRH.0.9999.0802231201380.21313@linuxbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760801AbYBYAK7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 19:10:59 -0500
In-Reply-To: <alpine.LRH.0.9999.0802231201380.21313@linuxbox.linuxbox.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Nick Cheng <nick.cheng@areca.com.tw>, Erich Chen <erich@areca.com.tw>

On Sat, 23 Feb 2008 12:20:12 +0100 (CET) Nikola Ciprich <extmaillist@linuxbox.cz> wrote:

> Hi,
> 
> I've found strange problem either in arcmsr driver, or maybe in 
> areca-1660 card...
> When system on SAS discs RAID connected to areca-1660 card 
> gets under heavy I/O load, it gets unusable after some time. I can 100% reproduce 
> this, although it needs quite speciffic conditions:
> It can be reproduced on 2x quad core machine, RAM has to be limited to 
> ~192MB to cause heavy paging.
> Only thing needed to cause the problem is to start loop doing kernel 
> compilation using make -j 8 - this loads the system heavily, because of 
> lack of memory. After few correct compile runs the system gets into 
> state when all programs including the basic ones (ls, cp, ..) start 
> crashing... dmesg (when it works) doesn't say anything strange...
> After reboot, the system is OK again.
> I have tested it on different motherboards, with different CPUs, RAMs(all 
> were properly tested with memtest), with two different areca cards and 
> different drives. I can't reproduce the problem on same hardware when 
> using different RAID card (ie adaptec). All testing systems were properly 
> cooled..
> I have tried all available areca firmwares, two different distributions 
> (oracle linux, and centos), and kernels ranging from distribution ones, to last GIT snapshot.
> Could somebody please give me some hints on how to hunt this problem?
> Areca support doesn't seem to be very interested in the problem :-(

(cc's added)

Please get the machine into this state of memory exhaustion then take
copies of the output of the following, and send them via reply-to-all to
this email:

- cat /proc/meminfo

- cat /proc/slabinfo

- dmesg -c > /dev/null ; echo m > /proc/sysrq-trigger ; dmesg -c

Thanks.
