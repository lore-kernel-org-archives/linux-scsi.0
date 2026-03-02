Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405173161BA;
	Mon,  2 Mar 2026 12:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772455748; cv=none; b=hTQ1sKNiSUUssYoY+jAi7RXJTkmLULY+Nd2+puWrcBCsKhEl0CwNLX62eyDWvkmn9FX4QWLt3Y2/cJQUudaw7fXZpxko6vI5AzGquP5A4zTifOnajhXoV922m5ecbzK1MRRqrxx06xT2H+5/uhsvT8JSOEksom3snbpcCjVbm8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772455748; c=relaxed/simple;
	bh=s35JJacV491PB1nRkT7qxya0wsEMKEf0z9R87MG7xFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tjD4YbMmwXjUeSXgWFWVFOFnJ4vKh9lIC7CT+AlZA9Mer/Y1VlG4XvJhLzXSode/v5IaCbygjtyZ6KbreErZsZycfrR4Jh9rpVKtlTJvNTo4sCpW7wSk1ETozjZ+QsiwxYoWCYIg7O5Oa1Jds7IvRgnEb+HbygkHMdIdSrkQGwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FMZ0GxTH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FMZ0GxTH"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621JuGwe2134901;
	Mon, 2 Mar 2026 12:48:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=S6a8y8
	thvqGz68SdposE1yh0zGtQahWh18yyJBA8xJY=; b=FMZ0GxTHK2jxJCNBNbdfnS
	tp3ucp/9AHoLl9jeh5GWEN+X83wmHBpzNI5Rfhw1Cie8nQqXUIVhh9m4fAnKIOn/
	VsfNAcMsdAfkeL875U7Goveq34Gc21nG3x0TVSuylp2o3tcCFIUkHSc53IpGlX2k
	RETJ4qx4uYrqMwiYWa4+jn6uGTz6GHIBUAPDpKkuCCQ1YpxpNqcektcV1rIXSYfa
	efe5nOPuOIIRYSQ7npufcAQOrxQWPzqS4zPSpc/Mafl8rYk0I7/eH3oaOH6ywFER
	bBKK/+vNiFOCORWiesjIBjLmqGwJj/nEmw74SzqoG66sNbanyZq1WNX1ia+W0Myg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksrhxkr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:48:50 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 622Awdoc008779;
	Mon, 2 Mar 2026 12:48:49 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmdd15sy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:48:49 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 622Cmmcr26346072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 12:48:48 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B21158051;
	Mon,  2 Mar 2026 12:48:48 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5F165805C;
	Mon,  2 Mar 2026 12:48:42 +0000 (GMT)
Received: from [9.79.192.112] (unknown [9.79.192.112])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Mar 2026 12:48:42 +0000 (GMT)
Message-ID: <82090fb6-7cdc-40e0-98a7-21b688aaeefc@linux.ibm.com>
Date: Mon, 2 Mar 2026 18:18:41 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/19] nvme-multipath: add nvme_mpath_{add,delete}_ns()
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
 <20260225154007.1033735-17-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260225154007.1033735-17-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Rp/I7SmK c=1 sm=1 tr=0 ts=69a58732 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=yPCof4ZbAAAA:8
 a=ugQ3dgLpbsxIGXIanpkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwNiBTYWx0ZWRfXzEalYYr+61kH
 etnmA0zGnnv7vfemNVr5hqvxHgj46JKMkOF8Yf4BV1FKQwiEsNwEnNwR80FaaqGYLJEuvHQN39F
 A/FKlN0MxYg0X1cUa6pKeXJvTc6viNHKzhC5qKIDoL0nJhY7b/oPo7X4SpdHNtM+qEF3/tD/ExZ
 3OK37ZLPcz6ql0I6SKl1rK2xjEGLVUkVn5kuv+eNfr+jhU0yA7mwHbZR/OTAswuuTi0+tMfHTyT
 JKBgapU3KkLNWUWE/UfiL2UP8eL3nbA6/v40kW2IafSlm2W1m5zj8xw0OxQC3jgLnkQD19VSgOk
 wLnWZula8cG1IQCbdaYGna6OMFfl1d6NEzjJNpmUAvJpwh3HsJZNtwdlLVrPVpoHCPT33J6wtmT
 e3kvgns0n3WtpNV3P9Uiu1AN4CzlmYhZW7hHETi841lrPHMlxMNShswwiEm/99syhdQxJNuHcrR
 y4lCqEKD6xFutzonw9Q==
X-Proofpoint-GUID: vnYz560JBUrvbE9RhXT8t9DlHlRiTd_H
X-Proofpoint-ORIG-GUID: vnYz560JBUrvbE9RhXT8t9DlHlRiTd_H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020106

On 2/25/26 9:10 PM, John Garry wrote:
> Add functions to call into the mpath_add_device() and mpath_delete_device()
> functions.
> 
> The per-NS gendisk pointer is used as the mpath_device disk pointer, which
> is used in libmultipath for references the per-path block device.
> 
> Signed-off-by: John Garry<john.g.garry@oracle.com>
> ---
>   drivers/nvme/host/multipath.c | 26 ++++++++++++++++++++++++++
>   drivers/nvme/host/nvme.h      |  8 ++++++++
>   2 files changed, 34 insertions(+)
> 
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 7ee0ad7bdfa26..bd96211123fee 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -982,6 +982,32 @@ void nvme_mpath_synchronize(struct nvme_ns_head *head)
>   	mpath_synchronize(mpath_disk->mpath_head);
>   }
>   
> +void nvme_mpath_add_ns(struct nvme_ns *ns)
> +{
> +	struct nvme_ns_head *head = ns->head;
> +	struct mpath_disk *mpath_disk = head->mpath_disk;
> +	struct mpath_head *mpath_head;
> +
> +	if (!mpath_disk)
> +		return;
> +
> +	mpath_head = mpath_disk->mpath_head;
> +
> +	ns->mpath_device.disk = ns->disk;
> +	mpath_add_device(mpath_head, &ns->mpath_device);
> +}

As we have now reference to mpath_device from struct nvme_ns
then why do we still maintain reference to ns->disk? We may
want to directly access path device disk using ns->mpath_device.disk,
makes sense?

Thanks,
--Nilay
