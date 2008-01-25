From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PATCH:
	usb-storage-set-last-sector-bug-flag.patch
Date: Fri, 25 Jan 2008 11:12:21 -0600
Message-ID: <1201281141.3119.41.camel@localhost.localdomain>
References: <20080120205625.GB28842@kroah.com>
	<Pine.LNX.4.44L0.0801201642460.8504-100000@netrider.rowland.org>
	<20080123181239.GA21836@kroah.com> <4798C5B4.1000208@s5r6.in-berlin.de>
	<20080124172158.GC9665@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080124172158.GC9665@kroah.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Greg KH <greg@kroah.com>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, David Brown <usb-storage2@davidb.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Alan Stern <stern@rowland.harvard.edu>, Hans de Goede <j.w.r.degoede@hhs.nl>, Boaz Harrosh <bharrosh@panasas.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2008-01-24 at 09:21 -0800, Greg KH wrote:
> On Thu, Jan 24, 2008 at 06:07:00PM +0100, Stefan Richter wrote:
> > Greg KH wrote:
> > > I just am worried that we are
> > > now suddenly keeping access from the last sector for devices that
> > > currently did work just fine.
> > 
> > This new workaround doesn't prevent access to the last sector.  It only
> > breaks up a multi-sector access which would also reach the last sector
> > into several (two? I'm too lazy to look back in the mail thread)
> > accesses, in order to access the last sector in a dedicated
> > single-sector access.
> > 
> > So that's very differently to the fix-capacity workaround.  The
> > fix-capacity workaround manipulates the READ CAPACITY parameter data.
> > Therefore the fix-capacity workaround is unsafe for non-buggy devices.
> > 
> > The last-sector-(access-)bug workaround _only_ modifies the command
> > stream which is sent to the device.  A dangerous command is replaced by
> > equivalent safe commands.  These commands are luckily safe for _all_
> > devices, buggy and non-buggy ones.  The only cost of this workaround is
> > (1.) the code, (2.) the runtime/ bandwidth/ latency overhead for
> > accesses which reach the last sector.
> 
> Ok, thanks for explaining it better.  I have no objection to this change
> anymore.

So, for forms sake to take this through the SCSI tree I need at least
one USB person to ack it ...

James



-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
