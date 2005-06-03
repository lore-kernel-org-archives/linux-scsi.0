From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: BIO_RW_FAILFAST
Date: Fri, 3 Jun 2005 09:38:37 -0700
Message-ID: <20050603163837.GA32475@us.ibm.com>
References: <20050517205915.GA27652@thumper2>
	<20050602164123.GE22633@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050602164123.GE22633@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 02, 2005 at 06:41:23PM +0200, Lars Marowsky-Bree wrote:
> On 2005-05-17T15:59:15, Andy <genanr@emsphone.com> wrote:
> 
> > I have been having problems with systems getting I/O errors and dropping
> > mounted filesystems, when it is processing a RCSN caused by some other event
> > on the fabric within its' zone.  If I unset BIO_RW_FAILFAST in dm-mpath.c I
> > no longer get the I/O errors and of course no filesystem drops.  Are there
> > any plans to change this, or make it a settable option?  Are there any
> > negatives to not setting it?
> 
> What is "RCSN"? What hardware? And why does it show up on all paths at
> once?

He must have meant a RSCN: Registered State Change Notification ...

Likely qlogic or emulex hardware. AFAIUI, the fibre switch sends an RSCN
to all initiators when it sees a change on the fabric, for example
detaching a cable from the switch or target.

AFAIR some RSCN's can cause glitches, and the FC driver generally wants
scsi core (or here, with fail fast set, maybe dm multipath) to just resend
the command.

I recall some recent changes to qlogic for retry handling in this area,
maybe as part of the queue removal code. 

Seems likely that the fast fail is hurting if we get a DID_BUS_BUSY or ???
from the driver.

Seeing the actual IO errors and kernel versions might help, cc-ing
linux-scsi. 

Maybe Andrew Vasquez (or James Smart) can comment.

-- Patrick Mansfield
