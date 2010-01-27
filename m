From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] [PATCH] scsi_dh_rdac: Changing the memory
	allocation flag from GFP_KERNEL to GFP_NOIO
Date: Wed, 27 Jan 2010 14:19:47 -0800
Message-ID: <1264630787.27583.144.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF4877BC7E8@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:36258 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab0A0WU4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2010 17:20:56 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o0RM6wpi020193
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2010 15:06:58 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0RMKrhQ089854
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2010 15:20:53 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0RMKqJR016165
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2010 15:20:53 -0700
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4877BC7E8@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chandra Seetharaman <chandra.seetharaman@us.ibm.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Rob Evers <revers@redhat.com>

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Tue, 2010-01-05 at 10:20 -0700, Moger, Babu wrote:
> This patch changes the memory allocation flag from GFP_KERNEL to GFP_NOIO which is more appropriate.
> 
> This was noticed by Mike Christie and Rob Evers.. 
> Mike Christie wrote:
> > Rob Evers wrote:
> >> +
> >> +static int queue_mode_select(struct scsi_device *sdev,
> >> +                activate_complete fn, void *data)
> >> +{
> >> +    struct rdac_queue_data *qdata;
> >> +    struct rdac_controller *ctlr;
> >> +
> >> +    qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
> >> +    if (!qdata)
> >> +        return SCSI_DH_RETRY;
> >> +
> >
> > It looks like this is called in the main IO path. A failed IO could cause, the path to go down,
> > then we would call this to active a new path. If the system needed to write out pages to the same
> > disk that just had the failed path so it can allocate memory then GFP_KERNEL would be bad to use here.
> > You would use a mempool and still use something like GFP_NOIO. If a mempool is not possible for some 
> > reason, then you would want to still use GFP_NOIO.
> 
> Using mempool would become bit more complex here because I cannot assume about the number of elements
> during the allocation. I would use GFP_NOIO.
> 
> CC: Mike Christie <michaelc@cs.wisc.edu>
> CC: Rob Evers <revers@redhat.com>
> CC: Chandra Seetharaman <chandra.seetharaman@us.ibm.com>
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> 
> ---
> --- linux-2.6.33-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2010-01-05 11:49:22.000000000 -0400
> +++ linux-2.6.33-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-01-05 11:53:13.000000000 -0400
> @@ -624,7 +624,7 @@ static int queue_mode_select(struct scsi
>  	struct rdac_queue_data *qdata;
>  	struct rdac_controller *ctlr;
> 
> -	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
> +	qdata = kzalloc(sizeof(*qdata), GFP_NOIO);
>  	if (!qdata)
>  		return SCSI_DH_RETRY;
> 
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

