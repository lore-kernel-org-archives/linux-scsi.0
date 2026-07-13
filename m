Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1C933BBB1;
	Mon, 13 Jul 2026 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783960019; cv=none; b=OZ2qTce5SP9up+TjY+Y7q5xtMfeMd7YMGeU5JzOHne9aaXhOIxUdAN4IqWMibBzaWBhcMnHtG63oDu9c0dv+UTc+uszyjs3VgsyxMnAVfREgcevR0Zjvf0OxlOVCy13oSlVdmLEy9zU3lVVN6LjkmqBsTNyyUIlQTEobDzqjWhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783960019; c=relaxed/simple;
	bh=rmN/MIwCrtKt1JNedWCAhlBxBZDM3RDo/fAVpqbb/oc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LL6yQv8EjlfPmGxd/od9f+YRUuW0T51eTC9mSgNUTTWQTaVwFa23ZCMlSS8RlxSbdt+sSfKzlmuMswa+259GJ3JbTUT9QL+bMDRG0aSR8cc9Z9cIYS96D0p5IWHsuFfsyYjMDbxGJ4P1Ih3fc7EFjGrmJJbS/hIR8SpG7NtAAt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kA5fwkCR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kA5fwkCR"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DFEFD4953913;
	Mon, 13 Jul 2026 16:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7955c4
	I3vp022l/ik6C3QsYjOlR4y6dlTg0ovoSXVKk=; b=kA5fwkCRrmS2854N+6lHwx
	z17Mb5BU5X2UYE79fXTAkL19lS0jpFoAcV3DpLkut3dTfYQZn/ScohjvFl/eVVkA
	YltFTzmtyVVGOa2ecuh80JO3UUty2hhKlP2y5HsxkoLnc/BODo7izPPlh0zZebPa
	H+8fw8T5v84tMZPktaVnkewJSIdAk844xF+8BxkuJrPmuRo/sP1+/Zm979q+JW9G
	izrnhUMONijY9LLAFWLuB/MXZBs/tU2IJ+Jw2IJZqiLyXxg7qFABbWpj9J2z8rjZ
	K280VlnQfjKI9zU4gzgZ+DVXw0JTsgroaQbrDb2im4Y3rkXb6ogsrAgwsCYqMq2A
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fcv3327p9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 16:26:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66DGJhLk009857;
	Mon, 13 Jul 2026 16:26:51 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fc05pxrve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 16:26:51 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66DGQovN65470774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 16:26:50 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0266658063;
	Mon, 13 Jul 2026 16:26:50 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EEFC58056;
	Mon, 13 Jul 2026 16:26:49 +0000 (GMT)
Received: from [9.61.176.127] (unknown [9.61.176.127])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 13 Jul 2026 16:26:49 +0000 (GMT)
Message-ID: <3f8f6510-5751-425d-bb61-59c46565dd9c@linux.ibm.com>
Date: Mon, 13 Jul 2026 11:26:48 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: lpfc: Fix race conditions in ELS retry handling
To: Paul Ely <paul.ely@broadcom.com>
Cc: Justin Tee <justintee8345@gmail.com>, Daniel Wagner <dwagner@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        thinhtr@linux.ibm.com, Justin Tee <justin.tee@broadcom.com>,
        James Smart <james.smart@broadcom.com>
References: <1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com>
 <CABPRKS_Ek4JHDs9pBg2nium+AjHhM_JQ8su1=vrcOg+xME7PjQ@mail.gmail.com>
 <3cf79f92-a492-45f4-838b-dcbef0a44147@flourine.local>
 <CAEQnVQmMfc96nWdC+0UA=vUrhHPSK38=rg+h3742AHTWD9qXYA@mail.gmail.com>
Content-Language: en-US
From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
In-Reply-To: <CAEQnVQmMfc96nWdC+0UA=vUrhHPSK38=rg+h3742AHTWD9qXYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDE2OCBTYWx0ZWRfXxhssL3LWebp2
 0eBvRySy9+AxCNnW/5sSPEToONt3MbLJjcaDose6SwRBQajOOkfGT/9VSnXO61Mv/XeZBx08/ep
 4CvHhkmyU4/H0SQrN8aIsHZqXQP/0Fo=
X-Authority-Analysis: v=2.4 cv=Mp1iLWae c=1 sm=1 tr=0 ts=6a5511cc cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=KneAjnFcxKRnfvGyJi4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: YS3E9nQSXLxPZfyuLr_po9y1LiIM1SpF
X-Proofpoint-ORIG-GUID: YXb5uW4rpbWj7larwl46SctMTeVmUEIN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDE2OCBTYWx0ZWRfX8QhbcRZi2QRD
 gq57J2+j8x715ZWbTNsAmZI1+flJosa3P/rPmfvsRHfbTCLtTgGNFtu/fW2j5Bt7fIze2b6i3jB
 8aQ6RcxyXgY3iSzd0u5DjMI3acqe02+n3+B83+o8SVHwJpqb3ZU0hMckoB0i0NMgFPmeKvu5uQT
 hm7mJ3J5XgTPXYKkaFoo//JihukMLA/Hzf2Tu4YAuPWWF6gvHFnAt0xkDUONDz69Dkd45/dSOjp
 T1LXdGgHSiTjz04Kgkwa0Vf/AvOcZZIwXYtooCjD7IseLbGzV68wpTzc/SIrprz5PDNL4G3Zc3d
 TOA1JEBgDkp92xwYqOTrrFPD1jXW1KA5FkH8jRLQomK4IluSSbV1FkQgxZgKOLnM8WQyZA2VJwr
 CtiGzf8xxuZTFY825fjYpK6xPx2QEbGuAiyJGvnmFp4kcl3MiiU1xhB+2ZrFvTDCS4hL928N3X7
 NED62Zg3OhgaOX+yRjg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_04,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130168

On 6/18/26 8:39 AM, Paul Ely wrote:
> Hello Daniel,
> 
> I have been testing Patch 1 of 3 for a while now but no reproduction.  I 
> reviewed Patch 1 of 3 yesterday with Justin and we think it needs some 
> minor rework.  

Hi Paul,
If you have a reworked patch I'd be happy to test it.

Thanks,
Kyle
