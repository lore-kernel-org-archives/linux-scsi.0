From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Sat, 29 Mar 2003 20:24:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303292024.08893.oliver@neukum.org>
References: <20030325100704.GC3868@beaverton.ibm.com> <1048948992.21525.1.camel@mulgrave> <20030329190407.GA1483@beaverton.ibm.com>
Reply-To: oliver@neukum.name
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030329190407.GA1483@beaverton.ibm.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Am Samstag, 29. M=E4rz 2003 20:04 schrieb Mike Anderson:
> James Bottomley [James.Bottomley@steeleye.com] wrote:
> > On Fri, 2003-03-28 at 19:32, Matthew Dharm wrote:
> > > Well, Linus wants this to work for usb-storage more short-term th=
an
> > > long-term....
> >
> > Well, I think Mike's given us everything you need.  We can use the
> > set_device_offline to alter the remove-single-device path to offlin=
e the
> > device, wait for the returning I/Os to complete or error and then r=
emove
> > the device.
> >
> > You can then trigger this from your hotplug scripts.
>
> I believe we still need to fixup scsi_remove_host to not fail (i.e
> return void) and call "hostt->release" when the ref count on the host

Yes, we cannot have a failure there.

> goes to zero. (I believe this was a point that started us on this thr=
ead
> of work as the usb implementation was one device per host).

Not necessarily. The USB driver cannot tell a simple device apart
from a SCSI<->USB bridge, which several SCSI devices can be
attached to. Hotplugging however is always on a host level with
USB storage.

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
