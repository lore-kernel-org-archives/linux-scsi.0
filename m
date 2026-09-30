Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44A2514753;
	Wed, 30 Sep 2026 21:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804932; cv=none; b=TaGxTgOUJIv49PSCuVRZbqgygF9hH55II6RgC4YBcQiCYSa4/SI+YkQepJZWqHYDxutVQohIJdXZGBRmDF82OAKhg8LRwGZeYormfKx1L7N0Rv3rLux6TytzSll6CBYGskTAheb+2gkywcUvZpslipm9smkNmkgP2Fnkq4y1XRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804932; c=relaxed/simple;
	bh=msRi4rfpUF2iQHTjYjUOAYbk5e0RTNwR+BOFW/f8QT4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Qzbpy4HgZh5b3Dgs2w8/F6CMSd6QPUy7WCqp4fAivAwddMEZnX78Vr9mFFfORHa6vn4wdzpQFgT+hYcbDr9S+92/KTnfV0YKyloZ4TV/H9R8LC4hSLa8UqyenxL3OCHqmhZ51uOR5ld7WsXgnXxOQjWghtylgAisXNUO/vyWvns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ViJIKt0C; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ViJIKt0C"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UI5gXV3708550;
	Wed, 30 Sep 2026 21:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=t5txDb2NQ+t3SnRIwjvXpaDUE0O4D7
	CyXlai1EKw3/U=; b=ViJIKt0CsSA0XIiB4lUQcyeNO5HiL3QPp5uidGOCDpeT7y
	j/zIz1+mx1qWIEW6pq/f8K6kwTIY8O0McdKBl6eBEK/JVZDkylDwbKlDlyGv7DzW
	eAJ8Bo7wuLJCgyZsoFFK9n9MzibB4YDeIBxFAY0gOgxA6iUmC79mgy7cj+6xyRhj
	Du5SVrSX6PJmKj5D7xaxXSeX+TNZ8SjKej+9BjeGefqwzv7t2CfBBpZuXXEeuR41
	G6rzc8UjxKUKktqo40XbOyO1mFWBBRHBOm5Js1YYhKnBF9dgsW++trzmdVB/IoBl
	0HEQ0KR5znn/jktG89MD6JEMreRPycYTGjjZq9VA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5j5ftr3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 21:48:48 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68UI2LfX3863791;
	Wed, 30 Sep 2026 21:48:47 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h0xcsb3ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 21:48:47 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ULmk0729098510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Sep 2026 21:48:47 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF3ED5804E;
	Wed, 30 Sep 2026 21:48:46 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 733D15803F;
	Wed, 30 Sep 2026 21:48:46 +0000 (GMT)
Received: from d (unknown [9.61.94.172])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Sep 2026 21:48:46 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v12 04/11] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <20260930183931.565D31F0089A@smtp.kernel.org>
	(sashiko-bot@kernel.org's message of "Wed, 30 Sep 2026 18:39:30
	+0000")
References: <20260930-ibmvfc-fpin-support-v12-0-53a3fff7d77b@linux.ibm.com>
	<20260930-ibmvfc-fpin-support-v12-4-53a3fff7d77b@linux.ibm.com>
	<20260930183931.565D31F0089A@smtp.kernel.org>
Date: Wed, 30 Sep 2026 16:48:45 -0500
Message-ID: <87ik3mjtqa.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA4OCBTYWx0ZWRfXzlPwQ65ngEYP
 czTGclt+D6dRlbgSuTe8oNO46bmqCUU1uK+dKM68d0OTKJeiZ0bB+svH1sb/aB1Zwpoc1Y6zCUL
 +k58XkHnyX2Ar7Fsft4dm2mp/SVHZfY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA4OCBTYWx0ZWRfX40Wyi3HGe8VZ
 ZuqwKkOK1P0q3qUjzliEoqHTx3yguBT0vOwvwWwMBtX1ve6ksRc1QbPMOLzxIr3JKdjx8wgWGNP
 KF58Lrk8FO+PoPT3Gky+85b/cYcXYwpEwMXuAridzicSiL8r2s8gMO09MTI1d6q9mgzOltP14Kr
 ERU0BrA/JHuXDMQKGKRc2EH14vi3s+tGlaFd2moCWwb45Wau6M2K8JiopUg2RrrThUX2kNZHwOb
 eDFeaaB9jBJmUY1lX+N9G47LPRhcSiGTGyJepyUcR9VdOYrw3UIRLwad1XtkwDMod9V0jksg6eG
 Y3QR/T197JhXjqbL51ZIgatQVqH3ASxH58EZL6TwVyckwUis+17UPP8RP/g/uIzQVP8DbaGgcb2
 7XgEtQI+sJfMpi2dyVmyWiSlfwS7ZmA8oy/cXa5QEPw8TxsL4Godfu+gye3vyxsD/joIwqrexeU
 pnFh2sszSmw9XsvlC1A==
X-Proofpoint-GUID: du-I7sd2bU-0akAZjRAw_x4NUW8046dt
X-Authority-Analysis: v=2.4 cv=RKcmjIi+ c=1 sm=1 tr=0 ts=6abd83c0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=8Ve1dzS3KkD96-Ov_HEA:9
X-Proofpoint-ORIG-GUID: du-I7sd2bU-0akAZjRAw_x4NUW8046dt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300088

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] scsi: ibmvfc: unbalanced scsi_host_put() and UAF in kunit tests due to ignored scsi_host_get() result
> --
>
> commit 0f3f9d832e1029568dc3a6eb9097fdaa04016dcc
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add basic FPIN support
>
> This commit implements support for a basic level of Fabric Performance
> Impact Notifications (FPIN) in the ibmvfc driver. It adds an async
> event handler for IBMVFC_AE_FPIN events that offloads FPIN processing
> to a dedicated workqueue, and introduces KUnit tests for validation.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index cf775f0673a0f..e0fa9b547cbfe 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -7120,5 +7393,21 @@ static void __exit ibmvfc_module_exit(void)
>>  	fc_release_transport(ibmvfc_transport_template);
>>  }
>>  
>> +#if IS_ENABLED(CONFIG_KUNIT)
>> +VISIBLE_IF_KUNIT struct ibmvfc_host *ibmvfc_get_first_vhost(void)
>> +{
>> +	struct ibmvfc_host *vhost = NULL;
>> +
>> +	spin_lock(&ibmvfc_driver_lock);
>> +	if (!list_empty(&ibmvfc_head))
>> +		vhost = list_first_entry(&ibmvfc_head, struct ibmvfc_host, queue);
>> +	if (vhost)
>> +		scsi_host_get(vhost->host);
>
> [Severity: Medium]
> Does this code need to check the return value of scsi_host_get()? 
>
> If it fails (for example, if the module is being concurrently unloaded and
> the host state becomes SHOST_DEL before vhost is removed from ibmvfc_head),
> this function will ignore the failure and return an unreferenced vhost
> pointer to the caller.

Yes, this is possible. In v13, if scsi_host_get() returns NULL,
ibmvfc_get_first_vhost() will return NULL.

>> +	spin_unlock(&ibmvfc_driver_lock);
>> +	return vhost;
>> +}
>> +EXPORT_SYMBOL_IF_KUNIT(ibmvfc_get_first_vhost);
>> +#endif
>
> [ ... ]
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> new file mode 100644
>> index 0000000000000..7cc9d423d4a79
>> --- /dev/null
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>
> [ ... ]
>
>> +static void ibmvfc_async_fpin_test(struct kunit *test)
>> +{
>
> [ ... ]
>
>> +	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
>> +			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
>> +
>> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
>> +	put_device(&rport->dev);
>> +	scsi_host_put(vhost->host);
>
> [Severity: Medium]
> Could this unconditional scsi_host_put() cause a refcount underflow if the
> earlier scsi_host_get() call failed?
>
> The test might also perform a use-after-free by accessing members of the
> unreferenced vhost if it was already freed concurrently by the unload path.

I assume you're referring to the earlier scsi_host_get() call as above
in ibmvfc_get_first_vhost(). Yes, this is currently a problem, but in
v13 this test will bail out as ibmvfc_get_first_vhost() will return NULL
if scsi_host_get() returns NULL.

-Dave
