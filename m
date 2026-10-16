Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0096737B010;
	Fri, 16 Oct 2026 14:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792162059; cv=none; b=igUrhUdWeC/PvhDimvhwDKezHgLrFhT7wh79pBmzkeymGRoI1eyz4CXCD/T9CS9arwW0dNilEBb5WHLH1ODq4bDzNNFB3IyFmf29aciyz+rp/heVO+k2dQ6Wr1lNXbnUM+Z7G1zQUyQLbjn2YnamRQzMVSVN5TOfDZexJU8DdK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792162059; c=relaxed/simple;
	bh=HtPwM1PCjsyC/WylC15pAfFJO+AQt0sKv8BR5kvKvco=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DbfZ6aegbyFvJaj32CsW6TG9ueFksxp/PBzOi89MpdbxhILQ+WJ46dr3hhUxPREeZEM6j32l4Qz+kJy3tERzG4FG+wPZyaCnWn9lThsqbddl1PffYzJAGSOAfwIat1bONH7pruqTJIf3Pj/OMJj97XBxB80yOIcj6n26w4Bsk2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RnlzAt/5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RnlzAt/5"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GEEWdW2270900;
	Fri, 16 Oct 2026 14:47:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=2VFCEUYCYjEdo8kS655yM+CRpOlu/c
	dwWmSkKGPsNT8=; b=RnlzAt/5DfJQ8L70s3rs/Qrpct639m7CwVw5lhxhRdqogY
	XRb4QP5CxeHHsu61iChXE/UkWf+L8t+tZkkhwP6p4kWS7d3VE2dVA+eSemTYLv5g
	00zpbz5E+fw4xjMeQrhZ7Wrd4z+giB4nasnSRoC+It1Nv4b5AwJbEiTcokRllRJ5
	st16S9DQ3PUenHjonsQHxTAZnFpxRgnbE1KK+sKIwN5YqSduj3YTjV122rXOye2I
	CT67OopsSwHyESBczqrHZkk4mgzs2GDhjyL7vcA7PXtgAMw+8AnJX5iYB47NZDkN
	Y2C9V0UXcl9pe9L+TCdwILheSb97ervAMxQbx1bg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dwhywf5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 14:47:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE5WB93752394;
	Fri, 16 Oct 2026 14:47:27 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hb34mkxef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 14:47:27 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69GElRLN30868036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Oct 2026 14:47:27 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 253715805A;
	Fri, 16 Oct 2026 14:47:27 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 07FC858051;
	Fri, 16 Oct 2026 14:47:27 +0000 (GMT)
Received: from d (unknown [9.61.189.254])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 16 Oct 2026 14:47:26 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v14 07/11] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
In-Reply-To: <sashiko-outbox-173052@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 15 Oct 2026 15:20:27 +0000")
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
	<20261015-ibmvfc-fpin-support-v14-7-a0b063b8d825@linux.ibm.com>
	<sashiko-outbox-173052@kernel.org>
Date: Fri, 16 Oct 2026 09:47:26 -0500
Message-ID: <87y0bxbt35.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1OCBTYWx0ZWRfXzA+IACljRJBw
 LMfHNC01/oV3ppfTNjYABr/D9D/fwUm0bPXBl7jocqhhSlF65ho1AFJVeZdxv0e0mA9iPKeZNHV
 l2KF5yCe+tdswvr1NaMgCcjyVXhgg8I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1OCBTYWx0ZWRfX7CGxr86LEGAu
 R5AgZ12iVa8SvjnBi+qdDEk62qnc7cW0ThSlEV18fQGelrjEq8wkiuImGHqyg/DqtaYxX9RL6zL
 pxK+wIoBwVMha2Aj/NaxLMSVITkI+llvzE30NWTxg5Exa5A23KNhOH1RdtB1YUR72qIPQd9berg
 vsva2Y/eprRknC5wQEnZsxamqn1q5arhwJgxRwg3+NkMGYAealhIRyScnqqmFZIMOOdWUPlfXlu
 9BAXDddUVUN2NfV/sWDjCN6NnIwjp6qSdIBBmzWLkjXajgHey1NVDt4vLEX9xDlcr7/IST42vEb
 zJ7kAbdWOba6CmStpcnjfeCck9j4naDbOVE/ScNj7BsgpLFNI3jMUDxjChdH45aRSifUlmTCnlK
 +4EFv5t7H92fVjpXNdBWqTtC00bBbHwb5TUpd5MNSHIfdReuwEVqDR5pf5og0zGW7LZlJiRrxxq
 l5rZWw0OMgo76w5TnYA==
X-Proofpoint-GUID: Xrq3k6tPo0_Ox7zGn-MRImsobjxo_yEp
X-Authority-Analysis: v=2.4 cv=RoFQvymK c=1 sm=1 tr=0 ts=6ad23900 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=RkTp2a6IZlHrwnyeuDYA:9
X-Proofpoint-ORIG-GUID: Xrq3k6tPo0_Ox7zGn-MRImsobjxo_yEp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160058

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: ibmvfc: UAF and module unload crash due to untracked async work
> --
>
> commit e22506651b699f9db9776870465be492a807fad7
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: extend async event handlers for async sub-CRQ events
>
> This commit refactors async event handling to support both traditional async
> CRQs and new asynchronous sub-queue CRQs. It introduces a tagged union
> struct ibmvfc_async_crq_event to hold either event type and updates the
> corresponding handlers and FPIN processing logic.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 9c710897cd546..87ee19057551e 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -3629,14 +3711,14 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>>  			}
>>  			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
>>  			aw->vhost = vhost;
>> -			aw->crq = *crq;
>> +			aw->event = *ae;
>>  			schedule_work(&aw->async_work_s);
>
> [Severity: High]
> Does this code leave the scheduled work item untracked without a cancelation
> path during module unload or device removal?
>
> Looking at ibmvfc_remove(), it executes without flushing the system workqueue
> or canceling these specific work items. It then calls ibmvfc_free_mem() which
> unconditionally destroys vhost->tgt_pool via mempool_destroy():

This is the same issue as patch 4, and is being addressed.

> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_remove() {
>     ...
>     flush_work(&vhost->rport_add_work_q);
>     fc_remove_host(vhost->host);
>     scsi_remove_host(vhost->host);
>     ...
>     ibmvfc_free_mem(vhost);
>     spin_lock(&ibmvfc_driver_lock);
>     list_del(&vhost->queue);
>     spin_unlock(&ibmvfc_driver_lock);
>     scsi_host_put(vhost->host);
> }
>
> If the work executes after the target pool is destroyed,
> ibmvfc_process_async_work() looks up a target, takes a reference, and
> eventually calls ibmvfc_release_tgt(), which triggers a use-after-free
> by calling mempool_free() on the already-destroyed pool:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_tgt() {
>     struct ibmvfc_target *tgt = container_of(kref, struct ibmvfc_target, kref);
>     mempool_free(tgt, tgt->vhost->tgt_pool);
> }
>
> Furthermore, since scsi_host_get() does not hold a module reference, rmmod
> could complete while the work is still queued. Could this lead to the system
> workqueue executing unmapped memory and causing a kernel panic?

Also fixed by using a vhost-specific workqueue, which will be done in
the next revision.

-Dave
