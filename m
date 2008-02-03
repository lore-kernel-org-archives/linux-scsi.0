From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Sun, 3 Feb 2008 11:01:29 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802031025180.12447-100000@netrider.rowland.org>
References: <47A5825D.2030901@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47A5825D.2030901-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Sorry, I understood only about half of what you wrote -- maybe less!

On Sun, 3 Feb 2008, Boaz Harrosh wrote:

> On Thu, Jan 31 2008 at 22:56 +0200, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:

> > I still don't understand.  Can you explain exactly what an overflow 
> > condition (negative residue) really means?
> As far as the protocol it is an error condition. But it is an error
> condition that should be handled and io should continue. What it usually means
> is that either target or Initiator had, like you said, more data then
> expected. Usually an encoding error of the different stages of transfer
> like sum of R2Ts or DATA is bigger then CDB length and so on.
> The important thing is that the system should continue, and that this
> is not a check_condition error.

What is an R2T?

How does a negative residue differ from a Phase error?

What exactly do you mean by "more data then expected"?  The USB 
mass-storage protocol specifies the length of a transfer in at least 
three different places, and those places won't always agree:

    (1) For some commands, the device may have a specific amount
	of data it can supply or expect to receive.  For example,
	the device might have 90 bytes of INQUIRY data available.

    (2) Many CDBs include a field specifying how much data should
	be transferred (INQUIRY does).  The amount of data actually
	transferred is supposed to be the smaller of this value
	and the size in (1).

    (3) The USB Bulk-only transport includes fields in the CDB
	wrapper specifying the number of bytes the host expects to 
	transfer and the direction.

If (3) is different from (2) or if the direction disagrees with what
the device expects, the device is supposed to return a Phase error.
If (1) < (2) = (3) then it isn't an error; in this case the residue is
given by (2) - (1).  If (1) > (2) = (3) then according to the USB
protocol nothing special happens -- no error and residue = 0.  
(Note however that the INQUIRY response data includes a field in which 
the device can tell the host that more data is available.)

In no cases does this allow for a negative residue.

> > Does it mean that the device had more data available than the host
> > asked for?  If it does, then you don't need to change the isd200 code
> > at all.  The changes to protocol.c will be enough.
> I do in the sense that the target should return correct information requested.

Doesn't the existing code in isd200 together with your changes to
protocol.c do exactly that?

> overflow is still an error.

Once again: What exactly do you mean by "overflow"?  In what sense is 
it an error?

> A recoverable but none-standard error. The INQUIRY
> has 3 flavors based on requested size. The target should comply.

What 3 flavors are you talking about?  As far as I know there's only 
one type of INQUIRY command.

> > However you should realize that usb-storage, as it stands, won't work
> > properly with negative residues.  Look at usb_stor_Bulk_transport() in
> > transport.c.  The residue variable is declared to be unsigned int.  
> > There's also code later on in the routine which assumes the residue is
> > never negative.
> > 
> > Alan Stern
> > 
> > -
> I will change that, but if you don't mind with a FIXME: comment next
> to it. I will set resid to 1 and set the cmnd->status.

Where will you change this?  Why set resid to 1?  That means the device 
sent 1 byte less than the host expected.

> Setting of command
> status is ineffective as it is, most probably, been set afterwards.

After what?

> Should I also put a WARN_ON()? I would say yes.
> I'll send a patch.

Maybe this will be more clear once you do.  As it is, I'm totally in 
the dark.

Alan Stern
