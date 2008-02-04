From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 4/9] scsi_dh: add skeleton for SCSI Device Handlers
Date: Mon, 04 Feb 2008 10:54:40 -0800
Message-ID: <1202151280.13537.1.camel@linuxchandra>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	 <20080124003115.18871.42778.sendpatchset@localhost.localdomain>
	 <47A378C3.5030207@cs.wisc.edu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:54923 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYBDSyn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 13:54:43 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m14IsgaX020715
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2008 13:54:42 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m14IsgsP215956
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2008 11:54:42 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m14IsgsV005798
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2008 11:54:42 -0700
In-Reply-To: <47A378C3.5030207@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, jens.axboe@oracle.com

On Fri, 2008-02-01 at 13:53 -0600, Mike Christie wrote:
> Chandra Seetharaman wrote:
> >  	 * mainly associated with tapes and returned SUCCESS.
> > Index: linux-2.6.24-rc8/drivers/scsi/scsi_sysfs.c
> > ===================================================================
> > --- linux-2.6.24-rc8.orig/drivers/scsi/scsi_sysfs.c
> > +++ linux-2.6.24-rc8/drivers/scsi/scsi_sysfs.c
> > @@ -951,6 +951,49 @@ int scsi_register_interface(struct class
> >  }
> >  EXPORT_SYMBOL(scsi_register_interface);
> >  
> > +static int scsi_dh_notifier_add(struct device *dev, void *data)
> > +{
> > +	struct scsi_device_handler *sdev_dh = data;
> > +
> > +	sdev_dh->nb.notifier_call(&sdev_dh->nb, BUS_NOTIFY_ADD_DEVICE, dev);
> > +
> > +	return 0;
> > +}
> > +
> > +int scsi_register_device_handler(struct scsi_device_handler *sdev_dh)
> > +{
> > +	int ret;
> > +
> > +	ret = bus_register_notifier(&scsi_bus_type, &sdev_dh->nb);
> > +
> > +	bus_for_each_dev(&scsi_bus_type, NULL, sdev_dh, scsi_dh_notifier_add);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(scsi_register_device_handler);
> > +
> > +static int scsi_dh_notifier_remove(struct device *dev, void *data)
> > +{
> > +	struct scsi_device_handler *sdev_dh = data;
> > +
> > +	sdev_dh->nb.notifier_call(&sdev_dh->nb, BUS_NOTIFY_DEL_DEVICE, dev);
> > +
> > +	return 0;
> > +}
> > +
> > +int scsi_unregister_device_handler(struct scsi_device_handler *sdev_dh)
> > +{
> > +	int ret;
> > +
> > +	ret = bus_unregister_notifier(&scsi_bus_type, &sdev_dh->nb);
> > +
> > +	bus_for_each_dev(&scsi_bus_type, NULL, sdev_dh,
> > +					scsi_dh_notifier_remove);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(scsi_unregister_device_handler);
> > +
> 
> Did this end up solving the problem I was hitting where when using the 
> other driver model stuff like is used with the SCSI upper layer drivers. 
> The problem where the hw handler module had to be loaded before finding 
> devices and had to be loaded before sd.c?

Yes, As andmike pointed, it is coded and tested.

It works in both cases, module being inserted before sd is probed and
module inserted after sd.


> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


