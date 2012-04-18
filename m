From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi_dh_rdac: Add dynamic match functionality to rdac
 handler
Date: Wed, 18 Apr 2012 00:32:31 -0500
Message-ID: <4F8E51EF.5010504@cs.wisc.edu>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B0574C6@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58198 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2DRFdd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Apr 2012 01:33:33 -0400
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B0574C6@SACEXCMBX02-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@netapp.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>

On 04/10/2012 12:06 PM, Moger, Babu wrote:
> This patch adds the dynamic match functionality to scsi_dh_rdac driver.
> New vendor and product strings are normally not there in the kernel. Whenever
> the new product is tested with this driver we see failures during the disco-
> very. Without the handler attached, the default scsi mid-level retries would
> take effect for certain check-conditions. Default retries(5) are not enough in
> some cases(especially with large configuration or huge lun cases).
> 
> This patch will send an inquiry if the vendor/product strings are not in the
> device list and match with vendor signature.
> 
> Signed-off-by: Babu Moger <babu.moger@netapp.com>
> Reviewed-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@netapp.com>
> ---
> 
> --- linux-3.4-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2012-04-07 20:30:41.000000000 -0500
> +++ linux-3.4-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c	2012-04-10 10:48:40.000000000 -0500
> @@ -818,7 +818,10 @@ static const struct scsi_dh_devlist rdac
>  
>  static bool rdac_match(struct scsi_device *sdev)
>  {
> -	int i;
> +	int i, err;
> +	struct c8_inquiry inqp;

The per function stack use limit is 512 bytes right? If so then the
patch seems ok to me (thought maybe the c8_inquiry was too large but it
is under that 512 limit), so:

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
