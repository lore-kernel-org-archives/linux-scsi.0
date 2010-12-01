From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: RE: [PATCH 0/3] megaraid_sas: Convert to host_lock less w/
	interrupts disabled internally
Date: Tue, 30 Nov 2010 16:24:09 -0800
Message-ID: <1291163049.17194.206.camel@haakon2.linux-iscsi.org>
References: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
	 <4B6A08C587958942AA3002690DD4F8C30106B1E5D6@cosmail02.lsi.com>
	 <1291152112.17194.121.camel@haakon2.linux-iscsi.org>
	 <1291154759.17194.133.camel@haakon2.linux-iscsi.org>
	 <4B6A08C587958942AA3002690DD4F8C30106BC00B8@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57716 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0LAA3o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 19:29:44 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106BC00B8@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

On Tue, 2010-11-30 at 15:30 -0700, Yang, Bo wrote:
> Nicholas,
> 
> Thanks for put it back.  This set (to NULL) is in original megasas_get_cmd  src.  
> 
> Can you share your testing with us (how much test you did in lock_less kernel)?
> We don't do any test with this kernel..
> 

Sure..   So I have been testing initially with RAMDISK_DR (for stressing
testing) and smaller sized FILEIO backstores w/ XFS for consistency.
For the stressing testing using LTP disktest, (4K) and large (128K)
block sizes to both RAMDISK_DR and FILEIO LUNs where used w/ Hannes's
8708EM2 emulation -> SG_IO into a lock-less megaraid_sas .37-rc3 KVM
guest.

These stress tests where running sustained on the order of hours without
any observed issues at 40K IOPs for 4K and ~1800 MB/sec for 128K.
Following the /proc/scsi_target/mib/scsi_lu statistics the test run was
on the order of 100,000,000 individual I/Os and ~900 GB of total SCSI
payload traffic in lock_less mode.

For the FILEIO tests, I created a small XFS filesystem and copied over a
number of binary packages and compared md5sums after an umount and
reboot, etc.  Also, running xfs_repair reported no issues for FS level
consistency.

--nab


> Thanks,
> 
> Bo Yang
> 
> 
> -----Original Message-----
> From: Nicholas A. Bellinger [mailto:nab@linux-iscsi.org] 
> Sent: Tuesday, November 30, 2010 5:06 PM
> To: Yang, Bo
> Cc: linux-scsi; Hannes Reinecke; Christoph Hellwig; James Bottomley; Daftardar, Jayant
> Subject: RE: [PATCH 0/3] megaraid_sas: Convert to host_lock less w/ interrupts disabled internally
> 
> On Tue, 2010-11-30 at 13:21 -0800, Nicholas A. Bellinger wrote:
> > On Mon, 2010-11-29 at 23:26 -0700, Yang, Bo wrote:
> > > Nicholas,
> > >
> > > Thanks for your patches (patches 1 -3).  We need to build the driver and provide it to our testing team to do
> > > the full verification on lock_less kernel.
> > 
> > > The patch 2 and patch 3 changed the driver's major routines (I/O, get/return cmds routines and OCR routine).
> > > I will keep update after we did the internal patch re-view for those changes as well as the testing team
> > > give us the report.
> > > 
> > 
> > Great, thanks for moving forward on the lock_less conversion..  Please
> > let me know if you have any other questions.
> > 
> > > By the way, can you send me the full link of: lio-core-2.6.git/lock_less-LLDs-for-38-v2?  I am try to understand the changes for patch 3
> > 
> > 
> > The patch #3 in full context is available here:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/scsi/megaraid/megaraid_sas.c;h=c42e1e4ef8c9923d9a930fa631f8d65455afadd6;hb=lock_less-LLDs-for-38-v2
> > 
> > Thanks!
> > 
> > --nab
> > 
> > 
> 
> Hi Bo,
> 
> I also noticed that __megasas_get_cmd() still needs the initial *cmd =
> NULL assignment.  Pushing the following into lock_less-LLDs-for-38-v2
> now:
> 
> Subject: [PATCH] megaraid_sas: Add NULL assignment in __megasas_get_cmd()
> 
> This patch changes the initial struct megasas_cmd *cmd to NULL,
> which follows the pre lock_less conversion code.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
> index c42e1e4..be956a5 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.c
> +++ b/drivers/scsi/megaraid/megaraid_sas.c
> @@ -131,7 +131,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
>  static struct megasas_cmd *
>  __megasas_get_cmd(struct megasas_instance *instance)
>  {
> -       struct megasas_cmd *cmd;
> +       struct megasas_cmd *cmd = NULL;
> 
>         if (!list_empty(&instance->cmd_pool)) {
>                 cmd = list_entry((&instance->cmd_pool)->next,
> -- 
> 1.7.2.3
> 
> Thanks!
> 
> --nab
> 
> > > +	struct megasas_cmd *cmd;
> > >  	unsigned long flags;
> > > -	struct megasas_cmd *cmd = NULL;
> > > 
> > > And 
> > > 
> > > +megasas_get_cmd(struct megasas_instance *instance) {
> > > +	struct megasas_cmd *cmd;
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
> > > +	cmd = __megasas_get_cmd(instance);
> > >  	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
> > > +
> > >  	return cmd;
> > >  }     
> > > 
> > > Regards,
> > > 
> > > Bo Yang  
> > > 
> > > -----Original Message-----
> > > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Nicholas A. Bellinger
> > > Sent: Sunday, November 28, 2010 2:18 AM
> > > To: linux-scsi; Hannes Reinecke; Yang, Bo
> > > Cc: Christoph Hellwig; James Bottomley; Nicholas Bellinger
> > > Subject: [PATCH 0/3] megaraid_sas: Convert to host_lock less w/ interrupts disabled internally
> > > 
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > Greetings Hannes, Bo and Co,
> > > 
> > > This series converts megaraid_sas to run in modern host_lock-less mode
> > > for >= .37-rc3+ with interrupts disabled internally around megasas_instance->hba_lock.
> > > This series is currently living in lio-core-2.6.git/lock_less-LLDs-for-38-v2,
> > > and is intended for .38 mainline code.
> > > 
> > > The first patch adds a handful of missing barriers around instance->fw_outstanding
> > > usage w/ atomic_add() and atomic_dec().
> > > 
> > > The second converts instance->issuepend_done to an atomic_t, along with
> > > the necessary assignments in order to run w/ Scsi_Host->host_lock, and
> > > without instance->hba_lock.
> > > 
> > > The third patch does the actual conversion, and adds a __megasas_get_cmd()
> > > usased by megasas_queue_command() w/ instance->hba_lock, along with
> > > being held for megasas_build_ldio() and megasas_build_dcdb() in order
> > > to locate the proper frame for struct megasas_cmd.  This is really the
> > > one major change in order to get host_lock-less to function with interrupts
> > > disabled around hba_lock.
> > > 
> > > So far this has been tested with Hannes's QEMU 8708EM2 HBA emulation with
> > > TCM_Loop backends using SG_IO from KVM host in a paired Host/Guest .37-rc3
> > > environment.  This has not been tested on real silicon yet, but I believe
> > > this series should be working there as well.
> > > 
> > > Comments are welcome, thanks!
> > > 
> > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > > 
> > > Nicholas Bellinger (3):
> > >   megaraid_sas: Add smp_mb__after_atomic_*() for
> > >     instance->fw_outstanding
> > >   megaraid_sas: Convert instance->issuepend_done to atomic_t
> > >   megaraid_sas: Convert SHT->queuecommand() to run host_lock-less
> > > 
> > >  drivers/scsi/megaraid/megaraid_sas.c |   84 ++++++++++++++++++++++-----------
> > >  drivers/scsi/megaraid/megaraid_sas.h |    2 +-
> > >  2 files changed, 57 insertions(+), 29 deletions(-)
> > > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

