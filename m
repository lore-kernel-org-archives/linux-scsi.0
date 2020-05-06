Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E12C47256
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 13:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 664E320769
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 13:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgEFNnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 09:43:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:54064 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728716AbgEFNnn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 May 2020 09:43:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BB74EAEA1;
        Wed,  6 May 2020 13:43:44 +0000 (UTC)
Subject: Re: [PATCH v4 06/11] qla2xxx: Increase the size of struct
 qla_fcp_prio_cfg to FCP_PRIO_CFG_SIZE
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-7-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <836faa92-2f4c-5778-d46c-826e3d148940@suse.de>
Date:   Wed, 6 May 2020 15:43:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427030310.19687-7-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/27/20 5:03 AM, Bart Van Assche wrote:
> This patch fixes the following Coverity complaint without changing any
> functionality:
> 
> CID 337793 (#1 of 1): Wrong size argument (SIZEOF_MISMATCH)
> suspicious_sizeof: Passing argument ha->fcp_prio_cfg of type
> struct qla_fcp_prio_cfg * and argument 32768UL to function memset is
> suspicious because a multiple of sizeof (struct qla_fcp_prio_cfg) /*48*/
> is expected.
> 
> memset(ha->fcp_prio_cfg, 0, FCP_PRIO_CFG_SIZE);
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_fw.h | 3 ++-
>   drivers/scsi/qla2xxx/qla_os.c | 1 +
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index b364a497e33d..4fa34374f34f 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -2217,8 +2217,9 @@ struct qla_fcp_prio_cfg {
>   #define FCP_PRIO_ATTR_PERSIST   0x2
>   	uint8_t  reserved;      /* Reserved for future use          */
>   #define FCP_PRIO_CFG_HDR_SIZE   0x10
> -	struct qla_fcp_prio_entry entry[1];     /* fcp priority entries  */
> +	struct qla_fcp_prio_entry entry[1023]; /* fcp priority entries  */
>   #define FCP_PRIO_CFG_ENTRY_SIZE 0x20
> +	uint8_t  reserved2[16];
>   };
>   
>   #define FCP_PRIO_CFG_SIZE       (32*1024) /* fcp prio data per port*/
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 2dd9c2a39cd5..30c2750c5745 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7877,6 +7877,7 @@ qla2x00_module_init(void)
>   	BUILD_BUG_ON(sizeof(struct qla82xx_uri_data_desc) != 28);
>   	BUILD_BUG_ON(sizeof(struct qla82xx_uri_table_desc) != 32);
>   	BUILD_BUG_ON(sizeof(struct qla83xx_fw_dump) != 51196);
> +	BUILD_BUG_ON(sizeof(struct qla_fcp_prio_cfg) != FCP_PRIO_CFG_SIZE);
>   	BUILD_BUG_ON(sizeof(struct qla_fdt_layout) != 128);
>   	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
>   	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
