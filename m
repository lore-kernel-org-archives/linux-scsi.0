Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C644D9571;
	Mon, 28 Sep 2026 14:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790604717; cv=none; b=ccVNSYCM7scZiYENLfo0bQ9W3Cn7S8GxGAacQ7IsL5p1QaC5vM+JHwQxbNUaTwK+zWKepALneEYgDT9MelzzNAXbsWB32nYhbzwk5a9ZNFKeYSPMRrHKwMCJqKEPbNkcH3Ys1iKHDgNGcH4n04+3d4XfnHcRldfL56e6TA8KlqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790604717; c=relaxed/simple;
	bh=2YRvEUrI5hwdkxAO4NWvX7lP5Y7hFTMB6g6IqcXKYbw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mD7tkSUos+e+Lb9zuk0VVz5xaf3On+Cszcz9n4B7kz+CZy95p2iju488+agoM9GqiyqTgvX0qs6B4/kY3c6r337omS9o+ERUYeOVWzJYg9R7EEmlyzhNkI00blG7mi07+EanDZOy6XIiJTnCmRxdLVf2rUMQvjwG0Lmp68GvBh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gk2FLQrb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gk2FLQrb"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZq1o3971552;
	Mon, 28 Sep 2026 14:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=f9QPaXFvkxSOFBxop1oKvpq4LVuhBv
	awOLd9eOd/GII=; b=gk2FLQrbhsTHOco9GDVQmYF5GCzxPAtx4+VIoiZOUxlzDc
	Sn/ZtfeL8XcnTsuUhiwg0Hu+fFhuUAknV5ijScIsfHfOEybd9lhrO+iYh+V2g2Dq
	IRXuZtIeIvKhEnj9AGlsMw17nMDVjEYVVNlkLaTuZ0Al4lCpgsL7dnMR69CtRGnn
	LLYazWnJ8wLYJ3je/wG3NXBjFxS5ckgguCIqqidRyUiErcz7MpmleELDG/YWtAc/
	XGQDGNJe8lD4MLJQOq+maGo/KZobAML5XtCmhwAPBOTKb7xcSTJgsV5l1W9Bu6cw
	SzD6C43GEtkAvu8MlBmRtjbuFhXw62KCvvjlsODw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx4fe1gu7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 14:11:53 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHZwM2943238;
	Mon, 28 Sep 2026 14:11:52 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxtkg5bw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 14:11:52 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SEBqVY4194966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 14:11:52 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9A1A58053;
	Mon, 28 Sep 2026 14:11:51 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B99258043;
	Mon, 28 Sep 2026 14:11:51 +0000 (GMT)
Received: from d (unknown [9.61.160.252])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 28 Sep 2026 14:11:51 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: "Tyrel Datwyler" <tyreld@linux.ibm.com>, sashiko-reviews@lists.linux.dev,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v11 04/11] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <87o6dl1e59.fsf@linux.ibm.com> (Dave Marquardt's message of "Fri,
	25 Sep 2026 11:36:50 -0500")
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
	<20260925044900.414340-5-tyreld@linux.ibm.com>
	<20260925050305.6F20E1F000FF@smtp.kernel.org>
	<87tsnd1f2r.fsf@linux.ibm.com> <87o6dl1e59.fsf@linux.ibm.com>
Date: Mon, 28 Sep 2026 09:11:51 -0500
Message-ID: <87pkxx5uu0.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=FYWiV5+6 c=1 sm=1 tr=0 ts=6aba75a9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=9iKCkZftw6WeuuriitQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA1NiBTYWx0ZWRfX/qYbXinUDpJe
 QZcxTtksMMieks2LPK2WC3vvX5/GlxvqNcaga9WeINGUWD1af8FlXVnYlYDLaYomMZZJENPCmMI
 K5BBcTmWJZEIOoice6IMuh4rExWKQ6M=
X-Proofpoint-ORIG-GUID: 6Lj4mi7Qg0RQ1Rr8KRIxsKsUkSDTNuSz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA1NiBTYWx0ZWRfXw4dVCMWnPPl5
 S6s68i9ZUXkBIln2abW7+sxczro5NC8/5AzhuRUGMENbPeGbpD2QI63q0Th5iJtr2STZTAmxdNc
 /UBy2YDudS+N84n7gx04R1ci0O7BXLrNUuiqrd3lcXr1ZgBoxH8Z/tXjnCeSDUlpQXdU25pWl2O
 lEvWGCyOI/WNt0UZYGiBWFVQgf0i2JbXLVR6CIMEUvVFJjaql/TOsm/k0kkfJPbmJp8mrJvx5Rv
 EMOu1TxYzergNStb6gitopLMbWxMIR7Dq4xpkRhN7ceMfxL1KXg7yNUl1ZxTlMiohY4k2QGcH1J
 cGsVodwSdm3XZOF5//133lfQIj1P70LkooRJBfSGovHnG2uwtiynucviwUsrOhcIRUjr9T5sJRq
 alcsGXKuvrR8BTmVJkrKe1YpeSi/aTRWK+CCMdPTIFCTiwyS8SQt2VchVjnpSnQzRdasn2I8+HB
 8pvIDtbdaYFx0jSqlpw==
X-Proofpoint-GUID: 6Lj4mi7Qg0RQ1Rr8KRIxsKsUkSDTNuSz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280056

Dave Marquardt <davemarq@linux.ibm.com> writes:

> Dave Marquardt <davemarq@linux.ibm.com> writes:
>
>> sashiko-bot@kernel.org writes:
>>
>>> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>>> - [Medium] scsi: ibmvfc: missing scsi_host_put() in test success path
>>> - [Medium] scsi: ibmvfc: missing host_lock around ibmvfc_handle_async() in KUnit test
>>> --
>>>
>>> commit 29ab8a9a78c94679b8187ae357d2978336830599
>>> Author: Dave Marquardt <davemarq@linux.ibm.com>
>>>
>>> scsi: ibmvfc: add basic FPIN support
>>>
>>> Implement support for a basic level of Fabric Performance Impact
>>> Notifications (FPIN) in the ibmvfc driver to enable monitoring of
>>> fabric congestion and link integrity events. This includes async event
>>> handling and KUnit test infrastructure.
>>>
>>>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>>>> new file mode 100644
>>>> index 0000000000000..ec52285b0aa22
>>>> --- /dev/null
>>>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>>>> @@ -0,0 +1,149 @@
>>> [ ... ]
>>>> +static void ibmvfc_async_fpin_test(struct kunit *test)
>>>> +{
>>> [ ... ]
>>>> +	vhost = ibmvfc_get_first_vhost();
>>>> +	if (!vhost)
>>>> +		kunit_skip(test, "No ibmvfc devices available");
>>> [ ... ]
>>>> +	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
>>>> +		ae[fs].valid = 0x80;
>>>> +		ae[fs].link_state = IBMVFC_AE_LS_LINK_UP;
>>>> +		ae[fs].fpin_status = fs;
>>>> +		ae[fs].event = cpu_to_be64(IBMVFC_AE_FPIN);
>>>> +		ae[fs].scsi_id = cpu_to_be64(tgt->scsi_id);
>>>> +		ae[fs].wwpn = cpu_to_be64(tgt->wwpn);
>>>> +		ae[fs].node_name = cpu_to_be64(tgt->ids.node_name);
>>>> +		ibmvfc_handle_async(&ae[fs], vhost);
>>>
>>> [Severity: Medium]
>>> Does this invocation of ibmvfc_handle_async() need to be protected by
>>> the host_lock?
>>>
>>> If a concurrent device removal via ibmvfc_remove() sets vhost->state to
>>> IBMVFC_HOST_OFFLINE and destroys fpin_workq just before this handles the
>>> async event, could queue_work() be called on a freed workqueue?
>>
>> Yes, this routine should acquire the host_lock before calling ibmvfc_handle_async.
>
> So, the host_lock is taken early in the routine and held in this case.
> I'm getting mixed messages in my research on whether return or something
> like KUNIT_FAIL() is required after kunit_skip(). I will add return
> statements.

Contemplating this a little longer, I don't think any change is needed
here. I think this is a false positive by Sashiko. Is it confused by
kunit_skip() calls?

-Dave
