From: Douglas Gilbert <dougg@torque.net>
Subject: Re: usb-storage / scsi : new scsi host on each
 plug
Date: Fri, 07 Nov 2003 16:24:16 +1000
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <3FAB3A90.402@torque.net>
References: <Pine.LNX.4.44L0.0310291020430.874-100000@ida.rowland.org> <1067442814.1829.21.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <1067442814.1829.21.camel@mulgrave>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, martin@lorenz.eu.org, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2003-10-29 at 09:24, Alan Stern wrote:
> 
>>>no matter which USB-storage-device I attach (tried CD-ROM, 
>>>Flash Card Reader and memory stick) I get a new scsi host
>>>every time i plug a device in.
>>>
>>>so when changing devices for several times I finally end up
>>>with /dev/scsi/host0 to 17 or more (diden't go on)
>>
>>This is a SCSI issue, not a USB one.  Maybe someone on the 
>>SCSI development list can enlighten us.  As far as I can tell, the host 
>>number is simply incremented every time a new host, of whatever sort, is 
>>added.  The numbers never get reused.
> 
> 
> This is really a design feature.  Not reusing hosts gives us time to
> clean up the old one before the new one is initialised (and prevents
> races where we could be trying to plug in a new host at the same time
> we're cleaning up the old one).

This "design feature" highlights the inadequacy of the
SCSI_IOCTL_GET_IDLUN ioctl which only allocates 8 bits for
the host number. Back to using the SCSI_IOCTL_GET_BUS_NUMBER
ioctl for mapping programs that want to work in both lk 2.4
and lk 2.6 . Since target port ids in iSCSI are url-like
(up to 255 chars) and luns can be 64 bits, a more robust
"GET_IDLUN" ioctl is needed at some stage.

Perhaps re-using host numbers after they are known to be
fully shut down would be saner.

Doug Gilbert




-------------------------------------------------------
This SF.net email is sponsored by: SF.net Giveback Program.
Does SourceForge.net help you be more productive?  Does it
help you create better code?   SHARE THE LOVE, and help us help
YOU!  Click Here: http://sourceforge.net/donate/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
