From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Wed, 20 Oct 2010 17:39:29 -0700
Message-ID: <1287621569.10283.162.camel@haakon2.linux-iscsi.org>
References: <C8E4D7B7.A1F4%giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm28.bullet.mail.ac4.yahoo.com ([98.139.52.225]:30291 "HELO
	nm28.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752447Ab0JUAuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2010 20:50:08 -0400
In-Reply-To: <C8E4D7B7.A1F4%giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, LinuxSCSI <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Wed, 2010-10-20 at 17:30 -0700, Giridhar Malavali wrote:
> 
> 
> On 10/20/10 4:19 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Wed, 2010-10-20 at 15:37 -0700, Giridhar Malavali wrote:
> >> 
> >> 
> > 
> > <Trimming long CC'list>
> > 
> > Hi Giri,
> > 
> >> On 10/20/10 1:49 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> >> 
> >>> Greetings all,
> >>> 
> >>> *) Individual LLDs running by default w/ unlocked_qcmds=1
> >>> 
> >>> aic94xx: need ack maintainer at adaptec..?)
> >>> mvsas: need ack maintainer at marvell..?)
> >>> pm8001: need ack Jang Wang
> >>> qla4xxx, qla2xxx: need ack Andrew Vasquez
> >>> fnic:  need ack Joe Eykholt
> >> 
> >> The qla2xxx driver is modified not to depend on the host_lock and also to
> >> drop usage of scsi_cmnd->serial_number. Both the patches are submitted to
> >> linux-scsi and you can find more information at
> >> 
> >> http://marc.info/?l=linux-scsi=128716779923700=2
> >> <http://marc.info/?l=linux-scsi&m=128716779923700&w=2>
> > 
> > Sure, but for the new fast unlocked_qcmds=1 operation in
> > qla2xxx_queuecommand(), the host_lock access needs to be complete
> > removed from SHT->queuecommand().   The above patch just moves the
> > vha->host->host_lock unlock up in queuecommand(),  right..?
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> > index b0c7139..77203b0 100644
> > --- a/drivers/scsi/qla2xxx/qla_os.c
> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > @@ -545,6 +545,7 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void
> > (*done)(struct scsi_cmnd *))
> >         srb_t *sp;
> >         int rval;
> > 
> > +       spin_unlock_irq(vha->host->host_lock);
> >         if (ha->flags.eeh_busy) {
> >                 if (ha->flags.pci_channel_io_perm_failure)
> >                         cmd->result = DID_NO_CONNECT << 16;
> > 
> > <SNIP>
> > 
> > @@ -603,9 +599,11 @@ qc24_host_busy_lock:
> >         return SCSI_MLQUEUE_HOST_BUSY;
> > 
> >  qc24_target_busy:
> > +       spin_lock_irq(vha->host->host_lock);
> >         return SCSI_MLQUEUE_TARGET_BUSY;
> > 
> >  qc24_fail_command:
> > +       spin_lock_irq(vha->host->host_lock);
> >         done(cmd);
> > 
> >         return 0;
> > 
> >> http://marc.info/?l=linux-scsi=128716779623683=2
> >> <http://marc.info/?l=linux-scsi&m=128716779623683&w=2>
> >> 
> > 
> > <nod> I had been only updating LLDs that actually used ->serial_number
> > beyond a simple informational purposes for error recovery.  Thanks for
> > removing this one preemptively!  8-)
> > 
> > Best,
> > 
> > --nab
> > 
> 
> Hi Nicholas,
> 
> Yes, I understand. I was thinking that you are going to submit the patches
> for all LLD with your final submission.
> 
> I will submit the patch which removes host_lock in queuecommand routine
> completely then. 

Hmmmmm..

I think you will want to coordinate with James Bottomley here before
dropping the existing qla2xxx SHT->queuecomand() -> unlock() ->
do_lld_work() -> lock() code.  Doing this legacy optimization still does
provide some form of benefit (which btw I don't think anyone has ever
actually determined how much this), but lets make sure the legacy
optimization remains in place until we can resolve the remaining issues
so James can merge the initial pieces.  From there you can drop
host_lock in qla2xxx_queuecommand() and safely enable unlocked_qcmds=1
operation by default to realize the lock-less queue small block IOP
gains.

Best,

--nab

> 
> -- Giri
> 
> > 
> > 
> 

