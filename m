From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC 02/22] target: Convert enable/disable ->device_list to RCU
 updater
Date: Sun, 29 Mar 2015 09:51:50 +0300
Message-ID: <5517A106.6090005@dev.mellanox.co.il>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com> <1427443512-8925-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37877 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbbC2Gvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Mar 2015 02:51:55 -0400
Received: by wiaa2 with SMTP id a2so83815646wia.0
        for <linux-scsi@vger.kernel.org>; Sat, 28 Mar 2015 23:51:54 -0700 (PDT)
In-Reply-To: <1427443512-8925-3-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 3/27/2015 11:04 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch converts core_[enable,disable]_device_list_for_node() to RCU
> updater path code when modifying se_dev_entry pointers.
>
> It includes protected rcu_assign_pointer() and invokes synchronize_rcu()
> to wait for RCU read paths to finish.
>
> Required for subsequent conversion to se_deve->pr_ref percpu-refcount.
>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_device.c | 50 ++++++++++++++++---------------------
>   1 file changed, 22 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index be893c8..9385e16 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -324,31 +324,16 @@ int core_enable_device_list_for_node(
>   	struct se_port *port = lun->lun_sep;
>   	struct se_dev_entry *deve;
>
> -	spin_lock_irq(&nacl->device_list_lock);
> -
> -	deve = nacl->device_list[mapped_lun];
> -
>   	/*
>   	 * Check if the call is handling demo mode -> explicit LUN ACL
>   	 * transition.  This transition must be for the same struct se_lun
>   	 * + mapped_lun that was setup in demo mode..
>   	 */
> +	spin_lock_irq(&nacl->lun_entry_lock);
> +	deve = nacl->lun_entry_hlist[mapped_lun];
>   	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> -		if (deve->se_lun_acl != NULL) {
> -			pr_err("struct se_dev_entry->se_lun_acl"
> -			       " already set for demo mode -> explicit"
> -			       " LUN ACL transition\n");
> -			spin_unlock_irq(&nacl->device_list_lock);
> -			return -EINVAL;
> -		}
> -		if (deve->se_lun != lun) {
> -			pr_err("struct se_dev_entry->se_lun does"
> -			       " match passed struct se_lun for demo mode"
> -			       " -> explicit LUN ACL transition\n");
> -			spin_unlock_irq(&nacl->device_list_lock);
> -			return -EINVAL;
> -		}
> -		deve->se_lun_acl = lun_acl;
> +		BUG_ON(deve->se_lun_acl != NULL);
> +		BUG_ON(deve->se_lun != lun);

Are these a MUST? Can't we WARN and return an error instead of shutting
down the lights on everyone?


