Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A01F411FBB;
	Wed,  2 Sep 2026 22:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386411; cv=none; b=HaRJ1j0G2mW5D6wwbEwaNH87Cge1tY1STTAxnUz7sz9aI8nRmnMyLDPNczwMWSNjg8wi4kABpqH7JIK9QcLzNfCuXXmYdweX+T2J2dPcMO2+gZmx8ctCXHdNrq+J/Rm5vi0rYv+MzRjz2VktleY+56SP2ygpnhsID6E4dVW3zjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386411; c=relaxed/simple;
	bh=RxferuzDFuSbUTZl4VqGbQKJ81mzu0r8UBeir/ECTvs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=guR2nXKD0VVepW+drFdDo6xFjZeT0D6ht42U09lNjlcVmR2vyC4PZpSQmGi5FjByfyrpGnf2dEQ2kxZScfH1RoXX5ZlFQggHFuh0ePGnF0vEJFyiRdZAMHQZAliogeXhzab5PMigJQpa2lpLeugVzXa0Q+Zu4KKTcm2ObPsIyAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pphpEK7S; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pphpEK7S"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682KWNsl1101962;
	Wed, 2 Sep 2026 21:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=HbrQinKiuwIELQ8uXe9LL9gkB0aFxD
	aolH1aBA17mXk=; b=pphpEK7SO749ucM9OrmyUWzo/NhRwkAiPQeDJYeGUfYeIX
	/uTLvfX7PYfWivexsnOCvejqV0YPjOCReDOOEx0W1SQhIdECZT2cQsR3WYbWt7VI
	bpwrxK0jEqNbs3Qxwqci4TsLxJoim44Kt68MAP464C7kKuuXi2PfnwHEXoUKTeqD
	xtuiYs2noupijusINfbOie34/baM+iiSy5ZnSUuCVjM0z+/kizaFx/jKAJcoB/Gv
	rw2qe8e34VH7JCfcJhb5Q3fBvIZSR7PYX0wbhMDnc1shGdwbZ/tqzaH17Ak9E0K6
	+ckAq/UnTdhbk90SV2e1+7ZZdUmudiXSKoN5kIEA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq2th6rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 21:59:57 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 682LuQrr032171;
	Wed, 2 Sep 2026 21:59:56 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcb8hmjaw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 21:59:56 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 682LxuXI25756166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Sep 2026 21:59:56 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F30AD58055;
	Wed,  2 Sep 2026 21:59:55 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB2A858043;
	Wed,  2 Sep 2026 21:59:55 +0000 (GMT)
Received: from d (unknown [9.61.186.94])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  2 Sep 2026 21:59:55 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 1/8] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <20260831213004.085A21F000E9@smtp.kernel.org>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
	<20260831-ibmvfc-fpin-support-v7-1-77d0b9809080@linux.ibm.com>
	<20260831213004.085A21F000E9@smtp.kernel.org>
Date: Wed, 02 Sep 2026 16:59:55 -0500
Message-ID: <87h5k71fhg.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=bc1bluPB c=1 sm=1 tr=0 ts=6a989c5d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=IdwDRE5yX8KDUOCRT-QA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE5MCBTYWx0ZWRfX3G8v48gNVqwz
 7r6/wI+XpTZH9me45Bn/RdVTeww1phCWO+tKhV75Img3OlM81HGpsinPA3n7Rj6afDRfULdsjhr
 ULVnddJ6h94l1BSs5sWtS0cp5+U9H90=
X-Proofpoint-ORIG-GUID: G8WPG3FpjGWGEEFx7w4u8hPAPntHAjcv
X-Proofpoint-GUID: G8WPG3FpjGWGEEFx7w4u8hPAPntHAjcv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE5MCBTYWx0ZWRfX6kc1ygLUHRil
 JZ9gdHmkjXUrFnLATAyQFl50rVvzoA5C+tlVMo8f1+hpS8kPj2RTzcnsGKcnGG1yDNuMvoikwCZ
 r5qbggPaj29QDpXMgkow7atr4mQTlfKjxTspLlCEcKVIeSul3h7lTXa/zYw2Rp9E+ys09W6h6K+
 RUfwaBj2R4akskm/Q34tgWZPu5L4YiuyKiWAkKC4NIxBRGu63bqTpsF8YZpF7egb7pu4AD22DUA
 4fNDGYt5Ga9tEnmMcP/ASv/R7uyoC1zJar47OTC/QRBQMvAMle/S2j/JxFWjthOaYAOEje4ndyB
 IKJmEfDSjkE3AiY6LXZwlZIIpDwBaf5UWzGGoT4dZBoWTFZ46QvpWncVhFC/KQldZ4WNpOTfTud
 qNLY9ER7jNz86q9KluNztqf+YL40zXrWJuZZRQQDcoG2B8iV2Ra1OVfdQL9EECRJ38xnnkjBEQw
 XeONG4QmqIlEIBhgYWA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_05,2026-09-02_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020190

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Teardown ordering race allows FPIN works to execute on an unregistered `fc_host`.
> - [Medium] Lockless traversal of global `ibmvfc_head` list in KUnit test risks use-after-free.
> - [Medium] The KUnit test accesses `tgt->rport` outside of the `host_lock`.
> --
>
> commit 6a259111a28ef932ad14496cabbef71084312dfe
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add basic FPIN support
>
> Implement support for a basic level of Fabric Performance Impact
> Notifications (FPIN) in the ibmvfc driver to enable monitoring of
> fabric congestion and link integrity events. Offloads FPIN processing
> to a dedicated workqueue and adds a KUnit test module for validation.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> new file mode 100644
>> index 0000000000000..8a73ea1b1da8c
>> --- /dev/null
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> [ ... ]
>> @@ -0,0 +1,146 @@
> [ ... ]
>> +static void ibmvfc_async_fpin_test(struct kunit *test)
>> +{
> [ ... ]
>> +	headp = ibmvfc_get_headp();
>> +	if (list_empty(headp))
>> +		kunit_skip(test, "No ibmvfc devices available");
>> +	queue = headp->next;
>> +	vhost = container_of_const(queue, struct ibmvfc_host, queue);
>
> [Severity: Medium]
> Could this lockless traversal of the global ibmvfc_head list lead to a
> use-after-free regression?
>
> If ibmvfc_remove() executes concurrently (for instance, during a device
> hot-unplug), it could remove and free the vhost structure while the KUnit test
> is still traversing the list.

Yes, this is a potential problem. I'll be using a new routine to get the
first vhost that's referenced with scsi_host_get(), or NULL. The callers
(tests) then must use scsi_host_put() before returning.

>> +
>> +	spin_lock_irqsave(vhost->host->host_lock, flags);
>> +	if (vhost->scsi_scrqs.num_targets < 1) {
>> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
>> +		kunit_skip(test, "No targets");
>> +	}
>> +	tgt = list_first_entry(&vhost->scsi_scrqs.targets, struct ibmvfc_target, queue);
>> +	if (!tgt->rport) {
>> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
>> +		kunit_skip(test, "No rport");
>> +	}
>> +	kref_get(&tgt->kref);
>> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
>> +
>> +	fc_host = shost_to_fc_host(vhost->host);
>> +
>> +	pre[IBMVFC_AE_FPIN_LINK_CONGESTED] = READ_ONCE(fc_host->fpin_stats.cn_device_specific);
>> +	pre[IBMVFC_AE_FPIN_PORT_CONGESTED] = READ_ONCE(tgt->rport->fpin_stats.cn_device_specific);
>
> [Severity: Medium]
> Is there a potential use-after-free regression here if tgt->rport is
> dereferenced outside of the host_lock?
>
> The test grabs a reference to tgt and drops vhost->host->host_lock, but then
> reads tgt->rport->fpin_stats locklessly. If an event like a link down triggers
> ibmvfc_del_tgt() concurrently, it can schedule the removal of the remote port.
> The worker thread would then call fc_remote_port_delete(rport), freeing the
> rport while the test is still dereferencing it.

Yes, this is another problem. I'll be adding device references to the
rport in the tests.

-Dave
