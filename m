From: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.39-rc1 problem
Date: Fri, 1 Apr 2011 11:01:35 +0200
Message-ID: <20110401090135.GI3385@htj.dyndns.org>
References: <1301536052.9909@guyane.yi.org>
 <20110331113523.3c34f360.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110331113523.3c34f360.akpm@linux-foundation.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: werner@guyane.yi.org, linux-kernel@vger.kernel.org, gregkh@suse.de, mingo@elte.hu, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(cc linux-scsi)
Hello,

On Thu, Mar 31, 2011 at 11:35:23AM -0700, Andrew Morton wrote:
> (cc linux-ide)
> 
> On Wed, 30 Mar 2011 22:47:32 -0300 (GFT)
> werner@guyane.yi.org wrote:
> 
> > The mailing list is anyhow blocking my mails, I suppose it didnt
> > appear there, so I send my error report to you You can send it to
> > someone wich can correct these erros

Can you please provide more details on the circumstances?  When did
this happen and how reproducible is it?  Which controller is in use
(lspci -nn)?  Please also attach full output of dmesg including the
boot messages.

> > ==============================================
> > Mar 30 03:48:42 werner kernel: ------------[ cut here ]------------
> > Mar 30 03:48:42 werner kernel: WARNING: at drivers/ata/libata-core.c:5015 ata_qc_issue+0x1ba/0x33c()
> > Mar 30 03:48:42 werner kernel: Hardware name: System Product Name
> > Mar 30 03:48:42 werner kernel: Modules linked in: ipv6 snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device rt2860sta(C) uvcvideo lp snd_hda_codec_realtek tpm_tis tpm tpm_bios rtc_cmos rtc_core rtc_lib asus_atk0110 snd_hda_intel 8139too snd_hda_codec snd_hwdep snd_pcm snd_timer k8temp atl1 snd soundcore snd_page_alloc i2c_nforce2
> > Mar 30 03:48:42 werner kernel: Pid: 0, comm: swapper Tainted: G         C  2.6.39-rc1 #1
> 
> I assume that 2.6.38 was OK and that this is a post-2.6.38 regression?
> 
> > Mar 30 03:48:42 werner kernel: Call Trace:
> > Mar 30 03:48:42 werner kernel:  [<c1a22e33>] ? ata_qc_issue+0x1ba/0x33c
> > Mar 30 03:48:42 werner kernel:  [<c103ce4b>] warn_slowpath_common+0x7a/0x8f
> > Mar 30 03:48:42 werner kernel:  [<c1a22e33>] ? ata_qc_issue+0x1ba/0x33c
> > Mar 30 03:48:42 werner kernel:  [<c103ce82>] warn_slowpath_null+0x22/0x24
> > Mar 30 03:48:42 werner kernel:  [<c1a22e33>] ata_qc_issue+0x1ba/0x33c
> > Mar 30 03:48:42 werner kernel:  [<c1a2806c>] ata_scsi_translate+0xdd/0x10b
> > Mar 30 03:48:43 werner kernel:  [<c1a27d4f>] ? ata_gen_passthru_sense+0x125/0x125
> > Mar 30 03:48:43 werner kernel:  [<c1a28d98>] ata_scsi_queuecmd+0x178/0x1bb
> > Mar 30 03:48:43 werner kernel:  [<c17f9c5b>] scsi_dispatch_cmd+0x164/0x1ee
> > Mar 30 03:48:43 werner kernel:  [<c15526a0>] ? blk_add_timer+0x89/0xab
> > Mar 30 03:48:43 werner kernel:  [<c17ff113>] scsi_request_fn+0x348/0x483
> > Mar 30 03:48:43 werner kernel:  [<c154cae0>] __blk_run_queue+0x6c/0xce
> > Mar 30 03:48:43 werner kernel:  [<c154cfe0>] blk_run_queue+0x22/0x33
> > Mar 30 03:48:43 werner kernel:  [<c17fe80a>] scsi_run_queue+0x297/0x318
> > Mar 30 03:48:43 werner kernel:  [<c17ff3f9>] scsi_next_command+0x2d/0x39
> > Mar 30 03:48:43 werner kernel:  [<c17fff29>] scsi_io_completion+0x41f/0x457
> > Mar 30 03:48:43 werner kernel:  [<c1a108e4>] ? sd_done+0xe/0x26d
> > Mar 30 03:48:43 werner kernel:  [<c17ffa2a>] ? scsi_device_unbusy+0x80/0x86
> > Mar 30 03:48:43 werner kernel:  [<c17f99db>] scsi_finish_command+0xce/0xd6
> > Mar 30 03:48:43 werner kernel:  [<c17fcafd>] ? scsi_decide_disposition+0xe8/0x16e
> > Mar 30 03:48:43 werner kernel:  [<c1800058>] scsi_softirq_done+0xe3/0xeb
> > Mar 30 03:48:43 werner kernel:  [<c107da3b>] ? __rcu_process_callbacks+0x6b/0x227
> > Mar 30 03:48:43 werner kernel:  [<c155248f>] blk_done_softirq+0x5b/0x68
> > Mar 30 03:48:43 werner kernel:  [<c10423aa>] __do_softirq+0xa1/0x169
> > Mar 30 03:48:43 werner kernel:  [<c1042309>] ? irq_enter+0x4d/0x4d
> > Mar 30 03:48:43 werner kernel:  <IRQ>  [<c1079bf8>] ? irq_to_desc+0x8/0x1e
> > Mar 30 03:48:43 werner kernel:  [<c10421b8>] ? irq_exit+0x37/0x53
> > Mar 30 03:48:43 werner kernel:  [<c1004715>] ? do_IRQ+0x8b/0xa1
> > Mar 30 03:48:43 werner kernel:  [<c1df2330>] ? common_interrupt+0x30/0x40
> > Mar 30 03:48:43 werner kernel:  [<c10266c4>] ? native_safe_halt+0xa/0xc
> > Mar 30 03:48:43 werner kernel:  [<c10093ca>] ? default_idle+0xa5/0x11b
> > Mar 30 03:48:43 werner kernel:  [<c100986e>] ? c1e_idle+0xdd/0xe3
> > Mar 30 03:48:43 werner kernel:  [<c100262a>] ? cpu_idle+0x86/0x9c
> > Mar 30 03:48:43 werner kernel:  [<c1d7aaad>] ? rest_init+0x5d/0x5f
> > Mar 30 03:48:43 werner kernel:  [<c231981d>] ? start_kernel+0x317/0x31d
> > Mar 30 03:48:43 werner kernel:  [<c231931c>] ? kernel_init+0x12a/0x12a
> > Mar 30 03:48:43 werner kernel:  [<c23190b6>] ? i386_start_kernel+0xb6/0xbd
> > Mar 30 03:48:43 werner kernel: ---[ end trace 2f5b85b514efe967 ]---
> > Mar 30 03:48:43 werner kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> > Mar 30 03:48:43 werner kernel: ata1.00: failed command: WRITE DMA
> > Mar 30 03:48:43 werner kernel: ata1.00: cmd ca/00:08:27:06:bc/00:00:00:00:00/e7 tag 0 dma 4096 out
> > Mar 30 03:48:43 werner kernel:          res 50/00:00:4e:00:bc/00:00:00:00:00/e7 Emask 0x40 (internal error)
> > Mar 30 03:48:43 werner kernel: ata1.00: status: { DRDY }
> > Mar 30 03:48:43 werner kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> > Mar 30 03:48:43 werner kernel: ata1.00: failed command: WRITE DMA
> > Mar 30 03:48:43 werner kernel: ata1.00: cmd ca/00:08:27:06:bc/00:00:00:00:00/e7 tag 0 dma 4096 out
> > Mar 30 03:48:43 werner kernel:          res 50/00:00:af:88:e0/00:00:00:00:00/e0 Emask 0x40 (internal error)
> > Mar 30 03:48:43 werner kernel: ata1.00: status: { DRDY }
> > Mar 30 03:48:43 werner kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> > Mar 30 03:48:43 werner kernel: ata1.00: failed command: WRITE DMA
> > Mar 30 03:48:43 werner kernel: ata1.00: cmd ca/00:08:27:06:bc/00:00:00:00:00/e7 tag 0 dma 4096 out
> > Mar 30 03:48:43 werner kernel:          res 50/00:00:af:88:e0/00:00:00:00:00/e0 Emask 0x40 (internal error)
> > Mar 30 03:48:43 werner kernel: ata1.00: status: { DRDY }
> > Mar 30 03:48:43 werner kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> > Mar 30 03:48:43 werner kernel: ata1.00: failed command: WRITE DMA
> > Mar 30 03:48:43 werner kernel: ata1.00: cmd ca/00:08:27:06:bc/00:00:00:00:00/e7 tag 0 dma 4096 out
> > Mar 30 03:48:43 werner kernel:          res 50/00:00:af:88:e0/00:00:00:00:00/e0 Emask 0x40 (internal error)
> > Mar 30 03:48:43 werner kernel: ata1.00: status: { DRDY }
> > Mar 30 03:48:43 werner kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> > Mar 30 03:48:43 werner kernel: ata1.00: failed command: WRITE DMA
> > Mar 30 03:48:43 werner kernel: ata1.00: cmd ca/00:08:27:06:bc/00:00:00:00:00/e7 tag 0 dma 4096 out
> > Mar 30 03:48:43 werner kernel:          res 50/00:00:af:88:e0/00:00:00:00:00/e0 Emask 0x40 (internal error)
> > Mar 30 03:48:43 werner kernel: ata1.00: status: { DRDY }
> > Mar 30 03:48:43 werner kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> > Mar 30 03:48:43 werner kernel: ata1.00: failed command: WRITE DMA
> > Mar 30 03:48:43 werner kernel: ata1.00: cmd ca/00:08:27:06:bc/00:00:00:00:00/e7 tag 0 dma 4096 out
> > Mar 30 03:48:43 werner kernel:          res 50/00:00:af:88:e0/00:00:00:00:00/e0 Emask 0x40 (internal error)
> > Mar 30 03:48:43 werner kernel: ata1.00: status: { DRDY }

The triggered condition is the following.

	if (WARN_ON_ONCE(ata_is_data(prot) &&
	    (!qc->sg || !qc->n_elem || !qc->nbytes)))
		goto sys_err;

qc->nbytes is 4096 as printed out in "dma 4096 out" in the command
error messages, so either qc->sg or n_elem is not initialized and both
are initialized directly from the SCSI command using scsi_sglist(scmd)
and scsi_sg_count(scmd), so the root cause could be in SCSI layer.

Anyways, too little info to determine anything at this point.

Thanks.

-- 
tejun
