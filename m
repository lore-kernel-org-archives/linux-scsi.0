From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 03/12] libsas: Convert to host_lock less w/ interrupts
	disabled externally
Date: Mon, 20 Dec 2010 01:33:26 -0800
Message-ID: <1292837606.20840.52.camel@haakon2.linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
	 <1292793727-31957-4-git-send-email-nab@linux-iscsi.org>
	 <4D0F1A99.8000703@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D0F1A99.8000703@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-iscsi-target-dev@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, adam radford <aradford@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-12-20 at 10:58 +0200, Boaz Harrosh wrote:
> On 12/19/2010 11:21 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch converts the libsas queuecommand to run in host_lock less mode
> > w/ the new IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling
> > ->queuecommand() dispatch.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/scsi/libsas/sas_scsi_host.c |   12 ++----------
> >  1 files changed, 2 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> > index 29251fa..011580f 100644
> > --- a/drivers/scsi/libsas/sas_scsi_host.c
> > +++ b/drivers/scsi/libsas/sas_scsi_host.c
> > @@ -185,24 +185,17 @@ int sas_queue_up(struct sas_task *task)
> >  /**
> >   * sas_queuecommand -- Enqueue a command for processing
> >   * @parameters: See SCSI Core documentation
> > - *
> > - * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
> > - * call us without holding an IRQ spinlock...
> >   */
> > -static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
> > +static int sas_queuecommand_irq_disable(struct scsi_cmnd *cmd,
> >  		     void (*scsi_done)(struct scsi_cmnd *))
> > -	__releases(host->host_lock)
> >  	__acquires(dev->sata_dev.ap->lock)
> >  	__releases(dev->sata_dev.ap->lock)
> > -	__acquires(host->host_lock)
> >  {
> >  	int res = 0;
> >  	struct domain_device *dev = cmd_to_domain_dev(cmd);
> >  	struct Scsi_Host *host = cmd->device->host;
> >  	struct sas_internal *i = to_sas_internal(host->transportt);
> >  
> > -	spin_unlock_irq(host->host_lock);
> > -
> >  	{
> >  		struct sas_ha_struct *sas_ha = dev->port->ha;
> >  		struct sas_task *task;
> > @@ -250,11 +243,10 @@ static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
> >  		}
> >  	}
> >  out:
> > -	spin_lock_irq(host->host_lock);
> >  	return res;
> >  }
> >  
> > -DEF_SCSI_QCMD(sas_queuecommand)
> > +IRQ_DISABLE_SCSI_QCMD(sas_queuecommand)
> >  
> 
> I hate this new macro. It is so simple by now. And anyway you are
> doing them one by one and auditing the code. Please completely drop
> this macro and open code it. There is no "safety" argument to this
> ugliness, any more.
> 
> (Completely drop the [PATCH 02/12] scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
>  patch and redo the users)
> 

Hi Boaz,

I am happy to open code the handful of remaining LLDs that need proper
conversion for lock_less-LLDs-for-38-v4 and drop patch #2 now that we
have isolated the first round of host_lock-less LLD conversions. 

Best Regards,

--nab
