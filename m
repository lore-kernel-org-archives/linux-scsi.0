From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Mon, 5 May 2003 09:38:34 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030505093834.B7831@beaverton.ibm.com>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl> <3EB619A4.5090407@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <3EB619A4.5090407@torque.net>; from dougg@torque.net on Mon, May 05, 2003 at 05:58:28PM +1000
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Douglas Gilbert <dougg@torque.net>
Cc: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Mon, May 05, 2003 at 05:58:28PM +1000, Douglas Gilbert wrote:
> So we are back to all the fun games of opening/
> querying/closing likely looking device nodes in
> the /dev space (and I speak from experience).
> What a joy.
> 
> Surely there is a better way. Why not do the VPD=0x83
> query on devices that claim to be SCSI-3 compliant
> or better. The scsi mid level driver (and/or the
> usb-storage + sbp2 LLDs) could have a sysfs parameter
> such as "simple_scan". The filters discussion
> showed more promise than this blunt approach.
> 
> I have contemplated putting the VPD=0x83 code in
> lsscsi but it won't be pretty (e.g. requiring root
> privilege, side effects including locking up
> certain USB storage devices :-) ).

As James said, we can get the uid from user space. This implies we need sg
(or an equivalent solution).

If the id is required before any actual use of the device, we (sometimes?
always?) need initramfs.

There is a problem with trying to use sg before sg is attached - not sure
how we can handle this. If sg could be opened generically and attached to
any nexus (i.e. scsi_device) via ioctl, we could use it not only for id's,
but for general user level scanning. Or maybe we can wait until after sg
is attached to get id's.

We still have problems with potentially locking up some devices, and we
will need some sort of black/white list for VPD usage, this would also
have been needed for an in kernel implementation; [for user space] you
would not need a kernel change to fix a problem (modify the black/white
list or other such code to prevent a VPD from being sent to a particular
device).

Plus, many of the devices do not return unique id's, even when VPD pages
are supported (especially I'm told USB) - we need a white list or other
such mechanism to tell us that id's are actually unique.

An sgid user program that does the same thing as the code removed from the
kernel would be very usefull. This could likely be incorporated into other
schemes (udev), independent of other details.

Right now, we could have an sgid that runs whenever an sg is found (sg
hotplug generated via device_register), and stores a sysfs path and the id
returned into a flat file.

-- Patrick Mansfield


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
