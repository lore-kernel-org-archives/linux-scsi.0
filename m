From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Wed, 30 Jun 2010 11:32:43 +0300
Message-ID: <4C2B012B.2000407@panasas.com>
References: <20100622180029.GA15950@redhat.com>	 <1277582211-10725-1-git-send-email-snitzer@redhat.com> <1277652576.4366.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277652576.4366.19.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On 06/27/2010 06:29 PM, James Bottomley wrote:
<snip>
>> +		/*
>> +		 * If this is a discard request that originated from the kernel
>> +		 * we need to free our payload here.  Note that we need to check
>> +		 * the request flag as the normal payload rules apply for
>> +		 * pass-through UNMAP / WRITE SAME requests.
>> +		 */
>> +		__free_page(bio_page(cmd->request->bio));
> 
> This is another layering violation:  the page is allocated in the Upper
> layer and freed in the mid-layer.
> 

May I ask a silly question? Why the dynamic allocation?

Why not have a const-static single global page at the block-layer somewhere
that will be used for all discard-type operations and be done with it once and
for all. A single page can be used for any size bio , any number of concurrent
discards, any ZERO needed operation. It can also be used by other operations
like padding and others. In fact isn't there one for the libsata padding?

(It could be dynamical allocated on first use for embedded system)

just my $0.017
Boaz
