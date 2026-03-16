Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5341F471F;
	Mon, 16 Mar 2026 14:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773672952; cv=none; b=WBfGsdFNeREKSUB9ITdrmSEacy3Dfc4ffWIYqxOmMdXObBF3YbPkeft0BKsIqqdTxV5yYIaUGZCJZ/eApYEfn2L+osv9RWnOUzrAI1+wMFxIQYYOuyC2XTfMojnZBS5bqKg+gZUlcT61ovW8tvWmC943mQCCM5f0Drpm4nGfAVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773672952; c=relaxed/simple;
	bh=Q7OFgWGy72xDhXk1BMOcjIYWh7Eev8ZgiPCRbtZUWiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tsV7CUMIsYi4iir+J9UJi8xw9iJEetOORKZ32qtlms4O8lHimuIjqLl7CgfOy9wTAbdh7G02ZLnX0qZ3uAEq/0rQj9REHpIGFNYbTG8tpL316L0RNVEjnIphvtDxidpRa9vlmiaZbJTtkglKCtvumpOFCg37F5rj0q/SOCmW29U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XasgCRWc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XasgCRWc"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FKtSd9737432;
	Mon, 16 Mar 2026 14:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WuORCV
	Tknc0o5e0nf6emq4HbX25XSpwjF76qcCFkcDI=; b=XasgCRWct7x3O1OOt1d6Gp
	zVOYhx8t7AGat9zqdOz3swq7XuYNrect6gXboDcaSSGXDAWe2bUKcsRkfETTMy8Z
	CvIXRe0M5VxVAhMM/TY+FM4AhpTGlUlRoTY1oclUlf+iFpJkqlGDMgKG1sTdry5W
	wpG6VWirFFsGrMfLuE2VFL7hnkqOcdZLBVDdgf7MJ5XjAuGbHOxXVj0Oe1Nxv+dZ
	E5RRYYYCy3ko98gcF4AfwY054RFD2ThOlTCFPpKWcIUBNMrUGROCYwzSjbifqU5o
	9CmNz/+uzR4aeADmTcjdbPmn/960qUXBDUaDL1SzeVDaxqEEmia1osZDdERLuWDQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvybs0chu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 14:55:44 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62GEjFFM004581;
	Mon, 16 Mar 2026 14:55:43 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cwj0s5bh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 14:55:43 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62GEtfHx26477286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 14:55:41 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9116358056;
	Mon, 16 Mar 2026 14:55:41 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B6825803F;
	Mon, 16 Mar 2026 14:55:40 +0000 (GMT)
Received: from [9.61.251.44] (unknown [9.61.251.44])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Mar 2026 14:55:40 +0000 (GMT)
Message-ID: <52db4557-c065-4727-8ac1-1de1a6926323@linux.ibm.com>
Date: Mon, 16 Mar 2026 10:55:39 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] scsi: virtio_scsi: remove unnecessary fn
 declaration
To: Matthew Rosato <mjrosato@linux.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        farman@linux.ibm.com, frankja@linux.ibm.com
References: <20260312174256.1557045-1-jdaley@linux.ibm.com>
 <20260312174256.1557045-3-jdaley@linux.ibm.com>
 <94050d3a-a7a2-40a9-9da7-38f759fc27f7@linux.ibm.com>
Content-Language: en-US
From: Joshua Daley <jdaley@linux.ibm.com>
In-Reply-To: <94050d3a-a7a2-40a9-9da7-38f759fc27f7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MMttWcZl c=1 sm=1 tr=0 ts=69b819f0 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=CEo9wTe8L_6vgSaUR5wA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _PPqmellvLLB7xxmDrdcRd4TzpSSLtUs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDExMSBTYWx0ZWRfX0yX5YfPBOXAo
 3W85w8+ibiwMuBzx0vFrkhRZzh2GY+Y7UQ9SCLC2vya1oPJkiTBoWpto3hu84ryS2l/77rglac9
 Ale+vyf2TmFHcuge4GqroOVUWfkRP31Gp3+Ajr/KHQu0ONClv3733ER0php2QairFCw9Gvmb+pE
 SejOZu5K+ks3jqWFqWq8TTftFVXmn1B5HOctCBSK93nI+CbFtDXBiTVBGc29it/T48+KlxW8h+l
 g7qRBaJ07DTFKyeyljrnkkLdI4Y+Ds7m8xNRWkzqyvlP8s/V7dYQkwnfQr3D0Gg1ey6Dfmrqwcw
 WkwUguYZu49NjseRNnfqNgioVw9HvuLcsUW6aU2rOqexhcq8OjFcWzLS9CuBXc6o25MxTIPrO2f
 fHE9jgGGjfhGfmHNLqJhn/2mYRmw2ErGv8MmjUzUpP1wrNoV1Lnb4itnzWhL/7BXJfdkyoIEVg0
 pplcBQdRg5yVIptneWw==
X-Proofpoint-GUID: _PPqmellvLLB7xxmDrdcRd4TzpSSLtUs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0 clxscore=1015
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603160111

On 3/16/2026 9:55 AM, Matthew Rosato wrote:
> On 3/12/26 1:42 PM, Joshua Daley wrote:
>> virtscsi_handle_event() is not used before its definition, so remove
>> a prior declaration.
>>
>> Suggested-by: Eric Farman <farman@linux.ibm.com>
>> Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
>> ---
>>   drivers/scsi/virtio_scsi.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 982f49bc6c69..6efbeaa30f65 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -233,8 +233,6 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
>>   	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
>>   };
>>   
>> -static void virtscsi_handle_event(struct work_struct *work);
>> -
> 
> Hi Josh,
> 
> You can't make this change until after patch 3 where you move the reference to virtscsi_handle_event further down.
> 
> In other words, if you just apply patch 1 + this patch you will get:
> 
> drivers/scsi/virtio_scsi.c:383:13: warning: ‘virtscsi_handle_event’ defined but not used [-Wunused-function]
> 
> until you also apply patch 3.  This breaks bisectability.
> 
> Please either re-arrange this series so that this is the last patch OR squash patch 2 + 3 together.
> 
> If you choose the latter approach and keep this patch then you can also include:
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 

Thanks for catching this. I'll re-arrange the series so that this is the last patch.

>>   static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>>   			       struct virtio_scsi_event_node *event_node)
>>   {
> 

