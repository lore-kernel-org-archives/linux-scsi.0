Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F79CEE49A5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 05:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbjHUFgF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 01:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbjHUFgE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 01:36:04 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D50DA7;
        Sun, 20 Aug 2023 22:36:02 -0700 (PDT)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37L5UqeT016155;
        Mon, 21 Aug 2023 05:35:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=TBheZIJBiI/yL7dDpUB7ykSr4aSuQb5EUd2UhnPeYQQ=;
 b=MgAj4Inz0X8cyWzsZT2IFHfijgAGp/yAx8Vm2LvR5jWsZpuhZG0Hr/d/6K5mNQXdd0L6
 nDE3CLTBvdqPv5hMe1qsBvO/Atima/OKM/SrBu3/6fVOEVCit5CDgdI0OQe+Uxvx/+wc
 qOh0E8waamj64WHUkk2Dc/f2TbT8nR5grOu0hEGMpZT31uB8KPyI+yh6skjH/UFcWRJl
 nYWVwbPRVS1QMV8f0nLmmFL86vyReLiq6QiSv3iz9Mw/AqjGNw1/rPhfV6F+09A+8hik
 gK3BeL+HzYJxapdO+JBcjouyu0qoT9IJYoVgoAmoWEru7wUcYYHkdhvX7YefJLI6+Y5S UA== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sjp4danxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Aug 2023 05:35:52 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37L5ZpOC008048
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Aug 2023 05:35:51 GMT
Received: from [10.253.34.146] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Sun, 20 Aug
 2023 22:35:48 -0700
Message-ID: <e4a29562-ba76-1e94-f950-8c18d991bb58@quicinc.com>
Date:   Mon, 21 Aug 2023 13:35:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 16/18] scsi: ufs: Simplify
 ufshcd_auto_hibern8_update()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-17-bvanassche@acm.org>
From:   Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20230818193546.2014874-17-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: oW111wLrLHLCq_XD0H_0avt23Fm3DwDV
X-Proofpoint-ORIG-GUID: oW111wLrLHLCq_XD0H_0avt23Fm3DwDV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-20_15,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210051
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 8/19/2023 3:34 AM, Bart Van Assche wrote:
> Calls to ufshcd_auto_hibern8_update() are already serialized: this
> function is either called if user space software is not running
> (preparing to suspend) or from a single sysfs store callback function.
> Kernfs serializes sysfs .store() callbacks.
>
> No functionality is changed. This patch makes the next patch in this
> series easier to read.
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Can Guo <quic_cang@quicinc.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 16 ++++------------
>   1 file changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index a08924972b20..68bf8e94eee6 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4347,21 +4347,13 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
>   
>   int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   {
> -	unsigned long flags;
> -	bool update = false;
> +	const u32 cur_ahit = READ_ONCE(hba->ahit);
>   
> -	if (!ufshcd_is_auto_hibern8_supported(hba))
> +	if (!ufshcd_is_auto_hibern8_supported(hba) || cur_ahit == ahit)
>   		return 0;
>   
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> -	if (hba->ahit != ahit) {
> -		hba->ahit = ahit;
> -		update = true;
> -	}
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -
> -	if (update &&
> -	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
> +	WRITE_ONCE(hba->ahit, ahit);
> +	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
>   		ufshcd_rpm_get_sync(hba);
>   		ufshcd_hold(hba);
>   		ufshcd_configure_auto_hibern8(hba);

Reviewed-by: Can Guo <quic_cang@quicinc.com>

