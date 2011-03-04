From: David Zeuthen <davidz@redhat.com>
Subject: Re: [PATCH] scsi: ensure bsg device is available before announcing
 scsi device
Date: Fri, 04 Mar 2011 11:50:16 -0500
Message-ID: <1299257417.4710.29.camel@satan>
References: <1299092565.26023.2.camel@satan>
	 <1299175019.9151.16.camel@mulgrave.site>  <1299249176.4710.15.camel@satan>
	 <1299253276.2461.33.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759825Ab1CDQu2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2011 11:50:28 -0500
In-Reply-To: <1299253276.2461.33.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, kay.sievers@vrfy.org

On Fri, 2011-03-04 at 09:41 -0600, James Bottomley wrote:
> > Note that we can already do all this today but since the sysfs layo=
ut
> > looks like this
> >=20
> >  0:0:0:0
> >  |-- block
> >  =E2=94=82   +-- sdb
> >  |   |   ...
> >  |
> >  |-- bsg
> >  |   +-- 0:0:0:0
> >  |   |   ...
> >=20
> > This setup is rather unfortunate because the bsg device and block d=
evice
> > are siblings and, thus, cannot share information with each other. T=
his
> > is because only children can import information from their parents =
-
> > anything else is prone to races.
> >=20
> > Now, since we currently run scsi_id + friends on the block device i=
t
> > would mean running these tools _again_ on the bsg device. Which,
> > honestly is a waste. So the idea was simply to always run it on the=
 scsi
> > device (using the bsg node) and simply just import the data to the =
block
> > device and bsg devices (both are children of the scsi device).
>=20
> OK, so why not simply an event on BSG device creation then?  To make
> what you want to do work, it sounds like we should be moving BSG bind=
ing
> farther back in the configure sequence (to the same place where we'd =
be
> binding an ordinary ULD).  It also perhaps sounds like we don't need =
any
> events on the sdev.  The only reason we might find them useful is if =
we
> were going to do configuration from user space (which was a proposal
> once upon a time).  The sdev was never designed to be any sort of thi=
ng
> the user saw (well, except as an identifying label).  That's why you
> need to bind a driver (including bsg) to speak to it.

Not entirely sure what you exactly are proposing here but note that the
root problem is that the block device and bsg device are siblings... th=
e
only way this can work without races in user space is to have their
common ancestor do the work (e.g. run /lib/udev/scsi_id + friends) on
the 'add' uevent, not on some 'change' uevent later... there is just no
way it will work otherwise.

If we didn't care about backward compat, maybe it could look like this

 0:0:0:0
 +-- dev    <-- this is dev file for the bsg device
 |
 +-- block
 |   +-- sdb
 |   |   +-- dev  <-- this is the dev file for the block device

so we get the bsg device as the first uevent and the block device with
the other one. With this setup we'd run /lib/udev/scsi_id + friends on
the bsg device node and then we'd import it for the block device node
and everything would be good.

That said, I don't think we can make such a change as it would probably
break some parts of user space...

    David


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
