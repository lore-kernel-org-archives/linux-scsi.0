From: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl on an USB disk
Date: Sun, 23 Aug 2009 12:11:50 -0300
Message-ID: <31690E3D-43A0-484D-9D65-C0003E033D1E@ime.usp.br>
References: <Pine.LNX.4.44L0.0908222002110.9952-100000@netrider.rowland.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=ISO-8859-1;
	delsp=yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933772AbZHWPNY@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0908222002110.9952-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi again, Alan.

(Sorry if this message seems messed up, but I am not using my regular =20
mailer right now, unfortunately).

On 2009-08-22, at 21:17, Alan Stern wrote:

> On Sat, 22 Aug 2009, Rog=E9rio Brito wrote:
>
>> The requested trace is attached to this message. Please let me =20
>> know if
>> you need more information.
>
> The trace shows that something (presumably smartctl) sends a command
> the drive doesn't understand.  The drive then violates the USB
> mass-storage protocol, sending an invalid response.

Right.

> The kernel waits
> for a proper response but nothing more happens, so after 30 seconds =20
> the
> command times out and is aborted and the drive is reset.

I'm not with the kernel sources here (so, I can't check the code), =20
but is there any option to be able to log such invalid responses when =20
the kernel gets one? Perhaps the verbose USB logging does that?

> The command
> then gets retried, and the same thing happens again.  The retries tak=
e
> so long that the kernel complains about smartctl being blocked for =20
> more
> than 120 seconds -- that's the reason for the stack dump.

Right.

Geeez, Alan, is there any vendor out there that gets the USB =20
implementation according to the specs?

This is the 3rd USB device that I sent you some message about where =20
the kernel moans about something that it doesn't understand (I can =20
get you the vendor and device ids when I get home).

I will test with some other devices that I have, just to see what =20
their response is. :-(

> So the problem has several causes.  One is that the drive is buggy (i=
t
> doesn't respond with an error code in the proper way when it =20
> receives a
> command it doesn't understand).  Another is that smartctl is trying t=
o
> send commands in a form the drive can't handle.

That's probably not smartctl, but the user (me) that is telling it to =20
use a given command set to check if the USB adapter understands/=20
allows pass-thru of the SMART protocol to the drive.

> Finally, there's the
> problem about all the retries taking too long.

Is there anything that could be done about this?

> Perhaps you can blame the kernel for spending too much time on =20
> retries,
> but the other two are the fault of the drive and smartctl.

I understand the p-o-v of the kernel: some devices need a little bit =20
more time on a retry, while others don't. There's no way to hardcode =20
a once and for all behavior. It seems that an expensive solution to =20
this would be to create (yet) another list of blacklisted devices =20
(how many lists of quirks do we have in the kernel already---this is =20
really causing some bloat, especially for some embedded devices). :-(

OTOH, creating blacklists seem to not be the adequate (let alone =20
"right") solution (see the ASUS/it87 monitoring cause) in many =20
situations. :-/


Thanks for your always kind messages, Rog=E9rio Brito.
