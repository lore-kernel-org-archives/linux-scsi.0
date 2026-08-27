Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945D0499F3B;
	Thu, 27 Aug 2026 19:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787858994; cv=none; b=cUStnzDFQg/I7xD3jtxaGQT9bDnBYnWduYml3o/LvfrnkR93R7eOz6n1ULb9rY9B+gcDSDUaRemAI0o47Sa4MO+aQ/a2WPkgeLol0ICZSpLX5nRKHY3Rw2obxg9dRacMmSayTrbM2cZlCs26IaiAnMNlUMQVETQUYhiqy5aFKJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787858994; c=relaxed/simple;
	bh=HakblkERuJ8lxUcZ1No75a/kXLlrNKrK0yRSRw1Fsz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TvfIn4nBcX+DCj2ir9VX7guGgn2nSF0eJhHn5QADWc5qoPe2pneB8WqKXr20veVOD/PD/E2W3tGO7RAFQ6fkeUXwqrvM6cZ+eiKo6W22RjtrDHA07m6WpBAScRIx637g6fNxZGOEMh9ahObTvWPzj5WbFJeg68JbOZPfXIxJLBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bne3dwsn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bne3dwsn"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RIVcCV3876912;
	Thu, 27 Aug 2026 19:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=S59u3T
	RnsKVWGoWTMHD50JnHRjTpgKKLIHcP2taOCtc=; b=bne3dwsnf80iDYIgrV5mWR
	yK6RHL+Xqti0MnuFPSUbi1UKcT5E2DLnaUSvppfOrfovhep/HHHfhGK4gVede6SP
	hFCDacKXGs/o+4phBMON0Eq2LmyQR9y1T8fIINBXmfrQcfJatsaPRkfSdMlAple4
	Xt9ioWW6HlikXrEeJEBQFlW+hSqOo2skfJDQqj4RXOwJruYpWPNDDjpw0wEqaGB8
	Qg6BXvZZqqF/+/T97rGh7/8FsCZESuDqKixP/xp35pLGoj/d1QFMI2RBldkwgG0T
	hGcu5hgqh1oJg9xODtX13ojVKpETdkdQqeAlpXb0DOGOkmDAU7joEv3gSEfB5Dzg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73dxq677-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 19:29:29 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67RJQcWD021730;
	Thu, 27 Aug 2026 19:29:28 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7rsyhp42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 19:29:28 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67RJTRdj51315146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Aug 2026 19:29:27 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F37F58053;
	Thu, 27 Aug 2026 19:29:27 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 640E058043;
	Thu, 27 Aug 2026 19:29:26 +0000 (GMT)
Received: from [9.61.79.161] (unknown [9.61.79.161])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Aug 2026 19:29:26 +0000 (GMT)
Message-ID: <b96e1cdf-bf10-464d-9fb9-5afc625d8984@linux.ibm.com>
Date: Thu, 27 Aug 2026 12:29:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ibmvfc: document protocol parameter of
 ibmvfc_alloc_target()
To: Muhammad Falak R Wani <falakreyaz@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org
References: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
 <b073968ae020b6ae0240e91341a92f428587ebd9.1787828961.git.falakreyaz@gmail.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <b073968ae020b6ae0240e91341a92f428587ebd9.1787828961.git.falakreyaz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDE2MSBTYWx0ZWRfXzlWOBqC9HRUO
 ++8bm4Puiev9eabSGcxJ4pLaVVP4fIdg60N0LwqB5e2Il4IMIssuaQ5uEmsefsq/0PgfruA097A
 /63KZXCeH7bpkaQZOQn8QVdhCR8hB4g=
X-Authority-Analysis: v=2.4 cv=AYuB2XXG c=1 sm=1 tr=0 ts=6a909019 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=xP4I_6v4Ii45Jom1HAIA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: VA61OV9oQxz5OlhCAXktmQ5nW6BdwtE5
X-Proofpoint-GUID: 1sVxm5x9ea8oTlMhMr8MewCaWL1plwGh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDE2MSBTYWx0ZWRfXw6MNoQrSvALG
 lcXHZ7kMcY1Z2CvQ4LSR2mBFjBcjYlQnX8fZGYESmQtr3bQA0kZgeAAba0KCtTsprQ6YPKdrlhz
 0MzpU+ZtQepip7L1ISIHR/Gvt++SoJbPAuglWR5+mci2smj4lwGWznEvSUcNPrCfvZh5WTbCRjF
 +gZDS9R/2WqQrsOZZdKfffN1weHIlEmgEb0Ps8LGJWeVuZ14X+Yksc1+UMWU937I7zhLc6uYAAs
 1Vz62LTmlqZ52cVj3eEftdyV2U1WwJ2HVvzhum7PH7tgFDFNp+qmE9529Wp06yDp7UENmiBpmaS
 OLKUPhHQQs64/qCSyTsBZ+63C825/GMThTBsaz8kYyTa/dxNA3w8s4x+DQLuyqg7iA5VDp4EC7E
 UOlapKTa5uO1tEC+iJ1wQyn6PZknhFkX8G0Te1ErLvi1nBJZ0wt4gvmW9AwfbfQCg/y+++fYuYo
 n1qoe4jg+M9jt4GwLkQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608270161

On 8/27/26 4:20 AM, Muhammad Falak R Wani wrote:
> Commit 249313b3f7b5 ("scsi: ibmvfc: allocate targets based on protocol")
> added a protocol parameter to ibmvfc_alloc_target() but did not describe
> it in the function's kernel-doc comment, so a W=1 build warns:
> 
>   drivers/scsi/ibmvscsi/ibmvfc-core.c:4996: warning: Function parameter
>   or struct member 'protocol' not described in 'ibmvfc_alloc_target'
> 
> Add the missing parameter description.
> 
> Fixes: 249313b3f7b5 ("scsi: ibmvfc: allocate targets based on protocol")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202608270829.lHI1FAdO-lkp@intel.com/
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
