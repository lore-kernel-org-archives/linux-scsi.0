From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH v2 1/2] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Thu, 2 Jun 2016 11:09:13 +0800
Message-ID: <574FA359.2070804@huawei.com>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
 <BF6B9AADDDF11740967545E971C7C0DE6B861A22@MAIL1.pickering.lenbrook.com>
 <574F9BE4.4020405@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <574F9BE4.4020405@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
To: Kevin Groeneveld <KGroeneveld@lenbrook.com>, "tj@kernel.org" <tj@kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "corbet@lwn.net" <corbet@lwn.net>
Cc: "hch@infradead.org" <hch@infradead.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 2016/6/2 10:37, Wei Fang wrote:
> Hi, Kevin,
> 
> On 2016/6/1 22:36, Kevin Groeneveld wrote:
>>> Subject: [PATCH v2 1/2] scsi: fix race between simultaneous decrements of ->host_failed
>>
>> I wonder if this could be related to http://www.spinics.net/lists/linux-scsi/msg86808.html?
>>
>> I never did get to the bottom of that.  If I have time I hope to retest my scsi hang issue with this patch.
>>
> 
> The concurrently decrements of host_failed only lead to abnormal
> of host_failed, host_busy will be zero after error handler, and
> the result may be host_failed > host_busy forever. But in your
> case, host_busy > host_failed, so I think it's not the same
> case. I'm afraid that this patch can't fix your scsi hang issue.

Something wrong in my words. host_busy may not be zero after error
handler, but the result is true that missing decrement of host_failed
may lead to host_failed > host_busy.

Thanks,
Wei

