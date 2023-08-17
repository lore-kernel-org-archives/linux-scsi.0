Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06D4C3DA58
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 18:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354571AbjHQSue (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 14:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354541AbjHQSuG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 14:50:06 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D359619E;
        Thu, 17 Aug 2023 11:50:04 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HD1aZb011489;
        Thu, 17 Aug 2023 18:49:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=XouDX/Vn29UXyshA54eg4v6ykt2/YSHpX91VcPSLbLE=;
 b=F1nWUnANh4ALcHCig6RY+iyL3qZCQtJwv3JAlbP6TRZqPjBJykF9TfGfrJ4+KBh9SXg1
 N7Ae0KLs5DCPEnrXndyFFkARw7Y8mzKFCqisYUfxX4LorRJpFA3JYNLn3wVFI/MTOKuw
 PKfO2C5+lswYa2z9hRpSp2CpUdz1HI5PqQUmkjHTiNdqt8KOvYVqfm2zHi/ja2GChSAf
 /aspjdWC9jwNkkoTrJbLhAHNm2fPxeNsbrIWGI0MiXX2fFtaPSLTKD6EywT1Y8p/DsCG
 2j+Va2tucWFA0u2dDgc/WQDxql4PPyyoex2otahcF38tpulr/y2WIYrVP4ypRAPJQg2D IQ== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sh2a3k3ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 18:49:43 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37HInf0a004405
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 18:49:41 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Thu, 17 Aug
 2023 11:49:41 -0700
Message-ID: <40508869-7cda-77f6-de98-6e41fce82c6a@quicinc.com>
Date:   Thu, 17 Aug 2023 11:49:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 14/17] scsi: ufs: Rename ufshcd_auto_hibern8_enable()
 and make it static
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Arthur Simchaev" <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-15-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230816195447.3703954-15-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: wXOxpqSqwoPp-W9Qq2Eap10EXKwbdCMe
X-Proofpoint-ORIG-GUID: wXOxpqSqwoPp-W9Qq2Eap10EXKwbdCMe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_14,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 clxscore=1011 impostorscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308170168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/16/2023 12:53 PM, Bart Van Assche wrote:
> Rename ufshcd_auto_hibern8_enable() into ufshcd_configure_auto_hibern8()
> since this function can enable or disable auto-hibernation. Since
> ufshcd_auto_hibern8_enable() is only used inside the UFSHCI driver core,
> declare it static. Additionally, move the definition of this function to
> just before its first caller.
> 
> Suggested-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 24 +++++++++++-------------
>   include/ufs/ufshcd.h      |  1 -
>   2 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 129446775796..f1bba459b46f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4337,6 +4337,14 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
>   
> +static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
> +{
> +	if (!ufshcd_is_auto_hibern8_supported(hba))
> +		return;
> +
> +	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +}
> +
>   void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   {
>   	unsigned long flags;
> @@ -4356,21 +4364,13 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
>   		ufshcd_rpm_get_sync(hba);
>   		ufshcd_hold(hba);
> -		ufshcd_auto_hibern8_enable(hba);
> +		ufshcd_configure_auto_hibern8(hba);
>   		ufshcd_release(hba);
>   		ufshcd_rpm_put_sync(hba);
>   	}
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
>   
> -void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
> -{
> -	if (!ufshcd_is_auto_hibern8_supported(hba))
> -		return;
> -
> -	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
> -}
> -
>    /**
>    * ufshcd_init_pwr_info - setting the POR (power on reset)
>    * values in hba power info
> @@ -8815,8 +8815,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>   
>   	if (hba->ee_usr_mask)
>   		ufshcd_write_ee_control(hba);
> -	/* Enable Auto-Hibernate if configured */
> -	ufshcd_auto_hibern8_enable(hba);
> +	ufshcd_configure_auto_hibern8(hba);
>   
>   	ufshpb_toggle_state(hba, HPB_RESET, HPB_PRESENT);
>   out:
> @@ -9809,8 +9808,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
>   	}
>   
> -	/* Enable Auto-Hibernate if configured */
> -	ufshcd_auto_hibern8_enable(hba);
> +	ufshcd_configure_auto_hibern8(hba);
Is it possible to have a race between sysfs and syspend/resume trying to 
update the auto_hibern8?

>   
>   	ufshpb_resume(hba);
>   	goto out;
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 6dc11fa0ebb1..040d66d99912 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1363,7 +1363,6 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
>   	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
>   }
>   
> -void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
>   void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
>   void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
>   			     const struct ufs_dev_quirk *fixups);

