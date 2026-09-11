Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909E83191BA;
	Fri, 11 Sep 2026 03:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789098060; cv=none; b=Gm0vJf59ySX21dm0zaoFE/V4SAZHBl8xJE3l69w2atqeZGyfLLKTEdTe3MQ/3yCEfIdOwx1umgSwYqxE3kFw4g65c4/Y2117wMkI+llVw2gHeMPN4qw711ANK7qstZacZpZPuOmTmjMRMuAG1O9FzgqLyWkdU+32Xbx/h++6Vco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789098060; c=relaxed/simple;
	bh=GTboQD3cJpQpQdbRt2pODYATli8NlCKBsHanYpGQSt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EsPx6yVJJwDhsIL2P8nra+44iib6EH0pYrwvCWWux27ocQbB2qRUlrvXwvqnX08WBufFo4lLm8ezGDPeQRYE0YIasFD1wa/I+551AF1qwPW95aN5Esa3MQ8hv6t6g8EaPCZS7wZE/33kZaZhhX76OzLEE7YjBqsXEdyDQ09w4oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TlKhImLK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TlKhImLK"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12a3l2632510;
	Fri, 11 Sep 2026 03:40:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=O8wp+U
	oZWruA3r3KrvfjhE7t/AQFQTXPkDFFCEDTeN0=; b=TlKhImLKZcGC+Rgf6eqbes
	FI9EcloTDLcI4Y/qMBz2DDX+kdTJBOCufyZhdRDAITvhTA8OSvyasSP/ZQ22XCPl
	DOyek9B0E7n6B8WNJl12JKtE0H/ViJBW52hAE2GdVtWiDUwoiYRh7mGV5I5mQTG/
	1RDZ7tmdxTPa/JOgs7VNTExtTgL7eJw6+8M1D5U6tEDolb8Yqy79T/7jHfzs5WMT
	G8l4/Th6Sw+8OB94TsnnkYq1zFj2Wd829Sv2COj3YCpeEY3IfrLjDZzXqkIjy/sn
	fUnfKfV2vhvr/Sv+vHxgrwFOETaWhiS/8Y8D6VrrIw8DZC/rL6C7yRP78Okh2DMQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8n92x9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 03:40:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B152Bd891395;
	Fri, 11 Sep 2026 03:40:56 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvq2v5yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 03:40:56 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B3etF063504828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 03:40:56 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD7915805D;
	Fri, 11 Sep 2026 03:40:55 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8440E58057;
	Fri, 11 Sep 2026 03:40:55 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 03:40:55 +0000 (GMT)
Message-ID: <a21133f0-ae1c-42d4-8cfe-85d124ef2291@linux.ibm.com>
Date: Thu, 10 Sep 2026 20:40:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/9] scsi: ibmvfc: add basic FPIN support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-2-tyreld@linux.ibm.com>
 <20260911023853.C190D1F000FF@smtp.kernel.org>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260911023853.C190D1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=NMVAaE6g c=1 sm=1 tr=0 ts=6aa37849 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=tbyaGIdMawIsEPTAFSMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GXuvtQtezosqyQBGllfv3Xn6nYUpkAWG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDA0NSBTYWx0ZWRfX37dnoJx03L2T
 ixzhYJvZqvGvc4GtubZXCeMqaz7S0kNe73rlSc5/lmBtBNeunALBXDwGdp6xmMBBpw6LA0srrIu
 4dtdAtPuDCFDCNmUcDToZ/Q2o1PZJPeNSONJ/Zvj/aafKw8XWem1oWIwMhG/DDHccMNnEVNtC05
 r1Q1BDmLQCsYhDvW68uA00LLgGP56V5WTZOobjEtIK2F2A0Ifw10zlxJ/Hg44eifCXDu+8y7afL
 JTzSOcxecyuseQw/1zXysFu3+XlLY2hvv4cOEL68BfEtosMSZRh1zrPG4wZnPK+DLmgvuym8Vcd
 kFyUsQWMR5nKhDB5efB5LnW1ATzFrnGEuWPDd3wGgM77B5DyuFFMswxvfh38w2XoIi3ZW8jUtLh
 8zilr5CaHYEdePtS1wDpbu9mVy8qPOJ+LA0ICwo1xu2EOfWmC9E6Ck4ZMmlGugP7/S7eJTtSWaG
 VXjhhzNE96DzhXCeaDA==
X-Proofpoint-ORIG-GUID: GXuvtQtezosqyQBGllfv3Xn6nYUpkAWG
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDA0NSBTYWx0ZWRfX9Y0x/bZ4h1Qy
 Ma0jCTKky8yOHXwSj0NUgccTJCl/i6Ag5JcqDK5yzRvPG/5C0K0ky9+5OrTZJ2vvhrIdWJSWR2/
 nmFHQX2lq6xlvhJsq2bEGOcNFJ1SpHY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110045

On 9/10/26 7:38 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] ibmvfc_find_target incorrectly uses a logical OR condition, causing it to skip all valid targets and unconditionally return NULL.
> - [Medium] Reference count leak of the SCSI host and remote port devices in the `ibmvfc_async_fpin_test` KUnit test.
> - [Low] KUnit tests use undefined structures, macros, and incompatible function signatures from a future patch, breaking the build.
> - [Low] Missing '&' operator when acquiring/releasing the host_lock, causing compilation to fail.
> --
> 
> commit e20d55240604f534a630e6df915a24fb9e9b543b
> Author: Dave Marquardt <davemarq@linux.ibm.com>
> 
> scsi: ibmvfc: add basic FPIN support
> 
> Implement support for a basic level of Fabric Performance Impact
> Notifications (FPIN) in the ibmvfc driver to enable monitoring of
> fabric congestion and link integrity events.
> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index aa7ae81df41b1..5259a80958ce1 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> 
> [ ... ]
> 
>> @@ -3411,6 +3450,25 @@ static struct fc_els_fpin *
>> +static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target_list,
>> +						__be64 scsi_id, __be64 wwpn,
>> +						__be64 node_name)
>> +{
>> +	struct ibmvfc_target *tgt;
>> +
>> +	list_for_each_entry(tgt, target_list, queue) {
>> +		if (scsi_id && cpu_to_be64(tgt->scsi_id) != scsi_id)
>> +			continue;
>> +		if (wwpn && cpu_to_be64(tgt->ids.port_name) != wwpn)
>> +			continue;
>> +		if (node_name && cpu_to_be64(tgt->ids.node_name) != node_name)
>> +			continue;
>> +		if (!tgt->rport || !tgt->nvme_remote_port)
>> +			continue;
> 
> [Severity: High]
> Should this check use a logical AND (&&) instead of a logical OR (||)?

Derp, yeah this check is meant to continue if there is no valid rport, and that
would mean both are NULL. Will fix in v10.
> 
> Since the target lists are separated into SCSI and NVMe, it seems every
> target will have either rport or nvme_remote_port set to NULL. Using
> a logical OR here evaluates to true for every target, causing the loop
> to unconditionally skip all valid targets and return NULL.
> 
>> +		return tgt;
>> +	}
>> +
>> +	return NULL;
>> +}
> 
> [ ... ]
> 
>> +static void ibmvfc_process_async_work(struct work_struct *work)
>> +{
>> +	struct ibmvfc_async_work *aw;
>> +	struct ibmvfc_async_crq *crq;
>> +	struct ibmvfc_target *tgt;
>> +	struct ibmvfc_host *vhost;
>> +	struct fc_els_fpin *fpin;
>> +	unsigned long flags;
>> +
>> +	aw = container_of_const(work, struct ibmvfc_async_work, async_work_s);
>> +	vhost = aw->vhost;
>> +	crq = &aw->crq;
>> +
>> +	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
>> +		goto free;
>> +
>> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> 
> [Severity: Low]
> Does this line cause a build failure due to a missing '&' operator?
> 
> In struct Scsi_Host, host_lock is an inline spinlock_t rather than a
> pointer. Passing it by value to spin_lock_irqsave() causes the compiler
> to fail with an incompatible type error.
> 
> Should this be written as:
> 	spin_lock_irqsave(&vhost->host->host_lock, flags);

Yep, I took Dave's v8 as was and assumed it was build tested. I can confirm this
fails. Will fix in v10.

> 
>> +	tgt = ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
>> +				 crq->wwpn, crq->node_name);
> 
> [ ... ]
> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> new file mode 100644
>> index 0000000000000..80e7f8e0fd700
>> --- /dev/null
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> @@ -0,0 +1,408 @@
> 
> [ ... ]
> 
>> +static void ibmvfc_async_fpin_test(struct kunit *test)
>> +{
>> +	u64 post[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
>> +	u64 pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
>> +	struct ibmvfc_async_crq_event ae[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1] = {
>> +		[0 ... IBMVFC_AE_FPIN_CONGESTION_CLEARED] = { .type = IBMVFC_ASYNC_CRQ_MAIN },
>> +	};
> 
> [Severity: Low]
> Do these undefined types and macros break the build when compiling with
> CONFIG_SCSI_IBMVFC_KUNIT_TEST=y?
> 
> struct ibmvfc_async_crq_event and IBMVFC_ASYNC_CRQ_MAIN are not defined
> in this commit, which prevents the tests from compiling. It appears they
> might have leaked from a subsequent patch in the series.

Confirmed that this does not build. Will break this apart into the proper
commits for v10.

> 
>> +	enum ibmvfc_ae_fpin_status fs;
>> +	struct fc_host_attrs *fc_host;
>> +	struct ibmvfc_target *tgt;
>> +	struct ibmvfc_host *vhost;
>> +	struct fc_rport *rport;
>> +	unsigned long flags;
>> +
>> +	vhost = ibmvfc_get_first_vhost();
>> +	if (!vhost)
>> +		kunit_skip(test, "No ibmvfc devices available");
>> +
>> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> 
> [Severity: Low]
> This also seems to be missing the '&' operator before vhost->host->host_lock,
> resulting in the same build failure mentioned above.

Correct. Will fix in v10.

> 
>> +	if (vhost->scsi_scrqs.num_targets < 1) {
> 
> [ ... ]
> 
>> +		ae[fs].async_crq.node_name = cpu_to_be64(tgt->ids.node_name);
>> +		ibmvfc_handle_async(&ae[fs], vhost);
> 
> [Severity: Low]
> Is there a signature mismatch here?
> 
> ibmvfc_handle_async() is defined to take a struct ibmvfc_async_crq pointer
> as its first argument, but the test passes a struct ibmvfc_async_crq_event
> pointer instead.
> 
>> +		ae[fs].async_crq.valid = 0;
>> +		wmb(); /* ensure valid bit clear is visible before checking stats */
>> +	}
> 
> [ ... ]
> 
>> +	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
>> +			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
>> +
>> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
>> +}
> 
> [Severity: Medium]
> Are we leaking device and host references in the successful exit path?
> 
> The test acquires references via ibmvfc_get_first_vhost() and
> get_device(&rport->dev) during setup, but unlike the other tests in this
> file (e.g., ibmvfc_full_fpin_test), it does not call put_device(&rport->dev)
> and scsi_host_put(vhost->host) before returning. Leaking these references
> can prevent module unloading and device cleanup.
> 
>> +
>> +/**
>> + * ibmvfc_full_fpin_test - unit test for IBMVFC_AE_FPIN parts of ibmvfc_handle_async
> 
> [ ... ]
> 
>> +static void ibmvfc_extended_fpin_test(struct kunit *test)
>> +{
>> +	enum ibmvfc_ae_fpin_status fs;
>> +	struct ibmvfc_async_subq_fpin crq[IBMVFC_AE_FPIN_CONGESTION_CLEARED+1] = {};
> 
> [Severity: Low]
> Does this undefined structure break the build?
> 
> struct ibmvfc_async_subq_fpin is not defined in this commit, causing a
> compilation error.

Sure does. Will refactor into the correct commits for v10

-Tyrel
> 
>> +	struct ibmvfc_async_subq_fpin
>> +		crqcn[IBMVFC_AE_FPIN_PORT_CONGESTED][FPIN_CONGN_DEVICE_SPEC+1] = {};
> 

