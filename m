From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Mon, 22 Nov 2010 14:02:06 -0500
Message-ID: <4CEABE2E.4010609@interlog.com>
References: <949636.86471.qm@web31809.mail.mud.yahoo.com> <AANLkTi=7tW6wqrk8ZkFuTYwmS-wZ4nQ+jkxk8U95H42F@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=7tW6wqrk8ZkFuTYwmS-wZ4nQ+jkxk8U95H42F@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ltuikov@yahoo.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 10-11-22 12:07 PM, Linus Torvalds wrote:
> On Mon, Nov 22, 2010 at 8:56 AM, Luben Tuikov<ltuikov@yahoo.com>  wrote:
>>
>> Some kernel transport drivers unconditionally disable
>> retrieval of the Caching mode page. One such for example is
>> the BBB/CBI transport over USB.
>
> One reason for that is that historically we've seen devices that
> simply go crazy - to the point of simply stopping to respond to
> anything - when you ask for pages that Windows doesn't ask for.
>
> It's especially common on USB storage, but it happens elsewhere too.
> The device firmware simply hasn't ever been tested in that situation,
> and it's buggy.
>
> So I don't mind the patch per se, but I think it's potentially way
> more dangerous than it looks.

The vast majority of USB mass storage devices are based
on SCSI-2 (1994) or a particularly nasty standard
called RBC (Reduced Block Commands, 1999) which is a
partial subset of the block commands (i.e. disk related).
We are all aware of the quality of most of the device
end implementations out in the wild.

I believe what Luben is working with is a new standard
called UAS (soon to be ratified) which is based on
www.t10.org work in the last few years. It seems to be
an attempt to throw out the older USB mass storage
transport and do it again, properly.

In the USB domain the UAS transport is identified in
an interface as mass storage class (8), SCSI transparent
command set subclass (6) and protocol 0x62. I would
think that the USB and SCSI layers could be modified to
remove some or all of its mass storage hacks (e.g. disabling
retrieval of the Caching mode page) when the transport
is UAS.

Doug Gilbert
