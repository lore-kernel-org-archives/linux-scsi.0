Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD5B39B95D;
	Mon, 16 Mar 2026 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773669882; cv=none; b=kGQzKIlIsgN0iVkz5ALDftNXLFSfi9gPhEidu8LSdkeZrlM4eE9R6l9Mz+vkWV0v/8NI6MUjZhc5p/4AylMyXyQpyyCKgfYQl0DGw8wuWL3TKF+VlYIbg0MN1CCd4wbQm91fyftxLZ0YxAyzC+WSA3tuirz3mxL8vAiwvhbdnRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773669882; c=relaxed/simple;
	bh=mPy27bcHbJYkQHRhzRTcD2juq8WeYLtVss7554Ec/UE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pytwbgEkVhRdD/nFkya498QfytWHSN7ci93TAdq1xvO03FZO71kJI658otESszzvOLqg9LAKrcXPjQuIyxuj1c3D4cPJ4USb2hz+c7g4rE/9VZ7xtU7jrt+vyHhIyOIQa9bxuMEmLwneYebitLfIciVtlvTw/cLsT2Bh/yowvNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=p7/jnTAq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="p7/jnTAq"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FKtSYV737432;
	Mon, 16 Mar 2026 14:04:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=9GcvlaVj9JseoW8iTrTJv7aIB+ClD6
	Y7tN5Boz9Tvt4=; b=p7/jnTAq6McYJRa71Va47wxR26Qh5f3gWp5pirsmD/HNlQ
	Wypmojdz0/wOQVIPl+sdpChIQ57egOAkWVWOqi9VgJ6isw1aajJFLomKIhryUut+
	vTIFnX725LAbrvpUEuMf2zEg83d1eHQxnIRrYVbMk3TrHfhn/Xp4n6uJEiNLJ06X
	G8vgW+84ixRR7A7fkmmHdRUUTfKMegKkqLNTRo5exWCyIeYCD0ssng21EgVlxelM
	6nN1KGqkWX5gCmm6yauV3ZcA3/FJucWwsjZmn0rGOvWLIy2WcXCKF6pKnkdoH+2S
	2NpibWPu+TQKd+LgzhL4Bt3fYw4FBCdDLtLEBNQQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvybs05rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 14:04:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62GAU3Ad028753;
	Mon, 16 Mar 2026 14:04:25 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwkgk51v6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 14:04:25 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62GE4OaA23462526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 14:04:24 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83E605804E;
	Mon, 16 Mar 2026 14:04:24 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E57B05803F;
	Mon, 16 Mar 2026 14:04:23 +0000 (GMT)
Received: from d (unknown [9.61.72.10])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Mar 2026 14:04:23 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Tyllis Xu <livelycarpet87@gmail.com>
Cc: tyreld@linux.ibm.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, brking@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, danisjiang@gmail.com, ychen@northwestern.edu
Subject: Re: [PATCH] scsi: ibmvfc: fix OOB access in
 ibmvfc_discover_targets_done()
In-Reply-To: <20260314170151.548614-1-LivelyCarpet87@gmail.com> (Tyllis Xu's
	message of "Sat, 14 Mar 2026 12:01:50 -0500")
References: <20260314170151.548614-1-LivelyCarpet87@gmail.com>
Date: Mon, 16 Mar 2026 09:04:23 -0500
Message-ID: <87ms07euqg.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=MMttWcZl c=1 sm=1 tr=0 ts=69b80deb cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=F9OWliIrSa7ykrEN07sA:9
X-Proofpoint-ORIG-GUID: EolokV-Vn9u9N0e0P5MBrHTxebThJoAo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDEwNCBTYWx0ZWRfX6qZN48idoYCz
 +T+i5GZSEFX4wpcE/wUK2D5FN+Lnca6h2/vV9WhLvJoFjRKjnuLqdeLXeSXsNuhTGO/21n3Ck3U
 lgXNnONiAjAbUiwYQJxhTROx9Lt8G+2WpgO52dGcnTsJIbYoSwuiZmGHkNc28Ia5ZIQWKPU/evS
 9t+vKMHY+ZjyzMbCOCjy6iWFSSRv7TMLajH96WzqPDeM17k50we67uqGYu/N4xK3GU/sfBMa39B
 6rBjO6P2GY8u7469NMhRQeXpwi7l7SD3BbM0s/+y5jWHIIrMLK5t7NGsP10VLu6DNWGo2UF7a3L
 LJbNmHE/6MVNKxdsHLQa1lUKA9lEsK2Rf/ApOdk94jCU23M5HG+8BwQRu56DEBZ7k6EnWynLnvM
 KP1lxf/U2Fy579DCZak1GKK68TlSmXat0M2wZaRwx/wgg71mDHIyvzqVO1NKVC6PHLn6zj/eshi
 OY2a9BcxLyoL7dABVww==
X-Proofpoint-GUID: 1CWs5HVzl9OknVQy9i86GexwQpW1usNI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0 clxscore=1011
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603160104

Tyllis Xu <livelycarpet87@gmail.com> writes:

> A malicious or compromised VIO server can return a num_written value in
> the discover targets MAD response that exceeds max_targets. This value
> is stored directly in vhost->num_targets without validation, and is then
> used as the loop bound in ibmvfc_alloc_targets() to index into disc_buf[],
> which is only allocated for max_targets entries. Indices at or beyond
> max_targets access kernel memory outside the DMA-coherent allocation.
> The out-of-bounds data is subsequently embedded in Implicit Logout and
> PLOGI MADs that are sent back to the VIO server, leaking kernel memory.
>
> Fix by clamping num_written to max_targets before storing it.
>
> Fixes: 072b91f9c651 ("[SCSI] ibmvfc: IBM Power Virtual Fibre Channel Adapter Client Driver")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index a20fce04fe79..3dd2adda195e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -4966,7 +4966,8 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
>  	switch (mad_status) {
>  	case IBMVFC_MAD_SUCCESS:
>  		ibmvfc_dbg(vhost, "Discover Targets succeeded\n");
> -		vhost->num_targets = be32_to_cpu(rsp->num_written);
> +		vhost->num_targets = min_t(u32, be32_to_cpu(rsp->num_written),
> +					   max_targets);
>  		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
>  		break;
>  	case IBMVFC_MAD_FAILED:

Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
