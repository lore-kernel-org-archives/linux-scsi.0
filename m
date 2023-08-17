Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761F9C41513
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 19:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbjHQTAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 15:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbjHQTA0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 15:00:26 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB6D271B;
        Thu, 17 Aug 2023 12:00:24 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HGwgAJ027252;
        Thu, 17 Aug 2023 19:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=BjV3cf12olDHXyN2GAE4FQ6aa+FzD92lcHoWl+d3rWY=;
 b=CVkSi6kRs8xWr+X9CecBaJbrv5tI4Lye5k4uKsbABo0cQ2Kkg8+vgGKMr4cayyvCQ9Pd
 elO0azfjf3eh3Knr2j7FGXcEReOT/JZiQOI8STY7thHBVtZOXajtqMuPAxZUj8uMU1VH
 DTt4I/bXDXzgv6u53MaXYzG3495IjSrk317FBEstGiK91PxetJQGSqDamY+L8KPrxJR1
 2Diq8GPJTAxl8Gn8F/uuG2CUH1Qxn7swdAr4XuSs9UDcL3yqkSsJFlfeMFowaC7Z/FZG
 XeMIKvp7X7uTQfBDC/VlLLw05jIs6MBMiYgjiexa09t+lZcqu6bSaJyR0UtVbtmsW3Uu Ow== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sh0tnb8yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 19:00:05 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37HJ04i6020500
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 19:00:04 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Thu, 17 Aug
 2023 12:00:04 -0700
Message-ID: <666c6d78-d975-c9f9-4ad2-c9fa86497b47@quicinc.com>
Date:   Thu, 17 Aug 2023 12:00:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 17/17] scsi: ufs: Inform the block layer about write
 ordering
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
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo" <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Arthur Simchaev" <Arthur.Simchaev@wdc.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-18-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230816195447.3703954-18-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: hfV771GU3vEB4toKZ-HO3XNyPLQtPhxF
X-Proofpoint-ORIG-GUID: hfV771GU3vEB4toKZ-HO3XNyPLQtPhxF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_15,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308170170
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/16/2023 12:53 PM, Bart Van Assche wrote:
>  From the UFSHCI 4.0 specification, about the legacy (single queue) mode:
> "The host controller always process transfer requests in-order according
> to the order submitted to the list. In case of multiple commands with
> single doorbell register ringing (batch mode), The dispatch order for
> these transfer requests by host controller will base on their index in
> the List. A transfer request with lower index value will be executed
> before a transfer request with higher index value."
> 
>  From the UFSHCI 4.0 specification, about the MCQ mode:
> "Command Submission
> 1. Host SW writes an Entry to SQ
> 2. Host SW updates SQ doorbell tail pointer
> 
> Command Processing
> 3. After fetching the Entry, Host Controller updates SQ doorbell head
>     pointer
> 4. Host controller sends COMMAND UPIU to UFS device"
> 
> In other words, for both legacy and MCQ mode, UFS controllers are
> required to forward commands to the UFS device in the order these
> commands have been received from the host.
> 
> Notes:
> - For legacy mode this is only correct if the host submits one
>    command at a time. The UFS driver does this.
> - Also in legacy mode, the command order is not preserved if
>    auto-hibernation is enabled in the UFS controller. Hence, enable
>    zone write locking if auto-hibernation is enabled.
> 
> This patch improves performance as follows on my test setup:
> - With the mq-deadline scheduler: 2.5x more IOPS for small writes.
> - When not using an I/O scheduler compared to using mq-deadline with
>    zone locking: 4x more IOPS for small writes.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Can Guo <quic_cang@quicinc.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 22 ++++++++++++++++++++--
>   1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 37d430d20939..7f5049a66cca 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4356,6 +4356,19 @@ static int ufshcd_update_preserves_write_order(struct ufs_hba *hba,
>   				return -EPERM;
>   		}
>   	}
> +	shost_for_each_device(sdev, hba->host)
> +		blk_freeze_queue_start(sdev->request_queue);
> +	shost_for_each_device(sdev, hba->host) {
> +		struct request_queue *q = sdev->request_queue;
> +
> +		blk_mq_freeze_queue_wait(q);
> +		q->limits.driver_preserves_write_order = preserves_write_order;
> +		blk_queue_required_elevator_features(q,
> +			preserves_write_order ? 0 : ELEVATOR_F_ZBD_SEQ_WRITE);
> +		if (q->disk)
> +			disk_set_zoned(q->disk, q->limits.zoned);
> +		blk_mq_unfreeze_queue(q);
> +	}
>   
>   	return 0;
>   }
> @@ -4393,7 +4406,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   
>   	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
>   		/*
> -		 * Auto-hibernation will be enabled for legacy UFSHCI mode.
> +		 * Auto-hibernation will be enabled for legacy UFSHCI mode. Tell
> +		 * the block layer that write requests may be reordered.
>   		 */
>   		ret = ufshcd_update_preserves_write_order(hba, false);
>   		if (ret)
> @@ -4409,7 +4423,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   	}
>   	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
>   		/*
> -		 * Auto-hibernation has been disabled.
> +		 * Auto-hibernation has been disabled. Tell the block layer that
> +		 * the order of write requests is preserved.
>   		 */
>   		ret = ufshcd_update_preserves_write_order(hba, true);
>   		WARN_ON_ONCE(ret);
> @@ -5187,6 +5202,9 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
>   
>   	ufshcd_hpb_configure(hba, sdev);
>   
> +	q->limits.driver_preserves_write_order =
> +		!ufshcd_is_auto_hibern8_supported(hba) ||
> +		FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;
In legacy SDB mode with auto-hibernation enabled, the default setting 
for the driver_preserves_write_order = false.

Using the default setting, it may be missing this check that is part of 
the ufshcd_auto_hibern8_update()->ufshcd_update_preserves_write_order().

Auto-hibernation should not be enabled by default unless these 
conditions are met?
	if (blk_queue_is_zoned(q) && !q->elevator)
		return -EPERM;


>   	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
>   	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
>   		blk_queue_update_dma_alignment(q, SZ_4K - 1);

