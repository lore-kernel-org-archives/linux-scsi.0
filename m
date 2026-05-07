Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92F8340281;
	Thu,  7 May 2026 22:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778193666; cv=none; b=pRt0Ba9D20CwOB7kFWj3ckzveeONBT+XGJEgZBP31YX7rzGfe1HcO6ojSLq62+mdm2GdMW/qJYD7Ap42jfkLXUUJbW4oJg/V0eRN0/5dK59p0uib8k4D0ZHduRSrQDPoz/2x4PxjvxRNfcv1BPfvSbHeLf9C6OeGM3h6Raq6KcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778193666; c=relaxed/simple;
	bh=scLmmUCto7BUzx8Z4chAiva/cQdAznDv7VcB3P2lc3s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Cwq6LELuhZFP5+aEE4jHnyksK9ooyo823r0p2sr5/r3XAoaGTy7ILr1Cn9xkCjYtRnja5yiix00DLbO8SWM+Y9vTj2yHi4Z7Tll2m88wlKbobfuLq9Av261qakrJ7PSdWYpcS/E9841DIQwFOaCRE3vQjNB2eTGiR3Wf2bvyFJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=P43HVx6O; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="P43HVx6O"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 647L6Mmm2725335;
	Thu, 7 May 2026 22:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=L0mr9sofZvcYRPXy5sFIxX0oXJ3Qsd
	B+9ux6RqWW0As=; b=P43HVx6Oink8QPaz+Hjr5yUdK/DVlD/mUJTalE+jlXKJhB
	wB0ofD5BqR1y9qQq35Yo7/I6KOrpxc2vn8VUhvy4G/EAd+z947lD1AuiebCC+06J
	MMO8nvDvKPPq7ynKrMnaQSEC5mFQ57MOC6a7wwr7u5o1qfrN6yA+E26TJlbfEPph
	uimyWO0BJgbJQUh9luIpZMox2vADD/xi0fpKNTVytv6q8YSTM3N2C6XG3TBQcrnN
	otmJrv/YmbC5Nm+64xrevO2Wk1YTILltQNcXaZXOxX+qihH7Dh4vun7JQr/rcHa2
	Qu7pS83GMgLNiGzw+PyPut/UACySXPhb8aXLzhUg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y501e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 22:40:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 647MdW06004822;
	Thu, 7 May 2026 22:40:43 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9ynjx0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 22:40:43 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 647MegXf31130146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 22:40:42 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44D725803F;
	Thu,  7 May 2026 22:40:42 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9BCB5805A;
	Thu,  7 May 2026 22:40:41 +0000 (GMT)
Received: from d (unknown [9.61.133.117])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  7 May 2026 22:40:41 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas
 Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King
 <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch
 <kmahlkuc@linux.ibm.com>
Subject: Re: [PATCH 4/5] ibmvfc: use async sub-queue for FPIN messages
In-Reply-To: <e59242e4-f353-44eb-ad48-b76a9101d4fb@linux.ibm.com> (Tyrel
	Datwyler's message of "Wed, 6 May 2026 22:41:26 -0700")
References: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
	<20260408-ibmvfc-fpin-support-v1-4-52b06c464e03@linux.ibm.com>
	<e59242e4-f353-44eb-ad48-b76a9101d4fb@linux.ibm.com>
Date: Thu, 07 May 2026 17:40:41 -0500
Message-ID: <87ecjmetcm.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDIzMCBTYWx0ZWRfX6XGLpE9CQqdH
 AFz+SZvSO3mQ911ZDSX09uJrO3CFr5XNiGLkwGakIjBrpQz+pgDS61+jOH2pYxjZA15Ymf/MhSG
 ZUZGDnQEspLbNjQ2wWA51E6EwHG5HOz6fnB6aNCV0W8NXJTfA2SkhX+0Gc3BtFv6AdMlKB3/pLd
 LJnBNBBd4LO0T9/VgWn3yhdYTDSwOcLQPuM7YY39g/l4mNeg87todN1jlDFTtqVLpflGCvsj0Ut
 uoiuroIrXsPxOyJaIG/Zy+QGHUV2t0HtqRWj7DQxTtv0RxAZBKfa4r2fJ+qPSyuSk1SJ9/vDOmx
 DYV8U9OdrI9LpMMwPzzgVfgf7+R5RE9KvnTu/yGiKCHD+9l/QYVE0Gu3dWAkmhH+LAayi8/ikvS
 vJJW9lxMldiVI8LkVHQZ7VxZPFColHLyG8K4rN8LV8zl9bPImq2uuAey7Iz0z5Vvn6ni5ZHqnjI
 rbbBE0i9TVHDvTwySEA==
X-Authority-Analysis: v=2.4 cv=J4GaKgnS c=1 sm=1 tr=0 ts=69fd14ec cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=POLsQlOSEy6U3WfIj7EA:9
X-Proofpoint-GUID: dV43-ZDSJ7Av1EtQ41yGi0Aq3JdyXlaB
X-Proofpoint-ORIG-GUID: mwy1_MVVeNI4wL0crNjR-ibEbh7T3qow
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605070230

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> On 4/8/26 10:07 AM, Dave Marquardt via B4 Relay wrote:
>> From: Dave Marquardt <davemarq@linux.ibm.com>
>> 
>> - allocate async sub-queue
>> - allocate interrupt and set up handler
>> - negotiate use of async sub-queue with NPIV (VIOS)
>> - refactor ibmvfc_basic_fpin_to_desc() and ibmvfc_full_fpin_to_desc()
>>   into common routine
>> - add KUnit test to verify async sub-queue is allocated
>
> Again more descriptive commit log message required here. Also, this looks like a
> lot of things being implmented. Can this be broken into multiple patches? It
> sure looks like a bunch of functional changes that build on each other.

Yes, I'll break this up into more patches.

>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c       | 325 ++++++++++++++++++++++++++++++++---
>>  drivers/scsi/ibmvscsi/ibmvfc.h       |  29 +++-
>>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c |  52 +++---
>>  3 files changed, 363 insertions(+), 43 deletions(-)
>> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index 803fc3caa14d..26e39b367022 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -1471,6 +1471,13 @@ static void ibmvfc_gather_partition_info(struct ibmvfc_host *vhost)
>>  	of_node_put(rootdn);
>>  }
>>  
>> +static __be64 ibmvfc_npiv_chan_caps[] = {
>> +	cpu_to_be64(IBMVFC_CAN_USE_CHANNELS | IBMVFC_USE_ASYNC_SUBQ |
>> +		    IBMVFC_YES_SCSI | IBMVFC_CAN_HANDLE_FPIN),
>> +	cpu_to_be64(IBMVFC_CAN_USE_CHANNELS),
>> +};
>> +#define IBMVFC_NPIV_CHAN_CAPS_SIZE (sizeof(ibmvfc_npiv_chan_caps)/sizeof(__be64))
>> +
>
> I really don't understand what you are doing here? You seem to be definig
> various sets of capabilities, but how does the driver decide which set to use?
> As far as I can tell the index is increased and the capabilities decrease each
> time a transport event is received. This looks like maybe its just a testing hack.

My thought was to deal with an older VIOS that doesn't support the async
sub-queue and full FPIN. But I suppose the response should just not set the
appropriate bits. I'll go re-read the NPIV spec and figure out if this
is actually needed.

>>  /**
>>   * ibmvfc_set_login_info - Setup info for NPIV login
>>   * @vhost:	ibmvfc host struct
>> @@ -1486,6 +1493,8 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>>  	const char *location;
>>  	u16 max_cmds;
>>  
>> +	ENTER;
>> +
>>  	max_cmds = scsi_qdepth + IBMVFC_NUM_INTERNAL_REQ;
>>  	if (mq_enabled)
>>  		max_cmds += (scsi_qdepth + IBMVFC_NUM_INTERNAL_SUBQ_REQ) *
>> @@ -1509,8 +1518,12 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>>  		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
>>  			    IBMVFC_CAN_USE_NOOP_CMD);
>>  
>> -	if (vhost->mq_enabled || vhost->using_channels)
>> -		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
>> +	if (vhost->mq_enabled || vhost->using_channels) {
>> +		if (vhost->login_cap_index >= IBMVFC_NPIV_CHAN_CAPS_SIZE)
>> +			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
>> +		else
>> +			login_info->capabilities |= ibmvfc_npiv_chan_caps[vhost->login_cap_index];
>> +	}
>>  
>>  	login_info->async.va = cpu_to_be64(vhost->async_crq.msg_token);
>>  	login_info->async.len = cpu_to_be32(async_crq->size *
>> @@ -1524,6 +1537,8 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>>  	location = of_get_property(of_node, "ibm,loc-code", NULL);
>>  	location = location ? location : dev_name(vhost->dev);
>>  	strscpy(login_info->drc_name, location, sizeof(login_info->drc_name));
>> +
>> +	LEAVE;
>>  }
>>  
>>  /**
>> @@ -3323,7 +3338,7 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>>   * non-NULL - pointer to populated struct fc_els_fpin
>>   */
>>  static struct fc_els_fpin *
>> -/*XXX*/ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq)
>
> I mentioned this /*XXX*/ in an earlier patch. This needs to be fixed in that patch.

Yes.

>> +ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq)
>>  {
>>  	return ibmvfc_common_fpin_to_desc(crq->fpin_status, crq->wwpn,
>>  					  cpu_to_be16(0),
>> @@ -3332,6 +3347,29 @@ static struct fc_els_fpin *
>>  					  cpu_to_be32(1));
>>  }
>>  
>> +/**
>> + * ibmvfc_full_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
>> + * containing a descriptor.
>> + * @ibmvfc_fpin: Pointer to async subq FPIN data
>> + *
>> + * Allocate a struct fc_els_fpin containing a descriptor and populate
>> + * based on data from *ibmvfc_fpin.
>> + *
>> + * Return:
>> + * NULL     - unable to allocate structure
>> + * non-NULL - pointer to populated struct fc_els_fpin
>> + */
>> +static struct fc_els_fpin *
>> +ibmvfc_full_fpin_to_desc(struct ibmvfc_async_subq *ibmvfc_fpin)
>> +{
>> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status,
>> +					  ibmvfc_fpin->wwpn,
>> +					  cpu_to_be16(0),
>> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD),
>> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
>> +					  cpu_to_be32(1));
>> +}
>> +
>>  /**
>>   * ibmvfc_handle_async - Handle an async event from the adapter
>>   * @crq:	crq to process
>> @@ -3449,6 +3487,120 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>>  }
>>  EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_async);
>>  
>> +VISIBLE_IF_KUNIT void ibmvfc_handle_asyncq(struct ibmvfc_crq *crq_instance,
>> +					   struct ibmvfc_host *vhost,
>> +					   struct list_head *evt_doneq)
>> +{
>> +	struct ibmvfc_async_subq *crq = (struct ibmvfc_async_subq *)crq_instance;
>> +	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be16_to_cpu(crq->event));
>> +	struct ibmvfc_target *tgt;
>> +	struct fc_els_fpin *fpin;
>> +
>> +	ibmvfc_log(vhost, desc->log_level,
>> +		   "%s event received. wwpn: %llx, node_name: %llx%s event 0x%x\n",
>> +		   desc->desc, be64_to_cpu(crq->wwpn), be64_to_cpu(crq->id.node_name),
>> +		   ibmvfc_get_link_state(crq->link_state), be16_to_cpu(crq->event));
>
> Was there no way to not copy/paste what looks like basically ibmvfc_handle_async
> into ibmvfc_handle_asyncq? This is a bunch of unnecessary code bloat. The major
> difference seems that crq->event is be64 on the standard CRQ and be16 on a
> sub-crq and accessing certain fields differently.

That's a good idea. I'll see what I can do. Seems like a little
refactoring should make it work.

> Again I think maybe we need to consider moving all the async work into a workqueue.

My initial thought was to just queue the FPIN processing of
ibmvfc_handle_asyncq to a work queue to resolve the problem of calling
fc_host_fpin_rcv from interrupt context, but putting all of this
processing into a work queue would work too. I'll look into it.

-Dave
