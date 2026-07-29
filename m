Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D531D4DB566;
	Wed, 29 Jul 2026 15:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338669; cv=none; b=o4AQoRJs/0UFRWX4Cp/hponBY0eTq+c1Kmx/anhDbIgys50oPTAy+LRgMHNmA6F6EFujfATQdJlGDMcfWtAxZx6TRyvIhanvOJlq6cXoC4iyyd14PRlAN8t+Q5KyjsuYM+mRCGtJ0gs/UwXirryJO64rQI4yWz4Cq+QtGwv/DQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338669; c=relaxed/simple;
	bh=xtu6tbx7k/1QIDKsCEMlZOY8VbKOvJ2YxulcDkoOEUk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CvMG2HmkMNn7o8k2P/JeKiWgbfIcXSccUYbB5aDXJtYs5nS7n6pb3wVudKf2I9+yB9wKGXaaYF3SHbUROJg7QfTvzwdJ+i73ffRp0nJOeAZ1Czy/uXwfx2Z/eMZ519StzgTvj2p9l3qZrYkNXgD2o7KhA+8I6nKSEVUp/pb+ovY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qFQKpxf6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qFQKpxf6"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TFHgFL402486;
	Wed, 29 Jul 2026 15:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=7Y851Sl6c1317PScn03Hr9nj2cJhPD
	VUt3qis4OFyxM=; b=qFQKpxf6VfzENcxKvq7yxuNFy/pR5LpgEr7+e1yX3HV366
	NuxNOjzWDpuOntSdqagNUuXWRwNO+n5ZWjIZSm8y1TgPqn90lCCfJH75dcBA41LE
	e+Eho6UZmwh9XSpB2cDUH0ckaFh3ZWtNr78Yn2rA4uavniBFtBV4MbUco8mwSjak
	iASFn7CSXWM7Q1b3Wgm9nnVdghVVcmS/vL3agCvr+1ezZUgFSO79Fhmanuhtuimn
	3yh34pSPC5mr+TDtrG44p0YsnwpyFG/jzW72GRPVqiiGgFjt7VBPNY7kOQscxrXR
	/5gkWk6gPLEyiiJ4xoNhaAfQXc7mIfJaDUE9A7Yg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuwd2meu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 15:24:19 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66TFBc3h001559;
	Wed, 29 Jul 2026 15:24:19 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8fk79bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 15:24:19 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66TFOHkZ28443348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 15:24:17 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9E7058056;
	Wed, 29 Jul 2026 15:24:17 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A1C6358052;
	Wed, 29 Jul 2026 15:24:17 +0000 (GMT)
Received: from d (unknown [9.16.41.19])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Jul 2026 15:24:17 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com
Subject: Re: [PATCH v2 10/33] ibmvfc: add logic for protocol specific fabric
 logins
In-Reply-To: <20260723000149.969416-11-tyreld@linux.ibm.com> (Tyrel Datwyler's
	message of "Wed, 22 Jul 2026 17:01:26 -0700")
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
	<20260723000149.969416-11-tyreld@linux.ibm.com>
Date: Wed, 29 Jul 2026 10:24:17 -0500
Message-ID: <87cxw5vmxq.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x3igD5_si39orQ0-ATocC7y2UIbFWhO7
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyMyBTYWx0ZWRfX6NF9i1sjrNIy
 thC2ir3wU+3uh7gsXzw4qvn/unsTZ3boYxpxmMrr0oEOf/p1Z0KXJZ4ZpEaUWQyY5odnmqzUwTN
 nRKQ3+jn0ATsqwXqDFJ2x21cBRCg4zs=
X-Authority-Analysis: v=2.4 cv=E/z9Y6dl c=1 sm=1 tr=0 ts=6a6a1b23 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=ypPWuq4yIia8aLVxQa0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyMyBTYWx0ZWRfX512gsMEHG/Qj
 NszMyvM1ArMfFA/RtETbKgY+/o/ssdt0Kg9wpQUHthQX80gx5HjZb6NC0Wp2tvWJ9UcTgdIHsfj
 GHX840H+tlDonSUaqHgTJKEfC5m6w6xreBWhY38z6sHWEsPFv95ZoddMtZQfj3ZHLC0wFp83gk8
 CPHzDvUAvE+NwkViZiqvXaMuzgOPaO+sr3Upy2fN1NpgTosE2lo0Qa14OjFJTmfpV4tAF8x6csJ
 JaZJkfhdM2z9IUY9umqNM8Dez/pACpkJveQhZ+o3SRPwcpWCprcybqGvhUMnWx9cjbeHutt6qaI
 0CGIFzgOISsHcYI9JihlH6mdG+arVJFZ/QLfvFx3bXsR/bLLcuVdX0v2+8gCS5e9gfbYNZfXTxy
 5A2YDruP5ptlovzMZA/kczrDBaQ4758f1J4/TXdGCKrC/YORPwVVnxOaaN4MIwBv4dHkNxj/5Pg
 3SPATdUz1e4XroOKu7A==
X-Proofpoint-GUID: x3igD5_si39orQ0-ATocC7y2UIbFWhO7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290123

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> @@ -1530,8 +1538,14 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>  	login_info->max_cmds = cpu_to_be32(max_cmds);
>  	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
>  
> -	if (vhost->mq_enabled || vhost->using_channels)
> +	if (vhost->mq_enabled || vhost->using_channels) {
>  		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
> +		if (vhost->nvme_enabled) {
> +			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_NVMEOF);
> +			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
> +			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
> +		}
> +	}

Should setting IBMVFC_YES_SCSI be conditioned on vhost->nvme_enabled?

-Dave
