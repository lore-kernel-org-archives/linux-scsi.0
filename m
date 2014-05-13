From: ching <ching2048@areca.com.tw>
Subject: Re: [PATCH v1.1 2/16 update 3] arcmsr:  Adding code to support
 MSI-X interrupt
Date: Tue, 13 May 2014 20:17:59 +0800
Message-ID: <1399983479.7074.9.camel@localhost>
References: <1399463548.23184.6.camel@localhost>
	 <536A43AF.6060908@redhat.com> <1399549025.25794.4.camel@localhost>
	 <536CB8EB.3040401@redhat.com> <1399895733.4349.2.camel@localhost>
	 <5370C620.9060303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5370C620.9060303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Tomas,

I will repost patch1 to patch17.
Although, patch3 to patch16 are not change, but patch2 has been updated.
So, the patch line number are shifted in patch3 till patch16.

On Mon, 2014-05-12 at 15:01 +0200, Tomas Henzl wrote:
> On 05/12/2014 01:55 PM, ching wrote:
> > Hi Tomas,
> >
> > Thanks for your remind again.
> > The patch 17/17 will be as following.
> 
> Hi Ching,
> I think we have messed up this thread a bit. Please repost the 2/16 with fixes related only to msi-x,
> this is the original 2/26 patch update with fixes directly related to it - free_irq + related fixes to error path.
> This should create a clear situation so James knows what he should take
> 
> For the other changes - moving scsi_scan_host + flush_work etc. either create a 17/16 patch
> or  wait until the 16/16 set is taken and then post a new patch.
> 
>  out_free_sysfs:
> -scsi_host_remove:
> -	scsi_remove_host(host);
> -RAID_controller_stop:
> +	del_timer_sync(&acb->eternal_timer);
> +	flush_scheduled_work();
> 
> Btw, isn't flush_work(&acb->arcmsr_d..  better here?
Agree.
> and if so the block looks almost identical to what is in arcmsr_shutdown,
> can we use it instead?
I do not prefer to call shutdown at here.
> 
> Thanks,
> Tomas
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
> >
> > On Fri, 2014-05-09 at 13:15 +0200, Tomas Henzl wrote:
> >> On 05/08/2014 01:37 PM, ching wrote:
> >>> Hi Tomas,
> >>>
> >>> Thanks for your suggestion.
> >>> I will add a new patch 17/17 at last.
> >> This additional patch was meant for moving the scsi_scan_host, because it's
> >> nor related to the ms-x interrupts. Probably  the maintainer will prefer
> >> a single patch which changes msi-x at once, I don't care.
> >> To the patch below - you should also free the allocated irqs as I wrote previously.
> >>
> >> Cheers,
> >> Tomas
> >>
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
