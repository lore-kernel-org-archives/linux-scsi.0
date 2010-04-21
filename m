From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 10:04:54 -0400
Message-ID: <1271858694.2893.47.camel@mulgrave.site>
References: <593030.61801.qm@web31804.mail.mud.yahoo.com>
	 <4BCF0310.4000906@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BCF0310.4000906@pobox.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Mark Lord <mlord@pobox.com>
Cc: ltuikov@yahoo.com, Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-04-21 at 09:52 -0400, Mark Lord wrote:
> On 21/04/10 08:47 AM, Luben Tuikov wrote:
> >>>>    starts at line 8816.  (It says the
> >> command
> >>>> is a BLANK command, but it's incorrectly
> >> identified that command.)
> >
> > Application clients should send ATA PASS-THROUGH (16) and never the
> 12 byte version to ATAPI devices behind a SAT bridge, whose opcode is
> interpreted as BLANK (as pointed out by Doug), and BLANK executed.
> ..

> That's a nice self-proclamation.
> Got a pointer to a SAT or ATA/SATA standard that says it for real?

I'm afraid it's just part of the usual standards confusion.  I think
what they were thinking is that no-one would use SATL with ATAPI ...
although I bet someone will ...

> The problem with that statement (above), becomes.. what to use
> for the initial IDENTIFY request, before the type of device is known?

But this isn't a userspace problem.  By the time we present the device
to userspace, we already know what it is ... so you can go by device
type and only use ATA_12 for disk devices.

For kernel space, we never use the encapsulation commands anyway, we
always go by the transport.

James



