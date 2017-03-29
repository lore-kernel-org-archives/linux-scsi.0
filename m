From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 03/23] sd: implement REQ_OP_WRITE_ZEROES
Date: Wed, 29 Mar 2017 16:51:50 +0200
Message-ID: <e19ca1bf-0908-1eb0-cb04-cd306692f216@redhat.com>
References: <20170323143341.31549-1-hch@lst.de>
 <20170323143341.31549-4-hch@lst.de> <1490726988.2573.16.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1490726988.2573.16.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "agk@redhat.com" <agk@redhat.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "shli@kernel.org" <shli@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 28/03/2017 20:50, Bart Van Assche wrote:
> 
> This means that just like the start and end of a discard must be aligned on a
> discard_granularity boundary, WRITE SAME commands with the UNMAP bit set must
> also respect that granularity. I think this means that either
> __blkdev_issue_zeroout() has to be modified such that it rejects unaligned
> REQ_OP_WRITE_ZEROES operations or that blk_bio_write_same_split() has to be
> modified such that it generates REQ_OP_WRITEs for the unaligned start and tail.

I don't think this is the case.

Rather, Linux should try to align the WRITE SAME commands to the optimal
unmap granularity if the zeroed area requires performing more than one
WRITE SAME command (i.e. > maximum write same length or too large to fit
in the CDB).  However, even in that case it can use WRITE SAME with
UNMAP for the unaligned start and tail.  Unlike the UNMAP command, the
SCSI standard does guarantee that zeroes are written in the unaligned parts.

Paolo
