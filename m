From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-storage and Sony Handycam
Date: Sat, 8 Nov 2003 11:28:37 -0500 (EST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0311081105351.28814-100000@netrider.rowland.org>
References: <20031107223444.A1747@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20031107223444.A1747@beaverton.ibm.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Dmitri Katchalov <dmitrik@users.sourceforge.net>, Idan Sofer <idan@idanso.dyndns.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 7 Nov 2003, Patrick Mansfield wrote:

> We need to figure out what is different here, and why (based on other
> reports for this device) this worked on 2.4 but not on 2.6.
> 
> Looking at usb/storage/transport.c, we are not generating the usb
> "fake_sense" with your change.
> 
> Maybe the failed MODE SENSE had a check condition, but the fake_sense
> prevented us from retrieving it?

No, the "babble" prevented that.

How to deal with babble errors is a serious question that's been under
discussion in the usb-storage mailing list, but we haven't found a good
answer.  It doesn't come up often except for certain devices that go crazy
when given some of the less-common commands.  Babble is a nasty violation
of the USB protocol (and in particular the USB Mass Storage class
protocols); it indicates that something has gone very wrong but doesn't
provide any clue as to how to fix it.  I vaguely recall getting a report
from someone that even unplugging the USB cable and reinserting it wasn't
enough to unwedge his device.

The "fake sense" is a compromise.  It lets us give a clear indication to 
the higher layers that something is wrong and asks them not to send the 
same command again.  But it doesn't do much about getting the device back 
into a working state (if that's even possible).

> So the next command sent got a check condition, illegal request.
> 
> That still doesn't tell us why the MODE SENSE failed, and why the failure
> does not show up with 2.4.

The best approach for doing this is to have a side-by-side comparison of 
the usb-storage debugging logs for 2.4 and 2.6.  I think we have to assume 
that the MODE-SENSE failed because the device simply doesn't support it 
correctly.

> Can you run the variants on MODE SENE via user space SG_IO, and figure out
> which ones work?
> 
> AFAICT at least three different problems are contributing to the failure:
> 
> 1) The MODE SENSE seems to work fine in 2.4, but is failing in 2.6. In
> 2.4, we always send a MODE SENSE page 3f with length 255; in 2.6 we start by
> asking for 4 bytes.
> 
> 2) scsi core ignores host byte errors (DID_ERROR). This means we behave as
> if the MODE SENSE worked OK, even though USB tells scsi core that it
> failed. Fixing this problem (for another user) caused even worse problems.

I must have missed that.  It seems odd that fixing an oversight in the
kernel could make interoperability _worse_.  Maybe that indicates
something else needs to be fixed.

> 3) The next command - TEST UNIT READY - gets a check condition, illegal
> request. Maybe the fake sense handling is screwing things up - the device
> tells us it sent back more data than we asked for, but it is also trying
> to check us.

I don't understand your speculation here.  It seems clear to me that this 
is a situation where the device and the host are out of sync -- the host 
sends a command and the device sends back status from the _previous_ 
command.  Repeating the TEST-UNIT-READY may bring us back in sync.  Or 
maybe some sort of reset will -- no way to tell without trying it.

The ultimate problem is that this device doesn't like some of the 
MODE-SENSE commands used to determine read-write and cache status.  We 
need to have either per-device information saying which variants of the  
commands the device will accept or else per-device information saying not 
to send the MODE-SENSE commands at all.

I don't see any other way of coping.  Even trying to send a command and 
then trying to recover if it fails is not a viable approach if recovery 
requires the user to cycle the power on the device (or to unplug its 
cable).

Alan Stern



-------------------------------------------------------
This SF.Net email sponsored by: ApacheCon 2003,
16-19 November in Las Vegas. Learn firsthand the latest
developments in Apache, PHP, Perl, XML, Java, MySQL,
WebDAV, and more! http://www.apachecon.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
