From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Patch added to scsi-rc-fixes-2.6:  [SCSI] host lock push-down
Date: Thu, 11 Nov 2010 00:58:35 -0800
Message-ID: <1289465915.2867.68.camel@haakon2.linux-iscsi.org>
References: <201011102240.oAAMe86a001486@hera.kernel.org>
	 <4CDB2A81.5030100@garzik.org> <1289432759.3016.63.camel@mulgrave.site>
	 <4CDB3028.6080605@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CDB3028.6080605@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-11-10 at 18:52 -0500, Jeff Garzik wrote:
> On 11/10/2010 06:45 PM, James Bottomley wrote:
> > On Wed, 2010-11-10 at 18:28 -0500, Jeff Garzik wrote:
> >> On 11/10/2010 05:40 PM, James Bottomley wrote:
> >>> Your commit:
> >>>
> >>>       [SCSI] host lock push-down
> >>>
> >>>       Move the mid-layer's ->queuecommand() invocation from being locked
> >>>       with the host lock to being unlocked to facilitate speeding up the
> >>>       critical path for drivers who don't need this lock taken anyway.
> >>>
> >>>       The patch below presents a simple SCSI host lock push-down as an
> >>>       equivalent transformation.  No locking or other behavior should change
> >>>       with this patch.  All existing bugs and locking orders are preserved.
> >>>
> >>>       Minimal code disturbance was attempted with this change.  Most drivers
> >>>       needed only two one-line modifications for their host lock push-down.
> >>>
> >>>       Signed-off-by: Jeff Garzik<jgarzik@redhat.com>
> >>>       Signed-off-by: James Bottomley<James.Bottomley@suse.de>
> >>>
> >>> has been added to the upstream SCSI tree
> >>> You can find it here:
> >>
> >> No comments on renaming ->queuecommand to something else?
> >
> > What we wondered about doing differently isn't really relevant for a
> > change log ... that should just really be about what was done (to avoid
> > confusion).
> 
> Wasn't referring to the changelog (perhaps shouldn't have quoted that); 
> just asking the question generally.
> 
> 
> >> The consequences are rather dire if this goes unnoticed, yes?
> >
> > You mean if there's a missed in-tree driver?  Yes, but I took care to
> > make sure all SCSI drivers were accounted for.  For out of tree drivers,
> > as with the eh lock push down, it's caveat emptor.
> 
> Thinking about out-of-tree drivers, yes.
> 

Hi Jeff and James,

Thank you for getting this initial patch merged.  I really think this
was and is the best choice moving forward.   Also, a seriously big thank
you to all of the other folks who have helped identify LLDs issues for
host_lock less mode for drivers!!

In the next days I will get a atomic_t scsi_host->cmd_serial_number
patch rebased (which is really very minor at this point w/o the
scsi_error.c changes), and merge the current host_lock-less 'scoreboard'
on top of jgarzik's code and tag for .38.   So, please let me know if
you would to include minor the atomic_t scsi_host->cmd_serial_number
patch for .37 or if you would rather have this immediately preceed the
first series of "enable host-lock_less for LLD vendor superturbo hba"
for the .38 round.

Best,

--nab
