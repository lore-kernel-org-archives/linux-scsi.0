From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine
 fails
Date: Tue, 11 Oct 2011 12:41:34 +0200
Message-ID: <4E941D5E.6060101@suse.de>
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amit Sahrawat <amit.sahrawat83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, NamJae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/11/2011 10:26 AM, Amit Sahrawat wrote:
> SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine fails
>
> It has been observed that a number of USB HDD's do not respond correc=
tly
> to SCSI mode sense command(retrieve caching pages) which results in t=
heir
> Write Cache being discarded by queue requests i.e., WCE if left set t=
o
> '0'(disabled). So, in order to identify the devices correctly - give =
it
> a last try using SG_ATA_16 after failure from normal routine.
>
I'd be _VERY_ cautious when trying something like this.

ATA_16 is a rather recent command, and most older drives simply=20
can't cope with this. Instead they just kick the error handler and=20
go offline eventually.

Shouldn't we rather use a sensible default, ie assume WCE is enabled?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
