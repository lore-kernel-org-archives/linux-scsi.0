From: john smith <whalajam@yahoo.com>
Subject: Re: scsi_host_template.queuecommand() instances
Date: Sun, 27 Feb 2011 23:21:20 -0800 (PST)
Message-ID: <439834.81106.qm@web161913.mail.bf1.yahoo.com>
References: <20110227222102.GH13726@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web161913.mail.bf1.yahoo.com ([98.139.211.221]:36261 "HELO
	web161913.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750919Ab1B1H2B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2011 02:28:01 -0500
In-Reply-To: <20110227222102.GH13726@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

> Not correct, they could easily be for the same LUN.

Of course, if there are concurrent application threads accessing the sa=
me (Target,LUN).

> Linux doesn't use threads like this ... what usually
> happens is a
> user thread makes a syscall (eg write() or read()) or
> faults on an
> mmaped region.  The thread switches into kernel mode,
> and winds its way
> through the file system, into the page cache, then the
> block layer, down
> to the scsi layer, and invokes queuecommand.  Once
> queuecommand finishes,
> the thread returns to the page cache to wait for the I/O to
> complete.

How does the queuecommand get called for concurrent application threads=
  before 2.6.37?

thanks,
John=20


--- On Sun, 2/27/11, Matthew Wilcox <matthew@wil.cx> wrote:

> From: Matthew Wilcox <matthew@wil.cx>
> Subject: Re: scsi_host_template.queuecommand() instances
> To: "john smith" <whalajam@yahoo.com>
> Cc: linux-scsi@vger.kernel.org
> Date: Sunday, February 27, 2011, 2:21 PM
> On Sun, Feb 27, 2011 at 11:22:06AM
> -0800, john smith wrote:
> > I understand that inside LDD's
> scsi_host_template.queuecommand(), the card->spinlock can
> be used to protect shared data between concurrent instances
> of queuecommand and bottom-half/tasklets IO completion
> code.
> > For SMP system with PCIE/MSIX enabled interrupts,
> there can be multiple instances of completion tasklets.
> > The questions I have are:
> >=A0=20
> > - can there be multiple instances of queuecommand as
> well?
>=20
> Yes, queuecommand can be called on multiple CPUs
> simultaneously.
> That's only been true since 2.6.37, though.
>=20
> > - if so, I would assume they are IO commands issued
> for different targets (controlled by LDD), correct?
>=20
> Not correct, they could easily be for the same LUN.
>=20
> > Also, if true, these multiple instances must be
> running on different kernel threads spwaned by the SCSI mid
> layer, or block layer?
>=20
> Linux doesn't use threads like this ... what usually
> happens is a
> user thread makes a syscall (eg write() or read()) or
> faults on an
> mmaped region.=A0 The thread switches into kernel mode,
> and winds its way
> through the file system, into the page cache, then the
> block layer, down
> to the scsi layer, and invokes queuecommand.=A0 Once
> queuecommand finishes,
> the thread returns to the page cache to wait for the I/O to
> complete.
>=20
> > Links to detailed and uptodate Block layer description
> would be appreciated (the ones I found are either old and
> superficial),
>=20
> It's a lot of effort to keep these things up to date, and
> generally those
> making the changes don't have the interest in updating
> documentation.
>=20
> --=20
> Matthew Wilcox=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 Intel Open Source
> Technology Centre
> "Bill, look, we understand that you're interested in
> selling us this
> operating system, but compare it to ours.=A0 We can't
> possibly take such
> a retrograde step."
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
