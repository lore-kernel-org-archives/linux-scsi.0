From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] add back single_lun support
Date: 05 Feb 2003 17:14:00 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044486842.1773.89.camel@mulgrave>
References: <20030205145104.A6169@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id PAA07116
	for <linux-scsi@vger.kernel.org>; Wed, 5 Feb 2003 15:14:06 -0800
In-Reply-To: <20030205145104.A6169@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-02-05 at 16:51, Patrick Mansfield wrote:
> This patch against the current scsi-misc-2.5 adds back the check for the
> single_lun case.
> 
> I compiled and booted with this applied but don't have any devices (i.e.
> CD ROM changer) for testing.
> 
> --- 1.66/drivers/scsi/scsi_lib.c	Wed Feb  5 08:33:15 2003
> +++ edited/drivers/scsi/scsi_lib.c	Tue Feb 11 14:27:08 2003
> @@ -787,6 +787,22 @@
>  	return ret;
>  }
>  
> +/*
> + * The target associated with myself can only handle one active command at
> + * a time. Scan through all of the luns on the same target as myself,
> + * return 1 if any are active.
> + */
> +static int check_all_luns(struct scsi_device *myself)
> +{
> +	struct scsi_device *sdev;
> +
> +	list_for_each_entry(sdev, &myself->same_target_siblings,
> +			    same_target_siblings)
> +		if (atomic_read(&sdev->device_active))
> +			return 1;
> +	return 0;
> +}
> +

I don't see device_active getting set anywhere.

shouldn't we just dump device_active in favour of a non-zero check of
device_busy (it's all done under the queue lock, anyway).

James


