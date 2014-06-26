From: "Atchley, Scott" <atchleyes@ornl.gov>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Thu, 26 Jun 2014 15:41:48 +0000
Message-ID: <86EE1A5C-8943-4C87-9A79-899DE85971CA@ornl.gov>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
 <1402477799-24610-2-git-send-email-sagig@mellanox.com>
 <53AC3402.2080302@acm.org> <1403794551.3572.6.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1403794551.3572.6.camel@dabdike>
Content-Language: en-US
Content-ID: <642D3FD07D596B4EBBF13477F523FB09@local>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Sagi Grimberg <sagig@mellanox.com>, "<michaelc@cs.wisc.edu>" <michaelc@cs.wisc.edu>, "<martin.petersen@oracle.com>" <martin.petersen@oracle.com>, "<nab@linux-iscsi.org>" <nab@linux-iscsi.org>, "<roland@kernel.org>" <roland@kernel.org>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>, "<target-devel@vger.kernel.org>" <target-devel@vger.kernel.org>, "<linux-rdma@vger.kernel.org>" <linux-rdma@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Jun 26, 2014, at 10:55 AM, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2014-06-26 at 16:53 +0200, Bart Van Assche wrote:
>> On 06/11/14 11:09, Sagi Grimberg wrote:
>>> +	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
>> 
>> Sorry that I just noticed this now, but why is a shift-right and ilog2()
>> used in the above expression instead of just dividing the transfer
>> length by the sector size ?
> 
> It's a performance thing.  Division is really slow on most CPUs.
> However, we know the divisor is a power of two so we re-express the
> division as a shift, which the processor can do really fast.
> 
> James

I have done this in the past as well, but have you benchmarked it? Compilers typically do the right thing in this case (i.e replace division with shift).

Scott