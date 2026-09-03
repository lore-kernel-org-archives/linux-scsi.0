Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E47A4F472E;
	Thu,  3 Sep 2026 16:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454614; cv=none; b=iQv27zUuwPF0noGFj3XdOIAA3aNZ28P3yngLo/ddVj5AHMNYm37SnKc/4ruMmCAN12Jtw9s8j76He1aY6kQdjmMzt4GQr8wXtnR+vBQFrEz7XcK5iaZfVxuZg7WgUFrTyNWBvyDqNEOnEqoHz9vAdWgPXvVSVvsyT7FlWMBXCrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454614; c=relaxed/simple;
	bh=FSlVyf9atQNmN9KquTxfDAEMbZlKXCjPzVeNCrGcDnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QSH9WScju+e/UcYdBeNe5ZsQ279X8pjL7A0z1KZgtg4gdqMmfgbU5LYpg4n6IQyKbAcV+1axgPYiA2ARaADqGEFxlaX4DVm9K4Fbxi/4yu6cT/eMe1fvpI8Hg6OQw63vtZ2dCTVmP1RvNMtb25J/iPk3e/Yp4YdZ0ZgaZa6mHgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iwIwdKKY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iwIwdKKY"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G2uol2292412;
	Thu, 3 Sep 2026 16:56:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PkYuOB
	nKxSMPtmBAHIe1yxX8ksre0sRUueo206+p7Sc=; b=iwIwdKKYz21A+uJFWpFhtk
	LmSVp/YA+o37pAQAAVwkYWX+ihnABjS/8yEAsR/88svEe1pRcpweaMDRiRxQgpcW
	9Eu1E/BJSHPQo04pGUwaWtZSEO1KChqpzNyM03Xwogw07PAOyp/9OtFCMwCrhi+l
	gzkBn20ebB0ABg8ld2sTOeIoQ1c8I5gCtPXzsiZDbO/ia9WscSnE97FFG/x8Q5Nl
	KpoERlNEgvhTu8w65pIlYIDH4ZMME2s10y+K5Qjw3YYa+SSWjlg31V6pgkfAVCZo
	WlN5zBLSdBEjI+gt6O5Ap9VSduw4invAqwPIQVtTcd/8wRXoutPfpunTx4olzdUw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbnue5m5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 16:56:43 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 683GuOZT029257;
	Thu, 3 Sep 2026 16:56:42 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gecjary37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 16:56:42 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 683Guf0J8520510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 16:56:41 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 003295805D;
	Thu,  3 Sep 2026 16:56:41 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B3B058055;
	Thu,  3 Sep 2026 16:56:40 +0000 (GMT)
Received: from [9.61.81.200] (unknown [9.61.81.200])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  3 Sep 2026 16:56:40 +0000 (GMT)
Message-ID: <ae274c2b-cc1a-414b-8e79-41eb7c68a596@linux.ibm.com>
Date: Thu, 3 Sep 2026 09:57:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ibmvfc: Add Kconfig dependency to fix link failure
 when NVME_FC=m
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        James.Bottomley@HansenPartnership.com, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        pavrampu@linux.ibm.com, brking@linux.ibm.com, davemarq@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
References: <20260903074329.6705-1-venkat88@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260903074329.6705-1-venkat88@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IUZzmbX7od1_g-NjyLzHSC5YfgOx0gP_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE0NCBTYWx0ZWRfX7nLK9tacXoxL
 b5OGMid/wWbAY5iYdQHcNH0PlXO5hzD/NFjiDU9PfLTfvDthj8l5RPlyJq5K1ck0eLaC40fho5+
 thBerZjdKwjcX5LtvvAce/QWHa5l5u3//GNgjZ0El9T+XhGYIcJyg/NsPKra9PjfDotuQne5CXC
 ZsmVZyVxPCf2xKBMicbTpuj2XDddShwV2IYjnh/u11PR1pV9LyHx4sM+CdniD/MctUbQzYFx9Kx
 +CHRZ+bVn/YIFcC8xlpu5kF9EKvXgk044dYnbbRYE51mDQNge4MgTyjtudMSAnOZvnlySg5KfxV
 ZLMO5KGsqOZPq3gxEav8hddjOahNVDoTlRx/qCwC7PDc0khmm+kQ4YRV6qlXEM05suEvkV9D6CK
 m71Xnb8gBDwQsz3ZJ46ZMdcUPuekaoIlVV8BdeYJQOnLYOs8mdLrS6pxq57nJ2wwED2yOobjoKq
 CwFoBtSNLh303mHFnYw==
X-Proofpoint-ORIG-GUID: IUZzmbX7od1_g-NjyLzHSC5YfgOx0gP_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE0NCBTYWx0ZWRfXwYHyF54/8TWG
 wmmjzfhPkuQtVKJEQbuL4puwtw+jAUdZuIef0/fxJCRZ9Hsq2NnIzVqNcNHbzf8RzhysCqbZgMB
 h1aW66nbqvnP6D8IxnkYvFbL5q/UEt4=
X-Authority-Analysis: v=2.4 cv=B92JFutM c=1 sm=1 tr=0 ts=6a99a6cb cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=l6V8SbYLYiLwnwxNSpgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1011 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030144

On 9/3/26 12:43 AM, Venkat Rao Bagalkote wrote:
> Building with CONFIG_SCSI_IBMVFC=y and CONFIG_NVME_FC=m results in a
> link failure:
> 
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_register_localport'
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_register_remoteport'
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_unregister_localport'
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_unregister_remoteport'
>   ibmvfc-core.o: undefined reference to `nvme_fc_rescan_remoteport'
> 
> IS_ENABLED() evaluates to 1 for both =y and =m, so the nvme_fc_*
> call sites are kept in the object file. When SCSI_IBMVFC=y (built-in)
> but NVME_FC=m (loadable module), the linker cannot resolve these
> symbols at vmlinux link time.
> 
> Add the same "depends on NVME_FC || NVME_FC=n" constraint already
> used by SCSI_LPFC to prevent this configuration.
> 
> Reported-by: Pavithra <pavrampu@linux.ibm.com>
> Closes: https://lore.kernel.org/all/327877a29337aa526cc50ac88fbddb86@linux.ibm.com/
> Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> ---
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
