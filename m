From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/2] sg: set class_data after success
Date: Mon, 14 Jan 2008 23:54:48 -0500
Message-ID: <478C3C98.3080802@torque.net>
References: <20080115131747L.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46782 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYAOEzo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 23:55:44 -0500
In-Reply-To: <20080115131747L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, mdr@sgi.com, linux-scsi@vger.kernel.org, tomof@acm.org

FUJITA Tomonori wrote:
> If cdev_add fails in sg_add, sg_remove crashes since class_data is
> bogus.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/sg.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index f1871ea..92b4367 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1418,7 +1418,6 @@ sg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
>  		goto out;
>  	}
>  
> -	class_set_devdata(cl_dev, sdp);
>  	error = cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, sdp->index), 1);
>  	if (error)
>  		goto cdev_add_err;
> @@ -1447,6 +1446,8 @@ sg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
>  		    "Attached scsi generic sg%d type %d\n", sdp->index,
>  		    scsidp->type);
>  
> +	class_set_devdata(cl_dev, sdp);
> +
>  	return 0;
>  
>  cdev_add_err:

Tomo,
Thanks.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

