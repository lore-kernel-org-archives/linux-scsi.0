Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE47F2BE630;
	Mon, 16 Mar 2026 13:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773669327; cv=none; b=p3QSC9mj6zRmw40043A2fxDzye0rGKjumSxvlRIY1GWjlALnAogDOdsDWjCcQEZx6h+2G+klagnvu2n8Nz4A9q5gMI8i5Oc6inb33cfw2IQjvqZJyJxdTX4crSrQHQQZyCJXY4iRUVCZ4ptq8LEcsDdtdegnzySm0+3ShRRQWck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773669327; c=relaxed/simple;
	bh=YjSq0EYhcPUB+bsVnjnmeROjsvWnOYZImCE2VEPLivA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RkmPn54z41Pfm1UkrZgyXYrl+0ZwsQqxKn7f6hB0UuJsF+OQelyhEZqm3VWQz2tzauDeSXh9YL1SekGUN1EMxchRqXMZ3agYqMqUJuJg0SMuYYeX4z84h6DHXZYDOGysjIP8fYNEO9bEsI8K+bigd4a5FloZswlfxGCU/K7+FAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZkpUYcgU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZkpUYcgU"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FLphVt874119;
	Mon, 16 Mar 2026 13:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kafYUu
	6DNsWuvh/Xd3mmI40xYnhnHyMRE5HuFA1OpU4=; b=ZkpUYcgUNDDFUBU4iwEJSZ
	Kc1njZleZ7eXKUxF0eZYJ0Mi9NzsufX9XV540qLsfNcJPgG3zzgh40VRXxYIHP0C
	/zE8wcB5xm+pSb36pkXMq8kNWRJbu7fFezrUwSsdK2DMAkY8zzv5i15OTaRQpCl1
	OPm/YnqqN+/pjWcmf76ouzg0J2aFqL4yShovRP4tEVHxhWYgtdBFY8fyfcECPaUM
	RElkig3QG1qbjadqdTlVWXYR8SvMvVRcnDoTmKdJYyXwpa7IPrR8ecQNrq2l/Pyt
	hN4124xZ/BwfCJvye3I7aF0VuupC6B60IO226f09CyFc2akCU6crjKXVX5aH1EnQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvyau7r29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 13:55:19 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62GALs5g015644;
	Mon, 16 Mar 2026 13:55:18 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwk0n51tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 13:55:18 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62GDtHE164422162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 13:55:17 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A67B58052;
	Mon, 16 Mar 2026 13:55:17 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FEF35805A;
	Mon, 16 Mar 2026 13:55:16 +0000 (GMT)
Received: from [9.61.145.197] (unknown [9.61.145.197])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Mar 2026 13:55:16 +0000 (GMT)
Message-ID: <94050d3a-a7a2-40a9-9da7-38f759fc27f7@linux.ibm.com>
Date: Mon, 16 Mar 2026 09:55:15 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] scsi: virtio_scsi: remove unnecessary fn
 declaration
To: Joshua Daley <jdaley@linux.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        farman@linux.ibm.com, frankja@linux.ibm.com
References: <20260312174256.1557045-1-jdaley@linux.ibm.com>
 <20260312174256.1557045-3-jdaley@linux.ibm.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20260312174256.1557045-3-jdaley@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDEwNCBTYWx0ZWRfX8l8AU7cs7jEe
 VjSWBiIezAacAiXHZNQ9iH7r/YNSJqDohM6ijSBNzFu0tF+74NMoOyscagniQEpRUBGihIpwgZz
 7beHunJhNZIaL1BDJ5dLObJ8Kr2XFsj3LSMH19cwYsL3MXKvF1ZBm18/3+pZM8q6VlEEhjWpxl8
 38GoYnyojBmjokhfGNFwJO7UKDhuXB/V7IKV14lcYOjKUmbRX42khPcb/w9bYNHouilq6F5ExDY
 7GfXk1fBJo6vO35MwUB1XvUbsVZ2WwcIqr2wfOAauftyzXWAfbO4hwJkJGEsgLYEuK2+A8os6F4
 g3HuEzvfeYO47+q/4zswpHNPWAKHYKhKPWeEYYGBYDaRSyota85Xi9aoxFoliu1A9sKXLSmamVI
 /duydLEp90ZGzX8NBEteCalLrVPFLGWv23DYL2VvI52akGk2SoEJf5PH04WKyjNdpPLM3UnzPyW
 3DZQdq6u9kZdNv+3WYQ==
X-Authority-Analysis: v=2.4 cv=GIQF0+NK c=1 sm=1 tr=0 ts=69b80bc7 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=pf9ycOQNVFrg17mmGOQA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: f4ooi1aJLRh4t-rZe4Ddv3dGoQlBioH0
X-Proofpoint-GUID: f4ooi1aJLRh4t-rZe4Ddv3dGoQlBioH0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603160104

On 3/12/26 1:42 PM, Joshua Daley wrote:
> virtscsi_handle_event() is not used before its definition, so remove
> a prior declaration.
> 
> Suggested-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 982f49bc6c69..6efbeaa30f65 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -233,8 +233,6 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
>  	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
>  };
>  
> -static void virtscsi_handle_event(struct work_struct *work);
> -

Hi Josh,

You can't make this change until after patch 3 where you move the reference to virtscsi_handle_event further down.

In other words, if you just apply patch 1 + this patch you will get:

drivers/scsi/virtio_scsi.c:383:13: warning: ‘virtscsi_handle_event’ defined but not used [-Wunused-function]

until you also apply patch 3.  This breaks bisectability.

Please either re-arrange this series so that this is the last patch OR squash patch 2 + 3 together.

If you choose the latter approach and keep this patch then you can also include:

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

>  static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>  			       struct virtio_scsi_event_node *event_node)
>  {

