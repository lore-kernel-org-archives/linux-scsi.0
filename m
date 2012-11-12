From: "Jason J. Herne" <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] USB enclosures seem to require read(16) with >2TB drives
Date: Mon, 12 Nov 2012 10:01:24 -0500
Message-ID: <CAJiM5SY+j-KK2WbFcvi9ij4L6qeJG4a9Q+971d37Cmyo0-hBog@mail.gmail.com>
References: <1352477289-8133-1-git-send-email-hernejj@gmail.com>
	<1352719990.2449.23.camel@dabdike.int.hansenpartnership.com>
	<50A10856.6090009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50A10856.6090009-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 12, 2012 at 9:31 AM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Il 12/11/2012 12:33, James Bottomley ha scritto:
>> On Fri, 2012-11-09 at 11:08 -0500, Jason J. Herne wrote:
>>> diff --git a/drivers/usb/storage/scsiglue.c
>>> b/drivers/usb/storage/scsiglue.c
>>> index 13b8bcd..6ff785e 100644
>>> --- a/drivers/usb/storage/scsiglue.c
>>> +++ b/drivers/usb/storage/scsiglue.c
>>> @@ -251,6 +251,11 @@ static int slave_configure(struct scsi_device
>>> *sdev)
>>>                                         US_FL_SCM_MULT_TARG)) &&
>>>                                 us->protocol == USB_PR_BULK)
>>>                         us->use_last_sector_hacks = 1;
>>> +
>>> +               /* Force read-16 for large capacity drives. */
>>> +               sdev->force_read_16 = 1;
>>> +
>>> +
>>
>> This turns READ_16 on unconditionally for all USB disks ... is that
>> safe?  As in have you tested this with older USB thumb drives?
>
> Actually it only turns it on for large capacity drives, as said in the
> comment.  sdp->force_read_16 only matters for >2TB drives:
>

I should have made this clearer.  Sorry for any confusion.

> Any reason not to do this always on >2TB drives, which basically means
> changing this:
>
> -       } else if (block > 0xffffffff) {
> +       } else if (sdkp->capacity > 0xffffffff) {
>
> and nothing else?

This was the intent of my patch, except I wanted to *only* affect USB based
drives as my drive was functioning perfecting when connected to an internal
Sata port.  I was adopting the "Do not fix what isn't broke" mentality.

If there is no reason to do otherwise, I like this suggestion.  It is simple
and removes the need to provide an extra bit in the scsi_device struct.
It also eliminates the need to do any additional probe/init time checking.
We just want to be sure it won't cause problems for currently working
devices.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
