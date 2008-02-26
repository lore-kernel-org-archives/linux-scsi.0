From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: arcmsr & areca-1660 - strange behaviour under heavy load
Date: Tue, 26 Feb 2008 09:43:08 -0800
Message-ID: <20080226094308.35db8f3f.akpm@linux-foundation.org>
References: <alpine.LRH.0.9999.0802231201380.21313@linuxbox.linuxbox.cz>
	<20080224161034.f494fc7f.akpm@linux-foundation.org>
	<alpine.LRH.0.9999.0802261032440.31781@linuxbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762393AbYBZRos (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2008 12:44:48 -0500
In-Reply-To: <alpine.LRH.0.9999.0802261032440.31781@linuxbox.linuxbox.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Nick Cheng <nick.cheng@areca.com.tw>, Erich Chen <erich@areca.com.tw>, kopi@linuxbox.cz

On Tue, 26 Feb 2008 10:35:31 +0100 (CET) Nikola Ciprich <extmaillist@linuxbox.cz> wrote:

> Hi
> 
> On Sun, 24 Feb 2008, Andrew Morton wrote:
> 
> Hi Andrew,
> thanks a lot for reply, I'm attaching requested information.
> please let me know if You need more information/testing, whatever.
> I'll be glad to help.
> BR
> nik
> 
> >> Areca support doesn't seem to be very interested in the problem :-(
> >
> > (cc's added)
> >
> > Please get the machine into this state of memory exhaustion then take
> > copies of the output of the following, and send them via reply-to-all to
> > this email:
> >
> > - cat /proc/meminfo
> >
> > - cat /proc/slabinfo
> >
> > - dmesg -c > /dev/null ; echo m > /proc/sysrq-trigger ; dmesg -c
> >
> > Thanks.

Alas, that all looks OK to me.

You never get any out-of-memory messages, and no oom-killing messages?

Possibly what is happening here is that in this low-memory condition, some
of the driver's internal memory-allocation attempts are failing, and the
driver isn't correctly handling this.  This is a rare situation which may
well not have been hit in anyone else's testing.

I expect that the Areca engineers will be able to reproduce this with a
suitably small "mem=" kernel boot option.  If not, they could perhaps
investigate the kernel's fault-injection framework, which permits
simulation of page allocation failures.
