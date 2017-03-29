From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 1/2] scsi: sas: flush destruct workqueue on device
 unregister
Date: Wed, 29 Mar 2017 12:15:44 +0100
Message-ID: <02778435-6c67-0ac9-2faa-03ebb7934477@huawei.com>
References: <cover.1490775958.git.jthumshirn@suse.de>
 <9580eaf323f5da17dcace9e32b22a1df4099961d.1490775958.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9580eaf323f5da17dcace9e32b22a1df4099961d.1490775958.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, Jack Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 29/03/2017 10:41, Johannes Thumshirn wrote:
> In the advent of an SAS device unregister we have to wait for all destruct
> works to be done to not accidently delay deletion of a SAS rphy or it's
> children to the point when we're removing the SCSI or SAS hosts.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/libsas/sas_discover.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 60de662..75b18f1 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -382,9 +382,13 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
>  	}
>
>  	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
> +		struct sas_discovery *disc = &dev->port->disc;
> +		struct sas_work *sw = &disc->disc_work[DISCE_DESTRUCT].work;
> +
>  		sas_rphy_unlink(dev->rphy);
>  		list_move_tail(&dev->disco_list_node, &port->destroy_list);
>  		sas_discover_event(dev->port, DISCE_DESTRUCT);
> +		flush_work(&sw->work);

I quickly tested plugging out the expander and we never get past this 
call to flush - a hang results:

root@(none)$ [  243.357088] INFO: task kworker/u32:1:106 blocked for 
more than 120 seconds.
[  243.364030]       Not tainted 4.11.0-rc1-13687-g2562e6a-dirty #1388
[  243.370282] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  243.378086] kworker/u32:1   D    0   106      2 0x00000000
[  243.383566] Workqueue: scsi_wq_0 sas_phye_loss_of_signal
[  243.388863] Call trace:
[  243.391314] [<ffff000008085d70>] __switch_to+0xa4/0xb0
[  243.396442] [<ffff0000088f1134>] __schedule+0x1b4/0x5d0
[  243.401654] [<ffff0000088f1588>] schedule+0x38/0x9c
[  243.406520] [<ffff0000088f4540>] schedule_timeout+0x194/0x294
[  243.412249] [<ffff0000088f202c>] wait_for_common+0xb0/0x144
[  243.417805] [<ffff0000088f20d4>] wait_for_completion+0x14/0x1c
[  243.423623] [<ffff0000080d5bd4>] flush_work+0xe0/0x1a8
[  243.428747] [<ffff000008598158>] sas_unregister_dev+0xf8/0x110
[  243.434563] [<ffff000008598304>] sas_unregister_domain_devices+0x4c/0xc8
[  243.441242] [<ffff000008596884>] sas_deform_port+0x14c/0x15c
[  243.446886] [<ffff000008596508>] sas_phye_loss_of_signal+0x48/0x54
[  243.453048] [<ffff0000080d6164>] process_one_work+0x138/0x2d8
[  243.458776] [<ffff0000080d635c>] worker_thread+0x58/0x424
[  243.464161] [<ffff0000080dc16c>] kthread+0xf4/0x120
[  243.469024] [<ffff0000080836c0>] ret_from_fork+0x10/0x50
[  364.189094] INFO: task kworker/u32:1:106 blocked for more than 120 
seconds.
[  364.196035]       Not tainted 4.11.0-rc1-13687-g2562e6a-dirty #1388
[  364.202281] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  364.210085] kworker/u32:1   D    0   106      2 0x00000000
[  364.215558] Workqueue: scsi_wq_0 sas_phye_loss_of_signal
[  364.220855] Call trace:
[  364.223303] [<ffff000008085d70>] __switch_to+0xa4/0xb0
[  364.228428] [<ffff0000088f1134>] __schedule+0x1b4/0x5d0
[  364.233640] [<ffff0000088f1588>] schedule+0x38/0x9c
[  364.238506] [<ffff0000088f4540>] schedule_timeout+0x194/0x294
[  364.244237] [<ffff0000088f202c>] wait_for_common+0xb0/0x144
[  364.249793] [<ffff0000088f20d4>] wait_for_completion+0x14/0x1c
[  364.255610] [<ffff0000080d5bd4>] flush_work+0xe0/0x1a8
[  364.260736] [<ffff000008598158>] sas_unregister_dev+0xf8/0x110
[  364.266551] [<ffff000008598304>] sas_unregister_domain_devices+0x4c/0xc8
[  364.273230] [<ffff000008596884>] sas_deform_port+0x14c/0x15c
[  364.278872] [<ffff000008596508>] sas_phye_loss_of_signal+0x48/0x54
[  364.285034] [<ffff0000080d6164>] process_one_work+0x138/0x2d8
[  364.290763] [<ffff0000080d635c>] worker_thread+0x58/0x424
[  364.296147] [<ffff0000080dc16c>] kthread+0xf4/0x120
[  364.301013] [<ffff0000080836c0>] ret_from_fork+0x10/0x50

Is the issue that we are trying to flush the queue when we are working 
in the same queue context?

Thanks,
John

>  	}
>  }
>
>
