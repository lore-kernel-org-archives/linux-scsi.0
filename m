From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Tue, 10 Jan 2017 16:00:28 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1701101551591.2462-100000@iolanthe.rowland.org>
References: <CABhjJhOp1GB0KXupWhDh-5v-+6N8=qA=rE9L21AANhdN5C0Bxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABhjJhOp1GB0KXupWhDh-5v-+6N8=qA=rE9L21AANhdN5C0Bxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Dainius_Masili=C5=ABnas?= <pastas4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 10 Jan 2017, Dainius Masiliūnas wrote:

> (I pressed reply instead of reply to all, sorry. Resending this.)
> 
> On Tue, Jan 10, 2017 at 8:29 PM, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> > There _is_ a quirk for broken models.  However, we don't know how
> > complete the set of quirk entries is, so we err on the side of caution.
> 
> Then what is it used for? There doesn't seem to be much point in a
> blacklist when the functionality is disabled by default to begin with.

It is used for preventing the kernel from issuing a READ CAPACITY(16) 
command to the device.  Normally the kernel would do this if the reply 
to READ CAPACITY(10) indicated there were more than 2^32 blocks (about 
2 TB).

> And if there's a whitelist, does it mean that we should submit the IDs
> of working USB devices for whitelisting? Also, is there a module
> parameter to toggle the functionality, to facilitate testing whether
> the device works fine or not?

There is no whitelist, but there is a quirk flag for devices that 
require READ CAPACITY(16) instead of READ CAPACITY(10) (because READ 
CAPACITY(10) returns incorrect information).

In theory, I suppose we could change the kernel so that it would 
default to READ CAPACITY(16) for devices that report a SCSI level >= 3, 
or something along those lines.  In general we hesitate to make changes 
of this sort, because they almost always end up breaking _some_ 
devices -- and if that happens then the change is reverted, with no 
exceptions.  Linus has a very strict rule about not breaking working 
systems.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
