Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D333E173B;
	Thu, 30 Jul 2026 23:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452819; cv=none; b=Cn04xoD0xRYSeetJMQrX58pxccrZsASbNWQ3cK0aTyzcMZ7jCs7KAJA87PlmY5pV3/luN4ViIs9S1z/h16pqzDwkXJEsUz9zpm058A7p9dcQGAZm7pN0zbGK5ayzj+4g4c9+oJKaOvFWjpwYCupaiyoEcOcyljRW0WZwpSJWbDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452819; c=relaxed/simple;
	bh=USJXkE+4lF9CyDSKvJwHxuGhLizfXKxML+vOLHKJQaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pikg1q9tB3kT15yo479do6ElC7NJ/m4sT1/cnfx/ILSahIYx/lQOq7660veBe/NUSKAa+hFFX6C0N2MJf5PvPC9Myl9/EWStCDOAFNOdzoZheZjUBslNgaoFB/kLEd/P6N6YR0haYrYmFtqK71d0dvyX9pKvUF4esrzWUB/cHmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rVqT0KpP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rVqT0KpP"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UJlhTO3942107;
	Thu, 30 Jul 2026 23:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VsiG3e
	968sHRnByhHa3WpRf5SZmewhahB2UA5sUBOz4=; b=rVqT0KpPMgicBNeYNB4Lbe
	fEBXg6VbIEov9TVTlCww8E1TX43Olhla7aR+Lsw5vVXItBcWCSO2DWejDJC/sHBt
	bePDevO2o35hvh/knDDd2cw5Po9ZVi/qfB526IzI/2VTcND6CiAiLjoAFcbcJCbr
	N8T5/a+x1hFOOXv7iYh2Wa7D3Rc8NxL+wjIVpw+wqLoTi7Gb/qWfKPaI787/N0UE
	Z2EpCdtYk6RKwEhcfs1KVvLk/LeRMFdzaJw/xm9fI+vc2cHIEnxEKob2UTsW6Tg8
	Xz674E4GTB03HFkCn7KFWY2f0gciw4popgApxjcpE29ZZmZJP4CRSfwB4LCYsoGg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuw7t9uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 23:06:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66UMugDY016115;
	Thu, 30 Jul 2026 23:06:50 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8fkdj1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 23:06:49 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UN6mC120972052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 23:06:48 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4D0D58066;
	Thu, 30 Jul 2026 23:06:48 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EA3358065;
	Thu, 30 Jul 2026 23:06:48 +0000 (GMT)
Received: from [9.61.73.28] (unknown [9.61.73.28])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 23:06:47 +0000 (GMT)
Message-ID: <16875239-c114-4c3c-a967-91bedeecf523@linux.ibm.com>
Date: Thu, 30 Jul 2026 16:06:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/33] ibmvfc: process NVMe/FC rports in work thread
To: Nathan Chancellor <nathan@kernel.org>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-26-tyreld@linux.ibm.com>
 <20260730065226.GA1879117@ax162>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260730065226.GA1879117@ax162>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GjIFRJEUrmd7LyPt4uaoEaTLrL1FiMH3
X-Proofpoint-ORIG-GUID: GjIFRJEUrmd7LyPt4uaoEaTLrL1FiMH3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDE2MyBTYWx0ZWRfX9Zb9CqdqtzS6
 WNyZp+MqHcshAeT2dyiBG7GJJtjvN4ykRVlKi8qNgos7sCKBZVynD2g+VTEnNd/ww/m75lmQIan
 ubFsnT8aMm1v1yklpRIIgluienJAcFNQxJX/LmTqs55RNaJnfow6sMcnp/iEt59ZmAl0vlajF6m
 ZjpuDCZuXLSEtOWq161kDgLAldE+ImV98qhjxHPCJEIitgmGxjXtzgc8I9oEdqaMTYjZron1ib8
 Fazpc8AGT2buDNu4qeXGF/C4o0FllOvVFVPWsZPvHkWq4glwNaJRJrb6qw9SMDcR2J8X5D2fe9w
 7+ddnmK6jTdSxaxaEyaQm+WNU/pf5vVVRmzQEfXcrd+faBQLDnev82TihO0Y5Qux0U78R/Nvkky
 iJ2NjPrLm0w7IegjBW6X0+Lu7RvBVZvAE9kmD29efskjaL5SCXYo2K2Kbx+9mgNPkao34/DfXXW
 9zMQZkkXAW1ds0FqIaA==
X-Authority-Analysis: v=2.4 cv=SKFykuvH c=1 sm=1 tr=0 ts=6a6bd90b cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=rqqzB6QmINZeZLXxEfgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDE2MyBTYWx0ZWRfX4omleGVZ2094
 Gv0m24mqvqoZbqCUr38u7aZWLfhQ+IRQuZI+lsBu2Np0nGTufrS1rw0ucMldW0Ugf+3lQsmCksH
 WFfuaymmCgCeLSCtq2gzyOy6yUraz/U=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1011 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300163

On 7/29/26 11:52 PM, Nathan Chancellor wrote:
> Hi Tyrel,
> 
> On Wed, Jul 22, 2026 at 05:01:41PM -0700, Tyrel Datwyler wrote:
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 81d9229bf388..ffb579816e84 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -6073,6 +6119,30 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
>>  			}
>>  		}
>>  
>> +		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
>> +			if (tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
>> +				tgt_dbg(tgt, "Deleteing NVMe rport\n");
>> +				nvme_rport = tgt->nvme_remote_port;
>> +				list_del(&tgt->queue);
>> +				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
>> +				spin_unlock_irqrestore(vhost->host->host_lock, flags);
>> +				if (nvme_rport)
>> +					ibmvfc_nvme_unregister_remoteport(tgt);
>> +				timer_delete_sync(&tgt->timer);
>> +				kref_put(&tgt->kref, ibmvfc_release_tgt);
>> +				return;
>> +			} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
>> +				tgt_dbg(tgt, "Deleting NVMe rport with outstanding I/O\n");
>> +				nvme_rport = tgt->nvme_remote_port;
>> +				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
>> +				tgt->init_retries = 0;
>> +				spin_unlock_irqrestore(vhost->host->host_lock, flags);
>> +				if (nvme_rport)
>> +					ibmvfc_nvme_unregister_remoteport(tgt);
>> +				return;
>> +			}
>> +		}
>> +
>>  		if (vhost->state == IBMVFC_INITIALIZING) {
>>  			if (vhost->action == IBMVFC_HOST_ACTION_TGT_DEL_FAILED) {
>>  				if (vhost->reinit) {
> 
> There is a warning from clang after this change landed in -next as
> commit 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in work
> thread"), breaking the build when -Werror is enabled:
> 
>   drivers/scsi/ibmvscsi/ibmvfc-core.c:6154:15: error: variable 'rport' is uninitialized when used here [-Werror,-Wuninitialized]
>    6154 |                         } else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
>         |                                    ^~~~~
> 
> Sashiko appears to point this out as well:
> 
>   https://lore.kernel.org/20260723005006.C7EE21F00A3A@smtp.kernel.org/
> 
> But I am not sure that its suggestion to use nvme_rport is correct given
> the context of this code, hence just the report from my end.
> 

I've already arrived at the conculsion that I will have to spin a v3 of this
series based on a few of the issues raised. Thanks for the heads up on the clang
warning.

-Tyrel

