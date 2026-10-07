Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2A33783CC;
	Wed,  7 Oct 2026 19:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791402748; cv=none; b=phW4yhhxANVaHUijzpv3FwZ4V9c98QoR+VVU6DjfskF5c2e1PTwxGh4PDIndr09SsvSPrW8KQ6NW8IGCEZrpfcYThkcARNkTM7lIcc2GEsRWdTONghF2QVyGUznVYzJk1ABJRQm3fvwlFctbFmSaylP2vErSbSGQKbmBtYY8M5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791402748; c=relaxed/simple;
	bh=Gw9twuohb3+sej2zMbWh2El2rEQ4f7pxJsQKxrwHok8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ob5yGwjsgCfJdOzGj0J93HJJrQUlzPVr1YeDv3zjn+4S6ESV2rZjCVjuvZ2+mafVbzVtkriL99j9jxTz/QgGXpzDOv6oQryAMXmLm0hDBlramwoE+e8l7qQxsaEH8nBlpAuoqg5kx+BM8Gptt6cZjbEv2ku90W6X6UPOnsFSHFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dmn1l79x; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dmn1l79x"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697IZZP73153330;
	Wed, 7 Oct 2026 19:52:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=dKRScO5r615KZAfb7svv7nu/uZyCJ9
	6iLwurAz89e8o=; b=Dmn1l79x+HV1myDWZKBf3faEJJJrtrw6C7eiRL+kdbwYHw
	T4fZD4pl+NgqotIWPsivEd0NS3QrVg7Uax/+kGXB4Q0jIVnzz0jMOZ/qT/8s9K67
	6T64/kKUhYu2cOk2FmNmzPlIqx4qtxB3GvvkVnH5MwOhR4bHjn5Dr7bs/tqHpFIG
	VwVB1jW3x+ISZtmniHFdpyqG89mSNFpJVwFd6BvphvQxhwYuCowjnJXif0hREWlk
	HitEOlL10E64DJxRbSseYEawI5gnB84Ey6TB7+so9vneBWA2CwvufdlITGnw9uPI
	ujWg0Ume2Fu0Q8izjt1S1h03mIzEgHhh912w9Hxg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2q4jy07s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 19:52:24 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697IHVXM2301990;
	Wed, 7 Oct 2026 19:52:24 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5a6dm3bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 19:52:24 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697Jpcmp17302068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 19:51:38 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E82D5805E;
	Wed,  7 Oct 2026 19:52:23 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3357A58056;
	Wed,  7 Oct 2026 19:52:23 +0000 (GMT)
Received: from d (unknown [9.16.59.154])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  7 Oct 2026 19:52:23 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v13 11/11] scsi: ibmvfc: handle extended FPIN events
In-Reply-To: <sashiko-outbox-163310@kernel.org> (sashiko-bot@kernel.org's
	message of "Wed, 07 Oct 2026 19:33:54 +0000")
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
	<20261007-ibmvfc-fpin-support-v13-11-b816abfa4fcc@linux.ibm.com>
	<sashiko-outbox-163310@kernel.org>
Date: Wed, 07 Oct 2026 14:52:22 -0500
Message-ID: <87o6d5b85l.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1XDo8Ik7WrQsy_DczPE3eHZTLMSQPF9Z
X-Proofpoint-GUID: 1XDo8Ik7WrQsy_DczPE3eHZTLMSQPF9Z
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA3OCBTYWx0ZWRfXzhkqJik5gdnH
 AyLp+DR7t8RTCM7ezDKo0X3Vi6OW4USuGf50oJj3dbB7u48mOug8EjIfNcFct6NBG2R7RDsRt26
 Wc6qNyLIr9MBkW0f4BJcvzIzfnZjMfU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA3OCBTYWx0ZWRfX1I05mh9SuVzc
 L10+52Jt8AJ/I3X8yhTY4Tq3tQTFBgDm1ZOYA+XrkZH5gmAUHpcgCfUV9TQ2Q75Oj6aTpy9+hxx
 lYrH7WsRh+qM9W+rGxouBzq0HZEXgc0AHsP1AUqznd8oBZcIzd1ezKrxdiSjpsyYby5r3LQ6kVq
 Rue/AeSHVar7i8+lEOoLswVRIYZzZnnN+U88GGk7f0LT+quFlDi7SS4fJ1HDA00KvKMGf5Vit/N
 UZWAo6AEztk7nGuzSNSpp3vCNUleidgO9oZXzQcgzIUK8MXtE9jkPlAue1bokTPK0fAecuE39RL
 rx4AN4QZ6bYlNX2AQGr2yn8+NdvlO4BvItxh72XGwMJzLdZAAMTQwKWCKWXwbzYh7MGRmeELOnb
 QGUHUL0dxZlHPR+MRsdvQhsZ1PRhN7aYJDqU/oLViEgEaYS5HPsO1XN3amRoNE7+ecxJ83yvmBj
 vc1wn+6GepbNuZgDrew==
X-Authority-Analysis: v=2.4 cv=eYeo7LEH c=1 sm=1 tr=0 ts=6ac6a2f8 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=QWrK6ewHXOknnRczYwsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_06,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070078

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] scsi: ibmvscsi: unused list head variable `evt_doneq` in test
> --
>
> commit 7276d45825dded3ce9d906eb91c3d06e314dc430
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
>     scsi: ibmvfc: handle extended FPIN events
>
> This commit implements support for extended FPIN messages via the
> asynchronous sub-queue. It introduces new capabilities and unit tests for
> extended FPIN event handling.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> index d2ef35e928eae..cc6e6d0b5f963 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>
> [ ... ]
>
>> +/**
>> + * ibmvfc_extended_fpin_test - unit test for extended FPIN events
>> + * @test: pointer to kunit structure
>> + *
>> + * Return: void
>> + */
>> +static void ibmvfc_extended_fpin_test(struct kunit *test)
>> +{
>> +	enum ibmvfc_ae_fpin_status fs;
>> +	struct ibmvfc_async_subq_fpin crq;
>> +	struct ibmvfc_target *tgt;
>> +	struct ibmvfc_host *vhost;
>> +	struct fc_host_attrs *fc_host;
>> +	struct fc_rport *rport;
>> +	LIST_HEAD(evt_doneq);
>
> [Severity: Low]
> Is the evt_doneq list head needed? The variable is declared and initialized
> at the beginning of ibmvfc_extended_fpin_test(), but it doesn't appear to be
> used anywhere else in the test function body.

I agree, evt_doneq is not needed. I will fix in a v14 series or we can
let this in and I'll fix it separately afterwards.

-Dave
