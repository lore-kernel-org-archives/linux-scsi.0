From: Dmitri Katchalov <dmitrik@users.sourceforge.net>
Subject: Re: usb-storage and Sony Handycam
Date: Sat,  8 Nov 2003 13:54:11 +1100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1068260051.3fac5ad3ea76c@webmail.netregistry.net>
References: <Pine.LNX.4.44L0.0311071448200.10810-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0311071448200.10810-100000@ida.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Quoting Alan Stern <stern@rowland.harvard.edu>:

> On Fri, 7 Nov 2003, Patrick Mansfield wrote:
> 
> > > On Fri, 7 Nov 2003, Dmitri Katchalov wrote:
> > > > If I change interpret_usb_result() in transport.c 
> > > > to ignore "babble" then the next REQUEST-SENSE 
> > > > reports ILLEGAL REQUEST, SCSI handles that and 
> > > > everything sort of works.
> > 
> > I don't see how that worked, I would expect nearly the same command
> > sequence, since scsi core is not checking the error. 
> > 
> > USB storage debug logs are needed to verify what happened (when ignoring
> > babble/overflow).
> 
> In any case, usb-storage should _never_ ignore a "babble" error.  It 
> indicates a serious communications problem.

Well, when I said "ignore babble" I actually did this:
      case -EOVERFLOW:
-          return USB_STOR_XFER_LONG;
+          return USB_STOR_XFER_STALL;
I agree, it was not a good idea. I only tried it to see what happens.

As I said, my camera works just fine. All I need is a module parameter 
in modprobe.conf (or a new entry in scsi_devinfo.c), no other code changes
required. I just thought you may be interested in this rather peculiar
behaviour.

Regards,
Dmitri




-------------------------------------------------------
This SF.Net email sponsored by: ApacheCon 2003,
16-19 November in Las Vegas. Learn firsthand the latest
developments in Apache, PHP, Perl, XML, Java, MySQL,
WebDAV, and more! http://www.apachecon.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
