From: Jeff Garzik <jeff@garzik.org>
Subject: Re: aic94xx or libsas crash on X7DB3 supermicro with enclosure and
 sata drives
Date: Mon, 03 Dec 2007 14:43:09 -0500
Message-ID: <47545C4D.1070708@garzik.org>
References: <200711301022.08001.kb@sysmikro.com.pl> <20071130213313.GA7066@tree.beaverton.ibm.com> <200712031709.54168.kb@sysmikro.com.pl> <20071203193652.GB7066@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47683 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXLCTnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Dec 2007 14:43:16 -0500
In-Reply-To: <20071203193652.GB7066@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Krzysztof B??aszkowski <kb@sysmikro.com.pl>, linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

Darrick J. Wong wrote:
> On Mon, Dec 03, 2007 at 05:09:54PM +0100, Krzysztof B??aszkowski wrote:
>> I noticed also another failure when i removed a drive. The event was not 
>> notified by anything (ie the block device and corresponding sg were 
>> registered) so i run dd on this truly "virtual" drive.
>>
>> dd reached D state (as well as scsi_wq) . i think it shouldn't happen no 
>> matter it was AIC failure or LSI expander failure.
> 
> "It's wireless!" ;)
> 
> Seriously, though, it's a good idea to tell the kernel that you're
> about to unplug a disk before actually doing it:
> 
> echo 1 > /sys/block/sdX/device/delete
> 
> This way, the kernel can tell the disk to flush its caches long before
> power actually gets removed.  Otherwise, the device removal code can
> get hung up just like you observed, and whatever's in the write cache
> may or may not actually get written to the media.


What you say is quite true about write cache -- you can clearly lose 
some data by hot-unplugging a device.  And there's nothing we can do 
about that.

But what do you mean by "device removal code can get hung up"?  That 
sounds like a bug we should fix.

	Jeff


