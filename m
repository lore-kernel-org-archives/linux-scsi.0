From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: usb-storage and Sony Handycam
Date: Mon, 10 Nov 2003 09:59:14 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20031110095914.B22518@beaverton.ibm.com>
References: <20031108123749.A3892@beaverton.ibm.com> <Pine.LNX.4.44L0.0311082220430.7127-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311082220430.7127-100000@netrider.rowland.org>; from stern@rowland.harvard.edu on Sat, Nov 08, 2003 at 10:47:26PM -0500
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

On Sat, Nov 08, 2003 at 10:47:26PM -0500, Alan Stern wrote:
> On Sat, 8 Nov 2003, Patrick Mansfield wrote:
> 
> > On Sat, Nov 08, 2003 at 11:28:37AM -0500, Alan Stern wrote:

> > A DID_ERROR causes scsi core to retry the command - it will not even check
> > the sense data. A DID_ABORT might be better, scsi core will not retry.
> > (We still have issue 1, where the host byte is not checked in
> > scsi_status_is_good.)
> 
> For CB and CBI devices, babble causes a DID_ERROR return.  For Bulk-only 
> it causes a Check-Condition status to be returned along with Invalid 
> Command sense data.  Like I said earlier, we haven't yet figured out the 
> best way to handle these errors.

The DID_ERROR should be changed to DID_ABORT for the babble case so scsi
core won't retry the command generating the babble.  

I don't know why scsi core retries on DID_ERROR, as code comments say
DID_ERROR is an internal error. DID_SOFT_ERROR is the same as DID_ERROR
(as far as scsi core cares), execept for a check for reservation conflict.

> > Dmitri's change (return USB_STOR_XFER_STALL instead of USB_STOR_XFER_LONG)
> > causes us to return USB_STOR_TRANSPORT_GOOD vs USB_STOR_TRANSPORT_ERROR in
> > usb_stor_CB_transport. 
> > 
> > Then in usb_stor_invoke_transport we issue a REQUEST SENSE. 
> > 
> > If for a USB_STOR_TRANSPORT_ERROR we also did a REQUEST SENSE, the
> > following command (TEST UNIT READY) would not get the ILLEGAL REQUEST.
> 
> That doesn't make sense.  USB_STOR_TRANSPORT_ERROR means we aren't able to 
> communicate with the device.  So how can we send it a REQUEST-SENSE?

No that should not be done, I was trying to figure out and explain why he
did not get the ILLEGAL REQUEST for TEST UNIT READY.

Has anyone looked at why the reset failed? I assume that would clear the
sense.

> > I don't know why the TEST UNIT READY caused an auto REQUEST SENSE to
> > be sent.
> 
> The CB transport doesn't include any means for the device to return
> status.  (Yes, it's stupid.)  The only way we can find out is to issue
> auto REQUEST-SENSE for virtually every command.
> 
> > Changing the sense stuff does not address the MODE SENSE failing, we still
> > have 3 separate issues that are all hit by this device.
> 
> If we simply avoided sending the MODE-SENSE in the first place, none of 
> the other issues would come up.  IMHO that's the best solution.

Yes.

We still have the missed check in scsi_status_is_good.

And, the sense coming back for a previous command returning babble is still
an issue.

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
