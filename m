From: Jens Axboe <axboe@suse.de>
Subject: Re: 2.6.11-rc[1,2]-mmX scsi cdrom problem, 2.6.10-mm2 ok
Date: Mon, 31 Jan 2005 14:53:24 +0100
Message-ID: <20050131135323.GA2766@suse.de>
References: <200501310034.32005.cova@ferrara.linux.it> <20050131080021.GA9446@suse.de> <200501311108.19593.cova@ferrara.linux.it> <20050131110550.GA5058@suse.de> <41FE1B39.6030702@torque.net> <20050131114943.GD5058@suse.de> <41FE2DFB.1090801@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:56222 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261197AbVAaNxf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 08:53:35 -0500
Content-Disposition: inline
In-Reply-To: <41FE2DFB.1090801@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Fabio Coatti <cova@ferrara.linux.it>, akpm@osdl.org, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Mon, Jan 31 2005, Douglas Gilbert wrote:
> Jens Axboe wrote:
> >On Mon, Jan 31 2005, Douglas Gilbert wrote:
> >
> >>Jens Axboe wrote:
> >>
> >>>On Mon, Jan 31 2005, Fabio Coatti wrote:
> >>>
> >>>
> >>>>Alle 09:00, luned=EC 31 gennaio 2005, Jens Axboe ha scritto:
> >>>>
> >>>>
> >>>>>>At this point k3b is stuck in D stat, needs reboot.
>=20
> I was able to replicate this with a USB burner.
> My system didn't need a reboot. The "D" state was locked
> on "blk_execute_rq". The burner was still accessible via
> sg.

With a slave burner on the same interface as your hard drive, it would
soft hang the system.

> >>>>>The most likely suspect is the REQ_BLOCK_PC scsi changes. Can yo=
u try
> >>>>>2.6.11-rc2-mm1 with bk-scsi backed out? (attached)
> >>>>
> >>>>just tried, right guess :)
> >>>>backing out that patch the problem disappears.
> >>>>Let me know if you need to narrow further that issue.
> >>>
> >>>
> >>>Doug, it looks like your REQ_BLOCK_PC changes are buggy. Let me kn=
ow if
> >>>you cannot find the full post and I'll forward it to you.
> >>
> >>Jens,
> >>Hmm. Found the thread on lkml. I got an almost identical
> >>lock up in k3b with a USB external cd/dvd drive recently.
> >>My laptop didn't need rebooting (probably since the root
> >>fs is one an ide disk).
> >>
> >>That is a quite large patch that you referenced. I'll
> >>try and replicate and report back.
> >
> >
> >My guess would be the scsi_lib changes, I would suggest you start th=
ere.
>=20
> Indeed. I'm not sure what I was thinking in
> scsi_io_completion(). This small reversion
> fixes my k3b problem; tested with a USB external
> burner.

Well at least I had hoped you would have tested patches going into
mainline...

Can you make sure it gets to Linus asap? Otherwise I'm sure I'll be
flooded with mails on burning not working very shortly.

--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
