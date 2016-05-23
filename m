From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] uas: leave can_queue as MAX_CMNDS if device reports
 larger qdepth
Date: Tue, 24 May 2016 02:33:24 +0800
Message-ID: <CAGnHSEn=5CvtKGXyxpyDRtV1Wu9d8Z0fo26p=8-YYvBDmMf8fw@mail.gmail.com>
References: <574329ae.c726620a.60f3.ffffd14b@mx.google.com>
	<20160523170025.GA3309@kroah.com>
	<CAGnHSE=Gt3XP9g5KpEyYUWGdw-kwqGDKpBQzd5qagxrjeHsxRA@mail.gmail.com>
	<1464024457.2331.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464024457.2331.10.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

I don't quite get what you mean. Are you saying that it is impossible
that UAS devices would report inappropriately high qdepth, because of
this?
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/usb/storage/uas.c?h=v4.6#n908

In that case should I send another patch that simply has `.can_queue =
MAX_CMNDS` in the host template removed?

On 24 May 2016 at 01:27, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Tue, 2016-05-24 at 01:23 +0800, Tom Yan wrote:
>> Nothing wrong. It's just .can_queue = MAX_CMNDS in the host template
>> is no longer neceesary, since with his patch, uas will set can_queue
>> again later (to devinfo->qdepth - 2).
>>
>> Originally I thought .can_queue = MAX_CMNDS can hence be removed; but
>> after a second thought, I think it might probably be better if we
>> leave it there and make use of it, in case certain device somehow
>> inapproriately reports an enormous qdepth (i.e. larger than
>> MAX_CMNDS). (According to the commit message of 55ff8cfbc4e1 ("USB:
>> uas: Reduce can_queue to MAX_CMNDS"), "The uas driver can never queue
>> more then MAX_CMNDS...")
>
> OK, so try this as an exercise: Why would this not be the right thing
> to do after the host is prepared:  It has to do with the streams
> resources the driver has already created.
>
> James
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
