From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: usb-storage and Sony Handycam
Date: Fri, 7 Nov 2003 09:29:10 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20031107092910.A3471@beaverton.ibm.com>
References: <1068207145.3fab8c2988d43@webmail.netregistry.net> <Pine.LNX.4.44L0.0311071117160.1577-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311071117160.1577-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Fri, Nov 07, 2003 at 11:21:48AM -0500
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>, Dmitri Katchalov <dmitrik@users.sourceforge.net>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 07, 2003 at 11:21:48AM -0500, Alan Stern wrote:
> On Fri, 7 Nov 2003, Dmitri Katchalov wrote:

> > I investigated it a little and that's what I found:
> > This device uses CB transport (SENSE status not reported).
> > This device does not support MODE_SENSE at all.
> > MODE_SENSE(6) fails with STALL condition. Subsequent 
> > REQUEST-SENSE reports ILLEGAL REQUEST. SCSI layer is 
> > able to handle this situation, the only drawback is 
> > that write-protect status is not reported.
> > 
> > Unfortunately usb-storage sets use_10_for_ms flag 
> > by default which causes SCSI to try MODE_SENSE(10)
> > first. 
> > The device responds to MODE_SENSE(10) with "babble" 
> > (-EOVERFLOW). scsiglue sees transport error and 
> > tries to do a soft reset (which also fails).
> > Note that scsiglue does not automatically send 
> > REQUEST-SENSE in this case.
> > 
> > scsiglue then gives up after several attempts and 
> > reports the error to the upper layer. Upper layer
> > (SCSI) correctly realises that MODE_SENSE(10) does
> > not work and attempts to fallback to MODE_SENSE(6) 
> > but before that it issues TEST_UNIT_READY. 


> > This time the device responds with ILLEGAL REQUEST.
> > Now SCSI gets totally confused and decides to give up.

The above sequence is not quite correct (assuming the same behaviour as
logs for another failing Sony/Sony DSC), the MODE SENSE goes out, but we
do not notice in scsi core that it failed (host byte DID_ERROR). 

The MODE SENSE is treated as if it succeeded, and yes the TEST UNIT READY
gets an ILLEGAL REQUEST.

I don't recall what happens to further MODE SENSE commands.

> > As I understand it this ILLEGAL REQUEST actually refers
> > to the previous MODE_SENSE(10) command because this 
> > error condition has never been cleared properly.
> 
> You're probably right.  But that's not how TEST-UNIT-READY is _supposed_ 
> to behave.  It shouldn't be reporting the status from a previous command; 
> it should indicate the device's current status.
> 
> > If I change interpret_usb_result() in transport.c 
> > to ignore "babble" then the next REQUEST-SENSE 
> > reports ILLEGAL REQUEST, SCSI handles that and 
> > everything sort of works.

I don't see how that worked, I would expect nearly the same command
sequence, since scsi core is not checking the error. 

USB storage debug logs are needed to verify what happened (when ignoring
babble/overflow).

> > Regards,
> > Dmitri
> 
> Patrick, what do you think about implementing that change to have the 
> response checker retry when it gets ILLEGAL REQUEST from a 
> TEST-UNIT-READY?

No, since we should fix scsi_status_is_good, and then we see a different
failure mode for the Sony/Sony DSC.

Dmitri -

Reference to the patch and discussion about scsi_status_is_good change,
you will likely get the same bad result if you apply the patch:

http://marc.theaimsgroup.com/?t=106744619500004&r=1&w=2

We should figure out what commands work for the device using SG_IO, try
using Pat L's plscsi or modify one of the sg_util programs to send the
exact failing command, reference:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106755844319144&w=2

A USB trace under Windows would be helpful.

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
