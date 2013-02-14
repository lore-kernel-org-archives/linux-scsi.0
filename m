From: Shuah Khan <shuah.khan@hp.com>
Subject: Re: [PATCH] scsi/hpsa: fix to check dma mapping error
Date: Thu, 14 Feb 2013 08:50:31 -0700
Message-ID: <1360857031.2824.6.camel@lorien2>
References: <1360796155.2735.16.camel@lorien2>
	 <20130214163917.GI1523@beardog.cce.hp.com>
Reply-To: shuah.khan@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130214163917.GI1523@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: JBottomley@parallels.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-02-14 at 10:39 -0600, scameron@beardog.cce.hp.com wrote:
> On Wed, Feb 13, 2013 at 03:55:55PM -0700, Shuah Khan wrote:
> > Add missing dma mapping error check to fix the following warning from
> > dma-debug.
> > 
> > [   16.614739] hpsa 0000:03:00.0: DMA-API: device driver failed to check map error[device address=0x00000000001c2ec0] [size=64 bytes] [mapped as single]
> > [   16.614833] Modules linked in: pata_atiixp tg3(+) ptp pps_core hpsa(+)
> > [   16.615381] Pid: 324, comm: modprobe Not tainted 3.8.0-rc7+ #6
> > [   16.615466] Call Trace:
> > [   16.615552]  [<ffffffff810581ef>] warn_slowpath_common+0x7f/0xc0
> > [   16.615639]  [<ffffffff810582e6>] warn_slowpath_fmt+0x46/0x50
> > [   16.615747]  [<ffffffff8134c129>] check_unmap+0x459/0x8a0
> > [   16.615832]  [<ffffffff81698aad>] ? schedule_timeout+0x1ed/0x250
> > [   16.615918]  [<ffffffff8134c70c>] debug_dma_unmap_page+0x5c/0x60
> > [   16.616008]  [<ffffffffa0002776>] hpsa_pci_unmap+0x86/0xd0 [hpsa]
> > [   16.616094]  [<ffffffffa00028c0>] hpsa_scsi_do_simple_cmd_with_retry+0x100/0x2a0 [hpsa]
> > [   16.616195]  [<ffffffffa0004863>] hpsa_scsi_do_inquiry+0x83/0x100 [hpsa]
> > [   16.616282]  [<ffffffffa0006ce9>] hpsa_init_one+0x1839/0x1ce0 [hpsa]
> > [   16.616369]  [<ffffffff811fc2d8>] ? sysfs_new_dirent+0x58/0x140
> > [   16.616456]  [<ffffffff8135db9b>] local_pci_probe+0x4b/0x80
> > [   16.616542]  [<ffffffff8135f471>] pci_device_probe+0x101/0x120
> > [   16.616629]  [<ffffffff814328db>] driver_probe_device+0x7b/0x240
> > [   16.616715]  [<ffffffff81432b4b>] __driver_attach+0xab/0xb0
> > [   16.616801]  [<ffffffff81432aa0>] ? driver_probe_device+0x240/0x240
> > [   16.616888]  [<ffffffff81430cf6>] bus_for_each_dev+0x56/0x90
> > [   16.617001]  [<ffffffff8143240e>] driver_attach+0x1e/0x20
> > [   16.617087]  [<ffffffff81431f80>] bus_add_driver+0x190/0x290
> > [   16.617173]  [<ffffffffa0011000>] ? 0xffffffffa0010fff
> > [   16.617259]  [<ffffffff814330aa>] driver_register+0x7a/0x160
> > [   16.617345]  [<ffffffffa0011000>] ? 0xffffffffa0010fff
> > [   16.617431]  [<ffffffff8135e42c>] __pci_register_driver+0x4c/0x50
> > [   16.617519]  [<ffffffffa001101e>] hpsa_init+0x1e/0x1000 [hpsa]
> > [   16.617605]  [<ffffffff8100206f>] do_one_initcall+0x3f/0x170
> > [   16.617692]  [<ffffffff810bef7e>] load_module+0x16ae/0x1c40
> > [   16.617777]  [<ffffffff810bbb70>] ? show_initstate+0x50/0x50
> > [   16.617863]  [<ffffffff8169f71e>] ? do_page_fault+0xe/0x10
> > [   16.617949]  [<ffffffff810bf5de>] sys_init_module+0xce/0x100
> > [   16.618035]  [<ffffffff816a3d99>] system_call_fastpath+0x16/0x1b
> > [   16.618157] ---[ end trace 260311c4be71d0dc ]---
> > [   16.618228] Mapped at:
> > [   16.618311]  [<ffffffff8134b189>] debug_dma_map_page+0xb9/0x160
> > [   16.618451]  [<ffffffffa0004132>] fill_cmd.isra.31+0x252/0x400 [hpsa]
> > [   16.618613]  [<ffffffffa0004853>] hpsa_scsi_do_inquiry+0x73/0x100 [hpsa]
> > [   16.618766]  [<ffffffffa0006ce9>] hpsa_init_one+0x1839/0x1ce0 [hpsa]
> > [   16.618919]  [<ffffffff8135db9b>] local_pci_probe+0x4b/0x80
> > [   16.619286] scsi3 : hpsa
> > 
> > 
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > CC: stable@vger.kernel.org
> > ---
> >  drivers/scsi/hpsa.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 4f33806..3b4d195 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -1405,6 +1405,11 @@ static void hpsa_map_one(struct pci_dev *pdev,
> >  	}
> >  
> >  	addr64 = (u64) pci_map_single(pdev, buf, buflen, data_direction);
> > +	if (dma_mapping_error(&pdev->dev, addr64)) {
> > +		cp->Header.SGList = 0;
> > +		cp->Header.SGTotal = 0;
> > +		return;
> > +	}
> >  	cp->SG[0].Addr.lower =
> >  	  (u32) (addr64 & (u64) 0x00000000FFFFFFFF);
> >  	cp->SG[0].Addr.upper =
> 
> Probably should bubble that error up through hpsa_map_one return value
> (currently void, but I guess that needs to change) and that's called from
> one place, fill_cmd(), also currently returning void (needs to change).
> I think all the places that call fill_cmd() have failure paths that
> can be used.
> 
> There are a couple other places in hpsa that we call pci_map_single and do
> not subsequently call dma_mapping_error().
> 
> I don't thinking just setting SGList = 0 and SGTotal = 0 is going to 
> do something good (I expect it will end up causing the cnotroller to 
> reject the command as invalid -- and pretty much all the commands that
> go through this path are driver generated commands, so, if the driver
> is generating invalid commands, that would be a bug.
> 
> So, I don't think this patch is quite correct as is.
> 

I wasn't very sure if this patch is the right way to address the
error :)

> But, thanks for bringing this failure to call dma_mapping_error to my
> attention.
> 
> So what cmdline options or config options did you enable to get this check?
> 
> was it something like:
> 
> dma_debug=1 dma_debug_entries=???

Build Linux 3.8 (any rc will do, I tested with Linux 3.8-rc7) with
CONFIG_DMA_API_DEBUG enabled.

CONFIG_DMA_API_DEBUG=y


btw once I had this patch in, I saw another error

[   18.795456] ------------[ cut here ]------------
[   18.795582] WARNING: at lib/dma-debug.c:933 check_unmap+0x459/0x8a0()
[   18.795661] Hardware name: ProLiant DL385p Gen8
[   18.795723] hpsa 0000:03:00.0: DMA-API: device driver failed to check
map error[device address=0x0000000000733000] [size=32 bytes] [mapped as
single]
[   18.795798] Modules linked in: pata_atiixp tg3 ptp pps_core hpsa
[   18.796167] Pid: 0, comm: swapper/3 Not tainted 3.8.0-rc7+ #8
[   18.796230] Call Trace:
[   18.796288]  <IRQ>  [<ffffffff810581ef>] warn_slowpath_common
+0x7f/0xc0
[   18.796466]  [<ffffffff810582e6>] warn_slowpath_fmt+0x46/0x50
[   18.796531]  [<ffffffff8134c129>] check_unmap+0x459/0x8a0
[   18.796596]  [<ffffffff8156fc46>] ? dma_ops_free_addresses+0x46/0x50
[   18.796661]  [<ffffffff8134c70c>] debug_dma_unmap_page+0x5c/0x60
[   18.796727]  [<ffffffffa00017f0>] complete_scsi_command+0xe0/0x500
[hpsa]
[   18.796793]  [<ffffffffa0003a8e>] do_hpsa_intr_msi+0x12e/0x270 [hpsa]
[   18.796860]  [<ffffffff810e9695>] handle_irq_event_percpu+0x55/0x210
[   18.796925]  [<ffffffff810e989e>] handle_irq_event+0x4e/0x80
[   18.796989]  [<ffffffff810ec2f4>] handle_edge_irq+0x84/0x130
[   18.797053]  [<ffffffff81016202>] handle_irq+0x22/0x40
[   18.797117]  [<ffffffff816a592a>] do_IRQ+0x5a/0xe0
[   18.797180]  [<ffffffff8169b92d>] common_interrupt+0x6d/0x6d
[   18.797243]  <EOI>  [<ffffffff8101b959>] ? sched_clock+0x9/0x10
[   18.797393]  [<ffffffff81556b20>] ? cpuidle_wrap_enter+0x50/0xa0
[   18.797458]  [<ffffffff81556b19>] ? cpuidle_wrap_enter+0x49/0xa0
[   18.797523]  [<ffffffff81556b80>] cpuidle_enter_tk+0x10/0x20
[   18.797613]  [<ffffffff8155673f>] cpuidle_idle_call+0xaf/0x2b0
[   18.797677]  [<ffffffff8101d4df>] cpu_idle+0xcf/0x120
[   18.797740]  [<ffffffff81686e42>] start_secondary+0x1fa/0x201
[   18.797804] ---[ end trace 56a89d480f09df70 ]---
[   18.797865] Mapped at:
[   18.797923]  [<ffffffff8134b189>] debug_dma_map_page+0xb9/0x160
[   18.798028]  [<ffffffffa00025fe>] hpsa_scsi_queue_command+0x45e/0x4b0
[hpsa]
[   18.799127]  [<ffffffff81467ac6>] scsi_dispatch_cmd+0x136/0x2f0
[   18.799233]  [<ffffffff8146ecd2>] scsi_request_fn+0x382/0x550
[   18.799339]  [<ffffffff81306d07>] __blk_run_queue+0x37/0x50


I can help with testing fixes to these problems.

-- Shuah
