From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] uas: leave can_queue as MAX_CMNDS if device reports
 larger qdepth
Date: Tue, 24 May 2016 01:23:25 +0800
Message-ID: <CAGnHSE=Gt3XP9g5KpEyYUWGdw-kwqGDKpBQzd5qagxrjeHsxRA@mail.gmail.com>
References: <574329ae.c726620a.60f3.ffffd14b@mx.google.com>
	<20160523170025.GA3309@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160523170025.GA3309-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Nothing wrong. It's just .can_queue = MAX_CMNDS in the host template
is no longer neceesary, since with his patch, uas will set can_queue
again later (to devinfo->qdepth - 2).

Originally I thought .can_queue = MAX_CMNDS can hence be removed; but
after a second thought, I think it might probably be better if we
leave it there and make use of it, in case certain device somehow
inapproriately reports an enormous qdepth (i.e. larger than
MAX_CMNDS). (According to the commit message of 55ff8cfbc4e1 ("USB:
uas: Reduce can_queue to MAX_CMNDS"), "The uas driver can never queue
more then MAX_CMNDS...")

On 24 May 2016 at 01:00, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Tue, May 24, 2016 at 12:02:43AM +0800, tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Commit 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level") made
>> qdepth limit set in host template (`.can_queue = MAX_CMNDS`) useless.
>>
>> Instead of removing the template limit, now we only change limit according
>> to the qdepth reported by the device if it is smaller than MAX_CMNDS.
>>
>> Signed-off-by: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
>> index 4d49fce..d7790e6 100644
>> --- a/drivers/usb/storage/uas.c
>> +++ b/drivers/usb/storage/uas.c
>> @@ -972,7 +972,8 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
>>        * 1 tag is reserved for untagged commands +
>>        * 1 tag to avoid off by one errors in some bridge firmwares
>>        */
>> -     shost->can_queue = devinfo->qdepth - 2;
>> +     if (devinfo->qdepth - 2 < MAX_CMNDS)
>> +             shost->can_queue = devinfo->qdepth - 2;
>
> What's wrong with Hans's patch for this issue instead?
>
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
