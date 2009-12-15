From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] Fix double free of MPT request frames.
Date: Tue, 15 Dec 2009 10:21:24 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93CDEC07@inbmail01.lsi.com>
References: <alpine.DEB.1.00.0912101533380.28374@darius>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:47145 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756279AbZLOEvh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2009 23:51:37 -0500
In-Reply-To: <alpine.DEB.1.00.0912101533380.28374@darius>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darius S. Naqvi" <dnaqvi@datagardens.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Naqvi,

If you are seeing problem in upgrading whole kernel, I would rather suggest move mptfusion driver to latest and keep you base kernel 2.6.24-24-generic.

For this you may need to modify mpt fusion little bit to make driver compliable. 

Double free issue was present in older mptfusion driver and as you have observed latest mptfusion driver has changed a lot from there.
Now, with latest mptfusion driver this double free MPT frame issue is not present.

- Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Darius S. Naqvi
> Sent: Friday, December 11, 2009 4:06 AM
> To: linux-scsi@vger.kernel.org
> Subject: RE: [PATCH] Fix double free of MPT request frames.
> 
> Hi,
> 
> On May 26, 2009 at 12:25 pm, Alok Kataria wrote:
> 
> > While testing scsi path failover for disks using MPT drivers we hit a
> > kernel oops on RHEL 5.1-64bit, while analyzing the problem we noticed
> > that this is due to a race present in the mpt scsi code path. The same
> > race seems to be present in the latest git kernel code too.
> >
> 
> I'm sorry to be bringing up something from months ago, but I do have
> some questions about this.  I believe I might be seeing the same
> problem.  We're running Ubuntu 8.04.3 LTS (linux kernel
> 2.6.24-24-generic), and the code is quite similar to your patch, to
> the point that the patch applies smoothly except for a couple of
> hunks in comments.  So I have a couple of questions:
> 
> 1) What was the kernel oops like?  In particular, was it like the one
>     I saw?  (I'll add details of the kernel oops later in this email).
> 
> 2) Has this patch or anything like it been accepted into the kernel?
>     I have my doubts, as Kashyap Desai had this to say about it on May
>     29, 2009 at 10:55pm (text re-formatted to break up long lines):
> 
> > Consider below two points as potential bug in your patch.
> >
> > #1. As per MPT Fusion design, driver should not free message frame
> >  which is still with FW. We should make sure that FW will not use
> >  submitted message frame in future before freeing it. There are
> >  multiple way to make sure FW will not use msg frame.
> >  a. Successful return in ISR for msg frame.
> >  b. HardReset
> >  c. Task Abort (success case)
> >
> > Potential bug in your patch is you are freeing msg frame before
> HardReset.
> > There is still possibility that FW will use that freed message
> > frame. It can fault IOC or may be IOC hangs.
> >
> > #2. Making TmState to NONE much before completing cleanup work for
> >  previously faild TM.  In general, TmState = TM_STATE_NONE should be
> >  just before you return from mptscsih_tm_wait_for_completion()
> >  failure case.
> >
> 
> 3) Is this fixed in the latest kernel (currently 2.6.32)?  The code
>     has changed quite a bit, so it isn't obvious that the problem still
>     exists, nor is it obvious that it has been fixed.
> 
> Unfortunately, it isn't easy for me to upgrade to the latest kernel,
> as we want to settle on a long-term supportable Unbuntu release for
> our deployments, so we use 8.04.3 LTS, for which the newest kernel so
> far is 2.6.24-26-generic.
> 
> Here are the details of my kernel oops, as I promised in #1 above:
> 
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4267.933351] mptscsih: ioc0: Issue
> of TaskMgmt failed!
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4267.933361] mptscsih: ioc0: task
> abort:FAILED (sc=f6b44a00)
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4267.933373] mptscsih: ioc0:
> attempting target reset! (sc=f6b44a00)
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4267.933377] sd 2:0:1:0: [sdb] CDB:
> Read(10): 28 00 01 20 aa c4 00 00 04 00
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4267.933431]  target2:0:0:
> Beginning Domain Validation
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.044445] mptscsih: ioc0: target
> reset: SUCCESS (sc=f6b44a00)
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.044804]  target2:0:0: Domain
> Validation Initial Inquiry Failed
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.044874]  target2:0:0: Ending
> DomainValidation
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.045001] BUG: unable to handle
> kernel NULL pointer dereference at virtual address 00000005
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.045128] printing eip: f89235fa
> *pde= 00000000
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.045299] Oops: 0002 [#1] SMP
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.045413] Modules linked in:
> iscsi_trgt crc32c libcrc32c vmmemctl cpufreq_powersave cpufreq_userspace
> cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table video
> output battery sbs sbshc dock iptable_filter ip_tables x_tables iscsi_tcp
> libiscsi scsi_transport_iscsi lploop ipv6 container evdev serio_raw ac
> button intel_agp parport_pc parport i2c_piix4 agpgart shpchp pci_hotplug
> i2c_core psmouse pcspkr ext3 jbd mbcache sd_modsg sr_mod cdrom ata_generic
> floppy pcnet32 mii mptspi mptscsih mptbase scsi_transport_spi ata_piix
> pata_acpi libata scsi_mod raid10 raid456 async_xor async_memcpy async_tx
> xor raid1 raid0 multipath linear md_mod dm_mirror dm_snapshot dm_mod
> thermal processor fan fbcon tileblit font bitblit softcursor fuse vmxnet
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.046097]
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.046177] Pid: 6, comm: events/0
> Not tainted (2.6.24-24-generic #1)
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.046237] EIP: 0060:[<f89235fa>]
> EFLAGS: 00010097 CPU: 0
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.046480] EIP is at
> mpt_get_msg_frame+0x6a/0x100 [mptbase]
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.046541] EAX: 0000400a EBX:
> f7fc5000ECX: df8c49c0 EDX: 00000001
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.046599] ESI: df8c49c0 EDI:
> 0000000fEBP: f7fc5104 ESP: f7c2bde8
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.046656]  DS: 007b ES: 007b FS:
> 00d8GS: 0000 SS: 0068
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.046723] Process events/0 (pid:
> 6, ti=f7c2a000 task=f7c28000 task.ti=f7c2a000)
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.046788] Stack: 00000000
> c01731e0 00000044 f7c2be6c 0000000a 0f000082 00000202 f7fc5000
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.046922]        f7ea6c14
> f7c2bec4 f7fc5000 f8926c5d 00000001 c03ef590 000000d0 0000000c
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047015]        00000000
> 0000000c f7c8444c 00000000 c0109173 00000000 f7c2bf24 f7c8444c
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047111] Call Trace:
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047269]  [<c01731e0>]
> __alloc_pages+0x60/0x3a0
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047453]  [<f8926c5d>]
> mpt_config+0x2d/0x2f0 [mptbase]
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047510]  [<c0109173>]
> dma_alloc_coherent+0xc3/0x110
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047567]  [<f88df86f>]
> mptspi_read_parameters+0x12f/0x3f0 [mptspi]
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047636]  [<f88e016f>]
> mptspi_dv_device+0x6f/0x170 [mptspi]
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047688]  [<c028063e>]
> get_device+0xe/0x20
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047744]  [<f893a13e>]
> scsi_device_get+0x1e/0x50 [scsi_mod]
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047814]  [<f893a298>]
> __scsi_iterate_devices+0x48/0x70 [scsi_mod]
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047879]  [<f88e0319>]
> mptspi_dv_renegotiate_work+0xa9/0xd0 [mptspi]
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047935]  [<c0179750>]
> vmstat_update+0x0/0x30
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.047988]  [<f88e0270>]
> mptspi_dv_renegotiate_work+0x0/0xd0 [mptspi]
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048043]  [<c013cecf>]
> run_workqueue+0xbf/0x160
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048094]  [<c013d970>]
> worker_thread+0x0/0xe0
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048141]  [<c013d9f4>]
> worker_thread+0x84/0xe0
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048188]  [<c0140c80>]
> autoremove_wake_function+0x0/0x40
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048240]  [<c013d970>]
> worker_thread+0x0/0xe0
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048287]  [<c01409c2>]
> kthread+0x42/0x70
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048331]  [<c0140980>]
> kthread+0x0/0x70
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048375]  [<c0105667>]
> kernel_thread_helper+0x7/0x10
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048479]
> =======================
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048536] Code: 00 8d ab 04 01
> 00 00 89 e8 e8 d3 9e 9f c7 8b 93 08 01 00 00 89 44 24 18 8d 83 08 01 00 00
> 39 c2 74 5489 d6 8b 12 8b 46 04 89 f1 <89> 42 04 89 10 89 f8 c7 46 08 00
> 00 00 00 c7 06 0001 10 00 88
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.048824] EIP: [<f89235fa>]
> mpt_get_msg_frame+0x6a/0x100 [mptbase] SS:ESP 0068:f7c2bde8
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.049231] ---[ end trace
> 4cf91050ea603706 ]---
> 
> I used objdump and matched up its output to the oops, and I concluded the
> oops occured at 5fa below:
> 
> /home/darius/ubuntu_src/linux-2.6.24/include/linux/list.h:157
>   * This is only for internal list manipulation where we know
>   * the prev/next entries already!
>   */
> static inline void __list_del(struct list_head * prev, struct list_head *
> next)
> {
>          next->prev = prev;
>       5fa:       89 42 04                mov    %eax,0x4(%edx)
> /home/darius/ubuntu_src/linux-2.6.24/include/linux/list.h:158
>          prev->next = next;
>       5fd:       89 10                   mov    %edx,(%eax)
> 
> The oops reports that EDX is 0x1, which means 5fa is trying to write
> to the address 0x5, which fits with this line in the oops:
> 
> Dec  8 13:29:29 syntropy-pcc kernel: [ 4268.045001] BUG: unable to handle
> kernel NULL pointer dereference at virtual address 00000005
> 
> In short, a next pointer in the message frame has a ridiculous value,
> which could be caused by using a message frame that has already been
> freed.
> 
> --
> Darius S. Naqvi
> dnaqvi@datagardens.com
> http://www.datagardens.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
