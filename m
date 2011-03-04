From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] libsas: fix/amend device gone notification in
 sas_deform_port()
Date: Fri, 04 Mar 2011 14:53:22 -0800
Message-ID: <1299279202.15839.4.camel@dwillia2-linux>
References: <20110217030659.4303.12762.stgit@localhost6.localdomain6>
	 <4D5DB0F0.4060006@redhat.com> <4D5DBB10.4030905@intel.com>
	 <4D716B65.20007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:39096 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab1CDWxh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2011 17:53:37 -0500
In-Reply-To: <4D716B65.20007@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "Fan, Haipao" <haipao.fan@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Trela, Maciej" <Maciej.Trela@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Darrick J. Wong" <djwong@us.ibm.com>

On Fri, 2011-03-04 at 14:44 -0800, David Milburn wrote:
> Dan Williams wrote:
> >> Dan,
> >>
> >> So, you are seeing sas_ata_task_done() trying to get the ata_port lock,
> >> but it has already been taken earlier in the code path?
> >>
> >> ata_scsi_queuecmd (spin_lock_irqsave(ap->lock, irq_flags)
> >>     __ata_scsi_queuecmd
> >>       ata_scsi_translate
> >>         ata_qc_issue
> >>           sas_ata_qc_issue
> >>             isci_task_execute_task
> >>               isci_task_complete_for_upper_layer
> >>                 sas_ata_task_done
> >> (spin_lock_irqsave(dev->sata_dev.ap->lock, flags)
> > 
> > Exactly.
> > 
> > sas_device_gone() should prevent an lldd from ever attempting an i/o to 
> > a missing sata device (one that has been notified via lldd_dev_gone). 
> > Although, I have only had time to verify the simple unplug case and 
> > sync-cache commands at driver unload.  We'll still need to handle 
> > missing ssp devices, but there are no lldd-external locking concerns in 
> > that path.
> > 
> 
> Dan,
> 
> One other question, should sas_device_gone() be sync'ing with sata io
> thru ata port lock instead of the Scsi_Host lock?
> 
> Looking at sas_queuecommand, the host_lock is released and the ata
> port lock is taken before calling ata_sas_queuecmd, and ata port lock is 
> held
> down the __ata_scsi_queuecmd path.
> 
> Should sas_device_gone get the ap->lock from the domain_device->
> sata_dev to better sync against sata io?

Unless I am mistaken they are one in the same, see ata_sas_port_alloc:

struct ata_port *ata_sas_port_alloc(struct ata_host *host,
                                    struct ata_port_info *port_info,
                                    struct Scsi_Host *shost)
{
        struct ata_port *ap;

        ap = ata_port_alloc(host);
        if (!ap)
                return NULL;

        ap->port_no = 0;
        ap->lock = shost->host_lock;
        ap->pio_mask = port_info->pio_mask;
        ap->mwdma_mask = port_info->mwdma_mask;
        ap->udma_mask = port_info->udma_mask;
        ap->flags |= port_info->flags;
        ap->ops = port_info->port_ops;
        ap->cbl = ATA_CBL_SATA;

        return ap;
}

--
Dan


