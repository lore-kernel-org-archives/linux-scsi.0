From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: usb-storage and Sony Handycam
Date: Fri, 7 Nov 2003 22:34:44 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20031107223444.A1747@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0311071448200.10810-100000@ida.rowland.org> <1068260051.3fac5ad3ea76c@webmail.netregistry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1068260051.3fac5ad3ea76c@webmail.netregistry.net>; from dmitrik@users.sourceforge.net on Sat, Nov 08, 2003 at 01:54:11PM +1100
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Dmitri Katchalov <dmitrik@users.sourceforge.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 08, 2003 at 01:54:11PM +1100, Dmitri Katchalov wrote:

> Well, when I said "ignore babble" I actually did this:
>       case -EOVERFLOW:
> -          return USB_STOR_XFER_LONG;
> +          return USB_STOR_XFER_STALL;
> I agree, it was not a good idea. I only tried it to see what happens.
> 
> As I said, my camera works just fine. All I need is a module parameter 
> in modprobe.conf (or a new entry in scsi_devinfo.c), no other code changes
> required. I just thought you may be interested in this rather peculiar
> behaviour.

We need to figure out what is different here, and why (based on other
reports for this device) this worked on 2.4 but not on 2.6.

Looking at usb/storage/transport.c, we are not generating the usb
"fake_sense" with your change.

Maybe the failed MODE SENSE had a check condition, but the fake_sense
prevented us from retrieving it?

So the next command sent got a check condition, illegal request.

That still doesn't tell us why the MODE SENSE failed, and why the failure
does not show up with 2.4.

Can you run the variants on MODE SENE via user space SG_IO, and figure out
which ones work?

AFAICT at least three different problems are contributing to the failure:

1) The MODE SENSE seems to work fine in 2.4, but is failing in 2.6. In
2.4, we always send a MODE SENSE page 3f with length 255; in 2.6 we start by
asking for 4 bytes.

2) scsi core ignores host byte errors (DID_ERROR). This means we behave as
if the MODE SENSE worked OK, even though USB tells scsi core that it
failed. Fixing this problem (for another user) caused even worse problems.

3) The next command - TEST UNIT READY - gets a check condition, illegal
request. Maybe the fake sense handling is screwing things up - the device
tells us it sent back more data than we asked for, but it is also trying
to check us.

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
