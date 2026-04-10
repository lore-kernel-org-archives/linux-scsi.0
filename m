Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522D23B6BEC;
	Fri, 10 Apr 2026 09:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775812212; cv=none; b=oq52fQbsm1z9mjm+oGhxmLyteKPoDHKHJV7spsmP4biGQLM/4GBOybraC8B0k40e49Yvo4rQo2o0n08qN7RdzYC/nU4KT3fzAPImTkOobVJ+N1+sJhT5IXUs0tz+ZiwdoVX4QoM9uyez0OqSUFuHBA14667fE/RetOJhKd9lobc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775812212; c=relaxed/simple;
	bh=y1y3tAC4dakqrUiW5N1bXwxs8afU4+dkOGTqJBlNCLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FTLfMaZmEI89rxmKU9Hz9yUwp3U3JTpJNpQ6U/wCA9T6C+AUFS41GaKQyE8YxTzypveJnVpphGj9zLkLD42MmoftRg797DTLd56IjeeNACryARPGwyjGaMLeht571K1g4UTeJh8ZaQ7z/kfZKgSkLrAx/UabDv7c82/e1diLgBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fdh6Qwbl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fdh6Qwbl"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A2UVXK2211971;
	Fri, 10 Apr 2026 09:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YFFT2U
	XaFgMw5FshuKYA6/yiU6lAss1w/aYLuf3p20s=; b=fdh6QwbljZCv0tRwUUv4DI
	jbO8GjTXlBubNdLmwPTw7Bl2QfNx46m1DzbQw498G2Gb7NIrai2pYxjm7QdJGrez
	Ms2q65MhZ8EkjzIqoS4jIFtFlQsDVqGdUZG8oTzV45ydW0qCyyIEG2gFUPjSREWh
	T8UnLG+P1vDGQZyBsE0z7K3OWSpdJvr7anhmCBGXzD1TMCk8jgm5yGayZPARYbwa
	MWdrX5G5RPa3kAIR6xQPV7eTOjhrxdAqbu0HlUG1xdNgkeqfd4xUFkh80dpuMkHS
	1P/OwtSAKwmZJwcvrDXNRv2XqYhcfONugJ0KbZgv06+3MOTSYFoHx0Cddb8gBwLg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2hr27f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 09:09:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63A7XSXB018952;
	Fri, 10 Apr 2026 09:09:47 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9qad0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 09:09:47 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63A99kdr64028962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 09:09:47 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E671A58045;
	Fri, 10 Apr 2026 09:09:46 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A2DF58064;
	Fri, 10 Apr 2026 09:09:40 +0000 (GMT)
Received: from [9.39.26.31] (unknown [9.39.26.31])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Apr 2026 09:09:39 +0000 (GMT)
Message-ID: <a1d72045-7b0e-4354-8365-f21f03765659@linux.ibm.com>
Date: Fri, 10 Apr 2026 14:39:38 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
        hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-8-john.g.garry@oracle.com>
 <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
 <74eb1f9b-265e-4264-9575-177de6c924a0@oracle.com>
 <6d7a4076-a4ad-4185-8e82-8e27d704d20e@suse.de>
 <c5334a6b-8089-4ee5-abd3-8340133db29a@oracle.com>
 <79725a83-3dc1-4398-ac86-c3e317e0e107@linux.ibm.com>
 <ccfc867c-e744-42a2-9b22-47245a6c06d7@oracle.com>
 <da2bfbb0-70ef-4c3a-a235-1343b4a02489@linux.ibm.com>
 <b77d5eab-d50f-4102-8bfb-f907cf39ca56@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <b77d5eab-d50f-4102-8bfb-f907cf39ca56@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDA4MSBTYWx0ZWRfXx+t7hVWGdfGP
 +K0ScVE9BekhEXANsgffA8AOLnDCwCJGsEw4WS+JlpKm85TFcbW0IM/aOpC2rDE53wmCld5FdIC
 OQDHHwNdYuezgFyAKscyyzttHfEsvLTUJDRTKDtDx39D4HGbm5HHadTGvKJnBUOz9iOt+0YeMvP
 mR6s7FQif3amgXeJvdzXPGSZZD5fyjnw944HW9C7P6IBOxM97xd8m815uZ1q31gE07UZ5R2s98v
 ho6bdTYrZMabK4TFZ1QLHyjqmbv4U1YQTViTEiMorbkH4Jcb+b+n+0vZKkGC/OyWCH0T2bE8UtC
 8ks2avhp1Q+dd6Vr1zxtmtjgsLV6YJUYjWp5+bjOxevMR4LN4n3MZnw04x5h8rUHg5SjQ4lGy+e
 ACE0dqML36iGoOJO2BjqqrFQDHLnAM5TgWqoFVl9lzImZX0IxquUgI5T93xI2g20bJRFb4cqP/y
 GDeuidbYbH2HxD/tGNQ==
X-Proofpoint-GUID: II3nVUc8c1JZMH9EfJ6wZTxQWHHQ9qoF
X-Authority-Analysis: v=2.4 cv=a/wAM0SF c=1 sm=1 tr=0 ts=69d8be5c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Toid4UBcJoDm1BhsOxsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: II3nVUc8c1JZMH9EfJ6wZTxQWHHQ9qoF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_02,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100081

On 4/10/26 2:25 PM, John Garry wrote:
> On 10/04/2026 08:06, Nilay Shroff wrote:
>>>    # Part b: Ensure writes work for intermittent disconnect
>>>      _nvme_connect_subsys
>>>
>>>      nvmedev=$(_find_nvme_dev "${def_subsysnqn}")
>>>      ns=$(_find_nvme_ns "${def_subsys_uuid}")
>>>      echo 10 > "/sys/block/"$ns"/delayed_removal_secs"
>>>      bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
>>>      if [ "$bytes_written" != 4096 ]; then
>>>          echo "could not write successfully initially"
>>>      fi
>>>      sleep 1
>>>      _nvme_disconnect_ctrl "${nvmedev}"
>>>      sleep 1
>>>      ns=$(_find_nvme_ns "${def_subsys_uuid}")
>>>      if [[ "${ns}" = "" ]]; then
>>>          echo "could not find ns after disconnect"
>>>      fi
>>>      _delayed_nvme_reconnect_ctrl &
>>>      sleep 1
>>>      bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
>>>      if [ "$bytes_written" != 4096 ]; then
>>>          echo "could not write successfully with reconnect"
>>>      fi
>>
>> It seems there may be a race here if we attempt to write to $ns before
>> the reconnect has completed in _delayed_nvme_reconnect_ctrl.
>>
>> If the intention is simply to verify that the controller reconnect occurs
>> within the delayed removal window and test pwrite,
> 
> Not exactly. I want to verify that if I write between the disconnect and the reconnect, then we write succeeds.

Okay, got it — I think I misunderstood the intention earlier.

So the goal here is to verify that if a write is issued during the
delayed removal window is in progress (i.e., when there is temporarily
no active path), the write should be queued. Once the reconnect succeeds,
the queued write should then be unblocked and sent to the target.

If this understanding is correct, then this looks like a good test
to me.

Thanks,
--Nilay
