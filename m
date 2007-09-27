From: Oliver Neukum <oliver@neukum.org>
Subject: Re: question on flushing buffers and spinning
	down disk
Date: Thu, 27 Sep 2007 20:12:14 +0200
Message-ID: <200709272012.15567.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709271159570.7735-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0709271159570.7735-100000@iolanthe.rowland.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am Donnerstag 27 September 2007 schrieb Alan Stern:
> On Thu, 27 Sep 2007, Oliver Neukum wrote:
> =

> > Am Dienstag 25 September 2007 schrieb Alan Stern:
> > > Getting all this to work will be tricky, because sd is a block device
> > > driven by requests issued through the block layer in atomic context,
> > > whereas suspend and resume require a process context. =A0Probably the =

> > > SCSI core would have to get involved in managing the synchronization.
> > =

> > =

> > Well,
> > =

> > here's a patch that seems to do what needs to be done to make it work.
> =

> Oliver, I'm surprised at you!  This patch is a big hack, not to mention =

> a layering violation and an inversion of the proper calling sequence.

Well,

1. autosuspend should not be specific to USB
2. I like to view the generic SCSI code as a library
3. The low level drivers will have to decide whether to suspend devices,
as the generic code doesn't know whether the bus is shared.

	Regards
		Oliver

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
