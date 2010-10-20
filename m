From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Wed, 20 Oct 2010 16:19:05 -0700
Message-ID: <1287616745.10283.141.camel@haakon2.linux-iscsi.org>
References: <C8E4BD3D.A1E3%giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:33338 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755055Ab0JTXX4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2010 19:23:56 -0400
In-Reply-To: <C8E4BD3D.A1E3%giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, LinuxSCSI <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Wed, 2010-10-20 at 15:37 -0700, Giridhar Malavali wrote:
> 
> 

<Trimming long CC'list>

Hi Giri,

> On 10/20/10 1:49 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > Greetings all,
> > 
> > So as we get closer to the .37 merge window, I wanted to take this
> > oppourtunity to recap the current status of the drop-host_lock /
> > unlocked_qcmds=1 patches, and what is required for the next RFCv5 and
> > hopefully a merge into .37.  The last RFCv4 was posted here:
> > 
> > http://marc.info/?l=linux-kernel=128563953114561=2
> > <http://marc.info/?l=linux-kernel&m=128563953114561&w=2>
> > 
> > Since then, Christof Schmitt has sent a patch to drop struct
> > scsi_cmnd->serial_number usage in zfcp, and Tim Chen has sent an
> > important fix to drop an extra host_lock access that I originally missed
> > in qla2xxx SHT->queuecommand() that certainly would have deadlocked a
> > running machine.   Many thanks to Christof and Tim for your
> > contributions and review!
> > 
> > So at this point in the game the current score sits at:
> > 
> > *) core drivers/scsi remaining issue(s):
> > 
> > The issue raised by andmike during RFCv4 described as:
> > 
> > "If we skip __scsi_try_to_abort_cmd when REQ_ATOM_COMPLETE is set it
> > would be correct for the scsi_decide_disposition cases but it would
> > appear this would stop __scsi_try_to_abort_cmd from being called in the
> > time out case as REQ_ATOM_COMPLETE is set prior to calling
> > blk_rq_timed_out."
> > 
> > The complete discussion is here:
> > 
> > http://marc.info/?l=linux-scsi=128535319915212=2
> > <http://marc.info/?l=linux-scsi&m=128535319915212&w=2>
> > 
> > We still need folks with experience to dig into this code, so you know
> > the scsi_error.c code please jump in!
> > 
> > *) LLD libraries running by default w/ unlocked_qcmds=1
> > 
> > libiscsi: need ack from mnc
> > libsas: need ack from jejb
> > libfc: remaining rport state + host_lock less issue.  Need more input
> >        from mnc for James Smart and Joe on this...
> > libata: jgarzik thinks this should be OK, review and ack from tejun
> >         would also be very helpful.
> > 
> > The main issue remaining here is the audit of libfc rport (and other..?)
> > code that assumes host_lock is held to protect state.  mnc, do you have
> > any more thoughts for James Smart and Joe here..?
> > 
> > *) Individual LLDs running by default w/ unlocked_qcmds=1
> > 
> > aic94xx: need ack maintainer at adaptec..?)
> > mvsas: need ack maintainer at marvell..?)
> > pm8001: need ack Jang Wang
> > qla4xxx, qla2xxx: need ack Andrew Vasquez
> > fnic:  need ack Joe Eykholt
> 
> The qla2xxx driver is modified not to depend on the host_lock and also to
> drop usage of scsi_cmnd->serial_number. Both the patches are submitted to
> linux-scsi and you can find more information at
> 
> http://marc.info/?l=linux-scsi&m=128716779923700&w=2

Sure, but for the new fast unlocked_qcmds=1 operation in
qla2xxx_queuecommand(), the host_lock access needs to be complete
removed from SHT->queuecommand().   The above patch just moves the
vha->host->host_lock unlock up in queuecommand(),  right..?

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b0c7139..77203b0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -545,6 +545,7 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	srb_t *sp;
 	int rval;
 
+	spin_unlock_irq(vha->host->host_lock);
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure)
 			cmd->result = DID_NO_CONNECT << 16;

<SNIP>

@@ -603,9 +599,11 @@ qc24_host_busy_lock:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc24_target_busy:
+	spin_lock_irq(vha->host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 qc24_fail_command:
+	spin_lock_irq(vha->host->host_lock);
 	done(cmd);
 
 	return 0;

> http://marc.info/?l=linux-scsi&m=128716779623683&w=2
> 

<nod> I had been only updating LLDs that actually used ->serial_number
beyond a simple informational purposes for error recovery.  Thanks for
removing this one preemptively!  8-)

Best,

--nab


