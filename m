From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Mon, 9 Jun 2008 15:40:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806091533160.14688-100000@iolanthe.rowland.org>
References: <484D8019.3090900@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <484D8019.3090900@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Chris Clayton <chris2553@googlemail.com>, LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Mon, 9 Jun 2008, Stefan Richter wrote:

> The log at http://lkml.org/lkml/2008/6/6/317 shows two pauses.  One in 
> the middle of USB related messages with no FireWire stuff around 
> (17:25:19 to 17:25:44).  The other with parport, ieee1394, USB messages 
> around it (17:25:44 to 17:26:31).
> 
>  From there, the last 17:25:44 message is strange:  The device 
> 00110666000013cc which is the controller is reported as being removed. 
> Chris, did you do something at this point?

It's also worth noting that the first 17:25:44 message is highly 
suspicious.  It is the initial output of the ohci-hcd driver, 
indicating that the udev/hotplug system had just loaded that driver.  
This doesn't seem to have anything to do with the SCSI stack.

Whatever caused the delay, it also managed to pause the other hotplug 
task which was in the midst of loading uhci-hcd.

Alan Stern


-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://sourceforge.net/services/buy/index.php
