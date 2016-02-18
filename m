From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Thu, 18 Feb 2016 11:27:13 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1602181121010.1280-100000@iolanthe.rowland.org>
References: <CAM79t8HzYT+s0BrqzZ0-Cv7khzn6CvpE5bfnJ6H9xYCx4RkS8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35554 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1946877AbcBRQ1O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2016 11:27:14 -0500
In-Reply-To: <CAM79t8HzYT+s0BrqzZ0-Cv7khzn6CvpE5bfnJ6H9xYCx4RkS8g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexandre Rossi <alexandre.rossi@gmail.com>
Cc: Paul Menzel <paul.menzel@giantmonkey.de>, Erich Schubert <erich@debian.org>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org

On Tue, 9 Feb 2016, Alexandre Rossi wrote:

> Hi,
>=20
> netconsole does not seem to work so early in the boot process this ti=
me.
>=20
> > As this is Linux 4.3 and not 4.4, I guess this is a different probl=
em
> > though. Alexandre, where you able to capture the stack trace? I=E2=80=
=99d submit
> > a new bug report with this.
>=20
> Here is a photo. Please ping me if you need to test some debugging pa=
tches.

It looks like the problem occurs in blk_post_runtime_resume().  Since=20
there have been recent changes to this routine, it's hard to tell=20
whether you're using the most up-to-date code.

In particular, the first few lines of blk_post_runtime_resume() in=20
block/blk-core.c should look like this:

void blk_post_runtime_resume(struct request_queue *q, int err)
{
	if (!q->dev)
		return;

The test was introduced by commit 4fd41a8552af ("SCSI: Fix NULL pointer
dereference in runtime PM"), which was added to the mainline kernel
between 4.3 and 4.4.  I don't know what the commit ID would be for a
=2Estable kernel.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
