Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5DAC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 15:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D93B206D8
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 15:58:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zyE9jEus"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgEOP6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 11:58:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49300 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgEOP6s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 11:58:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FFuffA003080;
        Fri, 15 May 2020 15:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=20g0MCDrlNSmh25br36wvUHSIWMrJeayERhp1X2DqzU=;
 b=zyE9jEusccrmP4o4HyiSfRbiO/v5rg1by0la4m+wpTxQSOUZR+axOUp33F7lEk5tVZHK
 jNXLM1sYgggxF68FhoGNak531xHGAjDESvxsbO7RVoVUg2kGU5y4Ez96d8HFFSmQYgKP
 EDNPF3hryTYT64Pgr9KjimD61EsqTd7nTpMGlse9Y9oUwAkTLSnTO4GzEsjG63imDSQY
 /kBMkYcGNEfovmeQhR6mzrqND91lMWjnMHDzyjhptfb2WUtwhSCMi+homXDZUpRro8w7
 kNTnVAlI9YXN5xH8RdNa27qLsw0LGxRnQFaiXkTcIyK9yg0WF1msj+sB6/JLuweOH1ox gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3100ygc6nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 15:58:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FFwCDp148791;
        Fri, 15 May 2020 15:58:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3100yk8yjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 15:58:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04FFwT9V025064;
        Fri, 15 May 2020 15:58:29 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 08:58:29 -0700
Subject: Re: [PATCH v6 13/15] qla2xxx: Use make_handle() instead of
 open-coding it
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-14-bvanassche@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <45058350-90d9-92f6-3171-9cb73f0d4d51@oracle.com>
Date:   Fri, 15 May 2020 10:58:27 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514213516.25461-14-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150136
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/14/20 4:35 PM, Bart Van Assche wrote:
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

Looks fine.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
