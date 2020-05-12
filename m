Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85164C54E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 06:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51B6520769
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 06:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgELGLz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 02:11:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:51022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgELGLy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 02:11:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C4D0FAC84;
        Tue, 12 May 2020 06:11:55 +0000 (UTC)
Subject: Re: [PATCH v5 09/15] qla2xxx: Use register names instead of register
 offsets
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200511200946.7675-1-bvanassche@acm.org>
 <20200511200946.7675-10-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e20d1dc7-5c93-16f9-ddb6-b37f8a5c0aad@suse.de>
Date:   Tue, 12 May 2020 08:11:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200511200946.7675-10-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/11/20 10:09 PM, Bart Van Assche wrote:
> Make qla27xx_write_remote_reg() easier to read by using register names
> instead of register offsets. The 'pahole' tool has been used to convert
> register offsets into register names. See also commit cbb01c2f2f63
> ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling").
> 
> Cc: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_tmpl.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
> index 4a4d92046cbf..645496091186 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -17,14 +17,14 @@ static void
>   qla27xx_write_remote_reg(struct scsi_qla_host *vha,
>   			 u32 addr, u32 data)
>   {
> -	char *reg = (char *)ISPREG(vha);
> +	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
>   
>   	ql_dbg(ql_dbg_misc, vha, 0xd300,
>   	       "%s: addr/data = %xh/%xh\n", __func__, addr, data);
>   
> -	WRT_REG_DWORD(reg + IOBASE(vha), 0x40);
> -	WRT_REG_DWORD(reg + 0xc4, data);
> -	WRT_REG_DWORD(reg + 0xc0, addr);
> +	WRT_REG_DWORD(&reg->iobase_addr, 0x40);
> +	WRT_REG_DWORD(&reg->iobase_c4, data);
> +	WRT_REG_DWORD(&reg->iobase_window, addr);
>   }
>   
>   void
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
