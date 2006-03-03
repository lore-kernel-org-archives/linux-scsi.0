From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: sg regression in 2.6.16-rc5
Date: Thu, 2 Mar 2006 16:12:00 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603021604070.22647@g5.osdl.org>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com> <4404AA2A.5010703@torque.net>
 <20060301083824.GA9871@merlin.emma.line.org> <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org>
 <4405F6F1.9040106@torque.net> <Pine.LNX.4.63.0603012239440.5789@kai.makisara.local>
 <44074CA1.3000007@torque.net> <Pine.LNX.4.64.0603021317520.22647@g5.osdl.org>
 <20060302230814.GB16237@merlin.emma.line.org> <Pine.LNX.4.64.0603021518430.22647@g5.osdl.org>
 <Pine.LNX.4.64.0603021555020.22647@g5.osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:36312 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751003AbWCCAMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 19:12:19 -0500
In-Reply-To: <Pine.LNX.4.64.0603021555020.22647@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: Douglas Gilbert <dougg@torque.net>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org



On Thu, 2 Mar 2006, Linus Torvalds wrote:
>
>  - the people who did special things like this are apparently already used 
>    to doing things like changing SG_SCATTER_SZ and then _recompiling_ the 
>    whole kernel (it wasn't ever a dynamic option or anything like that).

And, final note: yes, the new "honor the limits" means that there may not 
be a single place to change like before. Most of the limits are 
per-driver, with some limits set by (arguably bad) SCSI midlevel code (I 
think max_sectors is a "unsigned short", for example, which obviously 
implies that 63355 sectors is a limit not of the drivers, but of the SCSI 
host code.

The generic block layer, which people seem to like to blame, should 
actually be pretty blame-less. I think it tends to use full integers for 
its limits, for example. And tends to even allow changing the limits 
through sysfs (ie look for things like "max_sectors_kb" and "nr_reuests" 
etc in /sys/block/sdx/queue).

		Linus
