Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="kb6mi/gg"
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8E6138;
	Mon, 27 Nov 2023 17:45:43 -0800 (PST)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AS0LvBj022987;
	Tue, 28 Nov 2023 01:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=C2Wl7JccyRML31I3nvG8w7R3JFTxcqsSNH4FDHN2a7k=;
 b=kb6mi/ggt4rvFblpBVMl6Lc7ZUR1kFRnvLCnDP/NU4Q+CuZpuwW0RU/Y3qf1smVinj+v
 mDKwbVHac+fxA1TecISO2LP/nkD3jCnpwNs+QBUrnCFI1T2h+rXdfI5jgsTpZ2vihNQ9
 it4M2Wm6FsNECoj+Han6bGcDgQ8k35BFAJ10CVqnN+UlArOLPbO6RhhU7ivfhmCDxSJx
 YCOCJbpJOl0yGTulOmh5uW5kWmMo/VBACXA9Gg27nCi8qP3tc0okZGhmtrBlhvvsyHpt
 Hrv+L8cD3oz2DG/Wk7niHMGlY9Z3S97BvT+9/mFFq54t1/GTmO5PWGq8r6N5vCu9ef0M tw== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3un586r5du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Nov 2023 01:45:23 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3AS1jMtr030650
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Nov 2023 01:45:22 GMT
Received: from [10.253.11.37] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Mon, 27 Nov
 2023 17:45:18 -0800
Message-ID: <ea3b4046-2fe8-4fac-b170-9298f2266cda@quicinc.com>
Date: Tue, 28 Nov 2023 09:45:16 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 19/19] scsi: ufs: Inform the block layer about write
 ordering
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>,
        Jens Axboe
	<axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Bao D . Nguyen"
	<quic_nguyenb@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J.
 Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das
	<quic_asutoshd@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean Huo
	<beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20231114211804.1449162-1-bvanassche@acm.org>
 <20231114211804.1449162-20-bvanassche@acm.org>
Content-Language: en-US
From: Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20231114211804.1449162-20-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: fPzRfwNYfEVkMHkYpROV8cTdW4DV5TjY
X-Proofpoint-GUID: fPzRfwNYfEVkMHkYpROV8cTdW4DV5TjY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-28_01,2023-11-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 impostorscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 clxscore=1011
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311280011

Hi Bart,

On 11/15/2023 5:16 AM, Bart Van Assche wrote:
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
> Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Reviewed-by: Can Guo <quic_cang@quicinc.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 25 +++++++++++++++++++++++--
>   1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 732509289165..e78954cda3ae 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4421,6 +4421,20 @@ static int ufshcd_update_preserves_write_order(struct ufs_hba *hba,
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
> +			!preserves_write_order && blk_queue_is_zoned(q) ?
> +			ELEVATOR_F_ZBD_SEQ_WRITE : 0);
> +		if (q->disk)
> +			disk_set_zoned(q->disk, q->limits.zoned);
> +		blk_mq_unfreeze_queue(q);
> +	}
>   
>   	return 0;
>   }
> @@ -4463,7 +4477,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   
>   	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
>   		/*
> -		 * Auto-hibernation will be enabled for legacy UFSHCI mode.
> +		 * Auto-hibernation will be enabled for legacy UFSHCI mode. Tell
> +		 * the block layer that write requests may be reordered.
>   		 */
>   		ret = ufshcd_update_preserves_write_order(hba, false);
>   		if (ret)
> @@ -4479,7 +4494,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   	}
>   	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
>   		/*
> -		 * Auto-hibernation has been disabled.
> +		 * Auto-hibernation has been disabled. Tell the block layer that
> +		 * the order of write requests is preserved.
>   		 */
>   		ret = ufshcd_update_preserves_write_order(hba, true);
>   		WARN_ON_ONCE(ret);
> @@ -5247,6 +5263,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
>   	struct ufs_hba *hba = shost_priv(sdev->host);
>   	struct request_queue *q = sdev->request_queue;
>   
> +	q->limits.driver_preserves_write_order =
> +		!ufshcd_is_auto_hibern8_supported(hba) ||
> +		FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;
> +

I got some time testing these changes on SM8650 with MCQ enabled. I 
found that with these changes in place (with AH8 disabled). Even we can 
make sure UFS driver does not re-order requests in MCQ mode, the reorder 
is still happening while running FIO and can be seen from ftrace logs. I 
think it is related with below logic in blk-mq-sched.c, please correct 
me if I am wrong.

static int __blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
{
...
	} else if (multi_hctxs) {
		/*
		 * Requests from different hctx may be dequeued from some
		 * schedulers, such as bfq and deadline.
		 *
		 * Sort the requests in the list according to their hctx,
		 * dispatch batching requests from same hctx at a time.
		 */
		list_sort(NULL, &rq_list, sched_rq_cmp);
...
}

Thanks,
Can Guo.

>   	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
>   
>   	/*
> @@ -9026,6 +9046,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
>   	.max_host_blocked	= 1,
>   	.track_queue_depth	= 1,
>   	.skip_settle_delay	= 1,
> +	.needs_prepare_resubmit	= 1,
>   	.sdev_groups		= ufshcd_driver_groups,
>   	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
>   };
