Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9012CC04A6A
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Aug 2023 17:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjHLRJi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Aug 2023 13:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjHLRJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Aug 2023 13:09:36 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2DBE4D;
        Sat, 12 Aug 2023 10:09:39 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37CGvkCI015733;
        Sat, 12 Aug 2023 17:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=y4qMu+tOPB9jUwkslDFFhTp8GN1BoOS5dNysvFGFXFE=;
 b=jIQ8Mid0lxsUt/iZnt+kYmgcgVgMonOHq3iyn+TSw4MCjDgnF0ECrFIZhGigE/rmDJ1C
 /Idr+TpKDUecLWgWLpu8zRMfQ8huoTuzDSH1jUpc5YVN8UR56sCh/GbjJR9wqBaR3txG
 8eMwiB19uuKue4jKpJCigIY5qZb3BCkD+/Y1vxkmljsStpM9UT2wSB4f3KDBQ+3kMDM6
 TVScBVhHq+8PfmmAIByZF5/5m8hT72HA9uMWFB4zIeJoGWY8w42GVKqpLJtnYLkkm7Mn
 4uMy9ctWuxJG2p8RDpdGL9RTLrExTXaM529ng1E+hz2Rr/pY1CCwc/gF9yZhy+5Wijl+ Uw== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3se3srrnvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 12 Aug 2023 17:09:05 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37CH93C7008898
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 12 Aug 2023 17:09:03 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.30; Sat, 12 Aug
 2023 10:09:03 -0700
Message-ID: <668f296c-48f3-02ef-5ac1-30131579ea8d@quicinc.com>
Date:   Sat, 12 Aug 2023 10:09:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 9/9] scsi: ufs: Inform the block layer about write
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
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-10-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230811213604.548235-10-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: mOL7KIxEbyOB_LdvqjQzIRre4v0uAx7Q
X-Proofpoint-ORIG-GUID: mOL7KIxEbyOB_LdvqjQzIRre4v0uAx7Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-12_17,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 phishscore=0
 clxscore=1011 malwarescore=0 impostorscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308120161
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/11/2023 2:35 PM, Bart Van Assche wrote:
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
>   drivers/ufs/core/ufshcd.c | 35 ++++++++++++++++++++++++++++++++++-
>   1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ae7b868f9c26..71cee10c75ad 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4337,23 +4337,48 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
>   
> +static void ufshcd_update_preserves_write_order(struct ufs_hba *hba,
> +						bool preserves_write_order)
> +{
> +	struct scsi_device *sdev;
> +
> +	shost_for_each_device(sdev, hba->host)
> +		blk_freeze_queue_start(sdev->request_queue);
> +	shost_for_each_device(sdev, hba->host) {
> +		struct request_queue *q = sdev->request_queue;
> +
> +		blk_mq_freeze_queue_wait(q);
> +		q->limits.driver_preserves_write_order = preserves_write_order;
> +		blk_mq_unfreeze_queue(q);
> +	}
> +}
> +
>   void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   {
>   	unsigned long flags;
> -	bool update = false;
> +	bool prev_state, new_state, update = false;
>   
>   	if (!ufshcd_is_auto_hibern8_supported(hba))
>   		return;
>   
>   	spin_lock_irqsave(hba->host->host_lock, flags);
> +	prev_state = ufshcd_is_auto_hibern8_enabled(hba);
>   	if (hba->ahit != ahit) {
>   		hba->ahit = ahit;
>   		update = true;
>   	}
> +	new_state = ufshcd_is_auto_hibern8_enabled(hba);
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   
>   	if (!update)
>   		return;
> +	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
> +		/*
> +		 * Auto-hibernation will be enabled for legacy UFSHCI mode. Tell
> +		 * the block layer that write requests may be reordered.
> +		 */
> +		ufshcd_update_preserves_write_order(hba, false);
Hi Bart,
I am not reviewing other patches in this series, so I don't know the 
whole context. Here is my comment on this patch alone.

Looks like you rely on ufshcd_auto_hibern8_update() being invoked so 
that you can update the driver_preserves_write_order. However, the 
hba->ahit value can be updated by the vendor's driver, and 
ufshcd_auto_hibern8_enable() can be invoked without 
ufshcd_auto_hibern8_update(). Therefore, you may have a situation where 
the driver_preserves_write_order is true by default, but 
Auto-hibernation is enabled by default.

Thanks,
Bao

> +	}
>   	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
>   		ufshcd_rpm_get_sync(hba);
>   		ufshcd_hold(hba);
> @@ -4361,6 +4386,13 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   		ufshcd_release(hba);
>   		ufshcd_rpm_put_sync(hba);
>   	}
> +	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
> +		/*
> +		 * Auto-hibernation has been disabled. Tell the block layer that
> +		 * the order of write requests is preserved.
> +		 */
> +		ufshcd_update_preserves_write_order(hba, true);
> +	}
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
>   
> @@ -5140,6 +5172,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
>   
>   	ufshcd_hpb_configure(hba, sdev);
>   
> +	q->limits.driver_preserves_write_order = true;
>   	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
>   	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
>   		blk_queue_update_dma_alignment(q, SZ_4K - 1);

