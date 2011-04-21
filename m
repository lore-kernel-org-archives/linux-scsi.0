From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] [PATCH 1/3] scsi_dh_rdac : Add definitions for different
 RDAC operating modes
Date: Thu, 21 Apr 2011 13:10:46 -0500
Message-ID: <4DB07326.4010503@cs.wisc.edu>
References: <E463DF2B2E584B4A82673F53D62C2EF4FFAC9624@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59745 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1DUSKz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2011 14:10:55 -0400
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4FFAC9624@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>

Patches 1 - 3 look ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>


On 04/08/2011 12:37 PM, Moger, Babu wrote:
> This patch adds definitions to support for different operating modes for LSI rdac storage.
> Currently, rdac support 3 operation modes.
>
> 1. RDAC mode(legacy)
> 2. AVT mode
> 3. IOSHIP mode
> These definitions are used while activating the path(rdac_activate).
>
> Signed-off-by: Babu Moger<babu.moger@lsi.com>
> Reviewed-by: Yanling Qi<yanling.qi@lsi.com>
> Reviewed-by: Sudhir Dachepalli<Sudhir.Dachepalli@lis.com>
> Reviewed-by: Somasundaram Krishnasamy<Somasundaram.Krishnasamy@lsi.com>
> Reviewed-by: Bob Stankey<Robert.Stankey@lsi.com>
> Reviewed-by: Vijay Chauhan<Vijay.Chauhan@lsi.com>
>
> ---
> --- linux-2.6.38/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-03-17 16:31:53.000000000 -0500
> +++ linux-2.6.38/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-03-17 16:47:52.000000000 -0500
> @@ -182,6 +182,12 @@ struct rdac_dh_data {
>   	struct rdac_controller	*ctlr;
>   #define UNINITIALIZED_LUN	(1<<  8)
>   	unsigned		lun;
> +
> +#define RDAC_MODE		0
> +#define RDAC_MODE_AVT		1
> +#define RDAC_MODE_IOSHIP	2
> +	unsigned char		mode;
> +
>   #define RDAC_STATE_ACTIVE	0
>   #define RDAC_STATE_PASSIVE	1
>   	unsigned char		state;
> @@ -190,6 +196,11 @@ struct rdac_dh_data {
>   #define RDAC_LUN_OWNED		1
>   #define RDAC_LUN_AVT		2
>   	char			lun_state;
> +
> +#define RDAC_PREFERRED		0
> +#define RDAC_NON_PREFERRED	1
> +	char			preferred;
> +
>   	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
>   	union			{
>   		struct c2_inquiry c2;
> @@ -199,11 +210,15 @@ struct rdac_dh_data {
>   	} inq;
>   };
>
> +static const char *mode[] = {
> +	"RDAC",
> +	"AVT",
> +	"IOSHIP",
> +};
>   static const char *lun_state[] =
>   {
>   	"unowned",
>   	"owned",
> -	"owned (AVT mode)",
>   };
>
>   struct rdac_queue_data {
> @@ -836,8 +851,9 @@ static int rdac_bus_attach(struct scsi_d
>   	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>
>   	sdev_printk(KERN_NOTICE, sdev,
> -		    "%s: LUN %d (%s)\n",
> -		    RDAC_NAME, h->lun, lun_state[(int)h->lun_state]);
> +		    "%s: LUN %d (%s) (%s)\n",
> +		    RDAC_NAME, h->lun, mode[(int)h->mode],
> +		    lun_state[(int)h->lun_state]);
>
>   	return 0;
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

