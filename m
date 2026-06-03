Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1AF3AB482;
	Wed,  3 Jun 2026 10:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780484217; cv=none; b=Rtioz1F8sh8Z4hsvasxexJigiIu+lY0q9fB6zjPhtdA7PXGadFUOdl1XK2gWAnLAaGu3LiR/4wofpeudHkswp5VukhkdDgZp1es8lm+DvoHB5AahkUFW7zY3wgvc+KNN7ue2s1GnG1tmeJCzUoJv8IIJNU2x8S2uVE4hcqQLoRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780484217; c=relaxed/simple;
	bh=Tja5yhCofjmsVJ+sBi06G3oUE1wx2TP7zmSjMFMT0Sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bhsi5UugDbzT9EJj7ug2IrHXlYk0ll0JzrAhRJxs5Tx2LYHeqOPhmicBCoKcm25WrePlgMTRDfs7FO5BT4fVqGVdJTbaxJqo1w+pahv/MgUMM5uUrtqFxZQY8dPlAcyds1U83DberOFz6XfTHE5UveHh74OxsVW42D++AxgsD0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sKontEXL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sKontEXL"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 652JdW1b1276410;
	Wed, 3 Jun 2026 10:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=itkTAH
	ASZK2OQqLGjrU2zc88p58uCLzscZjgdkGwxXQ=; b=sKontEXLXj/EkcVZLWDnrC
	pTOJdWMTnwKHhpb8qjyzwRQngW+Qt9fTqt17cAViGaW7mqC6Qbz5nYHN1s91rvtH
	xKS1GvzLHg/7RdUwffQnFk8f8X4jDDPp3twqK4u2YFT1vcFkcPfExOleu53QUqf6
	Oc0TLva+cSHR/edYbkk/kC4jR9kesRkzG0jqYcXEI0wZroSZjg0wyxbObJCzBHoH
	JAJIy7kvovToTPX6XjbdVpeb/k/AtN8ifF6DdCH5F6KOM/Wq0P8he4FtfKKQKgv9
	ecc2+WNeUHBhgwwAqzPZsRgOdwdfZyEmayG5LrjNugwba986sf+n+AALrPWFidNQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqm52evk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 10:56:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 653AsIKK017636;
	Wed, 3 Jun 2026 10:56:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egakvywrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 10:56:45 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 653Aue6125625156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jun 2026 10:56:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EE7E2004E;
	Wed,  3 Jun 2026 10:56:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB1D92004B;
	Wed,  3 Jun 2026 10:56:37 +0000 (GMT)
Received: from [9.39.23.37] (unknown [9.39.23.37])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jun 2026 10:56:37 +0000 (GMT)
Message-ID: <5124c4ea-743a-4047-9d5e-990a7e9907aa@linux.ibm.com>
Date: Wed, 3 Jun 2026 16:26:36 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [SCSI] qla2xxx: Handle the INTx not connected while
 passing through
To: Madhavan Srinivasan <maddy@linux.ibm.com>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        Kyle.Mahlkuch@ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@nvidia.com,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, harshpb@linux.ibm.com
References: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
 <66039318-07c0-4453-a295-bc39a2a5b8ec@linux.ibm.com>
Content-Language: en-US
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <66039318-07c0-4453-a295-bc39a2a5b8ec@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MCVu_sUZo1C-csPGwBHbygqPTh7FtzWY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDEwMiBTYWx0ZWRfX6JxFg+ZsWBxT
 fWDNU3zOxEQ1hB5jwQhvs38CYftcsoMWSR7cQNbQkFWGitsMWmpdrKJVXkVpBROg82Kmy4Uric6
 wT0mZx2nN3K+JvdRAq9MeUmH01lFAC/6GNlPlyrsl6tQf1jxKFW0V0GezhuPHONb6d+hsXDw+cH
 sjkQf5OlCU10DcjCrrMi9MzRQBoaUNsmhky/ZGPkVbKMDD0WDeFs6s3Njbr686aJMS6n579l3iE
 wy1/lY9Q7IQQRjXHEuiBiBolU3stQ9OcQvpV/cw+HLW9W2sM5GOs4XfRXg2rSVUz7bHq+cpArZO
 xzHvnf4smAMW7uDokOXOMGV7pVjR9bYsyYvGpETlamrIa9oFZQdea4kdO25oyKZwev32LeB7VkL
 l92n1I6LbFWpXgADM47qHWCCOPnkgCyJk6e4qM/WJDXFUhoxwtteQUH5hCRWLtpD+N+qDWNprIq
 Zk8NSyMWE19JCCLJSkQ==
X-Proofpoint-ORIG-GUID: MCVu_sUZo1C-csPGwBHbygqPTh7FtzWY
X-Authority-Analysis: v=2.4 cv=Vf3H+lp9 c=1 sm=1 tr=0 ts=6a20086f cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=enu2mHtoF2I52F_0tAQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606030102

On 6/3/26 1:42 PM, Madhavan Srinivasan wrote:
>
> On 5/15/26 7:15 PM, Shivaprasad G Bhat wrote:
>> The PCI_INTERRUPT_PIN reports if the device supports the INTx.
>> However, when the device is assigned to a guest via vfio, the
>> PCI_INTERRUPT_PIN is set to 0(i.e none) if the line is not
>> connected and|or the platform cannot route the interrupt.
>>
>> In such cases, the guest PCI_INTERRUPT_PIN is 0 and the port
>> number becomes -1(255, uint8_t underflow) for qla[25|27|28]xx and
>> qla2031 devices. The flt_region_nvram is never set, and subsequently
>> the lun detection fails. Below warnings show the NVRAM configuration
>> failure.
>>
>>   []-0073:1: Inconsistent NVRAM checksum=0xffffffc0 id=HCAM 
>> version=0x100.
>>   []-0074:1: Falling back to functioning (yet invalid -- WWPN) defaults.
>>   []-0076:1: NVRAM configuration failed.
>>
>> The patch handles the case, and sets the port_no to devfn like
>> its done everywhere else.
>
> Any update on this? do you have any comments/concerns that should be 
> addressed
>
Hi Maddy,


Priya has tested this already. I have requested Kyle to help with 
reviewing this patch.

Meanwhile, would request Nilesh, James or Martin to provide feedback, if 
any.


Thanks,

Shivaprasad



> Maddy
>
>> Reference: commit 2bd42b03ab6b ("vfio/pci: Virtualize zero INTx PIN 
>> if no pdev->irq")
>> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
>> ---
>>   drivers/scsi/qla2xxx/qla_os.c |   15 ++++++++++-----
>>   1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_os.c 
>> b/drivers/scsi/qla2xxx/qla_os.c
>> index 72b1c28e4dae..a8d6a0a021f4 100644
>> --- a/drivers/scsi/qla2xxx/qla_os.c
>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>> @@ -2803,11 +2803,16 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
>>       else {
>>           /* Get adapter physical port no from interrupt pin 
>> register. */
>>           pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, 
>> &ha->port_no);
>> -        if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
>> -            IS_QLA27XX(ha) || IS_QLA28XX(ha))
>> -            ha->port_no--;
>> -        else
>> -            ha->port_no = !(ha->port_no & 1);
>> +        if (ha->port_no == 0) {
>> +            /* None of INT[A|B|C|D], may be virtualized by vfio */
>> +            ha->port_no = PCI_FUNC(ha->pdev->devfn);
>> +        } else {
>> +            if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
>> +                IS_QLA27XX(ha) || IS_QLA28XX(ha))
>> +                ha->port_no--;
>> +            else
>> +                ha->port_no = !(ha->port_no & 1);
>> +        }
>>       }
>>         ql_dbg_pci(ql_dbg_init, ha->pdev, 0x000b,
>>
>>
