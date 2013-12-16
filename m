From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 32/32] target: Increase MAX_LUNS_PER_TPG to 16384
Date: Mon, 16 Dec 2013 14:01:56 -0800
Message-ID: <1387231316.20247.258.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-33-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38125 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3LPWBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 17:01:04 -0500
In-Reply-To: <1386979160-6928-33-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> Indicate support for hierarchical LUN addressing.
> 
> Set address method field in each LUN reported by REPORT LUNS to 1, in
> accordance with SCSI SAM specs.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_spc.c  |    8 ++++++--
>  include/target/target_core_base.h |    4 ++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 

And ignoring, given the other NAKs.

--nab

> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index 0b678fc..04690bf 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -79,7 +79,7 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
>  	buf[2] = 0x05; /* SPC-3 */
>  
>  	/*
> -	 * NORMACA and HISUP = 0, RESPONSE DATA FORMAT = 2
> +	 * NORMACA = 0, HISUP = 1, RESPONSE DATA FORMAT = 2
>  	 *
>  	 * SPC4 says:
>  	 *   A RESPONSE DATA FORMAT field set to 2h indicates that the
> @@ -88,7 +88,7 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
>  	 *   obsolete. Response data format values greater than 2h are
>  	 *   reserved.
>  	 */
> -	buf[3] = 2;
> +	buf[3] = 0x12;
>  
>  	/*
>  	 * Enable SCCS and TPGS fields for Emulated ALUA
> @@ -1164,6 +1164,10 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
>  			break;
>  
>  		int_to_scsilun(deve->mapped_lun, (struct scsi_lun *)&buf[offset]);
> +
> +		/* Address method 1 for hier flat-space address. see SAM-5 */
> +		buf[offset] |= (1 << 6);
> +
>  		offset += 8;
>  	}
>  	spin_unlock_irq(&sess->se_node_acl->device_list_lock);
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 08ecfed..537cc67 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -14,8 +14,8 @@
>  #define TARGET_CORE_VERSION		TARGET_CORE_MOD_VERSION
>  
>  /* Maximum Number of LUNs per Target Portal Group */
> -/* Don't raise above 511 or REPORT_LUNS needs to handle >1 page */
> -#define TRANSPORT_MAX_LUNS_PER_TPG		256
> +/* Don't raise above 16384 or a different format in report_luns is needed */
> +#define TRANSPORT_MAX_LUNS_PER_TPG		16384
>  /*
>   * By default we use 32-byte CDBs in TCM Core and subsystem plugin code.
>   *


