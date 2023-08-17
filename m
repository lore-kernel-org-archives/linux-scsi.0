Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4DEC41513
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 18:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244159AbjHQSvi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 14:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354617AbjHQSvL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 14:51:11 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949AC30D6;
        Thu, 17 Aug 2023 11:51:09 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HD1V8h027949;
        Thu, 17 Aug 2023 18:50:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=T0kYjPOfuaookUrvpIX+GEbpRGal2KC+1BcMR6eZ8nM=;
 b=DRIzsVUYRsQtUKy32xtv7FpYxjh8G61/lq2qHQXd9eMgTDNsTN09E2T0clVyK4hCLvAv
 Z9dK1ArEEcokSucCNWceYFnAxwoedMr08soHT2vVh9VJtRD/DNGfCpLNdAN1zBIK31Kl
 mOmaDN1PgwxSctlk/R8ah7PIcRaVB22VsmNx0MLDIM7NWG4th7eWhr19NBUnzxfDuQPm
 inNlN3+sSn1gC4m2XwJgr/P38Tot/3Ha23qTqKRiMB7dKx3OSfhDDcqoHvcKbPRVpDeA
 2cEdm53MgwNKwE6IatV2lM7jpP2OYLl8vcqIU6Ch/CNu9W88qUhy/ru9icWDpN6eZ0ol fw== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sh3xxasme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 18:50:37 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37HIoaqY007777
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 18:50:36 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Thu, 17 Aug
 2023 11:50:35 -0700
Message-ID: <2a2bdb27-86a5-fcba-051d-4b37d7c4edbd@quicinc.com>
Date:   Thu, 17 Aug 2023 11:50:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 16/17] scsi: ufs: Forbid auto-hibernation without I/O
 scheduler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Can Guo" <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Damien Le Moal" <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "Asutosh Das" <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        zhanghui <zhanghui31@xiaomi.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        "Eric Biggers" <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-17-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230816195447.3703954-17-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: O7yPZFvxYth2YhULwOQpdkc81s2yX52x
X-Proofpoint-ORIG-GUID: O7yPZFvxYth2YhULwOQpdkc81s2yX52x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_15,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308170170
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/16/2023 12:53 PM, Bart Van Assche wrote:
> UFSHCI 3.0 controllers do not preserve the write order if auto-hibernation
> is enabled. If the write order is not preserved, an I/O scheduler is
> required to serialize zoned writes. Hence do not allow auto-hibernation
> to be enabled without I/O scheduler if a zoned logical unit is present
> and if the controller is operating in legacy mode. This patch has been
> tested with the following shell script:
> 
>      show_ah8() {
>          echo -n "auto_hibern8: "
>          adb shell "cat /sys/devices/platform/13200000.ufs/auto_hibern8"
>      }
> 
>      set_ah8() {
>          local rc
>          adb shell "echo $1 > /sys/devices/platform/13200000.ufs/auto_hibern8"
>          rc=$?
>          show_ah8
>          return $rc
>      }
> 
>      set_iosched() {
>          adb shell "echo $1 >/sys/class/block/$zoned_bdev/queue/scheduler &&
>      	           echo -n 'I/O scheduler: ' &&
> 	           cat /sys/class/block/sde/queue/scheduler"
>      }
> 
>      adb root
>      zoned_bdev=$(adb shell grep -lvw 0 /sys/class/block/sd*/queue/chunk_sectors |&
> 	         sed 's|/sys/class/block/||g;s|/queue/chunk_sectors||g')
>      [ -n "$zoned_bdev" ]
>      show_ah8
>      set_ah8 0
>      set_iosched none
>      if set_ah8 150000; then
>          echo "Error: enabled AH8 without I/O scheduler"
>      fi
>      set_iosched mq-deadline
>      set_ah8 150000
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Can Guo <quic_cang@quicinc.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufs-sysfs.c   |  2 +-
>   drivers/ufs/core/ufshcd-priv.h |  1 -
>   drivers/ufs/core/ufshcd.c      | 60 ++++++++++++++++++++++++++++++++--
>   include/ufs/ufshcd.h           |  2 +-
>   4 files changed, 60 insertions(+), 5 deletions(-)
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
>   	up(&hba->host_sem);
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index 0f3bd943b58b..a2b74fbc2056 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -60,7 +60,6 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
>   		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
>   int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
>   	enum flag_idn idn, u8 index, bool *flag_res);
> -void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
>   void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>   			  struct cq_entry *cqe);
>   int ufshcd_mcq_init(struct ufs_hba *hba);
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 39000c018d8b..37d430d20939 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4337,6 +4337,29 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
>   
> +static int ufshcd_update_preserves_write_order(struct ufs_hba *hba,
> +						bool preserves_write_order)
> +{
> +	struct scsi_device *sdev;
> +
> +	if (!preserves_write_order) {
> +		shost_for_each_device(sdev, hba->host) {
> +			struct request_queue *q = sdev->request_queue;
> +
> +			/*
> +			 * This code does not check whether the attached I/O
> +			 * scheduler serializes zoned writes
> +			 * (ELEVATOR_F_ZBD_SEQ_WRITE) because this cannot be
> +			 * checked from outside the block layer core.
> +			 */
> +			if (blk_queue_is_zoned(q) && !q->elevator)
> +				return -EPERM;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>   static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
>   {
>   	if (!ufshcd_is_auto_hibern8_supported(hba))
> @@ -4345,13 +4368,37 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
>   	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
>   }
>   
> -void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
> +/**
> + * ufshcd_auto_hibern8_update() - Modify the auto-hibernation control register
> + * @hba: per-adapter instance
> + * @ahit: New auto-hibernate settings. Includes the scale and the value of the
> + * auto-hibernation timer. See also the UFSHCI_AHIBERN8_TIMER_MASK and
> + * UFSHCI_AHIBERN8_SCALE_MASK constants.
> + *
> + * Note: enabling auto-hibernation if a zoned logical unit is present without
> + * attaching the mq-deadline scheduler first to the zoned logical unit may cause
> + * unaligned write errors for the zoned logical unit.
> + */
Please improve this "Note:". It seems like a run-on sentence and not 
very clear.


> +int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   {
>   	const u32 cur_ahit = READ_ONCE(hba->ahit);
> +	bool prev_state, new_state;
> +	int ret;
>   
>   	if (!ufshcd_is_auto_hibern8_supported(hba) || cur_ahit == ahit)
> -		return;
> +		return 0;
>   
> +	prev_state = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, cur_ahit);
> +	new_state = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, ahit);
> +
> +	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
> +		/*
> +		 * Auto-hibernation will be enabled for legacy UFSHCI mode.
> +		 */
> +		ret = ufshcd_update_preserves_write_order(hba, false);
> +		if (ret)
> +			return ret;
> +	}
>   	WRITE_ONCE(hba->ahit, ahit);
>   	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
>   		ufshcd_rpm_get_sync(hba);
> @@ -4360,6 +4407,15 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   		ufshcd_release(hba);
>   		ufshcd_rpm_put_sync(hba);
>   	}
> +	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
> +		/*
> +		 * Auto-hibernation has been disabled.
> +		 */
> +		ret = ufshcd_update_preserves_write_order(hba, true);
> +		WARN_ON_ONCE(ret);
> +	}
> +
> +	return 0;
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
>   
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 040d66d99912..7ae071a6811c 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1363,7 +1363,7 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
>   	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
>   }
>   
> -void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
> +int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
>   void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
>   			     const struct ufs_dev_quirk *fixups);
>   #define SD_ASCII_STD true

