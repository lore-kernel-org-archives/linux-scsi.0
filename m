From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
Date: Sat, 22 Aug 2009 20:17:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908222002110.9952-100000@netrider.rowland.org>
References: <20090822211430.GA2547@ime.usp.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:57983 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752089AbZHWARb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2009 20:17:31 -0400
In-Reply-To: <20090822211430.GA2547@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org

On Sat, 22 Aug 2009, [utf-8] Rog=C3=A9rio Brito wrote:

> Hi, Alan.
>=20
> On Aug 21 2009, Alan Stern wrote:
> > A usbmon trace showing what happens when you plug in the drive and
> > when you run smartctl would help.
>=20
> The requested trace is attached to this message. Please let me know i=
f
> you need more information.

The trace shows that something (presumably smartctl) sends a command
the drive doesn't understand.  The drive then violates the USB
mass-storage protocol, sending an invalid response.  The kernel waits
for a proper response but nothing more happens, so after 30 seconds the
command times out and is aborted and the drive is reset.  The command
then gets retried, and the same thing happens again.  The retries take
so long that the kernel complains about smartctl being blocked for more
than 120 seconds -- that's the reason for the stack dump.

So the problem has several causes.  One is that the drive is buggy (it
doesn't respond with an error code in the proper way when it receives a
command it doesn't understand).  Another is that smartctl is trying to
send commands in a form the drive can't handle.  Finally, there's the
problem about all the retries taking too long.

Perhaps you can blame the kernel for spending too much time on retries,=
=20
but the other two are the fault of the drive and smartctl.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
