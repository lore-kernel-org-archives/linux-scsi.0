From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] lpfc: Don't return internal MBXERR_ERROR code from
 probe function
Date: Wed, 6 Sep 2017 10:32:22 +0200
Message-ID: <20170906103222.538c07b2@elisabeth>
References: <a1464fd9d04361952cbbc031622c3259358eb8ac.1503925436.git.sbrivio@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752075AbdIFIc3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Sep 2017 04:32:29 -0400
In-Reply-To: <a1464fd9d04361952cbbc031622c3259358eb8ac.1503925436.git.sbrivio@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, QLogic-Storage-Upstream@cavium.com
Cc: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Hi,

On Mon, 28 Aug 2017 15:05:23 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> Internal error codes happen to be positive, thus the PCI driver
> core won't treat them as failure, but we do. This would cause a
> crash later on as lpfc_pci_remove_one() is called (e.g. as
> shutdown function).
> 
> Fixes: 6d368e532168 ("[SCSI] lpfc 8.3.24: Add resource extent support")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 491aa95eb0f6..38cc2b5bb5a2 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -6118,6 +6118,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
>  				"Extents and RPI headers enabled.\n");
>  		}
>  		mempool_free(mboxq, phba->mbox_mem_pool);
> +		rc = -EIO;
>  		goto out_free_bsmbx;
>  	}
>  

I didn't get feedback about this patch. Is there any issue with the
submission?

I think it actually fixes a quite critical issue, if initialization
fails we have crashes on reboot like the one reported below [1], and
should perhaps also be queued for -stable.


[1]

[  568.638555] BUG: unable to handle kernel NULL pointer dereference at 00000000000007c0 
[  568.679154] IP: lpfc_pci_remove_one+0x20/0x890 [lpfc] 
[  568.704062] PGD 0  
[  568.704063]  
[  568.721714] Oops: 0000 [#1] SMP 
[  568.736895] Modules linked in: fuse vfat msdos fat binfmt_misc xfs fcoe libfcoe libfc rpcrdma ib_isert iscsi_target_mod ib_iser ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_core intel_rapl x86_pkg_temp_thermal intel_powerclamp intel_cstate intel_uncore intel_rapl_perf sg ipmi_si hpilo ipmi_devintf pcspkr ipmi_msghandler lpc_ich ioatdma shpchp dca pcc_cpufreq acpi_cpufreq ext4 jbd2 mbcache loop nfsv3 nfs_acl nfs lockd grace fscache sd_mod 8021q garp stp llc mrp mgag200 ata_generic i2c_algo_bit pata_acpi drm_kms_helper syscopyarea sfc sysfillrect sysimgblt fb_sys_fops ttm tg3 mtd crct10dif_pclmul lpfc crc32_pclmul ata_piix drm ptp hpsa serio_raw scsi_transport_fc be2net ghash_clmulni_intel libata i2c_core scsi_transpor
 t_sas pps_core 
[  569.082589]  mdio wmi sunrpc xts lrw gf128mul mcryptd dm_crypt dm_round_robin dm_multipath dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_zero dm_mod linear raid10 raid456 async_raid6_recov async_memcpy libcrc32c crc32c_intel async_pq async_xor xor async_tx raid6_pq raid1 raid0 iscsi_ibft iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi squashfs cramfs edd ctr(E) 
[  569.254181] CPU: 9 PID: 46361 Comm: reboot Tainted: G            E  ------------   4.11.0-22.el7a.x86_64 #1 
[  569.301048] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/14/2012 
[  569.332878] task: ffff880801161680 task.stack: ffffc90005140000 
[  569.362693] RIP: 0010:lpfc_pci_remove_one+0x20/0x890 [lpfc] 
[  569.390275] RSP: 0018:ffffc90005143d18 EFLAGS: 00010296 
[  569.416040] RAX: 0000000000000000 RBX: ffff8804bd9cf000 RCX: 0000000000000000 
[  569.449874] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffff8804bd9cf000 
[  569.484402] RBP: ffffc90005143d78 R08: ffff8804bd9cf0b8 R09: 0000000000000006 
[  569.519146] R10: 0000000000000020 R11: ffffea0020975b80 R12: ffff8804bd9cf000 
[  569.553408] R13: ffffffffa057a2a0 R14: ffff8804bd9cf100 R15: 00000000fee1dead 
[  569.588474] FS:  00007f99fe258880(0000) GS:ffff88083f4c0000(0000) knlGS:0000000000000000 
[  569.628288] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  569.656916] CR2: 00000000000007c0 CR3: 0000000825d91000 CR4: 00000000000406e0 
[  569.693185] Call Trace: 
[  569.705044]  pci_device_shutdown+0x36/0x70 
[  569.725702]  device_shutdown+0xdf/0x190 
[  569.744657]  kernel_restart_prepare+0x36/0x40 
[  569.767099]  kernel_restart+0x12/0x60 
[  569.784916]  SYSC_reboot+0x1f3/0x220 
[  569.802649]  ? __alloc_fd+0x46/0x170 
[  569.819539]  ? vfs_writev+0x3c/0x50 
[  569.836206]  ? do_writev+0x61/0xf0 
[  569.852730]  SyS_reboot+0xe/0x10 
[  569.868375]  entry_SYSCALL_64_fastpath+0x1a/0xa9 
[  569.890588] RIP: 0033:0x7f99fd065a56 
[  569.907894] RSP: 002b:00007ffc8c5e2b58 EFLAGS: 00000202 ORIG_RAX: 00000000000000a9 
[  569.944700] RAX: ffffffffffffffda RBX: 00000000ffffff91 RCX: 00007f99fd065a56 
[  569.978659] RDX: 0000000001234567 RSI: 0000000028121969 RDI: fffffffffee1dead 
[  570.013272] RBP: 0000000000000000 R08: 00005583f9de32a0 R09: 00007ffc8c5e2220 
[  570.048039] R10: 0000000000000024 R11: 0000000000000202 R12: 00005583f9d6ef13 
[  570.082565] R13: 00007ffc8c5e2e20 R14: 0000000000000000 R15: 0000000000000000 
[  570.116914] Code: 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 89 fb 48 83 ec 38 48 8b 87 38 01 00 00 <4c> 8b b0 c0 07 00 00 48 89 45 c0 45 0f b6 86 00 08 00 00 41 80  
[  570.209034] RIP: lpfc_pci_remove_one+0x20/0x890 [lpfc] RSP: ffffc90005143d18 
[  570.246076] CR2: 00000000000007c0 
[  570.261308] ---[ end trace bd8848f6cfb1d58b ]--- 
[  570.283592] Kernel panic - not syncing: Fatal exception 
[  570.308166] Kernel Offset: disabled 
[  570.323883] ---[ end Kernel panic - not syncing: Fatal exception 


--
Stefano
