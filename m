Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561081E511;
	Mon, 16 Mar 2026 14:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773671859; cv=none; b=u641YWH4o9BWkf1bGpFxTnT3I7iG8zXqrNsrWt7kgPsu/KGxK4ZzPM2rMJK0y4eEw7yKyno+zK3bDjmG12lWAKGRowDx/jEIrZX0fpZ1U0cwuFPhv4WgZxfAL4o1XmnC3pV9Wfe/hOQAU5BniTlzT4F1cgfokRI8uwGDuci9x9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773671859; c=relaxed/simple;
	bh=o+M88/KJMB2IVz8OKQvJTjCzOmfsGr4+/0YSpOUJzj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oL9eWuFIkZ8PwITHhCPjlSg/+TcMMoqinFQoVUxpPy6+MPadPOiJanLvUzTMZLpP4NMEtGRK2dD56OI+LSKDKLCWV60xbAoAYFborCCSqiT6We2Mh7Z68pF1Tl9Vn30xt7v+TgpQ9VHID7xzUCeaT/NuR8Wl2gaLsPC/adTAHU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=etJ1Uxi1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="etJ1Uxi1"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FLqcLj858738;
	Mon, 16 Mar 2026 14:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=SyNe8B
	+2BJXGy2567L+B/HDMHX0mEeB5cqUpwx4ULU8=; b=etJ1Uxi17/YoY5C283Pjaq
	iUtoHVLHzhwyE/1AFAmOjQYhXcQYFSqpAuU01qmxpzH4kTNGxNyXNQY62WOQB+S0
	On1dCWF6by6FWtYzR1NVwHuVO1kCMbrhqys02HtFRGPjxeFe8RZM392Hw+U3Yjlx
	dX2sJz33gHjmK3tFLcCGRxBtiqDmiAaRYQNrJwDXTEc+IqrtwdGW1a1s/nD4Yb3o
	CcCTlaqC4v3P/21AsM/kEwrSvpCMCQD/NWN3UDzFXCJg/9WVpgVFTxsN/poR6bTe
	emvnmNbar/AfeWmzokxVA7B2BBSxgHQnMv9YmzA3oqjSRECckIr6K4JiJu2qHKRQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvw3hr5dr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 14:37:31 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62GAlfJX028739;
	Mon, 16 Mar 2026 14:37:31 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwkgk54uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 14:37:31 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62GEbTjQ64618790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 14:37:29 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 455A758056;
	Mon, 16 Mar 2026 14:37:29 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68D6358052;
	Mon, 16 Mar 2026 14:37:28 +0000 (GMT)
Received: from [9.61.145.197] (unknown [9.61.145.197])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Mar 2026 14:37:28 +0000 (GMT)
Message-ID: <c33c5147-37de-4cd7-94d7-1d09936c8fd0@linux.ibm.com>
Date: Mon, 16 Mar 2026 10:37:27 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: virtio_scsi: kick event_list unconditionally
To: Joshua Daley <jdaley@linux.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        farman@linux.ibm.com, frankja@linux.ibm.com
References: <20260312174256.1557045-1-jdaley@linux.ibm.com>
 <20260312174256.1557045-2-jdaley@linux.ibm.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20260312174256.1557045-2-jdaley@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: g3zhU5LWvyeJ9CPx5IUY7SnCSURxcFwA
X-Proofpoint-ORIG-GUID: g3zhU5LWvyeJ9CPx5IUY7SnCSURxcFwA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDEwNyBTYWx0ZWRfX1bkwrnOEPRpl
 HJV2vGARSGYWoLckDeeZEafqkMUPDlkvwD/PgEVS8z58q/mkefG0n4xQId+AIx0gzbAMNN3LyDm
 pLKj3jNhWaK4CWo1p5f5u9HVMAjeqA6WLOiApC/fpaK80tWgRbv6ZdfADTXpYhuTHliFAzk3V44
 QosX8aqzILNK9e5pVO1frMJYWSWW/BMo+rBI5lnbaisC5wSEQft0REwEMphJuVkJeMVnZvb7RVI
 tOUaGOAtZKgADxWVyEkbOOnYDIgUzdy/pZJT+Z1rjgPiB5WYmDsWNVMiQG35LZ+yOC8UmPMH7FT
 MwbLs3lwfgmgd1+GwdeNkOJF87SXDgyVQ429pgxgjRrc1qPXS0O9YtjqgiZn+JBXlrLUc/3V3Jr
 NvIU2ib6R2sJHkKtcX1+Mg/a8Rvgy9dLgBZFZoGUAwC6b61R4/KBG7H0F8HVn53+QPaTyv2knQX
 VVpgjgA2eObHgN/bY0Q==
X-Authority-Analysis: v=2.4 cv=Hf8ZjyE8 c=1 sm=1 tr=0 ts=69b815ab cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=20KFwNOVAAAA:8
 a=VnNF1IyMAAAA:8 a=kAOPLS83hYidNoMSTZoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603160107

On 3/12/26 1:42 PM, Joshua Daley wrote:
> The event_list processes non-hotplug events (such as LUN capacity
> changes), so remove the conditions that guard the initial kicks in
> _probe() and _restore(), as well as the work cancellation in _remove().
> 
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  drivers/scsi/virtio_scsi.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 0ed8558dad72..982f49bc6c69 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -983,9 +983,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  		goto scsi_add_host_failed;
>  
>  	virtio_device_ready(vdev);
> -
> -	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
> -		virtscsi_kick_event_all(vscsi);
> +	virtscsi_kick_event_all(vscsi);
>  
>  	scsi_scan_host(shost);
>  	return 0;
> @@ -1002,8 +1000,7 @@ static void virtscsi_remove(struct virtio_device *vdev)
>  	struct Scsi_Host *shost = virtio_scsi_host(vdev);
>  	struct virtio_scsi *vscsi = shost_priv(shost);
>  
> -	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
> -		virtscsi_cancel_event_work(vscsi);
> +	virtscsi_cancel_event_work(vscsi);
>  
>  	scsi_remove_host(shost);
>  	virtscsi_remove_vqs(vdev);
> @@ -1028,9 +1025,7 @@ static int virtscsi_restore(struct virtio_device *vdev)
>  		return err;
>  
>  	virtio_device_ready(vdev);
> -
> -	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
> -		virtscsi_kick_event_all(vscsi);
> +	virtscsi_kick_event_all(vscsi);
>  
>  	return err;
>  }

