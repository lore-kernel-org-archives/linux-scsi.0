From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH-for-4.6 1/6] target: Add target_alloc_session() helper
 function
Date: Mon, 11 Jan 2016 14:10:06 -0800
Message-ID: <5694283E.3070401@sandisk.com>
References: <1452458668-11034-1-git-send-email-nab@daterainc.com>
 <1452458668-11034-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452458668-11034-2-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org



On 01/10/2016 12:44 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> Based on HCH's original patch, this adds a full version to
> support percpu-ida tag pre-allocation and callback function
> pointer into fabric driver code to complete session setup.
>
> Reported-by: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Andy Grover <agrover@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_transport.c | 55 ++++++++++++++++++++++++++++++++++
>   include/target/target_core_fabric.h    |  6 ++++
>   2 files changed, 61 insertions(+)
>
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index c5035b9..fd4404f6 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -374,6 +374,61 @@ void transport_register_session(
>   }
>   EXPORT_SYMBOL(transport_register_session);
>
> +struct se_session *
> +target_alloc_session(struct se_portal_group *tpg,
> +		     unsigned int tag_num, unsigned int tag_size,
> +		     enum target_prot_op prot_op,
> +		     const char *initiatorname, void *private,
> +		     int (*callback)(struct se_portal_group *,
> +				     struct se_session *, void *))

Please use a more descriptive name instead of "callback", e.g. 
"init_session".

> +{
> +	struct se_session *sess;
> +
> +	if (tag_num != 0 && !tag_size) {
> +		pr_err("target_alloc_session called with percpu-ida tag_num:"
> +		       " %u, but zero tag_size\n", tag_num);
> +		return ERR_PTR(-EINVAL);
> +	}
> +	if (!tag_num && tag_size) {
> +		pr_err("target_alloc_session called with percpu-ida tag_size:"
> +		       " %u, but zero tag_num\n", tag_size);
> +		return ERR_PTR(-EINVAL);
> +	}

Please combine the above two tests into a single test, e.g. !!tag_num != 
!!tag_size or (bool)tag_num != (bool)tag_size.

Thanks,

Bart.
