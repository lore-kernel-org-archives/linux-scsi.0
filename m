From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Fw: [Bugme-new] [Bug 5998] New: oops on mount "kernel access
 of bad area, sig: 11 [#1]"
Date: Sat, 04 Feb 2006 12:34:07 +0100
Message-ID: <43E4912F.6090908@s5r6.in-berlin.de>
References: <20060202150719.0dafc8ae.akpm@osdl.org>	 <43E306AC.60004@s5r6.in-berlin.de> <1138993250.10057.125.camel@cog.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:10391 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932222AbWBDLhp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Feb 2006 06:37:45 -0500
In-Reply-To: <1138993250.10057.125.camel@cog.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

john stultz wrote:
> Let me know if there's anything else you need.

Please check if your kernel (2.6.15-rc5) contains Jody's patch 
"sbp2_command_orb_lock must be held when accessing the _orb_inuse 
list.": 
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=963f48a116bf3b797fe184e74c79c50de1da70bb
I.e. check if drivers/ieee1394/sbp2.c::sbp2scsi_complete_all_commands() 
contains a pair of spin_lock_irqsave/ spin_unlock_irqrestore.

Linux 2.6.15 contains it, but I don't know into which -rc it went.
-- 
Stefan Richter
-=====-=-==- --=- --=--
http://arcgraph.de/sr/
