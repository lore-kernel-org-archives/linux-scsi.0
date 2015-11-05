From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 03/27] hpsa: remove unused hpsa_tag_discard_error_bits
Date: Thu, 5 Nov 2015 09:30:54 -0600
Message-ID: <563B762E.8090703@linux.vnet.ibm.com>
References: <20151104214910.15472.23179.stgit@brunhilda>
 <20151104215013.15472.7744.stgit@brunhilda>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:36449 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161679AbbKEPab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 10:30:31 -0500
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 5 Nov 2015 08:30:30 -0700
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id B41353E4004E
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2015 08:30:28 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA5FUSAV9634086
	for <linux-scsi@vger.kernel.org>; Thu, 5 Nov 2015 08:30:28 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA5FURbe026614
	for <linux-scsi@vger.kernel.org>; Thu, 5 Nov 2015 08:30:28 -0700
In-Reply-To: <20151104215013.15472.7744.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Don:

Thanks for not redefining HPSA_PERF_ERROR_BITS.

Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>

---
Manoj Kumar

On 11/4/2015 3:50 PM, Don Brace wrote:
> This function is no longer used.
>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>   drivers/scsi/hpsa.c |   11 +----------
>   1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 4085401..5a996273 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -230,6 +230,7 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
>   	int cmd_type);
>   static void hpsa_free_cmd_pool(struct ctlr_info *h);
>   #define VPD_PAGE (1 << 8)
> +#define HPSA_SIMPLE_ERROR_BITS 0x03
>
>   static int hpsa_scsi_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
>   static void hpsa_scan_start(struct Scsi_Host *);
> @@ -6436,16 +6437,6 @@ static inline void finish_cmd(struct CommandList *c)
>   		complete(c->waiting);
>   }
>
> -
> -static inline u32 hpsa_tag_discard_error_bits(struct ctlr_info *h, u32 tag)
> -{
> -#define HPSA_PERF_ERROR_BITS ((1 << DIRECT_LOOKUP_SHIFT) - 1)
> -#define HPSA_SIMPLE_ERROR_BITS 0x03
> -	if (unlikely(!(h->transMethod & CFGTBL_Trans_Performant)))
> -		return tag & ~HPSA_SIMPLE_ERROR_BITS;
> -	return tag & ~HPSA_PERF_ERROR_BITS;
> -}
> -
>   /* process completion of an indexed ("direct lookup") command */
>   static inline void process_indexed_cmd(struct ctlr_info *h,
>   	u32 raw_tag)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

