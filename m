From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: [PATCH 2/3] scsi_dh: Provide set_params interface in emc
 device handler
Date: Mon, 20 Jul 2009 09:00:13 -0400
Message-ID: <1248094813.6307.10.camel@eddie-laptop>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
	 <20090702031320.28354.96958.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o142.mxlogic.net ([208.65.145.75]:59222 "EHLO
	p02c12o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZGTNAT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2009 09:00:19 -0400
In-Reply-To: <20090702031320.28354.96958.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com

On Wed, 2009-07-01 at 20:13 -0700, Chandra Seetharaman wrote:
> Handle the parameters provided by user thru multipath.
> 
> This handler expects only 2 parameters and their value can either be 0 or 1.
> 
> This code originates from the old dm-emc.c file. Appropriate changes have
> been made to make it work in the new design.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_emc.c |   56 ++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c
> ===================================================================
> --- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -561,6 +561,61 @@ done:
>  
>  	return result;
>  }
> +/*
> + * params - parameters in the following format
> + *      "no_of_params\0param1\0param2\0param3\0...\0"
> + *      for example, string for 2 parameters with value 10 and 21
> + *      is specified as "2\010\021\0".
> + */
> +static int clariion_set_params(struct scsi_device *sdev, const char *params)
> +{
> +	struct clariion_dh_data *csdev = get_clariion_data(sdev);
> +	unsigned int hr = 0, st = 0, argc;
> +	char *p = params;

This throws a compiler warning resolved with a type cast:
	char *p = (char *)params;



