Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B25C3C9EE9;
	Thu,  3 Sep 2026 07:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788421575; cv=none; b=QEOIQaBTk/UrWcRZP2s6ELKdYjp4cNAaBPBAIy/d52YlnYZakJRzMONz6nHnDTSJ3EsLEwVDdLjD+ZgrcNdYUsKbe7QrlitAY497PWO/36EcwvCqWzu74igiUhyovbpBOoadhcBDSDP2KDdboedn5NKzjYJhav1pJoEQXR9lZ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788421575; c=relaxed/simple;
	bh=TusS9N1RR7He/Kk9YZXjKMBjbTd6i5U/DANrCr8zito=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dDCrHU4uC9d0KPVW5zS2JCrA3o0coLT4io40x6ChuDP2aLGKuoZb5ktr53xW7T1PSswHivBpea8y6Q4RGSo5sDMUAnaXWUWKsv5BSkiEzFpPI3iIUufB2i9V9dv+OUzIFSpitXomtgSXtZO3ZAXaC0xYAARS62De8n43xtYGICc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TSlU0VVE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TSlU0VVE"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68361ecM2239326;
	Thu, 3 Sep 2026 07:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7f2Wki
	fVw0NguaifgmPtUXuEgHUauSvNBua3tTJ+apc=; b=TSlU0VVEOYZvXLfjWYV8Oa
	HAVJ0k5OVz6Xe7WtELfQ65d7sEz+FNNVJ/8tXoyULUfL9rgSbcpTTqTGaf0fYbhg
	QFjrGh7XhiIclcRsj17T9uKRluGDv8ScVcuJBg+lgFPDMsZ+vzaA+eplEuMsnTIe
	xGxEgZ1jAbnIm3jKkSEEQynbBOPl7YXHZ8rVwNkxHqeTT1UiykVZVJVwDACJ1KYJ
	dQSFnHw1iQP+vpNgfa34d5nwEUXej31i1sfc2JmwA7Wt5EahI3ihF5TD9YaT4wKO
	VPDGBHY8eu6bjPmHCdfX+SIWDHGu9ANs7KQkWT64GB3CXu8D9LtZx84to/rwg3dQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq2tk44f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 07:46:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6837fLDC028596;
	Thu, 3 Sep 2026 07:46:07 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gecjaq03q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 07:46:07 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6837k56s30212708
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 07:46:06 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF30558054;
	Thu,  3 Sep 2026 07:46:05 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78DFC5803F;
	Thu,  3 Sep 2026 07:46:03 +0000 (GMT)
Received: from [9.61.240.230] (unknown [9.61.240.230])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  3 Sep 2026 07:46:03 +0000 (GMT)
Message-ID: <b9f8c317-f919-47f2-8988-e57e22176a82@linux.ibm.com>
Date: Thu, 3 Sep 2026 13:16:01 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scsi: ibmvfc: Add Kconfig dependency on NVME_FC to prevent link
 failure
To: Tyrel Datwyler <tyreld@linux.ibm.com>, pavrampu <pavrampu@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        brking@linux.ibm.com, linux-kernel@vger.kernel.org,
        davemarq@linux.ibm.com
References: <327877a29337aa526cc50ac88fbddb86@linux.ibm.com>
 <afd6fdc7-0fae-4fcf-b30a-a69294d26576@linux.ibm.com>
 <9873559a-59df-4f4c-b653-6930636096a6@linux.ibm.com>
Content-Language: en-GB
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <9873559a-59df-4f4c-b653-6930636096a6@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=bc1bluPB c=1 sm=1 tr=0 ts=6a9925c0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=gCSP5jI7dXej6UQmhssA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDA2NiBTYWx0ZWRfX9jLg9A4OksDW
 XLvMiPP3ON5x+lQ2s4+SG9wYnSQZyXphFPQYG8ZGaQMtpBxGQahEfM8eV39SYlg/l4cLj5kPvbw
 6wrizuOvcRq1BTSESrCFnckZQ3tGSJI=
X-Proofpoint-ORIG-GUID: rLt_s67DKpB8sDS9buZinlg1K1nrPOmZ
X-Proofpoint-GUID: rLt_s67DKpB8sDS9buZinlg1K1nrPOmZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDA2NiBTYWx0ZWRfX+Pg0Dmh3W035
 /O4BFQ2PBsHDaNJ6Vs/rvt83WF9Y40i8yRDEjRrWg9jLsqqyFV9xCACSaDNYM6lFOGdso0kS90I
 AN/5KOgafIVvWNYxfm9/QOWQ+Uyw9HBW5KQ5IpFshQgLbf5mdiPLJMet2bXZT6pmJF1wSQHqbhx
 pmRiRGY+kVR44jhD/eO+F9ByqweQczD2iV8njE65nXReE5cuNlT5hJnj/Mug9wiwGehSQDKdtYK
 p2V73G+PULTk3ugnWCuW1feLiHgwtCEWWDqRSwYYXZwv1QPzhv2tjIyxcSEKvtC4TkxDIvX8NVU
 E9N0GvL5J+eTcUHf89GPYHVLRLqAQVociBqvVRiqfXZ7bHNEqM1awR2w7YGSFattxKuc6RNFPI/
 6i6FAQZHpwnA7mVWkV1DdRpxQNnOTFACfe8TA1z6JScQ7I6qFFSWFg9kXiLfDCNXiZCUPQO5x6n
 TULLHzmYpj77PpcDcyQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_02,2026-09-02_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030066


On 03/09/26 6:57 am, Tyrel Datwyler wrote:
> On 9/2/26 1:40 AM, Venkat Rao Bagalkote wrote:
>> On 02/09/26 1:55 pm, pavrampu wrote:
>>> Hi,
>>>
>>> I am seeing below build failure with latest linux-next repo.
>>>
>>> Description:
>>>
>>> Building the kernel with CONFIG_SCSI_IBMVFC=y and CONFIG_NVME_FC=m results in
>>> a link failure when building vmlinux:
>>>
>>> Build failure logs:
>>>
>>> ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function
>>> `ibmvfc_nvme_register_remoteport':
>>> ibmvfc-nvme.c:488: undefined reference to `nvme_fc_register_remoteport'
>>> ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function
>>> `ibmvfc_nvme_unregister_remoteport':
>>> ibmvfc-nvme.c:515: undefined reference to `nvme_fc_unregister_remoteport'
>>> ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function `ibmvfc_nvme_register':
>>> ibmvfc-nvme.c:536: undefined reference to `nvme_fc_register_localport'
>>> ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function `ibmvfc_nvme_unregister':
>>> ibmvfc-nvme.c:565: undefined reference to `nvme_fc_unregister_localport'
>>> ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function `ibmvfc_nvme_unregister':
>>> ibmvfc-nvme.c:565: undefined reference to `nvme_fc_unregister_localport'
>>> ld: drivers/scsi/ibmvscsi/ibmvfc-core.c:6798: undefined reference to
>>> `nvme_fc_rescan_remoteport'
>>
>> Below simple check in Kconfig fixes the build failure.
>>
>> If this is acceptable, then I will send a formal patch.
> Yep, need to force ibmvfc to be a module when NVME_FC isn't builtin, or NVME_FC
> must be disabled.


Thank you for confirming.

Link to Patch: 
https://lore.kernel.org/all/20260903074329.6705-1-venkat88@linux.ibm.com/


Regards,

Venkat.

>
> -Tyrel
>> # git diff
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 4a2af0f702e1..6612d5d445e2 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -753,6 +753,7 @@ config SCSI_IBMVFC
>>          tristate "IBM Virtual FC support"
>>          depends on PPC_PSERIES && SCSI
>>          depends on SCSI_FC_ATTRS
>> +      depends on NVME_FC || NVME_FC=n
>>          help
>>            This is the IBM POWER Virtual FC Client
>>
>>
>> Regards,
>>
>> Venkat.
>>
>>> If you happen to fix this, please add below tag.
>>>
>>> Reported-by: Pavithra <pavrampu@linux.ibm.com>
>>>
>>> Thanks,
>>> Pavithra
