From: Kiran Patil <kiran.patil@intel.com>
Subject: Re: [PATCH-v2 1/4] target: Fix multi task->task_sg[] chaining logic
 bug
Date: Tue, 17 May 2011 14:27:34 -0700
Message-ID: <4DD2E846.6090009@intel.com>
References: <1305088535-27486-1-git-send-email-nab@linux-iscsi.org> <1305088535-27486-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305088535-27486-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Acked-by: Kiran Patil <kiran.patil@intel.com>

On 5/10/2011 9:35 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger<nab@linux-iscsi.org>
>
> This patch fixes a bug in transport_do_task_sg_chain() used by HW target
> mode modules with sg_chain() to provide a single sg_next() walkable memory
> layout for use with pci_map_sg() and friends.  This patch addresses an
> issue with mapping multiple small block max_sector tasks across multiple
> struct se_task->task_sg[] mappings for HW target mode operation.
>
> This was causing OOPs with (cmd->t_task->t_tasks_no>  1) I/O traffic for
> HW target drivers using transport_do_task_sg_chain(), and has been tested
> so far with tcm_fc(openfcoe), tcm_qla2xxx, and ib_srpt fabrics with
> t_tasks_no>  1 IBLOCK backends using a smaller max_sectors to trigger the
> original issue.
>
> Reported-by: Kiran Patil<kiran.patil@intel.com>
> Signed-off-by: Nicholas Bellinger<nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_transport.c |   26 +++++++++++++++-----------
>   1 files changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 9583b23..fefe10a 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -4776,18 +4776,20 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
>   				sg_end_cur->page_link&= ~0x02;
>
>   				sg_chain(sg_head, task_sg_num, sg_head_cur);
> -				sg_count += (task->task_sg_num + 1);
> -			} else
>   				sg_count += task->task_sg_num;
> +				task_sg_num = (task->task_sg_num + 1);
> +			} else {
> +				sg_chain(sg_head, task_sg_num, sg_head_cur);
> +				sg_count += task->task_sg_num;
> +				task_sg_num = task->task_sg_num;
> +			}
>
>   			sg_head = sg_head_cur;
>   			sg_link = sg_link_cur;
> -			task_sg_num = task->task_sg_num;
>   			continue;
>   		}
>   		sg_head = sg_first =&task->task_sg[0];
>   		sg_link =&task->task_sg[task->task_sg_num];
> -		task_sg_num = task->task_sg_num;
>   		/*
>   		 * Check for single task..
>   		 */
> @@ -4798,9 +4800,12 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
>   			 */
>   			sg_end =&task->task_sg[task->task_sg_num - 1];
>   			sg_end->page_link&= ~0x02;
> -			sg_count += (task->task_sg_num + 1);
> -		} else
>   			sg_count += task->task_sg_num;
> +			task_sg_num = (task->task_sg_num + 1);
> +		} else {
> +			sg_count += task->task_sg_num;
> +			task_sg_num = task->task_sg_num;
> +		}
>   	}
>   	/*
>   	 * Setup the starting pointer and total t_tasks_sg_linked_no including
> @@ -4809,21 +4814,20 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
>   	T_TASK(cmd)->t_tasks_sg_chained = sg_first;
>   	T_TASK(cmd)->t_tasks_sg_chained_no = sg_count;
>
> -	DEBUG_CMD_M("Setup T_TASK(cmd)->t_tasks_sg_chained: %p and"
> -		" t_tasks_sg_chained_no: %u\n", T_TASK(cmd)->t_tasks_sg_chained,
> +	DEBUG_CMD_M("Setup cmd: %p T_TASK(cmd)->t_tasks_sg_chained: %p and"
> +		" t_tasks_sg_chained_no: %u\n", cmd, T_TASK(cmd)->t_tasks_sg_chained,
>   		T_TASK(cmd)->t_tasks_sg_chained_no);
>
>   	for_each_sg(T_TASK(cmd)->t_tasks_sg_chained, sg,
>   			T_TASK(cmd)->t_tasks_sg_chained_no, i) {
>
> -		DEBUG_CMD_M("SG: %p page: %p length: %d offset: %d\n",
> -			sg, sg_page(sg), sg->length, sg->offset);
> +		DEBUG_CMD_M("SG[%d]: %p page: %p length: %d offset: %d, magic: 0x%08x\n",
> +			i, sg, sg_page(sg), sg->length, sg->offset, sg->sg_magic);
>   		if (sg_is_chain(sg))
>   			DEBUG_CMD_M("SG: %p sg_is_chain=1\n", sg);
>   		if (sg_is_last(sg))
>   			DEBUG_CMD_M("SG: %p sg_is_last=1\n", sg);
>   	}
> -
>   }
>   EXPORT_SYMBOL(transport_do_task_sg_chain);
>
