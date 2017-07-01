From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] tcmu: Fix flushing cmd entry dcache page
Date: Sat, 1 Jul 2017 18:31:05 -0500
Message-ID: <595830B9.9070505@redhat.com>
References: <1498810456-10609-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1498810456-10609-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/30/2017 03:14 AM, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> When feeding the tcmu's cmd ring, we need to flush the dcache page
> for the cmd entry to make sure these kernel stores are visible to
> user space mappings of that page.
> 
> For the none PAD cmd entry, this will be flushed at the end of the
> tcmu_queue_cmd_ring().
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>  drivers/target/target_core_user.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 203bff1..930800c 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -699,21 +699,21 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
>  		size_t pad_size = head_to_end(cmd_head, udev->cmdr_size);
>  
>  		entry = (void *) mb + CMDR_OFF + cmd_head;
> -		tcmu_flush_dcache_range(entry, sizeof(*entry));
>  		tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_PAD);
>  		tcmu_hdr_set_len(&entry->hdr.len_op, pad_size);
>  		entry->hdr.cmd_id = 0; /* not used for PAD */
>  		entry->hdr.kflags = 0;
>  		entry->hdr.uflags = 0;
> +		tcmu_flush_dcache_range(entry, sizeof(*entry));
>  
>  		UPDATE_HEAD(mb->cmd_head, pad_size, udev->cmdr_size);
> +		tcmu_flush_dcache_range(mb, sizeof(*mb));
>  
>  		cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
>  		WARN_ON(cmd_head != 0);
>  	}
>  
>  	entry = (void *) mb + CMDR_OFF + cmd_head;
> -	tcmu_flush_dcache_range(entry, sizeof(*entry));
>  	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_CMD);
>  	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
>  	entry->hdr.kflags = 0;
> 

Looks ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>
