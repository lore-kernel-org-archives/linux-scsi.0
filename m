From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 18:01:51 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120180151.A18616@infradead.org>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:13320 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265643AbUATSBx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 13:01:53 -0500
Content-Disposition: inline
In-Reply-To: <400D5A28.1000301@us.ibm.com>; from brking@us.ibm.com on Tue, Jan 20, 2004 at 10:41:12AM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 20, 2004 at 10:41:12AM -0600, Brian King wrote:
> > Please do.  Also what about making this and the above one condition=
al on
> > some debugging option?
>=20
> How about a kernel config option for this? I don't want to make it to=
o=20
> difficult for people to enable it as it is exceedingly valuable for=20
> failure analysis.

Yes, that's what I meant.

> > Given all the mess these invisble devices create I think they shoul=
dn't
> > be invisble but rather exported as a second pseudo-channel on the h=
ost.
>=20
> Ok. That would solve a lot of problems. I will report these devices i=
n=20
> as scsi disk devices. They will respond like normal SCSI disks, excep=
t=20
> when issued media commands (read/write) it will fail with data protec=
t=20
> (07) sense data.

Now reading this again it might be better to use the "fake" as in not
registered with the device model devices I mentioned below for this.

> Yes. Should be able to. By getting rid of all this code, one problem =
we=20
> will need to solve is the following:
>=20
> 1. Driver is up and running with a disk array.
> 2. Adapter gets reset for some reason (could be due to an adapter err=
or)
> 3. Disk array device now needs a START_UNIT command.
>=20
> The current mid-layer/sd will not handle this. Would you accept a pat=
ch=20
> to add this function?

I'm not against this, but I wonder how such a patch would look like

> Ok, but I will still need that interface to send commands directed to=
=20
> the adapter.

commands as in scsi commands or as in internal commands?

> >>Build a command in DMA'able host memory (struct ipr_ioarcb), write =
the=20
> >>PCI address to a register on the adapter, the adapter DMAs down the=
=20
> >>control block, executes the command, writes the=20
> >>ipr_ioarcb.host_response_handle in the command control block to the=
 host=20
> >>request/response queue in host memory, and signals an interrupt.
> >>
> >>Does that help at all?
> >=20
> > What's the relation of all these command lists to that?
>=20
> Sorry, I guess I'm missing something here. Are you saying a LLD=20
> shouldn't need to maintain of queue of its command blocks (like my=20
> pending_q and free_q)?

Unless you allocate the blocks in ->queuecommand (like most modern driv=
ers
do) you'll need some form of freelist of course.  What you shouldn't ne=
ed i=DF
the pendig_q as the midlayer already keeps track of pending commands.
This of course only works if you actually do send all commands via the
midlayer (which you should).

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
