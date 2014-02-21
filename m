From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Thu, 20 Feb 2014 20:44:46 -0500
Message-ID: <5306AF8E.3080006@hurleysoftware.com>
References: <1392929071-16555-1-git-send-email-tj@kernel.org> <1392929071-16555-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1392929071-16555-5-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/20/2014 03:44 PM, Tejun Heo wrote:
> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> and a nasty surprise in terms of reentrancy guarantee as workqueue
> considers work items to be different if they don't have the same work
> function.
>
> firewire core-device and sbp2 have been been multiplexing work items
> with multiple work functions.  Introduce fw_device_workfn() and
> sbp2_lu_workfn() which invoke fw_device->workfn and
> sbp2_logical_unit->workfn respectively and always use the two
> functions as the work functions and update the users to set the
> ->workfn fields instead of overriding work functions using
> PREPARE_DELAYED_WORK().
>
> It would probably be best to route this with other related updates
> through the workqueue tree.
>
> Compile tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: linux1394-devel@lists.sourceforge.net
> Cc: Chris Boot <bootc@bootc.net>
> Cc: linux-scsi@vger.kernel.org
> Cc: target-devel@vger.kernel.org
> ---
>   drivers/firewire/core-device.c | 22 +++++++++++++++-------
>   drivers/firewire/sbp2.c        | 17 +++++++++++++----
>   include/linux/firewire.h       |  1 +
>   3 files changed, 29 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
> index de4aa40..2c6d5e1 100644
> --- a/drivers/firewire/core-device.c
> +++ b/drivers/firewire/core-device.c
> @@ -916,7 +916,7 @@ static int lookup_existing_device(struct device *dev, void *data)
>   		old->config_rom_retries = 0;
>   		fw_notice(card, "rediscovered device %s\n", dev_name(dev));
>
> -		PREPARE_DELAYED_WORK(&old->work, fw_device_update);
> +		old->workfn = fw_device_update;
>   		fw_schedule_device_work(old, 0);
>
>   		if (current_node == card->root_node)
> @@ -1075,7 +1075,7 @@ static void fw_device_init(struct work_struct *work)
>   	if (atomic_cmpxchg(&device->state,
>   			   FW_DEVICE_INITIALIZING,
>   			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE) {
> -		PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
> +		device->workfn = fw_device_shutdown;
>   		fw_schedule_device_work(device, SHUTDOWN_DELAY);

Implied mb of test_and_set_bit() in queue_work_on() ensures that the
newly assigned work function is visible on all cpus before evaluating
whether or not the work can be queued.

Ok.

>   	} else {
>   		fw_notice(card, "created device %s: GUID %08x%08x, S%d00\n",
> @@ -1196,13 +1196,20 @@ static void fw_device_refresh(struct work_struct *work)
>   		  dev_name(&device->device), fw_rcode_string(ret));
>    gone:
>   	atomic_set(&device->state, FW_DEVICE_GONE);
> -	PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
> +	device->workfn = fw_device_shutdown;
>   	fw_schedule_device_work(device, SHUTDOWN_DELAY);
>    out:
>   	if (node_id == card->root_node->node_id)
>   		fw_schedule_bm_work(card, 0);
>   }
>
> +static void fw_device_workfn(struct work_struct *work)
> +{
> +	struct fw_device *device = container_of(to_delayed_work(work),
> +						struct fw_device, work);

I think this needs an smp_rmb() here.

> +	device->workfn(work);
> +}
> +

Otherwise this cpu could speculatively load workfn before
set_work_pool_and_clear_pending(), which means that the old workfn
could have been loaded but PENDING was still set and caused queue_work_on()
to reject the work as already pending.

Result: the new work function never runs.

But this exposes a more general problem that I believe workqueue should
prevent; speculated loads and stores in the work item function should be
prevented from occurring before clearing PENDING in
set_work_pool_and_clear_pending().

IOW, the beginning of the work function should act like a barrier in
the same way that queue_work_on() (et. al.) already does.

Regards,
Peter Hurley
