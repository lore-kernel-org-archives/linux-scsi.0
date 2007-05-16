From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 16 May 2007 20:29:53 +0300
Message-ID: <464B3F91.1010102@panasas.com>
References: <20070508112553C.fujita.tomonori@lab.ntt.co.jp>	 <4640C724.8030409@panasas.com> <1178654497.3737.81.camel@mulgrave.il.steeleye.com> <46417C5A.1090707@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:48145 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754758AbXEPRd1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2007 13:33:27 -0400
In-Reply-To: <46417C5A.1090707@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, bhalevy@panasas.com, jens.axboe@oracle.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

Boaz Harrosh wrote:
> James Bottomley wrote:
>> 
>> There's actually a fourth option you haven't considered:
>>
>> Roll all the required sglist definitions (request_bufflen,
>> request_buffer, use_sg and sglist_len) into the sgtable pools.
>>
> This is a grate Idea. Let me see if I understand what you mean.
> ...
> ...

Hi Dear James, list.
I have worked on proposed solution (If anyone is interested see
url blow)

Now it works and all but I hit some problems.
What happens is that in 64 bit architectures, well in x86_64,
the sizeof scatterlist structure is 32 bytes which means that
we can only fit exactly 128 of them in a page. But together with
the scsi_sg_table header we are down to 127. Also if we want
good alignment/packing of other sized pools we want:
static struct scsi_host_sg_pool scsi_sg_pools[] = {
	SP(7),
	SP(15),
	SP(31),
	SP(63),
	SP(127)
};

now there are 2 issues with this:
1. Even if I do blk_queue_max_phys_segments(q, 127); I still get
   requests for use_sg=128 which will crash the kernel.

2. If I do SPs of 7,15,31,63,128 or even 8,16,32,64,128 it will
   boot and work but clearly it does not fit in one page. So either
   my sata drivers and iSCSI, which I test, are not sensitive to
   scatterlists fit one page. Or kernel gives me 2 contiguous pages?

I do not see away out of this problem. I think that even with Jens's
chaining of sg_tables 128 is a magic number that we don't want to cross

It leaves me with option 3 on the bidi front. I think it would be best
to Just allocate another global mem_pool of scsi_data_buffer(s) just like
we do for scsi_io_context. The uni scsi_data_buffer will be embedded in
struct scsi_cmnd and the bidi one will be allocated from this pool.
I am open to any suggestions.

If anyone wants to see I have done 2 versions of this work. One on top
of Jens's sg-chaining work (ver 5). And one on top of Tomo's cleanup
git. both can be found here:
  http://www.bhalevy.com/open-osd/download/scsi_sg_table/

Boaz

