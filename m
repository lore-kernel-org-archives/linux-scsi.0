From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 21 Apr 2003 14:23:36 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1050953018.2269.140.camel@mulgrave>
References: <20030322233136.D17056@one-eyed-alien.net>
	<1048467235.1634.22.camel@mulgrave>
	<20030323173733.B24668@one-eyed-alien.net>
	<1048469946.1643.2.camel@mulgrave>
	<20030323230438.E24668@one-eyed-alien.net>
	<1048519237.1982.16.camel@mulgrave>
	<20030324093028.A1066@one-eyed-alien.net>
	<1049556643.1762.16.camel@mulgrave>
	<20030420143351.C20891@one-eyed-alien.net>
	<1050942530.1772.12.camel@mulgrave>
	<20030421100102.A12581@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20030421100102.A12581@one-eyed-alien.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2003-04-21 at 12:01, Matthew Dharm wrote:
> I think 'any' is a bit harsh here... but, regardless...

OK, just the style changes, then, which are nasty to merge...

> My biggest complaints are:
> (1) Your patch doesn't compile on my system.  RH7.3 -- it chokes on an
> array in a struct with no length.  I doubt I'm the only person with this
> problem.  Considering that in other places we bother to support this
> compiler (-fomit-frame-pointer anyone?), it seems reasonable that we want
> to support it here.
>
> (2) You're creating a struct to associate two things (white/black selection
> and the list) which don't really need to be associated.  A list is a list
> -- if we treat it as whitelist or blacklist really is a separate question.

To be honest, I don't care much.  I think I had a merge problem where
the function template mismatched.

> (3) Your treatment of the INQUIRY EVPD filter arbitrarily limits what the
> filter can specify just to conserve a 'case' in a 'switch' -- considering
> that the history of the problem starts with scsi_scan issuing INQUIRY for
> 255 bytes, making the filter unable to limit anything >=127 seems bad.

I don't believe the limit to be a problem.  The scsi_scan code works
like this:

We send a 36 byte inquiry.  Based on the strings we get back we look for
devices that are blacklisted as supporting either 36 or 58 byte
inquiries.  If no blacklist exists, we believe the information the
device returns telling us how many bytes it supports for the inquiry, so
unless the device is blacklisted at 36, we issue another inquiry for
either 58 or the device listed length.

The blacklist only exists because you apparently have a device that lies
about the inquiry length it supports and then goes out to lunch when an
inquiry of that length is sent to it.

Therefore, the only current use of the inquiry filter is to black/white
list 36 and 58 byte inquiries.

Can you send us the inquiry strings of such a problem device?  We've had
absolutely no takers for the inquiry limitations in the current
blacklist, which does seem to imply that the code changes made to probe
all luns fixed the problem for almost everyone else.


James



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
