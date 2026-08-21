Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EF3331EA4;
	Fri, 21 Aug 2026 15:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787325210; cv=none; b=rPpRyVYHzG0ygIav8P57PCgzKZ/0jr1j8XEjtrB2tfXygBExWAkRbBHGKZ6IGpiJBnJktYjx8ZBndK02n0GTv1LHu0IF1LmeowZOLxSAsbT0gtEAeldeCnXnDLSetWqlGyQCJfqgvbRp7GJ8OJOMGg46LM6jeYet0qs2jRYgXjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787325210; c=relaxed/simple;
	bh=9Hr01kZ4gUwoBCSaSAdMX9wlbnucoyuNEl5iG2JZn1I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qSQB78e3LxgJ1uBXjNcK4nnBjj11E1RRTNwOBE8MTdvT+Yi97LYTM3lZeN5vwHu1w83a0oCzgf7ssqonalMm3VbX5T3ohS6PKmqAQuhM/6USgbIAVeP1L5xPs28KWGtl0LdyyapVOI68RLEfM8BeNf6KATJ75IESVGG4lLltNsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sQJr4s+u; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sQJr4s+u"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LD1V8P1530471;
	Fri, 21 Aug 2026 15:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=kL9+7oxbnYphS6GdcDQD1Q9a1I38ys
	9Zi1DKifjNquk=; b=sQJr4s+uMwWM/XpQ6kFKZV96Yg/wKpX9UGoaM/xs3/qPhA
	pc8hg3SL0XjoVpCQpNjxjYwHHlGkl0LqOORXQAs3YN+ErjmrJFxZ315ALHKlO9F8
	w1WE8eJLt+ta7M7q/omm0RxMMrWfWxYjA9L5lonppTYbTnTaJTFUpMTLBTKBsclp
	49Jxkv0nPS33t35gf8mgl3h9CemqQmbQE2B51x0aui7ebUVArCY0RNRSDfG5L3kr
	Ss+d0QH5XMOVCzA3jHj2O0iOWTkCbWxWE3KnPnP2hrYl08xRKp6c6pQic72+gO9v
	MXAKcRF4uWqO1LaLs7elK03C9AtXSD+KaC8BEzCA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu1t880-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:13:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67LFBFjh007798;
	Fri, 21 Aug 2026 15:13:26 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354yw2rg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:13:26 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67LFDQpK29098530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Aug 2026 15:13:26 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 214C45803F;
	Fri, 21 Aug 2026 15:13:26 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E24C35804E;
	Fri, 21 Aug 2026 15:13:25 +0000 (GMT)
Received: from d (unknown [9.61.29.95])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 21 Aug 2026 15:13:25 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 3/8] scsi: ibmvfc: define asynchronous sub-queue
In-Reply-To: <20260817203902.5DEA01F000E9@smtp.kernel.org>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
	<20260817-ibmvfc-fpin-support-v6-3-62a2d525e70d@linux.ibm.com>
	<20260817203902.5DEA01F000E9@smtp.kernel.org>
Date: Fri, 21 Aug 2026 10:13:25 -0500
Message-ID: <871pbry0a2.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=LsCiDHdc c=1 sm=1 tr=0 ts=6a886b17 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=UGRm_XtBAX8pSzKkes8A:9
X-Proofpoint-GUID: 0qJJ9QSW61pDUXBin6owHt6FjfSsZcPm
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX07Is/xBEXZC7
 fAa57hOehywKTCZmy8cbg1zfy+MqS+rEAb/vLF9qTaczVPzkVfV22WrXWEalkJoihbSILNgkD/6
 unHzosisHBnVDUFKZelZ7xMNILaUN+I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX37PmRa4olSYk
 hZyuH6yNycTSLyoCjM4Azm5ikSvxvC5rpZ8g1zePuEe1Ki6q25i2a1SdWV8Ww7cHFp5WsiDmw7r
 dlg0qOn5ERZXCW8rqg1x4OP/6rz0ahYgjIKARxZ/AMvmWw+NOY18OJHvZn3WcM6TzFp3dfnfm5O
 CiR2Vk9DF8+7Qoa7/0d4Ldvnx34t6xwHDp0PtBZojJVMH/8MAhX0waqz+Oqoau+uiq1ZLQlVMGK
 pHpgiubepWoO0cvuJYZhURRuyDhEQnfoFwW15n3LrCpnbIt9XS9K6A7fOti5DxYKvhEijxf6YfO
 ALoPgcMx5iU+v6FUiLAZIwVdzSONx5URGXL3v+BIlBf2ffFLrBcWufrBIuiQvKWx26xiqYIC6Vo
 QbMd/56y6cywIAUPjjivPDjM6CXIBvqDOZGwincSEsj290SDkQBQc4oxHfyHYh1IJAgghkua3iQ
 MMLO+htlWKfNmDZyW7w==
X-Proofpoint-ORIG-GUID: 0qJJ9QSW61pDUXBin6owHt6FjfSsZcPm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_04,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210117

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> --- Patch [3]: [PATCH v6 3/8] scsi: ibmvfc: define asynchronous sub-queue ---
> commit 4682ac13b0e9a18a4a0d6bd0390528a5ffb87d23
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: define asynchronous sub-queue
>
> Define data structures for asynchronous sub-queue support required for
> full and extended FPIN functionality.
>
>> Add ibmvfc_async_subq structure to represent async events received via
>> the sub-queue, including FPIN status, link state, event type, and WWPN
>> information.
>> 
>> Update ibmvfc_channel_setup structure to include async_subq_handle field
>> and reduce IBMVFC_MAX_CHANNELS from 502 to 501 to accommodate the async
>> sub-queue. Add async_scrq pointer to ibmvfc_channels structure.
>> 
>> Add capability flags IBMVFC_USE_ASYNC_SUBQ and IBMVFC_SUPPORT_ASYNC_SUBQ
>> for negotiating async sub-queue support with VIOS during login.
>
> [Severity: Medium]
> Are these changes missing from the patch? The commit message explicitly claims
> to define the ibmvfc_async_subq structure, update ibmvfc_channel_setup, reduce
> IBMVFC_MAX_CHANNELS, add an async_scrq pointer, and introduce several
> capability flags. However, almost none of these structural changes exist in the
> actual patch.

I missed rewriting this commit message after updates to integrate with
the recent ibmvfc NVMEOF work. Fixed in v7.

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
>> index e8ca0d30f483f..d8880d02685b3 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
>
> [ ... ]
>
>> @@ -990,6 +990,7 @@ struct ibmvfc_host {
>>  	mempool_t *tgt_pool;
>>  	struct ibmvfc_queue crq;
>>  	struct ibmvfc_queue async_crq;
>> +	struct ibmvfc_queue async_sub_crq;
>
> [Severity: Medium]
> The commit message claims to add an async_scrq pointer to ibmvfc_channels,
> but only async_sub_crq is added to ibmvfc_host here.

Right. Also missed in the commit message. Rewritten in v7.

>
> [Severity: High]
> Does the adapter removal process introduce a NULL pointer dereference
> during teardown?
>
> If an FPIN async event interrupt arrives during the adapter removal process
> after destroy_workqueue() is called but before free_irq(), the interrupt
> handler will schedule the tasklet, which executes ibmvfc_handle_async().
>
> In drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_remove():
>     destroy_workqueue(vhost->fpin_workq);
>     vhost->fpin_workq = NULL;
>
> Then later in drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_crq_queue():
>     free_irq(vdev->irq, vhost);
>     tasklet_kill(&vhost->tasklet);
>
> And the tasklet dereferences the NULL fpin_workq:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_async():
>     queue_work(vhost->fpin_workq, &aw->async_work_s);
>
> Because vhost->fpin_workq was destroyed and set to NULL early in
> ibmvfc_remove(), calling queue_work(NULL, ...) will immediately panic the
> kernel.

Yes, fixed in patch 1 of v7.

-Dave
