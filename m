From: Israel Rukshin <israelr@mellanox.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Sun, 12 Mar 2017 12:26:18 +0200
Message-ID: <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
 <1489088191.2597.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-eopbgr50081.outbound.protection.outlook.com ([40.107.5.81]:56290
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932241AbdCLK02 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Mar 2017 06:26:28 -0400
In-Reply-To: <1489088191.2597.9.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>

Hi Bart,

scsi_device_get() affect I/O because scsi_target_unblock() use it and calls to blk_start_queue().
terminate_rport_io() is called after scsi_target_unblock() and completes all the commands
including the SYNCHRONIZE CACHE command.

I applied your patch and you can see that QUEUE_FLAG_STOPPED is on.

[  342.485087] sd 7:0:0:0: Device offlined - not ready after error recovery
[  342.505738] scsi host10: ib_srp: Path record query failed
[  342.512023] sd 10:0:0:0: Device offlined - not ready after error recovery
[  342.589265] sd 7:0:0:0: __scsi_remove_device: device_busy = 0 device_blocked = 0
[  342.624110] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
[  342.630263] sd 7:0:0:0: [sdc] Synchronize Cache(10) failed: Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
[  342.649504] scsi 7:0:0:0: alua: Detached
[  342.769099] ------------[ cut here ]------------
[  342.769107] WARNING: CPU: 10 PID: 317 at drivers/scsi/scsi_sysfs.c:1293 __scsi_remove_device+0x131/0x140
[  342.769108] Modules linked in: nfsv3 ib_srp(-) dm_service_time scsi_transport_srp ib_uverbs ib_umad ib_ipoib ib_cm mlx4_ib ib_core rpcsec_gss_krb5 nfsv4 dns_resolver nfs netconsole fscache dm_mirror dm_region_hash dm_log sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd joydev input_leds glue_helper ipmi_si iTCO_wdt pcspkr cryptd mei_me iTCO_vendor_support ipmi_devintf sg lpc_ich ipmi_msghandler mei i2c_i801 shpchp mfd_core ioatdma nfsd auth_rpcgss dm_multipath nfs_acl dm_mod lockd grace sunrpc ip_tables ext4 jbd2 mbcache sd_mod mgag200 drm_kms_helper syscopyarea isci sysfillrect sysimgblt ahci igb libsas fb_sys_fops libahci ttm scsi_transport_sas ptp pps_core crc32c_int
 el dca drm
[  342.769152]  i2c_algo_bit libata mlx4_core fjes [last unloaded: ib_srp]
[  342.769157] CPU: 10 PID: 317 Comm: kworker/10:1 Not tainted 4.11.0-rc1+ #97
[  342.769157] Hardware name: Supermicro X9DRFR/X9DRFR, BIOS 1.0a 09/11/2012
[  342.769163] Workqueue: srp_remove srp_remove_work [ib_srp]
[  342.769165] Call Trace:
[  342.769173]  dump_stack+0x63/0x90
[  342.769176]  __warn+0xcb/0xf0
[  342.769178]  warn_slowpath_null+0x1d/0x20
[  342.769180]  __scsi_remove_device+0x131/0x140
[  342.769182]  scsi_forget_host+0x60/0x70
[  342.769186]  scsi_remove_host+0x77/0x110
[  342.769189]  srp_remove_work+0x90/0x230 [ib_srp]
[  342.769192]  process_one_work+0x177/0x430
[  342.769193]  worker_thread+0x4e/0x4b0
[  342.769195]  kthread+0x101/0x140
[  342.769197]  ? process_one_work+0x430/0x430
[  342.769198]  ? kthread_create_on_node+0x60/0x60
[  342.769201]  ret_from_fork+0x2c/0x40
[  342.769202] ---[ end trace 1eef46ba7887fee3 ]---
[  342.769210] sd 10:0:0:0: __scsi_remove_device: device_busy = 0 device_blocked = 0
[  343.020039] sd 10:0:0:0: [sde] Synchronizing SCSI cache
[  352.717659] scsi host10: ib_srp: Got failed path rec status -110

Israel.


On 3/9/2017 9:36 PM, Bart Van Assche wrote:
> On Thu, 2017-03-09 at 18:37 +0200, Israel Rukshin wrote:
>> The bug reproduce when unloading srp module with one port down.
>> sd_shutdown() hangs when __scsi_remove_device() get scsi_device with
>> state SDEV_OFFLINE or SDEV_TRANSPORT_OFFLINE.
>> It hangs because sd_shutdown() is trying to send sync cache command
>> when the device is offline but with SDEV_CANCEL status.
>> The status was changed to SDEV_CANCEL by __scsi_remove_device()
>> before it calls to device_del().
>>
>> The block layer timeout mechanism doesn't cause the SYNCHRONIZE CACHE
>> command to fail after the timeout expired because the request timer
>> wasn't started.
>> blk_peek_request() that is called from scsi_request_fn() didn't return
>> this request and therefore the request timer didn't start.
>>
>> This commit doesn't accept new commands if the original state was offline.
>>
>> The bug was revealed after commit cff549 ("scsi: proper state checking
>> and module refcount handling in scsi_device_get").
>> After this commit scsi_device_get() returns error if the device state
>> is SDEV_CANCEL.
>> This eventually leads SRP fast I/O failure timeout handler not to clean
>> the sync cache command because scsi_target_unblock() skip the canceled device.
>> If this timeout handler is set to infinity then the hang remains forever
>> also before commit cff549.
> How could blk_peek_request() not return a request that has not yet been
> started? How could a patch that changes scsi_device_get() affect I/O since
> scsi_device_get() is not called from the I/O path? Anyway, could you try to
> reproduce the hang with the patch below applied and see whether the output
> produced by this patch helps to determine what is going on?
>
> Thanks,
>
> Bart.
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ba2286652ff6..855548ff4c4d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3018,8 +3018,10 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
>   		else
>   			sdev->sdev_state = SDEV_CREATED;
>   	} else if (sdev->sdev_state != SDEV_CANCEL &&
> -		 sdev->sdev_state != SDEV_OFFLINE)
> +		 sdev->sdev_state != SDEV_OFFLINE) {
> +		WARN_ONCE(true, "sdev state = %d\n", sdev->sdev_state);
>   		return -EINVAL;
> +	}
>   
>   	if (q->mq_ops) {
>   		blk_mq_start_stopped_hw_queues(q, false);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 82dfe07b1d47..35aa6b37e199 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1289,6 +1289,13 @@ void __scsi_remove_device(struct scsi_device *sdev)
>   		device_unregister(&sdev->sdev_dev);
>   		transport_remove_device(dev);
>   		scsi_dh_remove_device(sdev);
> +
> +		WARN_ON_ONCE(blk_queue_stopped(sdev->request_queue));
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: device_busy = %d device_blocked = %d\n",
> +			    __func__, atomic_read(&sdev->device_busy),
> +			    atomic_read(&sdev->device_blocked));
> +
>   		device_del(dev);
>   	} else
>   		put_device(&sdev->sdev_dev);
> -- 
> 2.12.0
