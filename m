From: Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Subject: Re: Large disk drives
Date: Wed, 05 Nov 2014 20:53:02 +0200
Message-ID: <545A720E.3030108@plexistor.com>
References: <Pine.LNX.4.44L0.1411051130470.1531-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1411051130470.1531-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Dale R. Worley" <worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 11/05/2014 06:34 PM, Alan Stern wrote:
<>
> 
> It's simpler than that: The drive is attached directly to the computer
> (i.e., via SATA rather than USB) when the partition table is created.  
> With no USB-SATA bridge chip to mess things up, there's no problem
> determining the correct capacity.
> 

Right!

I think it should be very simple to, just as we send a
READ_CAPACITY16 / READ_CAPACITY32 / READ_CAPACITY64 or is
it a GET_CODE_PAGE ? whatever we send today we can also
have READ_CAPACITY_PART() which will send a READ of
sector 0 the raw PC_COMMAND way and run it through some
partition analyzer. We only need to support gpt or msdos
partitions I think in this case.

Then if READ_CAPACITY16 returns all ffff(s) and
READ_CAPACITY32 is not supported and/or blacklisted,
then yes attempt a READ_CAPACITY_PART() which should
be sam-2 compatible.

It should not take longer than a weekend afternoon over
cup of Machha. If any one sends a bad device my way, I'll
do it. But anyone should be able to code something so simple.

> Alan Stern
> 

Cheers
Boaz

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
