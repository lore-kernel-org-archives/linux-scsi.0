From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
Date: Sun, 23 Aug 2009 14:22:34 -0400
Message-ID: <4A9188EA.2080903@interlog.com>
References: <Pine.LNX.4.44L0.0908222002110.9952-100000@netrider.rowland.org> <31690E3D-43A0-484D-9D65-C0003E033D1E@ime.usp.br>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933585AbZHWSWm@vger.kernel.org>
In-Reply-To: <31690E3D-43A0-484D-9D65-C0003E033D1E@ime.usp.br>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

Rog=E9rio Brito wrote:
> Hi again, Alan.
>=20
> (Sorry if this message seems messed up, but I am not using my regular=
=20
> mailer right now, unfortunately).
>=20
> On 2009-08-22, at 21:17, Alan Stern wrote:
>=20
>> On Sat, 22 Aug 2009, Rog=E9rio Brito wrote:
>>
>>> The requested trace is attached to this message. Please let me know=
 if
>>> you need more information.
>>
>> The trace shows that something (presumably smartctl) sends a command
>> the drive doesn't understand.  The drive then violates the USB
>> mass-storage protocol, sending an invalid response.
>=20
> Right.
>=20
>> The kernel waits
>> for a proper response but nothing more happens, so after 30 seconds =
the
>> command times out and is aborted and the drive is reset.
>=20
> I'm not with the kernel sources here (so, I can't check the code), bu=
t=20
> is there any option to be able to log such invalid responses when the=
=20
> kernel gets one? Perhaps the verbose USB logging does that?
>=20
>> The command
>> then gets retried, and the same thing happens again.  The retries ta=
ke
>> so long that the kernel complains about smartctl being blocked for m=
ore
>> than 120 seconds -- that's the reason for the stack dump.
>=20
> Right.
>=20
> Geeez, Alan, is there any vendor out there that gets the USB=20
> implementation according to the specs?

The fact that you invoked:
   smartctl -d usbcypress -a /dev/sda

means that the cypress chip does not comply with SAT.
To find out what commands are being sent (via the SG_IO
ioctl I presume) by smartctl please try adding:
   '-r ioctl,3'
to the above invocation.


Doug Gilbert
