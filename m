Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C03548562;
	Tue, 22 Sep 2026 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790094481; cv=none; b=dwV2LoSc4mrY/eguV3RBc/w3CIMuwBizWnGpGCJg6+oGIltsocsFVvkXowN7LdQfkvbszER+iIzZH31KcrxWQblinIH5Q0qUAoNBhyjlHJTj8N2n2sWhAjTTOkPUYkaZJf383fyFmGTQe3za6NkKZHqNTvNN9djk1JfXefxFZpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790094481; c=relaxed/simple;
	bh=3r6iyEz6pbl5FVpyIgXnFRukS+LrtFJ0V6izVERaRno=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kS6GR54nhfTVRiY/X7Yt+R8W+A2I3PqN7pv98ko2q4k4UoaG4OtDLCH0tzt2kS7OcGE7NOoLulqB1ZkQAR0yKmUZOuk7c9iEJAxWlaFQeeHasfvQcqIs8oMuqEcJN5KPbK/Tgyg/3b5mRHqtEO2w4hq9KFN3wbsjPYjhx3oVhBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ImbB//S5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ImbB//S5"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MF5PCH752347;
	Tue, 22 Sep 2026 16:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=DHFYMJEW6ccj4GaEFRCOBqqtuwDJVJ
	0Kb0PdNxmhw/w=; b=ImbB//S5GzstI/GyMDDRB0Wo+ZQLCrt+seWsU+espPazIm
	eREH5Mlvh/AateRChqarMQTFN3kZNT6fLK6z6fzM507vkKVYCD2z+a6xb2TYZREW
	BpI71Vw1VXxFbqao+i27RkXNiVdljw8D1t9JvOgpGP0Xju1edwxc9e2UG0YLwUZ4
	iO/ClP/x2xEyanGLivqv40xaE/8QY1OFYiocteolrkmcLyNDFOSfGfOdiihJciDe
	z4KsunIdR6MWW1zjJBdisGm+u5tH2b4t6J1QQOSeAwryBvYwb13le1jUCxBnsRsD
	NjSCvQJ/yDMP9TBJlIP4ZWzxudy9l5eGhbJlGupw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskgs6vgm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 16:27:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68MElVeS3046781;
	Tue, 22 Sep 2026 16:27:58 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt4qqaqt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 16:27:58 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68MGRvYn29819474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Sep 2026 16:27:57 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE03B58056;
	Tue, 22 Sep 2026 16:27:57 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9399A58052;
	Tue, 22 Sep 2026 16:27:57 +0000 (GMT)
Received: from d (unknown [9.61.84.130])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 22 Sep 2026 16:27:57 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v10 1/9] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <c53d3fa9-3e66-4010-87a4-e9cd61789381@linux.ibm.com>
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
	<20260911054832.1311668-2-tyreld@linux.ibm.com>
	<20260911060658.68FDC1F000FF@smtp.kernel.org>
	<c53d3fa9-3e66-4010-87a4-e9cd61789381@linux.ibm.com>
Date: Tue, 22 Sep 2026 11:27:57 -0500
Message-ID: <878q4tz1wy.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=V/XoQuni c=1 sm=1 tr=0 ts=6ab2ac8f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=BuaCO-MwPhrfmhY2Sl0A:9
X-Proofpoint-ORIG-GUID: FHJbkOAaBLZX4Z6GtCadWqBd_B1gkVVP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDIzNSBTYWx0ZWRfX9VR32s1cn1QJ
 kCAUyfNabCrAbQsR91mNKdB5rzMNHV8jy9qH+R6G2tGbTf/W5s8klxv3hpQ7ULlxVgJGUZo8DeJ
 U+Gjc7bcBQVulia2SEGo1uI/b18N2VNkwUEHfoysw/SStYvSs3JKisJQg4DtXWBsGCFtJDRcXd+
 Spp2IcGMzIN9fc/+KvBUUNdHEloIG0ZJF4cIgsEjz0uxVeYnYO7o4J4X6lRJ1ai3r1d+JFbJ9HM
 P2mDw95oV7bgaefFqTWIEVHlzJkvPl9yoR2ks+WMNBHj3HN+nBg42jWnBgxi+TLpzHzjG7+ia8b
 /DZin4ZeWpesp5eGXtD1ivwooMdJxnb8O4QUJ/jdzZZcFVfmUDCFjZiiTJYmVgptgXehndvQedr
 R+sZoLqcSNmzOAwHlDCQQhs9lEqVeZPGAjxWy4oLsoklCgqFidqVxCtPnCQOUWMs7NsOl0FDatK
 5s7mfKuh0H5sRsbCJjQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDIzNSBTYWx0ZWRfX4nUHc2ugVmUp
 WBI2QF7U6P2Y6Oqg4DW2MhoVcK0C0j8xredTkfkgFBCRIshhQoW+wg/N0OJcLyWPDRYFEWyjfDc
 qz+hws+m5PStXLeY7c4zXZicFW2VdvM=
X-Proofpoint-GUID: FHJbkOAaBLZX4Z6GtCadWqBd_B1gkVVP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220235

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> On 9/10/26 11:06 PM, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>> - [Medium] The KUnit test `ibmvfc_async_fpin_test` leaks references to the `Scsi_Host` and the `fc_rport` device on its successful completion path.
>> - [Medium] Unordered workqueue allows FPIN events to be processed concurrently, causing data races in FC transport statistics and FPIN event reordering.
>> --
>> 
>> commit 79377784bc96c798354f5b0f5ce5007a8d857d16
>> Author: Dave Marquardt <davemarq@linux.ibm.com>
>>     
>> scsi: ibmvfc: add basic FPIN support
>>     
>> This commit implements support for a basic level of Fabric Performance Impact
>> Notifications (FPIN) in the ibmvfc driver. It adds an async event handler that
>> offloads FPIN processing to a dedicated workqueue and passes the converted
>> messages to the FC transport layer. A KUnit test module is also introduced to
>> validate the FPIN event handling and statistics updates.
>> 
>>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>>> @@ -3547,6 +3547,56 @@ static void ibmvfc_process_async_work(struct work_struct *work)
>> [ ... ]
>>> +	if (fpin) {
>>> +		fc_host_fpin_rcv(tgt->vhost->host,
>>> +				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
>>> +				 (char *)fpin, 0);
>>> +		kfree(fpin);
>>> +	} else
>>     
>> [Severity: Medium]
>> Can the lockless modifications to fpin_stats in the FC transport layer here
>> cause data races and lost statistic counts?
>>     
>> Multiple FPIN events arriving rapidly from the adapter are queued to the
>> fpin_workq. Because the workqueue is created below as WQ_UNBOUND with
>> max_active=0, these events can be processed concurrently.
>
> Makes sense. See response below.
>>     
>> Furthermore, since FPIN events are stateful (e.g., congestion detected vs
>> cleared), could concurrent processing deliver events out of order to the
>> midlayer and userspace, leaving the system reflecting an incorrect state?
>> 
>> [ ... ]
>>> @@ -7135,6 +7135,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>> [ ... ]
>>> +	vhost->fpin_workq = alloc_workqueue("%s-fpin-workq-%u", WQ_UNBOUND, 0,
>>> +						 IBMVFC_NAME, shost->host_no);
>>     
>> [Severity: Medium]
>> By setting the max_active parameter to 0, which defaults to 256 concurrent
>> execution threads, does this allow the unordered processing that triggers
>> the data races mentioned above?
>
> I think max_active should be set to 1 here to enforce ordered processing.

Or use alloc_ordered_workqueue() here instead.

-Dave
