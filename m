From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] RDMA/srp: Avoid calling mutex_lock() from inside
 scsi_queue_rq()
Date: Mon, 21 Jan 2019 13:21:08 -0800
Message-ID: <0bb65e25-fcb9-76aa-aad7-811ef7e6f6ef@acm.org>
References: <20190117002717.84686-1-bvanassche@acm.org>
 <20190117002717.84686-2-bvanassche@acm.org>
 <20190119100304.GB24246@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190119100304.GB24246@infradead.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Sergey Gorenko <sergeygo@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/19/19 2:03 AM, Christoph Hellwig wrote:
> On Wed, Jan 16, 2019 at 04:27:16PM -0800, Bart Van Assche wrote:
>> In scsi-mq mode it is not allowed to sleep inside srp_queuecommand()
>> since the flag BLK_MQ_F_BLOCKING has not been set. Since setting the
>> request queue flag BLK_MQ_F_BLOCKING would slow down the hot path, make
>> srp_queuecommand() skip the mutex_lock() and mutex_unlock() calls when
>> called from inside scsi_queue_rq() from the SCSI EH thread.
>>
>> This patch avoids that the following appears in the kernel log:
> 
> I think we need to get rid of the taking a sleeping lock in
> ->queuecomand entirely.  These checks are way to fragile.

Hi Christoph,

My own opinion is that the SCSI core should allow SCSI drivers to block 
all .queuecommand() calls e.g. to allow SCSI LLDs to perform error 
recovery. That is possible today for .queuecommand() calls that are the 
result of queueing a new command but not for .queuecommand() calls from 
the SCSI error handler. About three years ago I came up with multiple 
proposals for realizing such a change in the SCSI error handler. No 
matter what approach I proposed, the SCSI maintainer did not agree. No 
alternative approach was proposed either by the SCSI maintainer. That is 
why the srp_queuecommand() context check has been added to the SRP 
driver - there was no alternative.

How about proceeding with this patch and bringing up the SCSI error 
handler issue during LSF/MM? I hope that meeting in person will make it 
easier to reach agreement compared to an e-mail discussion. After an 
agreement has been reached and the SCSI error handler has been improved 
it will be possible to remove the context check from the SRP initiator 
driver.

Thanks,

Bart.
