From: Praveen Murali <pmurali@logicube.com>
Subject: Re: [PATCH 3/3] Fix device detection issues with mvsas driver
Date: Thu, 21 Jun 2012 09:41:58 -0700
Message-ID: <1340296918.3712.54.camel@praveen-debian.lg.local>
References: <1340044537.3712.23.camel@praveen-debian.lg.local>
	 <CAA9_cmeo=2Jjyp2DSwBDM=toTydMbLHJ+J7h2UXQYb2YmV+tzg@mail.gmail.com>
Reply-To: pmurali@logicube.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:58469 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2FUQmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2012 12:42:52 -0400
In-Reply-To: <CAA9_cmeo=2Jjyp2DSwBDM=toTydMbLHJ+J7h2UXQYb2YmV+tzg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org

Ok, do you want me to regenerate the patch?

Praveen

On Thu, 2012-06-21 at 09:05 -0700, Dan Williams wrote:
> On Mon, Jun 18, 2012 at 11:35 AM, Praveen Murali <pmurali@logicube.com> wrote:
> >  I am using the Marvell SAS HBA (MV64460/64461/64462 System Controller,
> > Revision B (rev 01)), on a system running Ubuntu 12.04 stock kernel. And
> > i am seeing some drive detection issues with SATA drives, mostly during
> > hotplugging the drives; the issue gets exaggerated when we keep removing
> > and plugging in drives.
> >
> > From dmesg, after starting the LibATA debugs, it looks like the
> > ata_eh_revalidate_and_attach fails because ata_dev_read_id fails to get
> > the IDENTIFY command response. I see "both IDENTIFYs aborted, assuming
> > NODEV" for all these drives that go undetected. At this point, if I
> > unload and reload the mvsas driver, these drives detect fine. So, I
> > hooked up a SATA analyzer between the HBA and one of the drives, and
> > restarted the test. From what I can see, even though the drive responds
> > to the IDENTIFY command, the upper layer detects an error and discards
> > the response. On further debugging it was evident that the error was
> > being detected in the FIS.
> >
> >  After going thru the mvsas driver, I see that the driver allocates a
> > DMA area for an FIS pool (for as many as 33 FIS's) and initializes it to
> > 0. And each ATA command is allocated a FIS area from this pool during
> > the command prep; but its never cleared.
> >
> > This change initializes the FIS area before using it and it fixes the
> > drive detection issue. I have tested it with kernel 3.2.0.
> >
> > ---
> >  drivers/scsi/mvsas/mv_sas.c |   14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> > index a4884a5..31bfd4e 100644
> > --- a/drivers/scsi/mvsas/mv_sas.c
> > +++ b/drivers/scsi/mvsas/mv_sas.c
> > @@ -21,6 +21,16 @@
> >  * along with this program; if not, write to the Free Software
> >  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
> >  * USA
> > + *
> > + * Changelog:
> > + *     Praveen Murali <pmurali@logicube.com>   May 15, 2012
> > + *             Cleanup and prepare the FIS index before issuing the
> > + *             ATA command (during prep: mvs_task_prep_ata). This is
> > + *             to overcome the drive detection issue where the SATA drives
> > + *             fail to get detected during hotplug since the ATA module
> > + *             (libATA) detects errors set in the FIS eventhough the SATA
> > + *             analyzer shows that the IDENTIFY command was successfull.
> > + *
> >  */
> 
> Hi,
> 
> The changelog will exist in the git history, no need to also append it
> to the file.  I think this should also be tagged for the -stable tree.
> 
> --
> Dan

