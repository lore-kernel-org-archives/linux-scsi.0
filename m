From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/3] target/file: Fix SG table for prot_buf
 initialization
Date: Wed, 15 Apr 2015 22:16:59 -0700
Message-ID: <1429161419.26182.23.camel@haakon3.risingtidesystems.com>
References: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com>
	 <1428934918-4004-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428934918-4004-2-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: target-devel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-04-13 at 23:21 +0900, Akinobu Mita wrote:
> In fd_do_prot_rw(), it allocates prot_buf which is used to copy from
> se_cmd->t_prot_sg by sbc_dif_copy_prot().  The SG table for prot_buf
> is also initialized by allocating 'se_cmd->t_prot_nents' entries of
> scatterlist and setting the data length of each entry to PAGE_SIZE
> at most.
> 
> However if se_cmd->t_prot_sg contains a clustered entry (i.e.
> sg->length > PAGE_SIZE), the SG table for prot_buf can't be
> initialized correctly and sbc_dif_copy_prot() can't copy to prot_buf.
> (This actually happened with TCM loopback fabric module)
> 
> As prot_buf is allocated by kzalloc() and it's physically contiguous,
> we only need a single scatterlist entry.
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
>  drivers/target/target_core_file.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 

Applied to target-pending/for-next, with CC' for v3.14.y stable.

Thanks Akinobu!
