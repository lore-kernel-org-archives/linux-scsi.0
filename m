From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: 05 May 2003 11:59:10 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1052153952.1816.22.camel@mulgrave>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl>
	<3EB619A4.5090407@torque.net>  <20030505093834.B7831@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20030505093834.B7831@beaverton.ibm.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Douglas Gilbert <dougg@torque.net>, Andries.Brouwer@cwi.nl, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Mon, 2003-05-05 at 11:38, Patrick Mansfield wrote:
> As James said, we can get the uid from user space. This implies we need sg
> (or an equivalent solution).
> 
> If the id is required before any actual use of the device, we (sometimes?
> always?) need initramfs.

initramfs is only needed to find the root device.  All others can be
located later (although when depends on how the hotplug vs coldplug
issues are sorted out)

> There is a problem with trying to use sg before sg is attached - not sure
> how we can handle this. If sg could be opened generically and attached to
> any nexus (i.e. scsi_device) via ioctl, we could use it not only for id's,
> but for general user level scanning. Or maybe we can wait until after sg
> is attached to get id's.

You can now send SCSI commands directly to sd via the ioctl.

> We still have problems with potentially locking up some devices, and we
> will need some sort of black/white list for VPD usage, this would also
> have been needed for an in kernel implementation; [for user space] you
> would not need a kernel change to fix a problem (modify the black/white
> list or other such code to prevent a VPD from being sent to a particular
> device).

Yes.

> Plus, many of the devices do not return unique id's, even when VPD pages
> are supported (especially I'm told USB) - we need a white list or other
> such mechanism to tell us that id's are actually unique.

That's one of the reasons for moving itt: he heuristics are pretty
complex given the strange things devices seem to call "unique" (I can
even see devices where it's "get the label from the first available
fs").

James




-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
