From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [RFC PATCH 9/9] libfc: adds queue_depth ramp up to libfc
Date: Wed, 02 Sep 2009 11:00:37 -0700
Message-ID: <1251914437.29277.99.camel@vi2.jf.intel.com>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
	 <20090826180403.23396.61277.stgit@vi1.jf.intel.com>
	 <20090827101957.GA5125@schmichrtp>
	 <1251406591.14954.19.camel@vi2.jf.intel.com>
	 <20090828104442.GA4550@schmichrtp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:17843 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582AbZIBSAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 14:00:38 -0400
In-Reply-To: <20090828104442.GA4550@schmichrtp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Fri, 2009-08-28 at 12:44 +0200, Christof Schmitt wrote:
> On Thu, Aug 27, 2009 at 01:56:31PM -0700, Vasu Dev wrote:

<snip>
> 
> I reused the default_depth settings for checking the maximum queue
> depth. But i am wondering if the check should happen differently.
> Would it make more sense to have an adjustable maximum_depth attribute
> for each SCSI device? Or would it be possible to always increase the
> queue depth until the storage returns QUEUE_FULL again?

Increasing only up to initially configured maximum_depth by LLD is
required otherwise there won't be any upper bound on qdepth increase and
in case of no traffic the qdepth will keep on increasing since there
won't be any QUEUE_FULL event in that case and that might lead to other
issues with qdepth related other resources in the stack.

Currently scsi-ml is not aware of maximum_depth but as you suggested
above it can be added to each scsi_device and then common scsi-ml ramp
up code can ramp up up to configured maximum_depth. But that would
require adding maximum_depth field to scsi_device for only ramp up
purpose and given ramp up call back is required for LLD requiring their
additional resources adjustment I had LLD checked for maximum_depth.

However I think moving qdepth increment qdepth++ to scsi-ml common ramp
up code will eliminate increment in each LLD. I'll do that move.

	Thanks
	Vasu

> ---
> zfcp: Adapt change_queue_depth for queue full tracking
> 
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> 
> Adapt the change_queue_depth callback in zfcp for the new reason
> parameter. Simply pass each call back to the SCSI midlayer, there are
> no resource adjustments necessary for zfcp.
> 
> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_scsi.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> --- a/drivers/s390/scsi/zfcp_scsi.c	2009-08-28 12:00:12.000000000 +0200
> +++ b/drivers/s390/scsi/zfcp_scsi.c	2009-08-28 12:01:27.000000000 +0200
> @@ -28,9 +28,25 @@ char *zfcp_get_fcp_sns_info_ptr(struct f
>  	return fcp_sns_info_ptr;
>  }
>  
> -static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth)
> +static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth,
> +					int reason)
>  {
> -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> +	switch (reason) {
> +	case SCSI_QDEPTH_SYSFS_REQ:
> +		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> +		break;
> +	case SCSI_QDEPTH_QFULL:
> +		scsi_track_queue_full(sdev, depth);
> +		break;
> +	case SCSI_QDEPTH_RAMP_UP:
> +		depth++;
> +		if (depth <= default_depth)
> +			scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
> +						depth);
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
>  	return sdev->queue_depth;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

