From: "Juergen E. Fischer" <fischer@linux-buechse.de>
Subject: Re: [PATCH] [v2] aha152x cmnd->device oops
Date: Wed, 29 Oct 2003 13:20:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029122008.GA5903@linux-buechse.de>
References: <20031027155713.GA28140@lst.de> <20031027160101.76d5291b.rddunlap@osdl.org> <20031028090600.GA7370@lst.de> <20031028124536.3ce82c23.rddunlap@osdl.org> <3F9EF2B4.9030708@us.ibm.com> <20031028162610.6dcfd06e.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pD9ED18AC.dip.t-dialin.net ([217.237.24.172]:45211 "EHLO
	linux-buechse.de") by vger.kernel.org with ESMTP id S262040AbTJ2MYI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 07:24:08 -0500
Content-Disposition: inline
In-Reply-To: <20031028162610.6dcfd06e.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fischer@norbit.de

Hi Randy,

On Tue, Oct 28, 2003 at 16:26:10 -0800, Randy.Dunlap wrote:
> On Tue, 28 Oct 2003 14:50:28 -0800 Mike Christie <mikenc@us.ibm.com> =
wrote:
>=20
> | Hi Randy,
> |=20
> | >  			if(!(DONE_SC->SCp.Status & not_issued)) {
> | > -				Scsi_Cmnd *cmnd =3D kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC);
> | > +				Scsi_Cmnd *cmnd =3D scsi_get_command(DONE_SC->device, GFP_AT=
OMIC);
> |=20
> | Do you need to add a scsi_put_command to balance this get when the=20
> | command completes?
> |=20
> | > +					cmnd->device          =3D ptr->device;
> |=20
> | Don't even need this now. scsi_get_command will set the device for =
you.
> |=20
> | Mike
>=20
> Hers's v3 of the aha152x patch.  However, I'm not satisfied with it,
> so I'm not asking James to apply it.  I don't know the state machine
> or the hardware well enough to understand and patch it.

> Things that I don't like about it:
>=20
> a.  calling aha152x_internal_queue() with cmnd pointer in 2 places.
>     Probably the second one should be NULL.
> b.  Easy to confuse the state machine by changing just one variable,
>     like DONE_SC (i.e., it's risky and I can't test it, although we
>     do have a bug report and can ask that reporter to test it).
> c.  int result =3D SCpnt->SCp.Status; /*FIXME*/
>     SCp.Status is not valid here AFAIK, and I don't know how to get
>     the current command status at this point.

There are 2 specially "commands" which are used internally in the drive=
r
only (so I don't see a problem in using kmalloc instead of
scsi_get_command; but nevertheless ->device needs to be intialized
correctly, which is what scsi_get_command() does and the current code
fails to do).=20

The first is when a command returns with status CHECK CONDITION and the
driver needs to do a REQUEST SENSE to fetch sense data and add that to
the Ssci_Cmnd which resulted in the CHECK CONDITION.  The internally
queued command fills the sense_buffer of the offending command and then
calls its ->scsi_done().

The second it when the controller needs to be resetted.  Both are purel=
y
internal to the driver.

I'll test this in the evening.


J=FCrgen

--=20
Phase 1: Where do you want to go today?
Phase 2: This is where you want to go today.
Phase 3: You're not going anywhere today.
  -- seen on /.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
