From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC PATCH 9/9] libfc: adds queue_depth ramp up to libfc
Date: Thu, 27 Aug 2009 12:19:58 +0200
Message-ID: <20090827101957.GA5125@schmichrtp>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com> <20090826180403.23396.61277.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:37805 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZH0KUW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 06:20:22 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n7RAK99h434786
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2009 10:20:14 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7RAJxXj1060952
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2009 11:19:59 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7RAJw5e017711
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2009 11:19:59 +0100
Content-Disposition: inline
In-Reply-To: <20090826180403.23396.61277.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Wed, Aug 26, 2009 at 11:04:03AM -0700, Vasu Dev wrote:
> Increases queue_depth by one on fc_change_queue_depth call back
> with reason SCSI_QDEPTH_RAMP_UP.
> 
> Signed-off-by: Vasu Dev <vasu.dev@intel.com>
> ---
> 
>  drivers/scsi/libfc/fc_fcp.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index dda4162..92e8a1b 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -2054,6 +2054,11 @@ int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
>  	case SCSI_QDEPTH_QFULL:
>  		scsi_track_queue_full(sdev, qdepth);
>  		break;
> +	case SCSI_QDEPTH_RAMP_UP:
> +		if (qdepth + 1 <= FC_FCP_DFLT_QUEUE_DEPTH)
> +			scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
> +						qdepth + 1);
> +		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}

Overall the approach looks good to me.

I am trying to find out how this applies to the zfcp driver. Is the
approach in fc_change_queue_depth a good example for a driver that
does not have to adjust internal resources when changing the queue
depth?

--
Christof Schmitt
