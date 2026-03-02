Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A72373BFE;
	Mon,  2 Mar 2026 12:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772455041; cv=none; b=Eb+OvhNaSNnkmRmapoC7w9eZjmm+jkWCE/QnC7zPe2hAu25DE0TjIl7DbH624YGLivCoV9ahhLGjG6KB0JqAzuZ9H76CtVRWUNeUI6+rD2Vv8GBpYTuv0mF4BPH2zQ5PuxQCUHr7qCb/PuGtX0qe2JxNiqjaaMdWRdVyP7FpgcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772455041; c=relaxed/simple;
	bh=RNNIoLgb43oyjgIK/Cwp+pvICYTW44+LA7W2jeiFMRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=noppwh3p7U3ZAzAj2s6cEFWAMNHCyAMQjFdReJbwWBOdR+bVRXPOzfWDX90VXpmTq0werzpNrMSPbNUEm/qYKbboeOfk7n9y8XcFvhA9IQqAvfQy2gymLgwfM0SCZfEtngPbJojTOZDYTXKgNjxMldBaEU6XHax7RAnXskTwwlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TnuCcolU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TnuCcolU"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621NOc3p2188183;
	Mon, 2 Mar 2026 12:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IcWZyG
	ostXMleCkEzwIAMNvP+Ka7HcEai/fLp27J1bE=; b=TnuCcolUD5CQ1ZonMBm+qu
	XlYNTc/socWdw6D15I6Yjs7b6mGCZ1kNRxQXPeLiCKP+GHnmkicE6LRrY9qIheto
	4NLQ90krMv+9GraBnRf59tB/YuvIaM9vVWhO/sd0PhjL1w0FxK9bGicWMPEXyMw5
	ToBrM5yb+T/EneIL60bZyFHvhunfvgtI5/siHgJA6W7bzedvPeWHbUscVbttL5iE
	StvdP0U62F+c8m6IlfsraI3OTnY0UobR2e0i2NicBlcXsdugYLQQsMEJK/xvu+fq
	GHkYUJBu9CW/9MIKloIyhtZzFQjsHRlLnvfDDYUN/AvLxy3CHvSLamZC6l6CpP5Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksk3pbpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:36:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 622A6hOL016802;
	Mon, 2 Mar 2026 12:36:58 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmbpmx1k1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:36:58 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 622Cavqj17498782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 12:36:58 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C24258051;
	Mon,  2 Mar 2026 12:36:57 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 199425805F;
	Mon,  2 Mar 2026 12:36:52 +0000 (GMT)
Received: from [9.79.192.112] (unknown [9.79.192.112])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Mar 2026 12:36:51 +0000 (GMT)
Message-ID: <775dd360-ea41-4e27-9690-e0633e0522d7@linux.ibm.com>
Date: Mon, 2 Mar 2026 18:06:50 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260225153225.1031169-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lKjX2aqSlyv-QhTy98TA6Y4BRh81WQWz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMSBTYWx0ZWRfX5Hq3h7erUDko
 PpZ4v2vJbL3I04tgZvVB2aB2Yecidw7A7RT3FNjKg2k0a1kWLTdXRx+Hhj0KbF6j8XMrjTGkzAj
 od38SP0krR0jJew+87RuS7jlkUDbx5BG52Qu5MkluNLUN8Xpi6nbnG/rgTqQ21aLcKg+9Y50w8J
 AH+Us0uba/t3dqMYrtH8FysIUk1aK5D6eVjNqQSAKQdVx7rDlfDIJObxQgKGnSsW133xM33ZMNu
 8b6W5rOdeIw+pxrhIjGRljurI9zFv+qrw8st4ocDW3EDnTFClEfnJdOVAOyoYSk3xQKWTugpnkI
 vhLAkxhTvBD0F78n2pKDU3xYy4zvjMcUvgy/XCN/HEvcg2+VIjKJJTNMYBLBVgLGT8OwDJZpYrh
 Q7J6M4Uz78OWYhRl2LadmzDdOiYLaZO5vI+9yGMLg0UBLNZjyl9NUFzZQOKrYO8fvcbUrBZsIMe
 AI/nqhRofaGlGmLkDcw==
X-Authority-Analysis: v=2.4 cv=csCWUl4i c=1 sm=1 tr=0 ts=69a5846b cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=yPCof4ZbAAAA:8
 a=0a6mvLp3HQvR2nPWJRIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: lKjX2aqSlyv-QhTy98TA6Y4BRh81WQWz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020101

On 2/25/26 9:02 PM, John Garry wrote:
> Add code for path selection.
> 
> NVMe ANA is abstracted into enum mpath_access_state. The motivation here is
> so that SCSI ALUA can be used. Callbacks .is_disabled, .is_optimized,
> .get_access_state are added to get the path access state.
> 
> Path selection modes round-robin, NUMA, and queue-depth are added, same
> as NVMe supports.
> 
> NVMe has almost like-for-like equivalents here:
> - __mpath_find_path() -> __nvme_find_path()
> - mpath_find_path() -> nvme_find_path()
> 
> and similar for all introduced callee functions.
> 
> Functions mpath_set_iopolicy() and mpath_get_iopolicy() are added for
> setting default iopolicy.
> 
> A separate mpath_iopolicy structure is introduced. There is no iopolicy
> member included in the mpath_head structure as it may not suit NVMe, where
> iopolicy is per-subsystem and not per namespace.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   include/linux/multipath.h |  36 ++++++
>   lib/multipath.c           | 251 ++++++++++++++++++++++++++++++++++++++
>   2 files changed, 287 insertions(+)
> 
> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
> index be9dd9fb83345..c964a1aba9c42 100644
> --- a/include/linux/multipath.h
> +++ b/include/linux/multipath.h
> @@ -7,6 +7,22 @@
>   
>   extern const struct block_device_operations mpath_ops;
>   
> +enum mpath_iopolicy_e {
> +	MPATH_IOPOLICY_NUMA,
> +	MPATH_IOPOLICY_RR,
> +	MPATH_IOPOLICY_QD,
> +};
> +
> +struct mpath_iopolicy {
> +	enum mpath_iopolicy_e	iopolicy;
> +};
> +
> +enum mpath_access_state {
> +	MPATH_STATE_OPTIMIZED,
> +	MPATH_STATE_ACTIVE,
> +	MPATH_STATE_INVALID	= 0xFF
> +};
Hmm so here we don't have MPATH_STATE_NONOPTIMIZED.
We are morphing NVME_ANA_NONOPTIMIZED as MPATH_STATE_ACTIVE.
Is it because SCSI doesn't have (NONOPTIMIZED) state?

> +
>   struct mpath_disk {
>   	struct gendisk		*disk;
>   	struct kref		ref;
> @@ -18,10 +34,16 @@ struct mpath_disk {
>   
>   struct mpath_device {
>   	struct list_head	siblings;
> +	atomic_t		nr_active;
>   	struct gendisk		*disk;
> +	int			numa_node;
>   };
>   
I haven't seen any API which help set nr_active or numa_node.
Do we need to have those under struct mpath_head_template ?

Thanks,
--Nilay
