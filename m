Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6491CFBA;
	Thu,  7 May 2026 04:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778127493; cv=none; b=Al0HwHI8DJLfI/fwfZHyFQQ1286glED96qCjtKXMzMcJvlz3KQ4OU40d3B7JMHY3erdWJTRJIHd7e3R7VZDy/D8tuzlEYxuqGxft5qKYo2/bTU4/FsZ/KDxNZAmYjXp+dWERRn5aKaQ7phBORkLlXidyQFAsNtopdHy79sv81Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778127493; c=relaxed/simple;
	bh=Nwnp6zDGuAWwP6UzZBeGzZn4DjFMtVSSag2JsZdJ/WY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z2Yx+CM5WPKvRcixRhlxuXttWlnaTI1+etvcsdlcy6Bo1HDFER/SY3zS71hKK0wRatXNX/rWpH49OZHYDFWVVWyYk22jnJPT8xqCVrB5KNOaz1r7gH/nV+AhKn4ABaFqrZvcrgoj0QTOgbr1/b5uIG+hKgGh1wS5Oj60MVgLnG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QxN5CPJC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QxN5CPJC"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 646NaHX1577034;
	Thu, 7 May 2026 04:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VPt5yg
	lUexDXIzzfiGc6+rdGX2ESmrpEL30POQ/aL5Y=; b=QxN5CPJCIORtgH7xNnKHyx
	hcwnyds0c3aL+MhjVESpzzRROH8/coDiT58PhLr4Vf8pun2HP7iK9utmyKGuIBYx
	opSgrwFr+e7A2tt4u3S5pUQkBP6s0witAeJyWLaKn8yTDMUXSwaXt5B25D4jsoGS
	kpfMQljsfduWgoNa5w4YblUiF5xsV0tAMRi9askZno7tuIamaCy0piFDYlSCc01N
	RlP0e7nHGgqPxzYu9ngznJo2aAFzpcRKFdb3Gbhvp5lKgkuxNzOZSLheqH0S8DLe
	Y/WHjQJfnt7fNrNkL33+e4UqGPcQShd8J0QEAwFanT3wDm/XpEAgNH8osrmlZXpw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxu6x3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 04:17:59 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64749fXm019689;
	Thu, 7 May 2026 04:17:58 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkk1d15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 04:17:58 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6474Hv0a58851814
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 04:17:57 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F00D058052;
	Thu,  7 May 2026 04:17:56 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E61658065;
	Thu,  7 May 2026 04:17:56 +0000 (GMT)
Received: from [9.61.92.155] (unknown [9.61.92.155])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 May 2026 04:17:56 +0000 (GMT)
Message-ID: <7da072cf-8774-4144-8888-b3d41af470f8@linux.ibm.com>
Date: Wed, 6 May 2026 21:17:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] ibmvfc: Add NOOP command support
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
References: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
 <20260408-ibmvfc-fpin-support-v1-2-52b06c464e03@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260408-ibmvfc-fpin-support-v1-2-52b06c464e03@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDAzNyBTYWx0ZWRfX5Z7pIDuw3IM4
 9M1/Sc/zb03PE1D32TWUvvAQzxW176LI6FJBwkyqBxprzvoE9RLJG1BL6tAHBaOEK8UR78Ho7BB
 76VAeFSeA238RaV+EI4RaD0AnIsqX5jyX1l6Wf7QgNhgWoMgUZmcIKunw1B9UX69vfuHoSOjenW
 z6l6tGKv8JY3kff4AGiHrvfPsZ0rHsQrRu/gwGPiww3aabF/YEYSP1u+inKHhPfvUH27cbHLfaN
 dbIUqZHVQQSWEpT4viDE2rYx3RZhyjRaO89Rqr/E/CVry7iSsnnU6qWFLMLqZcDhpZ64hxhGsxK
 dyZXPyg1EJTgHW7kz+0ONGD2DH+9pbOL2I4pDRIHsgWgsdb+CWiQ6Qr2kGvMB55Dpd9NtXbEhYN
 Q0zzVWFZSPIx3do4rFTJVAPpFOsocXnB9uhTTmmCFRfyYHcZUIOhXg6M43i+UMqmAApvj+67Ks9
 2Ukz8d1z+doS0STKS7w==
X-Proofpoint-ORIG-GUID: _NHr-UqH1jhWRSJdqpujdcuoE3E1GHVl
X-Proofpoint-GUID: dLHBxyj1krGN4DK6-p2PoLG9ouqf5AMi
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69fc1277 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=gbiXFsmGSiDHHzs1lG0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605070037

On 4/8/26 10:07 AM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>

As with patch 1 this requires a slightly more detailed commit log message and
developer sign off tag.

> 
> - Add VFC_NOOP command support
> - Add KUnit tests for VFC_NOOP command
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c       | 23 +++++++++++++----------
>  drivers/scsi/ibmvscsi/ibmvfc.h       | 13 +++++++++++++
>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 27 +++++++++++++++++++++++++++
>  3 files changed, 53 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 3ac376ba2c62..808301fa452d 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -189,13 +189,6 @@ static long h_reg_sub_crq(unsigned long unit_address, unsigned long ioba,
>  	return rc;
>  }
>  
> -static int ibmvfc_check_caps(struct ibmvfc_host *vhost, unsigned long cap_flags)
> -{
> -	u64 host_caps = be64_to_cpu(vhost->login_buf->resp.capabilities);
> -
> -	return (host_caps & cap_flags) ? 1 : 0;
> -}
> -

It appears you are moving this to ibmvfc.h? Is there reasoning outside making it
visible to kunit?

>  static struct ibmvfc_fcp_cmd_iu *ibmvfc_get_fcp_iu(struct ibmvfc_host *vhost,
>  						   struct ibmvfc_cmd *vfc_cmd)
>  {
> @@ -1512,7 +1505,9 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>  		login_info->flags |= cpu_to_be16(IBMVFC_CLIENT_MIGRATED);
>  
>  	login_info->max_cmds = cpu_to_be32(max_cmds);
> -	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
> +	login_info->capabilities =
> +		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
> +			    IBMVFC_CAN_USE_NOOP_CMD);
>  
>  	if (vhost->mq_enabled || vhost->using_channels)
>  		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
> @@ -3461,8 +3456,8 @@ EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_async);
>   * @evt_doneq:	Event done queue
>   *
>  **/
> -static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
> -			      struct list_head *evt_doneq)
> +VISIBLE_IF_KUNIT void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
> +					struct list_head *evt_doneq)
>  {
>  	long rc;
>  	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
> @@ -3520,6 +3515,13 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
>  	if (crq->format == IBMVFC_ASYNC_EVENT)
>  		return;
>  
> +	if (crq->format == IBMVFC_VFC_NOOP) {
> +		if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
> +			dev_err(vhost->dev,
> +				"Received unexpected NOOP command from partner\n");

If we have a misbahaved VIOS partner we may want to ratelimit this dev_err so
that we don't flood the log. Probably a corner case, but I don't think it hurts.

-Tyrel

> +		return;
> +	}
> +
>  	/* The only kind of payload CRQs we should get are responses to
>  	 * things we send. Make sure this response is to something we
>  	 * actually sent


