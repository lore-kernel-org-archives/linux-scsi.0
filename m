Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560721EB5E3;
	Fri, 21 Aug 2026 15:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787327088; cv=none; b=EVO8EBmjPT+nZaSuhdNU++1Bb3D5hN3WuIrE2s0TNwhWiDYJZY2T+fCDaTk1btbVppmhK/kXPXkp/meleRpIHE1tzo6F5B+0S4KA0BGRpCVJC2v3k8FJ/1opBnDteq3TFQRcQV5gupwNOqPA69Vry5xzIypSSQ+roQWiIhAUupQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787327088; c=relaxed/simple;
	bh=HZ5mLgw2emKZWU4zuIzDGFXNADwbys6IMOEBAKNa5jU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FM3K80p3SX+rtAjHFqbr3uSRRATxMMrbuC9kwjptth2M6zcsyKaUdzHQfmANxwCA/106v+LaMtwewALlFwqsSVw3LVEANad7P/f2LoVCyGPuCUd4/OR1Q3WNhUVejcy68QYyRLcThBg2py/Feb/fyyul+pIU5FaKJr45BSODGTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hI98dzpF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hI98dzpF"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LD1hQV455148;
	Fri, 21 Aug 2026 15:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=rlKGNjJsWlnkl3U2rEpYzyLq4X7/D0
	b2xDJRJF/MHc4=; b=hI98dzpFYo5Zeselis62RJQ/gxDr3LgNY3gLFR9CNfJAed
	zpVBil0ghWudddJRQAjsuGYCDXEU1JyPjf7iCWMW3Qp6EdTxbHFIuFrpJXljtKXO
	nnNyA+8dJVYnNOYEE4K5ejI+FIge9GMeybNCGHqPHIzg4f9TClnlgB844Klpf3RH
	XTT/A4aDD89gajN794VJQaVL/GJx6RZXyetW3bq8KaG8dHBX84Gx7YkQcqP/hFzf
	VUEiIQQ5f8lADxUZNQu/h3yQ5e46Qfuosnfx1sLwTqbHv7U1uig0bsAgiz9DIPtB
	o2Dv2DKnj4RLeECV9y8vmsVJIstB9HB6js+52qhw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu2jaqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:44:45 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67LFfNHK024713;
	Fri, 21 Aug 2026 15:44:45 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g32eqnmjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:44:45 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67LFiiKD20054588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Aug 2026 15:44:44 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 912355805A;
	Fri, 21 Aug 2026 15:44:44 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78DAC58062;
	Fri, 21 Aug 2026 15:44:44 +0000 (GMT)
Received: from d (unknown [9.61.29.95])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 21 Aug 2026 15:44:44 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 7/8] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
In-Reply-To: <20260817204231.3364C1F000E9@smtp.kernel.org>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
	<20260817-ibmvfc-fpin-support-v6-7-62a2d525e70d@linux.ibm.com>
	<20260817204231.3364C1F000E9@smtp.kernel.org>
Date: Fri, 21 Aug 2026 10:44:44 -0500
Message-ID: <87jypjwk9f.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AdqB2XXG c=1 sm=1 tr=0 ts=6a88726d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=eF7jxB_lQuaIYKCTfKIA:9
X-Proofpoint-GUID: btle4ZYQ3AwTZOCpHiWqVuKjNWafMNh5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDEyMSBTYWx0ZWRfX9vNtqahM22xw
 58h8Ho47Jh6O637HNF96giwieHMJQRMLX4AjIg/ECVMaiMazC1ZbNmJQ6/0wm60DbfZA3eocgcO
 2WGluo0TEiVyYUkTtUPUao4NWsamizqmVk7O3W9DPfaY/BnOkJpfsJjhPMSpxWRJR6iYGvDuQOx
 QBCTGfbvALBMrQupKYoJP1W43maG+ZEJshZp18k7yVPZayG4ITB27g2/1HAZKc+jnGVAzFghsOF
 Q4YTlBiogmG1xL9CUSRVEER1HTo70Qrm4ywWEFaqTsjFNS0DkAOjxMd6szuOJsRgbM6srvnFI5m
 p7MXODDrcbGoQh6S5w3Ev22/OZaXJhbxysJDPR/YwKPt5zZ3qnfobznQkXDpn/BdeB2qUqfvuQl
 yGpymBKBmtoWCN8x5JaLyi2p0jltNOO7ouul3VpglD/UadNvf8o9CY3TOa2qMQ730ZsWe2zCuxI
 x2fusOh9b2A/Yjfs4lg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDEyMSBTYWx0ZWRfX20qFXGgYKrnr
 Wp/rQcvt0Od8JlLgPlOpuq3LylgmPjYaqArK270nOB+GFjHWEMGly2C519+gHF9bCFpNN1+lAeV
 wVr49dxLB848/vzshjE8CX1E+LcsUbI=
X-Proofpoint-ORIG-GUID: btle4ZYQ3AwTZOCpHiWqVuKjNWafMNh5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_04,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608210121

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
>
> New issues:
> - [High] The newly added async_sub_crq is leaked and leaves its IRQ registered if ibmvfc_alloc_channels() fails during SCSI channel initialization.
> - [High] The async_sub_crq is completely omitted from the CRQ reset and re-enable sequences, breaking its lifecycle.
>
> Pre-existing issues:
> - [Critical] NULL pointer dereference in ibmvfc_channel_setup() when mq_enabled == 0.
> - [High] Missing bounds checks on hypervisor-provided queue counts can lead to out-of-bounds array accesses.
> - [High] Error codes from request_irq() are unconditionally clobbered, silently masking critical failures.
> --
>
> --- Patch [7]: [PATCH v6 7/8] scsi: ibmvfc: register and use asynchronous sub CRQ for events ---
> commit 10af0529db6ade6b831181ddc695f2e8713b38ee
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: register and use asynchronous sub CRQ for events
>     
> Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
> registered, and freed alongside the SCSI channel queues.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -5792,6 +5794,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>>  		for (i = 0; i < nvme->active_queues; i++)
>>  			nvme->scrqs[i].vios_cookie =
>>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
>
> [Severity: High]
> This is a pre-existing issue, but is it possible for an unexpectedly large
> response from the hypervisor to cause out-of-bounds array accesses here?

Up to this point in the driver history, we have trusted the answeres
from PHYP, the IBM PowerVM hypervisor.

> Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_channel_setup_done(),
> the unvalidated active_queues count returned by the VIOS is used directly
> as a loop limit to write into the driver's nvme->scrqs and scsi->scrqs
> arrays.
>
> Could a malformed or compromised response corrupt adjacent memory?
>
>> +		vhost->async_sub_crq.vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
>>  
>>  		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
>>  			   scsi->active_queues);
> [ ... ]
>> @@ -5851,6 +5854,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
>>  		for (i = 0; i < nvme_channels; i++)
>>  			setup_buf->channel_handles[scsi_channels + i] =
>>  				cpu_to_be64(nvme->scrqs[i].cookie);
>
> [Severity: Critical]
> This is a pre-existing issue, but does this loop risk a NULL pointer
> dereference when mq_enabled is 0?
>
> Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_channel_setup(),
> if the driver is loaded with mq_enabled=0, ibmvfc_init_sub_crqs() returns
> early without allocating scsi_scrqs.scrqs. 
>
> However, if a modern VIOS supports channels, the enquiry succeeds and sets
> max_vios_scsi_channels > 0.
>
> This would cause ibmvfc_channel_setup() to compute scsi_channels > 0 and
> unconditionally execute this loop, accessing the unallocated
> scsi->scrqs[i].cookie array.

I will study this more, but it will not be fixed in the v7 patch series.

>> +		setup_buf->async_sub_crq_handle = cpu_to_be64(vhost->async_sub_crq.cookie);
>>  	}
>>  
>>  	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
> [ ... ]
>> @@ -6949,7 +6953,9 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
>>  	for (i = 0; i < channels->max_queues; i++) {
>>  		if (ibmvfc_register_channel(vhost, channels, i)) {
>
> [Severity: High]
> This is a pre-existing issue, but does ibmvfc_register_channel() silently
> mask critical failures?
>
> Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_register_channel(),
> if request_irq() fails, the code jumps to the irq_failed label where it
> executes:
>
> rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
>
> If the hypervisor successfully frees the sub-CRQ, rc is overwritten with 0
> (H_SUCCESS). 
>
> The function then returns 0, falsely indicating success to the caller,
> which leaves the channel marked active but without an interrupt handler.

Good catch. In v7 I've changed the call to record the returned value in
a different variable, hcall_rc, so the original rc can be returned to
the caller of ibmvfc_register_channel().

>>  			for (j = i; j > 0; j--)
>> -				ibmvfc_deregister_channel(vhost, channels, j - 1);
>> +				ibmvfc_deregister_channel(
>> +					vhost, channels, j - 1);
>> +
>>  			vhost->do_enquiry = 0;
>>  			return;
>>  		}
> [ ... ]
>> @@ -7004,10 +7010,27 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
>>  
>>  static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
>>  {
> [ ... ]
>> +	/* register async_sub_crq channel */
>> +	if (ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1)) {
>> +		ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
>> +		vhost->do_enquiry = 0;
>> +		vhost->mq_enabled = 0;
>> +		return;
>> +	}
>> +
>>  	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs)) {
>>  		vhost->do_enquiry = 0;
>>  		vhost->mq_enabled = 0;
>>  		return;
>>  	}
>
> [Severity: High]
> Does this error path leak the newly added async_sub_crq?

Yes. In v7 I've restructured ibmvfc_init_sub_crqs() to handle errors
correctly and not leak async_sub_crq.

> Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_init_sub_crqs(),
> if ibmvfc_alloc_channels() fails during SCSI channel initialization, the
> function returns early.
>
> This skips deregistering or freeing the successfully allocated
> async_sub_crq.
>
>> @@ -7050,6 +7073,9 @@ static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
>>  	if (!vhost->scsi_scrqs.scrqs)
>>  		return;
>
> [Severity: High]
> Could this early return bypass async_sub_crq cleanup entirely?
>
> Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_sub_crqs(),
> if scsi_scrqs allocation failed earlier, !vhost->scsi_scrqs.scrqs evaluates
> to true, causing an immediate return. 
>
> When the module unloads, the memory for async_sub_crq is freed but its
> IRQ remains registered, potentially causing a use-after-free panic if the
> hardware triggers an interrupt.

v7 of this patch fixes this problem.

>> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
>> +	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
>> +
>>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
>
> [Severity: High]
> Are there lifecycle regressions during host adapter resets for async_sub_crq?
>
> Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_reset_crq(),
> when the host adapter undergoes a reset, ibmvfc_reset_crq() and
> ibmvfc_reenable_crq_queue() explicitly deregister and re-register the SCSI
> and NVMe sub-CRQs. 
>
> However, async_sub_crq appears to be omitted from these sequences.
>
> Across a reset, the async_sub_crq registration with the hypervisor becomes
> stale, which would permanently break the receipt of asynchronous events
> until the driver is reloaded. 
>
> Should async_sub_crq be included in the reset path?

Yes. v7 adds code to ibmvfc_reset_crq() and ibmvfc_reenable_crq_queue()
to deregister and reregister the async sub CRQ.

-Dave
