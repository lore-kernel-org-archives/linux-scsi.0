Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE3D53AC;
	Tue,  7 Jan 2025 18:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736272932; cv=none; b=YsZOXKbElYVABSw10Vi11u3+bh4KnisFQkDIer8a7D8/hIXFxa4suu9fTWDxoE7IGjBgoRayMCU1tHlN/ql1isMsG3ZbY6etyGhMTg57OYizgJCSWniRmai4Z1mNhcl2sfeuPrZz10s8jOyGN0b97819YVe3k8fnRpR/hTyvOM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736272932; c=relaxed/simple;
	bh=WV+TLZuDtrq0vN0L2SGNhb5nPcib4hM5tam8yfuu2ms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLqvmQA6OGfqcVKBzqnDuO+mkjoeDwrAyGPe8evMYUVSyM72sIVzd2rRm2HMRPbI85uZIPn3+YAPV/RUUsCxi1DKHE0b4JtLtQ6n7abPfdzTCgYVx0PMAMOVxQEj+1JwiuyI0KVpSYntvWSNC35yMXBQEeInHggstfmQ4huQoDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S2EYkqwx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S2EYkqwx"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507CcGJ3022197;
	Tue, 7 Jan 2025 18:01:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WV+TLZ
	uDtrq0vN0L2SGNhb5nPcib4hM5tam8yfuu2ms=; b=S2EYkqwx9tCL88zQ45J2OG
	diJT4/dnc2r0QZ3C9WLzmaR5ytuHdMAZFR1wWsqXp7zX6Htc7RldV31jpRWhXkfv
	L3wuYzDHusMf1vXlFg/55GH0XRqQZTWwkMqEEKm7xUHRVLgc2sx2w68S/vQuMG4W
	IsCMSwOzmCCSogG56gXnUzCHoCG1DICbwTifSyu2TB3G1LyhIOXnqm3QsPNMsH+g
	sfzGy12hz5jtjTzHqAPdIGcn20+L11M2kWv0v6jQn7/5CjNmEYjPUIdI5vl/KfWs
	/rFqo88004C+T8dNONoNDdgJitHYrOupO/p6G8A4vv+2ZfIiEP36dZIAyfBqXC+Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 440sahmgws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 18:01:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 507H06UW013571;
	Tue, 7 Jan 2025 18:01:55 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yganur2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 18:01:55 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 507I1spI31523424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Jan 2025 18:01:54 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55E1E58056;
	Tue,  7 Jan 2025 18:01:54 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88C3F58052;
	Tue,  7 Jan 2025 18:01:51 +0000 (GMT)
Received: from [9.171.94.59] (unknown [9.171.94.59])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Jan 2025 18:01:51 +0000 (GMT)
Message-ID: <f78a6a82-27f9-45b2-91a9-0ebac2fc06d9@linux.ibm.com>
Date: Tue, 7 Jan 2025 23:31:50 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] usb-storage:fix queue freeze vs limits lock order
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-9-hch@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250107063120.1011593-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2EY8dbR70v3t7uGmYqbyCiAkb9NHESTC
X-Proofpoint-ORIG-GUID: 2EY8dbR70v3t7uGmYqbyCiAkb9NHESTC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=462 impostorscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 suspectscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501070146

Looks good to me.
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
