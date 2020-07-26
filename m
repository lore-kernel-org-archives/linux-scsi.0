Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FB5C433E3
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 05:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5428204EA
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 05:32:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f/GqM9Io"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgGZFcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 01:32:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39142 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgGZFcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2020 01:32:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06Q5Voua088225;
        Sun, 26 Jul 2020 05:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=J7pPDARrUog4278JGhIp+msnFU3gN7fV+/j9AiHsv/Y=;
 b=f/GqM9IoJbiKVqHcsnJglOSdGuCC4/FR8ed/z7pcMTR5cfoudus+U68NdlEH2jylGbTf
 MwJsUh3lwjDrx7bWwyqBtQrWl8FJCFefJcerNPh5fvKkbP7dLraknCWcocegRHjNyb2y
 tssTwiI7yDcC4AG8mT2wdowbZqJS9mvxmWVKdQbI06KQUfImrVvSJaYEjO6OmcODCcmZ
 KD5sp43lEg5o2vX+m9ujS4mb/ENOkQmeHQSQ/RwProgxXRpDxZU4Ym6Co+yYAvam2lCk
 Fa25qC0YqsYrRo3Ep0lo5arYi2SZvL0POaIgneO4M0AsUv627uSps2ci5z6GH+Z505N8 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32gx46gd15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 26 Jul 2020 05:31:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06Q5SZik062479;
        Sun, 26 Jul 2020 05:31:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32gxajg22e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jul 2020 05:31:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06Q5VjL3029569;
        Sun, 26 Jul 2020 05:31:46 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 22:31:45 -0700
Subject: Re: [PATCH] scsi: iscsi: Do not put host in
 iscsi_set_flashnode_param()
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>, lduncan@suse.com,
        cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20200615081226.183068-1-jingxiangfeng@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <30b2622a-a04b-6b17-c50a-e6920be359ae@oracle.com>
Date:   Sun, 26 Jul 2020 00:31:44 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200615081226.183068-1-jingxiangfeng@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007260042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1011 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007260043
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/15/20 3:12 AM, Jing Xiangfeng wrote:
> If scsi_host_lookup() failes we will jump to put_host, which may
> cause panic. Jump to exit_set_fnode to fix it.
> 
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index f4cc08e..c5e99f9 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -3291,7 +3291,7 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
>  		pr_err("%s could not find host no %u\n",
>  		       __func__, ev->u.set_flashnode.host_no);
>  		err = -ENODEV;
> -		goto put_host;
> +		goto exit_set_fnode;
>  	}
>  
>  	idx = ev->u.set_flashnode.flashnode_idx;
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
