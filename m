From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v6 0/4] scsi: ufs & ums-* & esp_scsi: fix module reference
 counting
Date: Mon, 04 May 2015 17:30:08 +0200
Message-ID: <55479080.7030209@suse.de>
References: <1430750769-11405-1-git-send-email-akinobu.mita@gmail.com> <1430752523.2177.15.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430752523.2177.15.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 05/04/2015 05:15 PM, James Bottomley wrote:
> On Mon, 2015-05-04 at 23:46 +0900, Akinobu Mita wrote:
>> While accessing a scsi_device, the use count of the underlying LLDD =
module
>> is incremented.  The module reference is retrieved through .module f=
ield of
>> struct scsi_host_template.
>>
>> This mapping between scsi_device and underlying LLDD module works we=
ll
>> except ufs, unusual usb storage drivers, and sub drivers for esp_scs=
i.
>> These drivers consist with core driver and actual LLDDs, and
>> scsi_host_template is defined in the core driver.  So the actual LLD=
Ds can
>> be unloaded even if the scsi_device is being accessed.
>>
>> This patch series first adds ability to adjust module reference for
>> scsi host by LLDDs and then fixes actual LLDDs by adjusting module
>> reference after scsi host allocation.
>=20
> This series is still missing an ack from ufs.  However, as we're on
> series 6, final warning: object now or I'll take it without ufs ack.
>=20
> However, it does also strike me that these three drivers have problem=
s
> because they're using the wrong initialisation pattern: the template =
is
> supposed to be in the bus connector for compound drivers not in the
> core.  To see how the pattern is supposed to work look at the 53c700
> series of drivers.  They have a tiny template in the bus connector pa=
rt
> and then the function NCR_700_detect() fills in the rest.
>=20
> 53c700 is possibly not the best example because it fills in the templ=
ate
> for every host rather than once at module init time, but you get the
> idea.  how difficult would it be to convert these things to use the
> correct pattern rather than hacking it in the mid layer?
>=20
Probably not _that_ difficult.
I'll give esp_scsi a shot.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
