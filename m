From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: oops on usb storage device disconnect with 2.6.14-rc1
Date: Thu, 15 Sep 2005 15:19:46 -0700
Message-ID: <20050915221946.GA28441@us.ibm.com>
References: <20050915190338.GA6807@kroah.com> <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org> <20050915192912.GA7077@kroah.com> <1126814226.4821.48.camel@mulgrave> <1126818483.4821.60.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1126818483.4821.60.camel@mulgrave>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Thu, 2005-09-15 at 15:57 -0400, James Bottomley wrote:
> > I haven't had time to review the eh changes, but I was going to reply to
> > the other one (basically there's a better way to try to close the device
> > add/host remove race using the host state model).
> > 
> > Let me complete the SCSI process and I'll take them through the scsi-rc-
> > fixes tree.
> 
> Well, I think the symptoms are racing scsi_remove_host() calls and the
> solution is to enforce the state model on removal (as in if the host is
> already in the remove state, don't try to remove it again).
> 
> Could you try the patch here:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112613077011571
> 
> And see if it will fix the problem?
> 

A side effect of not applying Alan's previous patch that added
SHOST_RECOVERY to the SHOST_CANCEL: state is that we will not move to the
SHOST_CANCEL and subsequently not to SHOST_DEL state if the eh is active
during the start of scsi_remove_host. I sent mail on the 7th indicating to
include that state change hunk of the diff, but I guess that overlapped
with your newer state changes.
http://marc.theaimsgroup.com/?l=linux-scsi&m=112238726326927&w=2

In looking at the state model introduced by your patch I believe there may
still be a state model race issue if the recovery completes just after
the "if (!scsi_host_set_state(shost, SHOST_CANCEL))" call in
scsi_remove_host (maybe I am just looking to quickly at the state
updates).

I still do not understand as I asked in a previous comment why we are not
shutting down the eh_thread in scsi_remove_host and also why simpler state
model updates could not solve the problem.

I believe I also indicated that we could enhance scsi_error to shutdown
faster during this state which should only be a performance improvement.

-andmike
--
Michael Anderson
andmike@us.ibm.com


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
