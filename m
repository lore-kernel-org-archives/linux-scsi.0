From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: usb-storage and Sony Handycam
Date: Sat, 8 Nov 2003 12:37:49 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20031108123749.A3892@beaverton.ibm.com>
References: <20031107223444.A1747@beaverton.ibm.com> <Pine.LNX.4.44L0.0311081105351.28814-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311081105351.28814-100000@netrider.rowland.org>; from stern@rowland.harvard.edu on Sat, Nov 08, 2003 at 11:28:37AM -0500
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitri Katchalov <dmitrik@users.sourceforge.net>, Idan Sofer <idan@idanso.dyndns.org>, ronald@kuetemeier.com, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 08, 2003 at 11:28:37AM -0500, Alan Stern wrote:
> On Fri, 7 Nov 2003, Patrick Mansfield wrote:

> > Looking at usb/storage/transport.c, we are not generating the usb
> > "fake_sense" with your change.
> > 
> > Maybe the failed MODE SENSE had a check condition, but the fake_sense
> > prevented us from retrieving it?
> 
> No, the "babble" prevented that.

> The "fake sense" is a compromise.  It lets us give a clear indication to 
> the higher layers that something is wrong and asks them not to send the 
> same command again.  But it doesn't do much about getting the device back 
> into a working state (if that's even possible).

Looking closer at the USB code, is the fake_sense code even hit? The logs
do not show any of the US_DEBUGP in usb_stor_Bulk_transport(), like
"Bulk Command S ...".

A DID_ERROR causes scsi core to retry the command - it will not even check
the sense data. A DID_ABORT might be better, scsi core will not retry.
(We still have issue 1, where the host byte is not checked in
scsi_status_is_good.)

> > So the next command sent got a check condition, illegal request.
> > 
> > That still doesn't tell us why the MODE SENSE failed, and why the failure
> > does not show up with 2.4.
> 
> The best approach for doing this is to have a side-by-side comparison of 
> the usb-storage debugging logs for 2.4 and 2.6.

Yes, we do not have a 2.4 trace of the same device.

> I think we have to assume 
> that the MODE-SENSE failed because the device simply doesn't support it 
> correctly.
> 
> > Can you run the variants on MODE SENE via user space SG_IO, and figure out
> > which ones work?

Still no data on the above (from Dmitri or Ronald).

> > 3) The next command - TEST UNIT READY - gets a check condition, illegal
> > request. Maybe the fake sense handling is screwing things up - the device
> > tells us it sent back more data than we asked for, but it is also trying
> > to check us.
> 
> I don't understand your speculation here.  It seems clear to me that this 
> is a situation where the device and the host are out of sync -- the host 
> sends a command and the device sends back status from the _previous_ 
> command.  Repeating the TEST-UNIT-READY may bring us back in sync.  Or 
> maybe some sort of reset will -- no way to tell without trying it.

The sense data is not cleared until it is retrieved, so if there is sense
waiting, and we do not send a REQUEST SENSE, the next REQUEST SENSE will
retrieve the pre-existing sense data (see SAM-3, I am looking at
sam3r07.pdf, section 5.9.6 sense data).

If the actual result of the command was checked in the babble cases, and a
REQUEST SENSE sent, it might have gotten the ILLEGAL REQUEST, and the
devices sense data might be cleared. It might be bad to do anything for
babble cases, but the REQUEST SENSE should be sent to at least clear out
any real sense data if we are going to generate our own fake sense.

Dmitri's change (return USB_STOR_XFER_STALL instead of USB_STOR_XFER_LONG)
causes us to return USB_STOR_TRANSPORT_GOOD vs USB_STOR_TRANSPORT_ERROR in
usb_stor_CB_transport. 

Then in usb_stor_invoke_transport we issue a REQUEST SENSE. 

If for a USB_STOR_TRANSPORT_ERROR we also did a REQUEST SENSE, the
following command (TEST UNIT READY) would not get the ILLEGAL REQUEST.

I don't know why the TEST UNIT READY caused an auto REQUEST SENSE to
be sent.

Changing the sense stuff does not address the MODE SENSE failing, we still
have 3 separate issues that are all hit by this device.

-- Patrick Mansfield


-------------------------------------------------------
This SF.Net email sponsored by: ApacheCon 2003,
16-19 November in Las Vegas. Learn firsthand the latest
developments in Apache, PHP, Perl, XML, Java, MySQL,
WebDAV, and more! http://www.apachecon.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
