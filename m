Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F2DC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A604A206F6
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZL+CJEGt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgC0OSe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 10:18:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49918 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgC0OSe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 10:18:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02REDwaW107556;
        Fri, 27 Mar 2020 14:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4KgEs8UjLqPT3GD+5GEYeW48/6ihqbCo7ryzTiVRp9U=;
 b=ZL+CJEGthkDI4761pIFk9RKh9rI+6WS0qMgOSfwiUbt5sL3XUlDpSXqol7LBEIRNU8Wk
 LbUJJZI8MLrO91a8cCFEesYewGAjOiyDlOY3PforliTCoZ4vO+2oAOs99MxmtJ+8CuEi
 7SV/s0ieQcsT2MjvGsZdUBai5oGkz0agmKIKpXBhWb3eLIFd0Y/UUopstb26sPFfrPHr
 OaZkddvsTQsPbXgWTo8nsDprFJ8iwBZOeJv0mOBvVl3mafxGM3XKgsGrQoe4dkXy//ZH
 53Igv296VN7VGzXosnNEuFbyMXrD32gtySk8OixRp1Axoq8LKbqFETGj1y0PfdTDl+po uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ywavmnkx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 14:18:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02REHlxA155359;
        Fri, 27 Mar 2020 14:18:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3003gp1u1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 14:18:28 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02REIRg3020728;
        Fri, 27 Mar 2020 14:18:27 GMT
Received: from [192.168.1.16] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 07:18:26 -0700
Subject: Re: [PATCH 2/3] qla2xxx: Fix hang when issuing nvme disconnect-all in
 NPIV.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        emilne@redhat.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200327102730.22351-1-njavali@marvell.com>
 <20200327102730.22351-3-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <0b5a3baf-50ec-d188-5eb2-07c1c48c1f60@oracle.com>
Date:   Fri, 27 Mar 2020 09:18:23 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200327102730.22351-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270131
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/27/2020 5:27 AM, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> In NPIV environment, a NPIV host may use a queue pair created
> by base host or other NPIVs, so the check for a queue pair
> created by this NPIV is not correct, and can cause an abort
> to fail, which in turn means the NVME command not returned.
> This leads to hang in nvme_fc layer in nvme_fc_delete_association()
> which waits for all I/Os to be returned, which is seen as hang
> in the application.
> 
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 9fd83d1bffe0..7cefe35d61d1 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -3153,7 +3153,7 @@ qla24xx_abort_command(srb_t *sp)
>   	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
>   	    "Entered %s.\n", __func__);
>   
> -	if (vha->flags.qpairs_available && sp->qpair)
> +	if (sp->qpair)
>   		req = sp->qpair->req;
>   	else
>   		return QLA_FUNCTION_FAILED;
> 
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
