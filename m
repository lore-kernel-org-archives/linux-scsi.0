From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V3 1/2] smartpqi: initial commit of Microsemi smartpqi
 driver
Date: Thu, 30 Jun 2016 20:20:58 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1916380AB8@avsrvexchmbx1.microsemi.net>
References: <146611717567.26335.4769668449125772969.stgit@brunhilda>
 <146611729682.26335.17158396498682439988.stgit@brunhilda>
 <20160617095701.fv5wnorvisnbhcc6@c203.arch.suse.de>
 <4993A297653ECB4581FA5C3C31323D1916380165@avsrvexchmbx1.microsemi.net>
 <20160628075359.ypdmye7sl3y7knd4@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0086.outbound.protection.outlook.com ([104.47.34.86]:11752
	"EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751604AbcF3Uhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2016 16:37:33 -0400
In-Reply-To: <20160628075359.ypdmye7sl3y7knd4@c203.arch.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Tuesday, June 28, 2016 2:54 AM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Benesh;
> elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH V3 1/2] smartpqi: initial commit of Microsemi smartpqi
> driver
> 
> Anyway, a IMHO more important question
> 
> > > > +static void pqi_complete_queued_requests(struct pqi_ctrl_info
> *ctrl_info,
> > > > +     struct pqi_scsi_dev_t *device_in_reset)
> > > > +{
> > > > +     unsigned int i;
> > > > +     unsigned int path;
> > > > +     struct pqi_queue_group *queue_group;
> > > > +     unsigned long flags;
> > > > +     struct pqi_io_request *io_request;
> > > > +     struct pqi_io_request *next;
> > > > +     struct scsi_cmnd *scmd;
> > > > +     struct pqi_scsi_dev_t *device;
> > > > +
> > > > +     for (i = 0; i < ctrl_info->num_queue_groups; i++) {
> > > > +             queue_group = &ctrl_info->queue_groups[i];
> > > > +
> > > > +             for (path = 0; path < 2; path++) {
> > > > +                     spin_lock_irqsave(&queue_group->submit_lock[path],
> > > > +                             flags);
> > > > +
> > > > +                     list_for_each_entry_safe(io_request, next,
> > > > +                             &queue_group->request_list[path],
> > > > +                             request_list_entry) {
> > > > +                             scmd = io_request->scmd;
> > > > +                             if (scmd) {
> > > > +                                     device = scmd->device->hostdata;
> > > > +                                     if (device == device_in_reset) {
> > > > +                                             set_host_byte(scmd, DID_RESET);
> > > > +                                             pqi_scsi_done(scmd);
> > > > +                                             list_del(&io_request->
> > > > +                                                     request_list_entry);
> > > > +                                     }
> > > > +                             }
> > > > +                     }
> > > > +
> > > > +                     spin_unlock_irqrestore(&queue_group-
> >submit_lock[path],
> > > > +                             flags);
> > > > +             }
> > >
> > > If you'd factor the inner for loop into an own small (inline) function, it
> > > could drastically improve readability here.
> > >
> > > something like
> > >
> > > static void pqi_complete_queue_group(struct pqi_queue_group *qg,
> struct
> > >                                      pqi_device_t *device_in_reset)
> > > {
> > >         unsigned int path;
> > >         unsigned long flags;
> > >         struct qpi_scsi_dev_t *dev;
> > >         struct pqi_io_request *ior, *next;
> > >
> > >         for (path = 0; path < 2; path++) {
> > >                 spin_lock_irqsave(&qg->submit_lock[path], flags);
> > >
> > >                 list_for_each_entry_save(ior, next, &qg->request_list[path],
> > >                                          request_list_entry) {
> > >                         scmd = ior->scmnd;
> > >                         if (!scmd)
> > >                                 continue;
> > >
> > >                         device = scmnd->device->hostdata;
> > >                         if (dev == device_in_reset) {
> > >                                 set_host_byte(scmnd, DID_RESET);
> > >                                 pqi_scsi_done(scmnd);
> > >                                 list_del(&ior->request_list_entry);
> > >                         }
> > >                 }
> > >                 spin_unlock_irqresetore(&qg->submit_lock[path], flags);
> > >         }
> > > }
> 
> Does this have to be under a spin_lock and then even the irqsave
> variant? From my understanding scsi-mq/blk-mq is supposed to place the
> queues per-cpu. So if you're now deactivating local IRQs here you're
> throwing
> all optimizations out of the window. Can't you have the request lists and
> queues per-cpu so this code can run lockless?
> 
> Thanks,
>         Johannes
> 

The current version was developed on older kernels which did not have
scsi-mq enabled. We plan on fully supporting scsi-mq in the near
future, but would like to keep the kernel.org and internal versions
the same for now.
