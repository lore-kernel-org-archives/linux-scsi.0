Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13E33ED132;
	Thu, 30 Jul 2026 22:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452384; cv=none; b=osnHB+VIw4U3j2ycAEgU0C0EUI7U1xtwArTJrxM+DKzQSu//WhKMm3Hfaanwya2m/mGVl3ve0pteaq1YlFpa/0gr6KHlawcSd/MKNXyvyOUKfgZTaR79YAyRF1iIP158q321gl1iT0AV5uoDiH4qdL8Nll0f9sWjIHE74o4v5Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452384; c=relaxed/simple;
	bh=cEKMr2NzdBddGAc/CBpHTgTbKBVSFTlO2POlZEsZdfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rlm+XfRl/pUmLSS7G7m8IJCvCBYdUBoKqdIbLrFcVftSG/hKAq5kNeYg6rIiNAdKf4ShcgxTFX4jjMR/aaZF3DtZKWWRIrUWSUiCENw+IMvREF1M/4Yy06clAcYT0CKqa079fqcXX48LCx3qK6yJtQQ5R8hExAvgEer506Fiw48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MAhqRixn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MAhqRixn"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UJlwjU3942856;
	Thu, 30 Jul 2026 22:59:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fWsZAy
	AjMLB8vgXM9Et1W+JQpvtu4Qc7UjwfDaVS4zM=; b=MAhqRixnlZIe5M5oCa0OKw
	ixl2e7rv/YTp0jSye5XuTiAaWFbtqbnQK5TlvU/3z6tDsuWgr16yuQuqEii/RFfK
	7RBjTXD2+7Ra3D/fmlZLwccOY1Uj7PBSDZWqcxVIMS3rhYWBC81Zt6JBZja8asme
	mQdGoQG4d9SjVKAuPXlX9WhTFPY2j/G9oFq/WvBT21ylVbyuqRfLsHmzYYUVvNIJ
	q0puWqK2gR/IAY4n5GoX88PlGg1Pm7UE8ER1HXwDvPTCJYL49GHrQs7zCOZa3gz8
	JVqzcL8v15krVTC/bgtb2zLOohjqviV9td3mfeSccpI07BeSe7TcsR7GpqkTv6yw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuw7t91r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 22:59:35 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66UMujdq026118;
	Thu, 30 Jul 2026 22:59:34 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn7uwdn2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 22:59:34 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UMxXCO22151902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 22:59:33 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 967655805A;
	Thu, 30 Jul 2026 22:59:33 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14D1158052;
	Thu, 30 Jul 2026 22:59:33 +0000 (GMT)
Received: from [9.61.73.28] (unknown [9.61.73.28])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 22:59:32 +0000 (GMT)
Message-ID: <5d2e2959-0045-4ab6-99d3-d535a141a111@linux.ibm.com>
Date: Thu, 30 Jul 2026 15:59:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/33] ibmvfc: add logic for protocol specific fabric
 logins
To: Dave Marquardt <davemarq@linux.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-11-tyreld@linux.ibm.com>
 <87cxw5vmxq.fsf@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <87cxw5vmxq.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pkimep2t6jaAXVE4t1pAfHcvI73nSuqk
X-Proofpoint-ORIG-GUID: pkimep2t6jaAXVE4t1pAfHcvI73nSuqk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDE2MyBTYWx0ZWRfXy/yYOolgHDjP
 +p8BPLPySan+oFORjEmTAKzE5hmkvTxqRaLkwka2/ec8ovXa5v9qKE0rUNyfv1fFJejVPc88VSM
 r8DR5zfRYrIMVq95GZEw3D/RBil1Yu2RgmZtIg8FpDhxvgrn8C5myHmheoqufiYH3pOgy0/kV5a
 U6YZTfa+5ku6UqWtpyb51v67niIPTqDOCCsmxcMDWAWejkh1IV+4+dMVzvE9VUon9d3iukfQ5Wr
 nGSwDHEQXf8Aimx2dCHE4jWSBMlzZt0mZW6Dd6DBuULTpU7ZTf7tvtJDOrolerw6SMoQeFXTbRc
 2OHJtO6vqQBcPZ5hImwezVuOacF/FEAAykMoXwt4CEdVep18Meje/RzUvocj0kPO8ARLcEd7Iid
 5tEbRZpZ0Ci36CaMJ6125qjmfdvctEUfxVx/4uZvyv+hyYrl3PEAeU5I9GB9BzgXcz0OKH6mYn+
 IRBsnQgn+w8Sv5wZP6Q==
X-Authority-Analysis: v=2.4 cv=SKFykuvH c=1 sm=1 tr=0 ts=6a6bd757 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=6xaTkikXN-iOjGz2hm0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDE2MyBTYWx0ZWRfX/GNa03sgRG2Q
 kwSvBXja8pPuyxXxybyaekGsvEmJDKQivlq4tob08zvnlGRNcST7XWSh/bRwn+cj0Tk18NMGr9i
 oo368JyZT2jTl6fnuWs5e4qvI2F8cDs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300163

On 7/29/26 8:24 AM, Dave Marquardt wrote:
> Tyrel Datwyler <tyreld@linux.ibm.com> writes:
> 
>> @@ -1530,8 +1538,14 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>>  	login_info->max_cmds = cpu_to_be32(max_cmds);
>>  	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
>>  
>> -	if (vhost->mq_enabled || vhost->using_channels)
>> +	if (vhost->mq_enabled || vhost->using_channels) {
>>  		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
>> +		if (vhost->nvme_enabled) {
>> +			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_NVMEOF);
>> +			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
>> +			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
>> +		}
>> +	}
> 
> Should setting IBMVFC_YES_SCSI be conditioned on vhost->nvme_enabled?

Probably not since we always support SCSI protocol, and the extened async
handling via subq's is dependent on one or the other being set.

-Tyrel
> 
> -Dave
> 

