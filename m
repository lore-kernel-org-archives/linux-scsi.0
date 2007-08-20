From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Errors on USB-storage device are ignored.
Date: Mon, 20 Aug 2007 09:03:19 -0400
Message-ID: <1187614999.3465.2.camel@localhost.localdomain>
References: <20070816145817.GA24105@bitwizard.nl>
	<20070820060946.GE9867@one-eyed-alien.net>
	<20070820083723.GD21438@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20070820083723.GD21438@bitwizard.nl>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: usb-storage@lists.one-eyed-alien.net, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2007-08-20 at 10:37 +0200, Rogier Wolff wrote:
> On Sun, Aug 19, 2007 at 11:09:46PM -0700, Matthew Dharm wrote:
> > Off the cuff, this really looks like something for the SCSI layer.  I'll
> > bet there are SCSI devices that do something similar...
> > 
> > And, I'm generally reluctant to modify the data to/from a device unless
> > usb-storage *really* has to in order to make it work....
> 
> I fully agree, but as the scsi layer has been in existance almost 10
> years longer than USB-storage, and that nobody seems to have encountered
> a device requesting auto-sense, and then reporting no error, I would
> say this is just a classical: "shitty USB implementation". 

I'm afraid it is.  Reporting NO SENSE is actually a legitimate thing for
a SCSI device to do.  Usually it just means that the problem it was
reporting went away in the interim.  So, making it mean there's a
serious drive problem would put us in volation of the spec.  If this can
be fixed, it will have to be in USB ... probably tied as specificially
as possible to this particular device ... USB storage that correctly
follows the RBC spec is allowed to report NO SENSE for the same reason
as standard SCSI.

James



-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
