Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D431C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 08:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D95624650
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 08:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfLSIiq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 03:38:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:38378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfLSIip (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Dec 2019 03:38:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0AB6CAC9A;
        Thu, 19 Dec 2019 08:38:44 +0000 (UTC)
Date:   Thu, 19 Dec 2019 09:39:21 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] qla2xxx: Fix the endianness of the qla82xx_get_fw_size()
 return type
Message-ID: <20191219083921.2w3iibvbg2e53tg3@boron>
References: <20191219004905.39586-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219004905.39586-1-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 18, 2019 at 04:49:05PM -0800, Bart Van Assche wrote:
> Since qla82xx_get_fw_size() returns a number in CPU-endian format, change
> its return type from __le32 into u32. This patch does not change any
> functionality.
> 
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Fixes: 9c2b297572bf ("[SCSI] qla2xxx: Support for loading Unified ROM Image (URI) format firmware file.")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

> ---
>  drivers/scsi/qla2xxx/qla_nx.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index 2b2028f2383e..c855d013ba8a 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -1612,8 +1612,7 @@ qla82xx_get_bootld_offset(struct qla_hw_data *ha)
>  	return (u8 *)&ha->hablob->fw->data[offset];
>  }
>  
> -static __le32
> -qla82xx_get_fw_size(struct qla_hw_data *ha)
> +static u32 qla82xx_get_fw_size(struct qla_hw_data *ha)
>  {
>  	struct qla82xx_uri_data_desc *uri_desc = NULL;
>  
> @@ -1624,7 +1623,7 @@ qla82xx_get_fw_size(struct qla_hw_data *ha)
>  			return cpu_to_le32(uri_desc->size);
>  	}
>  
> -	return cpu_to_le32(*(u32 *)&ha->hablob->fw->data[FW_SIZE_OFFSET]);
> +	return get_unaligned_le32(&ha->hablob->fw->data[FW_SIZE_OFFSET]);
>  }
>  
>  static u8 *
> @@ -1816,7 +1815,7 @@ qla82xx_fw_load_from_blob(struct qla_hw_data *ha)
>  	}
>  
>  	flashaddr = FLASH_ADDR_START;
> -	size = (__force u32)qla82xx_get_fw_size(ha) / 8;
> +	size = qla82xx_get_fw_size(ha) / 8;
>  	ptr64 = (u64 *)qla82xx_get_fw_offs(ha);
>  
>  	for (i = 0; i < size; i++) {
