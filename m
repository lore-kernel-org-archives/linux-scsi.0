From: Andrew Morton <akpm@osdl.org>
Subject: Re: [SCSI] Driver broken in 2.6.x?
Date: Wed, 25 May 2005 21:40:47 -0700
Message-ID: <20050525214047.731f56ef.akpm@osdl.org>
References: <424EB65A.8010600@punkt.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:234 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261197AbVEZEln (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 00:41:43 -0400
In-Reply-To: <424EB65A.8010600@punkt.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: |TEcHNO| <techno@punkt.pl>
Cc: linux-scsi@vger.kernel.org

|TEcHNO| <techno@punkt.pl> wrote:
>
> Hi,
> 
> I've recently switched form 2.4.x kernel series to 2.6.x, and I've 
> encourted a problem with my old scanner card, lspci shows it as:
> 
> <begin lspci output>
> 00:0c.0 SCSI storage controller: DTC Technology Corp. Domex 536
>          Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>          Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Interrupt: pin A routed to IRQ 11
>          Region 0: I/O ports at d800 [size=32]
> <end>
> 
> It worked flawlessly under 2.4 kernels, but now it hangs xsane, and logs 
> show this:

Is this crash still repeatable in 2.6.12-rc5?

If so, can you please verify that it still occurs if the nvidia driver was
never loaded?

Thanks.

> <begin /var/log/messages>
> Apr  1 17:29:30 techno kernel:         command: cdb[0]=0x0: 00 00 00 00 
> 00 00
> Apr  1 17:29:40 techno last message repeated 3 times
> <end>
> 
> <begin /va/log/syslog>
> Apr  1 17:29:30 techno kernel: scsi0 : aborting command
> Apr  1 17:29:30 techno kernel: scsi0 : destination target 6, lun 0
> Apr  1 17:29:30 techno kernel:
> Apr  1 17:29:30 techno kernel: NCR5380 core release=7.
> Apr  1 17:29:30 techno kernel: Base Addr: 0x00000    io_port: d800 
> IRQ: 11.
> Apr  1 17:29:30 techno kernel: scsi0: no currently connected command
> Apr  1 17:29:30 techno kernel: scsi0: issue_queue
> Apr  1 17:29:30 techno kernel: scsi0 : destination target 6, lun 0
> Apr  1 17:29:30 techno kernel:         command =  0 (0x00)00 00 00 00 00
> Apr  1 17:29:30 techno kernel: scsi0: disconnected_queue
> Apr  1 17:29:30 techno kernel:
> Apr  1 17:29:30 techno kernel: scsi0 : aborting command
> Apr  1 17:29:30 techno kernel: scsi0 : destination target 6, lun 0
> Apr  1 17:29:30 techno kernel:
> Apr  1 17:29:30 techno kernel: NCR5380 core release=7.
> Apr  1 17:29:30 techno kernel: Base Addr: 0x00000    io_port: d800 
> IRQ: 11.
> Apr  1 17:29:30 techno kernel: scsi0: no currently connected command
> Apr  1 17:29:30 techno kernel: scsi0: issue_queue
> Apr  1 17:29:30 techno kernel: scsi0 : destination target 6, lun 0
> Apr  1 17:29:30 techno kernel:         command =  0 (0x00)00 00 00 00 00
> Apr  1 17:29:30 techno kernel: scsi0: disconnected_queue
> Apr  1 17:29:30 techno kernel:
> Apr  1 17:29:40 techno kernel: scsi0 : aborting command
> Apr  1 17:29:40 techno kernel: scsi0 : destination target 6, lun 0
> Apr  1 17:29:40 techno kernel:
> Apr  1 17:29:40 techno kernel: NCR5380 core release=7.
> Apr  1 17:29:40 techno kernel: Base Addr: 0x00000    io_port: d800 
> IRQ: 11.
> Apr  1 17:29:40 techno kernel: scsi0: no currently connected command
> Apr  1 17:29:40 techno kernel: scsi0: issue_queue
> Apr  1 17:29:40 techno kernel: scsi0 : destination target 6, lun 0
> Apr  1 17:29:40 techno kernel:         command =  0 (0x00)00 00 00 00 00
> Apr  1 17:29:40 techno kernel: scsi0: disconnected_queue
> Apr  1 17:29:40 techno kernel:
> Apr  1 17:29:40 techno kernel: scsi0 : aborting command
> Apr  1 17:29:40 techno kernel: scsi0 : destination target 6, lun 0
> Apr  1 17:29:40 techno kernel:
> Apr  1 17:29:40 techno kernel: NCR5380 core release=7.
> Apr  1 17:29:40 techno kernel: Base Addr: 0x00000    io_port: d800 
> IRQ: 11.
> Apr  1 17:29:40 techno kernel: scsi0: no currently connected command
> Apr  1 17:29:40 techno kernel: scsi0: issue_queue
> Apr  1 17:29:40 techno kernel: scsi0 : destination target 6, lun 0
> Apr  1 17:29:40 techno kernel:         command =  0 (0x00)00 00 00 00 00
> Apr  1 17:29:40 techno kernel: scsi0: disconnected_queue
> Apr  1 17:29:41 techno kernel:
> Apr  1 17:29:41 techno kernel: Unable to handle kernel paging request at 
> virtual address 002b2c36
> Apr  1 17:29:41 techno kernel:  printing eip:
> Apr  1 17:29:41 techno kernel: c03f1e71
> Apr  1 17:29:41 techno kernel: *pde = 00000000
> Apr  1 17:29:41 techno kernel: Oops: 0000 [#1]
> Apr  1 17:29:41 techno kernel: PREEMPT
> Apr  1 17:29:41 techno kernel: Modules linked in: nvidia
> Apr  1 17:29:41 techno kernel: CPU:    0
> Apr  1 17:29:41 techno kernel: EIP:    0060:[<c03f1e71>]    Tainted: P 
>      VLI
> Apr  1 17:29:41 techno kernel: EFLAGS: 00010202   (2.6.11.3)
> Apr  1 17:29:41 techno kernel: EIP is at sg_cmd_done+0x41/0x2f0
> Apr  1 17:29:41 techno kernel: eax: 00000000   ebx: cd4ee600   ecx: 
> db821dec   edx: db83d040
> Apr  1 17:29:41 techno kernel: esi: ca037038   edi: 002b2c32   ebp: 
> db83d040   esp: db84deec
> Apr  1 17:29:41 techno kernel: ds: 007b   es: 007b   ss: 0068
> Apr  1 17:29:41 techno kernel: Process scsi_eh_0 (pid: 1096, 
> threadinfo=db84c000 task=dbcf40e0)
> Apr  1 17:29:41 techno kernel: Stack: c060e3b5 db84defc c03e7c31 
> c060e3b5 c07bc620 db84df10 db821c00 00050000
> Apr  1 17:29:41 techno kernel:        00000000 00000001 c03e97fa 
> db83d040 00000000 00000001 00000246 db83d040
> Apr  1 17:29:41 techno kernel:        db84c000 c03dacce db83d040 
> c03dab30 c03dab10 00000000 00000000 db84df48
> Apr  1 17:29:41 techno kernel: Call Trace:
> Apr  1 17:29:41 techno kernel:  [<c03e7c31>] NCR5380_print_status+0x51/0x60
> Apr  1 17:29:41 techno kernel:  [<c03e97fa>] NCR5380_abort+0x14a/0x160
> Apr  1 17:29:41 techno kernel:  [<c03dacce>] scsi_send_eh_cmnd+0x13e/0x170
> Apr  1 17:29:41 techno kernel:  [<c03dab30>] scsi_eh_done+0x0/0x60
> Apr  1 17:29:41 techno kernel:  [<c03dab10>] scsi_eh_times_out+0x0/0x20
> Apr  1 17:29:41 techno kernel:  [<c03db045>] scsi_eh_tur+0x95/0xd0
> Apr  1 17:29:41 techno kernel:  [<c03db0e9>] scsi_eh_abort_cmds+0x69/0x80
> Apr  1 17:29:41 techno kernel:  [<c03dbd11>] scsi_unjam_host+0xa1/0xd0
> Apr  1 17:29:41 techno kernel:  [<c011b9c2>] complete+0x52/0x80
> Apr  1 17:29:41 techno kernel:  [<c03dbddf>] scsi_error_handler+0x9f/0xd0
> Apr  1 17:29:41 techno kernel:  [<c03dbd40>] scsi_error_handler+0x0/0xd0
> Apr  1 17:29:41 techno kernel:  [<c01012fd>] kernel_thread_helper+0x5/0x18
> Apr  1 17:29:41 techno kernel: Code: 1c 89 7c 24 20 0f 84 b1 02 00 00 8b 
> 5d 0c 85 db 0f 84 a6 02 00 00 8b b3 ac 00 00 00 85 f6 0f 84 98 02 00 00 
> 8b 7e 08 85 ff 74 13 <8b> 47 04 85 c0 89 44 24 0c 74 08 0f b6 40 14 84 
> c0 74 2c c7 04
> Apr  1 17:29:41 techno kernel:  <6>note: scsi_eh_0[1096] exited with 
> preempt_count 1
> <end>
> 
> I hope thant you can either tell me what's wrong, or anyone coudl look 
> at the code and fix the problem?
> As an additional note I have ScanMagic 9636 S Plus Scanner with the card 
>   thad it was sold with.
> As a side not I can tell It was working with 2.4 series, but scanning 
> coused the mashing to either hang for a few seconds (one or twice hang 
> for good), while the scanning caused the machine to become jaggy, the 
> music played (xmms), but the graphic wasn't working well.
> 
> I'm not subscribed so please CC to me too.
> -- 
> pozdrawiam     |"Help me master, I felt the burning twilight behind
> techno@punkt.pl|those gates of stell..." --Perihelion, Prophecy Sequence
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
