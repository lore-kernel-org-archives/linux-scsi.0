From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] [PATCH 1/5] qla4xxx: Add IPv6 support and misc
Date: Mon, 07 May 2007 13:36:32 -0500
Message-ID: <463F71B0.7000804@cs.wisc.edu>
References: <1178157907.20898.38.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42361 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713AbXEGSgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 May 2007 14:36:47 -0400
In-Reply-To: <1178157907.20898.38.camel@iscsi-sles10>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

David C Somayajulu wrote:
> Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
> 
> ---
>  drivers/scsi/qla4xxx/ql4_def.h     |   84 ++++---
>  drivers/scsi/qla4xxx/ql4_fw.h      |  426 +++++++++++++++---------------------
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
> index 6f4cf2d..7bbc2ab 100644
> --- a/drivers/scsi/qla4xxx/ql4_def.h
> +++ b/drivers/scsi/qla4xxx/ql4_def.h
> @@ -122,8 +122,7 @@ #define MAX_REQS_SERVICED_PER_INTR	16
>  
>  #define ISCSI_IPADDR_SIZE		4	/* IP address size */
>  #define ISCSI_ALIAS_SIZE		32	/* ISCSI Alais name size */
> -#define ISCSI_NAME_SIZE			255	/* ISCSI Name size -
> -						 * usually a string */
> +#define ISCSI_NAME_SIZE			0xE0	/* ISCSI Name size */
>  
>  #define LSDW(x) ((u32)((u64)(x)))
>  #define MSDW(x) ((u32)((((u64)(x)) >> 16) >> 16))
> @@ -159,6 +158,7 @@ struct srb {
>  	struct ddb_entry	*ddb;
>  	uint16_t flags;		/* (1) Status flags. */
>  
> +#define SRB_SCSI_PASSTHRU	BIT_2	/* for scsi passthru cmds */


Is this ever set or is the passthrough code in these patches ever used
or hit in upstream code or is it going to be used? It is doing the same
thing as sg io or is it different?
