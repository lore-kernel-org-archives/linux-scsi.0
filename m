Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EE0C77B75
	for <linux-scsi@archiver.kernel.org>; Fri,  5 May 2023 18:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbjEESph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 May 2023 14:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbjEESpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2023 14:45:34 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314C8203EF
        for <linux-scsi@vger.kernel.org>; Fri,  5 May 2023 11:45:33 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 345HUH8U022945;
        Fri, 5 May 2023 18:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=+5piykjxw/NFI8/Te3bXaz7b02hG/o1QJcEiJXRUnhM=;
 b=Mnl3FM7E8S0gksWFfg0uLk1tvIncrkVle+xKovo6mKP9QiraJBFyyIS98vcV49KULz63
 VF57s6QW6P2DuUpj2+S0XpqfbFmHO6wXPJ9V5Za9h6ql0MhX03Zny2tZqCM9rmQbmhYe
 XHsVtKX7dKayESPGRq7kpbNfpKF21uLq9oqiBjwuQo8DZfUf5bL0njvWuBcnSfMI43iX
 4ABFKjzBIV3la/JA8Q/cmqWi6TrwFPRaBmOWdTetahBxHjgnvXPOQ+tKKd94RtvojxT9
 RUELFNMHLwyxo2BQMMAbSnZMKtKT0e7F0kXzsxgp0BknZOcPRpcr8w8wMlN/R82nOOdc Xg== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qcb24bxgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 May 2023 18:40:14 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 345IeDh9001923
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 5 May 2023 18:40:13 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Fri, 5 May 2023
 11:40:13 -0700
Message-ID: <990e73a9-b42f-6d13-59a4-ac84edadd602@quicinc.com>
Date:   Fri, 5 May 2023 11:40:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 4/5] scsi: ufs: core: Unexport ufshcd_hold() and
 ufshcd_release()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Can Guo" <quic_cang@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230504235052.4423-1-bvanassche@acm.org>
 <20230504235052.4423-5-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230504235052.4423-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: v2cmsZljJbHS9NX1AwQyXlz4M1pFORQU
X-Proofpoint-ORIG-GUID: v2cmsZljJbHS9NX1AwQyXlz4M1pFORQU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-05_25,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 clxscore=1011 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305050153
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/2023 4:50 PM, Bart Van Assche wrote:
> Unexport these functions since these are only used by the UFS core.
Hi Bart,
Qualcomm uses these ufshcd_hold() and ufshcd_release() functions in 
ufs-qcom.c. I am going to post Qualcomm's change soon.

Thanks,
Bao

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 2 --
>   include/ufs/ufshcd.h      | 3 ---
>   2 files changed, 5 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index a1bce9c6aee5..54f91d7d0192 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1847,7 +1847,6 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>   out:
>   	return rc;
>   }
> -EXPORT_SYMBOL_GPL(ufshcd_hold);
>   
>   static void ufshcd_gate_work(struct work_struct *work)
>   {
> @@ -1950,7 +1949,6 @@ void ufshcd_release(struct ufs_hba *hba)
>   	__ufshcd_release(hba);
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   }
> -EXPORT_SYMBOL_GPL(ufshcd_release);
>   
>   static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
>   		struct device_attribute *attr, char *buf)
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index d6da1efb0212..13824462452d 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1358,9 +1358,6 @@ void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
>   int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
>   			    u8 **buf, bool ascii);
>   
> -int ufshcd_hold(struct ufs_hba *hba, bool async);
> -void ufshcd_release(struct ufs_hba *hba);
> -
>   void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
>   
>   u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);

