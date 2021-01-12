Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C251C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8E182312F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391565AbhALPjc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 10:39:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:60250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbhALPjc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 10:39:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 91894ABD6;
        Tue, 12 Jan 2021 15:38:50 +0000 (UTC)
Subject: Re: [PATCH 1/3] aha1542: clarify 'struct ccb' comments
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
 <17a7be14-a9d2-9822-bb3e-1d7385f486b0@omprussia.ru>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <719bc981-d171-d96c-8247-6d33f1054b69@suse.de>
Date:   Tue, 12 Jan 2021 16:38:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <17a7be14-a9d2-9822-bb3e-1d7385f486b0@omprussia.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/10/21 5:46 PM, Sergey Shtylyov wrote:
> This driver's original authors did pretty bad job of documenting the
> Command Control Block (CCB) structure -- especially its 2nd byte, where
> the bit numbers were completely left out.  Let's sync up the 'struct ccb'
> comments to the Adaptec AHA-154xA manual I have...
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> 
> ---
>   drivers/scsi/aha1542.h |   33 +++++++++++++++++++--------------
>   1 file changed, 19 insertions(+), 14 deletions(-)
> 
> Index: scsi/drivers/scsi/aha1542.h
> ===================================================================
> --- scsi.orig/drivers/scsi/aha1542.h
> +++ scsi/drivers/scsi/aha1542.h
> @@ -78,23 +78,28 @@ static inline void any2scsi(u8 *p, u32 v
>   #define MAX_CDB 12
>   #define MAX_SENSE 14
>   
> -struct ccb {		/* Command Control Block 5.3 */
> -	u8 op;		/* Command Control Block Operation Code */
> -	u8 idlun;	/* op=0,2:Target Id, op=1:Initiator Id */
> -			/* Outbound data transfer, length is checked*/
> -			/* Inbound data transfer, length is checked */
> -			/* Logical Unit Number */
> +/* Command Control Block (CCB), 5.3 */
> +struct ccb {
> +	u8 op;		/* Command Control Block Operation Code: */
> +			/* 0x00: SCSI Initiator CCB, 0x01: SCSI Target CCB, */
> +			/* 0x02: SCSI Initiator CCB with Scatter/Gather, */
> +			/* 0x81: SCSI Bus Device Reset CCB */
> +	u8 idlun;	/* Address and Direction Control: */
> +			/* Bits 7-5: op=0, 2: Target ID, op=1: Initiator ID */
> +			/* Bit	4: Outbound data transfer, length is checked */
> +			/* Bit	3:  Inbound data transfer, length is checked */
> +			/* Bits 2-0: Logical Unit Number */
>   	u8 cdblen;	/* SCSI Command Length */
> -	u8 rsalen;	/* Request Sense Allocation Length/Disable */
> -	u8 datalen[3];	/* Data Length (msb, .., lsb) */
> -	u8 dataptr[3];	/* Data Pointer */
> -	u8 linkptr[3];	/* Link Pointer */
> +	u8 rsalen;	/* Request Sense Allocation Length/Disable Auto Sense */
> +	u8 datalen[3];	/* Data Length  (MSB, ..., LSB) */
> +	u8 dataptr[3];	/* Data Pointer (MSB, ..., LSB) */
> +	u8 linkptr[3];	/* Link Pointer (MSB, ..., LSB) */
>   	u8 commlinkid;	/* Command Linking Identifier */
> -	u8 hastat;	/* Host Adapter Status (HASTAT) */
> -	u8 tarstat;	/* Target Device Status */
> +	u8 hastat;	/* Host  Adapter Status (HASTAT) */
> +	u8 tarstat;	/* Target Device Status (TARSTAT) */
>   	u8 reserved[2];
> -	u8 cdb[MAX_CDB+MAX_SENSE];	/* SCSI Command Descriptor Block */
> -					/* REQUEST SENSE */
> +	u8 cdb[MAX_CDB + MAX_SENSE];	/* SCSI Command Descriptor Block */
> +					/* followed by the Auto Sense data */
>   };
>   
>   #define AHA1542_REGION_SIZE 4
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
