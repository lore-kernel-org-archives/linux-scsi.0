From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] usb: storage: adjust module reference for scsi host
Date: Tue, 6 Jan 2015 08:43:51 +0900
Message-ID: <CAC5umygLeewW1-CrjA=ibffL6UHEXOYzoCyhMfQKnihff+NGBw@mail.gmail.com>
References: <1420468479-4508-4-git-send-email-akinobu.mita@gmail.com>
	<Pine.LNX.4.44L0.1501051021370.1485-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1501051021370.1485-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

2015-01-06 0:27 GMT+09:00 Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>:
> On Mon, 5 Jan 2015, Akinobu Mita wrote:
>
>> While accessing a unusual usb storage (ums-alauda, ums-cypress, ...),
>> the module reference count is not incremented.  Because these drivers
>> allocate scsi hosts with usb_stor_host_template defined in usb-storage
>> module.  So these drivers always can be unloaded.
>>
>> This fixes it by adjusting module reference after scsi host allocation.
>
>> diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
>> index 62c2d9d..77660d6 100644
>> --- a/drivers/usb/storage/alauda.c
>> +++ b/drivers/usb/storage/alauda.c
>> @@ -1242,6 +1242,7 @@ static int alauda_probe(struct usb_interface *intf,
>>       us->transport = alauda_transport;
>>       us->transport_reset = usb_stor_Bulk_reset;
>>       us->max_lun = 1;
>> +     us_to_host(us)->module = THIS_MODULE;
>>
>>       result = usb_stor_probe2(us);
>>       return result;
>
> ... etc.
>
> An easier and more foolproof approach would be to change
> usb_store_probe2 to take an extra argument for the owner:
>
> int _usb_stor_probe2(struct us_data *us, struct module *owner)
> ...
>         us_to_host(us)->module = owner;
> ...
>
> Then in usb.h:
>
> extern int _usb_stor_probe2(struct us_data *us, struct module *owner);
> #define usb_stor_probe2(us)     _usb_stor_probe2(us, THIS_MODULE)
>
> This pattern is already used in several other places in the kernel.

Sounds good.  I'll take this idea and update this patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
