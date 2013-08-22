From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH] [SCSI] mpt3sas: Added a driver module parameter
 max_msix_vectors
Date: Thu, 22 Aug 2013 19:15:59 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA723006D288F3@inbmail02.lsi.com>
References: <20130814125320.GA3402@lsi.com>	<520B9F99.1000003@redhat.com>
	<DCD177647606E9419ED923E0C8C4AA723006D280C2@inbmail02.lsi.com>
 <20130815095305.71570ba7@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:26369
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab3HVNqK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Aug 2013 09:46:10 -0400
In-Reply-To: <20130815095305.71570ba7@jlaw-desktop.mno.stratus.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Tomas Henzl <thenzl@redhat.com>, "jejb@kernel.org" <jejb@kernel.org>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>

Hi Joe,

Replied inline..

Regards,
Sreekanth

>-----Original Message-----
>From: Joe Lawrence [mailto:joe.lawrence@stratus.com]
>Sent: Thursday, August 15, 2013 7:23 PM
>To: Reddy, Sreekanth
>Cc: Tomas Henzl; jejb@kernel.org; JBottomley@Parallels.com; linux-
>scsi@vger.kernel.org; Nandigama, Nagalakshmi
>Subject: Re: [PATCH] [SCSI] mpt3sas: Added a driver module parameter
>max_msix_vectors
>
>Hi Sreekanth,
>
>Will there be a follow up patch to fix the crash scenario?

yes there will be a follow up patch to the issue.  we are already in process of implementing a new design with will overcome this issue.

>  Is there some error
>path in _base_allocate_memory_pools that isn't handled gracefully that
>needs to be cleaned up?

The crash happens when the kernel couldn't allocate the DMA'able memory that the driver requests for. The amount of memory allocated is directly proportional to the HBA queue depth and the no of MSI-X vectors.
Here is call trace

Feb 20 09:13:54 linux kernel: [  136.875370] mpt3sas0: iomem(0x00000000df3f0000), mapped(0xffffc900178c0000), size(65536)
Feb 20 09:13:54 linux kernel: [  136.875374] mpt3sas0: ioport(0x000000000000dc00), size(256)
Feb 20 09:13:54 linux kernel: [  137.161326] mpt3sas0: sending message unit reset !!
Feb 20 09:13:54 linux kernel: [  137.217104] mpt3sas0: message unit reset: SUCCESS
Feb 20 09:13:54 linux kernel: [  137.404763] ------------[ cut here ]------------
Feb 20 09:13:54 linux kernel: [  137.404779] WARNING: at /usr/src/packages/BUILD/kernel-default-2.6.32.12/linux-2.6.32/mm/page_alloc.c:1864 __alloc_pages_slowpath+0x4c9/0x550()
Feb 20 09:13:54 linux kernel: [  137.404784] Hardware name: PowerEdge T610
Feb 20 09:13:54 linux kernel: [  137.404785] Modules linked in: mpt3sas(N+) raid_class scsi_transport_sas ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit af_packet microcode ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables ipv6 fuse loop dm_mod rtc_cmos iTCO_wdt tpm_tis rtc_core sr_mod tpm iTCO_vendor_support e1000e bnx2 rtc_lib dcdbas(X) sg cdrom tpm_bios pcspkr serio_raw power_meter button usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore edd ext3 mbcache jbd fan processor ide_pci_generic ide_core ata_generic ata_piix libata scsi_mod thermal thermal_sys hwmon
Feb 20 09:13:54 linux kernel: [  137.404837] Supported: Yes
Feb 20 09:13:54 linux kernel: [  137.404840] Pid: 5770, comm: insmod Tainted: G          NX 2.6.32.12-0.7-default #1
Feb 20 09:13:54 linux kernel: [  137.404843] Call Trace:
Feb 20 09:13:54 linux kernel: [  137.404857]  [<ffffffff810061dc>] dump_trace+0x6c/0x2d0
Feb 20 09:13:54 linux kernel: [  137.404867]  [<ffffffff81394288>] dump_stack+0x69/0x71
Feb 20 09:13:54 linux kernel: [  137.404875]  [<ffffffff8104caf4>] warn_slowpath_common+0x74/0xd0
Feb 20 09:13:54 linux kernel: [  137.404881]  [<ffffffff810bab59>] __alloc_pages_slowpath+0x4c9/0x550
Feb 20 09:13:54 linux kernel: [  137.404887]  [<ffffffff810bad1a>] __alloc_pages_nodemask+0x13a/0x140
Feb 20 09:13:54 linux kernel: [  137.404893]  [<ffffffff81008686>] dma_generic_alloc_coherent+0xa6/0x160
Feb 20 09:13:54 linux kernel: [  137.404900]  [<ffffffff81024358>] x86_swiotlb_alloc_coherent+0x28/0x80
Feb 20 09:13:54 linux kernel: [  137.404908]  [<ffffffff810e2428>] pool_alloc_page+0xb8/0x190
Feb 20 09:13:54 linux kernel: [  137.404913]  [<ffffffff810e2565>] dma_pool_alloc+0x65/0x160
Feb 20 09:13:54 linux kernel: [  137.404927]  [<ffffffffa037ca4b>] mpt3sas_base_attach+0xb0b/0x16b0 [mpt3sas]
Feb 20 09:13:54 linux kernel: [  137.404951]  [<ffffffffa038317e>] _scsih_probe+0x3be/0x700 [mpt3sas]
Feb 20 09:13:54 linux kernel: [  137.404966]  [<ffffffff811f92d2>] local_pci_probe+0x12/0x20
Feb 20 09:13:54 linux kernel: [  137.404972]  [<ffffffff811f9580>] __pci_device_probe+0xe0/0xf0
Feb 20 09:13:54 linux kernel: [  137.404977]  [<ffffffff811fa493>] pci_device_probe+0x33/0x60
Feb 20 09:13:54 linux kernel: [  137.404983]  [<ffffffff812948f7>] really_probe+0x77/0x230
Feb 20 09:13:54 linux kernel: [  137.404988]  [<ffffffff81294b1a>] driver_probe_device+0x6a/0xc0
Feb 20 09:13:54 linux kernel: [  137.404993]  [<ffffffff81294c03>] __driver_attach+0x93/0xa0
Feb 20 09:13:54 linux kernel: [  137.404997]  [<ffffffff81293f78>] bus_for_each_dev+0x58/0x80
Feb 20 09:13:54 linux kernel: [  137.405002]  [<ffffffff81293765>] bus_add_driver+0x155/0x2b0
Feb 20 09:13:54 linux kernel: [  137.405007]  [<ffffffff81294f19>] driver_register+0x79/0x170
Feb 20 09:13:54 linux kernel: [  137.405012]  [<ffffffff811fa728>] __pci_register_driver+0x58/0xe0
Feb 20 09:13:54 linux kernel: [  137.405023]  [<ffffffffa0304184>] _scsih_init+0x184/0x1b9 [mpt3sas]
Feb 20 09:13:54 linux kernel: [  137.405037]  [<ffffffff810001e5>] do_one_initcall+0x35/0x190
Feb 20 09:13:54 linux kernel: [  137.405045]  [<ffffffff8107cfd4>] sys_init_module+0xe4/0x270
Feb 20 09:13:54 linux kernel: [  137.405051]  [<ffffffff81002f7b>] system_call_fastpath+0x16/0x1b


>
>Also, I think fixes in this space could apply to the mpt2sas driver as well.

 LSI SAS3 controller supports maximum of 96 msix-vectors whereas LSI SAS2 controller supports maximum of 16 msix vectors. So there is no need of this patch for mpt2sas drivers as kernel will able to allocate the required DMA able memory.  And we will directly post the new design implementation's patch to the upstream for mpt2sas driver also.  

>
>Regards,
>
>-- Joe
>
>
>On Wed, 14 Aug 2013 21:08:05 +0530
>"Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com> wrote:
>
>> Hi Tomas,
>>
>> The crash happens when the kernel couldn't allocate the DMA'able memory
>that the driver requests for Reply Descriptor post queue. The amount of
>memory allocated is directly proportional to the HBA queue depth and the
>number of MSI-X vectors.
>>
>> The indirect fix for this issue is to add a module parameter
>max_msix_vectors to the driver. Using this module parameter the max
>number of MSI-X vectors could be set. The amount of memory that is
>allocated could be decreased by reducing the number of MSI-X vectors.
>Therefore if a crash is seen on a system due to the memory allocation failure,
>then max_queue_depth and the max_msix_vectors could be set to a lower
>value during driver load time so that the memory requested by the driver is
>less and thereby preventing the kernel crash.
>>
>> So, lower  the value of this variable 'max_msix_vectors' only if  kernel
>couldn't allocate the DMA'able memory that the driver requests for and crash
>is observed.
>>
>> Regards,
>> Sreekanth
>>
>> >-----Original Message-----
>> >From: Tomas Henzl [mailto:thenzl@redhat.com]
>> >Sent: Wednesday, August 14, 2013 8:48 PM
>> >To: Reddy, Sreekanth
>> >Cc: jejb@kernel.org; JBottomley@Parallels.com;
>> >linux-scsi@vger.kernel.org; Nandigama, Nagalakshmi
>> >Subject: Re: [PATCH] [SCSI] mpt3sas: Added a driver module parameter
>> >max_msix_vectors
>> >
>> >On 08/14/2013 02:53 PM, Sreekanth Reddy wrote:
>> >> Added a driver module parameter max_msix_vectors. Using this module
>> >> parameter the maximum number of MSI-X vectors could be set.
>> >>
>> >> The number of MSI-X vectors used would be the minimum of MSI-X
>> >> vectors supported by the HBA, the number of CPU cores and the value
>> >> set to
>> >max_msix_vectors module parameter.
>> >>
>> >> The default value of this module parameter is set to 8. The default
>> >> value of this parameter is set to 8 inorder to reduce the amount of
>> >> memory
>> >required for Reply Descriptor Post queue.
>> >> This is because with the higher MSI-X vectors, some times kernel is
>> >> not able to allocate the requested amount of memory and crash is
>> >> observed. To overcome this problem, the default value is set to 8.
>> >
>> >Hi Sreekanth,
>> >I don't know exactly which allocation fails, but wouldn't be for the
>> >user better to just try to allocate and only when it fails lower the msi-x
>vectors count?
>> >Tomas
>> >
>> >>
>> >> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
>> >> ---
>> >>
>> >> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> >> b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> >> index a32d63b..d40ba0b 100644
>> >> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> >> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> >> @@ -82,6 +82,10 @@ static int msix_disable = -1;
>> >> module_param(msix_disable, int, 0);
>MODULE_PARM_DESC(msix_disable,
>> >"
>> >> disable msix routed interrupts (default=0)");
>> >>
>> >> +static int max_msix_vectors = 8;
>> >> +module_param(max_msix_vectors, int, 0);
>> >> +MODULE_PARM_DESC(max_msix_vectors,
>> >> +	" max msix vectors - (default=8)");
>> >>
>> >>  static int mpt3sas_fwfault_debug;
>> >>  MODULE_PARM_DESC(mpt3sas_fwfault_debug,
>> >> @@ -1723,6 +1727,16 @@ _base_enable_msix(struct
>MPT3SAS_ADAPTER
>> >*ioc)
>> >>  	ioc->reply_queue_count = min_t(int, ioc->cpu_count,
>> >>  	    ioc->msix_vector_count);
>> >>
>> >> +	printk(MPT3SAS_FMT "MSI-X vectors supported: %d, no of cores"
>> >> +	  ": %d, max_msix_vectors: %d\n", ioc->name, ioc-
>> >>msix_vector_count,
>> >> +	  ioc->cpu_count, max_msix_vectors);
>> >> +
>> >> +	if (max_msix_vectors > 0) {
>> >> +		ioc->reply_queue_count = min_t(int, max_msix_vectors,
>> >> +			ioc->reply_queue_count);
>> >> +		ioc->msix_vector_count = ioc->reply_queue_count;
>> >> +	}
>> >> +
>> >>  	entries = kcalloc(ioc->reply_queue_count, sizeof(struct msix_entry),
>> >>  	    GFP_KERNEL);
>> >>  	if (!entries) {
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> >> in the body of a message to majordomo@vger.kernel.org More
>> >> majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
>


