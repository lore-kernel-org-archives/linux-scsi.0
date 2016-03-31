From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] uas: Add a new NO_REPORT_LUNS quirk
Date: Thu, 31 Mar 2016 08:11:13 -0700
Message-ID: <1459437073.2958.29.camel@HansenPartnership.com>
References: <1459426971-11927-1-git-send-email-hdegoede@redhat.com>
	 <1459435682.2958.19.camel@HansenPartnership.com>
	 <56FD3C27.2050708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56FD3C27.2050708-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Webb <djw-8SE8IwxHpK9aa/9Udqfwiw@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-03-31 at 17:03 +0200, Hans de Goede wrote:
> Hi,
> 
> On 31-03-16 16:48, James Bottomley wrote:
> > On Thu, 2016-03-31 at 14:22 +0200, Hans de Goede wrote:
> > > Add a new NO_REPORT_LUNS quirk and set it for Seagate drives with
> > > an usb-id of: 0bc2:331a, as these will fail to respond to a
> > > REPORT_LUNS command.
> > 
> > Actually, if we're sending them a report luns command, they must be
> > reporting in at SCSI-3 SPC or higher.  Should we be quirking them 
> > down to SCSI-2 instead because it reduces the risk of running into
> > something else they're not doing from the SPC command set?
> 
> These are fairly new devices, so they should really be scsi3, but the
> usb <-> sata bridge (presumably) used does not seem to like
> report_luns.

That's what I'm questioning: REPORT LUNS is one of the big SCSI-3
changes, if they don't support that, it really looks like someone
picked up an old engine and just fuzzed the inquiry data to return SCSI
-3.  In which case we should put it back to SCSI-2 where it belongs.

Also, if it's USB<->SCSI bridge, that isn't really UAS, is it?

> Note that usb-storage simple sets no_report_luns conditionally for 
> all usb-storage devices. The scsi people have repeatedly asked me to 
> not do this kinda blanket blacklisting for uas devices, because they 
> hope that uas will allow them to more or less do proper scsi over 
> usb, so we end up with blacklisting specific commands every now and 
> then to get devices to work.

Well, we were hoping that with UAS the USB device creators would
actually learn what a standard was when it bit them, yes.  The fact
that Seagate can release a SCSI-3 UAS device that doesn't do REPORT
LUNS kind of dashes that hope.

James

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
