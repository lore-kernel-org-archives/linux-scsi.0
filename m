Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5B5C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 06:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 414C0206F1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 06:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgEOGjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 02:39:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:34310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgEOGjU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 02:39:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B2E2EAA6F;
        Fri, 15 May 2020 06:39:21 +0000 (UTC)
Subject: Re: [PATCH v6 13/15] qla2xxx: Use make_handle() instead of
 open-coding it
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-14-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <db2b3cb5-e75b-fe2c-31f0-9441c5b08851@suse.de>
Date:   Fri, 15 May 2020 08:39:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514213516.25461-14-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/14/20 11:35 PM, Bart Van Assche wrote:
> Cc: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 87d0f5e4d81a..0a9a838c7f20 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -819,7 +819,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
>   		goto skip_rio;
>   	switch (mb[0]) {
>   	case MBA_SCSI_COMPLETION:
> -		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
> +		handles[0] = le32_to_cpu(make_handle(mb[2], mb[1]));
>   		handle_cnt = 1;
>   		break;
>   	case MBA_CMPLT_1_16BIT:
> @@ -858,10 +858,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
>   		mb[0] = MBA_SCSI_COMPLETION;
>   		break;
>   	case MBA_CMPLT_2_32BIT:
> -		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
> -		handles[1] = le32_to_cpu(
> -		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 7) << 16)) |
> -		    RD_MAILBOX_REG(ha, reg, 6));
> +		handles[0] = le32_to_cpu(make_handle(mb[2], mb[1]));
> +		handles[1] =
> +			le32_to_cpu(make_handle(RD_MAILBOX_REG(ha, reg, 7),
> +						RD_MAILBOX_REG(ha, reg, 6)));
>   		handle_cnt = 2;
>   		mb[0] = MBA_SCSI_COMPLETION;
>   		break;
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
