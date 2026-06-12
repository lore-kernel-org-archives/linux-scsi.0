Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EADF3644C6;
	Fri, 12 Jun 2026 23:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781305930; cv=none; b=AtmqSRyWvnPlNlaMKblkY2HoOPqcL7+mcm4gGOoRMWjePyvZq14aCueL8kq4GKSvBkxmggRluyXg0bcFBmfX5b2j3k2JX3lMpAnASRAriiTtp64VO2OkAr7U0GQuey0QHMqO+4MIO3af2MS4S6Jhro01cKx18J7i3IbVi9tSG1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781305930; c=relaxed/simple;
	bh=qhIWZwDDuDWB2OEBZXnjxyJknODG3ClGhSgN1hxlEhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BKtJdvl/C5A3ADM5fv91a+2MPAaXMqWYzJqpeco+uTy2Yr9EOZuIPXtLhMDB5EoPmVpUrnU5w47REA075xDeqYF/wNHESg1/Vhks9HNBwL9KhxW3Yo2MrbEcT19pZ16FTz15gH3FEotFlT+QTrpr9lPioDtMf6MoN50RjOeZb9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ak+J8iSv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ak+J8iSv"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65CGK190722204;
	Fri, 12 Jun 2026 23:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XN2+Lv
	+Bpsdrx7zggvVnqXZteIICRqidIKpH/qtqCBc=; b=Ak+J8iSvyKcrEFPBMhfIDM
	YmZtEBY4cSeCZuAlh8xf5cPI4VG7rLjkEyOHcimKt4iEKRx0Fu0WRzVShZr6vBxm
	b12z1BQ1ZgjCqzTxX7RCID1CMWWHJohI2RBpOVkKcaqrw1dgJgZybxNF41uGSUeC
	k5B5kCYTrrfU6eXJbLTA7cv6QskX/ne0rNbHya0x085lZl0B0uy9S0bug3qfJVI7
	3bn6AIA0rCdFeSpxpKRoESX5+OxEnMYD6L9th9+DAuCvL+AvpJx5zC8gY+jZk0tk
	4VVpz92bIw3QUv5StZu9YCQnC2yf0ZlCwmV5nAb2878u9c/SnW+w68Ex6q6g2n4g
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8dkdv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 23:11:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65CN4ZM3032256;
	Fri, 12 Jun 2026 23:11:54 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4eqe0aa1je-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 23:11:54 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65CNBqje33292988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jun 2026 23:11:53 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D12D75804E;
	Fri, 12 Jun 2026 23:11:52 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B5F65803F;
	Fri, 12 Jun 2026 23:11:51 +0000 (GMT)
Received: from [9.61.160.241] (unknown [9.61.160.241])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 12 Jun 2026 23:11:51 +0000 (GMT)
Message-ID: <bfb7ff08-e4ec-46a2-b368-12d5c77f0ee4@linux.ibm.com>
Date: Fri, 12 Jun 2026 16:11:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] ibmvfc: make ibmvfc login to fabric
To: davemarq@linux.ibm.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
References: <20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com>
 <20260608-ibmvfc-fpin-support-v2-3-d41f540fba5c@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260608-ibmvfc-fpin-support-v2-3-d41f540fba5c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDIyMCBTYWx0ZWRfX30a1uCGgXRb0
 qUbqHu2cdSeRywaflWXHobQUOhAbzGhPuR03LDyK4Vw47w23lA7lg1R6r4MS+NhZFvINsiay/3t
 krGWMQIkmuC43DaPuaHAPNiG9SKwhfU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDIyMCBTYWx0ZWRfX6MioWJsnb8Fm
 TiC25s6c/s0RMw4GJLrjAkJH8EU2XBAE9tNEWOSXxhqgL58hpbwqJSqAiWQ3QG6n0c5m3EAqO1D
 3IJUiGSHKkrrX0g8MVY2xUenm7QDFV/6DXKSuOO/OJgHrQSsjyhCclNLiWPM/e6xKAf2EB2pH1+
 2L9mVQGvio6RTnXqaRAvQZKCeoGpUa0G9rX/T6Rj7MO+KjnrhiN5BQnUPtJqFoHldJ0eDI8gUo3
 Ic2iKcYjb7GAzK0pigPnQnWvSvqUkq28SXxViHM7Q1K6e5uRBJJEciAXXCMggTGQsiWFKZzOK/x
 UxtjbO0eABdFY+NK3HqIve9In/bM7YDkMwMzV6C/j+GfrwaFx21KaQYgvA7OUavG6qDz1gGn2qc
 M7+mbm4PrlsLCEJDuLR6E1OhbomVrRlDtuAy6n2mLPT8fRJUewCAVtd/ikd5l0drEQ5IWrZN2hg
 joQZ+3aYcZprUqci0vg==
X-Proofpoint-ORIG-GUID: lnI6gV-ZIlmvnu72oD7TXbKnTxSK6fzV
X-Authority-Analysis: v=2.4 cv=GIM41ONK c=1 sm=1 tr=0 ts=6a2c923c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=rJ4d5xbAOQceQwH0KXUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: hhYXZCFmBA_lzEO61kTaD4YLRPAYOEO8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 spamscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606120220

On 6/8/26 11:30 AM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Add support for fabric login in order to support the asynchronous
> event queue with its own interrupt as required by NPIV specification
> to support the asynchronous sub-queue and interrupt in order to
> support full and extended FPIN messages.
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 94 ++++++++++++++++++++++++++++++++++++++++--
>  drivers/scsi/ibmvscsi/ibmvfc.h | 16 +++++++
>  2 files changed, 106 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 88386d7c9106..a18861808325 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -5244,6 +5244,86 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
>  		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
>  }
>  
> +static void ibmvfc_fabric_login_done(struct ibmvfc_event *evt)
> +{
> +	struct ibmvfc_fabric_login *rsp = &evt->xfer_iu->fabric_login;
> +	u32 mad_status = be16_to_cpu(rsp->common.status);
> +	struct ibmvfc_host *vhost = evt->vhost;
> +	int level = IBMVFC_DEFAULT_LOG_LEVEL;
> +
> +	ENTER;
> +
> +	switch (mad_status) {
> +	case IBMVFC_MAD_SUCCESS:
> +		fc_host_port_id(vhost->host) = be64_to_cpu(rsp->nport_id);
> +		ibmvfc_free_event(evt);
> +		break;
> +
> +	case IBMVFC_MAD_FAILED:
> +		if (ibmvfc_retry_cmd(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)))
> +			level += ibmvfc_retry_host_init(vhost);
> +		else
> +			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
> +		ibmvfc_log(vhost, level, "Fabric Login failed: %s (%x:%x)\n",
> +			   ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
> +						be16_to_cpu(rsp->status), be16_to_cpu(rsp->error));
> +		ibmvfc_free_event(evt);
> +		LEAVE;
> +		return;
> +
> +	case IBMVFC_MAD_CRQ_ERROR:
> +		ibmvfc_retry_host_init(vhost);
> +		fallthrough;
> +
> +	case IBMVFC_MAD_DRIVER_FAILED:
> +		ibmvfc_free_event(evt);
> +		LEAVE;
> +		return;
> +
> +	default:
> +		dev_err(vhost->dev, "Invalid fabric Login response: 0x%x\n", mad_status);
> +		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
> +		ibmvfc_free_event(evt);
> +		LEAVE;
> +		return;
> +	}
> +
> +	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
> +	wake_up(&vhost->work_wait_q);
> +
> +	LEAVE;
> +}
> +
> +static void ibmvfc_fabric_login(struct ibmvfc_host *vhost)
> +{
> +	struct ibmvfc_fabric_login *mad;
> +	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
> +	int level = IBMVFC_DEFAULT_LOG_LEVEL;
> +
> +	if (!evt) {
> +		ibmvfc_log(vhost, level, "Fabric Login failed: no available events\n");
> +		ibmvfc_hard_reset_host(vhost);
> +		return;
> +	}
> +
> +	ibmvfc_init_event(evt, ibmvfc_fabric_login_done, IBMVFC_MAD_FORMAT);
> +	mad = &evt->iu.fabric_login;
> +	memset(mad, 0, sizeof(*mad));
> +	if (vhost->scsi_scrqs.protocol == IBMVFC_PROTO_SCSI)
> +		mad->common.opcode = cpu_to_be32(IBMVFC_FABRIC_LOGIN);
> +	else {
> +		ibmvfc_log(vhost, level, "Fabric Login failed: unknown protocol\n");
> +		return;
> +	}

This check is pretty pedantic. Seeing as you are directly referencing the scsi
sub-crqs. The protocol field exists so we can pass the sub-crqs blindly and the
code once NVMf comes along can determine the protocol.

Also, if somehow this was ever possibly the case you would leak the event
structure. I think we can drop the check all together.

-Tyrel


