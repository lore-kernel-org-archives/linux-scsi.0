From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] enclosure: fix WARN_ON in dual path device removing
Date: Tue, 19 Nov 2013 11:24:28 -0500
Message-ID: <20131119112428.Horde.QPZlNZir309Si5C82atS47A@imap.linux.ibm.com>
References: <20131115164601.223247118@linux.vnet.ibm.com>
 <20131115164711.585346972@linux.vnet.ibm.com>
 <1384556280.2003.46.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38755 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3KSQdN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Nov 2013 11:33:13 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Tue, 19 Nov 2013 11:33:12 -0500
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 3A36F6E8048
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 11:33:07 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23033.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rAJGX9551114514
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 16:33:09 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rAJGX8Jt013096
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 11:33:09 -0500
In-Reply-To: <1384556280.2003.46.camel@dabdike.int.hansenpartnership.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Quoting James Bottomley <James.Bottomley@hansenpartnership.com>:

> On Fri, 2013-11-15 at 10:46 -0600, wenxiong@linux.vnet.ibm.com wrote:
>> The issue is happened in dual controller configuration. We got the
>> sysfs warnings when rmmod the ipr module.
>>
>> enclosure_unregister() in drivers/msic/enclosure.c, call device_unregister()
>> for each componment deivce, device_unregister()  
>> ->device_del()->kobject_del()
>> ->sysfs_remove_dir(). In sysfs_remove_dir(), set kobj->sd = NULL.
>>
>> For each componment device,  
>> enclosure_component_release()->enclosure_remove_links()->sysfs_remove_link() in which checking kobj->sd again, it has been set as NULL when doing device_unregister. So we saw all these sysfs  
>> WARNING.
>>
>> sysfs: can not remove 'enclosure_device: P1-D1      2SS6', no directory
>> ------------[ cut here ]------------
>> WARNING: at fs/sysfs/inode.c:325
>> Modules linked in: fuse loop dm_mod ses enclosure ipr(-) ipv6  
>> ibmveth libata sg ext3 jbd mbcache sd_mod crc_t10dif  
>> crct10dif_common ibmvscsi scsi_transport_srp scsi_tgt scsi_dh_rdac  
>> scsi_dh_emc scsi_dh_hp_sw scsi_dh_alua scsi_dh scsi_mod
>> CPU: 0 PID: 4006 Comm: rmmod Not tainted 3.12.0-scsi-0.11-ppc64 #1
>> task: c0000000f769aba0 ti: c0000000f8f9c000 task.ti: c0000000f8f9c000
>> NIP: c0000000002b038c LR: c0000000002b0388 CTR: 0000000000000000
>> REGS: c0000000f8f9ee70 TRAP: 0700   Not tainted  (3.12.0-scsi-0.11-ppc64)
>> MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28008444  XER: 20000000
>> SOFTE: 1
>> CFAR: c000000000736118
>>
>> GPR00: c0000000002b0388 c0000000f8f9f0f0 c0000000010ed630 0000000000000047
>> GPR04: c000000001502628 c000000001513010 0000000000000689 652027656e636c6f
>> GPR08: 737572655f646576 c000000000ae2b7c 0000000000a20000 c000000000add630
>> GPR12: 0000000028008442 c000000007f20000 0000000000000000 0000000010146920
>> GPR16: 00000000100cb9d8 0000000010093088 0000000010146920 0000000000000000
>> GPR20: 0000000000000000 0000000010161900 00000000100ce458 0000000000000000
>> GPR24: 0000000010161940 0000000000000000 d0000000046ad440 0000000000000000
>> GPR28: c0000000f8f9f270 0000000000000000 c0000000fcb882c8 0000000000000000
>> NIP [c0000000002b038c] .sysfs_hash_and_remove+0xe4/0xf0
>> LR [c0000000002b0388] .sysfs_hash_and_remove+0xe0/0xf0
>> Call Trace:
>> [c0000000f8f9f0f0] [c0000000002b0388]  
>> .sysfs_hash_and_remove+0xe0/0xf0 (unreliable)
>> [c0000000f8f9f190] [c0000000002b4134] .sysfs_remove_link+0x24/0x60
>> [c0000000f8f9f200] [d000000004df037c]  
>> .enclosure_remove_links+0x64/0xa0 [enclosure]
>> [c0000000f8f9f2d0] [d000000004df0518]  
>> .enclosure_component_release+0x30/0x60 [enclosure]
>> [c0000000f8f9f350] [c000000000540068] .device_release+0x50/0xd8
>> [c0000000f8f9f3d0] [c0000000003b6f80] .kobject_cleanup+0xb8/0x230
>> [c0000000f8f9f460] [c00000000053f404] .put_device+0x1c/0x30
>> [c0000000f8f9f4d0] [d000000004df0db0]  
>> .enclosure_unregister+0xa0/0xe8 [enclosure]
>> [c0000000f8f9f560] [d000000004f90094]  
>> .ses_intf_remove_enclosure+0x8c/0xa8 [ses]
>> [c0000000f8f9f5f0] [c0000000005413ec] .device_del+0xf4/0x268
>> [c0000000f8f9f680] [c000000000541594] .device_unregister+0x34/0x88
>> [c0000000f8f9f700] [d000000001423d3c]  
>> .__scsi_remove_device+0x104/0x128 [scsi_mod]
>> [c0000000f8f9f780] [d00000000141eff8] .scsi_forget_host+0x70/0xa0 [scsi_mod]
>> [c0000000f8f9f800] [d000000001413dc0] .scsi_remove_host+0x88/0x178  
>> [scsi_mod]
>> [c0000000f8f9f890] [d00000000469db5c] .ipr_remove+0x7c/0xf8 [ipr]
>> [c0000000f8f9f920] [c0000000003fe1f4] .pci_device_remove+0x64/0xf0
>> [c0000000f8f9f9b0] [c000000000544f10] .__device_release_driver+0xd0/0x158
>> [c0000000f8f9fa40] [c0000000005450d8] .driver_detach+0x140/0x148
>> [c0000000f8f9fae0] [c000000000543848] .bus_remove_driver+0xe0/0x188
>> [c0000000f8f9fb70] [c00000000054628c] .driver_unregister+0x3c/0x80
>> [c0000000f8f9fbf0] [c0000000003fe35c] .pci_unregister_driver+0x34/0xe8
>> [c0000000f8f9fc90] [d0000000046a5fb4] .ipr_exit+0x2c/0x44 [ipr]
>> [c0000000f8f9fd20] [c0000000001359dc] .SyS_delete_module+0x204/0x308
>> [c0000000f8f9fe30] [c000000000009f60] syscall_exit+0x0/0xa0
>> Instruction dump:
>> e8010010 eb81ffe0 7c0803a6 eba1ffe8 ebc1fff0 ebe1fff8 4e800020 3c62ff8a
>> 7ca42b78 3863c388 48485d45 60000000 <0fe00000> 3860fffe 4bffff94 fba1ffe8
>> o
>> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
>> ---
>>  drivers/misc/enclosure.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> Index: b/drivers/misc/enclosure.c
>> ===================================================================
>> --- a/drivers/misc/enclosure.c	2013-11-08 12:30:25.000000000 -0600
>> +++ b/drivers/misc/enclosure.c	2013-11-08 14:47:55.527765695 -0600
>> @@ -233,7 +233,8 @@ static void enclosure_component_release(
>>  	struct enclosure_component *cdev = to_enclosure_component(dev);
>>
>>  	if (cdev->dev) {
>> -		enclosure_remove_links(cdev);
>> +		if (dev->kobj.sd)
>> +			enclosure_remove_links(cdev);
>
> This can happen everywhere for a multi path device, can't it, so the
> correct thing to do would be to check in the actual link case, like the
> below.
>
> James
>
> ---
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 0e8df41..3491b7f 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -198,6 +198,13 @@ static void enclosure_remove_links(struct  
> enclosure_component *cdev)
>  {
>  	char name[ENCLOSURE_NAME_SIZE];
>
> +	/*
> +	 * In odd circumstances, like multipath devices, something else may
> +	 * already have removed the links, so check for this condition first.
> +	 */
> +	if (!cdev->dev->kobj.sd)
> +		return;
> +
>  	enclosure_link_name(cdev, name);
>  	sysfs_remove_link(&cdev->dev->kobj, name);
>  	sysfs_remove_link(&cdev->cdev.kobj, "device");
Hi James,

I verified your patch on my system and it works as well.

Thanks,
Wendy


