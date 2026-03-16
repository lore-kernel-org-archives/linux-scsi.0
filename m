Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4451127A904;
	Mon, 16 Mar 2026 14:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773671928; cv=none; b=erJFsf1a6aqB+3zoZaUi5BoY2hVCrTYJyInqKsAlz27DzIXWCnfQUzvLDWHqkBSLy/oqenArYpeAA/Cji3gaXlceB6lsElLQjaDZLUMAuN7NWDhKRYSGLxOr5Kf5+c6otTaSOMwBrG78SCVz/u5Kt66MDiTo7Ox5LHgx/qU1eCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773671928; c=relaxed/simple;
	bh=0090eJcooTdKXKOrAZLQ/5eNj18Z5Zut2NvaJhrB2IU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJO3ioBmnxEv4uovFsTykZeNAKOypeHiikraZ0dLzFvrka9iYizk6zZ6i6iMwAT/yPYC0lTSIszkMbmW+pPIt82Gf4KW0VTmB3eNNMIqaAnQ56aqZL7cllqK+Q1ESPBAfO174qg7E6Sg5jo15TbHe4Mf+Hfo0K+E9sYhZeJl7vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y0dQ1Bno; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y0dQ1Bno"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G14ln41189633;
	Mon, 16 Mar 2026 14:37:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=mhwIm+
	/GMqVAHDowP5d2xzv+Fojpv77dsGveYO72hEk=; b=Y0dQ1BnoBHc1nMZsLGMxuD
	/GymKqCdDhoLjtWVgDRZnN80yYVRXMMjG3ubzJHLVjlpagze8Q0kOR19iivDDGwZ
	J1Pji4eBXF3XE/EOEJkUiHhicWuIoeuG09A3+LV+RpFO2PwdMCRz2eP+P8Cpwxvu
	1LwiOhImGhzYg6Ylo/hSKIHBZ/pWVfSHs+0Cmz2g43wmasB/b5LNKBss5LCSq/dP
	i0VILbH9PoEYEhNjWzWCugSiSF39sfisWjeoERXP64H/F5wrJpqiai7+ZtNl+PWL
	1z2KHo/ZDwkv7LQ2E6NqDzglJUcMgDqyZORvgttZpJfr7sveZLh/OiI5f7oj8fqA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cx7vfak7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 14:37:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62G9umgX014033;
	Mon, 16 Mar 2026 14:37:46 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwjcxw8rn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Mar 2026 14:37:46 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62GEbiJs31982326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 14:37:44 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E0F75805E;
	Mon, 16 Mar 2026 14:37:44 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6DE358052;
	Mon, 16 Mar 2026 14:37:43 +0000 (GMT)
Received: from [9.61.145.197] (unknown [9.61.145.197])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Mar 2026 14:37:43 +0000 (GMT)
Message-ID: <74fa682c-e07a-46a2-bd4e-c03ca6d906e6@linux.ibm.com>
Date: Mon, 16 Mar 2026 10:37:43 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: virtio_scsi: move INIT_WORK calls to
 virtscsi_init
To: Joshua Daley <jdaley@linux.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        farman@linux.ibm.com, frankja@linux.ibm.com
References: <20260312174256.1557045-1-jdaley@linux.ibm.com>
 <20260312174256.1557045-4-jdaley@linux.ibm.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20260312174256.1557045-4-jdaley@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _vyRgtQyB4wCjbifA2n-9YSEpUCpcIE1
X-Authority-Analysis: v=2.4 cv=KajfcAYD c=1 sm=1 tr=0 ts=69b815bb cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=vZcffsv9676pwnVvzI4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDEwNyBTYWx0ZWRfX29UOQOf/oojO
 tlE1tHB6oy8idFZMWMAw9bjthh9UYQIo37504V5+ijHMtaSoB+I5nqkTW3HcBRdcatCdkcC1DAA
 PwCM4nltAZm4cvc/GVe/+e79WoYQK11H9AThL3YPXEpXGU61R5jMqJkllSBn1dGCsHQdazkGY6K
 4bP6J5ngVFNcC+HU84a4zp7ARfZ5Kge5qvO+Xr2pQrwB/Z+1nqtSaHpyZheBnkRpfju1ACnKQG9
 c89Uc/R75ohklSHBOnfJY1YBzJJCzlw2kA3uewAoSaBCK9LVLxqQTd5nhvLBj9I9NErt8DP8cA0
 Nlu8EcyRbXLR3wrT5+wOl0CmdUosV6STekHh8zXOpBLWwGaOFgSe0UaINyRMT+wJglyS4NXJEVG
 QZVkatbj6H6XRFdWrzfRshfR4wb11uqsYLwh6+vpddI3Y8GxXzrufzSbCsinFH6K8k2QmbT0ygb
 1aW90X/6sBAh57Tj9EQ==
X-Proofpoint-GUID: _vyRgtQyB4wCjbifA2n-9YSEpUCpcIE1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603160107

On 3/12/26 1:42 PM, Joshua Daley wrote:
> The last step of virtscsi_handle_event is to call virtscsi_kick_event,
> which calls INIT_WORK on it's own work item. INIT_WORK resets the
> work item's data bits to 0.
> 
> If this occurs while the work item is being flushed by
> cancel_work_sync, then kernel/workqueue.c/work_offqd_enable triggers a
> kernel warning, as it expects the "disable" bit to be 1:
> 
> [   21.450115] workqueue: work disable count underflowed
> [   21.450117] WARNING: CPU: 1 PID: 56 at kernel/workqueue.c:4328 enable_work+0x10a/0x120
> ...
> [   21.450171] Call Trace:
> [   21.450173]  [<000003db2e5bdc3e>] enable_work+0x10e/0x120
> [   21.450176] ([<000003db2e5bdc3a>] enable_work+0x10a/0x120)
> [   21.450178]  [<000003db2e5bdd86>] cancel_work_sync+0x86/0xa0
> [   21.450181]  [<000003daae97d9e4>] virtscsi_remove+0xb4/0xd0 [virtio_scsi]
> [   21.450184]  [<000003db2ef3b5ca>] virtio_dev_remove+0x6a/0xd0
> [   21.450186]  [<000003db2ef9106c>] device_release_driver_internal+0x1ac/0x260
> [   21.450190]  [<000003db2ef8edc8>] bus_remove_device+0xf8/0x190
> [   21.450192]  [<000003db2ef88d72>] device_del+0x142/0x340
> [   21.450194]  [<000003db2ef88fa0>] device_unregister+0x30/0xa0
> [   21.450196]  [<000003db2ef3b2fa>] unregister_virtio_device+0x2a/0x40
> 
> This warning may occur if a controller is detached immediately
> following a disk detach.
> 
> Move the INIT_WORK call to prevent this. Don't re-init event list
> work items in virtscsi_kick_event, init them only once in
> virtscsi_init instead.
> 
> Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>

With patch 2 either squashed in OR moved after this one:

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>


