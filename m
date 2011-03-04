From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ensure bsg device is available before announcing
 scsi device
Date: Fri, 04 Mar 2011 11:10:03 -0600
Message-ID: <1299258603.7041.84.camel@mulgrave.site>
References: <1299092565.26023.2.camel@satan>
	 <1299175019.9151.16.camel@mulgrave.site>  <1299249176.4710.15.camel@satan>
	 <1299253276.2461.33.camel@mulgrave.site>  <1299257417.4710.29.camel@satan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54368 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759801Ab1CDRKF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2011 12:10:05 -0500
In-Reply-To: <1299257417.4710.29.camel@satan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Zeuthen <davidz@redhat.com>
Cc: linux-scsi@vger.kernel.org, kay.sievers@vrfy.org

On Fri, 2011-03-04 at 11:50 -0500, David Zeuthen wrote:
> On Fri, 2011-03-04 at 09:41 -0600, James Bottomley wrote:
> > > Note that we can already do all this today but since the sysfs la=
yout
> > > looks like this
> > >=20
> > >  0:0:0:0
> > >  |-- block
> > >  =E2=94=82   +-- sdb
> > >  |   |   ...
> > >  |
> > >  |-- bsg
> > >  |   +-- 0:0:0:0
> > >  |   |   ...
> > >=20
> > > This setup is rather unfortunate because the bsg device and block=
 device
> > > are siblings and, thus, cannot share information with each other.=
 This
> > > is because only children can import information from their parent=
s -
> > > anything else is prone to races.
> > >=20
> > > Now, since we currently run scsi_id + friends on the block device=
 it
> > > would mean running these tools _again_ on the bsg device. Which,
> > > honestly is a waste. So the idea was simply to always run it on t=
he scsi
> > > device (using the bsg node) and simply just import the data to th=
e block
> > > device and bsg devices (both are children of the scsi device).
> >=20
> > OK, so why not simply an event on BSG device creation then?  To mak=
e
> > what you want to do work, it sounds like we should be moving BSG bi=
nding
> > farther back in the configure sequence (to the same place where we'=
d be
> > binding an ordinary ULD).  It also perhaps sounds like we don't nee=
d any
> > events on the sdev.  The only reason we might find them useful is i=
f we
> > were going to do configuration from user space (which was a proposa=
l
> > once upon a time).  The sdev was never designed to be any sort of t=
hing
> > the user saw (well, except as an identifying label).  That's why yo=
u
> > need to bind a driver (including bsg) to speak to it.
>=20
> Not entirely sure what you exactly are proposing here but note that t=
he
> root problem is that the block device and bsg device are siblings...

Right, but that's a consequence of the fact that we allow multiple uppe=
r
layer driver bindings.

What I'm telling you is that you can't trigger off the ADD event on the
sdev because the device isn't ready at that point.  What you need to do
is trigger off the event for binding the ULD(s) ... but I'm also warnin=
g
that the multiple binding nature of ULDs always makes this racy.  If yo=
u
shift to using the bsg device, we'll have to make sure it isn't
advertised until the system is ready to receive packets down it ... and
I suspect we might be creating it a bit early in the current setup,
simply because no-one has used it like this before.

You have a guarantee that there will always be a bsg device ... so if
you want to use that for a probe, fine, cache the results on it.  I
don't think we can ever guarantee that the other ULD will (or won't) be
there at the same time, so surely you can make udev on the other device
wait until the bsg based probe completes?

James

>  the
> only way this can work without races in user space is to have their
> common ancestor do the work (e.g. run /lib/udev/scsi_id + friends) on
> the 'add' uevent, not on some 'change' uevent later... there is just =
no
> way it will work otherwise.
>=20
> If we didn't care about backward compat, maybe it could look like thi=
s
>=20
>  0:0:0:0
>  +-- dev    <-- this is dev file for the bsg device
>  |
>  +-- block
>  |   +-- sdb
>  |   |   +-- dev  <-- this is the dev file for the block device
>=20
> so we get the bsg device as the first uevent and the block device wit=
h
> the other one. With this setup we'd run /lib/udev/scsi_id + friends o=
n
> the bsg device node and then we'd import it for the block device node
> and everything would be good.
>=20
> That said, I don't think we can make such a change as it would probab=
ly
> break some parts of user space...
>=20
>     David
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
