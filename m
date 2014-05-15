From: ching <ching2048@areca.com.tw>
Subject: Re: [PATCH v1.2 17/16] arcmsr: fixed calling scsi_scan_host after
 all initialization done
Date: Thu, 15 May 2014 18:49:12 +0800
Message-ID: <1400150952.7179.2.camel@localhost>
References: <1400068509.6957.62.camel@localhost>
	 <5373675B.5030102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5373675B.5030102@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tomas,

Then I will have a patch 18/16 to replace flush_scheduled_work with flush_work.
Thanks for your advice.

On Wed, 2014-05-14 at 14:53 +0200, Tomas Henzl wrote:
> On 05/14/2014 01:55 PM, ching wrote:
> > From: Ching<ching2048@areca.com.tw>
> >
> > This is a new patch after patch v1.1 series.
> >
> > Fixed calling scsi_scan_host until all initialization are done.
> > And fixed error path free allocated resource.
> >
> > Signed-off-by: Ching<ching2048@areca.com.tw>
> > ---
> >
> > diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> > --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-08 17:45:34.000000000 +0800
> > +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-14 18:29:30.000000000 +0800
> > @@ -112,6 +112,7 @@ static void arcmsr_hbaD_message_isr(stru
> >  static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
> >  static const char *arcmsr_info(struct Scsi_Host *);
> >  static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
> > +static void arcmsr_free_irq(struct pci_dev *, struct AdapterControlBlock *);
> >  static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
> >  					  int queue_depth, int reason)
> >  {
> > @@ -778,12 +779,11 @@ static int arcmsr_probe(struct pci_dev *
> >  	}
> >  	error = scsi_add_host(host, &pdev->dev);
> >  	if(error){
> > -		goto RAID_controller_stop;
> > +		goto free_ccb_pool;
> >  	}
> >  	if (arcmsr_request_irq(pdev, acb) == ARC_FAILURE)
> >  		goto scsi_host_remove;
> >  	arcmsr_iop_init(acb);
> > -    	scsi_scan_host(host);
> >  	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
> >  	atomic_set(&acb->rq_map_token, 16);
> >  	atomic_set(&acb->ante_token_value, 16);
> > @@ -795,13 +795,17 @@ static int arcmsr_probe(struct pci_dev *
> >  	add_timer(&acb->eternal_timer);
> >  	if(arcmsr_alloc_sysfs_attr(acb))
> >  		goto out_free_sysfs;
> > +    	scsi_scan_host(host);
> >  	return 0;
> >  out_free_sysfs:
> > -scsi_host_remove:
> > -	scsi_remove_host(host);
> > -RAID_controller_stop:
> > +	del_timer_sync(&acb->eternal_timer);
> > + 	flush_work(&acb->arcmsr_do_message_isr_bh);
> 
> In your driver you use both flush_work(struct work_struct *) and flush_scheduled_work(),
> the second form is used used to flush the shared workqueue. 
> That said (and I think you use just one queue) you should decide which one is correct.
> In my previous mail I have asked about flush_work because i have it seen elsewhere in
> your code, now I've noticed the use of schedule_work and that means that you are using the global wq.
>  
> 
> >  	arcmsr_stop_adapter_bgrb(acb);
> >  	arcmsr_flush_adapter_cache(acb);
> > +	arcmsr_free_irq(pdev, acb);
> > +scsi_host_remove:
> > +	scsi_remove_host(host);
> > +free_ccb_pool:
> >  	arcmsr_free_ccb_pool(acb);
> >  free_hbb_mu:
> >  	arcmsr_free_mu(acb);
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
