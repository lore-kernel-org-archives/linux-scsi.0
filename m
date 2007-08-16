From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] add use_sg_chaining option to scsi_host_template
Date: Thu, 16 Aug 2007 13:31:43 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01D132C8@otce2k301.adaptec.com>
References: <200708161648.l7GGm15B000923@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:39135 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588AbXHPRbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Aug 2007 13:31:45 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200708161648.l7GGm15B000923@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

ACK aacraid portion (for what it is worth).

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of FUJITA Tomonori
> Sent: Thursday, August 16, 2007 12:48 PM
> To: jens.axboe@oracle.com
> Cc: linux-scsi@vger.kernel.org; James.Bottomley@SteelEye.com; 
> fujita.tomonori@lab.ntt.co.jp
> Subject: [PATCH] add use_sg_chaining option to scsi_host_template
> 
. . .
> diff --git a/drivers/scsi/aacraid/linit.c 
> b/drivers/scsi/aacraid/linit.c
> index a7f42a1..038980b 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -944,6 +944,7 @@ static struct scsi_host_template 
> aac_driver_template = {
>  	.cmd_per_lun    		= AAC_NUM_IO_FIB, 
>  #endif	
>  	.use_clustering			= ENABLE_CLUSTERING,
> +	.use_sg_chaining		= ENABLE_SG_CHAINING,
>  	.emulated                       = 1,
>  };
>  
. . .
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 3b8a6a8..cbb5217 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -36,6 +36,9 @@ struct blk_queue_tags;
>  #define DISABLE_CLUSTERING 0
>  #define ENABLE_CLUSTERING 1
>  
> +#define DISABLE_SG_CHAINING 0
> +#define ENABLE_SG_CHAINING 1
> +
>  enum scsi_eh_timer_return {
>  	EH_NOT_HANDLED,
>  	EH_HANDLED,
> @@ -438,6 +441,15 @@ struct scsi_host_template {
>  	unsigned ordered_tag:1;
>  
>  	/*
> +	 * true if the low-level driver can support sg chaining. this
> +	 * will be removed eventually when all the drivers are
> +	 * converted to support sg chaining.
> +	 *
> +	 * Status: OBSOLETE
> +	 */
> +	unsigned use_sg_chaining:1;
> +
> +	/*
>  	 * Countdown for host blocking with no commands outstanding
>  	 */
>  	unsigned int max_host_blocked;
> @@ -580,6 +592,7 @@ struct Scsi_Host {
>  	unsigned unchecked_isa_dma:1;
>  	unsigned use_clustering:1;
>  	unsigned use_blk_tcq:1;
> +	unsigned use_sg_chaining:1;
>  
>  	/*
>  	 * Host has requested that no further requests come 
> through for the
