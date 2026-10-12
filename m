Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FDD42586B;
	Mon, 12 Oct 2026 19:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791833071; cv=none; b=FYvc64QSTwQteDhxdVE9JJ3ZnriD9j9TWUkqz8umwzbX48VTdChyVlPbsQQZy4Hs/ZtRIYDTnmKeIErtxXZJmaUsN9dN+0ajydloRSk5FOF19GVhV4DjQt9sQlHTCnomWrAjuVlx4cXJaSdwrCcR4dpSVZtdBMFckF3zoLB2mF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791833071; c=relaxed/simple;
	bh=ynW/ZPRNAQHZw8d3BWPO4gqbzsy3woPT8XNzSC/UZ7U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Aho8evjWgJPRU+lC5b5L7KeZ0vpY/vxBVoqC5aFFDL8CBCsQed2hn6c9GbfHEpowEHkTYi+q9OzvshGJNkB9yTu5Z7PBm/AEs+Bm6OWARQwuNXdfWxDEJWPJNhOjF7ANFqXghCkubH5hbFhO/61ViA6dypmiNg/LPYb+vIKJtYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jrlzppV3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jrlzppV3"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CFic6G508599;
	Mon, 12 Oct 2026 19:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=suFbHXyrCeLqmqNFvZRn5V9qs5YaAd
	ubENHg4XGX7YA=; b=jrlzppV3dUVSkygj42q2gStc2nx7Ft8qA7pXkJ5mfdJD1y
	QFT5a4zVlN4Z8PDjj8XWnWh2VYC+Zph4168LenlyjpLMXqckgdnqfIQ4saa+z4IN
	qLQczqzghRsngdUtMvQrvkWy/CjI+WpoTCV7/LSU4Y6lhLoUBgDHz2C1MaKVj8cd
	nvFCVY2X/gaC0r1TBlV4hQM7pbCAbwJhqUbGeN+bgW0s2d8dQiD3Vqkd9KVRkxyz
	xu68Potn67qUDm4uP1/YQBGDDLXRil46XYSZyx9hHsQ8rullZ/ioX+Dzm+M56Heo
	Tcp7OC14yxHseZPjVF0wEyWrFHujGD6b8pyNKKmw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dwht81x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 19:24:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69CFo0o41594695;
	Mon, 12 Oct 2026 19:24:21 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h816gxhn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 19:24:21 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69CJOKeC33554958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Oct 2026 19:24:20 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 829D558063;
	Mon, 12 Oct 2026 19:24:20 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 418495804B;
	Mon, 12 Oct 2026 19:24:20 +0000 (GMT)
Received: from d (unknown [9.61.18.84])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 12 Oct 2026 19:24:20 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v13 05/11] scsi: ibmvfc: add NOOP command support
In-Reply-To: <sashiko-outbox-163312@kernel.org> (sashiko-bot@kernel.org's
	message of "Wed, 07 Oct 2026 19:36:26 +0000")
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
	<20261007-ibmvfc-fpin-support-v13-5-b816abfa4fcc@linux.ibm.com>
	<sashiko-outbox-163312@kernel.org>
Date: Mon, 12 Oct 2026 14:24:19 -0500
Message-ID: <87qzhuvi1o.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA3NiBTYWx0ZWRfXxzg++utp/YUf
 VL+AoCML+OH1eenpRn5YEpBK455kGEPpZWnYmycNRTHGsS/wzfXyi9jCWd8GjMcfY0TqT3MOK9P
 rWslHV1IDVXyPNVr+oBQHRmhfRpAOgmljHNqHFseDe5Xi+FiP7gLAh3CsjbBlI6B4q4J46LyYtF
 wYhBw5NaWsuCOaYLZv41qIrtIIx3tQynZ4uSIpPoMlX7XweeVqu7v75nVzTseBhUnyxanFSstsI
 ujyBVzkh88SboPLE6BsbJC6YUjhEYKUsJPX/1aQuXFCjY9xAjBlsFv+CdAVCGUxFjrcyRrSn+oJ
 xh6OUwv3Ic/40hlGtA/em95f4l88OAYcyT04qF85cRxj5eegyz2FixWWIMzC2k54qnerhP+Mz0k
 e+u+XIYCoHZtFpHQNNMPdUjKgrhG3u2PyVCdqTOowXGYjQEa/+chuRjHOZOcP+6MZSgwc4eG+Qp
 2XMHtjCKk9fZTB7I2MQ==
X-Proofpoint-GUID: HAyC78vHVNO_UY4yAmOJlG8eQWHPI6LG
X-Proofpoint-ORIG-GUID: HAyC78vHVNO_UY4yAmOJlG8eQWHPI6LG
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA3NiBTYWx0ZWRfX3cVajVoMGXML
 nalEkFmFPpTULx70PTvNMb0dff7mwiIPaAogr/2zTD6Vy44Mxt3GJeU7pfupg/B7BzfHCqMv7KA
 mwT/viul0U985iznpCNhZDl+OeCdfsA=
X-Authority-Analysis: v=2.4 cv=btHZl0ai c=1 sm=1 tr=0 ts=6acd33e6 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=uN6AuqMkTzWAaZc8BfUA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_05,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120076

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: ibmvfc: wild pointer dereference in ibmvfc_handle_scrq() during evt validation
> --
>
> commit 3a880d56c6f97510d8dc3b25b1c3b9b6711c3a6d
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add NOOP command support
>
> Add support for handling IBMVFC_NOOP format CRQ messages from the
> VIOS partner. Advertise the client's ability to handle NOOP commands
> by setting the IBMVFC_CAN_USE_NOOP_CMD capability in ibmvfc_set_login_info().
> Handle and ignore IBMVFC_NOOP format messages in both ibmvfc_handle_crq()
> and ibmvfc_handle_scrq().
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index ac2571e9e1eb9..161d4679d7026 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -4225,7 +4235,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
>>  	case IBMVFC_CRQ_XPORT_EVENT:
>>  		return;
>>  	default:
>> -		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
>> +		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid);
>> +		return;
>> +	}
>> +
>> +	if (crq->format == IBMVFC_NOOP) {
>> +		if (vhost->state == IBMVFC_ACTIVE &&
>> +		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
>> +			dev_err_ratelimited(vhost->dev,
>> +					    "Received unexpected NOOP command from partner\n");
>> +		return;
>> +	}
>> +
>> +	if (unlikely(!evt)) {
>> +		dev_err(vhost->dev, "Received null event\n");
>>  		return;
>>  	}
>>  
>>  	/* The only kind of payload CRQs we should get are responses to
>>  	 * things we send. Make sure this response is to something we
>>  	 * actually sent
>>  	 */
>>  	if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {
>
> [Severity: High]
> Can this code dereference a wild pointer if the VIOS partner or hypervisor 
> sends an arbitrary, non-zero garbage token in crq->ioba?
>
> At the top of ibmvfc_handle_scrq(), crq->ioba is cast to the evt pointer.
> While this patch adds a check to prevent a NULL pointer dereference, if
> crq->ioba is non-zero garbage, wouldn't evaluating evt->queue dereference
> that untrusted pointer before ibmvfc_valid_event() has a chance to safely 
> validate it?
>
> Looking at ibmvfc_handle_crq(), it avoids dereferencing the event entirely 
> during validation by checking against the host pool:
>
> 	if (unlikely(!ibmvfc_valid_event(&vhost->crq.evt_pool, evt))) {
>
> Could we do something similar here by passing the valid scrq directly into 
> ibmvfc_handle_scrq() so it can safely use &scrq->evt_pool?

Okay, good idea. I'm removing the vhost parameter of
ibmvfc_handle_scrq() and adding a struct ibmvfc_queue *scrq
parameter, and updating the ibmvfc_valid_event call as suggested.

-Dave
