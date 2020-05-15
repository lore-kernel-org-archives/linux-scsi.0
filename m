Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62AFFC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 22:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BBCB20657
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 22:55:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="mHs9kD+c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgEOWzk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 18:55:40 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36824 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgEOWzk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 18:55:40 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D4D0F4C850;
        Fri, 15 May 2020 22:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1589583335;
         x=1591397736; bh=8zYJiv4vZLcNZjXhBR8Ykv4NkAFHrpm9MUG4hG8RjvM=; b=
        mHs9kD+cxLgT0pNdfuHoYuHEnc3c9xjbvWA2XegYbep5Tt5hVDRQftxgbtHV8nfQ
        peFpvtn9Bt9jRfBYq31wD3NuDUlGt39xic1+dDWsCywel85lfcepHQEJ3RzkYIMt
        qd5zfx4yNzFO8QKbrg2EEn/R3PWaBH6T/b7uWgVLR2o=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 969X2bD-7-kw; Sat, 16 May 2020 01:55:35 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 6F3844C845;
        Sat, 16 May 2020 01:55:34 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sat, 16
 May 2020 01:55:36 +0300
Date:   Sat, 16 May 2020 01:55:35 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v6 13/15] qla2xxx: Use make_handle() instead of
 open-coding it
Message-ID: <20200515225535.GG98158@SPB-NB-133.local>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-14-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200514213516.25461-14-bvanassche@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 14, 2020 at 02:35:14PM -0700, Bart Van Assche wrote:
> Cc: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 87d0f5e4d81a..0a9a838c7f20 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -819,7 +819,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
>  		goto skip_rio;
>  	switch (mb[0]) {
>  	case MBA_SCSI_COMPLETION:
> -		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
> +		handles[0] = le32_to_cpu(make_handle(mb[2], mb[1]));
>  		handle_cnt = 1;
>  		break;
>  	case MBA_CMPLT_1_16BIT:
> @@ -858,10 +858,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
>  		mb[0] = MBA_SCSI_COMPLETION;
>  		break;
>  	case MBA_CMPLT_2_32BIT:
> -		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
> -		handles[1] = le32_to_cpu(
> -		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 7) << 16)) |
> -		    RD_MAILBOX_REG(ha, reg, 6));
> +		handles[0] = le32_to_cpu(make_handle(mb[2], mb[1]));
> +		handles[1] =
> +			le32_to_cpu(make_handle(RD_MAILBOX_REG(ha, reg, 7),
> +						RD_MAILBOX_REG(ha, reg, 6)));
>  		handle_cnt = 2;
>  		mb[0] = MBA_SCSI_COMPLETION;
>  		break;

Hi Bart,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
