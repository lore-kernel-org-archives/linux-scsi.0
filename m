From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/6] ipr: AF DASD raw mode implementation in ipr driver
Date: Thu, 09 Apr 2015 14:17:39 -0700
Message-ID: <1428614259.2448.3.camel@HansenPartnership.com>
References: <201503261623.t2QGNxP3021634@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57911 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756124AbbDIVRl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 17:17:41 -0400
In-Reply-To: <201503261623.t2QGNxP3021634@d03av04.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, kreling@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com

On Thu, 2015-03-26 at 11:23 -0500, Brian King wrote:
> From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> 
> This patch implements raw mode support for AF DASD in ipr driver
> which allows for tools to send commands directly to physical
> devices which are members of RAID arrays when enabled in the firmware.
> 
> Signed-off-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ipr.h |    3 +
>  2 files changed, 88 insertions(+)
> 
> diff -puN drivers/scsi/ipr.c~ipr_sispipe drivers/scsi/ipr.c
> --- linux/drivers/scsi/ipr.c~ipr_sispipe	2015-03-26 10:53:55.540578199 -0500
> +++ linux-bjking1/drivers/scsi/ipr.c	2015-03-26 10:57:00.570080498 -0500
[...]
> @@ -6152,6 +6228,13 @@ static void ipr_erp_start(struct ipr_ioa
>  		break;
>  	case IPR_IOASC_NR_INIT_CMD_REQUIRED:
>  		break;
> +	case IPR_IOASC_IR_NON_OPTIMIZED:
> +		if (res->raw_mode){

Missing space here ... checkpatch would have picked this up; please use
it.

James


