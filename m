From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC PATCH 1/9] scsi-ml: modify change_queue_depth to take in
	reason why it is being called
Date: Thu, 27 Aug 2009 12:21:36 +0200
Message-ID: <20090827102135.GB5125@schmichrtp>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com> <20090826180320.23396.70657.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:33835 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbZH0KVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 06:21:35 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.1/8.13.1) with ESMTP id n7RALb5p028906
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2009 10:21:37 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7RALa332601140
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2009 12:21:36 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7RALaZr015988
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2009 12:21:36 +0200
Content-Disposition: inline
In-Reply-To: <20090826180320.23396.70657.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Wed, Aug 26, 2009 at 11:03:20AM -0700, Vasu Dev wrote:
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -43,6 +43,13 @@ struct blk_queue_tags;
>  #define DISABLE_CLUSTERING 0
>  #define ENABLE_CLUSTERING 1
> 
> +enum {
> +	SCSI_QDEPTH_SYSFS_REQ,	/* user requested change through sysfs */
> +	SCSI_QDEPTH_QFULL,	/* scsi-ml requested due to queue full */
> +	SCSI_QDEPTH_RAMP_UP,	/* scsi-ml requested due to threshhold event */
> +	SCSI_QDEPTH_RAMP_DOWN, 	/* LLD/class requested due to lld/class event */
> +};
> +
>  struct scsi_host_template {
>  	struct module *module;
>  	const char *name;

I did not find SCSI_QDEPTH_RAMP_DOWN being used. Would a LLD use this
internally when changing the queue depth?

--
Christof Schmitt
