From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Wed, 30 Jun 2010 13:57:28 +0300
Message-ID: <4C2B2318.1030107@panasas.com>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-1-git-send-email-snitzer@redhat.com> <1277652576.4366.19.camel@mulgrave.site> <4C2B012B.2000407@panasas.com> <20100630084204.GA27609@lst.de> <4C2B1B7D.2090607@panasas.com> <20100630104155.GA1370@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:1054 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752345Ab0F3K5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2010 06:57:33 -0400
In-Reply-To: <20100630104155.GA1370@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On 06/30/2010 01:41 PM, Christoph Hellwig wrote:
> On Wed, Jun 30, 2010 at 01:25:01PM +0300, Boaz Harrosh wrote:
>> OK, Thanks, I see. Is it one of these operations, (like we have in OSD) where
>> the CDB information spills into the payload? like the scatter-gather and extent
>> lists and such.
> 
> For UNMAP the payload is a list of block number / length pairs, while
> the CDB itself doesn't contain any information like that.  It's a rather
> awkward command.
> 

How big can that be? could we, maybe, use the sense_buffer, properly allocated
already?

>> Do we actually use a WRITE_SAME which is not zero? for what use?
> 
> The kernel doesn't issue any WRITE SAME without the unmap bit set.

So if the unmap bit is set then the page can just be zero, right?

I still think a static zero-page is a worth while optimization. And
block-drivers can take care with special needs with a private mem_pool
or something. For the discard-type user and generic block layer the
page is just an implementation specific residue, No?

But don't mind me, I'm just babbling. Not that I'll do anything about it.
Boaz
