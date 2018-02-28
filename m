From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Wed, 28 Feb 2018 10:25:10 +0800
Message-ID: <449a5591-252d-e1f9-967b-d9c530f1f788@oracle.com>
References: <1519631932-1730-1-git-send-email-jianchao.w.wang@oracle.com>
 <1519700898.3120.3.camel@wdc.com>
 <3b6ca136-ba62-3eca-6eca-d191490b7754@oracle.com>
 <1519702875.3120.7.camel@wdc.com>
 <db9c47e6-d8ea-1e9e-609a-ff1b1db3769c@oracle.com>
 <1519708355.3120.9.camel@wdc.com>
 <478f40f1-d86c-ee5f-daaf-6332b67fe721@oracle.com>
 <1519751213.23791.3.camel@wdc.com> <1519751913.23791.6.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519751913.23791.6.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi Bart

Thanks for your kindly response and precious time to review this.

On 02/28/2018 01:18 AM, Bart Van Assche wrote:
> On Tue, 2018-02-27 at 17:06 +0000, Bart Van Assche wrote:
>> On Tue, 2018-02-27 at 13:15 +0800, jianchao.wang wrote:
>>> Can you share more details about this ? 
>>
>> After having had another look, I think your patch is fine.
> 
> (replying to my own e-mail)
> 
> What I think is fine in your patch is that it skips the unprep and reprep
> when requeueing. However, there is a put_device(&sdev->sdev_gendev) call
> in scsi_mq_requeue_cmd() and your patch causes that put_device() call to
> be skipped when requeueing. An explanation is needed in the commit message
> why you think that removing that put_device() call is fine.

Your concern is right.
For the block legacy path in scsi core, the get_device(&sdev->sdev_gendev) is in prep.
So when it requeue the request w/ RQF_DONTPREP, the reference will not be got again.
However, for blk-mq patch in scsi core, the get_device(&sdev->sdev_gendev) in .get_budget,
so put_device is still needed here.

Thanks for your directive.
Jianchao
