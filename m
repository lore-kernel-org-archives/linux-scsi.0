From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] scsi_remove_device locking
Date: Fri, 2 Jul 2004 21:23:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040702202351.GP30334@parcelfarce.linux.theplanet.co.uk>
References: <40E49E70.9020504@us.ibm.com> <40E5C32A.3060002@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:11152 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264914AbUGBUXz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2004 16:23:55 -0400
Content-Disposition: inline
In-Reply-To: <40E5C32A.3060002@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Fri, Jul 02, 2004 at 03:18:50PM -0500, Brian King wrote:
>  {
> -	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
> +	struct Scsi_Host *shost = sdev->host;
> +	down(&shost->scan_mutex);
> +
> +	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0) {
> +		up(&shost->scan_mutex);
>  		return;
> +	}
>  
>  	class_device_unregister(&sdev->sdev_classdev);
>  	if (sdev->transport_classdev.class)
> @@ -537,6 +542,7 @@ void scsi_remove_device(struct scsi_devi
>  	if (sdev->host->transportt->cleanup)
>  		sdev->host->transportt->cleanup(sdev);
>  	put_device(&sdev->sdev_gendev);
> +	up(&shost->scan_mutex);
>  }

IMO, this would be better done as:

{
	struct Scsi_Host *shost = sdev->host;
	down(&shost->scan_mutex);

	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
		goto out;

...
 out:
	up(&shost->scan_mutex);
}


-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
