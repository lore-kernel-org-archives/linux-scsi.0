From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: oops on usb storage device disconnect with
	2.6.14-rc1
Date: Thu, 15 Sep 2005 22:27:31 -0400
Message-ID: <1126837651.4794.16.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509152133170.9589-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0509152133170.9589-100000@netrider.rowland.org>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Thu, 2005-09-15 at 21:52 -0400, Alan Stern wrote:
> You're forgetting something: Devices can be removed at any time, no matter
> what state the host is in.  It's even possible for thread A to be removing
> a device while thread B is removing the host.  The A thread will interfere
> with the B thread, because the "list_for_each_entry_safe" loops in
> scsi_forget_host and __scsi_remove_target _aren't_ safe against other
> threads removing devices.  Also remember that the list pointers get
> changed when a device is _released_, which can occur quite some time after
> it is _removed_.
> 
> In short, those iterations must be carried out as in my patch.

OK, I concede the point ... I'll put it in.

> Finally, having said all that, it turns out there's still a bug in the 
> 2.6.14-rc1 code.  I feel pretty stupid about it -- you'll understand why 
> when you read the patch below.

Heh, yes, got that one in too.

James




-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
