Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CFD3A4F5B;
	Mon,  2 Mar 2026 12:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772455587; cv=none; b=a+V+Ky0VBtrAYfEZORhHq3kIaOkQ3SSV5uKvpGo4MAjA5tpASwWHanPfX99iV1zpzWsQRq0bfXihG7I6yUjMyVfZpO3ZqzjjVaTGmzx4Eo+hnrGv/X1hoUptdCIUH1/hdwc5H0bR7y6K5WqkM1XxX0K2DTuxhqKvHh6QGkHBOMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772455587; c=relaxed/simple;
	bh=KiTTfeeOB3oiJ3yH6lppJhg+iZ6xP2VBR0n0pKqicr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dTFMMQ1dawxTRK5grJW0OdB4dAVf2QWWfbqdcpyxOrKArh6DoUFghq0tosxIyH18fCojNNRwcVlTgvasg+fsSWfyIWvcgf8glFgf/iVwGRPTxuq6vKfguLXB0QPavuoGVfIiM2pzqtQ946HFlxogZrjgR0sl3NbB4as3LhRV0nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H050d7E3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H050d7E3"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621N88fb2488101;
	Mon, 2 Mar 2026 12:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AH+87W
	/EBFQoEcB1Eewwldm2vzb1rUL59UugJvpAqik=; b=H050d7E3wPcWyX4WgD+usG
	k9Rx8/Lgj5Cm+wKSAqm0B1KTWHMQswBV+E/pxqSNlPHGdt7m70wJJinR+lPFla4V
	dd73gXSvQ9MqEanJLBbQfvy1ciGWuLPI43P+UW3W7/gesZVuTOoLUy+/KxyC+e/D
	Me23GX8qMANFQgZ/JFdsQJ7wTxFjeQ+7Mk6pM7i4VBCJNmpJk5Owy/puZAh5mk2G
	ZUT3L6IMEy0AsXC9a7u03B4qH3d7L5QXIKRWf5g394F47O/3ng5p2i74qGH84kC8
	8XxN0R0XCqUdbqAHyrFBvf1ioscVaKkLgK9YcHAzutwpOlQsdzGXLWnIVk+wcePg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksrhxk8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:46:10 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 622Ch7Ne003201;
	Mon, 2 Mar 2026 12:46:09 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmb2xx71j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:46:09 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 622CjkeG24642198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 12:45:47 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E4C85805E;
	Mon,  2 Mar 2026 12:46:08 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 500F358051;
	Mon,  2 Mar 2026 12:46:03 +0000 (GMT)
Received: from [9.79.192.112] (unknown [9.79.192.112])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Mar 2026 12:46:02 +0000 (GMT)
Message-ID: <e4ac58e4-c649-44a9-a6c3-3d027834c464@linux.ibm.com>
Date: Mon, 2 Mar 2026 18:16:01 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] nvme: introduce a namespace count in the ns head
 structure
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
 <20260225154007.1033735-3-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260225154007.1033735-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Rp/I7SmK c=1 sm=1 tr=0 ts=69a58692 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=yPCof4ZbAAAA:8
 a=1fZ_7sylh_IV_nERHg0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwNiBTYWx0ZWRfXzaluzDAfSKQl
 dbqQv72/XEpWZrq6wjY4KP8GrFrORGwv9WvNrQS6V7Z0cwq/gbfOP7XlWt4I57eenM5uO4XKkIi
 HmzCGiymCvP/p3GFfAYy/C+JVandL8xhrOIfS0Y5A49k3ZcGj0CQeY1YJIZMfLtVt7DstFUNHZL
 cTrxZipo9wTzPuSZHRw/83CeqWfZOsd+G+iqwmbZSnob76K5nk463ExtqcsahhhQ8Yi/7CfHUxS
 eYWL9dEE04J5vKClOE7WkXiA0e3uJ12ylO9UxHgC58U2J6MTlHvuyNm+qpPu+Fe29sFtLNunMVs
 fqcGlMIoyqVIv7b0M8b7D624kPV2Z/n/T21d2RDkAddKyoeM0l4idrd2uGpZtleWlzO3sLFOcJx
 tpZo41kmkRiRwdfhRFIfkYKSssaUW3SFgqzXcv9565DjSl0WJ6ziBSXjr3OO73/uj/8dIpffv9W
 abR1OPyRlfOYZyhFCDA==
X-Proofpoint-GUID: x3EROFGtCw_Q20XmIZIc-gNGrQix8Eow
X-Proofpoint-ORIG-GUID: x3EROFGtCw_Q20XmIZIc-gNGrQix8Eow
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020106

On 2/25/26 9:09 PM, John Garry wrote:
> For switching to use libmultipath, the per-namespace sibling list entry in
> nvme_ns.sibling will be replaced with multipath_device.sibling list
> pointer.
> 
> For when CONFIG_LIBMULTIPATH is disabled, that list of namespaces would no
> longer be maintained.
> 
> However the core code checks in many places whether there is any
> namespace in the head list, like in nvme_ns_remove().
> 
> Introduce a separate count of the number of namespaces for the namespace
> head and use that count for the places where the per-namespace head list
> of namespaces is checked to be empty.
> 
> Signed-off-by: John Garry<john.g.garry@oracle.com>
> ---
>   drivers/nvme/host/core.c      | 10 +++++++---
>   drivers/nvme/host/multipath.c |  4 ++--
>   drivers/nvme/host/nvme.h      |  1 +
>   3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 37e30caff4149..76249871dd7c2 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -4024,7 +4024,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
>   	} else {
>   		ret = -EINVAL;
>   		if ((!info->is_shared || !head->shared) &&
> -		    !list_empty(&head->list)) {
> +		    head->ns_count) {
>   			dev_err(ctrl->device,
>   				"Duplicate unshared namespace %d\n",
>   				info->nsid);
> @@ -4047,6 +4047,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
>   	}
>   
>   	list_add_tail_rcu(&ns->siblings, &head->list);
> +	head->ns_count++;
>   	ns->head = head;
>   	mutex_unlock(&ctrl->subsys->lock);
>   

I think we could still access head->mpath_disk->mpath_head->dev_list.
So in that case do we really need to have ->ns_count? Moreover, if
we could maintain a pointer to struct mpath_head from struct 
nvme_ns_head then we may avoid one dereference. What do you think?

Thanks,
--Nilay
