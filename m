From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] usb-storage and Sony Handycam
Date: Sat, 8 Nov 2003 22:47:26 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311082220430.7127-100000@netrider.rowland.org>
References: <20031108123749.A3892@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:33041 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S262131AbTKIDr0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Nov 2003 22:47:26 -0500
In-Reply-To: <20031108123749.A3892@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Dmitri Katchalov <dmitrik@users.sourceforge.net>, Idan Sofer <idan@idanso.dyndns.org>, ronald@kuetemeier.com, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 8 Nov 2003, Patrick Mansfield wrote:

> On Sat, Nov 08, 2003 at 11:28:37AM -0500, Alan Stern wrote:
> 
> > The "fake sense" is a compromise.  It lets us give a clear indication to 
> > the higher layers that something is wrong and asks them not to send the 
> > same command again.  But it doesn't do much about getting the device back 
> > into a working state (if that's even possible).
> 
> Looking closer at the USB code, is the fake_sense code even hit? The logs
> do not show any of the US_DEBUGP in usb_stor_Bulk_transport(), like
> "Bulk Command S ...".

It probably wasn't hit.  The fake sense data is only sent for devices 
using the Bulk-only transport, and Dmitri's and Idan's devices use the 
Control-Bulk transport IIRC.

> A DID_ERROR causes scsi core to retry the command - it will not even check
> the sense data. A DID_ABORT might be better, scsi core will not retry.
> (We still have issue 1, where the host byte is not checked in
> scsi_status_is_good.)

For CB and CBI devices, babble causes a DID_ERROR return.  For Bulk-only 
it causes a Check-Condition status to be returned along with Invalid 
Command sense data.  Like I said earlier, we haven't yet figured out the 
best way to handle these errors.

> > > That still doesn't tell us why the MODE SENSE failed, and why the failure
> > > does not show up with 2.4.
> > 
> > The best approach for doing this is to have a side-by-side comparison of 
> > the usb-storage debugging logs for 2.4 and 2.6.
> 
> Yes, we do not have a 2.4 trace of the same device.
> 
> > I think we have to assume 
> > that the MODE-SENSE failed because the device simply doesn't support it 
> > correctly.
> > 
> > > Can you run the variants on MODE SENE via user space SG_IO, and figure out
> > > which ones work?
> 
> Still no data on the above (from Dmitri or Ronald).

Doing that will probably be a waste of time.  I firmly believe that there 
is _no_ least common denominator among USB mass storage devices: Some 
work with any MODE-SENSE command, some work with only a few variants, 
others work with others.  Maybe some devices don't work with MODE-SENSE at 
all.  In any case, there isn't any single combination of 
pages/transfer-lengths that will be accepted by every device.  And when a 
device fails to accept such a command it often does so catastrophically, 
requiring a power-cycle to start working again.

The only safe course is to avoid sending these commands at all to the 
devices that can't handle them.

> > > 3) The next command - TEST UNIT READY - gets a check condition, illegal
> > > request. Maybe the fake sense handling is screwing things up - the device
> > > tells us it sent back more data than we asked for, but it is also trying
> > > to check us.
> > 
> > I don't understand your speculation here.  It seems clear to me that this 
> > is a situation where the device and the host are out of sync -- the host 
> > sends a command and the device sends back status from the _previous_ 
> > command.  Repeating the TEST-UNIT-READY may bring us back in sync.  Or 
> > maybe some sort of reset will -- no way to tell without trying it.
> 
> The sense data is not cleared until it is retrieved, so if there is sense
> waiting, and we do not send a REQUEST SENSE, the next REQUEST SENSE will
> retrieve the pre-existing sense data (see SAM-3, I am looking at
> sam3r07.pdf, section 5.9.6 sense data).

Hmmm...  I'm more used to an earlier version of the SCSI protocol,
according to which old sense data is lost whenever a new command is
received unless that command is REQUEST-SENSE.

> If the actual result of the command was checked in the babble cases, and a
> REQUEST SENSE sent, it might have gotten the ILLEGAL REQUEST, and the
> devices sense data might be cleared. It might be bad to do anything for
> babble cases, but the REQUEST SENSE should be sent to at least clear out
> any real sense data if we are going to generate our own fake sense.

There's isn't any reliable way to get the command result or the sense data
after a babble occurs -- in fact, there isn't a reliable way to
re-establish communication with the device at all.  My best thought on
this has been to try reading (and throwing away) data from the device
until a 5-second (for example) timeout expires without receiving anything,
then issue a device reset.  That's more likely to recover from this sort
of error than anything else I can think of, but it's never been 
implemented.

I have seen logs from users where a device reset was sent following a 
babble error.  It didn't help; the device remained wedged.

The USB Mass Storage specification documents are silent on the issue of
babble.  And even if they weren't it probably wouldn't help; the only
reason these devices start babbling is because they aren't compliant with
the standards in the first place.

> Dmitri's change (return USB_STOR_XFER_STALL instead of USB_STOR_XFER_LONG)
> causes us to return USB_STOR_TRANSPORT_GOOD vs USB_STOR_TRANSPORT_ERROR in
> usb_stor_CB_transport. 
> 
> Then in usb_stor_invoke_transport we issue a REQUEST SENSE. 
> 
> If for a USB_STOR_TRANSPORT_ERROR we also did a REQUEST SENSE, the
> following command (TEST UNIT READY) would not get the ILLEGAL REQUEST.

That doesn't make sense.  USB_STOR_TRANSPORT_ERROR means we aren't able to 
communicate with the device.  So how can we send it a REQUEST-SENSE?

> I don't know why the TEST UNIT READY caused an auto REQUEST SENSE to
> be sent.

The CB transport doesn't include any means for the device to return
status.  (Yes, it's stupid.)  The only way we can find out is to issue
auto REQUEST-SENSE for virtually every command.

> Changing the sense stuff does not address the MODE SENSE failing, we still
> have 3 separate issues that are all hit by this device.

If we simply avoided sending the MODE-SENSE in the first place, none of 
the other issues would come up.  IMHO that's the best solution.

Alan Stern

