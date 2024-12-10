Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2843F1A0BD1;
	Tue, 10 Dec 2024 15:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733844563; cv=none; b=oowCvGGqWSpzOFLqk0bdGCjvGF4xfGjhxV3m7D/3sRCRAU9PlLfOqXP1decBgyGO6MalJJ/VcOzeNVXXrfhS/XGNvqD6EFJQQhBssIuOjxlNvim275qhMort/+jrhxQ+yxWO5RoxzqnuMjj5+P57DrUyveTSZ5MDrwv+K+fx3k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733844563; c=relaxed/simple;
	bh=yNzybAo1CgsPHB6e0xFgwg1pUgNHTBFa4FZssFroosA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSISvwjrE8ZQ8jqW1B4WKHVw3eLs4LQ0xV2DoGg4vNDQu5sAwYKbvyrjNq1AtOnW0Rn/AGwb5gFoDIk6WJhanlXS4j74fkZOD9mdR3GQ8w3IaosItBQ/vE3eV5d3AojErORxyH9fQpQh9z/gXjSCGHvs/lyqGfb1L56yNyQkh9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LPZ5OBF+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LPZ5OBF+"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BADrd9U009303;
	Tue, 10 Dec 2024 15:29:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fFiHhP
	Wccpkjs+zB4a+vGrFniwRBOHqpcWiahmMSLz4=; b=LPZ5OBF+ud+cbmE9rRxEJJ
	zpZ2OmpNNwYg0nPXA9VlhENiODanI0I9lIFaJ8PMLSbyLJcoJ8OwURiU2x+YrWHP
	4C70o6h34vDCUIaK9wlHz2W3JWDCME1fXmg59J72bIvBkjpkjeM3WfioidUZSUB6
	g2IKb+lc2GtnrSAxUtbNDFUNqE2wYs+jVbn/BXmOuovKGmgU8MdQPUDLEXdblUd9
	6B2OD34UxfSKeLjXxa7egMZp9Pf4W1HScI6Cy7HhXSnyMNoqnkGK145yhPkg6yjY
	3wpKjNAWQi3a0gvNeHtDXZvKYSpyDmV72gswGboMIlSMy2K8jGqjCMgaPyw1t4hA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce38qw6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 15:29:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BAF1NG7016944;
	Tue, 10 Dec 2024 15:29:15 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43d12y4cp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 15:29:15 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BAFTARM63963574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 15:29:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 160DA2004B;
	Tue, 10 Dec 2024 15:29:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C2EBF20040;
	Tue, 10 Dec 2024 15:29:09 +0000 (GMT)
Received: from [9.84.194.138] (unknown [9.84.194.138])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Dec 2024 15:29:09 +0000 (GMT)
Message-ID: <2cf0c159-5f29-4098-8fb3-47be4eeea37e@linux.ibm.com>
Date: Tue, 10 Dec 2024 16:29:09 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] cxl: Remove driver
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ukrishn@linux.ibm.com, manoj@linux.ibm.com,
        clombard@linux.ibm.com, vaibhav@linux.ibm.com
References: <20241210072721.157323-1-ajd@linux.ibm.com>
 <20241210072721.157323-3-ajd@linux.ibm.com>
Content-Language: en-US
From: Frederic Barrat <fbarrat@linux.ibm.com>
In-Reply-To: <20241210072721.157323-3-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tNZaKKi4QEPnxiSxu1Cz3pgPmbQ_ncPR
X-Proofpoint-ORIG-GUID: tNZaKKi4QEPnxiSxu1Cz3pgPmbQ_ncPR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412100115



On 10/12/2024 08:27, Andrew Donnellan wrote:
> Remove the cxl driver that provides support for the IBM Coherent
> Accelerator Processor Interface. Revert or clean up associated code in
> arch/powerpc that is no longer necessary.
> 
> cxl has received minimal maintenance for several years, and is not
> supported on the Power10 processor. We aren't aware of any users who are
> likely to be using recent kernels.
> 
> Thanks to Mikey Neuling, Ian Munsie, Daniel Axtens, Frederic Barrat,
> Christophe Lombard, Philippe Bergheaud, Vaibhav Jain and Alastair
> D'Silva for their work on this driver over the years.
> 
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>

With the understanding that it would be merged (at least) one release 
cycle after 
https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=436003&state=* 
:

Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>

And many thanks for doing it!

   Fred
