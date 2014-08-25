From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Mon, 25 Aug 2014 12:28:17 -0700
Message-ID: <1408994897.3629.5.camel@HansenPartnership.com>
References: <1408972618.10300.35.camel@linux-fkkt.site>
	 <Pine.LNX.4.44L0.1408251021560.1385-100000@iolanthe.rowland.org>
	 <40601ab081d3451baf6267807659c80e@serv030.corp.eldorado.org.br>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <40601ab081d3451baf6267807659c80e-CWPHn/M7kmRpAIlDVkCwMZnVvqcnFG0x9MRKq5+/VYY@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alfredo Dal Ava Junior <alfredo.junior-peCLlicIkyA3OWu3QmcX+g@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-08-25 at 18:48 +0000, Alfredo Dal Ava Junior wrote:
> On Mon, 25 Aug 2014, Alan Stern wrote:
> > 
> > Don't forget that lots of disks go crazy if you try to read from a nonexistent
> > block, that is, one beyond the end of the disk.
> > IMO, this bug cannot be worked around in any reasonable manner.  The
> > device simply cannot handle disks larger than 2 TB.
> 
> 
> This device works well on Windows 7 if HDD is already partitioned.

So how did the partition get on there at the correct size in the first
place?  Even under windows partition managers believe the disk size they
get from the system if the disk is blank.

>  Sounds like Win7 gnores the READ_CAPACITY value on a partitioned HDD.
> It shows 4TB on disk manager, but will fall back to 1.8TB if I remove
> the partition.

I assume for those of us on linux-scsi who don't have the start of this
thread, you already tried read capacity(16) and it has this same
problem?

> Could we do the same?

Hm, allowing users to set desired capacity by overriding the partition
size ... I'm sure that's not going to cause support problems ...

>  Would be possible to signalize to upper layers that capacity is not
> accurate (or return zero) on this device, and tell GPT handlers to
> bypass it's partition_size vs disk size consistency check?

If we can find a heuristic to set the correct capacity in the kernel,
then we may be able to fix this ... but as Alain says, it looks hard.
We can't ask userspace to hack tools for broken devices.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
