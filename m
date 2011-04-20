From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 1/3] scsi_dh_rdac : Add definitions for different RDAC
 operating modes
Date: Wed, 20 Apr 2011 09:08:30 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FFC0B9A5@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4FFAC9624@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:55862 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634Ab1DTPHg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2011 11:07:36 -0400
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4FFAC9624@cosmail01.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: "Cummins, Charles" <Charles.Cummins@lsi.com>, James Bottomley <James.Bottomley@suse.de>

Charles has been testing these patches for last couple of weeks. James, Can you please consider these patches for next scsi update..

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Moger, Babu
> Sent: Friday, April 08, 2011 12:38 PM
> To: linux-scsi@vger.kernel.org; device-mapper development
> Cc: Qi, Yanling; Chauhan, Vijay; Stankey, Robert; Arumugam, Anburaja;
> Krishnasamy, Somasundaram; Dachepalli, Sudhir
> Subject: [PATCH 1/3] scsi_dh_rdac : Add definitions for different RDAC
> operating modes
> 
> This patch adds definitions to support for different operating modes for
> LSI rdac storage.
> Currently, rdac support 3 operation modes.
> 
> 1. RDAC mode(legacy)
> 2. AVT mode
> 3. IOSHIP mode
> These definitions are used while activating the path(rdac_activate).
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Yanling Qi <yanling.qi@lsi.com>
> Reviewed-by: Sudhir Dachepalli <Sudhir.Dachepalli@lis.com>
> Reviewed-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>
> Reviewed-by: Bob Stankey <Robert.Stankey@lsi.com>
> Reviewed-by: Vijay Chauhan <Vijay.Chauhan@lsi.com>

Tested-by: Charles Cummins <Charles.cummins@lsi.com>

> 
> ---
> --- linux-2.6.38/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-
> 03-17 16:31:53.000000000 -0500
> +++ linux-2.6.38/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-03-17
> 16:47:52.000000000 -0500
> @@ -182,6 +182,12 @@ struct rdac_dh_data {
>  	struct rdac_controller	*ctlr;
>  #define UNINITIALIZED_LUN	(1 << 8)
>  	unsigned		lun;
> +
> +#define RDAC_MODE		0
> +#define RDAC_MODE_AVT		1
> +#define RDAC_MODE_IOSHIP	2
> +	unsigned char		mode;
> +
>  #define RDAC_STATE_ACTIVE	0
>  #define RDAC_STATE_PASSIVE	1
>  	unsigned char		state;
> @@ -190,6 +196,11 @@ struct rdac_dh_data {
>  #define RDAC_LUN_OWNED		1
>  #define RDAC_LUN_AVT		2
>  	char			lun_state;
> +
> +#define RDAC_PREFERRED		0
> +#define RDAC_NON_PREFERRED	1
> +	char			preferred;
> +
>  	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
>  	union			{
>  		struct c2_inquiry c2;
> @@ -199,11 +210,15 @@ struct rdac_dh_data {
>  	} inq;
>  };
> 
> +static const char *mode[] = {
> +	"RDAC",
> +	"AVT",
> +	"IOSHIP",
> +};
>  static const char *lun_state[] =
>  {
>  	"unowned",
>  	"owned",
> -	"owned (AVT mode)",
>  };
> 
>  struct rdac_queue_data {
> @@ -836,8 +851,9 @@ static int rdac_bus_attach(struct scsi_d
>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> 
>  	sdev_printk(KERN_NOTICE, sdev,
> -		    "%s: LUN %d (%s)\n",
> -		    RDAC_NAME, h->lun, lun_state[(int)h->lun_state]);
> +		    "%s: LUN %d (%s) (%s)\n",
> +		    RDAC_NAME, h->lun, mode[(int)h->mode],
> +		    lun_state[(int)h->lun_state]);
> 
>  	return 0;
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
