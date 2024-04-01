Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EF68F6E
	for <linux-scsi@vger.kernel.org>; Mon,  1 Apr 2024 07:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711955414; cv=none; b=FTvfw22bzOfYQcRDEahA1O3VAqKlNSfPXoQd9D7TQE0ioJTBpiKJi1l5Xg+zJBJm+BlX/asRCOpE+TS6zi19Cac7jGHyCO2WAvDhTIKR27r5o+vBaY3fkpCTTDuJwDaiLpR+CZ7g6EU4uG8IZhLwfTd1NLq7kj+ns+F00JOeBNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711955414; c=relaxed/simple;
	bh=u2+BXqgkfpuxSzfmzKH05RKJXdCUhwIlr9UKjLKAx48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nyVsITWunvWSrSG1Iwu7ZAAxgRME7KaOtxNl2FPCGD9KDB9Iu3MJvDWNNUVqHKOXgxjQgoC68QqK3wGG25a+v1YJOHtD4Rzdy9O35vFz7lC11zGooBy7z1Ww4E3caQLboXOnhFODfuvxAq87vR8FyLhGR0c92Ds76RYmVOdZ6aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPZfbBQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPZfbBQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9467C433F1;
	Mon,  1 Apr 2024 07:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711955412;
	bh=u2+BXqgkfpuxSzfmzKH05RKJXdCUhwIlr9UKjLKAx48=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IPZfbBQ3dNisMOmYFVx02YXwAzwFsFJ9cBq/YhW99ehZHFD5IKj4Ckwn1f7cDaSKB
	 2POl/DSVepDft79GlzKb36Oi6/9PHxOSgTMGDX+YLPXuwogSI83MEZUz4cIpWkR265
	 tzahclOmut3ZSum4nUxyveJsQrZhk4GX7WjbvAc+6DVGS/ONFOqd8+uSZWc19jLLQK
	 a7joKs4w9EKGzCnh7tHRS3xlf6eAmB0eari16EgjFMbI6nGRD6lHrRcjoTxVffb80W
	 dn8+HFUXVy5efz4IwS0w6go+aRvKhRhqJ6pMLuhFlX7hX9BvuXLSRiPsrbpK5k3uRk
	 po+OrukvQ7avA==
Message-ID: <415f65a7-ffaf-42a2-a1b5-6182ccc3c3cd@kernel.org>
Date: Mon, 1 Apr 2024 16:10:10 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: hisi_sas: Handle the NCQ error returned by D2H
 frame
To: chenxiang <chenxiang66@hisilicon.com>, jejb@linux.vnet.ibm.com,
 martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org
References: <20240401054914.721093-1-chenxiang66@hisilicon.com>
 <20240401054914.721093-2-chenxiang66@hisilicon.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240401054914.721093-2-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/24 14:49, chenxiang wrote:
> From: Xingui Yang <yangxingui@huawei.com>
> 
> We find that some disks use D2H frame instead of SDB frame to return NCQ
> error. Currently, only the I/O corresponding to the D2H frame is processed
> in this scenario, which does not meet the processing requirements of the
> NCQ error scenario.
> So we set dev_status to HISI_SAS_DEV_NCQ_ERR and abort all I/Os of the disk
> in this scenario.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 7d2a33514538..3935fa6bc72b 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -2244,7 +2244,14 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
>  	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
>  		if ((dw0 & CMPLT_HDR_RSPNS_XFRD_MSK) &&
>  		    (sipc_rx_err_type & RX_FIS_STATUS_ERR_MSK)) {
> -			ts->stat = SAS_PROTO_RESPONSE;
> +			if (task->ata_task.use_ncq) {
> +				struct domain_device *device = task->dev;> +				struct hisi_sas_device *sas_dev =
> +						device->lldd_dev;

Missing blank line after the declaration. And why the line split for the above
declaration ? That fits in 80 chars line...

> +				sas_dev->dev_status = HISI_SAS_DEV_NCQ_ERR;
> +				slot->abort = 1;
> +			} else
> +				ts->stat = SAS_PROTO_RESPONSE;

Missing the curly brackets here.

>  		} else if (dma_rx_err_type & RX_DATA_LEN_UNDERFLOW_MSK) {
>  			ts->residual = trans_tx_fail_type;
>  			ts->stat = SAS_DATA_UNDERRUN;

-- 
Damien Le Moal
Western Digital Research

