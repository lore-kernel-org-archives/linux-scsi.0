From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/9] scsi_dh: add skeleton for SCSI Device Handlers
Date: Fri, 1 Feb 2008 12:27:08 -0800
Message-ID: <20080201202708.GB6808@linux.vnet.ibm.com>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain> <20080124003115.18871.42778.sendpatchset@localhost.localdomain> <47A378C3.5030207@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:43173 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbYBAU1j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 15:27:39 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m11KRXC0001509
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2008 15:27:33 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m11KRXej099950
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2008 13:27:33 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m11KRWVj005190
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2008 13:27:33 -0700
Content-Disposition: inline
In-Reply-To: <47A378C3.5030207@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

Mike Christie <michaelc@cs.wisc.edu> wrote:
> Chandra Seetharaman wrote:
>>  	 * mainly associated with tapes and returned SUCCESS.
>> Index: linux-2.6.24-rc8/drivers/scsi/scsi_sysfs.c
>> ===================================================================
>> --- linux-2.6.24-rc8.orig/drivers/scsi/scsi_sysfs.c
>> +++ linux-2.6.24-rc8/drivers/scsi/scsi_sysfs.c
>> @@ -951,6 +951,49 @@ int scsi_register_interface(struct class
>>  }
>>  EXPORT_SYMBOL(scsi_register_interface);
>>  +static int scsi_dh_notifier_add(struct device *dev, void *data)
>> +{
>> +	struct scsi_device_handler *sdev_dh = data;
>> +
>> +	sdev_dh->nb.notifier_call(&sdev_dh->nb, BUS_NOTIFY_ADD_DEVICE, dev);
>> +
>> +	return 0;
>> +}
>> +
>> +int scsi_register_device_handler(struct scsi_device_handler *sdev_dh)
>> +{
>> +	int ret;
>> +
>> +	ret = bus_register_notifier(&scsi_bus_type, &sdev_dh->nb);
>> +
>> +	bus_for_each_dev(&scsi_bus_type, NULL, sdev_dh, scsi_dh_notifier_add);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(scsi_register_device_handler);
>> +
>> +static int scsi_dh_notifier_remove(struct device *dev, void *data)
>> +{
>> +	struct scsi_device_handler *sdev_dh = data;
>> +
>> +	sdev_dh->nb.notifier_call(&sdev_dh->nb, BUS_NOTIFY_DEL_DEVICE, dev);
>> +
>> +	return 0;
>> +}
>> +
>> +int scsi_unregister_device_handler(struct scsi_device_handler *sdev_dh)
>> +{
>> +	int ret;
>> +
>> +	ret = bus_unregister_notifier(&scsi_bus_type, &sdev_dh->nb);
>> +
>> +	bus_for_each_dev(&scsi_bus_type, NULL, sdev_dh,
>> +					scsi_dh_notifier_remove);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(scsi_unregister_device_handler);
>> +
>
> Did this end up solving the problem I was hitting where when using the 
> other driver model stuff like is used with the SCSI upper layer drivers. 
> The problem where the hw handler module had to be loaded before finding 
> devices and had to be loaded before sd.c?

Yes this update was to have the handler add routine called prior to the
upper level drivers probe routine. In device_add
blocking_notifier_call_chain is called prior to bus_attach_device which
leads to the upper level drivers probe routine being called.

The bus_register_notifier will handle new devices showing up and the
bus_for_each_dev is used to sync up with already probed devices. Obviously
loading late will not be able to handle issues during the device probe
if a device needs that type of handling.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
