Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC302550D5;
	Thu, 10 Sep 2026 23:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789082554; cv=none; b=KyNO11HDN0pM+ZyZZqfImUrQjcV5dGU9qPGOXmVlu096iARCA3HhWf9DlO/Hy7mHGF8QY5mEh1kBTe4c249HgLxfkpIyOrkbgV4FfQ0pCLJRZesSM4RFbVMyl+f0WiiBOC5YOosFXMFaMRlUFX+NNxyqUqFc0W72H+Y5Ds2wuy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789082554; c=relaxed/simple;
	bh=eWfyrGN7T5d95WgR64ERiUYIFqGy8ng84//fIQk3uaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IrmfgI7PLXHnoSSVWJyPSrJVuBlhwJZL1Xe6SBhELWmthlkCLwT9wyVHvlen0u2QykNgXLeek3jxZdk4mWu3OHjNm5WUcOuTunwnzHHAKXTYwvo2QP5QpZOc3uyKFQgO0t1iDAAWhP9NOUAY+dgvKSdlZlRy6Ki7dQ7xS9p680M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UwPaqsL2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UwPaqsL2"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALVTmM4091787;
	Thu, 10 Sep 2026 23:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ipxB8r
	z11PIxv9SqRXPb9ZFDOauqFO2bO6r/38LfXBE=; b=UwPaqsL2MBs37y8wsVa7Pg
	gkv4HDFgLq/ONHFBkTZcSozSJt3YCIxCdmoagrIyU/TLUzBYXD1HJIlhjaLg0R8O
	NKXd21W60lxJ5GLRvASD4UrqHQeS8tAWN6uKWQ/RiKTPOn8S1v/pUp9/qkiUo5Kf
	HWMA2gdYjWZLUq7z1GE2BbIaWUISx/hmyp54IoZB6JYz7+4Qfi++LbM01EDmHDVx
	KHqp1S6u5U+El7WRNzLwpSCAppmzAoee0HRnMyXZ1hLJ+vQdEBusxKtb9Dpg1UL4
	W4+XEc8q2hbFrKtbQvZmonVYfOfT8R7awgUQTyVdY3h/HKb1RzqA0R6mNnhgXAsw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8qr448-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:22:22 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALZ12R619325;
	Thu, 10 Sep 2026 23:22:21 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvvrb49g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:22:21 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ANMKBh29229742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 23:22:20 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08AA458060;
	Thu, 10 Sep 2026 23:22:20 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 260625803F;
	Thu, 10 Sep 2026 23:22:19 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Sep 2026 23:22:19 +0000 (GMT)
Message-ID: <5e3c1e03-26cc-4374-bc7d-a62078448988@linux.ibm.com>
Date: Thu, 10 Sep 2026 16:22:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/9] scsi: ibmvfc: fix IRQ leak and guard deregister on
 channel reg failure
To: davemarq@linux.ibm.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260909-ibmvfc-fpin-support-v8-7-b27183b055af@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-7-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=SpUFe/O0 c=1 sm=1 tr=0 ts=6aa33bae cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=h_tiGb6L9mVtcfvnarcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: jyca9Frngx7CXzeTQVyMQSi6TRseadcR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI5MCBTYWx0ZWRfX5RW8z+AO6YUM
 O+uiXKWU7WdJIL+w79UpIQxvRKOYQC5eoTm6cwN0nESPeT4bGnu7DMCWQowWTXTygyQUWjM8XUh
 l4IVhuYFPtfinFDn7CgUgiIw8XLTGJQ+cFSs8kTnrt8RxtWatqT+7pqdd+9WZoqukCXbFQD3fys
 zBDXK29PbHwHPFhPCCwgy2FdtA8a6YP3rS9AT7+cxEzVL+NjfVd9KJUgqvWu2+OLZhRpLW+viwB
 TfCw/oEvzDqHeFtQZj7ugIS4NFctkwPn4gNMIvS1uea5bkQBiYhwglqupLHJ8n8MhC4UDbTanxM
 3SEMeCy0KpKRZ76V1IWVUZdi3C0jU8TYX8s86sRr2Uz/JDuZ7cZhLEjE3xfh/7/8jzgBzFU50Aa
 L4ZB4k3fO2ty9eDSgDZtZGAoQgvIfbNH9Zpy4y4LOLtk7jJ8BAPvZ5JOZejirM3F8VGBy7dnDXF
 HqW/bDbB4zbIcr0k+vA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI5MCBTYWx0ZWRfX1uaXpdca2F65
 YFTnAsT7ayBsRLA6XG1ECKOanqZElyUjrltECYBOSKUcYVA5jIEkz+5HnGBIMWcz89N/+5pvovo
 XkM4p/faF3nWW281sD7GewdUcO0LNio=
X-Proofpoint-GUID: ECO-hezQbJbCZa2Hu-S06-Uk4cobxTNr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100290

On 9/9/26 12:08 PM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> If request_irq() fails during ibmvfc_register_channel(), the error path
> disposes of the IRQ mapping via irq_dispose_mapping() but leaves scrq->irq
> populated with the stale virq number. A subsequent call to
> ibmvfc_deregister_channel() during teardown or reset cleanup then
> unconditionally invokes free_irq() and irq_dispose_mapping() on the stale
> IRQ descriptor, triggering kernel warnings.
> 
> Fix this by:
> 1. Explicitly setting scrq->irq to 0 after irq_dispose_mapping() in the
>    ibmvfc_register_channel() error path.
> 2. Guarding free_irq() and irq_dispose_mapping() with a check for scrq->irq
>    in ibmvfc_deregister_channel() so unmapped or unregistered queues are
>    safely skipped.
> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> ---
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
