From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/3] target/file: Fix BUG() when CONFIG_DEBUG_SG=y and
 DIF protection enabled
Date: Mon, 13 Apr 2015 17:55:19 +0300
Message-ID: <552BD8D7.4050801@dev.mellanox.co.il>
References: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, target-devel@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 4/13/2015 5:21 PM, Akinobu Mita wrote:
> When CONFIG_DEBUG_SG=y and DIF protection support enabled, kernel
> BUG()s are triggered due to the following two issues:
>
> 1) prot_sg is not initialized by sg_init_table().
>
> When CONFIG_DEBUG_SG=y, scatterlist helpers check sg entry has a
> correct magic value.
>
> 2) vmalloc'ed buffer is passed to sg_set_buf().
>
> sg_set_buf() uses virt_to_page() to convert virtual address to struct
> page, but it doesn't work with vmalloc address.  vmalloc_to_page()
> should be used instead.  As prot_buf isn't usually too large, so
> fix it by allocating prot_buf by kmalloc instead of vmalloc.
>

Hi Akinobu,

This obviously fixes a bug, but I'm afraid that for certain
workloads (large IO size) this would trigger higher order allocations.

how about removing the prot_buf altogether? The only reason why
this bounce is used is to allow code sharing with rd_mcp DIF mode
calling sbc_verify_[write|read]. But I'd say it doesn't make sense
anymore given these fixes.

IMO, the t_prot_sg can be used just like t_data_sg.
In the read case, we just read the data into t_prot_sg using
bvec_iter (better to reuse fd_do_rw code) and just call
__sbc_dif_verify_read (that would not copy sg's).
In the write case, we call sbc_dif_verify_write() with NULL to
avoid the copy and then just write it to the file (reusing fd_do_rw
code).

Thoughts?

Sagi.
