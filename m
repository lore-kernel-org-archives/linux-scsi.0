From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/4] scsi: ufs & ums-* & esp_scsi: fix module reference counting
Date: Tue, 13 Jan 2015 22:57:16 +0900
Message-ID: <CAC5umyj=6RfuyhvV02khOH=m7=DcWD3=p2ydV0aoSVeK64DxFw@mail.gmail.com>
References: <1420984206-22341-1-git-send-email-akinobu.mita@gmail.com>
	<20150112093610.GA25942@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150112093610.GA25942-jcswGhMUV9g@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

2015-01-12 18:36 GMT+09:00 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>:
> On Sun, Jan 11, 2015 at 10:50:02PM +0900, Akinobu Mita wrote:
>> While accessing a scsi_device, the use count of the underlying LLDD module
>> is incremented.  The module reference is retrieved through .module field of
>> struct scsi_host_template.
>>
>> This mapping between scsi_device and underlying LLDD module works well
>> except ufs, unusual usb storage drivers, and sub drivers for esp_scsi.
>> These drivers consist with core driver and actual LLDDs, and
>> scsi_host_template is defined in the core driver.  So the actual LLDDs can
>> be unloaded even if the scsi_device is being accessed.
>>
>> This patch series first adds ability to adjust module reference for
>> scsi host by LLDDs and then fixes actual LLDDs by adjusting module
>> reference after scsi host allocation.
>
> Why don't we move the module into the Scsi_Host only, and use
> the same macro that passes THIS_MODULE trick you are using in
> the sub drivers?  That seems to be a fairly common scheme in other
> subsystems as well.

Sure, we can take this approach.  But ata drivers require more changes for
it because ata drivers don't call scsi_host_alloc() directly so we need to
pass THIS_MODULE to a variety of init functions() provided by libata.

While looking through ata drivers, I found that libahci_platform sub-drivers
and pata_of_platform driver also have module reference mismatch problem.  So
ata drivers need to be touched anyway.  I'll update this patch series with
the new approach.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
