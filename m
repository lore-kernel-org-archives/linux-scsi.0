From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Thu, 9 Mar 2006 10:05:21 -0800
Message-ID: <20060309180521.GB5498@us.ibm.com>
References: <8C064C48AB104B428CBA524C342357CA34CFCB@aime2k05.adaptec.com> <1141445373.5397.23.camel@mulgrave.il.steeleye.com> <20060306193555.GA2316@us.ibm.com> <1141674628.3167.31.camel@mulgrave.il.steeleye.com> <1141692292.8649.75.camel@localhost.localdomain> <1141830925.3194.10.camel@mulgrave.il.steeleye.com> <1141923969.8649.108.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:51410 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751118AbWCISHp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 13:07:45 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k29I7iWe014747
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 13:07:44 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k29I4xBe244212
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 11:05:00 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k29I7hXD003011
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 11:07:43 -0700
Content-Disposition: inline
In-Reply-To: <1141923969.8649.108.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Alexis Bruemmer <alexisb@us.ibm.com> wrote:
> > Which shows that the current scsi_flush_work() is in the wrong place.
> > If you move it out of sas_init.c and into aic94xx_init.c at this place,
> > I think you'll find everything now works for you.
> 
> I tried your suggestion and moved the scsi_flush_work() from sas_init.c
> to aic94xx_init.c and, unfortunately the discovery race condition still
> existed with this change (see dump below).  This makes sense because
> where we are flushing the work queue we cannot guarantee that any work
> actually exits there yet.

I assume one explanation is that without waiting for the event thread to
make it passed the event_sema there is no work to flush.

I have added some notes I had below of the different call chains.

-andmike
--
Michael Anderson
andmike@us.ibm.com

Moving the scsi_flush_work from sas_register_ha to asd_pci_probe() prior
to return of asd_pci_probe may still miss an event. The difference between
this move not working and the patch that Alexis posted working could be
that Alexis's patch was waiting until sas_discover_work_fn had called
sas_process_events prior to indicating discovery was done.

1.) pci probe context
asd_pci_probe(...)
asd_register_sas_ha(...)
	sas_register_ha(...)
		sas_start_event_thread(...)
			wait_for_completion(&event_th_comp);
		<--
asd_enable_phys(...)
scsi_flush_work(sas_ha->core.shost);


2.) hw interrupt leading to event context.
asd_hw_isr(...)
	asd_process_donelist_isr(...)
		asd_dl_tasklet_handler(...)
			asd_task_tasklet_complete(...)
			or
			control_phy_tasklet_complete(...)
			or
			escb_tasklet_complete(...)
				asd_bytes_dmaed_tasklet(...)
					notify_port_event(...)
						 up(&ha->event_sema);


3.) event thread context
sas_event_thread(...)
	complete(&event_th_comp);
	down_interruptible(&sas_ha->event_sema);
	sas_process_events(...)
		sas_process_port_event(...)
			sas_porte_bytes_dmaed(...)
				sas_form_port(...)
					sas_discover_event(...)
			INIT_WORK(&port->work, sas_discover_work_fn, port);
			scsi_queue_work(port->ha->core.shost, &port->work);

4.) work fn context
sas_discover_work_fn(...)
	sas_discover_domain(...)
		sas_discover_end_dev(...)
			sas_rphy_add(...)
				scsi_scan_target(...)
