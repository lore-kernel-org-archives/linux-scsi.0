Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AFF19C552
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 05:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726205381; cv=none; b=VshYSOCiEvyjC6Th73/TcMtbNLRYvFPu3S/duQKNEOfrDCjmjjLpjgIt49Vwb1K0Hj/4LIEhWwzlgSoh9cTZIxsiOgErbb1ErFe2UXhUElu/mx3uKKV50pV5H72I0xqGnsEs8RdubvQ7eFt7FhfrZRsLT/RIEo5oGzdVyznimvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726205381; c=relaxed/simple;
	bh=3H/ldlb7dCaqpCmFlyq6wm07tZ55Tu7M9kPXTLgJvcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Hpwhuc7BpDUs3J6v1SVd34o+4yRrUjwfunpQE129lrtd1/2KL5wAuVzcyQ76zvnrsXWkfZ3PrCQ7NQytlyZkGRAMcgQyILvlY5RI45o+M7zOAE1vtZuebAGuRKjjtG3VyRT8zC+JuZcysqPZwlWF25z87gA3bvh8DGKxZdyVdFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=G5zWi+zj; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="G5zWi+zj"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBaoa003394;
	Fri, 13 Sep 2024 05:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	26enAS6y3AOXsxjL0KVl5mMkRZR+xc5JAzbevmeLlYI=; b=G5zWi+zjBXL2MtjD
	2fJFsmkXhTA/RzY9wcoNu3CjJAYXz1z1KeSaOFwqrRNj68zXHBSVoSAc2jMxnQD7
	TT/lEUhx4fpCQAXU1DUED1yoVunBo7eMUvO+gID+skFI8MndqpHB0dz56Th7aFIj
	ML0f1zz7gkOcxDNZBzEX2DTlBtQARuxBZ5eN1efu1qdc8mgg1K/1l/UlGaDtw17/
	JiHIy3Zb3GWigoA95DxWrEaNMHvk7w6K5Tge5cQpwUd0OnlC2WEFii6RFO5xDDi4
	fbcbFWRhRoU7CMU4TbC+N0WctJw3MDJW3/aYmrWrKY3kFfF7f/yDOu1f5xx6B6Ot
	VIgnqw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gybpyfea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 05:29:14 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 48D5TDjs014255
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 05:29:13 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 12 Sep
 2024 22:29:12 -0700
Message-ID: <7b1e932c-45e5-29bd-5361-e88642b27e86@quicinc.com>
Date: Thu, 12 Sep 2024 22:29:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 06/10] scsi: ufs: core: Move the
 ufshcd_device_init(hba, true) call
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andrew Halaney <ahalaney@redhat.com>, "Bean Huo" <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Eric
 Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
        Maramaina
 Naresh <quic_mnaresh@quicinc.com>
References: <20240910215139.3352387-1-bvanassche@acm.org>
 <20240910215139.3352387-7-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240910215139.3352387-7-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 6OCz0rw6fASIRSLB1uR3GzC4iJ9oaCoP
X-Proofpoint-GUID: 6OCz0rw6fASIRSLB1uR3GzC4iJ9oaCoP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 bulkscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130037

On 9/10/2024 2:50 PM, Bart Van Assche wrote:
> ufshcd_async_scan() is called (asynchronously) only by ufshcd_init().
> Move the ufshcd_device_init(hba, true) call from ufshcd_async_scan()
> into ufshcd_init(). This patch prepares for moving both scsi_add_host()
> calls into ufshcd_add_scsi_host(). Calling ufshcd_device_init() from
> ufshcd_init() without holding hba->host_sem is safe. This is safe because
> hba->host_sem serializes core code and sysfs callbacks. The
> ufshcd_device_init() call is moved before the scsi_add_host() call and
> hence happens before any SCSI sysfs attributes are created.
> 
> Since ufshcd_add_scsi_host() checks whether or not the MCQ mode is
> enabled and since ufshcd_device_init() may modify hba->mcq_enabled,
> only call scsi_add_host() from ufshcd_device_init() if the SCSI host
> has not yet been added by ufshcd_device_init().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 16 +++++++++-------
>   include/ufs/ufshcd.h      |  3 +++
>   2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index f62d257a92da..a3c5493ccc8f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8907,16 +8907,12 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>   static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>   {
>   	struct ufs_hba *hba = (struct ufs_hba *)data;
> -	ktime_t device_init_start;
>   	int ret;
>   
>   	down(&hba->host_sem);
>   	/* Initialize hba, detect and initialize UFS device */
> -	device_init_start = ktime_get();
> -	ret = ufshcd_device_init(hba, /*init_dev_params=*/true);
> -	if (ret == 0)
> -		ret = ufshcd_probe_hba(hba, true);
> -	ufshcd_process_device_init_result(hba, device_init_start, ret);
> +	ret = ufshcd_probe_hba(hba, true);
> +	ufshcd_process_device_init_result(hba, hba->device_init_start, ret);

This patch probably changed the original trace print. In the original 
code, the trace only prints the time spent in probe_hba().
In this patch however the trace print includes the time spent in 
ufshcd_add_scsi_host() plus the time wait for 
async_schedule(ufshcd_async_scan, hba).

>   	up(&hba->host_sem);
>   	if (ret)
>   		goto out;
> @@ -10387,7 +10383,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba)
>   {
>   	int err;
>   
> -	if (!is_mcq_supported(hba)) {
> +	if (!hba->scsi_host_added) {
>   		err = scsi_add_host(hba->host, hba->dev);
>   		if (err) {
>   			dev_err(hba->dev, "scsi_add_host failed\n");
> @@ -10610,6 +10606,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	 */
>   	ufshcd_set_ufs_dev_active(hba);
>   
> +	/* Initialize hba, detect and initialize UFS device */
> +	hba->device_init_start = ktime_get();
> +	err = ufshcd_device_init(hba, /*init_dev_params=*/true);
> +	if (err)
> +		goto out_disable;
> +
>   	err = ufshcd_add_scsi_host(hba);
>   	if (err)
>   		goto out_disable;
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index a43b14276bc3..55ec89fa16af 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -839,6 +839,7 @@ enum ufshcd_mcq_opr {
>    * @dev: device handle
>    * @ufs_device_wlun: WLUN that controls the entire UFS device.
>    * @hwmon_device: device instance registered with the hwmon core.
> + * @device_init_start: start time of first ufshcd_device_init() call.
>    * @curr_dev_pwr_mode: active UFS device power mode.
>    * @uic_link_state: active state of the link to the UFS device.
>    * @rpm_lvl: desired UFS power management level during runtime PM.
> @@ -972,6 +973,8 @@ struct ufs_hba {
>   	struct device *hwmon_device;
>   #endif
>   
> +	ktime_t device_init_start;

IMO, it's kinda overkill to add this device_init_start member for the 
purpose of trace print the time spent in the first probe_hba() only.
How about print the time spent in probe_hba() outside of the 
ufshcd_process_device_init_result() function so that you don't need to 
pass device_init_start into ufshcd_process_device_init_result()?

> +
>   	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
>   	enum uic_link_state uic_link_state;
>   	/* Desired UFS power management level during runtime PM */
> 

