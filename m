From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/3] target/file: Fix BUG() when CONFIG_DEBUG_SG=y and
 DIF protection enabled
Date: Wed, 15 Apr 2015 22:10:31 -0700
Message-ID: <1429161031.26182.17.camel@haakon3.risingtidesystems.com>
References: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: target-devel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-04-13 at 23:21 +0900, Akinobu Mita wrote:
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
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: target-devel@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/target/target_core_file.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 

Thanks for testing with CONFIG_DEBUG_SG=y.

Applied to target-pending/for-next, with CC' for v3.14.y stable.

Thank you,

--nab
