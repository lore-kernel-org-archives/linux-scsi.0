From: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Tue, 23 Nov 2010 13:40:21 -0500
Message-ID: <4CEC0A95.5020201@interlog.com>
References: <949636.86471.qm@web31809.mail.mud.yahoo.com> <AANLkTi=7tW6wqrk8ZkFuTYwmS-wZ4nQ+jkxk8U95H42F@mail.gmail.com> <4CEABE2E.4010609@interlog.com> <20101123045900.GK20296@one-eyed-alien.net>
Reply-To: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101123045900.GK20296-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, James
List-Id: linux-scsi@vger.kernel.org

On 10-11-22 11:59 PM, Matthew Dharm wrote:
> On Mon, Nov 22, 2010 at 02:02:06PM -0500, Douglas Gilbert wrote:
>> On 10-11-22 12:07 PM, Linus Torvalds wrote:
>>> On Mon, Nov 22, 2010 at 8:56 AM, Luben Tuikov<ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>   wrote:
>>>>
>>>> Some kernel transport drivers unconditionally disable
>>>> retrieval of the Caching mode page. One such for example is
>>>> the BBB/CBI transport over USB.
>>>
>>> One reason for that is that historically we've seen devices that
>>> simply go crazy - to the point of simply stopping to respond to
>>> anything - when you ask for pages that Windows doesn't ask for.
>>>
>>> It's especially common on USB storage, but it happens elsewhere too.
>>> The device firmware simply hasn't ever been tested in that situation,
>>> and it's buggy.
>>>
>>> So I don't mind the patch per se, but I think it's potentially way
>>> more dangerous than it looks.
>>
>> The vast majority of USB mass storage devices are based
>> on SCSI-2 (1994) or a particularly nasty standard
>> called RBC (Reduced Block Commands, 1999) which is a
>> partial subset of the block commands (i.e. disk related).
>> We are all aware of the quality of most of the device
>> end implementations out in the wild.
>
> Not true.  The vast majority of USB mass storage devices adhere to no SCSI
> or T10 specification at all.  The official definition of the "Transparent
> SCSI" operating mode of the USB Mass Storage Class is "that which
> microsoft/sun/other major vendors use".  Of course, that's not written down
> anywhere, but it was the intent of the committee and that is the reason why
> the committee rejected all attempts by people like me to implement a
> command-based compliance test.

Okay.

>> I believe what Luben is working with is a new standard
>> called UAS (soon to be ratified) which is based on
>> www.t10.org work in the last few years. It seems to be
>> an attempt to throw out the older USB mass storage
>> transport and do it again, properly.
>
> Luben's patch changes the behavior of sd-mod, which would affect both
> usb-storage and UAS.
>
> The primary thing that UAS adds is support for USB 3.0 streams and TCQ,
> which are both designed to improve performance.  I consider it likely that
> the quality of device firmware will be equally poor as older devices.

That depends on how low we, and particularly W7, set
the bar. And W7 has a similar set of problems to
us. For example, how to detect an SSD supporting
trim behind a USB transport.

Doug Gilbert

> That said, Luben's patch is kinda slick.  sd-mod already asks for a lot of
> mode page data; it does this so that it's request matches the observed
> behavior of a "popular" Redmond, WA-based OS.  Luben's patch just searches
> through that data to see if it can find what it is looking for, rather than
> rqeuesting a specific mode page later (which may not be supported).
>
> That said, I still consider this somewhat risky.  We've seen devices with
> grossly inaccurate data before.
>
> But, to my thinking, as long as the devices don't see any change in the
> command stream, then I think the risk has been properly mitigated.  To my
> understanding, this is the case.
>
> Matt
>

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
