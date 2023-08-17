Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C0AC3DA58
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 18:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352184AbjHQSks (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 14:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354541AbjHQSk2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 14:40:28 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA5030D4;
        Thu, 17 Aug 2023 11:40:27 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HDgcr1003956;
        Thu, 17 Aug 2023 18:40:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=8beUAYvVt+q73E7VB8BGUK84aeEF3fecJqSz3gMPZbM=;
 b=f8wN1NJPs9v5zmuNyrI3jWwSt7eVe8ih99yVQcYR0sajvx/GLMY/r5CVGCk6yUNWCq5u
 CVD0PuBAbYePuCfyE+E5bYjV9u116CxFnIznvmqa32bM7IeLrLuSaPHREApKj0gDfstQ
 92FjrwaQPtHWjNOjj08folon4B21ro+YLoy/HB5n6Z8cBpUhFVW1YqdfAGoFERWfCfso
 lwq7wzSuQEXDBM0PGQDr8dGw/zUy+36pX7eqr2eOFXFD79WVD23eGqS2PM4KmABYQWLn
 63XXDW1ELd8xSzzGZLpkuw/O2thtxVOcvQmXUFBvcp0e4SzUlpwWVG5BVOaZKaKzDBLT 8g== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sh3xxas4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 18:40:08 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37HIe8X1007501
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 18:40:08 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Thu, 17 Aug
 2023 11:40:07 -0700
Message-ID: <3b1caab8-c95e-eb81-57ef-21b746795ba6@quicinc.com>
Date:   Thu, 17 Aug 2023 11:40:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 12/17] scsi: ufs: mediatek: Rework the code for
 disabling auto-hibernation
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-13-bvanassche@acm.org>
Content-Language: en-US
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230816195447.3703954-13-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: ROd2cc_OXYpNHcdJUDgJ851jEobzE3m_
X-Proofpoint-ORIG-GUID: ROd2cc_OXYpNHcdJUDgJ851jEobzE3m_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_14,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308170168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/16/2023 12:53 PM, Bart Van Assche wrote:
> Call ufshcd_auto_hibern8_update() instead of writing directly into the
> auto-hibernation control register. This patch is part of an effort to
> move all auto-hibernation register changes into the UFSHCI driver core.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/host/ufs-mediatek.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> index e68b05976f9e..a3cf30e603ca 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1252,7 +1252,7 @@ static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
>   	int ret;
>   
>   	/* disable auto-hibern8 */
> -	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +	ufshcd_auto_hibern8_update(hba, 0);
Since you now use ufshcd_auto_hibern8_update(), the caller should not 
need to check for ufshcd_is_auto_hibern8_supported() because this is 
already part of the hibern8_update(). Suggest remove the if statement 
from the caller.

	if (ufshcd_is_auto_hibern8_supported(hba))
		ufs_mtk_auto_hibern8_disable(hba);

>   
>   	/* wait host return to idle state when auto-hibern8 off */
>   	ufs_mtk_wait_idle_state(hba, 5);

