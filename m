Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A343137F8DC;
	Fri, 25 Sep 2026 16:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790353011; cv=none; b=ATcY9WFCS3b3XQEdojx2hNOfZ920wgmuZo5j1cwmZrSpT3lXPgpCUWBwhyNQPIBoszVEYzzxOAjSpq5egBs6M0WU19CXOXxTJI/SGq0M49UihwfBCb/OaS2ev2UEMbQ0XUkzhs5jOR6oXq448nGc01kDTWCcNI7cBtkOn17+TXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790353011; c=relaxed/simple;
	bh=sIryPOD3Cn3cBjiKLNSTwsPBF0lByXz9s1a8wiEpRCM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lcYeKDRZQglKy42h+FDihqNFejUoib8gUe0+gqpKjYQfibAUT3jA5DEByLVLEw6DOfCHMg1syNB/6T2MTr0r996Ig5nnCt9lTu+tAI4WtyUi2VaYcqXHl6622mY8+yT1fowNzWtOgu2B16KueY9sF2jwIOdjx2dWmBmdwwWnrCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tfrgofJ/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tfrgofJ/"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PG5tu91371936;
	Fri, 25 Sep 2026 16:16:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=UwoQ0JX5KoacIG5R72R9cBOYn/wcBx
	5VQebUk4FBJRw=; b=tfrgofJ/iM0ux5Lcv/o0wet7svvmCBoyJnRtz74mOaabJ0
	H/9UDX2SvSJTUqqn4OQcNly0WxBc0q0KvaGjpe9+u6M6KOdYaB99Guj1i1xkuiVq
	jtuGOiDzHrsNef1VIjfvJ8VBcFWQhWWYb3y9uXQql0oHPChR5/xEmnVL47agO6gI
	APwNT2ByUU6gtsviv7sHgPJwDuEsdtX+zm+S6AOHgPRl7ulyNuU74OoZjMkbuFOp
	3RM9W2nnI8vv0tZm5Kn7m/VnGCGtkWBzItUicST4v6l4VpKh5615Mo/ZoRNYJiY9
	GWFfFqvy3prCYbTTGUpAAPU9WZMBxuwEte9N4z4Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1y3cc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 16:16:46 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68PG3BEl2859686;
	Fri, 25 Sep 2026 16:16:46 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvu7ef9ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 16:16:46 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68PGGjkp32178820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Sep 2026 16:16:45 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B2CD58056;
	Fri, 25 Sep 2026 16:16:45 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2195258050;
	Fri, 25 Sep 2026 16:16:45 +0000 (GMT)
Received: from d (unknown [9.16.59.154])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 25 Sep 2026 16:16:45 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: "Tyrel Datwyler" <tyreld@linux.ibm.com>, sashiko-reviews@lists.linux.dev,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v11 04/11] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <20260925050305.6F20E1F000FF@smtp.kernel.org>
	(sashiko-bot@kernel.org's message of "Fri, 25 Sep 2026 05:03:04
	+0000")
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
	<20260925044900.414340-5-tyreld@linux.ibm.com>
	<20260925050305.6F20E1F000FF@smtp.kernel.org>
Date: Fri, 25 Sep 2026 11:16:44 -0500
Message-ID: <87tsnd1f2r.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: E0zKfwzd07Z_USLrgTNgw8LOcrzmmbOa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2NCBTYWx0ZWRfX0GacBzohROVi
 VvXYE9dkW+4iMbM+f8N95coAU1YT+z+gE8glLkOincMm868NYwE0z5a2TXZ8PWUbtgbUJWwj/pU
 RESZQTBmOqa5wzxQU7QkpgE9sAM7m4aYzUs47JESfQ89CbbjEjd8AUqyg1Kql23Bhj+KpkY9x+Y
 M0Mo+or0sH0mYK3H/Lbwx72P3iGGYKhMMiNKr/KCAQblnkyy1/2Zr7M83eNlOVDbF78m2AHOt9t
 KOoXlUzJ/pqZcfsuUwneG59RcyXjCZSDmxPDYtn5ZcveEX9G4AXccjrUe9KQWOPlG8IOb1Dk8d8
 qltw8ed346hiqIKbMjTAmxDGVg6IF/sogTGR0bXX1di9Wavd7/rKKlsHZmom7pPgcvaAyARHBMi
 fk+H4QcfDnwUAOL736z+RIxPlPzg6jDdPPmIzZof/9PjsXroCuwdsNxH0F5vxsk7KJs2JnR8t+9
 orJgbYbj7agqIEKuHQw==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab69e6e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=ELeJ1hq4zliZ-6f2ezEA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2NCBTYWx0ZWRfX+2KzbPdOHrTc
 Vjqcc5QvLQffZbhVawJd+rNiukMNuc07H7qRyh60IL+nCbK9YOv+tPCb4T9s+veCXibq3TbBD8p
 vPhXj0ysK9Rw0ezDl0M40knPIOwwtBY=
X-Proofpoint-GUID: E0zKfwzd07Z_USLrgTNgw8LOcrzmmbOa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250064

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] scsi: ibmvfc: missing scsi_host_put() in test success path
> - [Medium] scsi: ibmvfc: missing host_lock around ibmvfc_handle_async() in KUnit test
> --
>
> commit 29ab8a9a78c94679b8187ae357d2978336830599
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add basic FPIN support
>
> Implement support for a basic level of Fabric Performance Impact
> Notifications (FPIN) in the ibmvfc driver to enable monitoring of
> fabric congestion and link integrity events. This includes async event
> handling and KUnit test infrastructure.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> new file mode 100644
>> index 0000000000000..ec52285b0aa22
>> --- /dev/null
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> @@ -0,0 +1,149 @@
> [ ... ]
>> +static void ibmvfc_async_fpin_test(struct kunit *test)
>> +{
> [ ... ]
>> +	vhost = ibmvfc_get_first_vhost();
>> +	if (!vhost)
>> +		kunit_skip(test, "No ibmvfc devices available");
> [ ... ]
>> +	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
>> +		ae[fs].valid = 0x80;
>> +		ae[fs].link_state = IBMVFC_AE_LS_LINK_UP;
>> +		ae[fs].fpin_status = fs;
>> +		ae[fs].event = cpu_to_be64(IBMVFC_AE_FPIN);
>> +		ae[fs].scsi_id = cpu_to_be64(tgt->scsi_id);
>> +		ae[fs].wwpn = cpu_to_be64(tgt->wwpn);
>> +		ae[fs].node_name = cpu_to_be64(tgt->ids.node_name);
>> +		ibmvfc_handle_async(&ae[fs], vhost);
>
> [Severity: Medium]
> Does this invocation of ibmvfc_handle_async() need to be protected by
> the host_lock?
>
> If a concurrent device removal via ibmvfc_remove() sets vhost->state to
> IBMVFC_HOST_OFFLINE and destroys fpin_workq just before this handles the
> async event, could queue_work() be called on a freed workqueue?

Yes, this routine should acquire the host_lock before calling ibmvfc_handle_async.

>> +		ae[fs].valid = 0;
>> +		wmb(); /* ensure valid bit clear is visible before checking stats */
>> +	}
>> +	flush_workqueue(vhost->fpin_workq);
> [ ... ]
>> +	ae[0].valid = 0x80;
>> +	ae[0].link_state = IBMVFC_AE_LS_LINK_UP;
>> +	ae[0].fpin_status = 0; /* bad value */
>> +	ae[0].event = cpu_to_be64(IBMVFC_AE_FPIN);
>> +	ae[0].scsi_id = cpu_to_be64(tgt->scsi_id);
>> +	ae[0].wwpn = cpu_to_be64(tgt->wwpn);
>> +	ae[0].node_name = cpu_to_be64(tgt->ids.node_name);
>> +	ibmvfc_handle_async(&ae[0], vhost);
>
> [Severity: Medium]
> Is the host_lock similarly required around this call to
> ibmvfc_handle_async() to prevent a use-after-free if the device is
> concurrently unbound?

Yes.

>> +	ae[0].valid = 0;
>> +	wmb(); /* ensure valid bit clear is visible before checking stats */
>> +	flush_workqueue(vhost->fpin_workq);
> [ ... ]
>> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
>> +	put_device(&rport->dev);
>> +}
>
> [Severity: Medium]
> Does this successful exit path leak the Scsi_Host reference?
>
> The call to ibmvfc_get_first_vhost() at the beginning of the test acquires
> a reference via scsi_host_get(), but unlike the error return paths, there
> doesn't appear to be a corresponding scsi_host_put() call here.

Yes, this needs a scsi_host_put() call.

-Dave
