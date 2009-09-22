From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [2.6.31] Memory leak in SCSI initialization?
Date: Tue, 22 Sep 2009 23:26:08 +0900
Message-ID: <200909222326.GGB13598.JFVOtQFOMOSLHF@I-love.SAKURA.ne.jp>
References: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
	<1253625194.5923.10.camel@concordia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wine.ocn.ne.jp ([122.1.235.145]:64286 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbZIVO0J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2009 10:26:09 -0400
In-Reply-To: <1253625194.5923.10.camel@concordia>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michael@ellerman.id.au
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hello.

Michael Ellerman wrote:
> I think this will fix it:
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 9ce5c34..284bcbe 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -957,7 +957,7 @@ static inline void scsi_destroy_sdev(struct scsi_device *sdev)
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(&sdev->sdev_gendev);
> -	put_device(&sdev->sdev_gendev);
> +	put_device(&sdev->sdev_dev);
>  }
>  
>  #ifdef CONFIG_SCSI_LOGGING

Yes. This patch solved the memory leak.

Thank you.
