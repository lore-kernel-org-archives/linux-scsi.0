From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/8] target: remove se_hba_cache
Date: Tue, 23 Nov 2010 18:13:58 -0800
Message-ID: <1290564838.30138.161.camel@haakon2.linux-iscsi.org>
References: <20101123223053.574330460@bombadil.infradead.org>
	 <20101123223109.874349746@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37591 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0KXCT0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 21:19:26 -0500
In-Reply-To: <20101123223109.874349746@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-11-23 at 17:30 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-kill-se_hba_cache)
> There is no need of a slab cache for the hba structures.  There's very few of
> them and their allocation it in a slow path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: lio-core/drivers/target/target_core_configfs.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_configfs.c	2010-11-23 22:12:05.405254018 +0100
> +++ lio-core/drivers/target/target_core_configfs.c	2010-11-23 22:33:25.000253320 +0100
> @@ -3163,7 +3163,7 @@ static struct config_group *target_core_
>  
>  	return &hba->hba_group;
>  out:
> -	kmem_cache_free(se_hba_cache, hba);
> +	kfree(hba);
>  	return ERR_PTR(ret);
>  }
>  
> Index: lio-core/drivers/target/target_core_device.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_device.c	2010-11-23 22:11:59.006253249 +0100
> +++ lio-core/drivers/target/target_core_device.c	2010-11-23 22:33:25.014252691 +0100
> @@ -1619,7 +1619,7 @@ int core_dev_setup_virtual_lun0(void)
>  	ret = se_core_add_hba(hba, "rd_dr", 0);
>  	if (ret < 0) {
>  		printk("se_core_add_hba() with %d\n", ret);
> -		kmem_cache_free(se_hba_cache, hba);
> +		kfree(hba);
>  		return ret;
>  	}
>  
> Index: lio-core/drivers/target/target_core_hba.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_hba.c	2010-11-23 22:12:05.407253459 +0100
> +++ lio-core/drivers/target/target_core_hba.c	2010-11-23 22:33:25.026253459 +0100
> @@ -48,8 +48,8 @@ struct se_hba *core_alloc_hba(void)
>  {
>  	struct se_hba *hba;
>  
> -	hba = kmem_cache_zalloc(se_hba_cache, GFP_KERNEL);
> -	if (!(hba)) {
> +	hba = kmalloc(sizeof(*hba), GFP_KERNEL);
> +	if (!hba) {
>  		printk(KERN_ERR "Unable to allocate struct se_hba\n");
>  		return NULL;
>  	}

Hmmm, actually I assumed you where using kzalloc() here but unfortuately
that is not the case.   kmalloc() w/o a trailing memset here creates the
following OOPs in configfs code for the non zero'ed hba->hba_group..

TCM: Registered subsystem plugin: iblock struct module: f09c0118
TCM: Registered subsystem plugin: fileio struct module: f09c71a0
TCM: Registered subsystem plugin: pscsi struct module: f09ced68
TCM: Registered subsystem plugin: stgt struct module: f0a8af40
CORE_HBA[840988271] - TCM FILEIO HBA Driver 4.0 on Generic Target Core Stack v4.0.0-rc5
CORE_HBA[840988271] - Attached FILEIO HBA: 0 to Generic Target Core with TCQ Depth: 256 MaxSectors: 1024
CORE_HBA[1] - Attached HBA to Generic Target Core
BUG: unable to handle kernel paging request at f0041c80
IP: [<c1092f95>] kfree+0x29/0xc3
*pde = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/tcm_loop_0/tcm_loop_adapter_0/host7/target7:0:1/7:0:1:0/type
Modules linked in: target_core_stgt target_core_pscsi target_core_file target_core_iblock target_core_mod iscsi_initiator_mod cryptomgr aead crc32c crypto_hash crypto_algapi scsi_tgt configfs dm_mirror dm_region_hash dm_log dm_snapshot sg pcnet32 mii [last unloaded: target_core_mod]

Pid: 15935, comm: tcm_node Not tainted 2.6.37-rc2+ #52 440BX Desktop Reference Platform/VMware Virtual Platform
EIP: 0060:[<c1092f95>] EFLAGS: 00210282 CPU: 0
EIP is at kfree+0x29/0xc3
EAX: 4556455f EBX: f0041c80 ECX: ee477e70 EDX: cbe92690
ESI: f0cdfc4c EDI: cbe92694 EBP: ee477e48 ESP: ee477e30
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process tcm_node (pid: 15935, ti=ee476000 task=e1c5b480 task.ti=ee476000)
Stack:
 00000000 4556455f cbe92690 cbe92690 f0cdfc4c cbe92694 ee477e60 f0dc59fb
 cbe92694 cbe92690 f0cdfc4c ee477ec8 ee477e78 f0dc5a4e cbe92690 ec8b73c0
 cbe92690 ee477e8f ee477ed8 f0cbb818 ee477e90 ec8b73c0 656c6966 30006f69
Call Trace:
 [<f0dc59fb>] ? config_item_set_name+0x7d/0x8f [configfs]
 [<f0dc5a4e>] ? config_group_init_type_name+0x10/0x23 [configfs]
 [<f0cbb818>] ? target_core_call_addhbatotarget+0xfe/0x108 [target_core_mod]
 [<f0dc4bf9>] ? configfs_mkdir+0x138/0x2d1 [configfs]
 [<c109d68a>] ? vfs_mkdir+0x5c/0x88
 [<f0dc4ac1>] ? configfs_mkdir+0x0/0x2d1 [configfs]
 [<c109f402>] ? sys_mkdirat+0x7a/0xba
 [<c1098de9>] ? sys_stat64+0x14/0x28
 [<c10888ce>] ? do_mmap_pgoff+0x22f/0x27f
 [<c1002903>] ? sysenter_exit+0xf/0x18
 [<c109f452>] ? sys_mkdir+0x10/0x12
 [<c10028d0>] ? sysenter_do_call+0x12/0x36
Code: 5d c3 55 89 e5 57 56 53 83 ec 0c 83 f8 10 89 45 ec 0f 86 a6 00 00 00 89 c3 81 c3 00 00 00 40 c1 eb 0c c1 e3 05 03 1d 80 44 af c1 <8b> 03 66 85 c0 79 03 8b 5b 0c 8b 03 84 c0 78 14 66 f7 03 00 c0 
EIP: [<c1092f95>] kfree+0x29/0xc3 SS:ESP 0068:ee477e30
CR2: 00000000f0041c80
---[ end trace 9a735723aa0c3f01 ]---

Converted to a kzalloc() and rebased into new commit 4a17dbe7bcc.

--nab

