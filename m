From: James Smart <James.Smart@Emulex.Com>
Subject: Re: NPIV mapping problems (was Re: [PATCH 1/19] add data buffer accessors)
Date: Mon, 09 Jul 2007 15:20:34 -0400
Message-ID: <46928A82.8090900@emulex.com>
References: <1178980728.3723.8.camel@mulgrave.il.steeleye.com>	<20070629132332.GB2648@plap.qlogic.org>	<20070704172536N.fujita.tomonori@lab.ntt.co.jp> <20070702215658V.fujita.tomonori@acm.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:32983 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbXGITVP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 15:21:15 -0400
In-Reply-To: <20070702215658V.fujita.tomonori@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: andrew.vasquez@qlogic.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, hch@infradead.org, seokmann.ju@qlogic.com, fujita.tomonori@lab.ntt.co.jp

ACK - looks fine..

Thanks

-- james s

FUJITA Tomonori wrote:
> I forgot to CC James Smart and send a lpfc patch.
> 
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: Re: NPIV mapping problems (was Re: [PATCH 1/19] add data buffer accessors)
> Date: Wed, 04 Jul 2007 17:25:36 +0900
> 
>> Sorry for the delay...
>>
>> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
>> Subject: NPIV mapping problems (was Re: [PATCH 1/19] add data buffer accessors)
>> Date: Fri, 29 Jun 2007 06:23:32 -0700
>>
>>> On Sat, 12 May 2007, James Bottomley wrote:
>>>
>>>> On Sat, 2007-05-12 at 19:05 +0900, FUJITA Tomonori wrote:
>>>>> Add a set of accessors for the scsi data buffer. This is in
>>>>> preparation for chaining sg lists and bidirectional requests (and
>>>>> possibly, the mid-layer dma mapping).
>>>>>
>>>>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>>>> ---
>>>>>  drivers/scsi/scsi_lib.c  |   26 ++++++++++++++++++++++++++
>>>>>  include/scsi/scsi_cmnd.h |   11 +++++++++++
>>>>>  2 files changed, 37 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>>> index 1f5a07b..a2ebe61 100644
>>>>> --- a/drivers/scsi/scsi_lib.c
>>>>> +++ b/drivers/scsi/scsi_lib.c
>>>>> @@ -2290,3 +2290,29 @@ void scsi_kunmap_atomic_sg(void *virt)
>>>>>  	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
>>>>>  }
>>>>>  EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
>>>>> +
>>>>> +int scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd)
>>>> Actually, this is redundant.  We make sure the
>>>> shost->shost_gendev.parent is the device which should have been passed
>>>> in to scsi_add_host().
>>> Well, there's perhaps an unintended side-effect with this assumption,
>>> NPIV-based 'vports' (and their subsequent 'struct device' members) are
>>> not fully initialized objects.
>>>
>>> This is what we've run into while working on our NPIV (based) driver
>>> with the 'data buffer' accessors works, while queueing the first
>>> command to an sdev of a freshly created vport:
>>>
>>> 	[  366.860758] Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
>>> 	[  366.860762]  [<ffffffff8020fdf6>] check_addr+0x10/0x4a
>>> 	[  366.860778] PGD 0 
>>> 	[  366.860782] Oops: 0000 [1] SMP 
>>> 	[  366.860787] CPU 0 
>>> 	[  366.860790] Modules linked in: qla2xxx scsi_transport_fc
>>> 	[  366.860798] Pid: 5757, comm: scsi_wq_2 Not tainted 2.6.22-rc6 #4
>>> 	[  366.860802] RIP: 0010:[<ffffffff8020fdf6>]  [<ffffffff8020fdf6>] check_addr+0x10/0x4a
>>> 	[  366.860812] RSP: 0018:ffff810073979960  EFLAGS: 00010082
>>> 	[  366.860816] RAX: 0000000000000000 RBX: ffff810037cda070 RCX: 0000000000000024
>>> 	[  366.860821] RDX: 000000007cd86188 RSI: ffff81007d800ef8 RDI: ffffffff804c30e1
>>> 	[  366.860824] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>>> 	[  366.860828] R10: 00000000ffffffff R11: 0000000000000006 R12: 0000000000000001
>>> 	[  366.860834] R13: ffff81007d800ef8 R14: ffff810075f9fda0 R15: ffff810076d66af8
>>> 	[  366.860839] FS:  0000000000000000(0000) GS:ffffffff80570000(0000) knlGS:0000000000000000
>>> 	[  366.860844] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>>> 	[  366.860847] CR2: 0000000000000000 CR3: 000000007ec6b000 CR4: 00000000000006e0
>>> 	[  366.860853] Process scsi_wq_2 (pid: 5757, threadinfo ffff810073978000, task ffff810037c6ce00)
>>> 	[  366.860856] Stack:  0000000000011220 ffffffff8020fea6 0000000000000246 00000000000000e1
>>> 	[  366.860866]  00000000000000e1 ffff810076908608 ffff810076d66af8 ffffffff803a440c
>>> 	[  366.860876]  ffff810076908608 ffffffff8801cdd2 ffff810076908688 ffff810073979a18
>>> 	[  366.860885] Call Trace:
>>> 	[  366.860891]  [<ffffffff8020fea6>] nommu_map_sg+0x76/0x8f
>>> 	[  366.860900]  [<ffffffff803a440c>] scsi_dma_map+0x45/0x5c
>>> 	[  366.860922]  [<ffffffff8801cdd2>] :qla2xxx:qla24xx_start_scsi+0x118/0x4fb
>>> 	[  366.860928]  [<ffffffff8039fa74>] scsi_done+0x0/0x18
>>> 	[  366.860942]  [<ffffffff880116f0>] :qla2xxx:qla24xx_queuecommand+0x148/0x17a
>>> 	[  366.860948]  [<ffffffff803a01f7>] scsi_dispatch_cmd+0x1f6/0x313
>>> 	[  366.860953]  [<ffffffff803a622b>] scsi_request_fn+0x1d7/0x3b8
>>>
>>> the failure point is this check (line 16) in check_addr():
>>>
>>> 	(gdb) l* check_addr+0x10
>>> 	0xffffffff8020fdf6 is in check_addr (arch/x86_64/kernel/pci-nommu.c:16).
>>> 	11      #include <asm/dma.h>
>>> 	12
>>> 	13      static int
>>> 	14      check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
>>> 	15      {
>>> 	16              if (hwdev && bus + size > *hwdev->dma_mask) {
>>> 	17                      if (*hwdev->dma_mask >= DMA_32BIT_MASK)
>>> 	18                              printk(KERN_ERR
>>> 	19                                  "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
>>> 	20                                      name, (long long)bus, size,
>>>
>>> hwdev->dma_mask (an 'u64 *') is NULL, as a corresponding 'set'
>>> function is never getting called via pci_set_dma_mask() and
>>> pci_set_consistent_dma_mask() on a vport.
>> Yeah, I use lpfc's NPIV but haven't hit this because I use swiotlb...
>>
>>
>>> I don't believe we'd want to:
>>>
>>> 1) have each LLD cache the physical-port's previously determined
>>>    dma-mask, and call pci_set_[consistent_]dma_mask() for each
>>>    instantiated vport.
>>>
>>>    the problem with this approach is 'knowing' how much data needs to
>>>    be propagated to a vport's underlying 'struct device'.
>>>
>>> 2) pass the physical-port's 'scsi_host' structure during a vport's
>>>    scsi_add_host() call:
>>>
>>> 	if (scsi_add_host(vha->host, &fc_vport->dev)) {
>>>
>>>    as that would lead to some device-model ugliness...
>> Yeah, we shouldn't do this...
>>
>>
>>> Abstractions such as these 'data-accessor functions' which don't allow
>>> a LLD the opprotunity to be more selective on the
>>> 'physical-characteristics' of a 'virtual' device are going to lead to
>>> more subtle bugs going forward.
>>>
>>> One possiblity (the least intrusive) would be to add a
>>> scsi_dma_map_with_device() function which takes the proper (LLD
>>> defined) 'struct device' as a parameter, as was originally proposed,
>>> and have NPIV-aware drivers call that function during the mappings of
>>> physical *and* virtual dma-mappings.
>> It's ok. But if only NPIV-aware drivers need to handle this, would it
>> be better to just use dma_map_sg instead of scsi_dma_map?
> 
> ---
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> This patch uses dma_map_sg with phba->pcidev->dev instead of
> scsi_dma_map.
> 
> scsi_dma_map doesn't work for NPIV since fc_vport->dev isn't fully
> initialized. check_addr() in arch/x86_64/kernel/pci-nommu.c leads to
> the crash since dev->dma_mask is NULL.
> 
> For more details:
> 
> http://marc.info/?l=linux-scsi&m=118312448030633&w=2
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 5d2e3de..94c5f0c 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -332,8 +332,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
>  	 * data bde entry.
>  	 */
>  	bpl += 2;
> -	nseg = scsi_dma_map(scsi_cmnd);
> -	if (nseg > 0) {
> +	if (scsi_sg_count(scsi_cmnd)) {
>  		/*
>  		 * The driver stores the segment count returned from pci_map_sg
>  		 * because this a count of dma-mappings used to map the use_sg
> @@ -341,6 +340,11 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
>  		 * architectures that implement an IOMMU.
>  		 */
>  
> +		nseg = dma_map_sg(&phba->pcidev->dev, scsi_sglist(scsi_cmnd),
> +				  scsi_sg_count(scsi_cmnd), datadir);
> +		if (unlikely(!nseg))
> +			return 1;
> +
>  		lpfc_cmd->seg_cnt = nseg;
>  		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
>  			printk(KERN_ERR "%s: Too many sg segments from "
> @@ -370,8 +374,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
>  			bpl++;
>  			num_bde++;
>  		}
> -	} else if (nseg < 0)
> -		return 1;
> +	}
>  
>  	/*
>  	 * Finish initializing those IOCB fields that are dependent on the
