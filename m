Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EE3C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABE492078E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgJEJDG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 05:03:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:55884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgJEJDG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Oct 2020 05:03:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A6B8AABE3;
        Mon,  5 Oct 2020 09:03:04 +0000 (UTC)
Subject: Re: [PATCH 04/10] scsi: simplify varlen CDB length checking
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20201005084130.143273-1-hch@lst.de>
 <20201005084130.143273-5-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <54150714-44ad-ff09-72a8-a69f9137e259@suse.de>
Date:   Mon, 5 Oct 2020 11:03:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005084130.143273-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/20 10:41 AM, Christoph Hellwig wrote:
> Directly access the cdb array like we do everywhere else insted of
> overlaying a structure on top of it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_logging.c |  2 +-
>   include/scsi/scsi_common.h  | 11 +++--------
>   include/scsi/scsi_proto.h   | 10 ----------
>   3 files changed, 4 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
> index 8ea44c6595efa7..b6222df7254a3a 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -111,7 +111,7 @@ static size_t scsi_format_opcode_name(char *buffer, size_t buf_len,
>   
>   	cdb0 = cdbp[0];
>   	if (cdb0 == VARIABLE_LENGTH_CMD) {
> -		int len = scsi_varlen_cdb_length(cdbp);
> +		int len = cdbp[7] + 8;
>   
>   		if (len < 10) {
>   			off = scnprintf(buffer, buf_len,
> diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
> index 731ac09ed23135..297fc1881607b6 100644
> --- a/include/scsi/scsi_common.h
> +++ b/include/scsi/scsi_common.h
> @@ -9,20 +9,15 @@
>   #include <linux/types.h>
>   #include <scsi/scsi_proto.h>
>   
> -static inline unsigned
> -scsi_varlen_cdb_length(const void *hdr)
> -{
> -	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
> -}
> -
>   extern const unsigned char scsi_command_size_tbl[8];
>   #define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
>   
>   static inline unsigned
>   scsi_command_size(const unsigned char *cmnd)
>   {
> -	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
> -		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
> +	if (cmnd[0] == VARIABLE_LENGTH_CMD)
> +		return cmnd[7] + 8;
> +	return COMMAND_SIZE(cmnd[0]);
>   }
>   
>   /* Returns a human-readable name for the device */
> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
> index c3686011193224..c57f9cd8185526 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -176,16 +176,6 @@
>   
>   #define SCSI_MAX_VARLEN_CDB_SIZE 260
>   
> -/* defined in T10 SCSI Primary Commands-2 (SPC2) */
> -struct scsi_varlen_cdb_hdr {
> -	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
> -	__u8 control;
> -	__u8 misc[5];
> -	__u8 additional_cdb_length;         /* total cdb length - 8 */
> -	__be16 service_action;
> -	/* service specific data follows */
> -};
> -
>   /*
>    *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
>    *  T10/1561-D Revision 4 Draft dated 7th November 2002.
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
