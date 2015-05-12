From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 03/12] target/configfs: Convert mappedlun + SCSI MIBs
 to RCU reader
Date: Tue, 12 May 2015 13:58:35 -0700
Message-ID: <5552697B.8050008@redhat.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1431422736-29125-4-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 05/12/2015 02:25 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch converts fabric independent configfs link/unlink to use
> RCU read path macros for se_node_acl->lun_entry_hlist access.
>
> It also converts SCSI MIB configfs show attribute code to use
> RCU read path macros for se_node_acl->lun_entry_hlist access.
>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_fabric_configfs.c |  35 +++---
>   drivers/target/target_core_stat.c            | 180 +++++++++++++--------------
>   2 files changed, 110 insertions(+), 105 deletions(-)
>
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index 6cb4828..0dab6d5 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -123,16 +123,16 @@ static int target_fabric_mappedlun_link(
>   	 * which be will write protected (READ-ONLY) when
>   	 * tpg_1/attrib/demo_mode_write_protect=1
>   	 */
> -	spin_lock_irq(&lacl->se_lun_nacl->device_list_lock);
> -	deve = lacl->se_lun_nacl->device_list[lacl->mapped_lun];
> -	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
> +	rcu_read_lock();
> +	deve = target_nacl_find_deve(lacl->se_lun_nacl, lacl->mapped_lun);
> +	if (deve && deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)

Why do we still need TRANSPORT_LUNFLAGS_INITIATOR_ACCESS? Isn't deve 
being not-NULL enough?

-- Andy
