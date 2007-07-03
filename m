From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH]mpt fusion: add sysfs attributes to display IOC parameters
Date: Tue, 03 Jul 2007 08:49:38 -0500
Message-ID: <468A53F2.5000402@linux.vnet.ibm.com>
References: <20070703130103.GA15841@lsil.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:59604 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXGCNtm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jul 2007 09:49:42 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l63DnebD029545
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jul 2007 09:49:40 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l63Dneuw268026
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jul 2007 07:49:40 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l63DndOT028299
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jul 2007 07:49:39 -0600
In-Reply-To: <20070703130103.GA15841@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

Prakash, Sathya wrote: 
> +static void
> +mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
> +{

> +
> +	memcpy(ioc->board_name, pbuf->BoardName, 16);
> +	memcpy(ioc->board_assembly, pbuf->BoardAssembly, 16);
> +	memcpy(ioc->board_tracer, pbuf->BoardTracerNumber, 16);

Are these guaranteed to be NULL terminated? The code below appears to
assume they are. Also you might want to use sizeof instead of hardcoding
16 here.

> +static ssize_t
> +mptscsih_version_driver_show(struct class_device *cdev, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%02d.%02d.%02d.%02d\n",
> +	    MPT_LINUX_MAJOR_VERSION, MPT_LINUX_MINOR_VERSION,
> +	    MPT_LINUX_BUILD_VERSION, MPT_LINUX_RELEASE_VERSION);
> +}
> +static CLASS_DEVICE_ATTR(version_driver, S_IRUGO, mptscsih_version_driver_show, NULL);

You should be using the MODULE_VERSION macro instead of this. This results
in the version showing up in /sys/module/mpt_fusion/version

> +
> +static ssize_t
> +mptscsih_io_delay_show(struct class_device *cdev, char *buf)
> +{
> +	struct Scsi_Host *host = class_to_shost(cdev);
> +	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
> +	MPT_ADAPTER *ioc = hd->ioc;
> +	char delay_str[30];
> +
> +	sprintf(delay_str, "%02d", ioc->io_missing_delay);
> +	return snprintf(buf, PAGE_SIZE, "%s\n", delay_str);
> +}

Why not just do:

	return snprintf(buf, PAGE_SIZE, "%02d", ioc->io_missing_delay);

and get rid of the delay_str on the stack? In fact you have a lot
of double sprintf's which seem like they could be just a single snprintf.


-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
