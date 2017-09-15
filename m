From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH V2] megaraid: kmemleak: Track page allocation for fusion
Date: Fri, 15 Sep 2017 14:12:18 +0100
Message-ID: <20170915131218.lu5ca4j3d6idl3hq@localhost>
References: <20170915052152.5032-1-shuwang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170915052152.5032-1-shuwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shuwang@redhat.com
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuhu@redhat.com, yizhan@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2017 at 01:21:52PM +0800, shuwang@redhat.com wrote:
> From: Shu Wang <shuwang@redhat.com>
> 
> Kmemleak reports about a thousand false positives for fusion->
> cmd_list[]. Root casue is the cmd_list objects are allocated from
> slab allocator, and stored its pointer in object allocated by page
> allocator. The fix will tell kmemleak to track and scan fusion
> object.
> 
> V2:
> Add comment, balance braces, move kmemleak_free before free_pages.
> checkpatch passed.
> 
> Before patch:
> kmemleak: 1004 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> 
> unreferenced object 0xffff88042584e000 (size 8192):
>   backtrace:
>      kmemleak_alloc+0x4a/0xa0
>      __kmalloc+0xec/0x220
>      megasas_alloc_cmdlist_fusion+0x3e/0x140 [megaraid_sas]
>      megasas_alloc_cmds_fusion+0x44/0x450 [megaraid_sas]
>      megasas_init_adapter_fusion+0x21d/0x6e0 [megaraid_sas]
>      megasas_init_fw+0x357/0xd30 [megaraid_sas]
>      megasas_probe_one.part.34+0x5be/0x1040 [megaraid_sas]
>      megasas_probe_one+0x46/0xc0 [megaraid_sas]
>      local_pci_probe+0x45/0xa0
>      work_for_cpu_fn+0x14/0x20
>      process_one_work+0x149/0x360
>      worker_thread+0x1d8/0x3c0
>      kthread+0x109/0x140
>      ret_from_fork+0x25/0x30
> 
> Signed-off-by: Shu Wang <shuwang@redhat.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.

-- 
Catalin
