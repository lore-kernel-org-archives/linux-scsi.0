Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77F82FFDDE;
	Thu, 23 Apr 2026 08:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776931621; cv=none; b=DYAipGAUTdSvZhRwDlSGR5szz1nLtMvEUQTfRkN+sscCQp+WnCePy5gNSeeVWyz7FpnpQiC5RWzpyxx04Yoqzk5bzO/X7ryaAaJveBBVwCfZijb0Mdnq/OpTLZJ//buPdRmw1q8bDJXKPDtyBIyiaC9KwQ2AKeNvPdDXX6QJSSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776931621; c=relaxed/simple;
	bh=jqc8L2jXIm9yMdm3Y6fH9bA32sxq5mNS3Njua0GR5og=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g0kQ4JifTLOW3iU+Wl9DPnl2djhv1v3Hb+VBHXjZFjRmcOkBBVBGvL74tsyWhRaiyRnVdD/V6U3aF5JzPco9NxyZ62PHT4lOKsjv9vQSPmqWhGYt48HEBcOJv/7iImVOBpr/gaA5P4nHhqZnnF2VVt6zScyCGG4Wj14k+ky1u3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ncz8DOiH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ncz8DOiH"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MGML6U3515186;
	Thu, 23 Apr 2026 08:06:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=bxi6IJ
	3aE/tu2sGioxou/vZaxEnNZQlnyhpHaOQJoWY=; b=ncz8DOiHzTyYaQNNfKWnY6
	rCS5lfoP7oW4/7xJiWF1IBjaZA7M/a4KTx8i16XAbVOpUNUw79UZmF0fWSwCIO/B
	Kp5RBWy4GVAoMLEfkHVIIDcnvWjg3YkpdISfHN6H+X18esOwvFgEWJqWDcVivpUg
	/daX91McyZTlc+R8ksknK4Ag4uoE3TocpYBrK9tMtQkk8vszMGjbbFZqWmvX0LtD
	9xJ0SM+KLjnD8o7wOuHuxJ0utuQCrkQz6QARZC3xeTXJ8OEiHYQYk2LSiixLbZNy
	RZgxI6E2NGAfXk1wUSmtZKR+8IIQon91ORUooD6H8OmGaAqIXApkIXl+tNUKYVQg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu27n15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 08:06:00 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63N85Y58021558;
	Thu, 23 Apr 2026 08:05:59 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjky5s4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 08:05:59 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63N85wuT12714538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 08:05:58 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8594958054;
	Thu, 23 Apr 2026 08:05:58 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC8555805A;
	Thu, 23 Apr 2026 08:05:49 +0000 (GMT)
Received: from [9.124.217.242] (unknown [9.124.217.242])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Apr 2026 08:05:49 +0000 (GMT)
Message-ID: <d6282aa7-4673-4bae-a0ff-fbd84f0a610f@linux.ibm.com>
Date: Thu, 23 Apr 2026 13:35:47 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
To: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc: Daniel Wagner <dwagner@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
        Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>,
        hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "tytso@mit.edu" <tytso@mit.edu>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Christian Brauner <brauner@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        "willy@infradead.org" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        "amir73il@gmail.com" <amir73il@gmail.com>,
        "vbabka@suse.cz"
 <vbabka@suse.cz>,
        Damien Le Moal <dlemoal@kernel.org>
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
 <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local>
 <aY77ogf5nATlJUg_@shinmob>
 <901f4daf-3226-416f-8741-dd15573e736b@linux.ibm.com>
 <aecTw6IYs1fo26EX@shinmob>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <aecTw6IYs1fo26EX@shinmob>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDA3NCBTYWx0ZWRfX+TG4krB7zqZu
 OXbp9oVjPeMTEGs2QBAKSDljHKdPiAQaFyvQd/1MYt7hJYyAJS1S5ZmHYUct4uYVqI9j2i9t9rk
 FXE1XZkn4xOJCR+3BA4cHfQsbQRvGIgQIOKjTUPK/s2CJB2zqQF+06/i5W8PR1bBYWoX1GTEVR6
 qot7jjBQjTbg7BY6FEAFLceyjnT0TPEPZvE26Iqeg4+vjZ/Zkpmruec8fpPt6PhpTYGHg1/pDo1
 xthffe8jNIxO9sef0xxejvHv6Dtgrnefc+6KdpfpYQU0TeCnr4EmJcIP8hzfpEVkiea2eycRWW8
 v9L9CQHO3s1GJdljbJs9bNJzuuxkmp9ArFOTKctCKnoLa5N5PhAVMQp1eMJvINKZrfpPTbj9r9U
 iQMqjZNwRNTaBsGzJ0owOWf4xP6F5fq1570gZAl5pbXxiXGtK9vlB+Ky8hmVeoVLbFVMan4vCUv
 MJSQLxonARs2uQkr1Zg==
X-Proofpoint-ORIG-GUID: OOjIfKd0yVPwG5ssNBh8GILi_QA-oMuG
X-Proofpoint-GUID: H4i410UZSAsk7SAw-VjArRpCGMjqVMUm
X-Authority-Analysis: v=2.4 cv=XMUAjwhE c=1 sm=1 tr=0 ts=69e9d2e8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=Ikd4Dj_1AAAA:8 a=9iF2WbhH_aIozX9BpwEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230074

On 4/21/26 11:49 AM, Shin'ichiro Kawasaki wrote:
> On Feb 16, 2026 / 00:08, Nilay Shroff wrote:
>>
>>
>> On 2/13/26 4:53 PM, Shinichiro Kawasaki wrote:
>>> On Feb 12, 2026 / 08:52, Daniel Wagner wrote:
>>>> On Wed, Feb 11, 2026 at 08:35:30PM +0000, Chaitanya Kulkarni wrote:
>>>>>     For the storage track at LSFMMBPF2026, I propose a session dedicated to
>>>>>     blktests to discuss expansion plan and CI integration progress.
>>>>
>>>> Thanks for proposing this topic.
>>>
>>> Chaitanya, my thank also goes to you.
>>>
>> Yes thanks for proposing this!
>>
>>>> Just a few random topics which come to mind we could discuss:
>>>>
>>>> - blktests has gain a bit of traction and some folks run on regular
>>>>    basis these tests. Can we gather feedback from them, what is working
>>>>    good, what is not? Are there feature wishes?
>>>
>>> Good topic, I also would like to hear about it.
>>>
>> One improvement I’d like to highlight is related to how blktests are executed
>> today. So far, we’ve been running blktests serially, but if it's possible to
>> run tests in parallel to improve test turnaround time and make large-scale or
>> CI-based testing more efficient? For instance, adding parallel_safe Tags: Marking tests
>> that don't modify global kernel state so they can be safely offloaded to parallel
>> workers. Marking parallel_safe tags would allow the runner to distinguish:
>>
>> Safe Tests: Tests that only perform I/O on a specific, non-shared device or
>> check static kernel parameters.
>>
>> Unsafe Tests: Tests that reload kernel modules, modify global /sys or /proc entries,
>> or require exclusive access to specific hardware addresses.
>>
>> Yes adding parallel execution support shall require framework/design changes.
> 
> Hi Nilay, thanks for the idea. I understand that shorter test time will make CI
> cycles faster and improve the development efficiency.
> 
> Said that, the safe/unsafe testing idea may not be enough. I think majority of
> test case does kernel module set up using null_blk, scsi_debug, or nvme target
> drivers. Then I foresee the majority of the test cases will be "unsafe", and
> cannot be run in parallel.
> 
> Also, parallel runs on single system will affect dmesg or kmemleak checking.
> We cannot tell which run caused a dmesg message or a memory leak.
> 
> For the runtime reduction by parallel runs, I guess blktests run on VMs might be
> the good approach as Haris pointed out. Anyway, this topic will need more
> discussion.
> 
> [...]

Alright, see if we may discuss this during LSFMM.

> 
>>>   4. Long standing failures make test result reports dirty
>>>      - I feel lockdep WARNs are tend to be left unfixed rather long period.
>>>        How can we gather effort to fix them?
>>
>> I agree regarding lockdep; recently we did see quite a few lockdep splats.
>> That said, I believe the number has dropped significantly and only a small
>> set remains. From what I can tell, most of the outstanding lockdep issues
>> are related to fs-reclaim paths recursing into the block layer while the
>> queue is frozen. We should be able to resolve most of these soon, or at
>> least before the conference. If anything is still outstanding after that,
>> we can discuss it during the conference and work toward addressing it as
>> quickly as possible.
> 
> Taking this chance, I'd like to express my appreciation for the effort to
> resolve the lockdep issues. It is great that a number of lockdeps are already
> fixed. Said that, two lockdep issues are still observed with v7.0 kernel at
> nvme/005 and nbd/002 [1]. I would like to gather attentions to the failures.
> 
> [1] https://lore.kernel.org/linux-block/ynmi72x5wt5ooljjafebhcarit3pvu6axkslqenikb2p5txe57@ldytqa2t4i2x/
> 
I think nvme/005 and nbd/002 failures shall be addressed with this
patch: https://lore.kernel.org/all/20260413171628.6204-1-kch@nvidia.com/

It's currently applied to nvme-7.1 and not there yet to mainline kernel.

Thanks,
--Nilay

