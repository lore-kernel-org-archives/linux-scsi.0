From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 11/32] target: Convert se_dev_entry to kref
Date: Mon, 16 Dec 2013 13:15:30 -0800
Message-ID: <1387228530.20247.222.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-12-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-12-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_device.c   |   12 +++-------
>  drivers/target/target_core_internal.h |   12 ++++++++++
>  drivers/target/target_core_pr.c       |   38 ++++++++++++--------------------
>  drivers/target/target_core_tpg.c      |    2 +-
>  include/target/target_core_base.h     |    3 +-
>  5 files changed, 32 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 1954b0f..295b5e4 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -224,8 +224,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
>  		if (port->sep_rtpi != rtpi)
>  			continue;
>  
> -		atomic_inc(&deve->pr_ref_count);
> -		smp_mb__after_atomic_inc();
> +		get_deve(deve);
>  		spin_unlock_irq(&nacl->device_list_lock);
>  
>  		return deve;
> @@ -401,12 +400,6 @@ int core_disable_device_list_for_node(
>  	spin_lock_bh(&port->sep_alua_lock);
>  	list_del(&deve->alua_port_node);
>  	spin_unlock_bh(&port->sep_alua_lock);
> -	/*
> -	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
> -	 * PR operation to complete.
> -	 */
> -	while (atomic_read(&deve->pr_ref_count) != 0)
> -		cpu_relax();
>  
>  	spin_lock_irq(&nacl->device_list_lock);
>  	/*
> @@ -421,6 +414,9 @@ int core_disable_device_list_for_node(
>  	spin_unlock_irq(&nacl->device_list_lock);
>  
>  	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
> +
> +	put_deve(deve);
> +
>  	return 0;
>  }

Same issue yet again.  It's not safe to release all of the se_dev_entry
pointers, UAs, and PR associations until the other references from
different process contexts have been released.

Also the issue with reuse of se_dev_entry also exists here.
configfs_group_operations->drop_item() callbacks should not return until
all references have completed.

NAK.

--nab
