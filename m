Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C665E647;
	Tue,  7 Jan 2025 09:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736242174; cv=none; b=UMrL/ESNGWGDJ76K7OCT/CvKPMcq3A8JyZ9FE3MZ1tk0CqUhETm0QkgfpYKVlFYPws5TDmWD7wyXY73dI+lTOGud/cH3X9c6pYEAb7AvxDjCPshwhXnOgIzKKBebH6SRF74W1FnqOSo1H9r7+6mn99182llbxbhAadk1DCBLTik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736242174; c=relaxed/simple;
	bh=T8BzQOYXclOcKeGV1/DFl+dYNUefautWJLzlqdUkeqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rk1kD6Nt+nmAW6HUpwLR6V4Wi8K4noaRVhdlIARRJw4yub3yvCXHgGpDGmY3dmuL9RAHbiMoLfrNMIAWzk/L62s2EkYt5WXM28AFAtQKiYaYpWg8LvQmkLk14rG9D5TgQR1hGc8CwvRbGc9y0Gdcu5bp4Td+P0V5CzKlTnRPAuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o10GpuTN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o10GpuTN"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 506NaH29007319;
	Tue, 7 Jan 2025 09:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Nqt19L
	jA7V6SFxJ3HfBT8AU+vaazARI3YF1sz5W0Vfg=; b=o10GpuTNcyBlukFrThp6Bu
	K7cw3v/Vrlj73CvrsSZm2+vFHwXOhAnQ3E7CAYuctevI9RhUD227dedNlMs0Fj9h
	E38Hr5bVaCEOVah+5/XxYOSQJ6hKnhsgnkNWiUEN7pQxbcEBDXZvY9vgXjYyY01G
	0KgpmF/SscNVW+0jCx7k2Psz3KT+LiNgnUcZi6mDbxGn+sY6sv9ocWiUOrofZ6O9
	NVUjkwkHfwrvh0Wi2xO7DfYr3Vkz3cAdfceezw3iMZCpFOaNRS72cD2qIPNXpZNn
	PW2AWss2+Uqafkn7pplBoL8cyzaUnVKM/lWWrSaWIt9Y0BWefAGPQhzHTBLOazpA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 440s0a9yn8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 09:29:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5075lY9X027963;
	Tue, 7 Jan 2025 09:29:19 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yhhk1k3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 09:29:19 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5079TIOr23855864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Jan 2025 09:29:18 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDFD458074;
	Tue,  7 Jan 2025 09:29:17 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9A9258056;
	Tue,  7 Jan 2025 09:29:14 +0000 (GMT)
Received: from [9.109.198.241] (unknown [9.109.198.241])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Jan 2025 09:29:14 +0000 (GMT)
Message-ID: <de4159dd-d0c8-4638-9c2f-c2d4fd1c64a6@linux.ibm.com>
Date: Tue, 7 Jan 2025 14:59:13 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] nvme: fix queue freeze vs limits lock order
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, nbd@other.debian.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-7-hch@lst.de>
 <96c48ba0-3db5-4504-a456-e57440aa1b56@linux.ibm.com>
 <20250107082224.GB15960@lst.de>
 <263963d9-ac40-4f87-b38a-edb4202d294c@linux.ibm.com>
 <20250107085825.GA16827@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250107085825.GA16827@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EwIytq_W9xmRz7cg4BLBWcJ2PsLco0gO
X-Proofpoint-ORIG-GUID: EwIytq_W9xmRz7cg4BLBWcJ2PsLco0gO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=753 lowpriorityscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501070079



On 1/7/25 2:28 PM, Christoph Hellwig wrote:
> On Tue, Jan 07, 2025 at 02:15:05PM +0530, Nilay Shroff wrote:
>> The nvme_set_ctrl_limits() sets certain queue limits which are 
>> also used during IO processing. For instance, ->max_segment_size
>> is used while submitting bio.
> 
> nvme_set_ctrl_limits only sets them in the on-stack queue_limits
> structure, which is local to the calling thread.
> 
> 
Oh yeah, I didn't notice it while reading patch. Agreed, we don't 
require freezing queue here. Sorry for the noise.

Thanks,
--Nilay
