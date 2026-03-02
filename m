Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BC93630B1;
	Mon,  2 Mar 2026 12:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772456261; cv=none; b=B8BKQwoIMewfYeSfT72Thz+xsBZyNf+8ivIifTeUFGeTDCYHB/6BS/FnEx6lkYoVDLtosVOx3mlnzoo3JbHMg0YEf+QrN0JwTzf0HRrUHVnxOi3L3szXc0/Pax2vYErPyRZ7rD7PrWCLtgLycDMxCmjgcznCI6H8u41BTBt48A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772456261; c=relaxed/simple;
	bh=hvLSZiQsLnWzNs6WZ5wabnubTCSvxN70/ljhaRbQ3sU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pBbRw73fDkZmY5Jr9SXjneNrRIt4fmV+wY55jEuGMh1mZl1F8VOkN/3AGIc7Ihxpx6QZpnSVV5xcpZYCkMjJK3lBbkygUSv3pKbq7iqj1akyIf/Q39kliSO6Q+suKd5k+4gYFljE4uKPV+b53G0vuXzy+kvC27QJjkW51r9dAVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j1HJk5Mi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j1HJk5Mi"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621KiDCG1941479;
	Mon, 2 Mar 2026 12:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HGxsnL
	Yfy9kHPdT/nhG4VlprNXrSE18ZkeT+apwbbHo=; b=j1HJk5Micy3UEBWVybBLb4
	y/CoykrpD+y5spqD4mq7pRQ4RqYy/VdMN+op1dnRE5kCwDPk4FP4/r4WOa+ywACw
	9924BaKbvbomfZ2M48lB+8TIPsi2Tt25IFvNw48O/v9czGCuqoS6xh+oMElnkFJg
	lFnaeN0UxC7wxbgCZ6jTBasRb+7EH5j905TQxls3Gnp6ehgiVb/qyR6q2k+7ziYh
	lrk+xgUDlpBeBLRPBnpKjE6b1WBeC1QucUSC/W8PVVRFD9MgtnmKQsYBEfNVZI/D
	K7xAFibvHzzq4RNxtqSCOUEl6TwFuDb1/TdBktnuJr5sDg8PCChEh/M0T0eMKGLg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckssmef16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:57:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 622AOjTE027704;
	Mon, 2 Mar 2026 12:57:19 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmcwj5w68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:57:19 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 622CvI4162718236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 12:57:18 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CA325805E;
	Mon,  2 Mar 2026 12:57:18 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFC635805C;
	Mon,  2 Mar 2026 12:57:12 +0000 (GMT)
Received: from [9.79.192.112] (unknown [9.79.192.112])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Mar 2026 12:57:12 +0000 (GMT)
Message-ID: <bfc2bfa4-a28d-47dc-9362-b9ff6680cfab@linux.ibm.com>
Date: Mon, 2 Mar 2026 18:27:11 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/19] nvme-multipath: switch to use libmultipath
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
 <20260225154007.1033735-20-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260225154007.1033735-20-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwNiBTYWx0ZWRfX08ZG4mfYdE6+
 Pgtc0Q/jGKa+jDQNE0D+GrQjHKgMnFzoHCqSu1ifqjMpkeREbPJtmEaIO9GDdlyqoix0A4iKnHM
 cWPTqmGukRD+IAgnETbDg4A6HsMmzcl3mFPG7whALYPLnrPwsfSmk1d1HmZsuB3/sJnjvrcC+ws
 jrR24Dv2Nb41sT1mxJEx7tjCxkwzHlmsRf/oGegnyhGZfHMj7tY/ZXlIJfTJgNj+4eYSdTHnN23
 VToJkQiBTVF7qOd756gghV+boAmuRDWm+lRlynZeh1XKhyAQJZ4pBkmcVgZ7y/gwxByv15H44fi
 ih3mFr+3mKU1Jx+t5maDc4pBFEK1wLhsR/5WxfDXr+lGl9dlfVYLVIU354rQFSrtrdOF+X+vi1s
 /jrdGPpTmejHF9fPkuh+jbj3TYi0P2fTwTjgcFf7fs9l9egIJER25DB/fhJCYN66PvOFOO/v2yQ
 I6RLWIDDP3LRYFqC9Xw==
X-Proofpoint-ORIG-GUID: 9hUb9hBF3IRM0ca70u5en9RE3Z-TTG7C
X-Proofpoint-GUID: 9hUb9hBF3IRM0ca70u5en9RE3Z-TTG7C
X-Authority-Analysis: v=2.4 cv=AobjHe9P c=1 sm=1 tr=0 ts=69a58930 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=CpEX-UuAubdY51wu2XgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020106

On 2/25/26 9:10 PM, John Garry wrote:
>   void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
> @@ -277,30 +279,35 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
>   	srcu_idx = srcu_read_lock(&ctrl->srcu);
>   	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
>   				 srcu_read_lock_held(&ctrl->srcu)) {
> +		struct nvme_ns_head *head = ns->head;
> +		struct mpath_disk *mpath_disk = head->mpath_disk;
> +
> +		if (!mpath_disk)
> +			continue;
> +
>   		nvme_mpath_clear_current_path(ns);
> -		kblockd_schedule_work(&ns->head->requeue_work);
> +		kblockd_schedule_work(&mpath_disk->mpath_head->requeue_work);
>   	}
>   	srcu_read_unlock(&ctrl->srcu, srcu_idx);
>   }
>   
> +static void nvme_mpath_revalidate_paths_cb(struct mpath_device *mpath_device,
> +					sector_t capacity)
> +{
> +	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
> +
> +	if (capacity != get_capacity(ns->disk))
> +		clear_bit(NVME_NS_READY, &ns->flags);
> +}
> +

I don't quite understand the intent of the above function.
Here I see that we compare mpath_disk capacity with per-path
disk. Do we really have sectors allocated for mpath_disk?

Overall, IMO abstracting out common multipath function into
a separate library is a good move. But then I just want to
understand layering here with libmultipath. Does it sit above
the driver or below? I see in some places we have back and forth
callbacks from driver to libmultipath and then back to the
driver, for instance:
nvme_mpath_add_disk          => driver
  -> mpath_device_set_live    => libmultipath
   -> mpath_head_add_cdev     => libmultipath
     -> nvme_mpath_add_cdev   => driver

Does this intentional? Or am I missing overall picture...

Thanks,
--Nilay

