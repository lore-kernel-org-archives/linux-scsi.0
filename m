Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C45FAD24;
	Tue,  4 Mar 2025 06:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741069728; cv=none; b=LUiWOq/GRdh1/2yr3I6F5mNoykbH2lGuI+q6Mb+z3wbaLyoKyf8CFFKTSuXVxD6qXHfhXzwlmDRVGUjycmOHy22xpZ5Vj/cr85If57Jpzq0vNrfMrO5RMYEe+Vw5DNqKpYaKMYyBDffr8Yhatz8yR0aaFIAZ1+jzlDFSuq7/OTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741069728; c=relaxed/simple;
	bh=iXpnhM3P98eFDZLpfSUky/aLJP6ToKZcH+ePpmoozuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J3QJX+z47PXRy6mfDgrjAuyGCeh0KzQk/rImfs7tQQMAV0P1yJGZS0ebNaWgY2adh/b/rt+cNok2HpwIGmowr58GVsWSs2K4pUHQ8XA2Sc5rH8QGb/DCXehFaQ/wNz9ltrW1ZIxow05Gbi2VHKV6VuzU5Dyb58dsSVkCCgJODfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O84e0bh8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O84e0bh8"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5243jobs021779;
	Tue, 4 Mar 2025 06:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cNUqlS
	orz0hTRYHCVAT6HlL4WN4AHcrWFBeNm6gRh/0=; b=O84e0bh8lAeRb2J7gJNmeH
	QFkDuo4sdUoGA9+3uo+BwLY/TTnNoXAlr072JzF4Fu/k1Ug/JcW2MTynGOBvY3Dm
	AW9lzlF43I8i/inIxVB3pWKEMNOzfyYLaDLR93T75mfL21Q68H781snqX37G/NxD
	UK7TAIu0a79gF0ZrmKB5myayiQ99eU19u6cRgspKj/2V06ueEwCUMk3UH93z0EIk
	CK4MPXfrub5RkMbx7Ymj0smLnYhFaIAUjGhzYHsfTUJUH0g65TF6QYkMZJrOxdHI
	Htf8VSj/gXCzVPN5zoaQAQjcv/2f1HSwfHsKtVws5ZxYgc9GCl/XsF7DnBE1MCtA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 455sw7gnq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 06:28:40 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52432CmR032219;
	Tue, 4 Mar 2025 06:28:39 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 454cjsv777-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 06:28:39 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5246SdWK17433174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 06:28:39 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F17DB58059;
	Tue,  4 Mar 2025 06:28:38 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9607458055;
	Tue,  4 Mar 2025 06:28:33 +0000 (GMT)
Received: from [9.43.105.169] (unknown [9.43.105.169])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Mar 2025 06:28:33 +0000 (GMT)
Message-ID: <9921ee1a-fbe1-4ffe-9490-5cd62714e3ec@linux.ibm.com>
Date: Tue, 4 Mar 2025 11:58:30 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] cxl: Remove driver
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fbarrat@linux.ibm.com, ukrishn@linux.ibm.com, clombard@linux.ibm.com,
        vaibhav@linux.ibm.com, linuxppc-dev@lists.ozlabs.org,
        Andrew Donnellan <ajd@linux.ibm.com>
References: <20250219070007.177725-1-ajd@linux.ibm.com>
 <20250219070007.177725-2-ajd@linux.ibm.com>
 <9190bfed-8ecd-4941-9297-a8b29c9c47f4@linux.ibm.com>
 <yq1frjttt41.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <yq1frjttt41.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TmI2lBxqPyPlv9udpqYAaqVg5ICVAWP6
X-Proofpoint-GUID: TmI2lBxqPyPlv9udpqYAaqVg5ICVAWP6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_03,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=482 mlxscore=0 adultscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503040053



On 3/4/25 8:31 AM, Martin K. Petersen wrote:
> 
> Hi Madhavan!
> 
>> This patch has depenednecy with the first patch 
>>
>> https://lists.ozlabs.org/pipermail/linuxppc-dev/2025-February/280990.html
>>
>> Which is already part of your staging tree. Can you please
>> take this patch along with the previous patch. 
> 
> If I merge the main cxl patch we'll have another conflict due to the
> docs patch below:
> 
>>> [0] https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20250219064807.175107-1-ajd@linux.ibm.com/
> 
> I don't mind taking both patches but it seems more appropriate for a
> major feature removal like this to go through the relevant architecture
> tree.
> 
> Maybe the path of least resistance is for you to put the cxl removal in
> a separate branch and defer sending the pull request until after Linus
> has merged the initial SCSI bits for 6.15?

Yes, I agree and I was thinking of doing it, but wanted to check. 
I will send a separate PR after SCSI merge PR. 

Thanks for response.

Maddy   

> 

