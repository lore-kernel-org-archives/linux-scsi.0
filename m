From: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>
Subject: Re: RES: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Wed, 27 Aug 2014 08:45:31 +0200
Message-ID: <1409121931.27702.8.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1408261031090.1434-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1408261031090.1434-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Alfredo Dal Ava Junior <alfredo.junior-peCLlicIkyA3OWu3QmcX+g@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-08-26 at 10:47 -0400, Alan Stern wrote:
> On Mon, 25 Aug 2014, Oliver Neukum wrote:

> > Just set US_FL_NEEDS_CAP16. If READ CAPACITY(16) fails in that case,
> > it is clear that something is wrong. It must be set or READ CAPACITY(10)
> > alone would be taken as giving a valid answer.
> 
> You have committed a mental layering violation.  :-)

Indeed.

> US_FL_NEEDS_CAP16 is a usb-storage flag.  But the capacity
> determination is made by the sd driver, which relies on the SCSI
> try_rc_10_first flag.  If that flag isn't set, sd tries READ 
> CAPACITY(16) and then falls back to READ CAPACITY(10) if an error 
> occurs.  That's what happened here.
> 
> I don't think we want to add another SCSI flag to say that READ
> CAPACITY(10) is unreliable.

Why not? It would only be friendly to tell the upper layer
of a malfunction if we know about it.

> > At that time we are sure that the drive will be unusable unless we
> > determine the correct capacity, so we don't make matters worse if we
> > crash it.
> 
> Given the difficulty of determining the true capacity, I see two
> alternatives.  We could set the capacity to a ridiculously large value
> (like 1 billion TB), or we could leave the capacity set to the low
> value and disable the "block within bounds" checks.  Neither of these
> is attractive and they both have issues of their own -- although the 
> second is close to what Windows does.

That seems to be the most attractive solution to me.

> (For example, udev often tries to read the last sectors of a new drive, 
> looking for a GPT or RAID signature.  That won't work if the capacity 
> is set to some random value.)

Yes, but clipping has its own dangers. Suppose you use the medium
without a partition table.

	Regards
		Oliver



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
