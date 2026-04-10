Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28328278161;
	Fri, 10 Apr 2026 07:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775804827; cv=none; b=jeyK8ATCEiqLpbtX6R4cVObUzW6ajhdINT1JUMUiw8gigddCyQqrE40ut9D4Q9TK+O+g3zucD0nyyJ81lNR9nsEMqgfyLBfip0zyjPhhzZkI4bMOJbkxCasox6UKPmvltVRBk37yqTS4vxVojPTa/vnW8yNK7Z+e9P5VXvjHFIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775804827; c=relaxed/simple;
	bh=7924LyPz+7XslcATVmHCF21cqIc92A+jvphY+OSRdjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=okuzFOPN5MQPWInMdlV6S9TRnPlFNl1d/6Hl+PNNHw0BNcHj4buwFBrODkop1Ca8BMDKYxMoeNZnyI+hRVtLqY+twlHFH/XMd6YuW2zWKe6tEIOoaKxO1Sq6NXa0l1nQ36pejGaq16c7gg9PVOGt5KhPqNj3BtYgcXpypdUpK4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IY3mkX2W; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IY3mkX2W"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639Gd0Fv773967;
	Fri, 10 Apr 2026 07:06:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jjdWvt
	z81DpzP/9ibBKHCS6i67LOXAZzB1JC038nklg=; b=IY3mkX2WeyMQTbT8hnVZaJ
	rN0zYlL6adx4Jb2VYc69NL1EpGgbHt42QIRbp+M6O1KY/Xw17Y9fJFBXZcwLcZRF
	YN791fdNvGK5vzTf9aYuNQEEeCtIMyn2ZrjfnHfGjGWRodbBuN+ePco25bfl4OEo
	/hS8G//fXCMsmTVa45AjhIi2PZi9JIMMk7x1iQMwigCc8mHF4idgg9rUM4MtFGbX
	yk0bWsQSBkXsvjR1RXaUsgsnRVS7q4C4ZLT0KXuHaA/LYm92rFViMeff5khQJJTk
	+9Q8A8fYudYZU3mHCnU0D3XZFx3m2PFgYHKTfX1NYcycNvFO0+rIzIKpb1Ii50DA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2hqpaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 07:06:41 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63A2ejTN013844;
	Fri, 10 Apr 2026 07:06:41 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmf4eypm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 07:06:41 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63A76e1t31261422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 07:06:40 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9363658052;
	Fri, 10 Apr 2026 07:06:40 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B83B65805E;
	Fri, 10 Apr 2026 07:06:33 +0000 (GMT)
Received: from [9.39.26.31] (unknown [9.39.26.31])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Apr 2026 07:06:33 +0000 (GMT)
Message-ID: <da2bfbb0-70ef-4c3a-a235-1343b4a02489@linux.ibm.com>
Date: Fri, 10 Apr 2026 12:36:31 +0530
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
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <ccfc867c-e744-42a2-9b22-47245a6c06d7@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDA2MSBTYWx0ZWRfX3atOYmuSqHgA
 83ISnRFcZNQmY4UX6drZl8sj9IRocDy/eLf2LMo/pdmrYODFzDVlBNwjCEuNzwTKblBhdFha22I
 zOz74ImcGcc8CyAY4tk19mFAxQFWZXtYrrlp0z8LijDUhh0FyCG7p2nAUOIxp+Eyb25ldQEi7nV
 S+m2xqT8kJ2PkLW6FnVPKW5fI8KIhZ8G4Fgq/kUSLao/I6kreU+VJcPrH3Ey17eosJGS/d01CFw
 VxBRPoycpV79PSwXaJyFdDh1oPgKmfskOb/Eh8J5v1v7sQGiI3B1P7OlYJmwpShcSIE5LlAbRbT
 5+5YZSrogzEKU17slYtXS4JnkrZ/FM6RQdh4ikELC1co56qN/QtVa4u87JbebHP6PZZ69bk1lcy
 FBT1DFQl9YlyBsRB/4pgSVwWkFtoEBSSaaRJ9rcXyfN5YnSj+kU0kHeIPgaemG+Yx1EIb1RvDpH
 Ehv6WC85ViFsFuNQXDw==
X-Proofpoint-GUID: 9fyxScA-pcIiFl_bT5Yynx1JEic1pTK3
X-Authority-Analysis: v=2.4 cv=a/wAM0SF c=1 sm=1 tr=0 ts=69d8a181 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=hYD4mLzqdKOEPKpwNsQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 9fyxScA-pcIiFl_bT5Yynx1JEic1pTK3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_02,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100061

On 4/9/26 6:30 PM, John Garry wrote:
> On 09/04/2026 07:37, Nilay Shroff wrote:
>>>
>>> You mean a common blktests testcase, right?
>>>
>>> For NVMe, that test would:
>>> a. try to remove NVMe ko when we have the delayed removal active
>>> b. ensure that we can queue for no path
>>>
>>> I suppose that a common testcase could be possible (with dm mpath), but doesn't dm have its own testsuite?
>>>
>> Yes, I'd add a blktest for 'queue_if_no_path' feature. But as we know we have
>> separate test suite for dm under blktests, I'd first target nvme testcase and
>> then later add another testcase for dm-multipath.
> 
> Testing a. is a challenge to be effective, as we would typically not be able to remove the nvme modules anyway due to many other references.
> 
> For b, how about something like the following:
> 
> set_conditions() {
>      _set_nvme_trtype "$@"
> }
> 
> _delayed_nvme_reconnect_ctrl() {
>      sleep 2
>      _nvme_connect_subsys
> }
> 
> test() {
>      echo "Running ${TEST_NAME}"
> 
>      _setup_nvmet
> 
>      local nvmedev
>      local ns
>      local bytes_written
> 
>      _nvmet_target_setup
>      _nvme_connect_subsys
> 
>      # Part a: Ensure writes fail when no path returns
>      nvmedev=$(_find_nvme_dev "${def_subsysnqn}")
>      ns=$(_find_nvme_ns "${def_subsys_uuid}")
>      echo 10 > "/sys/block/"$ns"/delayed_removal_secs"
>      bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
>      if [ "$bytes_written" != 4096 ]; then
>          echo "could not write successfully initially"
>      fi
>      sleep 1
>      _nvme_disconnect_ctrl "${nvmedev}"
>      sleep 1
>      ns=$(_find_nvme_ns "${def_subsys_uuid}")
>      if [[ "${ns}" = "" ]]; then
>          echo "could not find ns after disconnect"
>      fi
>      bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
>      if [ "$bytes_written" == 4096 ]; then
>          echo "wrote successfully after disconnect"
>      fi
>      sleep 10
>      ns=$(_find_nvme_ns "${def_subsys_uuid}")
>      if [[ !"${ns}" = "" ]]; then
>          echo "found ns after delayed removal"
>      fi
> 
>      #echo "now part 2"
>      # Part b: Ensure writes work for intermittent disconnect
>      _nvme_connect_subsys
> 
>      nvmedev=$(_find_nvme_dev "${def_subsysnqn}")
>      ns=$(_find_nvme_ns "${def_subsys_uuid}")
>      echo 10 > "/sys/block/"$ns"/delayed_removal_secs"
>      bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
>      if [ "$bytes_written" != 4096 ]; then
>          echo "could not write successfully initially"
>      fi
>      sleep 1
>      _nvme_disconnect_ctrl "${nvmedev}"
>      sleep 1
>      ns=$(_find_nvme_ns "${def_subsys_uuid}")
>      if [[ "${ns}" = "" ]]; then
>          echo "could not find ns after disconnect"
>      fi
>      _delayed_nvme_reconnect_ctrl &
>      sleep 1
>      bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
>      if [ "$bytes_written" != 4096 ]; then
>          echo "could not write successfully with reconnect"
>      fi

It seems there may be a race here if we attempt to write to $ns before
the reconnect has completed in _delayed_nvme_reconnect_ctrl.

If the intention is simply to verify that the controller reconnect occurs
within the delayed removal window and test pwrite, then it may be sufficient
to:
- perform the reconnect, and
- then validate the write (pwrite) afterwards.

In that case, we could either:
- run _delayed_nvme_reconnect_ctrl in the foreground, or
- open-code the reconnect directly in the script before issuing the write.

>      sleep 10
>      ns=$(_find_nvme_ns "${def_subsys_uuid}")
>      if [[ "${ns}" = "" ]]; then
>          echo "could not find ns after delayed reconnect"
>      fi
> 
>      # Final tidy-up
>      echo 0 > /sys/block/"$ns"/delayed_removal_secs
>      nvmedev=$(_find_nvme_dev "${def_subsysnqn}")
>      _nvme_disconnect_ctrl "${nvmedev}"
>      _nvmet_target_cleanup
> 
>      echo "Test complete"
> }

Otherwise overall this looks good to me.

Thanks,
--Nilay
