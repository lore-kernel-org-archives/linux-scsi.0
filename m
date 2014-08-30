From: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Sat, 30 Aug 2014 16:40:57 -0700
Message-ID: <CAA6KcBBYbwxrCD3-W_frS5TLBVixMr-tBjhLp0HmoaDSRT==Cw@mail.gmail.com>
References: <CAA6KcBCnns-nuE4LA4EqWGhEbisueBNwAjN7vtYcfBdKm2WyUA@mail.gmail.com>
 <Pine.LNX.4.44L0.1408301710120.4299-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1408301710120.4299-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "Dale R. Worley" <worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 30, 2014 at 2:15 PM, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> On Fri, 29 Aug 2014, Matthew Dharm wrote:
>
>> Is there an 'easy' way to override the detected size of a storage
>> device from userspace?  If we had that, someone could write a helper
>> application which looked for this particular fubar and try to Do The
>> Right Thing(tm), or at least offer the user some options.
>
> You mean, force a Media Change event and override the capacity reported
> by the hardware?  I'm not aware of any API for doing that, although it
> probably wouldn't be too hard to add one.
>
> How would the user know what value to put in for the capacity?  Unless
> the drive had been hooked up to a different computer and the user
> manually noted the correct capacity and typed it in, it would have to
> be guesswork.

I didn't say it would be easy to figure out the right value, but at
least it would be possible.

I was thinking of something that could notice a USB device which is
formatted NTFS and has a partition table and filesystem that indicates
a much bigger capacity than what the drive reports.  Under this
circumstances, you could do something like pop-up a dialog box saying
"this drive is confused -- is it 2TB or 3TB?"

Well, maybe that would say "Drive capacity is not consistent with
partition table.  This can happen with certain USB drives designed for
use with Windows.  Override drive capacity (emulating Windows)?"

You could imagine increasing complex heuristics to try to detect this
scenario.  Even without an automated helper program to do it, if there
was a sysfs interface then when we got the periodic e-mails reporting
this same type of problem, we could offer a quick-and-clean solution.

Matt


-- 
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
