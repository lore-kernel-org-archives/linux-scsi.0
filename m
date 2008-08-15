From: Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Fri, 15 Aug 2008 09:31:34 +0100
Message-ID: <48A53EE6.8010408@tuffmail.co.uk>
References: <Pine.LNX.4.44L0.0808141535350.2148-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0808141535350.2148-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Wed, 13 Aug 2008, Boaz Harrosh wrote:
>
>   
>> One thing I don't like is the now blk_end_request(req, -EIO, bytes=0)
>> inside scsi_end_request(). What's the point of calling that with 0 bytes?
>> Maybe fix that too.
>>     
>
> While testing the patch, I learned what the point is.  :-)
>
> Actually it's very simple; you just have to remember that not all 
> requests are BLOCK_FS type.  Other types of request can indeed have a 
> transfer length of 0, and we want to end those requests normally.
>
> So this version of the patch works better than the earlier one.  In 
> principle there doesn't seem to be any reason not to call 
> blk_end_request with bytes = 0, but I left the test in there.
>
> Alan, you might want to test this version and see how well it works for 
> you.
>   
Yes, that fixes it!

I applied your patch and reduced SD_LAST_BUGGY_SECTORS to 1.  As
expected, when I inserted my USB cardreader the kernel log shows
"uncorrected read errors", as /lib/udev/vol_id triggers the hardware
bug.  But vol_id doesn't hang any more.  udev goes on to create the
device node, I get the KDE popup and can successfully mount the device.

Great work, thanks.

Alan
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
