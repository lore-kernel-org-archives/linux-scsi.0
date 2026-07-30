Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559383A9DB9;
	Thu, 30 Jul 2026 23:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785454084; cv=none; b=Ju2VS6tPmq4jZO//m+nlVlGGm7CBohLbiGr/AbtOsd4ubjYz9U4a9SYikVChC/UgaBkXGWJhPxRnnWgoRpF1+Ao/vjieiBr1zzfMOE5UFjCx0fMKjtb2E4VYT6ZooWmM7adIJOgny+k6H4gwYFL48/UMGeZu6GpNYaCpgxfrwXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785454084; c=relaxed/simple;
	bh=9I3PK4mCan59rOFkoJnY/JtwETqGaZNzExqWJqjlbmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QNMZJPEtaQvuNLd84ui2Vyi9sirD8j4eWz4OlZ+rz/bOk3jt66S0JxIfNzq7gxiFFX/tPstBldDzlnu5p/HexW7l5ugk5naSANv+aDr41/6sAafYT7F+aCg9XZbV+3oiBS6h8ykOT9+q0iMuzIAMNJcbehE2TLzRYv0pUuAHE+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cD2t23rG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cD2t23rG"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UNHe6q117992;
	Thu, 30 Jul 2026 23:27:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OfkKlM
	MM8oJLbZihosEtrpQ1IaN+jIeRBx39f/HKrss=; b=cD2t23rGukGSpV/AbTPRkB
	2t8mllJcszxjYdvOs6litUDLbB5YFvDl7tM+BwxA1PPFh/d2uMeQKS8tJ+wiVV7j
	gwQ6IsSq80YnyNmTfx0QKUJwqaiJXQ+H/YBmB6lyPIWyv7dYZU1vYkg1309gW+RA
	jo/DZ5nbZqC9mm7avljeaxr3shUs7Uf8DEWLKFXuEAyTQPbaHhtzw3rvGIMNC5K7
	EC16rPoYrobuirk9ocuEu4pWr+Ner03r5s7UfEqorAJcBKr1XTbBSXP6qRVxulbD
	w2dz9O28rz9vMqerAq3THoap9zwZMNBrrkqtzvoaqFxEoh27cwkebbZDziE/vtTA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0p1d7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 23:27:49 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66UNQWGp028175;
	Thu, 30 Jul 2026 23:27:48 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn7uwdqx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 23:27:48 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UNRlMa10093210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 23:27:47 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CEE358056;
	Thu, 30 Jul 2026 23:27:47 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 900A658052;
	Thu, 30 Jul 2026 23:27:46 +0000 (GMT)
Received: from [9.61.73.28] (unknown [9.61.73.28])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 23:27:46 +0000 (GMT)
Message-ID: <6ccbe8c5-beb6-483f-bfa4-c2d3819ad5f2@linux.ibm.com>
Date: Thu, 30 Jul 2026 16:27:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/33] ibmvfc: process NVMe/FC rports in work thread
To: Bart Van Assche <bvanassche@acm.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-26-tyreld@linux.ibm.com>
 <20260730065226.GA1879117@ax162>
 <86ee4f27-7303-43c4-b772-b735b85c0229@acm.org>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <86ee4f27-7303-43c4-b772-b735b85c0229@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDE2NiBTYWx0ZWRfX7XYndK/1j2v5
 9KoYoyh1m/cbTFSdVR/aQ5U0qDDpQ4avuGfbQ3IC9Xn2XyCX2qWxlN92fq7WIhiC7iI0Od+dnNV
 GY1Dyxbhlrlqp02hw9+pMsgnAXKss6Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDE2NiBTYWx0ZWRfX3qQPWQJIDfbp
 sjxjGu7EHTPuBQ0raHoPKFZB4FkdjNiwmdZ557dP+EYN51qdNNyDyE4ziZcSSlKF9QZ2exI67jQ
 iYY+ckmm4wEFR4o2b5LW7WvPnu544QwKHAQC5B8DzKH6mkdtzgGze52aZhqnS3WUpgQV0FgHXLf
 xH4TMozMFJwZ7Ity/oB7jiITDJ+pha0fHS6YUjjPNlRXvzA62ckrvuE2KkO1ns13SxCGIPiGfOn
 +mQpQbtQwnpiYBcOyzqaWk0CINsEpqenSlWZDszGWkaKvjGNm/+XcMWhFVVXbjtxXR+U+BMIdzm
 SMTN/LdJwCRRkAf3jEXrML5uVqcbulNuHZoYystHZ0dRogwPw1XbF9w6OrLpFjubS6+FYYCgbsj
 dYaegR93gD9jFMrDAOtsiXuLzxQK9OmQDq0kTwGmcPsSCutmX+QXSOTqLC/5L18BdHpk9Qj8Pxc
 GQHut7/1vcPHPCNox3Q==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a6bddf5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=reDaP5zPGsiZX54FuSEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: iOzL0pz9vNx_bh2wxmciA65gtgzUf8it
X-Proofpoint-ORIG-GUID: iOzL0pz9vNx_bh2wxmciA65gtgzUf8it
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_07,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300166

On 7/30/26 2:28 PM, Bart Van Assche wrote:
> On 7/29/26 11:52 PM, Nathan Chancellor wrote:
>> Hi Tyrel,
>>
>> On Wed, Jul 22, 2026 at 05:01:41PM -0700, Tyrel Datwyler wrote:
>>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/
>>> ibmvfc-core.c
>>> index 81d9229bf388..ffb579816e84 100644
>>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>>> @@ -6073,6 +6119,30 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
>>>               }
>>>           }
>>>   +        list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
>>> +            if (tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
>>> +                tgt_dbg(tgt, "Deleteing NVMe rport\n");
>>> +                nvme_rport = tgt->nvme_remote_port;
>>> +                list_del(&tgt->queue);
>>> +                ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
>>> +                spin_unlock_irqrestore(vhost->host->host_lock, flags);
>>> +                if (nvme_rport)
>>> +                    ibmvfc_nvme_unregister_remoteport(tgt);
>>> +                timer_delete_sync(&tgt->timer);
>>> +                kref_put(&tgt->kref, ibmvfc_release_tgt);
>>> +                return;
>>> +            } else if (rport && tgt->action ==
>>> IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
>>> +                tgt_dbg(tgt, "Deleting NVMe rport with outstanding I/O\n");
>>> +                nvme_rport = tgt->nvme_remote_port;
>>> +                ibmvfc_set_tgt_action(tgt,
>>> IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
>>> +                tgt->init_retries = 0;
>>> +                spin_unlock_irqrestore(vhost->host->host_lock, flags);
>>> +                if (nvme_rport)
>>> +                    ibmvfc_nvme_unregister_remoteport(tgt);
>>> +                return;
>>> +            }
>>> +        }
>>> +
>>>           if (vhost->state == IBMVFC_INITIALIZING) {
>>>               if (vhost->action == IBMVFC_HOST_ACTION_TGT_DEL_FAILED) {
>>>                   if (vhost->reinit) {
>>
>> There is a warning from clang after this change landed in -next as
>> commit 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in work
>> thread"), breaking the build when -Werror is enabled:
>>
>>    drivers/scsi/ibmvscsi/ibmvfc-core.c:6154:15: error: variable 'rport' is
>> uninitialized when used here [-Werror,-Wuninitialized]
>>     6154 |                         } else if (rport && tgt->action ==
>> IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
>>          |                                    ^~~~~
>>
>> Sashiko appears to point this out as well:
>>
>>    https://lore.kernel.org/20260723005006.C7EE21F00A3A@smtp.kernel.org/
>>
>> But I am not sure that its suggestion to use nvme_rport is correct given
>> the context of this code, hence just the report from my end.
> 
> I think that advice is wrong because nvme_rport has not yet been set if
> the "else" statement is reached. How about the change below?
> 
> Thanks,
> 
> Bart.
> 
First off rport is an fc_port in this context not an nvme_rport (whoops), and
second we don't need to check for its existence at all here as we will get it
from the tgt in the else body and check it there. That check got copied out of
the add target code where we check if a target we are adding has suddenly moved
to being deleted.

-Tyrel
