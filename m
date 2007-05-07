From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] [PATCH 4/5] qla4xxx: Add IPv6 support and misc
Date: Mon, 07 May 2007 13:31:12 -0500
Message-ID: <463F7070.5080601@cs.wisc.edu>
References: <1178158199.21709.5.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42354 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965749AbXEGSb3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 May 2007 14:31:29 -0400
In-Reply-To: <1178158199.21709.5.camel@iscsi-sles10>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

David C Somayajulu wrote:
> Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
> 
> ---
>  drivers/scsi/qla4xxx/ql4_mbx.c     |  190 ++++++++++------
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
> index 7f28657..0ef777a 100644
> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
> @@ -6,6 +6,10 @@
>   */
>  
>  #include "ql4_def.h"
> +#include "ql4_version.h"
> +#include "ql4_glbl.h"
> +#include "ql4_dbg.h"
> +#include "ql4_inline.h"

Did you need to bring in all of these? You did not need version did you?

>  
> -	memset((void *)fw_ddb_entry->iSCSIAlias, 0,
> -	       sizeof(fw_ddb_entry->iSCSIAlias));
> +	memset((void *)fw_ddb_entry->iscsi_alias, 0,
> +	       sizeof(fw_ddb_entry->iscsi_alias));
>  
> -	memset((void *)fw_ddb_entry->iscsiName, 0,
> -	       sizeof(fw_ddb_entry->iscsiName));
> +	memset((void *)fw_ddb_entry->iscsi_name, 0,
> +	       sizeof(fw_ddb_entry->iscsi_name));
>  
> -	memset((void *)fw_ddb_entry->ipAddr, 0, sizeof(fw_ddb_entry->ipAddr));
> -	memset((void *)fw_ddb_entry->targetAddr, 0,
> -	       sizeof(fw_ddb_entry->targetAddr));
> +	memset((void *)fw_ddb_entry->ip_addr, 0, sizeof(fw_ddb_entry->ip_addr));
> +	memset((void *)fw_ddb_entry->tgt_addr, 0,
> +	       sizeof(fw_ddb_entry->tgt_addr));
>  

I am not sure if it is a big deal or if it clutters the code, but I do
not think you need the void * casts in there.
