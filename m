Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB16B137C26
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 22:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706136396; cv=none; b=tYQtu1UDhw1uZf/y7QpfARxAyo4jtzdWofyxlx1ClInqynjdPrwCia+SD3LB/t5OzrGuEyFDa0LhWUh9ms/jlJZHHWCa/QzssEejggnNWWjkO/NwPGE7LEvgTO3SoM1mOoPUFkGi+PkIHF2ou5c8sA+SFSRM3jopbeG+wYnjV4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706136396; c=relaxed/simple;
	bh=4+zOn5/03uHCCfmxGYKUzR/qMs9xjzTYtAbhi+cBdB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nenoy7ZS5H4vXxLNQ2U1QCM3vY6ah06PhxSQ2Uu4io+w/8AGdV7clNex2B+3M+Ssjb5o86FjWBlsXZsWjWp+dQa3gpKeucyery1qvHMVN7Mk9pQvZLyaj+beu9CMEx4+bcQkyE/ZklcaVUZANck1QMajr2Mf39bHAifLKHs/b1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Pzz7kB3z; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Pzz7kB3z"
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40OMbKrB027356;
	Wed, 24 Jan 2024 22:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tjQp4v2r1Ciawh8ZHuTxi0uApvQ6KrdrzDLoUZi1mDU=;
 b=Pzz7kB3z21jMxicxZSFC/KMPbitg/7VSXpu1jrwKka0bD9ET2jvXI5JDf792ixgWzGp9
 osaal2djeG/6PLJxOy0NaeBPyAsDGZZE0L6uWdm0AfqeHFPRSGwLEoonj28nHCwlvM50
 hZjVMN0FqpY8cUr3xE1ctr0mkHgj6Xur2+D9X1oAredaHN/CRDK1bl9b4NRzUN7am66C
 Tn6OOW5H6XaLA/YT6lWLwInnNNAKe+XrMfc9kq2dgZwek0P738+DdS4eCVwDDRRagbG5
 InqnVgBe2ZS8oyJs3rb8AHA+gn2Q8Gncn/zeCmo7Jn2kwal5//hEHTapXijjvsgIjs3L tA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vu9aub9xv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jan 2024 22:46:27 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40OMgrwQ010352;
	Wed, 24 Jan 2024 22:46:27 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vu9aub9xq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jan 2024 22:46:27 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40OLUOSV010861;
	Wed, 24 Jan 2024 22:46:26 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vrrw00ysg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jan 2024 22:46:26 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40OMkQDF45679040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 22:46:26 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B4C558056;
	Wed, 24 Jan 2024 22:46:26 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9ECC5803F;
	Wed, 24 Jan 2024 22:46:25 +0000 (GMT)
Received: from [9.61.2.55] (unknown [9.61.2.55])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Jan 2024 22:46:25 +0000 (GMT)
Message-ID: <c665ba57-92a2-4d6a-adb1-4c3222de5f38@linux.vnet.ibm.com>
Date: Wed, 24 Jan 2024 16:46:25 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Update max_hw_sectors on rescan
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, brking@pobox.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, michael.christie@oracle.com
References: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
 <ZbDXV4u17fcQHwjN@infradead.org>
Content-Language: en-US
From: Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <ZbDXV4u17fcQHwjN@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XEe0JEcwCWuxnc0rf6ERe8id4ykMVt2f
X-Proofpoint-ORIG-GUID: xvDwamIJk_loPwKa_uOMhAGWqLpLrRmV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-24_10,2024-01-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 mlxlogscore=986 adultscore=0 bulkscore=0 clxscore=1011 spamscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401240165

On 1/24/24 3:24 AM, Christoph Hellwig wrote:
> We can't change the host-wide limit here (it wouldn't apply to all
> LUs anyway).  If your limit is per-LU, you can call
> blk_queue_max_hw_sectors from ->slave_configure.

Unfortunately, it doesn't look like slave_configure gets called in the
scenario in question. In this case we already have a scsi_device created but
its in devloss state and the FC transport layer is bringing it back online.

There is also the point that Mike brought up in that if fast fail tmo
has not yet fired, there could be I/O still in the queue that is now
too large. 

To answer your earlier question, Mike, if the VIOS receives a request that
is too large it closes the CRQ, forcing an entire reinit / discovery,
so its definitely not something we want to encounter. I'm trying to get this
behavior improved so that only the one command fails, but that's not what
happens today.

I suppose I could iterate through all the LUNs and call blk_queue_max_hw_sectors
on them, but I'm not sure if that solves the problem. It would close the window
that Mike highlighted, but if there are commands outstanding when this occurs
that are larger than the new max_hw_sectors and they get requeued, will they
get split in the block layer when they get resent to the LLD or will they
just get resent as-is? If its the latter, I'd get a request larger than
what I can support.

-Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


