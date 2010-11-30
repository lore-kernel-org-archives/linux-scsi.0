From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: RE: [PATCH 0/3] megaraid_sas: Convert to host_lock less w/
	interrupts disabled internally
Date: Tue, 30 Nov 2010 13:21:52 -0800
Message-ID: <1291152112.17194.121.camel@haakon2.linux-iscsi.org>
References: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
	 <4B6A08C587958942AA3002690DD4F8C30106B1E5D6@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51306 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0K3V11 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 16:27:27 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106B1E5D6@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

On Mon, 2010-11-29 at 23:26 -0700, Yang, Bo wrote:
> Nicholas,
>
> Thanks for your patches (patches 1 -3).  We need to build the driver and provide it to our testing team to do
> the full verification on lock_less kernel.

> The patch 2 and patch 3 changed the driver's major routines (I/O, get/return cmds routines and OCR routine).
> I will keep update after we did the internal patch re-view for those changes as well as the testing team
> give us the report.
> 

Great, thanks for moving forward on the lock_less conversion..  Please
let me know if you have any other questions.

> By the way, can you send me the full link of: lio-core-2.6.git/lock_less-LLDs-for-38-v2?  I am try to understand the changes for patch 3


The patch #3 in full context is available here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/scsi/megaraid/megaraid_sas.c;h=c42e1e4ef8c9923d9a930fa631f8d65455afadd6;hb=lock_less-LLDs-for-38-v2

Thanks!

--nab


> +	struct megasas_cmd *cmd;
>  	unsigned long flags;
> -	struct megasas_cmd *cmd = NULL;
> 
> And 
> 
> +megasas_get_cmd(struct megasas_instance *instance) {
> +	struct megasas_cmd *cmd;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
> +	cmd = __megasas_get_cmd(instance);
>  	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
> +
>  	return cmd;
>  }     
> 
> Regards,
> 
> Bo Yang  
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Nicholas A. Bellinger
> Sent: Sunday, November 28, 2010 2:18 AM
> To: linux-scsi; Hannes Reinecke; Yang, Bo
> Cc: Christoph Hellwig; James Bottomley; Nicholas Bellinger
> Subject: [PATCH 0/3] megaraid_sas: Convert to host_lock less w/ interrupts disabled internally
> 
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings Hannes, Bo and Co,
> 
> This series converts megaraid_sas to run in modern host_lock-less mode
> for >= .37-rc3+ with interrupts disabled internally around megasas_instance->hba_lock.
> This series is currently living in lio-core-2.6.git/lock_less-LLDs-for-38-v2,
> and is intended for .38 mainline code.
> 
> The first patch adds a handful of missing barriers around instance->fw_outstanding
> usage w/ atomic_add() and atomic_dec().
> 
> The second converts instance->issuepend_done to an atomic_t, along with
> the necessary assignments in order to run w/ Scsi_Host->host_lock, and
> without instance->hba_lock.
> 
> The third patch does the actual conversion, and adds a __megasas_get_cmd()
> usased by megasas_queue_command() w/ instance->hba_lock, along with
> being held for megasas_build_ldio() and megasas_build_dcdb() in order
> to locate the proper frame for struct megasas_cmd.  This is really the
> one major change in order to get host_lock-less to function with interrupts
> disabled around hba_lock.
> 
> So far this has been tested with Hannes's QEMU 8708EM2 HBA emulation with
> TCM_Loop backends using SG_IO from KVM host in a paired Host/Guest .37-rc3
> environment.  This has not been tested on real silicon yet, but I believe
> this series should be working there as well.
> 
> Comments are welcome, thanks!
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> Nicholas Bellinger (3):
>   megaraid_sas: Add smp_mb__after_atomic_*() for
>     instance->fw_outstanding
>   megaraid_sas: Convert instance->issuepend_done to atomic_t
>   megaraid_sas: Convert SHT->queuecommand() to run host_lock-less
> 
>  drivers/scsi/megaraid/megaraid_sas.c |   84 ++++++++++++++++++++++-----------
>  drivers/scsi/megaraid/megaraid_sas.h |    2 +-
>  2 files changed, 57 insertions(+), 29 deletions(-)
> 

