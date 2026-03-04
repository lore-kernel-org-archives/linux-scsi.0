Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB89282F17;
	Wed,  4 Mar 2026 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772629888; cv=none; b=WgDERuAJGmjtww7K8gumXYH2pR316tCkam+hDTxfXM0jRH68En2vtGMSWkX/xcDH5CXrRKHdHfJeDwSgsrT1MJgOcYBjMW14mEhAxEvkslYy5JStrgOHyFuvaAPokcn47LYHj9OOJndqdSq4PVM1ZFtLMsVnvfBU87x5tfkHbK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772629888; c=relaxed/simple;
	bh=8CQVbZhvgDEerj7hpjqj+mgqxQVM5P1qrl9uzHGXzhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W4S7Jkc04Zip9TBSNjlol5yjhszJgmGir7lsIz+Gu+7oSll/bWSOpoIBbjprRQHndtt3fnFy6gsZVyE0Jj6pUdhAT2sVNgihX+qb0jP0LPYm0pu48vf9iPO2BD9mK+9lPufewW240LmdljbemJSH2GtV7XARd0nmbKNjt2hwxn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h3r7OaJO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h3r7OaJO"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624CSMtH2021490;
	Wed, 4 Mar 2026 13:11:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=uqJLKJ
	wpEhz8qK4MbW7QESrzLNSyj+3jTip8w/7IyDQ=; b=h3r7OaJO1ts3VC2QEvUPzF
	gnucWd10yDnTJFzeBhfJ9fwKHu6k0UaARXrzb9ALUHzQIubHX7ymytRxSrs3+0Nw
	CqhHOUkSDjDp8MDdvneAYUoUMjuquUILelu1XFp5VHPEWPdqz1VjjjEtB+t2DD3d
	/MQ7unT8+zQXHq4FUfJmeOdpHY+hAXGj6YjPtQUJDAueVLRIdtwO+F9E30BleOtU
	GThXLlY9NuNC5OulxoIHfrF27aYTPyrzuDSCMD+Os4o9kAoocyk+K6ZzrgopIVa1
	eBcBgvxJUpXdQZxW3/CEybCpjw9LFbQbgE+0mYfOAANZDOnJGihyveeK373KqloQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksk3y19e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:11:06 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 624BdcjQ027692;
	Wed, 4 Mar 2026 13:11:05 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmcwjefeg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:11:05 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 624DB5IR18416304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Mar 2026 13:11:05 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 272665805A;
	Wed,  4 Mar 2026 13:11:05 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74ED55805E;
	Wed,  4 Mar 2026 13:10:59 +0000 (GMT)
Received: from [9.124.211.174] (unknown [9.124.211.174])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Mar 2026 13:10:59 +0000 (GMT)
Message-ID: <93696b95-7c01-4988-8fe2-baf427469f4f@linux.ibm.com>
Date: Wed, 4 Mar 2026 18:40:57 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260225153225.1031169-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Aaom7RQJ9fQrig_94ibNusALFS6MxUTI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDEwNSBTYWx0ZWRfX5GdPTBXG37lh
 obKehUKoCQlVUGZyUcfC/SdqLQB+cSi+1P1ob56lr79kjlAiXD4OcWk1CMWTcW9NQp9Yh9QdDEb
 PGKfWiZYziTXUe1PNoIe1ilM2tIOjHuEgUqzwr8EXwp5dn/mdhuUEC1c6idtJwp0TQ+P4m6sIDz
 18dFdPjt+ipaG+nuf3YjwDvUfB9TjU1IWuXWrs6sVG516JhlWsPZFKZsKQejWM0pzgir2+mj8FN
 alHrf/+iTfpQIMBTzmjJUXhRnd4VHyi+QhhWIwn/xwHYMVclX06Yjf9zqVozLCQZP2Bw9gRl7Es
 G2B0Bv2UCja8vqveqkhfkZKlyXSKcWJwesIT80xzZvRqOqcxfzcthHRZeJEDw4eJJ6EdZmG6cqO
 gsuaoofWMQ185sG5VqST6cBcCywBEn/+OOvO3S+OTojNVzi1VC8Q9ePihcQ8LMQuVcH9CoLg9r/
 E+C31FDrk4tl1+qhvZw==
X-Authority-Analysis: v=2.4 cv=csCWUl4i c=1 sm=1 tr=0 ts=69a82f6a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=DxhCtTx9tnWbhxYo0-8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Aaom7RQJ9fQrig_94ibNusALFS6MxUTI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_06,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040105

Hi John,

On 2/25/26 9:02 PM, John Garry wrote:
> +static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_head,
> +			enum mpath_iopolicy_e iopolicy, int node)
> +{
> +	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
> +	struct mpath_device *mpath_dev_found, *mpath_dev_fallback,
> +			*mpath_device;
> +

I think we should initialize mpath_dev_found and mpath_dev_fallback to
NULL. Otherwise this may lead upto adding a junk mpath_device pointer
in ->current_path[node] when mpath_head->dev_list is empty. This may
particularly manifests when a controller is being shutdown and
concurrently I/O is forwarded to the same controller.

Thanks,
--Nilay
