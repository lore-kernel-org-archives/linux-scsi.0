From: Huang Ying <ying.huang@intel.com>
Subject: Re: Fwd: [lkp] [dma] 6894258eda: mpt2sas0: reply_post_free pool:
 pci_pool_alloc failed
Date: Fri, 18 Sep 2015 07:48:08 +0800
Message-ID: <1442533688.26334.3.camel@intel.com>
References: <87lhc5g3a6.fsf@yhuang-dev.intel.com>
	 <CA+55aFwbbRxBMA7p+NC-g6VuKkSJQjgrJ-y0nngRseARFXcxFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbbIQXso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2015 19:48:44 -0400
In-Reply-To: <CA+55aFwbbRxBMA7p+NC-g6VuKkSJQjgrJ-y0nngRseARFXcxFA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, Max Filippov <jcmvbkbc@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, James Bottomley <jbottomley@parallels.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>

On Thu, 2015-09-17 at 11:38 -0700, Linus Torvalds wrote:
> This was missing the rest of the sign-off chain, and the scsi/mpt
> people who might have more ideas about why that change causes
> problems
> for mpt2sas.
> 
> Ying Huang - can you make the test robot reports add at least the
> sign-off list (and probably also add people who are listed as
> "Acked-by:" and "Tested-by:") when it has bisected to a particular
> commit?

Sure.  We will do this.

Best Regards,
Huang, Ying

>                      Linus
> 
> ---------- Forwarded message ----------
> From: kernel test robot <ying.huang@intel.com>
> Date: Wed, Sep 16, 2015 at 7:58 PM
> Subject: [lkp] [dma] 6894258eda: mpt2sas0: reply_post_free pool:
> pci_pool_alloc failed
> To: Christoph Hellwig <hch@lst.de>
> Cc: lkp@01.org, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds
> <torvalds@linux-foundation.org>
> 
> 
> FYI, we noticed the below changes on
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git ma
> ster
> commit 6894258eda2f9badc28c878086c0e54bd5b7fb30 ("dma-mapping:
> consolidate dma_{alloc,free}_{attrs,coherent}")
> 
> 
> [   38.454412] mpt2sas 0000:01:00.0: swiotlb buffer is full (sz:
> 398336 bytes)
> [   38.462243] swiotlb: coherent allocation failed for device
> 0000:01:00.0 size=398336
> [   38.470860] CPU: 33 PID: 1287 Comm: systemd-udevd Not tainted
> 4.2.0-10851-g6894258 #1
> [   38.479661] Hardware name: Intel Corporation BRICKLAND/BRICKLAND,
> BIOS BRBDXSD1.000.0320.R00.1506111113 06/11/2015
> [   38.491285]  00000000000613ff ffff887fe642b998 ffffffff81400352
> 00000000ffffffff
> [   38.499656]  ffff887fe642b9d8 ffffffff81427f86 0000000000000007
> 00000000000002d0
> [   38.508025]  ffff883ff0cce098 0000000000061400 ffff883fe0e178d8
> ffffffff81cd9bc0
> [   38.516366] Call Trace:
> [   38.520330]  [<ffffffff81400352>] dump_stack+0x4b/0x69
> [   38.527336]  [<ffffffff81427f86>]
> swiotlb_alloc_coherent+0x146/0x160
> [   38.535725]  [<ffffffff8105ad53>]
> x86_swiotlb_alloc_coherent+0x43/0x50
> [   38.544292]  [<ffffffff811aed05>] dma_pool_alloc+0x105/0x240
> [   38.551877]  [<ffffffffa0167de6>]
> _base_allocate_memory_pools+0x306/0x10d0 [mpt2sas]
> [   38.562571]  [<ffffffffa0166662>] ?
> _base_handshake_req_reply_wait+0x1e2/0x430 [mpt2sas]
> [   38.572893]  [<ffffffffa016c6bb>] mpt2sas_base_attach+0x39b/0x7c0
> [mpt2sas]
> [   38.581956]  [<ffffffffa0170d0c>] _scsih_probe+0x38c/0x520
> [mpt2sas]
> [   38.590334]  [<ffffffff814467c5>] local_pci_probe+0x45/0xa0
> [   38.597808]  [<ffffffff81447bb7>] pci_device_probe+0xd7/0x120
> [   38.605480]  [<ffffffff815490b4>] driver_probe_device+0x224/0x490
> [   38.613534]  [<ffffffff815493a4>] __driver_attach+0x84/0x90
> [   38.620992]  [<ffffffff81549320>] ?
> driver_probe_device+0x490/0x490
> [   38.629224]  [<ffffffff81546dd4>] bus_for_each_dev+0x64/0xa0
> [   38.636759]  [<ffffffff81548a4e>] driver_attach+0x1e/0x20
> [   38.643997]  [<ffffffff815485b1>] bus_add_driver+0x1f1/0x290
> [   38.651527]  [<ffffffffa0196000>] ? 0xffffffffa0196000
> [   38.658480]  [<ffffffff81549d40>] driver_register+0x60/0xe0
> [   38.665907]  [<ffffffff8144616c>] __pci_register_driver+0x4c/0x50
> [   38.673932]  [<ffffffffa0196164>] _scsih_init+0x164/0x1000
> [mpt2sas]
> [   38.682255]  [<ffffffff81002123>] do_one_initcall+0xb3/0x1d0
> [   38.689808]  [<ffffffff811c1e44>] ?
> kmem_cache_alloc_trace+0x1b4/0x220
> [   38.698339]  [<ffffffff811647f8>] ? do_init_module+0x27/0x1e8
> [   38.705976]  [<ffffffff81164831>] do_init_module+0x60/0x1e8
> [   38.713431]  [<ffffffff810f98b9>] load_module+0x2089/0x24b0
> [   38.720841]  [<ffffffff810f5ac0>] ? __symbol_put+0x40/0x40
> [   38.728139]  [<ffffffff810f9ee0>] SyS_finit_module+0x80/0xb0
> [   38.735647]  [<ffffffff818aa42e>]
> entry_SYSCALL_64_fastpath+0x12/0x71
> [   38.744018] mpt2sas0: reply_post_free pool: pci_pool_alloc failed
> 
> 
> To reproduce:
> 
>         git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
>         cd lkp-tests
>         bin/lkp install job.yaml  # job file is attached in this
> email
>         bin/lkp run     job.yaml
> 
> 
> 
> Thanks,
> Ying Huang
