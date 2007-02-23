From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: RE: [PATCH] qla2xxx: fix RSCN handling on big-endian systems
Date: Fri, 23 Feb 2007 14:51:03 -0800
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32BAE6378@AVEXCH2.qlogic.org>
References: <20070219181832.GA18043@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:25776 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbXBWWvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Feb 2007 17:51:07 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20070219181832.GA18043@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org, Linux Driver <Linux-Driver@qlogic.com>

ACK - Thank you for the findings.

Acked-by: Seokmann Ju <seokmann.ju@qlogic.com>

> -----Original Message-----
> From: malahal@us.ibm.com [mailto:malahal@us.ibm.com] 
> Sent: Monday, February 19, 2007 10:19 AM
> To: linux-scsi@vger.kernel.org; Linux Driver
> Subject: [PATCH] qla2xxx: fix RSCN handling on big-endian systems
> 
> qla2xxx driver fails to handle RSCN events affecting area or 
> domain due to an endian issue on big endian systems.  This 
> fixes the port_id_t structure on big endian systems.
> 
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> 
> diff -r c860739bb0f4 drivers/scsi/qla2xxx/qla_def.h
> --- a/drivers/scsi/qla2xxx/qla_def.h	Fri Feb 16 14:19:34 2007 -0800
> +++ b/drivers/scsi/qla2xxx/qla_def.h	Fri Feb 16 14:21:29 2007 -0800
> @@ -1478,14 +1478,17 @@ typedef union {
>  	uint32_t b24 : 24;
>  
>  	struct {
> -		uint8_t d_id[3];
> -		uint8_t rsvd_1;
> -	} r;
> -
> -	struct {
> +#ifdef __BIG_ENDIAN
> +		uint8_t domain;
> +		uint8_t area;
> +		uint8_t al_pa;
> +#elif __LITTLE_ENDIAN
>  		uint8_t al_pa;
>  		uint8_t area;
>  		uint8_t domain;
> +#else
> +#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
> +#endif
>  		uint8_t rsvd_1;
>  	} b;
>  } port_id_t;
> 
