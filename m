From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-storage and Sony Handycam
Date: Fri, 7 Nov 2003 11:21:48 -0500 (EST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0311071117160.1577-100000@ida.rowland.org>
References: <1068207145.3fab8c2988d43@webmail.netregistry.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <1068207145.3fab8c2988d43@webmail.netregistry.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Dmitri Katchalov <dmitrik@users.sourceforge.net>, Patrick Mansfield <patmans@us.ibm.com>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 7 Nov 2003, Dmitri Katchalov wrote:

> Greetings,
> 
> I finally managet to get Sony DCR-TRV17E memory stick
> working with usb-storage.
> The solution turned out to be very simple:
> 
> echo "Sony:Sony DSC:0" > /proc/scsi/device_info
> 
> But I'm puzzled as to why didn't it work in the first 
> place despite several reports to the contrary. My guess
> is it used to work in earlier kernels and then some
> seemingly unrelated change broke it.
> 
> I investigated it a little and that's what I found:
> This device uses CB transport (SENSE status not reported).
> This device does not support MODE_SENSE at all.
> MODE_SENSE(6) fails with STALL condition. Subsequent 
> REQUEST-SENSE reports ILLEGAL REQUEST. SCSI layer is 
> able to handle this situation, the only drawback is 
> that write-protect status is not reported.
> 
> Unfortunately usb-storage sets use_10_for_ms flag 
> by default which causes SCSI to try MODE_SENSE(10)
> first. 
> The device responds to MODE_SENSE(10) with "babble" 
> (-EOVERFLOW). scsiglue sees transport error and 
> tries to do a soft reset (which also fails).
> Note that scsiglue does not automatically send 
> REQUEST-SENSE in this case.
> 
> scsiglue then gives up after several attempts and 
> reports the error to the upper layer. Upper layer
> (SCSI) correctly realises that MODE_SENSE(10) does
> not work and attempts to fallback to MODE_SENSE(6) 
> but before that it issues TEST_UNIT_READY. 
> 
> This time the device responds with ILLEGAL REQUEST.
> Now SCSI gets totally confused and decides to give up.
> 
> As I understand it this ILLEGAL REQUEST actually refers
> to the previous MODE_SENSE(10) command because this 
> error condition has never been cleared properly.

You're probably right.  But that's not how TEST-UNIT-READY is _supposed_ 
to behave.  It shouldn't be reporting the status from a previous command; 
it should indicate the device's current status.

> If I change interpret_usb_result() in transport.c 
> to ignore "babble" then the next REQUEST-SENSE 
> reports ILLEGAL REQUEST, SCSI handles that and 
> everything sort of works.
> 
> Regards,
> Dmitri

Patrick, what do you think about implementing that change to have the 
response checker retry when it gets ILLEGAL REQUEST from a 
TEST-UNIT-READY?

Alan Stern



-------------------------------------------------------
This SF.net email is sponsored by: SF.net Giveback Program.
Does SourceForge.net help you be more productive?  Does it
help you create better code?   SHARE THE LOVE, and help us help
YOU!  Click Here: http://sourceforge.net/donate/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
