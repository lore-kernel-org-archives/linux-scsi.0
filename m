From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 02 Apr 2004 10:57:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080921450.1804.66.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080862354.2118.78.camel@mulgrave>  <20040402084338.GA3547@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:6296 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264090AbUDBP5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 10:57:45 -0500
In-Reply-To: <20040402084338.GA3547@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, stern@rowland.harvard.edu

On Fri, 2004-04-02 at 03:43, Mike Anderson wrote:
> I have looked at the sd issue off and on due to the previous open race
> reported by Alan Stern. While the window can be narrowed inside SCSI you
> need help for the calling subsystem to know when it is OK to cleanup and
> your routine will not be called anymore. A similar problem also showed
> up in the tear down the host directory entry in /proc/scsi but was only
> fixed up so far due to its depreciated status.
> 
> http://marc.theaimsgroup.com/?t=105545175900001&r=1&w=2
> 
> I believe as indicated above that all cross subsystem registrations need
> a release / put callback. This would allow the release chain to be
> called from block -> ULD -> scsi core -> LLDD. 
> 
> Recently I have not been spending the proper time looking at this, but
> last look it appeared that we needed to  add a release / put method call
> to the gendisk disk_release routine. The release function or object to do
> the put on would need to be set prior to the call to add_disk.

Actually, I can't believe this problem to be local entirely to SCSI. 
So, a simpler mechanism (and more globally useful) might be to have a
two phase driver release in sysfs:

- the current ->remove would stay where it is (as a notify on
device_del).  On receving this the driver begins clean up enough to drop
any internal references to the device it is holding.
- then introduce a ->release which is called as part of dropping the
last device reference where the driver cleans up any resources the
driver was keeping to service the removed but not released device.

Then, we'd obviously not call unregister_cdrom and kfree the scsi_cd
structure until ->release time.

James


