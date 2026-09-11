Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E855937E317;
	Fri, 11 Sep 2026 06:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106425; cv=none; b=ouKSbE7Nk1iUhw9ftAw+14srWorD7sHU9E8UuvckxiUx1Kl0qHXXR9EMT2xheRS4cJm0CoO3hEsOfj74QAdfV/LfkNJhMEeARUSvRUjUwe2BgYXFkfz9c6RijbcQrKRL9b673D0D92wlfNDzyoKpcV91M9aYMoffNWarpIsBzao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106425; c=relaxed/simple;
	bh=tirqTfLna/EEoG5NgyzwcptctXQYxUIJ+VH/WsxsUeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OlNXhLydVGDAQy7l01Nnq/h39kQwOlz+zVDMzyG6F8umtSkpRVgLDqgPYrF3+neZ4T0cgIVDVPjs4DPV8+GN6akzpTpetlEIQnYtZeRA8YXBAa/xa/2cBu56lncv5DWopz2ukTa3xaBqpf5HEOgoyIU1eQzbaJFPHy1R4Ox1jJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JTFCRCqc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JTFCRCqc"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B4VWY53839646;
	Fri, 11 Sep 2026 06:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/XFLmt
	KJKrj/dYsJUyrpbed7Yz39RfliIDLGwTrJI7g=; b=JTFCRCqc47sq1S8UnDL0N1
	rIJlELrRRWrQI6OxGHYJ4vxTgII1sfrXYTMr5B34LTqX78/NDKC368vWq4OWmDss
	PrlFfgakppEU5jqM+8yj0h5jRVSuiAnONGHziFNP0+2qEZ2eBqU2qTf1yPbTt4uL
	9fSldLb7XLY8e4xGZ60sJzr407l+AwGDiWoR0HnUxF12Fbu9piXpDuxrZmNXK0/a
	gX0ruzJabj9/6bQaXRZVyecjCiji7fIvJdsL32KyMxltRrrTmpoLhiDxveO49XXK
	6Ww/2c4fbkofSAf1kdfh0OOR/OuCmiDuDc6P+cInc5D0MeW+dxCDK7bSqD3Nbxvg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8q9j1a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 06:00:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B4K7q41076060;
	Fri, 11 Sep 2026 06:00:12 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvwk4kxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 06:00:12 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B5xSrh16056840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 05:59:29 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD95F5805E;
	Fri, 11 Sep 2026 06:00:10 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 297F658063;
	Fri, 11 Sep 2026 06:00:10 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 06:00:09 +0000 (GMT)
Message-ID: <23857c38-a884-4aa8-b272-de5419e36a0b@linux.ibm.com>
Date: Thu, 10 Sep 2026 23:00:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 1/9] scsi: ibmvfc: add basic FPIN support
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
 <20260911054832.1311668-2-tyreld@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260911054832.1311668-2-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WuJXIpMEg0ehDIqKrYQJ-czSPCQpPVom
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDA3NCBTYWx0ZWRfX+BQW8VB3S6Ox
 tIQ5wRmC08Q9GeiZW/My0UesH/mGEzGEFAAEZTSzqZKkgrfTx+0HMittTXX52nVvtIBFQlklh6u
 XXLWq8plPLdhsjPWMFuZ3a8PKAQyoG4=
X-Authority-Analysis: v=2.4 cv=E/dYNqdl c=1 sm=1 tr=0 ts=6aa398ed cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=5nvlYwwb9chOb2Jmx_UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDA3NCBTYWx0ZWRfX6aDsynn09+eV
 O7VUqH/NsddF45tAOz3bS3TD7VCLjhQNHh/Z5Jb786EjVfEsc+w8LZwewvy64ZDAZfOCs4DcHOl
 f4+xErxJ0oGsGFYiiomQ+yyMUOE7BvcT0bbRJiAuYN9xqTWojQgNapzayZaB4yKpqkWDsRsFqdW
 JUXWTUKnY2aCFopUHgFb29tjMKrtNZOm+NXeDRt2NVoaFQgigII3s3JrUJ2wFZWJgs8fJ/3U0ye
 ymvHa5ITYYgsJfblokSF157E+KiFJEu0GEEcqYB2BbuALIgpGPeC8THs/4vaqlApZyOBFxb1f7R
 ceavnqMnVP9rK1ZkVGm+bQIe7RA1Z+hokM5haUYWp5e9UMkx9DTsx327nvAYnz3f33qbKbVysp8
 RGVkR2rhg0JB2HkkdKmtzO50FUX5FfBuA2VRtwbKSTKprDJ3l7Ji2vvQIUthXu8J3eYdS8hj7ic
 F2Wy4w3465XByl7HjXQ==
X-Proofpoint-GUID: WuJXIpMEg0ehDIqKrYQJ-czSPCQpPVom
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110074

On 9/10/26 10:48 PM, Tyrel Datwyler wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Implement support for a basic level of Fabric Performance Impact
> Notifications (FPIN) in the ibmvfc driver to enable monitoring of
> fabric congestion and link integrity events.
> 
> Add async event handler for IBMVFC_AE_FPIN events that offloads FPIN
> processing to a dedicated workqueue. Convert VIOS FPIN messages to
> standard fc_els_fpin structures and pass them to fc_host_fpin_rcv() for
> processing by the FC transport layer.
> 
> Introduce common FPIN conversion routines that will be reused for full
> and extended FPIN support in subsequent patches. Add KUnit test
> infrastructure to validate FPIN event handling and statistics updates.
> 
> Add ibmvfc_handle_async() support for IBMVFC_AE_FPIN events, a dedicated
> workqueue for FPIN processing, FPIN message conversion to fc_els_fpin
> format, handling of link congestion, port congestion, port cleared, port
> degraded, and congestion cleared events, and a KUnit test module for
> FPIN functionality.
> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> [tyreld: add & operator to irqsave/restore calls]
> [tyreld: check for valid fc or nvme port in ibmvfc_find_target]
> [tyreld: remove kunit tests meant for later patchs]
> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---

<..snip..>

> @@ -6923,6 +7189,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>  	kthread_stop(vhost->work_thread);
>  free_host_mem:
>  	ibmvfc_free_mem(vhost);
> +free_workq:
> +	destroy_workqueue(vhost->fpin_workq);
> +	vhost->fpin_workq = NULL;
>  free_scsi_host:
>  	scsi_host_put(shost);
>  out:
> @@ -6953,8 +7222,6 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	ibmvfc_wait_while_resetting(vhost);
>  	kthread_stop(vhost->work_thread);
>  	flush_work(&vhost->rport_add_work_q);
> -	fc_remove_host(vhost->host);
> -	scsi_remove_host(vhost->host);

I mucked something up my fist go add cleaning up the kunit mess, and as a result
I went back and started fresh again from Dave's v8. Anyways, the second I hit
send I realized I forgot to reincorporate the change I had in v9 to no move the
xxx_remove_host() calls back and add the destroy workqueue call above those as
well as an IBMVFC_HOST_OFFLINE check before enqueue of work.

-Tyrel

>  
>  	spin_lock_irqsave(&vhost->host->host_lock, flags);
>  	ibmvfc_purge_requests(vhost, DID_ERROR);
> @@ -6963,6 +7230,10 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	ibmvfc_complete_purge(&purge);
>  	ibmvfc_release_sub_crqs(vhost);
>  	ibmvfc_release_crq_queue(vhost);
> +	destroy_workqueue(vhost->fpin_workq);
> +	vhost->fpin_workq = NULL;
> +	fc_remove_host(vhost->host);
> +	scsi_remove_host(vhost->host);
>  
>  	ibmvfc_free_mem(vhost);
>  	spin_lock(&ibmvfc_driver_lock);
