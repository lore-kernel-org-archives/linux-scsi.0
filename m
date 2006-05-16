From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [RFC] Megaraid update, submission
Date: Tue, 16 May 2006 15:08:13 -0600
Message-ID: <890BF3111FB9484E9526987D912B261901BD85@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34793 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750826AbWEPVJA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 17:09:00 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, "Mukker, Atul" <Atul.Mukker@engenio.com>

Hi Andre,
Tuesday, May 16, 2006 4:47 PM, Andre Hedrick wrote:
> Lets move on to the list management issues where timeouts on 
> ioctl calls
> have produced NULL pointers when one performs an add v/s move 
> to transfer
> ownership of a given scb between pools.
> 
> Fixing the list management may mean the pci_master_abort is 
> not needed.
If this issue still exist on 2.6.17-rcl kernel, I would definitely work on it.
>From my best estimate, the _NULL pointer_ issue should not be there with the patch.
Please let me know if you still see the issue.

I thank you very much your contribution on the driver stability.

Regards, 

> -----Original Message-----
> From: Andre Hedrick [mailto:andre@linux-ide.org] 
> Sent: Tuesday, May 16, 2006 4:47 PM
> To: Ju, Seokmann
> Cc: linux-scsi@vger.kernel.org; Andrew Morton; James 
> Bottomley; Christoph Hellwig; Mukker, Atul
> Subject: RE: [RFC] Megaraid update, submission
> 
> 
> Warning OOPS in message, ignore if you hate reading pasted OOPS's
> 
> Seokmann,
> 
> So there should be no (sane) heroic attempts to recover the 
> card state?
> Please look and see the path is only retried and follows the original
> operational path which resulted in setting the 
> 'raid_dev->hw_error' flag.
> If I am reading the code correctly, the *->quiescent flag 
> controls command
> submission to the card.  Thus all commands submitted to the 
> firmware are
> owned by the card, and should be allowed to complete the IO's 
> regardless?
> With as many as 20 requests outstanding (max I have seen to date) and
> termiation of the transactions surely blows apart any filesystem, as I
> have had filesystems and in several cases attached arrays 
> just vaporize if
> forced to reboot when 'hw_error' is set.
> 
> So since the pci_master_abort for the card is being rejected ...
> 
> Lets move on to the list management issues where timeouts on 
> ioctl calls
> have produced NULL pointers when one performs an add v/s move 
> to transfer
> ownership of a given scb between pools.
> 
> Fixing the list management may mean the pci_master_abort is 
> not needed.
> 
> The NULL pointer:
> 
> Mar 29 00:09:53 5000 kernel: megaraid: aborting-464723 cmd=2a 
> <c=1 t=0 l=0>
> Mar 29 00:09:53 5000 kernel: megaraid abort: 
> 464723:40[255:0], fw owner
> Mar 29 00:09:53 5000 kernel: megaraid: aborting-464744 cmd=2a 
> <c=1 t=0 l=0>
> Mar 29 00:09:53 5000 kernel: megaraid abort: 
> 464744:12[255:0], fw owner
> Mar 29 00:09:53 5000 kernel: megaraid: aborting-464745 cmd=2a 
> <c=1 t=0 l=0>
> Mar 29 00:09:53 5000 kernel: megaraid abort: 
> 464745:23[255:0], fw owner
> Mar 29 00:09:53 5000 kernel: megaraid: aborting-464746 cmd=2a 
> <c=1 t=0 l=0>
> Mar 29 00:09:53 5000 kernel: megaraid abort: 464746:0[255:0], fw owner
> Mar 29 00:09:53 5000 kernel: megaraid: aborting-464747 cmd=2a 
> <c=1 t=0 l=0>
> Mar 29 00:09:53 5000 kernel: megaraid abort: 464747[255:0], 
> driver owner 
> Mar 29 00:09:53 5000 kernel: megaraid: reseting the host...
> Mar 29 00:09:53 5000 kernel: megaraid: 
> 464723:128[65535:65535], reset from pending list
> Mar 29 00:09:53 5000 kernel: megaraid: 4 outstanding 
> commands. Max wait 180 sec
> Mar 29 00:09:53 5000 kernel: megaraid mbox: Wait for 4 
> commands to complete:180
> ...
> Mar 29 00:11:54 5000 kernel: megaraid mbox: Wait for 4 
> commands to complete:60
> Mar 29 00:11:59 5000 kernel: megaraid mbox: Wait for 4 
> commands to complete:55
> Mar 29 00:12:04 5000 kernel: megaraid mbox: Wait for 4 
> commands to complete:50
> Mar 29 00:12:08 5000 kernel: megaraid mbox: reset sequence 
> completed sucessfully
> Mar 29 00:12:08 5000 kernel: Unable to handle kernel NULL 
> pointer dereference at virtual address 00000000
> Mar 29 00:12:08 5000 kernel:  printing eip:
> Mar 29 00:12:08 5000 kernel: f881f739
> Mar 29 00:12:08 5000 kernel: *pde = 00000000
> Mar 29 00:12:08 5000 kernel: Oops: 0002 [#1]
> Mar 29 00:12:08 5000 kernel: SMP
> Mar 29 00:12:08 5000 kernel: Modules linked in: xfs md5 ipv6 
> af_packet button thermal processor fan ac battery tsdev joydev
> evdev usbkbd usbhid e1000 intel_agp agpgart ehci_hcd uhci_hcd 
> usbcore rtc ext3 jbd sd_mod megaraid_mbox megaraid_mm 
> ata_piix  libata scsi_mod
> Mar 29 00:12:08 5000 kernel: CPU:    0
> Mar 29 00:12:08 5000 kernel: EIP:    
> 0060:[pg0+943802169/1069495296] Tainted: P      VLI
> Mar 29 00:12:08 5000 kernel: EIP:    0060:[<f881f739>]    
> Tainted: P VLI
> Mar 29 00:12:08 5000 kernel: EFLAGS: 00010046   (2.6.10)
> Mar 29 00:12:08 5000 kernel: EIP is at 
> megaraid_mbox_build_cmd+0x979/0xce0 [megaraid_mbox]
> Mar 29 00:12:08 5000 kernel: eax: 00000000   ebx: 00000000   
> ecx: 0000000d edx: 79473000
> Mar 29 00:12:08 5000 kernel: esi: c238f780   edi: c23af800   
> ebp: f7491f10 esp: f7491e98
> Mar 29 00:12:09 5000 kernel: ds: 007b   es: 007b   ss: 0068
> Mar 29 00:12:09 5000 kernel: Process scsi_eh_1 (pid: 885, 
> threadinfo=f7490000 task=f7dde020)
> Mar 29 00:12:09 5000 kernel: Stack: c23e3c00 f7de3000 
> f7491ebc f66fc2a0 c23e3c00 0000000d c226a42c f7436038
> Mar 29 00:12:09 5000 kernel:        f7436030 f7491ee8 
> c23b1010 f7491ed0 011d2df4 c226aa34 c226aa2c c226a42c
> Mar 29 00:12:09 5000 kernel:        00000000 000000ff 
> c2268000 6e616373 676e696e 00000000 00000086 70696b73
> Mar 29 00:12:09 5000 kernel: Call Trace:
> Mar 29 00:12:09 5000 kernel:  [show_stack+171/192] 
> show_stack+0xab/0xc0
> Mar 29 00:12:09 5000 kernel:  [<c0103e9b>] show_stack+0xab/0xc0
> Mar 29 00:12:09 5000 kernel:  [show_registers+351/464] 
> show_registers+0x15f/0x1d0
> Mar 29 00:12:09 5000 kernel:  [<c010402f>] show_registers+0x15f/0x1d0
> Mar 29 00:12:09 5000 kernel:  [die+244/400] die+0xf4/0x190
> Mar 29 00:12:09 5000 kernel:  [<c0104244>] die+0xf4/0x190
> Mar 29 00:12:09 5000 kernel:  [do_page_fault+1172/1715] 
> do_page_fault+0x494/0x6b3
> Mar 29 00:12:09 5000 kernel:  [<c0117394>] do_page_fault+0x494/0x6b3
> Mar 29 00:12:09 5000 kernel:  [error_code+43/48] error_code+0x2b/0x30
> Mar 29 00:12:09 5000 kernel:  [<c0103aeb>] error_code+0x2b/0x30
> Mar 29 00:12:09 5000 kernel:  [pg0+943799680/1069495296] 
> megaraid_queue_command+0x50/0x90 [megaraid_mbox]
> Mar 29 00:12:09 5000 kernel:  [<f881ed80>] 
> megaraid_queue_command+0x50/0x90 [megaraid_mbox]
> Mar 29 00:12:09 5000 kernel:  [pg0+943941731/1069495296] 
> scsi_dispatch_cmd+0x173/0x290 [scsi_mod]
> Mar 29 00:12:09 5000 kernel:  [<f8841863>] 
> scsi_dispatch_cmd+0x173/0x290 [scsi_mod]
> Mar 29 00:12:09 5000 kernel:  [pg0+943966809/1069495296] 
> scsi_request_fn+0x1e9/0x430 [scsi_mod]
> Mar 29 00:12:09 5000 kernel:  [blk_run_queue+42/64] 
> blk_run_queue+0x2a/0x40
> Mar 29 00:12:09 5000 kernel:  [<c023aeaa>] blk_run_queue+0x2a/0x40
> Mar 29 00:12:09 5000 kernel:  [pg0+943963243/1069495296] 
> scsi_run_host_queues+0x2b/0x50 [scsi_mod]
> Mar 29 00:12:09 5000 kernel:  [<f8846c6b>] 
> scsi_run_host_queues+0x2b/0x50 [scsi_mod]
> Mar 29 00:12:09 5000 kernel:  [pg0+943960213/1069495296] 
> scsi_error_handler+0x85/0x170 [scsi_mod]
> Mar 29 00:12:09 5000 kernel:  [<f8846095>] 
> scsi_error_handler+0x85/0x170 [scsi_mod]
> Mar 29 00:12:09 5000 kernel:  [kernel_thread_helper+5/16] 
> kernel_thread_helper+0x5/0x10
> Mar 29 00:12:09 5000 kernel:  [<c01012d5>] 
> kernel_thread_helper+0x5/0x10
> Mar 29 00:12:09 5000 kernel: Code: 2c 82 f8 c7 47 20 01 00 00 
> 00 8b 4d 9c 85 c9 74 39 8b 4d 9c 31 db 8d b6 00 00 00 00 8d 
> bf 00 00 00 00 8b 55 a0 8b 42 10 8b 56 08 <89> 14 18 31 d2 89 
> 54 18 04 8b 45 a0 8b 50 10 8b 46 0c 83 c6 10
> Mar 29 00:14:23 5000 kernel:  <4>megaraid cmm: ioctl timed out
> Mar 29 00:14:23 5000 kernel: megaraid cmm: controller cannot 
> accept cmds
> due to earlier errors
> Mar 29 00:14:24 5000 last message repeated 3 times
> ...
> until reboot
> 
> I know everyone will rant about ... there is a taint, I just do not
> have immediate access to the logs (which) do exist without the taint
> marker set.
> 
> I will post the patch on kernel.org and can be adopted or dumped.
> The posting to the list was to follow the patch submission rules.
> 
> Cheers,
> 
> Andre Hedrick
> LAD Storage Consulting Group
> 
> On Tue, 16 May 2006, Ju, Seokmann wrote:
> 
> > Hi,
> > 
> > I cannot agree on the changes in the patch for following reasons.
> > 
> > On Tuesday, May 16, 2006 1:44 PM, Andre Hedrick wrote:
> > > Random (hard to reproduce, without a noise injection into the SATA
> > > connector or cable) hardware error states which locks the 
> > > card and in the
> > > majority of the cases caused the array to be lost.  If the 
> > > array was not
> > > lost then a drive was failed but one could not 
> remove/replace w/ a new
> > > drive.  Thus adding in a pci_master_abort test and clear 
> > > function proved
> > > to allow recovery in all cases where the card shutdown 
> > > communication to
> > > the host.  This may not address all cases; however, 
> clearly this is a
> > > missing part of the driver base when entry to eh_scsi_* begins.
> > If 'raid_dev->hw_error' is non-zero, this means that the 
> controller has gone bad and will (and should not to avoid 
> further memory corruption) not be able to recoverd unless reboot.
> > The overall issue described here already taken care by the 
> patch that I've submitted.
> > The patch has been accepted and should be available on 
> 2.6.17-rc1-mm3 as specified in Andrew Morton's email.
> > > The compond issue in the failed recovery resulted in a deref 
> > > NULL pointer
> > > in the various list_head calls.  After change the individual 
> > > list_add to
> > > list_move and such, the NULL point issue has never shown up 
> > > in the past 6
> > > weeks of heavy testing.
> > I'm not sure how this changes help for the issue. 
> Furthermore, I'm not sure what is _the NULL point issue_ 
> refering to. If you see the issue with driver available on 
> 2.6.17-rc1-mm3, please let me know.
> > Following link will leads you to further details of the patch.
> > 
> http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fix
es-2.6.git;a=commit;h=c005fb4fb2d23ba29ad21dee5042b2f8451ca8ba
> > 
> > Thank you,
> > 
> > Seokmann
> > 
> > > -----Original Message-----
> > > From: Andre Hedrick [mailto:andre@linux-ide.org] 
> > > Sent: Tuesday, May 16, 2006 1:44 PM
> > > To: linux-scsi@vger.kernel.org; Ju, Seokmann; Andrew Morton
> > > Cc: James Bottomley; Christoph Hellwig; Mukker, Atul
> > > Subject: [RFC] Megaraid update, submission
> > > 
> > > 
> > > Linux-scsi, et al.
> > > 
> > > The follow patch address two major issues found under 
> > > extensive testing.
> > > 
> > > While pounding data io down the card and performing large 
> > > scale queries to
> > > the controller about device state and function parameters, 
> > > the following
> > > were discovered.
> > > 
> > > Random (hard to reproduce, without a noise injection into the SATA
> > > connector or cable) hardware error states which locks the 
> > > card and in the
> > > majority of the cases caused the array to be lost.  If the 
> > > array was not
> > > lost then a drive was failed but one could not 
> remove/replace w/ a new
> > > drive.  Thus adding in a pci_master_abort test and clear 
> > > function proved
> > > to allow recovery in all cases where the card shutdown 
> > > communication to
> > > the host.  This may not address all cases; however, 
> clearly this is a
> > > missing part of the driver base when entry to eh_scsi_* begins.
> > > 
> > > The compond issue in the failed recovery resulted in a deref 
> > > NULL pointer
> > > in the various list_head calls.  After change the individual 
> > > list_add to
> > > list_move and such, the NULL point issue has never shown up 
> > > in the past 6
> > > weeks of heavy testing.
> > > 
> > > In all cases in the past, the baseline for error was 6:1.  
> > > Meaning either
> > > one system in six failed and/or one in six test/stress runs 
> > > failed.  With
> > > the attached changes, there have been zero failures in 
> the past three
> > > weeks.  This sound great, but I wish it would fail to allow some
> > > statistics of improved error handling.
> > > 
> > > Please note the changes to SAS are minor and not tested, but 
> > > seem correct
> > > for the entire directory code base.  SAS shares the CMM core 
> > > with MBOX,
> > > thus the rational for changes to SAS.
> > > 
> > > Please comment and provide suggestions.
> > > 
> > > Cheers,
> > > 
> > > Andre Hedrick
> > > LAD Storage Consulting Group
> > > 
> > > 
> > > 
> > > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> 
> 
