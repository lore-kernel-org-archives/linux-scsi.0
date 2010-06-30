From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Wed, 30 Jun 2010 13:25:01 +0300
Message-ID: <4C2B1B7D.2090607@panasas.com>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-1-git-send-email-snitzer@redhat.com> <1277652576.4366.19.camel@mulgrave.site> <4C2B012B.2000407@panasas.com> <20100630084204.GA27609@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100630084204.GA27609@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On 06/30/2010 11:42 AM, Christoph Hellwig wrote:
> On Wed, Jun 30, 2010 at 11:32:43AM +0300, Boaz Harrosh wrote:
>> May I ask a silly question? Why the dynamic allocation?
>>
>> Why not have a const-static single global page at the block-layer somewhere
>> that will be used for all discard-type operations and be done with it once and
>> for all. A single page can be used for any size bio , any number of concurrent
>> discards, any ZERO needed operation. It can also be used by other operations
>> like padding and others. In fact isn't there one for the libsata padding?
> 
> for UNMAP we need to write into the payload.  And for ATA TRIM we need
> to write into the WRITE SAME payload.  

OK, Thanks, I see. Is it one of these operations, (like we have in OSD) where
the CDB information spills into the payload? like the scatter-gather and extent
lists and such. Do we actually use a WRITE_SAME which is not zero? for what use?

> That's another layering violation
> for those looking for them, btw..
> 

Agreed
