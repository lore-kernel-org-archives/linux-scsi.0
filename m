Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFF6EE4996
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 05:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbjHUFcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 01:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbjHUFcQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 01:32:16 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB29CA6;
        Sun, 20 Aug 2023 22:32:11 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37L5LbpD019203;
        Mon, 21 Aug 2023 05:31:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=ks7BlhSDzyxYb5voeOdaDvlPc/UZIwDWK8UKz2XmTTc=;
 b=aPabMcbR2F7kF8Alx8azdaf8xVUpjNrvbswIyNdYjks6CyVCN7lIgVc/SwagSIC0lDeP
 44QVF9Dl/lPWNeNmW2irzH1SpVN02WGjgLuIjYSKkHu0JoyKPRATsr+o37VNVkKOpBzf
 BQ9zsP18xu3MGT95LiJo4I/YsnR9Cvefh+IWWQAuYVSnv4eXAINQfREqN9VbE2fZGF9S
 /FOlKI8Bw4V2zZj/FEBAWNTHyjqOm5bQLT599rcnDFcUVMKGTaowasSf/c1zhV/eN2nu
 GRY/ua4JSd2L0iCsOMZnrQ3mUwdxA9CECJ64/eF+STEWzwm252826UZq43LX/GZSXHaX Lg== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sjn2rapmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Aug 2023 05:31:17 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37L5VFuL003028
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Aug 2023 05:31:15 GMT
Received: from [10.253.34.146] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Sun, 20 Aug
 2023 22:31:11 -0700
Message-ID: <ac21eb11-8588-8e0b-2eca-d59593712a82@quicinc.com>
Date:   Mon, 21 Aug 2023 13:30:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 11/18] scsi: ufs: Change the return type of
 ufshcd_auto_hibern8_update()
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Manivannan Sadhasivam" <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Arthur Simchaev" <arthur.simchaev@wdc.com>,
        zhanghui <zhanghui31@xiaomi.com>,
        "Po-Wen Kao" <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        "Keoseong Park" <keosung.park@samsung.com>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-12-bvanassche@acm.org>
Content-Language: en-US
From:   Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20230818193546.2014874-12-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: tk-ddMVT0Rx2OOObaxjHZydHu6cOFYx0
X-Proofpoint-ORIG-GUID: tk-ddMVT0Rx2OOObaxjHZydHu6cOFYx0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-20_15,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308210051
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 8/19/2023 3:34 AM, Bart Van Assche wrote:
> A later patch will introduce an error path in ufshcd_auto_hibern8_update().
> Change the return type of that function before introducing calls to that
> function in the host drivers such that the host drivers only have to be
> modified once.
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Can Guo <quic_cang@quicinc.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufs-sysfs.c   | 2 +-
>   drivers/ufs/core/ufshcd-priv.h | 1 -
>   drivers/ufs/core/ufshcd.c      | 6 ++++--
>   include/ufs/ufshcd.h           | 2 +-
>   4 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 6c72075750dd..a693dea1bd18 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -203,7 +203,7 @@ static ssize_t auto_hibern8_store(struct device *dev,
>   		goto out;
>   	}
>   
> -	ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
> +	ret = ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
>   
>   out:

Reviewed-by: Can Guo <quic_cang@quicinc.com>

