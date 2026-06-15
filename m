Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1E22D97AA;
	Mon, 15 Jun 2026 21:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781560393; cv=none; b=CNw7jNiFSPjpHix2J9QQ4R/5Hzu/5dnXz4xHfqL+a/HR+MfMzDE2+4PWmaSUOwKh2+9hCP8ppZDvT6TXeB/fNF3Lnqopa5dslquHU9qNedc3YiWPIb6hSpDqZHDqgmnzqDJQ/E7oHg+U2z2Aw//XDa6BP7XarUVReQqBuQWDJck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781560393; c=relaxed/simple;
	bh=CDAg3ZMdr7Ak5YU9ZMlZRIfqBGoieYL+HHqqZ1m7wLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RGvWyssrmlwMvCYcAgPAR/TLYWgJX24wqlB6ZvkixxJapVWJcGc2ddlTiwJd7HDIdiEt4S51LUkVnp42CuKtHrmHP+497qYSCVu1SiPHfN0gNeVGNQF1kKIXt/IF3LY2+dQB+M56N/fUEaWY1MT8wJ4HuetVQCLAO+kAyGFKpEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fpAygnDG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fpAygnDG"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FJIOTF3358381;
	Mon, 15 Jun 2026 21:52:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NluXmv
	msMHz3DDJtcOAZVhOXiV2u6yLkaZ414E5090o=; b=fpAygnDG8fHh3IFnKLOmoF
	3aftf9YTKxTDAxDt2FWFRl/o+AbwN5jj07Grp2nOjL4RSnXE+JMSYgsXWRw8CbKe
	4skEvvIkUpoV/MZi2cjFfJWLSv8l6D7R0EiMUwShJO/MuDt7PRotaYpuh9G9cyiC
	83KrlTCqaLTLLlKfGiOhfc90gDFhC9/h9N3fbHbIyKSnG1j+vpKOk9CnGo9zcocP
	SE2eypXQHyTWuPanwwASnkGOUPTkzco5B0WInEv93JcB0QDFAu+eqgNxrJUKtmEf
	xDu/7Stha4WBg977Oku/f3OqVvmAIiJMxNYr7wXvxY/DmpbR17WmZMdA2R2XjoKg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4es1eg2a02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 21:52:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65FLncl3025342;
	Mon, 15 Jun 2026 21:52:56 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eskrg8b4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 21:52:56 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65FLqttj29229746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jun 2026 21:52:55 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5596358043;
	Mon, 15 Jun 2026 21:52:55 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 76A7558055;
	Mon, 15 Jun 2026 21:52:54 +0000 (GMT)
Received: from [9.61.95.246] (unknown [9.61.95.246])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Jun 2026 21:52:54 +0000 (GMT)
Message-ID: <5ab40307-b197-4a19-ac73-5f7e516d81b8@linux.ibm.com>
Date: Mon, 15 Jun 2026 14:52:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] ibmvfc: handle extended FPIN events
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
 <20260608-ibmvfc-fpin-support-v2-7-d41f540fba5c@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260608-ibmvfc-fpin-support-v2-7-d41f540fba5c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDIzMSBTYWx0ZWRfX/U1KXILuoKrE
 AF/gfuYC5GyuySSC9V4ewVpWbQ/ZxzDGLNJtKXQXuQMBxeq06tgewiqxh+n1kMGg8oS0TN+ozAS
 xLnKHeskUGLlszcOPmOWq6frTpFtKj0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDIzMSBTYWx0ZWRfX8l3JH75sGcB4
 M4QmqUMpxB3lWJI0ShuYS9IdC4K0NKP4LlTDw9ktFE8vquhhSr/XGwIAbrzkQxR5Cz4ZYGWlnM0
 mnS8DL7wN2LM/AokX6ogP//XvzpZ2kUjRFL66IBUVg2XJTJpLi08VHOCd1Q8bMxW+O28R4Zv6bJ
 tpNZHyrJFj/iKlEcsBMeBP1jd8n/+syeWgC/qsr2u/sFJDsljOqTE9FRkW84CetYD4vlE+SXy8I
 SEO0bRpZcplK6LfKQogck87j0AgDvtgaW/cslD4Z54JS8gf1IPSVxKsbXnX0zYtkpxgUgRarqfx
 OFQYcn9cYx0JjN/109Eq9xWMNGFwhpVpau/e9wE7f3zzauqr1+tRNrcjcbMdmtXYGSu4BP0YQHj
 jg1yP2Dgcc5SSkbVAWZKoYtI3Ue3gM29bFl1F16M0v91SoWncxH2j92OM6puOoJ2cvi1TBhVV81
 iCs4SUmluzrfwsFPXMg==
X-Proofpoint-GUID: QjjjplWGXftDX74fdbz6Od9CqbvKhuYN
X-Authority-Analysis: v=2.4 cv=NuDhtcdJ c=1 sm=1 tr=0 ts=6a307439 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=7hyLSrYlzJ6CN_kyhJEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Tff9x5M5dv-PAV_h2PcbxTCmATr5_aLe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_05,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 phishscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150231

On 6/8/26 11:30 AM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Add extended FPIN handling to ibmvfc driver. Tell VIOS ibmvfc can
> handle extended FPIN messages, convert any received to struct fc_els
> descriptors, and call fc_host_fpin_rcv to update statistics and send
> netlink multicast messages to listeners such as multipathd.
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c       |  41 +++++++++++-
>  drivers/scsi/ibmvscsi/ibmvfc.h       |  31 +++++++++
>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 122 +++++++++++++++++++++++++++++++++--
>  3 files changed, 186 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index a2252cd2f44b..b034a894e3ec 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -1515,7 +1515,8 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>  	login_info->capabilities =
>  		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
>  			    IBMVFC_CAN_USE_NOOP_CMD | IBMVFC_YES_SCSI |
> -			    IBMVFC_USE_ASYNC_SUBQ | IBMVFC_CAN_HANDLE_FPIN);
> +			    IBMVFC_USE_ASYNC_SUBQ | IBMVFC_CAN_HANDLE_FPIN |
> +			    IBMVFC_CAN_HANDLE_FPIN_EXT);
>  
>  	if (vhost->mq_enabled || vhost->using_channels)
>  		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
> @@ -3254,7 +3255,7 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 type, __be16 modi
>  	if (size == 0)
>  		return NULL;
>  
> -	fpin = kzalloc(size, GFP_ATOMIC);
> +	fpin = kzalloc(size, GFP_KERNEL);

I commented on why this was changed in the previous patch, but now its been
reverted back here. Looks like a refactoring artifact that needs to be fixed in
patch 6.

>  	if (fpin == NULL)
>  		return NULL;
>  
> @@ -3371,6 +3372,28 @@ ibmvfc_full_fpin_to_desc(struct ibmvfc_async_subq *ibmvfc_fpin)
>  					  cpu_to_be32(1));
>  }
>  
> +/**
> + * ibmvfc_ext_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
> + * containing a descriptor.
> + * @ibmvfc_fpin: Pointer to async subq FPIN data
> + *
> + * Allocate a struct fc_els_fpin containing a descriptor and populate
> + * based on data from *ibmvfc_fpin.
> + *
> + * Return:
> + * NULL     - unable to allocate structure
> + * non-NULL - pointer to populated struct fc_els_fpin
> + */
> +static struct fc_els_fpin *
> +ibmvfc_ext_fpin_to_desc(struct ibmvfc_async_subq_fpin *ibmvfc_fpin)
> +{
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin->wwpn,
> +					  ibmvfc_fpin->fpin_data.event_type,
> +					  ibmvfc_fpin->fpin_data.event_type_modifier,
> +					  ibmvfc_fpin->fpin_data.event_threshold,
> +					  ibmvfc_fpin->fpin_data.event_data.event_count);
> +}
> +
>  /**
>   * ibmvfc_process_async_work - Process IBMVFC_AE_FPIN async CRQ from work queue
>   * @work: pointer to work_struct
> @@ -3425,7 +3448,19 @@ static void ibmvfc_process_async_work(struct work_struct *work)
>  			fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
>  		} else {
>  			sqfpin = (struct ibmvfc_async_subq_fpin *)subq;
> -			fpin = ibmvfc_full_fpin_to_desc(subq);

I think this should be fpin = NULL here.

> +			if ((subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) == 0) {
> +				fpin = ibmvfc_full_fpin_to_desc(subq);

As you set it here for non-EXT fpins.

> +			} else if (!(sqfpin->fpin_data.flags & IBMVFC_FPIN_EVENT_TYPE_VALID)) {
> +				dev_err_ratelimited(vhost->dev,
> +						    "Invalid extended FPIN event received");
> +				fpin = NULL;

No longer need to set NULL here

> +			} else if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_FPIN_EXT)) {
> +				dev_err_ratelimited(vhost->dev,
> +						    "Unexpected extended FPIN event received");
> +				fpin = NULL;

Or here.

> +			} else {
> +				fpin = ibmvfc_ext_fpin_to_desc(sqfpin);

And here you set the ext-fpin case.

-Tyrel
