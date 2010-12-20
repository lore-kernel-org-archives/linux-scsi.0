From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 00/12] LLD host_lock-less conversion status for .38
Date: Mon, 20 Dec 2010 20:38:34 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70916A017@inbmail01.lsi.com>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, adam radford <aradford@gmail.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Nicholas A. Bellinger [mailto:nab@linux-iscsi.org]
> Sent: Monday, December 20, 2010 2:52 AM
> To: linux-scsi; linux-kernel; James Bottomley; Jeff Garzik; Christoph
> Hellwig; FUJITA Tomonori; Hannes Reinecke; Mike Christie
> Cc: Mike Anderson; Tejun Heo; Vasu Dev; Tim Chen; Andi Kleen; Ravi
> Anand; Andrew Vasquez; Joe Eykholt; James Smart; Douglas Gilbert; adam
> radford; Desai, Kashyap; DL-MPT Fusion Linux; Nicholas Bellinger
> Subject: [PATCH 00/12] LLD host_lock-less conversion status for .38
> 
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings James and Co,
> 
> Attached are the current set of LLD host_lock-less conversions in the
> queue
> for .38, that have now been pushed into lio-core-2.6.git/lock_less-
> LLDs-for-38-v3
> 
> New in this v3 series are the megaraid_sas LLD changes necessary to run
> in
> host_lock-less mode, which have been tested thus far in legacy x86
> interrupt
> pin mode using 8708EM2 QEMU HBA emulation into KVM guest using TCM_Loop
> virtual SCSI LUNs.
> 
> This series also drops the drivers/scsi patches that have been resolved
> with
> the following (Thanks!)
> 
> commit 459dbf72e4d2b4aa13620e6b70d54f098547bf13
> Author: James Bottomley <James.Bottomley@suse.de>
> Date:   Wed Nov 17 10:10:57 2010 -0600
> 
>     [SCSI] Eliminate error handler overload of the SCSI serial number
> 
> At this point the remaining code TODO items for the LLD conversion
> patches
> include
> 
> *) libiscsi: NULL sc->scsi_done() callback in exception path in
> iscsi_queuecommand().
> The last status on this from Mike Christie was:
> 
> "This will NULL pointer. See a couple lines above where we NULL it.
> iscsi_free_task checks if the scsi_done pointer is set and if it is it
> will call scsi_done.
> 
> It is a hack to prevent the normal completion path from calling
> scsi_done. For the case where we return SCSI_MLQUEUE_TARGET_BUSY (the
> prepd_reject case) we need something to prevent scsi_done from getting
> called.
> 
> For the return 0/prepd_fault case we can just call sc->scsi_done, but
> we
> have to move some code around."
> 
> mnc, have you been able to take another look at this..?
> 
> *) mpt2sas: Locking considerations for firmware specific data
> structures
> 
> A patch to mptsas was included originally to convert to host_lock less
> w/ interrupts
> disabled externally here:
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-
> 2.6.git;a=commitdiff;h=87ba9071b46f37f1adab1732d41b87bf195d191f
> 
> but due to concerns from jgarzik this had been dropped from the
> lock_less-LLDs-for-38-v2
> during the last round.  The feedback from Kashyap @ LSI is that mpt2sas
> technically should be
> able to run in host_lock-less, but there needs to be some explict
> clarification in the code
> for the conversion to happen.  More details are here:
> 
> http://marc.info/?l=linux-scsi&m=129022827729386&w=2
> 
> Kashyap, can you take another look at this and make sure this is
> acceptable..?

Nicholas, I have replied my input on the same thread. 

> 
> *) megaraid_sas: Running in host_lock-less mode with MSI-X interrupts
> 
> This has not been tested yet, but I would like to get some review from
> the LSI
> megaraid_sas folks now that their patches to enable MSI-X interrupts
> has been sent
> to linux-scsi.
> 
> AdamR, any thoughts or comments to add here..?
> 
> -----------------------------------------------------------------------
> -----------
> 
> So at this point the next steps will be to shaking out breakage in
> corner cases for
> struct scsi_device hotplug removal, more testing+validation, and more
> LLD code review.
> 
> For the CC'ed LLD maintainers, please have another look at the changes
> to enable
> host_lock-less operation within your code and send the necessary ACKs
> to linux-scsi
> at your earliest convience.  Many thanks to everyone who has
> contributed!
> 
> If anyone has any other patches, comments or concerns please let me
> know and they
> will be queued up for the next v4 for-38 round.
> 
> Best Regards,
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> Nicholas Bellinger (12):
>   libiscsi: Convert to host_lock less w/ interrupts disabled internally
>   scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
>   libsas: Convert to host_lock less w/ interrupts disabled externally
>   message: Convert to host_lock less w/ interrupts disabled externally
>   fnic: Convert to host_lock less w/ interrupts disabled externally
>   lpfc: Convert to host_lock less w/ interrupts disabled externally
>   qla2xxx: Convert to host_lock less w/ interrupts disabled externally
>   qla4xxx: Convert to host_lock less w/ interrupts disabled externally
>   scsi_debug: Convert to host_lock less
>   megaraid_sas: Add smp_mb__after_atomic_*() for
>     instance->fw_outstanding
>   megaraid_sas: Convert instance->issuepend_done to atomic_t
>   megaraid_sas: Convert SHT->queuecommand() to run host_lock-less
> 
>  drivers/message/fusion/mptfc.c       |    2 +-
>  drivers/message/fusion/mptsas.c      |    6 +-
>  drivers/message/fusion/mptscsih.c    |    8 ++-
>  drivers/message/fusion/mptscsih.h    |    2 +-
>  drivers/message/fusion/mptspi.c      |    6 +-
>  drivers/scsi/fnic/fnic_scsi.c        |   14 +----
>  drivers/scsi/libiscsi.c              |   10 +---
>  drivers/scsi/libsas/sas_scsi_host.c  |   12 +----
>  drivers/scsi/lpfc/lpfc_scsi.c        |    9 ++--
>  drivers/scsi/megaraid/megaraid_sas.c |   85 ++++++++++++++++++++++----
> --------
>  drivers/scsi/megaraid/megaraid_sas.h |    2 +-
>  drivers/scsi/qla2xxx/qla_os.c        |   11 +---
>  drivers/scsi/qla4xxx/ql4_os.c        |   10 +---
>  drivers/scsi/scsi_debug.c            |   16 +++----
>  include/scsi/scsi_host.h             |   14 ++++++
>  15 files changed, 107 insertions(+), 100 deletions(-)
> 
> --
> 1.7.3.4
