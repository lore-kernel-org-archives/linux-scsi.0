From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] [SCSI] ibmvscsi: Fix SCSI scanning
Date: Mon, 20 Jun 2011 14:06:57 -0500
Message-ID: <4DFF9A51.1010400@linux.vnet.ibm.com>
References: <201106191348.40759.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:43607 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab1FTTHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2011 15:07:34 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5KIoWw4028443
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2011 12:50:32 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p5KJ7EVx145222
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2011 13:07:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5KD6SBF002087
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2011 07:06:28 -0600
In-Reply-To: <201106191348.40759.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>

On 06/19/2011 06:48 AM, Bart Van Assche wrote:
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 3d391dc..c31adf5 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -498,6 +498,11 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
>  	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
>  }
> 
> +static int ibmvscsi_target_alloc(struct scsi_target *starget)
> +{
> +	return starget->channel == 0 ? 0 : -ENODEV;
> +}
> +

This will break existing IBM Power users who have more than 64 virtual disks assigned
to a single virtual scsi adapter. The IBM VSCSI target uses Logical Unit Addressing (10b)
and does bus/id/lun -> vscsi LUN mapping as defined in SAM. The 65'th virtual scsi
disk would show up on bus 1 as target 0.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


