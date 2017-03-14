From: Israel Rukshin <israelr@mellanox.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Tue, 14 Mar 2017 11:44:56 +0200
Message-ID: <c9afc172-105a-cabf-b286-150c6dc11a68@mellanox.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
 <1489088191.2597.9.camel@sandisk.com>
 <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
 <1489430936.2658.9.camel@sandisk.com>
 <1489432986.23810.12.camel@HansenPartnership.com>
 <1489437175.2658.17.camel@sandisk.com>
 <1489442133.23810.24.camel@HansenPartnership.com>
 <1489458944.2987.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-eopbgr30071.outbound.protection.outlook.com ([40.107.3.71]:53152
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751028AbdCNJpD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Mar 2017 05:45:03 -0400
In-Reply-To: <1489458944.2987.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>

Hello Bart,

I applied and tested patches 3, 4 and 5.
I am sorry to tell you that it didn't work.
I saw the warning you added and the hang at device_del().

[  333.696462] ------------[ cut here ]------------
[  333.696471] WARNING: CPU: 11 PID: 321 at 
drivers/scsi/scsi_sysfs.c:1280 __scsi_remove_device+0x106/0x110
[  333.696472] Modules linked in: nfsv3 ib_srp(-) dm_service_time 
scsi_transport_srp ib_uverbs ib_umad ib_ipoib ib_cm mlx4_ib ib_core 
rpcsec_gss_krb5 nfsv4 dns_resolver nfs netconsole fscache dm_mirror 
dm_region_hash dm_log sb_edac edac_core x86_pkg_temp_thermal 
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel iTCO_wdt pcbc iTCO_vendor_support 
aesni_intel mei_me crypto_simd joydev input_leds ipmi_si ioatdma mei 
glue_helper lpc_ich pcspkr cryptd ipmi_devintf shpchp ipmi_msghandler sg 
i2c_i801 mfd_core dm_multipath dm_mod nfsd binfmt_misc auth_rpcgss 
nfs_acl lockd grace sunrpc ip_tables ext4 jbd2 mbcache sd_mod mgag200 
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops isci igb 
ttm ahci libsas ptp libahci scsi_transport_sas pps_core dca crc32c_intel
[  333.696511]  drm i2c_algo_bit libata mlx4_core fjes [last unloaded: 
ib_srp]
[  333.696516] CPU: 11 PID: 321 Comm: kworker/11:1 Not tainted 
4.11.0-rc2+ #99
[  333.696517] Hardware name: Supermicro X9DRFR/X9DRFR, BIOS 1.0a 09/11/2012
[  333.696522] Workqueue: srp_remove srp_remove_work [ib_srp]
[  333.696523] Call Trace:
[  333.696530]  dump_stack+0x63/0x90
[  333.696534]  __warn+0xcb/0xf0
[  333.696536]  warn_slowpath_null+0x1d/0x20
[  333.696538]  __scsi_remove_device+0x106/0x110
[  333.696540]  scsi_forget_host+0x60/0x70
[  333.696545]  scsi_remove_host+0x77/0x110
[  333.696547]  srp_remove_work+0x90/0x230 [ib_srp]
[  333.696551]  process_one_work+0x177/0x430
[  333.696553]  worker_thread+0x4e/0x4b0
[  333.696555]  kthread+0x101/0x140
[  333.696556]  ? process_one_work+0x430/0x430
[  333.696558]  ? kthread_create_on_node+0x60/0x60
[  333.696563]  ret_from_fork+0x2c/0x40
[  333.696565] ---[ end trace b1edd584bf21aaba ]---

Israel.


On 3/14/2017 4:35 AM, Bart Van Assche wrote:
> On Mon, 2017-03-13 at 14:55 -0700, James Bottomley wrote:
>> This is true, but I don't see how it can cause the host to be freed
>> before the sdev.  The memory for struct Scsi_Host is freed in the
>> shost_gendev release routine, which should be pinned by the parent
>> traversal from sdev.  So it should not be possible for
>>   scsi_host_dev_release() to be called before
>>   scsi_device_dev_release_usercontext() becase the latter has the final
>> put of the parent device.
> Hello James,
>
> I will run a bisect to see whether that provides more information about
> what caused the change in the reference counting behavior.
>
> Israel, since you did not hit the reference counting issue in your tests,
> can you repeat your test with patches 3, 4 and 5 applied?
>
> Thanks,
>
> Bart.
