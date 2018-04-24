From: Paul Menzel <pmenzel+linux-block@molgen.mpg.de>
Subject: Re: Regression 4.17-rc1: SSD doesn properly resume causing system
 hang (NULL pointer dereference)
Date: Tue, 24 Apr 2018 23:04:30 +0200
Message-ID: <6a2162a7-5f48-c107-0b1c-5258089522c5@molgen.mpg.de>
References: <59ca6556-11a6-4f77-76e7-d51c7175eb32@molgen.mpg.de>
 <67ffdf0050a04bf3615c3d8a3a90b0c9c2aeb1ad.camel@wdc.com>
 <2cc5f0fb-4caa-9c28-7daa-68993d5cb41a@molgen.mpg.de>
 <14ff1ed06e36a372680872c227b5abe389c753da.camel@wdc.com>
 <a3a7f906-3681-15cc-67af-b96e4ac71b0e@molgen.mpg.de>
 <134955874b401e6764077393c75ab2d4549b940a.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------1D77A5019546E2FD3B843EA9"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <134955874b401e6764077393c75ab2d4549b940a.camel@wdc.com>
Content-Language: de-DE
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: axboe@kernel.dk, jejb@linux.vnet.ibm.com, regressions@leemhuis.info, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------1D77A5019546E2FD3B843EA9
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Bart,


Thank you for looking into the issue.

Am 24.04.2018 um 20:27 schrieb Bart Van Assche:
> On Tue, 2018-04-24 at 19:37 +0200, Paul Menzel wrote:
>> On 04/24/18 19:31, Bart Van Assche wrote:
>> Here it is, pasted as citation, as otherwise Thunderbird would wrap the
>> line.
>>
>>> (gdb) disas blk_set_runtime_active
>>> Dump of assembler code for function blk_set_runtime_active:
>>>     0xc1518610 <+0>:	call   0xc106ac9c <__fentry__>
>>>     0xc1518615 <+5>:	push   %ebp
>>>     0xc1518616 <+6>:	mov    %esp,%ebp
>>>     0xc1518618 <+8>:	sub    $0x14,%esp
>>>     0xc151861b <+11>:	mov    %ebx,-0xc(%ebp)
>>>     0xc151861e <+14>:	mov    %eax,%ebx
>>>     0xc1518620 <+16>:	mov    %gs:0x14,%eax
>>>     0xc1518626 <+22>:	mov    %eax,-0x10(%ebp)
>>>     0xc1518629 <+25>:	xor    %eax,%eax
>>>     0xc151862b <+27>:	test   %ebx,%ebx
>>>     0xc151862d <+29>:	mov    %esi,-0x8(%ebp)
>>>     0xc1518630 <+32>:	mov    %edi,-0x4(%ebp)
>>>     0xc1518633 <+35>:	je     0xc15186b3 <blk_set_runtime_active+163>
>>>     0xc1518635 <+37>:	mov    0xfc(%ebx),%eax
>>>     0xc151863b <+43>:	call   0xc1a4b920 <_raw_spin_lock_irq>
>>>     0xc1518640 <+48>:	mov    0x150(%ebx),%esi
>>>     0xc1518646 <+54>:	xor    %eax,%eax
>>>     0xc1518648 <+56>:	mov    0xc1ca7d20,%edi
>>>     0xc151864e <+62>:	mov    %eax,0x154(%ebx)
>>>     0xc1518654 <+68>:	cmp    $0xffffff0c,%esi
>>>     0xc151865a <+74>:	mov    %edi,-0x14(%ebp)
>>>     0xc151865d <+77>:	je     0xc15186a5 <blk_set_runtime_active+149>
>>>     0xc151865f <+79>:	mov    %edi,0xf4(%esi)
> 
> The e-mail at the start of this e-mail thread shows that %esi == NULL at
> the time of the crash and also that the crash occurred at offset 79 (0x4f)
> in this function. I think that means that the crash occurred in the following
> code: pm_request_autosuspend(q->dev) and also that this means that q->dev ==
> NULL. Can you test the (untested) patch below?
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 57cae47ab1c2..b029a94a1e66 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3272,7 +3272,6 @@ static void sd_probe_async(struct work_struct *work)
>   		gd->events |= DISK_EVENT_MEDIA_CHANGE;
>   	}
>   
> -	blk_pm_runtime_init(sdp->request_queue, dev);
>   	device_add_disk(dev, gd);
>   	if (sdkp->capacity)
>   		sd_dif_config_host(sdkp);
> @@ -3390,6 +3389,8 @@ static int sd_probe(struct device *dev)
>   	get_device(dev);
>   	dev_set_drvdata(dev, sdkp);
>   
> +	blk_pm_runtime_init(sdp->request_queue, dev);
> +
>   	get_device(&sdkp->dev);	/* prevent release before sd_probe_async() */
>   	WARN_ON_ONCE(!queue_work(system_unbound_wq, &sdkp->probe_work));

I applied your change, and rebuilt the Linux kernel. Unfortunately, it 
looks like, it didn’t make a difference.

> 18.673: [  184.143302] BUG: unable to handle kernel NULL pointer dereference at 000000f4
> 18.673: [  184.143306] *pde = 00000000 
> 18.673: [  184.143312] Oops: 0002 [#1] SMP
> 18.674: [  184.148479] calling  usb2+ @ 720, parent: 0000:00:1d.7
> 18.674: [  184.148471] Modules linked in: i915 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm drm_panel_orientation_quirks i2c_algo_bit serport binfmt_misc
> 18.674: [  184.158340] calling  PNP0C0A:01+ @ 690, parent: PNP0C09:00
> 18.674: [  184.148471]  mousedev iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm irqbypass psmouse snd_pcsp arc4 pcmcia sdhci_pci cqhci iwl3945 lpc_ich mfd_core iwlegacy
> 18.674: [  184.169352] call 0000:05:00.2+ returned 0 after 251381 usecs
> 18.674: [  184.169336]  i2c_i801 sdhci mmc_core mac80211 snd_hda_codec_analog snd_hda_codec_generic firewire_ohci yenta_socket pcmcia_rsrc firewire_core crc_itu_t pcmcia_core rng_core cfg80211 snd_hda_intel ehci_pci e1000e thinkpad_acpi snd_hda_codec uhci_hcd snd_hda_core snd_hwdep snd_pcm snd_timer
> 18.674: [  184.180378] calling  phy0+ @ 727, parent: 0000:02:00.0
> 18.674: [  184.180362]  ehci_hcd nvram rfkill battery snd soundcore usbcore video button shpchp ac acpi_cpufreq ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto cbc dm_crypt dm_mod sd_mod ahci
> 18.674: [  184.192683] call PNP0C0A:01+ returned 0 after 23063 usecs
> 18.674: [  184.180362]  libahci evdev libata serio_raw scsi_mod fan thermal
> 18.674: [  184.180362] CPU: 0 PID: 708 Comm: kworker/u4:7 Not tainted 4.17.0-rc2+ #14
> 18.674: [  184.198715] calling  PNP0C0E:00+ @ 690, parent: PNP0C09:00
> 18.674: [  184.198705] Hardware name: LENOVO 636338U/636338U, BIOS CBET4000 TIMELESS 01/01/1970
> 18.674: [  184.198705] Workqueue: events_unbound async_run_entry_fn
> 18.674: [  184.198705] EIP: blk_set_runtime_active+0x4f/0xc0
> 18.674: [  184.198705] EFLAGS: 00010013 CPU: 0
> 18.674: [  184.198705] EAX: 00000000 EBX: f665f740 ECX: f665f838 EDX: 00000000
> 18.674: [  184.198705] ESI: 00000000 EDI: ffff7bbe EBP: f1afde38 ESP: f1afde24
> 18.674: [  184.218335] call PNP0C0E:00+ returned 0 after 2 usecs
> 18.674: [  184.198705]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> 18.674: [  184.198705] CR0: 80050033 CR2: 000000f4 CR3: 0e40a000 CR4: 000006d0
> 18.674: [  184.198705] Call Trace:
> 18.674: [  184.198705]  ? async_sdev_thaw+0x20/0x20 [scsi_mod]
> 18.674: [  184.198705]  scsi_bus_resume_common+0x79/0x180 [scsi_mod]
> 18.674: [  184.238364] call phy0+ returned 0 after 44664 usecs
> 18.674: [  184.198705]  scsi_bus_resume+0x12/0x20 [scsi_mod]
> 18.674: [  184.198705]  dpm_run_callback+0x47/0x1b0
> 18.674: [  184.198705]  ? scsi_bus_thaw+0x20/0x20 [scsi_mod]
> 18.674: [  184.198705]  device_resume+0x97/0x190
> 18.674: [  184.269566] calling  usb3+ @ 727, parent: 0000:00:1d.1
> 18.674: [  184.198705]  ? device_resume+0x190/0x190
> 18.674: [  184.198705]  async_resume+0x1e/0x50
> 18.675: [  184.198705]  async_run_entry_fn+0x61/0x3a0
> 18.675: [  184.198705]  ? __schedule+0x2f5/0xcf0
> 18.675: [  184.198705]  ? try_to_wake_up+0x4d/0x790
> 18.675: [  184.198705]  ? __switch_to_asm+0x33/0x4c
> 18.675: [  184.291885] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> 18.675: [  184.198705]  ? pwq_dec_nr_in_flight+0x7c/0x150
> 18.675: [  184.198705]  process_one_work+0x235/0x690
> 18.675: [  184.198705]  worker_thread+0x19d/0x6a0
> 18.675: [  184.198705]  kthread+0x14a/0x1f0
> 18.675: [  184.198705]  ? process_one_work+0x690/0x690
> 18.675: [  184.198705]  ? kthread_create_worker_on_cpu+0x30/0x30
> 18.675: [  184.198705]  ret_from_fork+0x2e/0x38
> 18.675: [  184.198705] Code: 
> 18.675: [  184.303294] call usb2+ returned 0 after 141649 usecs
> 18.675: [  184.198705] 7e 8b 83 fc 00 00 00 e8 e0 32 53 00 8b b3 50 01 
> 18.675: [  184.315689] calling  usb4+ @ 118, parent: 0000:00:1d.2
> 18.675: [  184.198705] 00 00 31 c0 8b 3d 20 7d ea cd 89 83 54 01 00 00 81 fe 0c 
> 18.675: [  184.328767] call usb1+ returned 0 after 190866 usecs
> 18.675: [  184.198705] ff ff ff 89 7d ec 74 46 <89> be f4 00 00 00 ba 09 00 00 00 8b 83 50 01 00 00 e8 0b 25 24 
> 18.675: [  184.198705] EIP: blk_set_runtime_active+0x4f/0xc0 SS:ESP: 0068:f1afde24
> 18.675: [  184.198705] CR2: 00000000000000f4
> 18.675: [  184.336955] calling  2-6+ @ 6, parent: usb2
> 18.675: [  184.198705] ---[ end trace 94bb43426dd6105a ]---

> (gdb) disas blk_set_runtime_active
> Dump of assembler code for function blk_set_runtime_active:
>    0xc1518610 <+0>:	call   0xc106ac9c <__fentry__>
>    0xc1518615 <+5>:	push   %ebp
>    0xc1518616 <+6>:	mov    %esp,%ebp
>    0xc1518618 <+8>:	sub    $0x14,%esp
>    0xc151861b <+11>:	mov    %ebx,-0xc(%ebp)
>    0xc151861e <+14>:	mov    %eax,%ebx
>    0xc1518620 <+16>:	mov    %gs:0x14,%eax
>    0xc1518626 <+22>:	mov    %eax,-0x10(%ebp)
>    0xc1518629 <+25>:	xor    %eax,%eax
>    0xc151862b <+27>:	test   %ebx,%ebx
>    0xc151862d <+29>:	mov    %esi,-0x8(%ebp)
>    0xc1518630 <+32>:	mov    %edi,-0x4(%ebp)
>    0xc1518633 <+35>:	je     0xc15186b3 <blk_set_runtime_active+163>
>    0xc1518635 <+37>:	mov    0xfc(%ebx),%eax
>    0xc151863b <+43>:	call   0xc1a4b920 <_raw_spin_lock_irq>
>    0xc1518640 <+48>:	mov    0x150(%ebx),%esi
>    0xc1518646 <+54>:	xor    %eax,%eax
>    0xc1518648 <+56>:	mov    0xc1ca7d20,%edi
>    0xc151864e <+62>:	mov    %eax,0x154(%ebx)
>    0xc1518654 <+68>:	cmp    $0xffffff0c,%esi
>    0xc151865a <+74>:	mov    %edi,-0x14(%ebp)
>    0xc151865d <+77>:	je     0xc15186a5 <blk_set_runtime_active+149>
>    0xc151865f <+79>:	mov    %edi,0xf4(%esi)
>    0xc1518665 <+85>:	mov    $0x9,%edx
>    0xc151866a <+90>:	mov    0x150(%ebx),%eax
>    0xc1518670 <+96>:	call   0xc175ab80 <__pm_runtime_suspend>
>    0xc1518675 <+101>:	mov    0xfc(%ebx),%eax
>    0xc151867b <+107>:	call   *0xc1ce2918
>    0xc1518681 <+113>:	call   *0xc1ce2888
>    0xc1518687 <+119>:	mov    -0x10(%ebp),%eax
>    0xc151868a <+122>:	xor    %gs:0x14,%eax
>    0xc1518691 <+129>:	jne    0xc15186a0 <blk_set_runtime_active+144>
>    0xc1518693 <+131>:	mov    -0xc(%ebp),%ebx
>    0xc1518696 <+134>:	mov    -0x8(%ebp),%esi
>    0xc1518699 <+137>:	mov    -0x4(%ebp),%edi
>    0xc151869c <+140>:	mov    %ebp,%esp
>    0xc151869e <+142>:	pop    %ebp
>    0xc151869f <+143>:	ret    
>    0xc15186a0 <+144>:	call   0xc108c6c0 <__stack_chk_fail>
>    0xc15186a5 <+149>:	xor    %edx,%edx
>    0xc15186a7 <+151>:	mov    $0xc1ee14b4,%eax
>    0xc15186ac <+156>:	call   0xc15bb7f0 <__ubsan_handle_type_mismatch>
>    0xc15186b1 <+161>:	jmp    0xc151865f <blk_set_runtime_active+79>
>    0xc15186b3 <+163>:	xor    %edx,%edx
>    0xc15186b5 <+165>:	mov    $0xc1ee14cc,%eax
>    0xc15186ba <+170>:	call   0xc15bb7f0 <__ubsan_handle_type_mismatch>
>    0xc15186bf <+175>:	jmp    0xc1518635 <blk_set_runtime_active+37>
> End of assembler dump.


Kind regards,

Paul

--------------1D77A5019546E2FD3B843EA9
Content-Type: text/x-log;
 name="seriallog-20180424_225038.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="seriallog-20180424_225038.log"



======= Tue Apr 24 22:50:51 2018 (adjust=86.8us)
00.000: <00>
00.677: 
00.677: 
00.677: coreboot-TIMELESS Thu Jan  1 00:00:00 UTC 1970 romstage starting...
00.677: Dock is present
00.678: 
00.678: Mobile Intel(R) 82945GM/GME Express Chipset
00.678: (G)MCH capable of up to FSB 800 MHz
00.678: (G)MCH capable of up to DDR2-667
00.678: Setting up static southbridge registers... done.
00.678: Disabling Watchdog reboot... done.
00.678: Setting up static northbridge registers...CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.680: CBFS: Locating 'cmos_layout.bin'
00.681: CBFS: Found @ offset 39100 size 6ac
00.681:  done.
00.681: Waiting for MCHBAR to come up...ok
00.681: PM1_CNT: 00000000
00.681: SMBus controller enabled.
00.682: Setting up RAM controller.
00.682: This mainboard supports Dual Channel Operation.
00.741: Reading SPD using i2c block operation.
00.743: DDR II Channel 0 Socket 0: x8DDS
00.743: DIMM 0 side 0 = 512 MB
00.743: DIMM 0 side 1 = 512 MB
00.744: DDR II Channel 0 Socket 1: N/A
00.803: Reading SPD using i2c block operation.
00.803: DDR II Channel 1 Socket 0: x8DDS
00.803: DIMM 2 side 0 = 512 MB
00.803: DIMM 2 side 1 = 512 MB
00.804: DDR II Channel 1 Socket 1: N/A
00.804: Memory will be driven at 667MT with CAS=5 clocks
00.804: tRAS = 15 cycles
00.804: tRP  = 5 cycles
00.804: tRCD = 5 cycles
00.804: tWR  = 5 cycles
00.804: tRFC = 35 cycles
00.805: Refresh: 7.8us
00.805: Setting Graphics Frequency...
00.805: FSB: 667 MHz Voltage: 1.05V Render: 250MHz Display: 200MHz
00.805: Setting Memory Frequency... CLKCFG = 0x00010023, CLKCFG = 0x00010043, ok
00.805: Setting mode of operation for memory channels...Dual Channel Interleaved.
00.806: Programming Clock Crossing...MEM=667 FSB=667... ok
00.806: Setting RAM size...
00.807: C0DRB = 0x20202010
00.807: C1DRB = 0x20202010
00.807: TOLUD = 0x0080
00.807: Setting row attributes...
00.807: C0DRA = 0x0033
00.807: C1DRA = 0x0033
00.807: one dimm per channel config..
00.807: Initializing System Memory IO...
00.807: Programming Dual Channel RCOMP
00.807: Table Index: 18
00.808: Programming DLL Timings...
00.808: Enabling System Memory IO...
00.809: jedec enable sequence: bank 0
00.809: jedec enable sequence: bank 1
00.809: bankaddr from bank size of rank 0
00.809: jedec enable sequence: bank 4
00.809: jedec enable sequence: bank 5
00.809: bankaddr from bank size of rank 4
00.810: receive_enable_autoconfig() for channel 0
00.810:   find_strobes_low()
00.810:     set_receive_enable() medium=0x3, coarse=0x5
00.810:     set_receive_enable() medium=0x1, coarse=0x5
00.810:   find_strobes_edge()
00.810:     set_receive_enable() medium=0x1, coarse=0x5
00.811:   add_quarter_clock() mediumcoarse=15 fine=e0
00.811:     set_receive_enable() medium=0x3, coarse=0x5
00.811:   find_preamble()
00.811:     set_receive_enable() medium=0x3, coarse=0x4
00.811:     set_receive_enable() medium=0x3, coarse=0x3
00.811:   add_quarter_clock() mediumcoarse=0f fine=60
00.811:   normalize()
00.811:     set_receive_enable() medium=0x0, coarse=0x4
00.811: receive_enable_autoconfig() for channel 1
00.811:   find_strobes_low()
00.811:     set_receive_enable() medium=0x3, coarse=0x5
00.811:     set_receive_enable() medium=0x1, coarse=0x5
00.811:   find_strobes_edge()
00.811:     set_receive_enable() medium=0x1, coarse=0x5
00.811:   add_quarter_clock() mediumcoarse=15 fine=e1
00.811:     set_receive_enable() medium=0x3, coarse=0x5
00.811:   find_preamble()
00.811:     set_receive_enable() medium=0x3, coarse=0x4
00.811:     set_receive_enable() medium=0x3, coarse=0x3
00.811:   add_quarter_clock() mediumcoarse=0f fine=61
00.811:   normalize()
00.811:     set_receive_enable() medium=0x0, coarse=0x4
00.812: RAM initialization finished.
00.812: Setting up Egress Port RCRB
00.812: Loading port arbitration table ...ok
00.812: Wait for VC1 negotiation ...ok
00.812: Setting up DMI RCRB
00.812: Wait for VC1 negotiation ...done..
00.813: Internal graphics: enabled
00.813: Waiting for DMI hardware...ok
00.813: Enabling PCI Express x16 Link
00.813: SLOTSTS: 0000
00.813: Disabling PCI Express x16 Link
00.813: Wait for link to enter detect state... ok
00.813: Setting up Root Complex Topology
00.813: CBMEM:
00.814: IMD: root @ 7f7ff000 254 entries.
00.814: IMD: root @ 7f7fec00 62 entries.
00.822: MTRR Range: Start=ffe00000 End=0 (Size 200000)
00.822: MTRR Range: Start=0 End=1000000 (Size 1000000)
00.822: MTRR Range: Start=7f400000 End=7f800000 (Size 400000)
00.822: MTRR Range: Start=7f000000 End=7f400000 (Size 400000)
00.827: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.828: CBFS: Locating 'fallback/ramstage'
00.829: CBFS: Found @ offset 24340 size 147a9
00.829: Decompressing stage fallback/ramstage @ 0x7f789fc0 (252176 bytes)
00.888: Loading module at 7f78a000 with entry 7f78a000. filesize: 0x32a48 memsize: 0x3d8d0
00.888: Processing 2833 relocs. Offset value of 0x7f68a000
00.894: 
00.894: 
00.894: coreboot-TIMELESS Thu Jan  1 00:00:00 UTC 1970 ramstage starting...
00.894: Normal boot.
00.894: BS: BS_PRE_DEVICE times (us): entry 0 run 0 exit 0
00.894: BS: BS_DEV_INIT_CHIPS times (us): entry 0 run 1 exit 0
00.894: Enumerating buses...
00.894: CPU_CLUSTER: 0 enabled
00.894: DOMAIN: 0000 enabled
00.894: PCI: pci_scan_bus for bus 00
00.894: PCI: 00:00.0 [8086/27a0] enabled
00.894: PCI: 00:02.0 [8086/27a2] enabled
00.894: PCI: 00:02.1 [8086/27a6] enabled
00.894: PCI: 00:1b.0 [8086/27d8] enabled
00.894: PCI: 00:1c.0 [8086/27d0] enabled
00.894: PCI: 00:1c.1 [8086/27d2] enabled
00.894: PCI: 00:1c.2 [8086/27d4] enabled
00.894: PCI: 00:1c.3 [8086/27d6] enabled
00.894: PCI: 00:1d.0 [8086/27c8] enabled
00.894: PCI: 00:1d.1 [8086/27c9] enabled
00.894: PCI: 00:1d.2 [8086/27ca] enabled
00.894: PCI: 00:1d.3 [8086/27cb] enabled
00.894: PCI: 00:1d.7 [8086/27cc] enabled
00.894: PCI: 00:1e.0 [8086/2448] enabled
00.894: PCI: 00:1f.0 [8086/27b9] enabled
00.894: PCI: 00:1f.1 [8086/27df] enabled
00.894: Set SATA mode early
00.894: Set SATA mode early
00.894: PCI: 00:1f.2 [8086/27c5] enabled
00.894: PCI: 00:1f.3 [8086/27da] enabled
00.894: PCI: pci_scan_bus for bus 01
00.894: PCI: 01:00.0 [8086/109a] enabled
00.895: scan_bus: scanning of bus PCI: 00:1c.0 took 5653 usecs
00.895: PCI: pci_scan_bus for bus 02
00.895: PCI: 02:00.0 [8086/4227] enabled
00.895: scan_bus: scanning of bus PCI: 00:1c.1 took 5667 usecs
00.895: PCI: pci_scan_bus for bus 03
00.895: scan_bus: scanning of bus PCI: 00:1c.2 took 2674 usecs
00.895: PCI: pci_scan_bus for bus 04
00.895: scan_bus: scanning of bus PCI: 00:1c.3 took 2673 usecs
00.895: PCI: pci_scan_bus for bus 05
00.895: PCI: 05:00.0 [1180/0476] enabled
00.895: PCI: 05:00.1 [1180/0552] enabled
00.895: PCI: 05:00.2 [1180/0822] enabled
00.895: PCI: 05:00.3 [1180/0843] enabled
00.895: PCI: pci_scan_bus for bus 06
00.895: scan_bus: scanning of bus PCI: 05:00.0 took 2679 usecs
00.895: scan_bus: scanning of bus PCI: 00:1e.0 took 22164 usecs
00.895: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.895: CBFS: Locating 'cmos_layout.bin'
00.895: CBFS: Found @ offset 39100 size 6ac
00.895: WARNING: No CMOS option 'touchpad'.
00.895: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.895: CBFS: Locating 'cmos_layout.bin'
00.895: CBFS: Found @ offset 39100 size 6ac
00.896: PMH7: ID 03 Revision 10
00.896: PNP: 00ff.1 enabled
00.897: EC Firmware ID 7JHT12WW-3.4, Version 3.01A
00.898: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.898: CBFS: Locating 'cmos_layout.bin'
00.898: CBFS: Found @ offset 39100 size 6ac
00.898: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.898: CBFS: Locating 'cmos_layout.bin'
00.898: CBFS: Found @ offset 39100 size 6ac
00.901: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.901: CBFS: Locating 'cmos_layout.bin'
00.901: CBFS: Found @ offset 39100 size 6ac
00.902: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.902: CBFS: Locating 'cmos_layout.bin'
00.902: CBFS: Found @ offset 39100 size 6ac
00.902: H8: BDC not installed
00.902: H8: WWAN detection not implemented. Assuming WWAN installed
00.902: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.903: CBFS: Locating 'cmos_layout.bin'
00.902: CBFS: Found @ offset 39100 size 6ac
00.903: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.903: CBFS: Locating 'cmos_layout.bin'
00.903: CBFS: Found @ offset 39100 size 6ac
00.903: WARNING: No CMOS option 'fn_ctrl_swap'.
00.903: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.903: CBFS: Locating 'cmos_layout.bin'
00.903: CBFS: Found @ offset 39100 size 6ac
00.904: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.904: CBFS: Locating 'cmos_layout.bin'
00.904: CBFS: Found @ offset 39100 size 6ac
00.904: PNP: 00ff.2 enabled
00.904: PNP: 164e.2 enabled
00.904: PNP: 164e.3 enabled
00.904: PNP: 164e.7 enabled
00.904: PNP: 164e.19 enabled
00.904: PNP: 002e.0 disabled
00.904: PNP: 002e.1 enabled
00.905: PNP: 002e.2 disabled
00.905: PNP: 002e.3 enabled
00.905: PNP: 002e.7 enabled
00.905: PNP: 002e.a disabled
00.905: scan_bus: scanning of bus PCI: 00:1f.0 took 166453 usecs
00.905: bus: PCI: 00:1f.3[0]->I2C: 01:69 enabled
00.905: bus: PCI: 00:1f.3[0]->I2C: 01:54 enabled
00.905: bus: PCI: 00:1f.3[0]->I2C: 01:55 enabled
00.905: bus: PCI: 00:1f.3[0]->I2C: 01:56 enabled
00.905: bus: PCI: 00:1f.3[0]->I2C: 01:57 enabled
00.905: bus: PCI: 00:1f.3[0]->I2C: 01:5c enabled
00.905: bus: PCI: 00:1f.3[0]->I2C: 01:5d enabled
00.905: bus: PCI: 00:1f.3[0]->I2C: 01:5e enabled
00.905: bus: PCI: 00:1f.3[0]->I2C: 01:5f enabled
00.905: scan_bus: scanning of bus PCI: 00:1f.3 took 33206 usecs
00.905: scan_bus: scanning of bus DOMAIN: 0000 took 333087 usecs
00.905: scan_bus: scanning of bus Root Device took 342187 usecs
00.905: done
00.905: BS: BS_DEV_ENUMERATE times (us): entry 0 run 349669 exit 0
00.905: found VGA at PCI: 00:02.0
00.905: Setting up VGA for PCI: 00:02.0
00.905: Setting PCI_BRIDGE_CTL_VGA for bridge DOMAIN: 0000
00.905: Setting PCI_BRIDGE_CTL_VGA for bridge Root Device
00.905: Allocating resources...
00.905: Reading resources...
00.905: Adding PCIe enhanced config space BAR 0xf0000000-0xf4000000.
00.906: PNP: 00ff.1 missing read_resources
00.906: PNP: 00ff.2 missing read_resources
00.906: Done reading resources.
00.907: skipping PNP: 00ff.2@60 fixed resource, size=0!
00.907: skipping PNP: 00ff.2@62 fixed resource, size=0!
00.907: skipping PNP: 00ff.2@64 fixed resource, size=0!
00.907: skipping PNP: 00ff.2@66 fixed resource, size=0!
00.907: skipping PNP: 164e.3@29 fixed resource, size=0!
00.907: skipping PNP: 164e.3@f0 fixed resource, size=0!
00.907: Setting resources...
00.907: pci_tolm: 0xd0000000
00.907: IGD decoded, subtracting 8M UMA
00.907: Available memory: 2088960K (2040M)
00.907: PCI: 00:02.0 10 <- [0x00e4300000 - 0x00e437ffff] size 0x00080000 gran 0x13 mem
00.907: PCI: 00:02.0 14 <- [0x00000050b0 - 0x00000050b7] size 0x00000008 gran 0x03 io
00.907: PCI: 00:02.0 18 <- [0x00d0000000 - 0x00dfffffff] size 0x10000000 gran 0x1c prefmem
00.907: PCI: 00:02.0 1c <- [0x00e4400000 - 0x00e443ffff] size 0x00040000 gran 0x12 mem
00.907: PCI: 00:02.1 10 <- [0x00e4380000 - 0x00e43fffff] size 0x00080000 gran 0x13 mem
00.907: PCI: 00:1b.0 10 <- [0x00e4440000 - 0x00e4443fff] size 0x00004000 gran 0x0e mem64
00.907: PCI: 00:1c.0 1c <- [0x0000004000 - 0x0000004fff] size 0x00001000 gran 0x0c bus 01 io
00.907: PCI: 00:1c.0 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 01 prefmem
00.907: PCI: 00:1c.0 20 <- [0x00e4100000 - 0x00e41fffff] size 0x00100000 gran 0x14 bus 01 mem
00.907: PCI: 01:00.0 10 <- [0x00e4100000 - 0x00e411ffff] size 0x00020000 gran 0x11 mem
00.907: PCI: 01:00.0 18 <- [0x0000004000 - 0x000000401f] size 0x00000020 gran 0x05 io
00.907: PCI: 00:1c.1 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 gran 0x0c bus 02 io
00.907: PCI: 00:1c.1 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 02 prefmem
00.907: PCI: 00:1c.1 20 <- [0x00e4200000 - 0x00e42fffff] size 0x00100000 gran 0x14 bus 02 mem
00.907: PCI: 02:00.0 10 <- [0x00e4200000 - 0x00e4200fff] size 0x00001000 gran 0x0c mem
00.907: PCI: 00:1c.2 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 gran 0x0c bus 03 io
00.907: PCI: 00:1c.2 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 03 prefmem
00.907: PCI: 00:1c.2 20 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 03 mem
00.907: PCI: 00:1c.3 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 gran 0x0c bus 04 io
00.907: PCI: 00:1c.3 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 04 prefmem
00.907: PCI: 00:1c.3 20 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 04 mem
00.907: PCI: 00:1d.0 20 <- [0x0000005000 - 0x000000501f] size 0x00000020 gran 0x05 io
00.907: PCI: 00:1d.1 20 <- [0x0000005020 - 0x000000503f] size 0x00000020 gran 0x05 io
00.907: PCI: 00:1d.2 20 <- [0x0000005040 - 0x000000505f] size 0x00000020 gran 0x05 io
00.907: PCI: 00:1d.3 20 <- [0x0000005060 - 0x000000507f] size 0x00000020 gran 0x05 io
00.907: PCI: 00:1d.7 10 <- [0x00e4444000 - 0x00e44443ff] size 0x00000400 gran 0x0a mem
00.907: PCI: 00:1e.0 1c <- [0x0000002000 - 0x0000003fff] size 0x00002000 gran 0x0c bus 05 io
00.907: PCI: 00:1e.0 24 <- [0x00e2100000 - 0x00e40fffff] size 0x02000000 gran 0x14 bus 05 prefmem
00.907: PCI: 00:1e.0 20 <- [0x00e0000000 - 0x00e20fffff] size 0x02100000 gran 0x14 bus 05 mem
00.907: PCI: 05:00.0 In set resources
00.907: PCI: 05:00.0 10 <- [0x00e2000000 - 0x00e2000fff] size 0x00001000 gran 0x0c mem
00.907: PCI: 05:00.0 2c <- [0x0000002000 - 0x0000002fff] size 0x00001000 gran 0x02 io
00.907: PCI: 05:00.0 34 <- [0x0000003000 - 0x0000003fff] size 0x00001000 gran 0x02 io
00.907: PCI: 05:00.0 1c <- [0x00e2100000 - 0x00e40fffff] size 0x02000000 gran 0x0c prefmem
00.907: PCI: 05:00.0 24 <- [0x00e0000000 - 0x00e1ffffff] size 0x02000000 gran 0x0c mem
00.907: PCI: 05:00.1 10 <- [0x00e2001000 - 0x00e20017ff] size 0x00000800 gran 0x0b mem
00.907: PCI: 05:00.2 10 <- [0x00e2002000 - 0x00e20020ff] size 0x00000100 gran 0x08 mem
00.907: PCI: 05:00.3 10 <- [0x00e2003000 - 0x00e20030ff] size 0x00000100 gran 0x08 mem
00.907: PNP: 00ff.1 missing set_resources
00.907: PNP: 00ff.2 missing set_resources
00.907: PNP: 164e.2 60 <- [0x00000002f8 - 0x00000002ff] size 0x00000008 gran 0x03 io
00.907: ERROR: PNP: 164e.2 70 irq size: 0x0000000001 not assigned
00.907: ERROR: PNP: 164e.2 74 drq size: 0x0000000001 not assigned
00.907: ERROR: PNP: 164e.2 75 drq size: 0x0000000001 not assigned
00.907: PNP: 164e.3 60 <- [0x0000000200 - 0x0000000207] size 0x00000008 gran 0x03 io
00.907: PNP: 164e.3 29 <- [0x00000000b0 - 0x00000000af] size 0x00000000 gran 0x00 irq
00.907: PNP: 164e.3 70 <- [0x0000000005 - 0x0000000005] size 0x00000001 gran 0x00 irq
00.907: PNP: 164e.3 f0 <- [0x0000000082 - 0x0000000081] size 0x00000000 gran 0x00 irq
00.907: PNP: 164e.7 60 <- [0x0000001680 - 0x000000168f] size 0x00000010 gran 0x04 io
00.907: ERROR: PNP: 164e.7 70 irq size: 0x0000000001 not assigned
00.907: PNP: 164e.19 60 <- [0x000000164c - 0x000000164d] size 0x00000002 gran 0x01 io
00.907: ERROR: PNP: 164e.19 70 irq size: 0x0000000001 not assigned
00.907: PNP: 002e.1 60 <- [0x00000003bc - 0x00000007bb] size 0x00000400 gran 0x0a io
00.907: PNP: 002e.1 70 <- [0x0000000007 - 0x0000000007] size 0x00000001 gran 0x00 irq
00.907: ERROR: PNP: 002e.1 74 drq size: 0x0000000001 not assigned
00.907: PNP: 002e.3 60 <- [0x00000003f8 - 0x00000003ff] size 0x00000008 gran 0x03 io
00.907: PNP: 002e.3 70 <- [0x0000000004 - 0x0000000004] size 0x00000001 gran 0x00 irq
00.907: PNP: 002e.7 60 <- [0x0000001620 - 0x0000001627] size 0x00000008 gran 0x03 io
00.907: ERROR: PNP: 002e.7 70 irq size: 0x0000000001 not assigned
00.907: PCI: 00:1f.1 10 <- [0x00000050b8 - 0x00000050bf] size 0x00000008 gran 0x03 io
00.907: PCI: 00:1f.1 14 <- [0x00000050d8 - 0x00000050db] size 0x00000004 gran 0x02 io
00.907: PCI: 00:1f.1 18 <- [0x00000050c0 - 0x00000050c7] size 0x00000008 gran 0x03 io
00.907: PCI: 00:1f.1 1c <- [0x00000050dc - 0x00000050df] size 0x00000004 gran 0x02 io
00.907: PCI: 00:1f.1 20 <- [0x00000050a0 - 0x00000050af] size 0x00000010 gran 0x04 io
00.907: PCI: 00:1f.2 10 <- [0x00000050c8 - 0x00000050cf] size 0x00000008 gran 0x03 io
00.907: PCI: 00:1f.2 14 <- [0x00000050e0 - 0x00000050e3] size 0x00000004 gran 0x02 io
00.907: PCI: 00:1f.2 18 <- [0x00000050d0 - 0x00000050d7] size 0x00000008 gran 0x03 io
00.907: PCI: 00:1f.2 1c <- [0x00000050e4 - 0x00000050e7] size 0x00000004 gran 0x02 io
00.907: PCI: 00:1f.2 20 <- [0x0000005080 - 0x000000509f] size 0x00000020 gran 0x05 io
00.907: PCI: 00:1f.2 24 <- [0x00e4445000 - 0x00e44453ff] size 0x00000400 gran 0x0a mem
00.907: Done setting resources.
00.907: Done allocating resources.
00.907: BS: BS_DEV_RESOURCES times (us): entry 0 run 546659 exit 0
00.907: Enabling resources...
00.907: PCI: 00:00.0 subsystem <- 17aa/2017
00.907: PCI: 00:00.0 cmd <- 06
00.907: PCI: 00:02.0 subsystem <- 17aa/201a
00.907: PCI: 00:02.0 cmd <- 03
00.907: PCI: 00:02.1 subsystem <- 17aa/201a
00.907: PCI: 00:02.1 cmd <- 02
00.907: PCI: 00:1b.0 subsystem <- 17aa/2010
00.907: PCI: 00:1b.0 cmd <- 102
00.907: PCI: 00:1c.0 bridge ctrl <- 0003
00.907: PCI: 00:1c.0 subsystem <- 8086/27d0
00.908: PCI: 00:1c.0 cmd <- 107
00.908: PCI: 00:1c.1 bridge ctrl <- 0003
00.907: PCI: 00:1c.1 subsystem <- 8086/27d2
00.908: PCI: 00:1c.1 cmd <- 106
00.908: PCI: 00:1c.2 bridge ctrl <- 0003
00.908: PCI: 00:1c.2 cmd <- 00
00.908: PCI: 00:1c.3 bridge ctrl <- 0003
00.908: PCI: 00:1c.3 cmd <- 00
00.908: PCI: 00:1d.0 subsystem <- 17aa/200a
00.908: PCI: 00:1d.0 cmd <- 01
00.908: PCI: 00:1d.1 subsystem <- 17aa/200a
00.908: PCI: 00:1d.1 cmd <- 01
00.908: PCI: 00:1d.2 subsystem <- 17aa/200a
00.908: PCI: 00:1d.2 cmd <- 01
00.908: PCI: 00:1d.3 subsystem <- 17aa/200a
00.908: PCI: 00:1d.3 cmd <- 01
00.908: PCI: 00:1d.7 subsystem <- 17aa/200b
00.908: PCI: 00:1d.7 cmd <- 102
00.908: PCI: 00:1e.0 bridge ctrl <- 0003
00.908: PCI: 00:1e.0 cmd <- 07
00.908: PCI: 00:1f.0 subsystem <- 17aa/2009
00.908: PCI: 00:1f.0 cmd <- 107
00.908: PCI: 00:1f.1 subsystem <- 17aa/200c
00.908: PCI: 00:1f.1 cmd <- 01
00.908: PCI: 00:1f.2 subsystem <- 17aa/200d
00.908: PCI: 00:1f.2 cmd <- 03
00.908: PCI: 00:1f.3 subsystem <- 17aa/200f
00.908: PCI: 00:1f.3 cmd <- 101
00.908: PCI: 01:00.0 cmd <- 03
00.908: PCI: 02:00.0 cmd <- 02
00.908: PCI: 05:00.0 bridge ctrl <- 0503
00.908: PCI: 05:00.0 cmd <- 03
00.908: PCI: 05:00.1 cmd <- 02
00.908: PCI: 05:00.2 cmd <- 06
00.908: PCI: 05:00.3 cmd <- 06
00.908: done.
00.908: BS: BS_DEV_ENABLE times (us): entry 0 run 120210 exit 0
00.908: Initializing devices...
00.908: Root Device init ...
00.909: Root Device init finished in 2592 usecs
00.909: CPU_CLUSTER: 0 init ...
00.909: start_eip=0x00001000, code_size=0x00000031
00.909: Initializing SMM handler...
00.910: SMI_STS: MCSMI PM1 
00.910: PM1_STS: PRBTNOR PWRBTN 
00.910: GPE0_STS: GPIO15 GPIO14 GPIO13 GPIO12 GPIO11 GPIO10 GPIO8 GPIO7 GPIO6 GPIO5 GPIO4 GPIO3 GPIO2 GPIO1 GPIO0 
00.910: ALT_GP_SMI_STS: GPI15 GPI14 GPI13 GPI12 GPI11 GPI10 GPI8 GPI7 GPI6 GPI5 GPI4 GPI3 GPI2 GPI1 GPI0 
00.910: TCO_STS: INTRD_DET 
00.910: Initializing CPU #0
00.910: CPU: vendor Intel device 6ec
00.910: CPU: family 06, model 0e, stepping 0c
00.910: Enabling cache
00.911: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.911: CBFS: Locating 'cpu_microcode_blob.bin'
00.911: CBFS: Found @ offset d2c0 size 17000
00.911: microcode: sig=0x6ec pf=0x20 revision=0x0
00.912: microcode: updated to revision 0x54 date=2006-05-01
00.912: CPU: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz.
00.912: MTRR: Physical address space:
00.912: 0x0000000000000000 - 0x00000000000a0000 size 0x000a0000 type 6
00.912: 0x00000000000a0000 - 0x00000000000c0000 size 0x00020000 type 0
00.912: 0x00000000000c0000 - 0x000000007f800000 size 0x7f740000 type 6
00.912: 0x000000007f800000 - 0x00000000d0000000 size 0x50800000 type 0
00.912: 0x00000000d0000000 - 0x00000000e0000000 size 0x10000000 type 1
00.912: 0x00000000e0000000 - 0x0000000100000000 size 0x20000000 type 0
00.912: MTRR: Fixed MSR 0x250 0x0606060606060606
00.912: MTRR: Fixed MSR 0x258 0x0606060606060606
00.912: MTRR: Fixed MSR 0x259 0x0000000000000000
00.912: MTRR: Fixed MSR 0x268 0x0606060606060606
00.912: MTRR: Fixed MSR 0x269 0x0606060606060606
00.912: MTRR: Fixed MSR 0x26a 0x0606060606060606
00.912: MTRR: Fixed MSR 0x26b 0x0606060606060606
00.912: MTRR: Fixed MSR 0x26c 0x0606060606060606
00.912: MTRR: Fixed MSR 0x26d 0x0606060606060606
00.912: MTRR: Fixed MSR 0x26e 0x0606060606060606
00.912: MTRR: Fixed MSR 0x26f 0x0606060606060606
00.913: CPU physical address size: 32 bits
00.913: MTRR: default type WB/UC MTRR counts: 5/3.
00.913: MTRR: UC selected as default type.
00.913: MTRR: 0 base 0x0000000000000000 mask 0x0000000080000000 type 6
00.913: MTRR: 1 base 0x000000007f800000 mask 0x00000000ff800000 type 0
00.913: MTRR: 2 base 0x00000000d0000000 mask 0x00000000f0000000 type 1
00.914: 
00.914: MTRR check
00.914: Fixed MTRRs   : Enabled
00.914: Variable MTRRs: Enabled
00.914: 
00.914: Setting up local APIC... apic_id: 0x00 done.
00.914: VMX status: enabled, locked
00.914: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.914: CBFS: Locating 'cmos_layout.bin'
00.915: CBFS: Found @ offset 39100 size 6ac
00.915: CPU: 0 2 siblings
00.915: CPU: 0 has sibling 1
00.915: CPU #0 initialized
00.927: Initializing CPU #1
00.927: Waiting for 1 CPUS to stop
00.927: CPU: vendor Intel device 6ec
00.927: CPU: family 06, model 0e, stepping 0c
00.927: Enabling cache
00.927: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.927: CBFS: Locating 'cpu_microcode_blob.bin'
00.927: CBFS: Found @ offset d2c0 size 17000
00.927: microcode: sig=0x6ec pf=0x20 revision=0x0
00.930: microcode: updated to revision 0x54 date=2006-05-01
00.930: CPU: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz.
00.930: MTRR: Fixed MSR 0x250 0x0606060606060606
00.930: MTRR: Fixed MSR 0x258 0x0606060606060606
00.930: MTRR: Fixed MSR 0x259 0x0000000000000000
00.930: MTRR: Fixed MSR 0x268 0x0606060606060606
00.930: MTRR: Fixed MSR 0x269 0x0606060606060606
00.930: MTRR: Fixed MSR 0x26a 0x0606060606060606
00.931: MTRR: Fixed MSR 0x26b 0x0606060606060606
00.931: MTRR: Fixed MSR 0x26c 0x0606060606060606
00.931: MTRR: Fixed MSR 0x26d 0x0606060606060606
00.931: MTRR: Fixed MSR 0x26e 0x0606060606060606
00.931: MTRR: Fixed MSR 0x26f 0x0606060606060606
00.932: CPU physical address size: 32 bits
00.933: 
00.933: MTRR check
00.933: Fixed MTRRs   : Enabled
00.933: Variable MTRRs: Enabled
00.933: 
00.933: Setting up local APIC... apic_id: 0x01 done.
00.933: VMX status: enabled, locked
00.933: CPU: 1 2 siblings
00.933: CPU #1 initialized
00.933: CPU 1 going down...
00.933: All AP CPUs stopped (9741 loops)
00.933: CPU_CLUSTER: 0 init finished in 324528 usecs
00.933: PCI: 00:02.0 init ...
00.933: Initializing VGA without OPROM.
00.997: No display connected on slave 2
01.012: WARNING: EDID block does NOT fully conform to EDID 1.3.
01.012: <09>Missing name descriptor
01.012: <09>Missing monitor ranges
01.012: bringing up panel at resolution 1024 x 768
01.012: Borders 0 x 0
01.012: Blank 320 x 38
01.012: Sync 136 x 6
01.012: Front porch 24 x 3
01.012: Spread spectrum clock
01.012: Single channel
01.012: Polarities 1, 1
01.013: Pixel N=3, M1=15, M2=4, P1=2
01.012: Pixel clock 65000 kHz
01.012: VGA mode: text
01.020: waiting for panel powerup
01.019: panel powered up
01.019: gtt_setup is enabled.
01.019: 8M UMA
01.020: GTT PGETBL_CTL register: 0x7ffc0001
01.020: GTT Enabled
01.023: PCI: 00:02.0 init finished in 139579 usecs
01.023: PCI: 00:02.1 init ...
01.023: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.023: CBFS: Locating 'cmos_layout.bin'
01.024: CBFS: Found @ offset 39100 size 6ac
01.024: PCI: 00:02.1 init finished in 14413 usecs
01.024: PCI: 00:1b.0 init ...
01.025: Azalia: codec type: Azalia
01.025: Azalia: base = e4440000
01.027: Azalia: codec_mask = 03
01.027: Azalia: Initializing codec #1
01.027: Azalia: codec viddid: 14f12bfa
01.027: Azalia: No verb!
01.027: Azalia: Initializing codec #0
01.027: Azalia: codec viddid: 11d41981
01.027: Azalia: verb_size: 44
01.029: Azalia: verb loaded.
01.029: PCI: 00:1b.0 init finished in 30349 usecs
01.029: PCI: 00:1c.0 init ...
01.029: Initializing ICH7 PCIe bridge.
01.029: PCI: 00:1c.0 init finished in 4838 usecs
01.029: PCI: 00:1c.1 init ...
01.029: Initializing ICH7 PCIe bridge.
01.029: PCI: 00:1c.1 init finished in 4840 usecs
01.029: PCI: 00:1c.2 init ...
01.029: Initializing ICH7 PCIe bridge.
01.029: PCI: 00:1c.2 init finished in 4839 usecs
01.029: PCI: 00:1c.3 init ...
01.030: Initializing ICH7 PCIe bridge.
01.030: PCI: 00:1c.3 init finished in 4839 usecs
01.030: PCI: 00:1d.0 init ...
01.030: UHCI: Setting up controller.. done.
01.030: PCI: 00:1d.0 init finished in 5272 usecs
01.030: PCI: 00:1d.1 init ...
01.030: UHCI: Setting up controller.. done.
01.030: PCI: 00:1d.1 init finished in 5271 usecs
01.030: PCI: 00:1d.2 init ...
01.030: UHCI: Setting up controller.. done.
01.030: PCI: 00:1d.2 init finished in 5272 usecs
01.030: PCI: 00:1d.3 init ...
01.030: UHCI: Setting up controller.. done.
01.030: PCI: 00:1d.3 init finished in 5273 usecs
01.030: PCI: 00:1d.7 init ...
01.030: EHCI: Setting up controller.. done.
01.030: PCI: 00:1d.7 init finished in 5282 usecs
01.030: PCI: 00:1e.0 init ...
01.030: PCI: 00:1e.0 init finished in 2029 usecs
01.030: PCI: 00:1f.0 init ...
01.030: i82801gx: lpc_init
01.030: IOAPIC: Initializing IOAPIC at 0xfec00000
01.030: IOAPIC: Bootstrap Processor Local APIC = 0x00
01.030: IOAPIC: ID = 0x02
01.030: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.030: CBFS: Locating 'cmos_layout.bin'
01.030: CBFS: Found @ offset 39100 size 6ac
01.031: WARNING: No CMOS option 'power_on_after_fail'.
01.031: Set power on after power failure.
01.031: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.031: CBFS: Locating 'cmos_layout.bin'
01.031: CBFS: Found @ offset 39100 size 6ac
01.031: NMI sources enabled.
01.031: rtc_failed = 0x0
01.031: RTC Init
01.032: Disabling ACPI via APMC:
01.033: done.
01.033: Locking SMM.
01.033: PCI: 00:1f.0 init finished in 54893 usecs
01.033: PCI: 00:1f.1 init ...
01.033: i82801gx_ide: initializing... IDE0
01.033: PCI: 00:1f.1 init finished in 5203 usecs
01.033: PCI: 00:1f.2 init ...
01.033: i82801gx_sata: initializing...
01.033: SATA controller in AHCI mode.
01.033: PCI: 00:1f.2 init finished in 7552 usecs
01.033: PCI: 01:00.0 init ...
01.033: PCI: 01:00.0 init finished in 2017 usecs
01.033: PCI: 02:00.0 init ...
01.033: PCI: 02:00.0 init finished in 2018 usecs
01.033: PCI: 05:00.0 init ...
01.033: Ricoh RL5c476: Initializing.
01.033: CF Base = 0
01.033: CF boot not enabled.
01.033: PCI: 05:00.0 init finished in 7726 usecs
01.033: PCI: 05:00.1 init ...
01.033: PCI: 05:00.1 init finished in 2018 usecs
01.033: PCI: 05:00.2 init ...
01.033: PCI: 05:00.2 init finished in 2018 usecs
01.033: PCI: 05:00.3 init ...
01.033: PCI: 05:00.3 init finished in 2018 usecs
01.033: PNP: 00ff.2 init ...
01.033: PNP: 00ff.2 init finished in 1931 usecs
01.033: PNP: 164e.2 init ...
01.033: PNP: 164e.2 init finished in 1930 usecs
01.033: PNP: 164e.3 init ...
01.033: PNP: 164e.3 init finished in 1931 usecs
01.033: PNP: 164e.7 init ...
01.033: PNP: 164e.7 init finished in 1930 usecs
01.033: PNP: 164e.19 init ...
01.033: PNP: 164e.19 init finished in 2018 usecs
01.033: PNP: 002e.1 init ...
01.033: PNP: 002e.1 init finished in 1932 usecs
01.033: PNP: 002e.3 init ...
01.033: PNP: 002e.3 init finished in 1930 usecs
01.033: PNP: 002e.7 init ...
01.033: PNP: 002e.7 init finished in 1932 usecs
01.033: smbus: PCI: 00:1f.3[0]->I2C: 01:69 init ...
01.047: Changing 12 of the 12 ck505 config bytes.
01.059: I2C: 01:69 init finished in 33862 usecs
01.059: smbus: PCI: 00:1f.3[0]->I2C: 01:54 init ...
01.059: I2C: 01:54 init finished in 3940 usecs
01.059: smbus: PCI: 00:1f.3[0]->I2C: 01:55 init ...
01.059: I2C: 01:55 init finished in 3940 usecs
01.059: smbus: PCI: 00:1f.3[0]->I2C: 01:56 init ...
01.059: I2C: 01:56 init finished in 3940 usecs
01.059: smbus: PCI: 00:1f.3[0]->I2C: 01:57 init ...
01.060: I2C: 01:57 init finished in 3940 usecs
01.060: smbus: PCI: 00:1f.3[0]->I2C: 01:5c init ...
01.060: Locking EEPROM RFID
01.081: init EEPROM done
01.081: I2C: 01:5c init finished in 28962 usecs
01.081: smbus: PCI: 00:1f.3[0]->I2C: 01:5d init ...
01.081: I2C: 01:5d init finished in 3939 usecs
01.081: smbus: PCI: 00:1f.3[0]->I2C: 01:5e init ...
01.081: I2C: 01:5e init finished in 3939 usecs
01.081: smbus: PCI: 00:1f.3[0]->I2C: 01:5f init ...
01.081: I2C: 01:5f init finished in 3939 usecs
01.081: Devices initialized
01.081: BS: BS_DEV_INIT times (us): entry 7 run 903793 exit 0
01.081: Finalize devices...
01.081: Devices finalized
01.081: BS: BS_POST_DEVICE times (us): entry 0 run 3507 exit 0
01.081: BS: BS_OS_RESUME_CHECK times (us): entry 0 run 0 exit 0
01.081: Copying Interrupt Routing Table to 0x000f0000... done.
01.081: Copying Interrupt Routing Table to 0x7f732000... done.
01.081: PIRQ table: 272 bytes.
01.081: Wrote the mp table end at: 000f0410 - 000f05cc
01.081: Wrote the mp table end at: 7f731010 - 7f7311cc
01.082: MP table: 460 bytes.
01.082: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.081: CBFS: Locating 'fallback/dsdt.aml'
01.082: CBFS: Found @ offset 39800 size 300e
01.082: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.082: CBFS: Locating 'fallback/slic'
01.082: CBFS: 'fallback/slic' not found.
01.082: ACPI: Writing ACPI tables at 7f70d000.
01.083: ACPI:    * FACS
01.082: ACPI:    * DSDT
01.089: ACPI:    * FADT
01.089: ACPI: added table 1/32, length now 40
01.089: ACPI:     * SSDT
01.115: Lenovo P/N is 636338U
01.115: Lenovo P/N 636338U is a tablet
01.115: Found 1 CPU(s) with 2 core(s) each.
01.115: clocks between 1000 and 1666 MHz.
01.115: adding 3 P-States between busratio 6 and a, incl. P0
01.115: PSS: 1666MHz power 31000 control 0xa1b status 0xa1b
01.115: PSS: 1333MHz power 22050 control 0x817 status 0x817
01.115: PSS: 1000MHz power 13100 control 0x613 status 0x613
01.115: clocks between 1000 and 1666 MHz.
01.115: adding 3 P-States between busratio 6 and a, incl. P0
01.115: PSS: 1666MHz power 31000 control 0xa1b status 0xa1b
01.115: PSS: 1333MHz power 22050 control 0x817 status 0x817
01.115: PSS: 1000MHz power 13100 control 0x613 status 0x613
01.115: ACPI: added table 2/32, length now 44
01.115: ACPI:    * MCFG
01.115: ACPI: added table 3/32, length now 48
01.115: ACPI:    * TCPA
01.115: TCPA log created at 7f6fd000
01.115: ACPI: added table 4/32, length now 52
01.115: ACPI:    * MADT
01.115: ACPI: added table 5/32, length now 56
01.115: current = 7f710a00
01.115: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.115: CBFS: Locating 'vbt.bin'
01.115: CBFS: 'vbt.bin' not found.
01.115: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.115: CBFS: Locating 'pci8086,27a2.rom'
01.116: CBFS: 'pci8086,27a2.rom' not found.
01.116: PCI Option ROM loading disabled for PCI: 00:02.0
01.116: GMA: locate_vbt_vbios: aa55 8086 0 0 3
01.116: GMA: Found valid VBT in legacy area
01.116: ACPI:    * HPET
01.116: ACPI: added table 6/32, length now 60
01.116: ACPI: done.
01.116: ACPI tables: 23104 bytes.
01.116: smbios_write_tables: 7f6fc000
01.279: Root Device (LENOVO ThinkPad X60)
01.279: CPU_CLUSTER: 0 (Intel i945 Northbridge)
01.280: APIC: 00 (unknown)
01.280: DOMAIN: 0000 (Intel i945 Northbridge)
01.280: PCI: 00:00.0 (Intel i945 Northbridge)
01.280: PCI: 00:02.0 (Intel i945 Northbridge)
01.280: PCI: 00:02.1 (Intel i945 Northbridge)
01.280: PCI: 00:1b.0 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PCI: 00:1c.0 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PCI: 00:1c.1 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PCI: 00:1d.0 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PCI: 00:1d.1 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PCI: 00:1d.2 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PCI: 00:1d.3 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PCI: 00:1d.7 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PCI: 00:1f.0 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PNP: 00ff.1 (Lenovo Power Management Hardware Hub 7)
01.280: PNP: 00ff.2 (Lenovo H8 EC)
01.280: PNP: 164e.2 (NSC PC87382 Docking LPC Switch)
01.280: PNP: 164e.3 (NSC PC87382 Docking LPC Switch)
01.280: PNP: 164e.7 (NSC PC87382 Docking LPC Switch)
01.280: PNP: 164e.19 (NSC PC87382 Docking LPC Switch)
01.280: PNP: 002e.0 (NSC PC87392 Super I/O)
01.280: PNP: 002e.1 (NSC PC87392 Super I/O)
01.280: PNP: 002e.2 (NSC PC87392 Super I/O)
01.280: PNP: 002e.3 (NSC PC87392 Super I/O)
01.280: PNP: 002e.7 (NSC PC87392 Super I/O)
01.280: PNP: 002e.a (NSC PC87392 Super I/O)
01.280: PCI: 00:1f.1 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PCI: 00:1f.2 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: PCI: 00:1f.3 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.280: I2C: 01:69 (CK505 Clock generator)
01.280: I2C: 01:54 (AT24RF08C)
01.280: I2C: 01:55 (AT24RF08C)
01.280: I2C: 01:56 (AT24RF08C)
01.280: I2C: 01:57 (AT24RF08C)
01.280: I2C: 01:5c (AT24RF08C)
01.280: I2C: 01:5d (AT24RF08C)
01.280: I2C: 01:5e (AT24RF08C)
01.280: I2C: 01:5f (AT24RF08C)
01.280: PCI: 00:1c.2 (unknown)
01.280: PCI: 00:1c.3 (unknown)
01.280: PCI: 00:1e.0 (unknown)
01.280: PCI: 01:00.0 (unknown)
01.280: PCI: 02:00.0 (unknown)
01.280: PCI: 05:00.0 (unknown)
01.280: PCI: 05:00.1 (unknown)
01.280: PCI: 05:00.2 (unknown)
01.280: PCI: 05:00.3 (unknown)
01.280: APIC: 01 (unknown)
01.280: SMBIOS tables: 438 bytes.
01.280: Writing table forward entry at 0x00000500
01.280: Wrote coreboot table at: 00000500, 0x10 bytes, checksum 506b
01.280: Writing coreboot table at 0x7f733000
01.280: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.280: CBFS: Locating 'cmos_layout.bin'
01.280: CBFS: Found @ offset 39100 size 6ac
01.281:  0. 0000000000000000-0000000000000fff: CONFIGURATION TABLES
01.281:  1. 0000000000001000-000000000009ffff: RAM
01.281:  2. 00000000000c0000-000000007f6fbfff: RAM
01.281:  3. 000000007f6fc000-000000007f7fffff: CONFIGURATION TABLES
01.281:  4. 000000007f800000-000000007fffffff: RESERVED
01.281:  5. 00000000f0000000-00000000f3ffffff: RESERVED
01.281: Manufacturer: c2
01.281: SF: Detected MX25L1605D with sector size 0x1000, total 0x200000
01.281: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.281: FMAP: Found "FLASH" version 1.1 at 0.
01.281: FMAP: base = ffe00000 size = 200000 #areas = 3
01.281: Wrote coreboot table at: 7f733000, 0xa08 bytes, checksum fc14
01.281: coreboot table: 2592 bytes.
01.281: IMD ROOT    0. 7f7ff000 00001000
01.281: IMD SMALL   1. 7f7fe000 00001000
01.281: CONSOLE     2. 7f7ce000 00030000
01.281: TIME STAMP  3. 7f7cd000 00000400
01.282: ROMSTG STCK 4. 7f7c8000 00005000
01.282: RAMSTAGE    5. 7f789000 0003f000
01.282: 57a9e100    6. 7f74b000 0003d8d0
01.282: SMM BACKUP  7. 7f73b000 00010000
01.282: COREBOOT    8. 7f733000 00008000
01.282: IRQ TABLE   9. 7f732000 00001000
01.282: SMP TABLE  10. 7f731000 00001000
01.282: ACPI       11. 7f70d000 00024000
01.282: TCPA LOG   12. 7f6fd000 00010000
01.282: SMBIOS     13. 7f6fc000 00000800
01.282: IMD small region:
01.282:   IMD ROOT    0. 7f7fec00 00000400
01.282:   CAR GLOBALS 1. 7f7feac0 00000140
01.282:   ROMSTAGE    2. 7f7feaa0 00000004
01.282:   57a9e000    3. 7f7fea80 00000018
01.282:   ACPI GNVS   4. 7f7fe980 00000100
01.283:   COREBOOTFWD 5. 7f7fe940 00000028
01.283: BS: BS_WRITE_TABLES times (us): entry 0 run 689903 exit 0
01.283: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.283: CBFS: Locating 'fallback/payload'
01.283: CBFS: Found @ offset 5ad00 size 57f3c
01.283: Loading segment from ROM address 0xffe5af38
01.283:   code (compression=1)
01.283:   New segment dstaddr 0x9000 memsize 0x17b48 srcaddr 0xffe5af8c filesize 0x8520
01.283: Loading segment from ROM address 0xffe5af54
01.283:   code (compression=1)
01.283:   New segment dstaddr 0x100000 memsize 0xfac68 srcaddr 0xffe634ac filesize 0x4f9c8
01.283: Loading segment from ROM address 0xffe5af70
01.283:   Entry Point 0x00009000
01.283: Loading Segment: addr: 0x0000000000009000 memsz: 0x0000000000017b48 filesz: 0x0000000000008520
01.283: Post relocation: addr: 0x0000000000009000 memsz: 0x0000000000017b48 filesz: 0x0000000000008520
01.283: using LZMA
01.304: Clearing Segment: addr: 0x0000000000019103 memsz: 0x0000000000007a45
01.304: dest 00009000, end 00020b48, bouncebuffer ffffffff
01.304: Loading Segment: addr: 0x0000000000100000 memsz: 0x00000000000fac68 filesz: 0x000000000004f9c8
01.304: Post relocation: addr: 0x0000000000100000 memsz: 0x00000000000fac68 filesz: 0x000000000004f9c8
01.304: using LZMA
01.506: dest 00100000, end 001fac68, bouncebuffer ffffffff
01.506: BS: BS_PAYLOAD_LOAD times (us): entry 0 run 318276 exit 0
01.506: ICH7 watchdog disabled
01.506: Jumping to boot code at 00009000(7f733000)
53.237: [    0.514464] 00:07: ttyS1 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
53.238: [    0.522732] Linux agpgart interface v0.103
53.239: [    0.527654] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
53.250: [    0.546540] serio: i8042 KBD port at 0x60,0x64 irq 1
53.250: [    0.551590] serio: i8042 AUX port at 0x60,0x64 irq 12
53.250: [    0.556883] rtc_cmos 00:03: RTC can wake from S4
53.251: [    0.557111] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.251: [    0.561596] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.251: [    0.579627] rtc_cmos 00:03: registered as rtc0
53.251: [    0.584192] rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
53.251: [    0.592047] ledtrig-cpu: registered to indicate activity on CPUs
53.252: [    0.598730] random: get_random_u32 called from cache_random_seq_create+0xa3/0x1f0 with crng_init=0
53.252: [    0.607810] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.252: [    0.616618] random: get_random_u32 called from cache_random_seq_create+0xa3/0x1f0 with crng_init=0
53.252: [    0.625708] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.253: [    0.634519] random: get_random_u32 called from cache_random_seq_create+0xa3/0x1f0 with crng_init=0
53.253: [    0.643593] NET: Registered protocol family 10
53.253: [    0.643608] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.253: [    0.648144] random: get_random_u32 called from bucket_table_alloc+0x163/0x340 with crng_init=0
53.253: [    0.656990] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
53.253: [    0.665630] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.253: [    0.683112] random: get_random_u32 called from neigh_hash_alloc+0x9e/0x140 with crng_init=0
53.253: [    0.691563] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.254: [    0.700558] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.254: [    0.709596] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.254: [    0.718465] random: get_random_u32 called from bucket_table_alloc+0x163/0x340 with crng_init=0
53.254: [    0.727195] Segment Routing with IPv6
53.254: [    0.730977] mip6: Mobile IPv6
53.255: [    0.734029] NET: Registered protocol family 17
53.255: [    0.738564] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.255: [    0.747374] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.255: [    0.756405] mpls_gso: MPLS GSO support
53.257: [    0.760284] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.258: [    0.771906] microcode: sig=0x6ec, pf=0x20, revision=0x54
53.258: [    0.777400] microcode: Microcode Update Driver: v2.2.
53.258: [    0.782573] Using IPI No-Shortcut mode
53.259: [    0.786430] random: get_random_bytes called from init_oops_id+0x42/0x50 with crng_init=0
53.259: [    0.795019] registered taskstats version 1
53.259: [    0.799206] Loading compiled-in X.509 certificates
53.259: [    0.804134] zswap: loaded using pool lzo/zbud
53.260: [    0.808875] random: get_random_bytes called from key_alloc+0x1fc/0x5e0 with crng_init=0
53.260: [    0.817015] random: get_random_bytes called from prandom_seed_full_state+0x65/0x120 with crng_init=0
53.261: [    0.826842] rtc_cmos 00:03: setting system clock to 2018-04-24 20:51:47 UTC (1524603107)
53.261: [    0.835109] Unstable clock detected, switching default tracing clock to "global"
53.261: [    0.835109] If you want to keep using the local clock, then add:
53.261: [    0.835109]   "trace_clock=local"
53.261: [    0.835109] on the kernel command line
53.263: [    0.857861] Freeing unused kernel memory: 884K
53.264: [    0.862567] Write protecting the kernel text: 10556k
53.264: [    0.867698] Write protecting the kernel read-only data: 2384k
53.264: [    0.873687] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.264: [    0.881963] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=0
53.264: [    0.890507] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.264: [    0.898891] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.265: [    0.907228] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.265: [    0.915592] random: get_random_bytes called from load_elf_binary+0xaf8/0x1d20 with crng_init=0
53.265: [    0.924313] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=0
53.266: [    0.933190] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.266: [    0.942185] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.266: [    0.951348] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.266: [    0.959623] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=0
53.267: [    0.968145] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.267: [    0.976503] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.267: [    0.984805] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.267: [    0.993160] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=0
53.268: [    1.001919] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.268: [    1.011195] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.268: [    1.019474] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=0
53.268: [    1.028012] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.268: [    1.036378] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.269: [    1.044676] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.269: [    1.053042] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=0
53.269: [    1.061255] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.269: [    1.061931] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.269: [    1.079146] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.269: [    1.087424] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=0
53.270: [    1.095957] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.270: [    1.104326] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.270: [    1.112628] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.270: [    1.120988] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=0
53.270: [    1.129536] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.271: [    1.138480] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.271: [    1.147736] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.271: [    1.156020] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=0
53.271: [    1.164559] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.271: [    1.172922] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.272: [    1.181227] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.272: [    1.189590] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=0
53.272: [    1.198310] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.273: [    1.207302] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.273: [    1.216370] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.273: [    1.224646] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=0
53.273: [    1.233172] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.273: [    1.241529] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.273: [    1.249830] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.274: [    1.258189] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=0
53.274: [    1.266956] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.274: [    1.275960] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.275: [    1.285012] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.275: [    1.293287] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=0
53.275: [    1.301815] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.275: [    1.310173] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.275: [    1.318471] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.276: [    1.326834] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=0
53.276: [    1.335602] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.276: [    1.344617] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.277: [    1.353701] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.277: [    1.361976] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=0
53.277: [    1.370502] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.277: [    1.378862] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.277: [    1.387161] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.277: [    1.395518] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=0
53.278: [    1.404071] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.278: [    1.413227] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.279: [    1.422211] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=0
53.279: [    1.431304] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.279: [    1.439581] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=0
53.279: [    1.448108] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.279: [    1.456465] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.279: [    1.464765] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.280: [    1.473142] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=0
53.280: [    1.481926] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=0
53.281: [    1.491184] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=0
53.281: [    1.499458] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=0
53.281: [    1.507985] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=0
53.281: [    1.508032] random: fast init done
53.281: [    1.516354] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.281: [    1.528108] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.284: [    1.536468] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.284: [    1.547370] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.285: [    1.556636] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.285: [    1.564917] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.285: [    1.573451] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.285: [    1.581806] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.285: [    1.590103] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.285: [    1.598464] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.286: [    1.607083] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.286: [    1.616068] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.287: [    1.625325] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.287: [    1.633602] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.287: [    1.642132] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.287: [    1.650485] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.287: [    1.658785] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.287: [    1.667142] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.288: [    1.675925] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.288: [    1.685182] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.289: [    1.693458] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.289: [    1.701990] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.289: [    1.710345] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.289: [    1.718648] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.289: [    1.727008] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.290: [    1.735562] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.291: [    1.746023] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.292: [    1.755341] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.292: [    1.763618] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.292: [    1.772151] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.292: [    1.780505] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.292: [    1.788804] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.292: [    1.797164] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.294: [    1.806302] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.294: [    1.815607] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.294: [    1.823887] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.294: [    1.832422] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.294: [    1.840810] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.295: [    1.849113] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.295: [    1.857469] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.295: [    1.866161] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.296: [    1.875350] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.296: [    1.884263] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.296: [    1.892537] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.296: [    1.901076] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.296: [    1.909441] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.296: [    1.917759] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.297: [    1.926121] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.297: [    1.935096] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.298: [    1.944388] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.298: [    1.952667] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.298: [    1.961200] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.298: [    1.969556] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.298: [    1.977854] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.299: [    1.986217] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.299: [    1.995079] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.300: [    2.004370] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.300: [    2.012649] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.300: [    2.021181] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.300: [    2.029531] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.300: [    2.037830] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.300: [    2.046198] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.301: [    2.054926] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.302: [    2.064216] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.302: [    2.072490] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.302: [    2.081029] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.302: [    2.089404] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.302: [    2.097719] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.302: [    2.106082] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.303: [    2.114768] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.303: [    2.123748] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.303: [    2.132748] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.303: [    2.141029] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.304: [    2.149555] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.304: [    2.157912] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.304: [    2.166211] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.304: [    2.174571] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.305: [    2.183201] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.305: [    2.192452] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.305: [    2.200735] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.305: [    2.209274] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.305: [    2.217648] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.306: [    2.225964] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.306: [    2.234334] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.417: [    2.354047] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.429: [    2.373770] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.429: [    2.383099] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.429: [    2.391380] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.429: [    2.399921] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.429: [    2.408294] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.429: [    2.416613] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.430: [    2.424980] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.433: [    2.433766] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.433: [    2.445205] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.433: [    2.453487] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.433: [    2.462012] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.433: [    2.470370] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.433: [    2.478672] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.434: [    2.487032] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.436: [    2.497110] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.436: [    2.506179] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.436: [    2.515234] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.437: [    2.524353] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.437: [    2.524841] random: systemd-udevd: uninitialized urandom read (16 bytes read)
53.437: [    2.533640] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.437: [    2.540712] random: systemd-udevd: uninitialized urandom read (16 bytes read)
53.437: [    2.548841] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.437: [    2.556078] random: systemd-udevd: uninitialized urandom read (16 bytes read)
53.437: [    2.564576] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.437: [    2.564609] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.438: [    2.571835] random: systemd-udevd: uninitialized urandom read (16 bytes read)
53.438: [    2.580203] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.438: [    2.590561] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.438: [    2.595648] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.438: [    2.604077] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.438: [    2.614705] random: udevadm: uninitialized urandom read (16 bytes read)
53.439: [    2.636938] random: udevadm: uninitialized urandom read (16 bytes read)
53.442: [    2.646551] random: udevadm: uninitialized urandom read (16 bytes read)
53.442: [    2.653412] random: udevadm: uninitialized urandom read (16 bytes read)
53.443: [    2.660901] random: udevadm: uninitialized urandom read (16 bytes read)
53.443: [    2.667760] random: udevadm: uninitialized urandom read (16 bytes read)
53.485: [    2.715763] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.485: [    2.715771] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.485: [    2.722778] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.485: [    2.724879] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.485: [    2.733992] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.485: [    2.742657] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.485: [    2.751333] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
53.486: [    2.760272] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.486: [    2.768384] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.486: [    2.768403] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
53.486: [    2.776933] random: get_random_bytes called from generate_random_uuid+0x10/0x50 with crng_init=1
53.486: [    2.785758] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
53.486: [    2.794304] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.486: [    2.802352] random: get_random_bytes called from load_elf_binary+0xaf8/0x1d20 with crng_init=1
53.487: [    2.802366] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
53.487: [    2.814876] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.487: [    2.854294] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.487: [    2.863291] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.488: [    2.872624] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.488: [    2.881649] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.491: [    2.893863] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.492: [    2.902949] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.492: [    2.911905] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.492: [    2.920883] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.493: [    2.930005] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.493: [    2.939061] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.502: [    2.957260] random: get_random_u32 called from module_alloc+0x105/0x120 with crng_init=1
53.503: [    2.959461] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.503: [    2.974779] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.503: [    2.983815] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.505: [    2.994212] thermal LNXTHERM:00: registered as thermal_zone0
53.505: [    2.995097] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.505: [    2.999964] ACPI: Thermal Zone [THM0] (43 C)
53.505: [    3.000282] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.507: [    3.023479] thermal LNXTHERM:01: registered as thermal_zone1
53.507: [    3.024107] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.507: [    3.029241] ACPI: Thermal Zone [THM1] (29 C)
53.507: [    3.038232] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.508: [    3.052311] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.508: [    3.061318] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.509: [    3.070356] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.509: [    3.079365] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.509: [    3.088358] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.510: [    3.097332] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.510: [    3.106366] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.510: [    3.106614] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.517: [    3.131055] SCSI subsystem initialized
53.524: [    3.141474] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
53.524: [    3.148218] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
53.524: [    3.156579] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
53.525: [    3.165560] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.525: [    3.166546] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.525: [    3.174620] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.525: [    3.183630] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.526: [    3.192351] scsi host0: ahci
53.526: [    3.204105] random: get_random_u32 called from cache_random_seq_create+0xa3/0x1f0 with crng_init=1
53.527: [    3.213993] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.527: [    3.222974] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.528: [    3.232390] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.528: [    3.232459] scsi host1: ahci
53.528: [    3.244688] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.528: [    3.245375] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.529: [    3.253745] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.529: [    3.266779] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.529: [    3.271598] scsi host2: ahci
53.535: [    3.289445] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.535: [    3.289728] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.535: [    3.298504] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.535: [    3.307832] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.536: [    3.316231] scsi host3: ahci
53.536: [    3.328177] ata1: SATA max UDMA/133 abar m1024@0xe4445000 port 0xe4445100 irq 28
53.538: [    3.335686] ata2: DUMMY
53.538: [    3.340405] ata3: DUMMY
53.538: [    3.342928] ata4: DUMMY
53.539: [    3.345513] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.539: [    3.354799] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.539: [    3.363626] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.539: [    3.372610] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.540: [    3.381489] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.540: [    3.390467] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.689: [    3.548109] clocksource: timekeeping watchdog on CPU0: Marking clocksource 'tsc-early' as unstable because the skew is too large:
53.689: [    3.552096] clocksource:                       'hpet' wd_now: 3243489 wd_last: 2b5c078 mask: ffffffff
53.689: [    3.552096] clocksource:                       'tsc-early' cs_now: 169b17e646 cs_last: 16779e777a mask: ffffffffffffffff
53.689: [    3.580127] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.778: [    3.677186] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
53.778: [    3.683855] ata1.00: ATA-9: M4-CT256M4SSD2, 070H, max UDMA/100
53.778: [    3.689765] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
53.779: [    3.697422] ata1.00: configured for UDMA/100
53.779: [    3.701825] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.779: [    3.710855] scsi 0:0:0:0: Direct-Access     ATA      M4-CT256M4SSD2   070H PQ: 0 ANSI: 5
53.784: [    3.723698] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
53.784: [    3.731314] sd 0:0:0:0: [sda] Write Protect is off
53.784: [    3.736217] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
53.785: [    3.745740] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
53.785: [    3.754739] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
53.785: [    3.763860]  sda: sda1 sda2
53.786: [    3.767372] sd 0:0:0:0: [sda] Attached SCSI disk
53.786: [    3.772087] sd 0:0:0:0: [sda] Synchronizing SCSI cache
53.790: [    3.781169] sd 0:0:0:0: [sda] Stopping disk
54.526: [    4.520411] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.526: [    4.529506] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
54.527: [    4.538819] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.527: [    4.547102] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
54.527: [    4.555632] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.527: [    4.564003] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.527: [    4.572346] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.528: [    4.580714] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
54.529: [    4.590354] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
54.562: [    4.631816] random: get_random_u32 called from bucket_table_alloc+0x163/0x340 with crng_init=1
54.562: [    4.640711] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.563: [    4.650104] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.563: [    4.658383] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
54.563: [    4.666915] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.563: [    4.675277] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.563: [    4.683588] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.564: [    4.691954] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
54.564: [    4.700732] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.565: [    4.710417] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.565: [    4.718695] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
54.565: [    4.727229] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.565: [    4.735588] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.566: [    4.743889] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.566: [    4.752247] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
54.569: [    4.763700] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
54.569: [    4.772678] random: get_random_u32 called from cache_random_seq_create+0xa3/0x1f0 with crng_init=1
54.570: [    4.772842] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.570: [    4.781752] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
54.570: [    4.799519] random: get_random_u32 called from cache_random_seq_create+0xa3/0x1f0 with crng_init=1
54.570: [    4.808575] device-mapper: uevent: version 1.0.3
54.570: [    4.813271] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
54.570: [    4.822073] random: get_random_u32 called from cache_random_seq_create+0xa3/0x1f0 with crng_init=1
54.570: [    4.831150] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
54.571: [    4.840068] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03) initialised: dm-devel@redhat.com
54.571: [    4.840298] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.572: [    4.858485] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
54.572: [    4.867498] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.575: [    4.879217] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.575: [    4.887517] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
54.575: [    4.896064] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.575: [    4.904458] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.575: [    4.912776] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.576: [    4.921148] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
54.578: [    4.931099] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.578: [    4.940412] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.578: [    4.948693] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
54.578: [    4.957223] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.578: [    4.965577] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.578: [    4.973878] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.579: [    4.982239] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
54.581: [    4.992885] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.582: [    5.002186] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.582: [    5.010473] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
54.582: [    5.019014] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.582: [    5.027391] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.582: [    5.035708] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.582: [    5.044080] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
54.584: [    5.053668] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.584: [    5.062967] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.584: [    5.071249] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
54.585: [    5.079794] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.585: [    5.088168] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.585: [    5.096482] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.585: [    5.104854] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
54.586: [    5.114188] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.587: [    5.123490] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.587: [    5.131771] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
54.589: [    5.140321] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.589: [    5.150876] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.590: [    5.159191] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.590: [    5.167561] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
54.607: [    5.192649] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.607: [    5.201976] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.607: [    5.210252] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
54.607: [    5.218780] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.608: [    5.227141] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.608: [    5.235442] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.608: [    5.243803] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
54.610: [    5.253914] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
54.612: [    5.264743] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.612: [    5.264757] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
54.612: [    5.273030] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.612: [    5.273045] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.612: [    5.281565] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.612: [    5.289968] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
54.613: [    5.298195] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
54.613: [    5.323054] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
54.613: [    5.323065] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
63.160: [   13.880467] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.161: [   13.889553] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.161: [   13.897838] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
63.161: [   13.906370] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.161: [   13.914729] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.161: [   13.923036] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.161: [   13.931399] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
63.163: [   13.940957] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
63.163: [   13.950115] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.164: [   13.959736] random: get_random_u32 called from bucket_table_alloc+0x163/0x340 with crng_init=1
63.164: [   13.960260] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
63.164: [   13.968483] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.164: [   13.977616] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.165: [   13.987413] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
63.165: [   13.994507] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
63.165: [   13.994517] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.165: [   14.020215] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.165: [   14.028547] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.165: [   14.036915] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
63.166: [   14.046207] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.167: [   14.055311] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.167: [   14.063589] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
63.167: [   14.072129] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.167: [   14.080492] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.167: [   14.088796] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.167: [   14.097156] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
63.168: [   14.106317] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.169: [   14.115446] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.169: [   14.123729] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
63.169: [   14.132264] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.169: [   14.140631] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.169: [   14.148940] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.169: [   14.157295] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
63.171: [   14.166629] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
63.171: [   14.175682] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.171: [   14.175889] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
63.172: [   14.193714] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.172: [   14.202949] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
63.172: [   14.211772] random: get_random_u32 called from cache_random_seq_create+0xa3/0x1f0 with crng_init=1
63.172: [   14.220874] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
63.173: [   14.230077] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.175: [   14.241356] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.175: [   14.249650] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
63.175: [   14.258187] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.175: [   14.266549] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.176: [   14.274861] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.176: [   14.283233] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
63.178: [   14.293703] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
63.178: [   14.302605] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.179: [   14.312166] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.179: [   14.320452] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
63.179: [   14.328980] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.179: [   14.337341] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.180: [   14.345652] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.180: [   14.354018] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
63.182: [   14.364070] random: get_random_u32 called from cache_alloc_refill+0x5bb/0x13d0 with crng_init=1
63.182: [   14.372958] random: get_random_u32 called from bucket_table_alloc+0x163/0x340 with crng_init=1
63.182: [   14.374074] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.191: [   14.399601] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.191: [   14.407908] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
63.191: [   14.416438] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.192: [   14.424803] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.192: [   14.433122] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.192: [   14.441490] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
63.194: [   14.451690] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.195: [   14.461242] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.195: [   14.469526] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
63.195: [   14.478100] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.197: [   14.486467] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.198: [   14.496997] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.198: [   14.505365] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
63.283: [   14.598634] random: get_random_u32 called from copy_process.part.33+0x186/0x2100 with crng_init=1
63.283: [   14.608063] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.284: [   14.608131] random: get_random_u32 called from load_elf_binary+0x76a/0x1d20 with crng_init=1
63.284: [   14.616354] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.284: [   14.624888] random: get_random_u32 called from arch_rnd.part.2+0x18/0x40 with crng_init=1
63.284: [   14.633278] random: get_random_u32 called from arch_align_stack+0x45/0x70 with crng_init=1
63.284: [   14.641555] random: get_random_u32 called from randomize_page+0x42/0x57 with crng_init=1
71.881: [   23.249929] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
72.542: [   23.918359] systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
72.562: [   23.956274] systemd[1]: Detected architecture x86.
72.574: [   23.972713] systemd[1]: Set hostname to <gm-debian>.
73.005: [   24.408815] systemd[1]: Listening on fsck to fsckd communication Socket.
73.006: [   24.416444] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
73.006: [   24.426427] systemd[1]: Listening on Network Service Netlink Socket.
73.007: [   24.433292] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
73.007: [   24.440805] systemd[1]: Listening on Journal Audit Socket.
73.008: [   24.446762] systemd[1]: Reached target Swap.
73.008: [   24.451565] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
73.141: [   24.591347] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro,discard
74.135: [   25.592317] systemd-journald[252]: Received request to flush runtime journal from PID 1
74.202: [   25.666551] systemd-journald[252]: File /var/log/journal/3606b1ddb0854918b8e3d24578588f9c/system.journal corrupted or uncleanly shut down, renaming and replacing.
74.650: [   26.129153] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
74.657: [   26.142643] ACPI: bus type USB registered
74.677: [   26.167410] usbcore: registered new interface driver usbfs
74.679: [   26.174084] usbcore: registered new interface driver hub
74.684: [   26.184607] usbcore: registered new device driver usb
74.736: [   26.241824] ACPI: AC Adapter [AC] (on-line)
74.736: [   26.242192] ACPI Error: AE_NOT_FOUND, Error reading AC Adapter state (20180313/ac-139)
74.737: [   26.254417] Non-volatile memory driver v1.3
74.737: [   26.254584] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/PNP0C09:00/PNP0C0E:00/input/input3
74.742: [   26.274873] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
74.801: [   26.340908] ACPI: Sleep Button [SLPB]
74.817: [   26.360378] uhci_hcd: USB Universal Host Controller Interface driver
74.830: [   26.379886] ACPI: Battery Slot [BAT0] (battery absent)
74.856: [   26.410269] ACPI: Battery Slot [BAT1] (battery absent)
74.857: [   26.416602] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
74.857: [   26.420544] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/PNP0C09:00/PNP0C0D:00/input/input4
74.857: [   26.422574] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
74.865: [   26.447555] thinkpad_acpi: ThinkPad ACPI Extras v0.26
74.865: [   26.452751] thinkpad_acpi: http://ibm-acpi.sf.net/
74.865: [   26.457624] thinkpad_acpi: ThinkPad BIOS CBET4000 TIMELESS, EC 7JHT12WW-3.4
74.865: [   26.464659] thinkpad_acpi: Lenovo ThinkPad X60 Tablet, model 636338U
74.873: [   26.478782] ehci-pci: EHCI PCI platform driver
74.873: [   26.478824] uhci_hcd 0000:00:1d.0: UHCI Host Controller
74.877: [   26.492463] ACPI: Lid Switch [LID]
74.878: [   26.496600] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
74.878: [   26.500586] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
74.878: [   26.504461] uhci_hcd 0000:00:1d.0: detected 2 ports
74.879: [   26.517006] thinkpad_acpi: radio switch found; radios are disabled
74.879: [   26.523371] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00005000
74.879: [   26.523835] cfg80211: Loading compiled-in X.509 certificates for regulatory database
74.879: [   26.529696] e1000e 0000:01:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
74.879: [   26.537731] ACPI: Power Button [PWRF]
74.880: [   26.550731] thinkpad_acpi: Tablet mode switch found (type: MHKG), currently in laptop mode
74.889: [   26.567626] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
74.889: [   26.567721] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 4.17
74.889: [   26.578899] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
74.889: [   26.587246] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
74.889: [   26.587249] usb usb1: Product: UHCI Host Controller
74.889: [   26.587251] usb usb1: Manufacturer: Linux 4.17.0-rc2+ uhci_hcd
74.889: [   26.587254] usb usb1: SerialNumber: 0000:00:1d.0
74.889: [   26.604698] hub 1-0:1.0: USB hub found
74.890: [   26.621793] hub 1-0:1.0: 2 ports detected
74.894: [   26.629729] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
74.895: [   26.637135] 1
74.895: [   26.637154] 2
74.895: [   26.638887] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
74.895: [   26.649333] cfg80211: failed to load regulatory.db
74.896: [   26.654520] snd_hda_intel 0000:00:1b.0: probe_mask set to 0x1 for device 17aa:2010
74.899: [   26.665523] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
74.919: [   26.694268] 3
74.921: [   26.694270] 4
74.922: [   26.695937] 5
74.922: [   26.699856] 6
74.922: [   26.701516] 7
74.922: [   26.703156] 8
74.929: [   26.704808] 9
74.938: [   26.723682] yenta_cardbus 0000:05:00.0: CardBus bridge found [0000:0000]
74.945: [   26.737592] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
74.970: [   26.769945] e1000e 0000:01:00.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:16:d3:b8:e3:49
74.970: [   26.778002] e1000e 0000:01:00.0 eth0: Intel(R) PRO/1000 Network Connection
74.970: [   26.785088] e1000e 0000:01:00.0 eth0: MAC: 2, PHY: 2, PBA No: 005302-003
74.981: [   26.802265] snd_hda_codec_analog hdaudioC0D0: autoconfig for AD1981: line_outs=1 (0x5/0x0/0x0/0x0/0x0) type:speaker
74.981: [   26.812813] snd_hda_codec_analog hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
74.981: [   26.812817] snd_hda_codec_analog hdaudioC0D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
74.981: [   26.812820] snd_hda_codec_analog hdaudioC0D0:    mono: mono_out=0x0
74.981: [   26.812822] snd_hda_codec_analog hdaudioC0D0:    dig-out=0xa/0x0
74.981: [   26.812828] snd_hda_codec_analog hdaudioC0D0:    inputs:
74.981: [   26.846178] snd_hda_codec_analog hdaudioC0D0:      Mic=0x8
74.983: [   26.853037] snd_hda_codec_analog hdaudioC0D0:      CD=0x19
74.990: [   26.866136] battery: new extension: ThinkPad Battery Extension
74.991: [   26.872233] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
74.991: [   26.881025] ehci-pci 0000:00:1d.7: EHCI Host Controller
74.995: [   26.889542] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
74.995: [   26.897217] ehci-pci 0000:00:1d.7: debug port 1
74.995: [   26.899646] yenta_cardbus 0000:05:00.0: ISA IRQ mask 0x0408, PCI irq 16
74.995: [   26.901895] do_IRQ: 0.45 No irq handler for vector
74.995: [   26.908606] yenta_cardbus 0000:05:00.0: Socket status: 30000006
74.995: [   26.913446] do_IRQ: 0.44 No irq handler for vector
74.995: [   26.913450] do_IRQ: 0.43 No irq handler for vector
74.999: [   26.933178] ehci-pci 0000:00:1d.7: irq 19, io mem 0xe4444000
75.009: [   26.948078] intel_rng: FWH not detected
75.029: [   26.972042] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
75.029: [   26.978011] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 4.17
75.029: [   26.986366] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
75.029: [   26.993703] usb usb2: Product: EHCI Host Controller
75.029: [   26.998661] usb usb2: Manufacturer: Linux 4.17.0-rc2+ ehci_hcd
75.030: [   27.004570] usb usb2: SerialNumber: 0000:00:1d.7
75.030: [   27.009284] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge window: [io  0x2000-0x3fff]
75.030: [   27.017912] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe20fffff]
75.030: [   27.027533] hub 2-0:1.0: USB hub found
75.030: [   27.031390] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe20fffff:
75.031: [   27.038991] hub 2-0:1.0: 8 ports detected
75.031: [   27.043400]  excluding 0xe1ef0000-0xe20fffff
75.031: [   27.047762] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge window: [mem 0xe2100000-0xe40fffff 64bit pref]
75.033: [   27.059501] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
75.033: [   27.068549] usb usb1: root hub lost power or was reset
75.045: [   27.085052] hub 1-0:1.0: USB hub found
75.049: [   27.093347] sdhci: Secure Digital Host Controller Interface driver
75.049: [   27.099616] sdhci: Copyright(c) Pierre Ossman
75.051: [   27.105489] hub 1-0:1.0: 2 ports detected
75.071: [   27.129740] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
75.071: [   27.138987] iwl3945: Copyright(c) 2003-2011 Intel Corporation
75.071: [   27.144819] iwl3945: hw_scan is disabled
75.072: [   27.149387] uhci_hcd 0000:00:1d.1: UHCI Host Controller
75.072: [   27.154735] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
75.073: [   27.162524] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe2100000-0xe40fffff:
75.091: [   27.188084] uhci_hcd 0000:00:1d.1: detected 2 ports
75.091: [   27.193106]  excluding 0xe2100000-0xe40fffff
75.098: [   27.204771] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00005020
75.124: [   27.235664] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 4.17
75.124: [   27.244296] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
75.124: [   27.251839] usb usb3: Product: UHCI Host Controller
75.125: [   27.256968] usb usb3: Manufacturer: Linux 4.17.0-rc2+ uhci_hcd
75.125: [   27.263061] usb usb3: SerialNumber: 0000:00:1d.1
75.134: [   27.276886] iwl3945 0000:02:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
75.134: [   27.284798] iwl3945 0000:02:00.0: Detected Intel Wireless WiFi Link 3945ABG
75.239: [   27.396598] hub 3-0:1.0: USB hub found
75.241: [   27.402328] hub 3-0:1.0: 2 ports detected
75.242: [   27.407743] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
75.257: [   27.428052] usb 2-6: new high-speed USB device number 2 using ehci-pci
75.260: [   27.437777] uhci_hcd 0000:00:1d.2: UHCI Host Controller
75.263: [   27.445466] leds_ss4200: no LED devices found
75.263: [   27.450502] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
75.264: [   27.455393] firewire_ohci 0000:05:00.1: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
75.264: [   27.458304] uhci_hcd 0000:00:1d.2: detected 2 ports
75.264: [   27.473215] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00005040
75.264: [   27.479183] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 4.17
75.264: [   27.487545] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
75.265: [   27.494863] usb usb4: Product: UHCI Host Controller
75.265: [   27.499816] usb usb4: Manufacturer: Linux 4.17.0-rc2+ uhci_hcd
75.265: [   27.505730] usb usb4: SerialNumber: 0000:00:1d.2
75.268: [   27.513308] hub 4-0:1.0: USB hub found
75.268: [   27.517438] sdhci-pci 0000:05:00.2: SDHCI controller found [1180:0822] (rev 18)
75.270: [   27.526989] sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
75.271: [   27.536550] hub 4-0:1.0: 2 ports detected
75.272: [   27.542066] uhci_hcd 0000:00:1d.3: UHCI Host Controller
75.273: [   27.548326] mmc0 bounce up to 128 segments into one, max segment size 65536 bytes
75.273: [   27.555915] sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
75.273: [   27.565437] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
75.274: [   27.572978] uhci_hcd 0000:00:1d.3: detected 2 ports
75.274: [   27.578025] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00005060
75.274: [   27.584063] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 4.17
75.274: [   27.592428] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
75.274: [   27.599753] usb usb5: Product: UHCI Host Controller
75.274: [   27.604716] usb usb5: Manufacturer: Linux 4.17.0-rc2+ uhci_hcd
75.275: [   27.610632] usb usb5: SerialNumber: 0000:00:1d.3
75.275: [   27.615648] sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
75.275: [   27.625267] usb 2-6: New USB device found, idVendor=17ef, idProduct=1000, bcdDevice= 0.01
75.275: [   27.633563] usb 2-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
75.279: [   27.644585] mmc0: SDHCI controller on PCI [0000:05:00.2] using DMA
75.280: [   27.651291] hub 2-6:1.0: USB hub found
75.280: [   27.655343] hub 2-6:1.0: 4 ports detected
75.282: [   27.661258] hub 5-0:1.0: USB hub found
75.293: [   27.675537] hub 5-0:1.0: 2 ports detected
75.308: [   27.694824] input: PC Speaker as /devices/platform/pcspkr/input/input8
75.510: [   27.903468] intel_powerclamp: No package C-state available
75.536: [   27.934778] intel_powerclamp: No package C-state available
75.602: [   28.005806] firewire_core 0000:05:00.1: created device fw0: GUID 0000000000000000, S400
75.742: [   28.154371] e1000e 0000:01:00.0 eth8: renamed from eth0
75.987: [   28.404281] iTCO_vendor_support: vendor-support=0
76.028: [   28.450321] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
76.030: [   28.457758] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
76.038: [   28.473346] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: discard
76.043: [   28.485760] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x0560)
76.055: [   28.505364] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input9
76.062: [   28.514132] IPv6: ADDRCONF(NETDEV_UP): eth8: link is not ready
76.071: [   28.516843] iwl3945 0000:02:00.0 wlan4: renamed from wlan0
76.096: [   28.565925] mousedev: PS/2 mouse device common for all mice
76.118: [   28.593472] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
78.029: [   30.509354] serio: Serial port ttyS0
78.401: 
78.412: Debian GNU/Linux 9 gm-debian ttyS1
78.412: 
78.421: gm-debian login: [   44.147118] systemd-journald[252]: File /var/log/journal/3606b1ddb0854918b8e3d24578588f9c/user-1000.journal corrupted or uncleanly shut down, renaming and replacing.
106.181: [   58.687538] pci 0000:00:00.0: Intel 945GM Chipset
106.181: [   58.692375] pci 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
106.181: [   58.700415] pci 0000:00:00.0: detected 8192K stolen memory
106.182: [   58.706075] [drm] Replacing VGA console driver
106.184: [   58.712631] Console: switching to colour dummy device 80x25
106.242: [   58.776139] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
106.242: [   58.782782] [drm] Driver supports precise vblank timestamp query.
106.242: [   58.789421] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
106.262: [   58.817960] [drm] RC6 disabled, disabling runtime PM support
106.262: [   58.823821] [drm] initialized overlay support
106.266: [   58.832332] [drm] Initialized i915 1.6.0 20180308 for 0000:00:02.0 on minor 0
106.267: [   58.840405] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
106.280: [   58.860818] acpi device:04: registered as cooling_device3
106.280: [   58.866378] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input10
106.930: [   58.896240] fbcon: inteldrmfb (fb0) is primary device
106.930: [   59.452282] Console: switching to colour frame buffer device 128x48
106.930: [   59.536879] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device


======= Tue Apr 24 22:54:27 2018 (adjust=86.8us)
00.000: [  161.229240] PM: suspend entry (deep)
00.027: [  161.232930] PM: Syncing filesystems ... done.
00.054: [  161.289592] Freezing user space processes ... (elapsed 0.001 seconds) done.
00.054: [  161.298090] OOM killer disabled.
00.055: [  161.301409] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
00.056: [  161.310540] calling  input10+ @ 690, parent: LNXVIDEO:00
00.056: [  161.315972] call input10+ returned 0 after 2 usecs
00.056: [  161.320871] calling  acpi_video0+ @ 690, parent: 0000:00:02.0
00.056: [  161.326751] call acpi_video0+ returned 0 after 6 usecs
00.056: [  161.332019] calling  intel_backlight+ @ 690, parent: card0-LVDS-1
00.057: [  161.338246] call intel_backlight+ returned 0 after 6 usecs
00.057: [  161.343874] calling  input9+ @ 690, parent: serio1
00.057: [  161.348773] call input9+ returned 0 after 2 usecs
00.057: [  161.353589] calling  coretemp.0+ @ 690, parent: platform
00.057: [  161.359016] call coretemp.0+ returned 0 after 2 usecs
00.057: [  161.364179] calling  input8+ @ 690, parent: pcspkr
00.057: [  161.369077] call input8+ returned 0 after 2 usecs
00.057: [  161.373905] calling  mmc0::+ @ 690, parent: 0000:05:00.2
00.058: [  161.373933] calling  usb5+ @ 119, parent: 0000:00:1d.3
00.058: [  161.379328] call mmc0::+ returned 0 after 1 usecs
00.058: [  161.379344] calling  gpio_ich.1.auto+ @ 690, parent: 0000:00:1f.0
00.058: [  161.384590] calling  2-6+ @ 118, parent: usb2
00.058: [  161.389383] call gpio_ich.1.auto+ returned 0 after 1 usecs
00.058: [  161.395608] calling  usb4+ @ 6, parent: 0000:00:1d.2
00.058: [  161.400041] calling  iTCO_wdt.0.auto+ @ 690, parent: 0000:00:1f.0
00.058: [  161.416929] call iTCO_wdt.0.auto+ returned 0 after 1 usecs
00.059: [  161.422541] calling  rfkill0+ @ 690, parent: phy0
00.059: [  161.422565] calling  usb3+ @ 117, parent: 0000:00:1d.1
00.059: [  161.427368] call rfkill0+ returned 0 after 9 usecs
00.059: [  161.437525] calling  phy0-led+ @ 690, parent: 0000:02:00.0
00.059: [  161.437714] call usb4+ returned 0 after 31325 usecs
00.059: [  161.443132] call phy0-led+ returned 0 after 1 usecs
00.059: [  161.443152] calling  input7+ @ 690, parent: card0
00.060: [  161.448192] call usb5+ returned 0 after 62124 usecs
00.060: [  161.453107] call input7+ returned 0 after 2 usecs
00.060: [  161.453127] calling  input6+ @ 690, parent: thinkpad_acpi
00.060: [  161.457937] calling  phy0+ @ 120, parent: 0000:02:00.0
00.060: [  161.462904] call input6+ returned 0 after 1 usecs
00.060: [  161.462920] calling  tpacpi::thinkvantage+ @ 690, parent: thinkpad_acpi
00.060: [  161.467783] call usb3+ returned 0 after 34354 usecs
00.061: [  161.473227] call tpacpi::thinkvantage+ returned 0 after 2 usecs
00.061: [  161.473236] calling  tpacpi::standby+ @ 690, parent: thinkpad_acpi
00.061: [  161.473242] call tpacpi::standby+ returned 0 after 2 usecs
00.061: [  161.473247] calling  tpacpi::power+ @ 690, parent: thinkpad_acpi
00.061: [  161.478559] calling  hdaudioC0D0+ @ 6, parent: 0000:00:1b.0
00.061: [  161.483296] call tpacpi::power+ returned 0 after 1 usecs
00.061: [  161.483314] calling  regulatory.0+ @ 690, parent: platform
00.061: [  161.490181] calling  usb1+ @ 706, parent: 0000:00:1d.0
00.062: [  161.495033] call regulatory.0+ returned 0 after 1 usecs
00.065: [  161.501078] call phy0+ returned 0 after 32585 usecs
00.069: [  161.507382] calling  thinkpad_hwmon+ @ 690, parent: platform
00.072: [  161.507386] call thinkpad_hwmon+ returned 0 after 1 usecs
00.075: [  161.546539] call usb1+ returned 0 after 44406 usecs
00.079: [  161.554834] calling  thinkpad_acpi+ @ 690, parent: platform
00.082: [  161.572779] call 2-6+ returned 0 after 173036 usecs
00.086: [  161.590003] call thinkpad_acpi+ returned 0 after 8824 usecs
00.089: [  161.598244] calling  usb2+ @ 119, parent: 0000:00:1d.7
00.092: [  161.607192] calling  input5+ @ 690, parent: LNXPWRBN:00
00.096: [  161.615881] call usb2+ returned 0 after 181 usecs
00.099: [  161.624260] call input5+ returned 0 after 2 usecs
00.103: [  161.624271] calling  input4+ @ 690, parent: PNP0C0D:00
00.106: [  161.648778] call input4+ returned 0 after 2 usecs
00.109: [  161.648844] call hdaudioC0D0+ returned 0 after 155078 usecs
00.113: [  161.656810] calling  input3+ @ 690, parent: PNP0C0E:00
00.116: [  161.674170] call input3+ returned 0 after 1 usecs
00.119: [  161.682270] calling  host3+ @ 706, parent: ata4
00.123: [  161.682273] calling  microcode+ @ 690, parent: platform
00.126: [  161.682277] call microcode+ returned 0 after 1 usecs
00.129: [  161.690136] call host3+ returned 0 after 1 usecs
00.133: [  161.698692] calling  input1::scrolllock+ @ 690, parent: input1
00.136: [  161.706952] calling  host2+ @ 120, parent: ata3
00.139: [  161.714851] call input1::scrolllock+ returned 0 after 1 usecs
00.143: [  161.723989] call host2+ returned 0 after 1 usecs
00.146: [  161.724016] calling  host1+ @ 117, parent: ata2
00.149: [  161.731906] calling  ata4+ @ 708, parent: 0000:00:1f.2
00.152: [  161.740856] call host1+ returned 0 after 1 usecs
00.156: [  161.740873] calling  0:0:0:0+ @ 119, parent: target0:0:0
00.159: [  161.748816] calling  input1::capslock+ @ 690, parent: input1
00.162: [  161.756548] call 0:0:0:0+ returned 0 after 1 usecs
00.166: [  161.756557] calling  target0:0:0+ @ 118, parent: host0
00.169: [  161.764968] call input1::capslock+ returned 0 after 1 usecs
00.172: [  161.772840] call target0:0:0+ returned 0 after 1 usecs
00.176: [  161.772854] calling  ata3+ @ 6, parent: 0000:00:1f.2
00.179: [  161.781433] calling  host0+ @ 707, parent: ata1
00.182: [  161.790371] calling  ata2+ @ 119, parent: 0000:00:1f.2
00.186: [  161.798442] call host0+ returned 0 after 1 usecs
00.189: [  161.806903] calling  input1::numlock+ @ 690, parent: input1
00.192: [  161.815796] calling  ata1+ @ 118, parent: 0000:00:1f.2
00.195: [  161.824223] call input1::numlock+ returned 0 after 1 usecs
00.199: [  161.824254] call ata3+ returned 0 after 33107 usecs
00.202: [  161.832610] call ata4+ returned 0 after 81886 usecs
00.205: [  161.840412] calling  input1+ @ 690, parent: serio0
00.208: [  161.848809] call ata1+ returned 0 after 15910 usecs
00.211: [  161.856707] call input1+ returned 0 after 2 usecs
00.215: [  161.856720] calling  memconsole+ @ 690, parent: platform
00.218: [  161.865571] call ata2+ returned 0 after 57323 usecs
00.221: [  161.873967] call memconsole+ returned 0 after 1 usecs
00.224: [  161.947463] calling  rtc0+ @ 690, parent: 00:03
00.227: [  161.955140] call rtc0+ returned 0 after 2 usecs
00.230: [  161.962806] calling  serio1+ @ 690, parent: i8042
00.245: [  161.981675] call serio1+ returned 0 after 10783 usecs
00.248: [  161.989894] calling  serio0+ @ 690, parent: i8042
00.252: [  161.998510] call serio0+ returned 0 after 795 usecs
00.255: [  162.006544] calling  i8042+ @ 690, parent: platform
00.260: [  162.016524] call i8042+ returned 0 after 1963 usecs
00.263: [  162.024491] calling  serial8250+ @ 690, parent: platform
00.266: [  162.032899] call serial8250+ returned 0 after 2 usecs
00.269: [  162.041079] calling  alarmtimer+ @ 690, parent: platform
00.272: [  162.049505] call alarmtimer+ returned 0 after 2 usecs
00.276: [  162.057672] calling  platform-framebuffer.0+ @ 690, parent: platform
00.279: [  162.067175] call platform-framebuffer.0+ returned 0 after 2 usecs
00.282: [  162.076425] calling  pcspkr+ @ 690, parent: platform
00.285: [  162.084557] call pcspkr+ returned 0 after 10 usecs
00.288: [  162.092579] calling  00:07+ @ 690, parent: pnp0
00.292: [  162.100283] call 00:07+ returned 0 after 13 usecs
00.295: [  162.108169] calling  00:06+ @ 690, parent: pnp0
00.298: [  162.115914] call 00:06+ returned 0 after 53 usecs
00.301: [  162.123768] calling  00:05+ @ 690, parent: pnp0
00.304: [  162.131435] call 00:05+ returned 0 after 2 usecs
00.307: [  162.139166] calling  00:04+ @ 690, parent: pnp0
00.311: [  162.146790] call 00:04+ returned 0 after 2 usecs
00.314: [  162.154511] calling  00:03+ @ 690, parent: pnp0
00.317: [  162.162165] call 00:03+ returned 0 after 28 usecs
00.320: [  162.169958] calling  00:02+ @ 690, parent: pnp0
00.323: [  162.177574] call 00:02+ returned 0 after 2 usecs
00.326: [  162.185261] calling  00:01+ @ 690, parent: pnp0
00.329: [  162.192851] call 00:01+ returned 0 after 2 usecs
00.332: [  162.200513] calling  00:00+ @ 690, parent: pnp0
00.335: [  162.208077] call 00:00+ returned 0 after 2 usecs
00.338: [  162.215720] calling  LNXPWRBN:00+ @ 690, parent: LNXSYSTM:00
00.341: [  162.224430] call LNXPWRBN:00+ returned 0 after 2 usecs
00.345: [  162.232624] calling  BOOT0000:00+ @ 690, parent: platform
00.348: [  162.241094] call BOOT0000:00+ returned 0 after 7 usecs
00.351: [  162.249306] calling  PNP0C0B:00+ @ 690, parent: platform
00.354: [  162.257687] call PNP0C0B:00+ returned 0 after 6 usecs
00.357: [  162.265797] calling  PNP0C04:00+ @ 690, parent: 0000:00:1f.0
00.360: [  162.274520] call PNP0C04:00+ returned 0 after 2 usecs
00.363: [  162.282634] calling  INT0800:00+ @ 690, parent: 0000:00:1f.0
00.366: [  162.291420] call INT0800:00+ returned 0 after 2 usecs
00.369: [  162.299602] calling  PNP0C0D:00+ @ 690, parent: PNP0C09:00
00.373: [  162.308242] call PNP0C0D:00+ returned 0 after 2 usecs
00.376: [  162.316441] calling  PNP0C0E:00+ @ 690, parent: PNP0C09:00
00.379: [  162.325087] call PNP0C0E:00+ returned 0 after 2 usecs
00.382: [  162.333299] calling  PNP0C0A:01+ @ 690, parent: PNP0C09:00
00.385: [  162.341961] call PNP0C0A:01+ returned 0 after 2 usecs
00.388: [  162.350187] calling  PNP0C0A:00+ @ 690, parent: PNP0C09:00
00.392: [  162.358872] call PNP0C0A:00+ returned 0 after 2 usecs
00.395: [  162.367122] calling  ACPI0003:00+ @ 690, parent: PNP0C09:00
00.398: [  162.375909] call ACPI0003:00+ returned 0 after 2 usecs
00.401: [  162.384263] calling  IBM0068:00+ @ 690, parent: PNP0C09:00
00.405: [  162.392978] call IBM0068:00+ returned 0 after 2 usecs
00.408: [  162.401259] calling  PNP0C09:00+ @ 690, parent: 0000:00:1f.0
00.411: [  162.410182] call PNP0C09:00+ returned 0 after 2 usecs
00.415: [  162.418507] calling  0000:05:00.2+ @ 118, parent: 0000:00:1e.0
00.418: [  162.418522] calling  LNXTHERM:01+ @ 690, parent: LNXSYBUS:01
00.421: [  162.427627] calling  0000:05:00.1+ @ 119, parent: 0000:00:1e.0
00.424: [  162.436552] calling  0000:05:00.0+ @ 708, parent: 0000:00:1e.0
00.428: [  162.445652] calling  0000:02:00.0+ @ 6, parent: 0000:00:1c.1
00.431: [  162.454674] call 0000:05:00.0+ returned 0 after 1 usecs
00.434: [  162.463532] call 0000:02:00.0+ returned 0 after 37 usecs
00.437: [  162.471869] calling  0000:01:00.0+ @ 707, parent: 0000:00:1c.0
00.440: [  162.480349] calling  0000:00:1f.2+ @ 6, parent: pci0000:00
00.443: [  162.489319] calling  0000:00:1f.1+ @ 710, parent: pci0000:00
00.446: [  162.497867] call 0000:00:1f.2+ returned 0 after 4 usecs
00.449: [  162.497875] call 0000:05:00.2+ returned 0 after 68614 usecs
00.453: [  162.506649] call 0000:00:1f.1+ returned 0 after 1 usecs
00.456: [  162.514996] call 0000:05:00.1+ returned 0 after 67731 usecs
00.459: [  162.523659] calling  0000:00:1f.0+ @ 709, parent: pci0000:00
00.462: [  162.531949] calling  0000:00:1e.0+ @ 120, parent: pci0000:00
00.465: [  162.540570] call 0000:00:1f.0+ returned 0 after 1 usecs
00.468: [  162.549285] call 0000:00:1e.0+ returned 0 after 1 usecs
00.471: [  162.549300] calling  0000:00:1d.7+ @ 6, parent: pci0000:00
00.474: [  162.557982] calling  0000:00:1d.3+ @ 706, parent: pci0000:00
00.477: [  162.566275] calling  0000:00:1d.2+ @ 119, parent: pci0000:00
00.480: [  162.574462] call LNXTHERM:01+ returned 0 after 134687 usecs
00.483: [  162.582953] calling  0000:00:1d.1+ @ 118, parent: pci0000:00
00.486: [  162.591689] call 0000:00:1d.3+ returned 0 after 16836 usecs
00.489: [  162.600232] calling  0000:00:1d.0+ @ 117, parent: pci0000:00
00.492: [  162.609011] e1000e 0000:01:00.0: Disabling ASPM L0s L1
00.495: [  162.617450] calling  0000:00:1c.3+ @ 120, parent: pci0000:00
00.498: [  162.625977] calling  LNXTHERM:00+ @ 690, parent: LNXSYBUS:01
00.501: [  162.634631] calling  0000:00:1c.2+ @ 711, parent: pci0000:00
00.504: [  162.642755] calling  0000:00:1c.1+ @ 708, parent: pci0000:00
00.507: [  162.651460] call 0000:00:1d.0+ returned 0 after 33253 usecs
00.510: [  162.660097] calling  0000:00:1b.0+ @ 710, parent: pci0000:00
00.513: [  162.668759] call 0000:00:1d.7+ returned 0 after 100127 usecs
00.516: [  162.677423] calling  0000:00:02.1+ @ 706, parent: pci0000:00
00.519: [  162.685905] calling  0000:00:02.0+ @ 712, parent: pci0000:00
00.522: [  162.694508] call 0000:00:02.1+ returned 0 after 1 usecs
00.524: [  162.703123] call 0000:00:1d.2+ returned 0 after 117370 usecs
00.527: [  162.714180] calling  0000:00:00.0+ @ 713, parent: pci0000:00
00.530: [  162.720289] call 0000:00:1d.1+ returned 0 after 117267 usecs
00.533: [  162.728402] call 0000:00:00.0+ returned 0 after 1 usecs
00.536: [  162.736930] call 0000:00:1c.2+ returned 0 after 83507 usecs
00.539: [  162.745518] call LNXTHERM:00+ returned 0 after 100363 usecs
00.542: [  162.753977] call 0000:00:1c.3+ returned 0 after 116567 usecs
00.544: [  162.762039] call 0000:00:1c.1+ returned 0 after 99563 usecs
00.547: [  162.770571] call 0000:00:1b.0+ returned 0 after 91023 usecs
00.550: [  162.778743] calling  dock.0+ @ 690, parent: platform
00.552: [  162.778747] call dock.0+ returned 0 after 1 usecs
00.555: [  162.778778] calling  PNP0C0D:00+ @ 690, parent: PNP0C09:00
00.558: [  162.826955] call PNP0C0D:00+ returned 0 after 1 usecs
00.560: [  162.827275] e1000e: EEE TX LPI TIMER: 00000000
00.563: [  162.834725] calling  PNP0C0E:00+ @ 690, parent: PNP0C09:00
00.566: [  162.850012] call PNP0C0E:00+ returned 0 after 2 usecs
00.569: [  162.857834] calling  PNP0C09:00+ @ 690, parent: device:22
00.572: [  162.865993] call PNP0C09:00+ returned 0 after 2 usecs
00.574: [  162.868666] call 0000:01:00.0+ returned 0 after 370516 usecs
00.577: [  162.882295] calling  0000:00:1c.0+ @ 709, parent: pci0000:00
00.580: [  162.890769] call 0000:00:1c.0+ returned 0 after 8 usecs
00.766: [  163.084228] call 0000:00:02.0+ returned 0 after 372171 usecs
00.766: [  163.090294] calling  BOOT0000:00+ @ 690, parent: platform
00.766: [  163.095722] call BOOT0000:00+ returned 0 after 2 usecs
00.766: [  163.100886] calling  PNP0C0B:00+ @ 690, parent: platform
00.766: [  163.106227] call PNP0C0B:00+ returned 0 after 9 usecs
00.766: [  163.111337] calling  0000:05:00.2+ @ 712, parent: 0000:00:1e.0
00.766: [  163.111442] calling  0000:05:00.1+ @ 714, parent: 0000:00:1e.0
00.766: [  163.117192] call 0000:05:00.2+ returned 0 after 1 usecs
00.766: [  163.123040] call 0000:05:00.1+ returned 0 after 1 usecs
00.766: [  163.128297] calling  0000:02:00.0+ @ 707, parent: 0000:00:1c.1
00.766: [  163.133534] calling  0000:01:00.0+ @ 714, parent: 0000:00:1c.0
00.766: [  163.139371] call 0000:02:00.0+ returned 0 after 1 usecs
00.766: [  163.139389] calling  0000:00:1f.2+ @ 708, parent: pci0000:00
00.766: [  163.145226] call 0000:01:00.0+ returned 0 after 1 usecs
00.767: [  163.150465] call 0000:00:1f.2+ returned 0 after 1 usecs
00.766: [  163.150479] calling  0000:00:1f.1+ @ 706, parent: pci0000:00
00.767: [  163.156162] calling  0000:00:1f.0+ @ 712, parent: pci0000:00
00.767: [  163.161393] call 0000:00:1f.1+ returned 0 after 1 usecs
00.767: [  163.161413] calling  0000:00:1d.7+ @ 713, parent: pci0000:00
00.767: [  163.166639] call 0000:00:1f.0+ returned 0 after 1 usecs
00.767: [  163.172314] call 0000:00:1d.7+ returned 0 after 1 usecs
00.767: [  163.177996] calling  0000:00:1d.3+ @ 714, parent: pci0000:00
00.767: [  163.183242] calling  0000:00:1d.2+ @ 120, parent: pci0000:00
00.767: [  163.188915] call 0000:00:1d.3+ returned 0 after 1 usecs
00.767: [  163.194153] call 0000:00:1d.2+ returned 0 after 1 usecs
00.767: [  163.199405] calling  0000:00:1d.1+ @ 712, parent: pci0000:00
00.767: [  163.205079] calling  0000:00:1d.0+ @ 711, parent: pci0000:00
00.767: [  163.210752] call 0000:00:1d.1+ returned 0 after 1 usecs
00.767: [  163.215992] call 0000:00:1d.0+ returned 0 after 1 usecs
00.767: [  163.216019] calling  0000:00:1c.3+ @ 118, parent: pci0000:00
00.767: [  163.221272] calling  0000:00:1c.2+ @ 714, parent: pci0000:00
00.767: [  163.226937] call 0000:00:1c.3+ returned 0 after 1 usecs
00.767: [  163.226952] calling  0000:00:1c.1+ @ 119, parent: pci0000:00
00.767: [  163.232614] call 0000:00:1c.2+ returned 0 after 1 usecs
00.767: [  163.232625] calling  0000:05:00.0+ @ 709, parent: 0000:00:1e.0
00.767: [  163.237865] call 0000:00:1c.1+ returned 0 after 2 usecs
00.767: [  163.243111] call 0000:05:00.0+ returned 0 after 1 usecs
00.767: [  163.248794] calling  0000:00:1c.0+ @ 6, parent: pci0000:00
00.767: [  163.254473] calling  0000:00:1e.0+ @ 710, parent: pci0000:00
00.767: [  163.259701] call 0000:00:1c.0+ returned 0 after 0 usecs
00.767: [  163.259716] calling  0000:00:1b.0+ @ 117, parent: pci0000:00
00.767: [  163.265382] call 0000:00:1e.0+ returned 0 after 1 usecs
00.767: [  163.270623] call 0000:00:1b.0+ returned 0 after 1 usecs
00.768: [  163.276527] calling  0000:00:02.1+ @ 706, parent: pci0000:00
00.768: [  163.281725] calling  0000:00:02.0+ @ 6, parent: pci0000:00
00.768: [  163.286959] call 0000:00:02.1+ returned 0 after 1 usecs
00.768: [  163.292465] calling  0000:00:00.0+ @ 711, parent: pci0000:00
00.768: [  163.341642] call 0000:00:00.0+ returned 0 after 2 usecs
00.789: [  163.368154] call 0000:00:02.0+ returned 0 after 73918 usecs
00.789: [  163.373918] calling  iTCO_wdt.0.auto+ @ 690, parent: 0000:00:1f.0
00.789: [  163.380041] call iTCO_wdt.0.auto+ returned 0 after 1 usecs
00.789: [  163.385557] calling  pcmcia_socket0+ @ 690, parent: 0000:05:00.0
00.789: [  163.391606] call pcmcia_socket0+ returned 0 after 22 usecs
00.790: [  163.397312] calling  BOOT0000:00+ @ 690, parent: platform
00.790: [  163.402729] call BOOT0000:00+ returned 0 after 1 usecs
00.790: [  163.407884] calling  PNP0C0B:00+ @ 690, parent: platform
00.790: [  163.413216] call PNP0C0B:00+ returned 0 after 1 usecs
00.790: [  163.418309] calling  0000:05:00.2+ @ 6, parent: 0000:00:1e.0
00.790: [  163.418347] calling  PNP0C09:00+ @ 690, parent: device:22
00.790: [  163.424079] calling  0000:05:00.0+ @ 707, parent: 0000:00:1e.0
00.790: [  163.429405] ACPI: EC: interrupt blocked
00.790: [  163.435337] call 0000:05:00.0+ returned 0 after 91 usecs
00.790: [  163.439087] call PNP0C09:00+ returned 0 after 9455 usecs
00.790: [  163.444417] calling  0000:05:00.1+ @ 711, parent: 0000:00:1e.0
00.790: [  163.449750] calling  0000:02:00.0+ @ 117, parent: 0000:00:1c.1
00.790: [  163.455593] call 0000:05:00.1+ returned 0 after 1 usecs
00.790: [  163.455603] call 0000:05:00.2+ returned 0 after 30875 usecs
00.790: [  163.461671] calling  0000:01:00.0+ @ 712, parent: 0000:00:1c.0
00.790: [  163.466705] calling  0000:00:1f.2+ @ 711, parent: pci0000:00
00.790: [  163.472446] calling  0000:00:1f.1+ @ 119, parent: pci0000:00
00.790: [  163.478212] calling  0000:00:1f.0+ @ 6, parent: pci0000:00
00.790: [  163.483882] call 0000:00:1f.1+ returned 0 after 59 usecs
00.790: [  163.489560] call 0000:00:1f.0+ returned 0 after 65 usecs
00.790: [  163.495013] calling  0000:00:1e.0+ @ 713, parent: pci0000:00
00.790: [  163.500333] calling  0000:00:1d.7+ @ 6, parent: pci0000:00
00.790: [  163.500522] calling  0000:00:1d.3+ @ 707, parent: pci0000:00
00.790: [  163.505725] call 0000:00:1e.0+ returned 0 after 55 usecs
00.790: [  163.511407] call 0000:00:1f.2+ returned 0 after 32486 usecs
00.790: [  163.516866] calling  0000:00:1d.2+ @ 120, parent: pci0000:00
00.791: [  163.522552] calling  0000:00:1d.1+ @ 711, parent: pci0000:00
00.791: [  163.527984] call 0000:00:1d.2+ returned 0 after 112 usecs
00.791: [  163.533521] call 0000:00:1d.7+ returned 0 after 32406 usecs
00.791: [  163.539205] call 0000:02:00.0+ returned 0 after 75938 usecs
00.791: [  163.544824] calling  0000:00:1d.0+ @ 118, parent: pci0000:00
00.791: [  163.550243] calling  0000:00:1c.3+ @ 706, parent: pci0000:00
00.791: [  163.555945] call 0000:01:00.0+ returned 0 after 81683 usecs
00.791: [  163.561546] call 0000:00:1c.3+ returned 0 after 109 usecs
00.791: [  163.567161] call 0000:00:1d.0+ returned 0 after 11073 usecs
00.791: [  163.572797] calling  0000:00:1c.2+ @ 709, parent: pci0000:00
00.791: [  163.578381] calling  0000:00:1c.1+ @ 712, parent: pci0000:00
00.791: [  163.583902] call 0000:00:1c.2+ returned 0 after 109 usecs
00.791: [  163.589492] call 0000:00:1c.1+ returned 0 after 107 usecs
00.791: [  163.595069] calling  0000:00:1c.0+ @ 710, parent: pci0000:00
00.791: [  163.600741] calling  0000:00:1b.0+ @ 6, parent: pci0000:00
00.791: [  163.606257] call 0000:00:1c.0+ returned 0 after 103 usecs
00.791: [  163.611718] call 0000:00:1d.1+ returned 0 after 76420 usecs
00.791: [  163.617263] calling  0000:00:02.1+ @ 714, parent: pci0000:00
00.791: [  163.622762] calling  0000:00:02.0+ @ 118, parent: pci0000:00
00.791: [  163.628197] call 0000:00:02.1+ returned 0 after 25 usecs
00.791: [  163.633763] call 0000:00:02.0+ returned 0 after 1 usecs
00.791: [  163.639447] calling  0000:00:00.0+ @ 716, parent: pci0000:00
00.791: [  163.645120] call 0000:00:1b.0+ returned 0 after 32761 usecs
00.791: [  163.650475] call 0000:00:00.0+ returned 0 after 31 usecs
00.791: [  163.655755] call 0000:00:1d.3+ returned 0 after 141022 usecs
00.792: [  163.678264] ACPI: Preparing to enter system sleep state S3
00.803: [  163.695353] ACPI: EC: event blocked
00.803: [  163.696007] ACPI: EC: EC stopped
00.803: [  163.702094] PM: Saving platform NVS memory
00.803: [  163.706209] Disabling non-boot CPUs ...
00.818: [  163.724421] IRQ 1: no longer affine to CPU1
00.818: [  163.728008] IRQ 9: no longer affine to CPU1
00.818: [  163.728008] IRQ 12: no longer affine to CPU1
00.818: [  163.728008] IRQ 16: no longer affine to CPU1
00.818: [  163.728008] IRQ 19: no longer affine to CPU1
00.818: [  163.728008] IRQ 28: no longer affine to CPU1
00.819: [  163.750966] smpboot: CPU 1 is now offline
00.820: [  163.755499] PM: Calling kvm_suspend+0x0/0x30 [kvm]
00.820: [  163.759004] PM: Calling mce_syscore_suspend+0x0/0x30
00.820: [  163.759004] PM: Calling ledtrig_cpu_syscore_suspend+0x0/0x20
00.820: [  163.759004] PM: Calling timekeeping_suspend+0x0/0x500
00.820: [  163.759004] PM: Calling irq_gc_suspend+0x0/0x90
00.820: [  163.759004] PM: Calling save_ioapic_entries+0x0/0x260
00.820: [  163.759004] PM: Calling i8259A_suspend+0x0/0x30
00.820: [  163.759004] PM: Calling fw_suspend+0x0/0x20
00.820: [  163.759004] PM: Calling acpi_save_bm_rld+0x0/0x20
00.820: [  163.759004] PM: Calling lapic_suspend+0x0/0x310
18.120: <00>
18.320: 
18.320: 
18.320: coreboot-TIMELESS Thu Jan  1 00:00:00 UTC 1970 romstage starting...
18.320: Dock is present
18.320: 
18.321: Mobile Intel(R) 82945GM/GME Express Chipset
18.321: (G)MCH capable of up to FSB 800 MHz
18.321: (G)MCH capable of up to DDR2-667
18.321: Setting up static southbridge registers... done.
18.321: Disabling Watchdog reboot... done.
18.321: Setting up static northbridge registers...CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.323: CBFS: Locating 'cmos_layout.bin'
18.323: CBFS: Found @ offset 39100 size 6ac
18.324:  done.
18.324: Waiting for MCHBAR to come up...ok
18.324: PM1_CNT: 00001400
18.324: Resume from S3 detected.
18.324: SMBus controller enabled.
18.324: Setting up RAM controller.
18.325: This mainboard supports Dual Channel Operation.
18.384: Reading SPD using i2c block operation.
18.385: DDR II Channel 0 Socket 0: x8DDS
18.386: DIMM 0 side 0 = 512 MB
18.386: DIMM 0 side 1 = 512 MB
18.387: DDR II Channel 0 Socket 1: N/A
18.446: Reading SPD using i2c block operation.
18.446: DDR II Channel 1 Socket 0: x8DDS
18.446: DIMM 2 side 0 = 512 MB
18.446: DIMM 2 side 1 = 512 MB
18.447: DDR II Channel 1 Socket 1: N/A
18.447: Memory will be driven at 667MT with CAS=5 clocks
18.447: tRAS = 15 cycles
18.447: tRP  = 5 cycles
18.447: tRCD = 5 cycles
18.447: tWR  = 5 cycles
18.447: tRFC = 35 cycles
18.448: Refresh: 7.8us
18.448: Setting Graphics Frequency...
18.448: FSB: 667 MHz Voltage: 1.05V Render: 250MHz Display: 200MHz
18.448: Setting Memory Frequency... CLKCFG = 0x00010023, CLKCFG = 0x00010043, ok
18.449: Setting mode of operation for memory channels...Dual Channel Interleaved.
18.449: Programming Clock Crossing...MEM=667 FSB=667... ok
18.449: Setting RAM size...
18.450: C0DRB = 0x20202010
18.450: C1DRB = 0x20202010
18.450: TOLUD = 0x0080
18.450: Setting row attributes...
18.450: C0DRA = 0x0033
18.450: C1DRA = 0x0033
18.450: one dimm per channel config..
18.450: Initializing System Memory IO...
18.451: Programming Dual Channel RCOMP
18.451: Table Index: 18
18.451: Programming DLL Timings...
18.451: Enabling System Memory IO...
18.453: RAM initialization finished.
18.453: Setting up Egress Port RCRB
18.453: Loading port arbitration table ...ok
18.453: Wait for VC1 negotiation ...ok
18.453: Setting up DMI RCRB
18.453: Wait for VC1 negotiation ...done..
18.453: Internal graphics: enabled
18.454: Waiting for DMI hardware...ok
18.454: Enabling PCI Express x16 Link
18.454: SLOTSTS: 0000
18.454: Disabling PCI Express x16 Link
18.454: Wait for link to enter detect state... ok
18.454: Setting up Root Complex Topology
18.461: MTRR Range: Start=ffe00000 End=0 (Size 200000)
18.461: MTRR Range: Start=0 End=1000000 (Size 1000000)
18.461: MTRR Range: Start=7f400000 End=7f800000 (Size 400000)
18.461: MTRR Range: Start=7f000000 End=7f400000 (Size 400000)
18.465: Jumping to image.
18.466: 
18.466: 
18.466: coreboot-TIMELESS Thu Jan  1 00:00:00 UTC 1970 ramstage starting...
18.466: S3 Resume.
18.466: BS: BS_PRE_DEVICE times (us): entry 0 run 0 exit 0
18.466: BS: BS_DEV_INIT_CHIPS times (us): entry 0 run 1 exit 0
18.466: Enumerating buses...
18.466: CPU_CLUSTER: 0 enabled
18.466: DOMAIN: 0000 enabled
18.466: PCI: pci_scan_bus for bus 00
18.466: PCI: 00:00.0 [8086/27a0] enabled
18.466: PCI: 00:02.0 [8086/27a2] enabled
18.466: PCI: 00:02.1 [8086/27a6] enabled
18.467: PCI: 00:1b.0 [8086/27d8] enabled
18.467: PCI: 00:1c.0 [8086/27d0] enabled
18.467: PCI: 00:1c.1 [8086/27d2] enabled
18.467: PCI: 00:1c.2 [8086/27d4] enabled
18.467: PCI: 00:1c.3 [8086/27d6] enabled
18.467: PCI: 00:1d.0 [8086/27c8] enabled
18.467: PCI: 00:1d.1 [8086/27c9] enabled
18.467: PCI: 00:1d.2 [8086/27ca] enabled
18.467: PCI: 00:1d.3 [8086/27cb] enabled
18.467: PCI: 00:1d.7 [8086/27cc] enabled
18.467: PCI: 00:1e.0 [8086/2448] enabled
18.467: PCI: 00:1f.0 [8086/27b9] enabled
18.467: PCI: 00:1f.1 [8086/27df] enabled
18.467: Set SATA mode early
18.467: Set SATA mode early
18.467: PCI: 00:1f.2 [8086/27c5] enabled
18.467: PCI: 00:1f.3 [8086/27da] enabled
18.467: PCI: pci_scan_bus for bus 01
18.467: PCI: 01:00.0 [8086/109a] enabled
18.467: scan_bus: scanning of bus PCI: 00:1c.0 took 5652 usecs
18.467: PCI: pci_scan_bus for bus 02
18.467: PCI: 02:00.0 [8086/4227] enabled
18.467: scan_bus: scanning of bus PCI: 00:1c.1 took 5667 usecs
18.467: PCI: pci_scan_bus for bus 03
18.467: scan_bus: scanning of bus PCI: 00:1c.2 took 2672 usecs
18.467: PCI: pci_scan_bus for bus 04
18.467: scan_bus: scanning of bus PCI: 00:1c.3 took 2673 usecs
18.467: PCI: pci_scan_bus for bus 05
18.467: PCI: 05:00.0 [1180/0476] enabled
18.467: PCI: 05:00.1 [1180/0552] enabled
18.467: PCI: 05:00.2 [1180/0822] enabled
18.467: PCI: pci_scan_bus for bus 06
18.467: scan_bus: scanning of bus PCI: 05:00.0 took 2678 usecs
18.467: scan_bus: scanning of bus PCI: 00:1e.0 took 19181 usecs
18.467: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.467: CBFS: Locating 'cmos_layout.bin'
18.467: CBFS: Found @ offset 39100 size 6ac
18.468: WARNING: No CMOS option 'touchpad'.
18.468: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.468: CBFS: Locating 'cmos_layout.bin'
18.468: CBFS: Found @ offset 39100 size 6ac
18.468: PMH7: ID 03 Revision 10
18.468: PNP: 00ff.1 enabled
18.469: EC Firmware ID 7JHT12WW-3.4, Version 3.01A
18.470: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.470: CBFS: Locating 'cmos_layout.bin'
18.470: CBFS: Found @ offset 39100 size 6ac
18.470: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.470: CBFS: Locating 'cmos_layout.bin'
18.470: CBFS: Found @ offset 39100 size 6ac
18.473: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.473: CBFS: Locating 'cmos_layout.bin'
18.473: CBFS: Found @ offset 39100 size 6ac
18.474: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.474: CBFS: Locating 'cmos_layout.bin'
18.474: CBFS: Found @ offset 39100 size 6ac
18.474: H8: BDC not installed
18.475: H8: WWAN detection not implemented. Assuming WWAN installed
18.475: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.475: CBFS: Locating 'cmos_layout.bin'
18.475: CBFS: Found @ offset 39100 size 6ac
18.475: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.475: CBFS: Locating 'cmos_layout.bin'
18.475: CBFS: Found @ offset 39100 size 6ac
18.475: WARNING: No CMOS option 'fn_ctrl_swap'.
18.475: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.475: CBFS: Locating 'cmos_layout.bin'
18.475: CBFS: Found @ offset 39100 size 6ac
18.476: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.476: CBFS: Locating 'cmos_layout.bin'
18.476: CBFS: Found @ offset 39100 size 6ac
18.477: PNP: 00ff.2 enabled
18.477: PNP: 164e.2 enabled
18.477: PNP: 164e.3 enabled
18.477: PNP: 164e.7 enabled
18.477: PNP: 164e.19 enabled
18.477: PNP: 002e.0 disabled
18.477: PNP: 002e.1 enabled
18.477: PNP: 002e.2 disabled
18.477: PNP: 002e.3 enabled
18.477: PNP: 002e.7 enabled
18.477: PNP: 002e.a disabled
18.477: scan_bus: scanning of bus PCI: 00:1f.0 took 166006 usecs
18.477: bus: PCI: 00:1f.3[0]->I2C: 01:69 enabled
18.477: bus: PCI: 00:1f.3[0]->I2C: 01:54 enabled
18.477: bus: PCI: 00:1f.3[0]->I2C: 01:55 enabled
18.477: bus: PCI: 00:1f.3[0]->I2C: 01:56 enabled
18.477: bus: PCI: 00:1f.3[0]->I2C: 01:57 enabled
18.477: bus: PCI: 00:1f.3[0]->I2C: 01:5c enabled
18.477: bus: PCI: 00:1f.3[0]->I2C: 01:5d enabled
18.477: bus: PCI: 00:1f.3[0]->I2C: 01:5e enabled
18.477: bus: PCI: 00:1f.3[0]->I2C: 01:5f enabled
18.477: scan_bus: scanning of bus PCI: 00:1f.3 took 33205 usecs
18.477: scan_bus: scanning of bus DOMAIN: 0000 took 329659 usecs
18.477: scan_bus: scanning of bus Root Device took 338756 usecs
18.477: done
18.477: BS: BS_DEV_ENUMERATE times (us): entry 0 run 346240 exit 0
18.477: found VGA at PCI: 00:02.0
18.477: Setting up VGA for PCI: 00:02.0
18.477: Setting PCI_BRIDGE_CTL_VGA for bridge DOMAIN: 0000
18.477: Setting PCI_BRIDGE_CTL_VGA for bridge Root Device
18.477: Allocating resources...
18.477: Reading resources...
18.477: Adding PCIe enhanced config space BAR 0xf0000000-0xf4000000.
18.478: PNP: 00ff.1 missing read_resources
18.479: PNP: 00ff.2 missing read_resources
18.479: Done reading resources.
18.479: skipping PNP: 00ff.2@60 fixed resource, size=0!
18.479: skipping PNP: 00ff.2@62 fixed resource, size=0!
18.479: skipping PNP: 00ff.2@64 fixed resource, size=0!
18.479: skipping PNP: 00ff.2@66 fixed resource, size=0!
18.479: skipping PNP: 164e.3@29 fixed resource, size=0!
18.479: skipping PNP: 164e.3@f0 fixed resource, size=0!
18.479: Setting resources...
18.479: pci_tolm: 0xd0000000
18.479: IGD decoded, subtracting 8M UMA
18.479: Available memory: 2088960K (2040M)
18.479: PCI: 00:02.0 10 <- [0x00e4300000 - 0x00e437ffff] size 0x00080000 gran 0x13 mem
18.479: PCI: 00:02.0 14 <- [0x00000050b0 - 0x00000050b7] size 0x00000008 gran 0x03 io
18.479: PCI: 00:02.0 18 <- [0x00d0000000 - 0x00dfffffff] size 0x10000000 gran 0x1c prefmem
18.479: PCI: 00:02.0 1c <- [0x00e4400000 - 0x00e443ffff] size 0x00040000 gran 0x12 mem
18.479: PCI: 00:02.1 10 <- [0x00e4380000 - 0x00e43fffff] size 0x00080000 gran 0x13 mem
18.479: PCI: 00:1b.0 10 <- [0x00e4440000 - 0x00e4443fff] size 0x00004000 gran 0x0e mem64
18.479: PCI: 00:1c.0 1c <- [0x0000004000 - 0x0000004fff] size 0x00001000 gran 0x0c bus 01 io
18.479: PCI: 00:1c.0 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 01 prefmem
18.479: PCI: 00:1c.0 20 <- [0x00e4100000 - 0x00e41fffff] size 0x00100000 gran 0x14 bus 01 mem
18.479: PCI: 01:00.0 10 <- [0x00e4100000 - 0x00e411ffff] size 0x00020000 gran 0x11 mem
18.479: PCI: 01:00.0 18 <- [0x0000004000 - 0x000000401f] size 0x00000020 gran 0x05 io
18.479: PCI: 00:1c.1 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 gran 0x0c bus 02 io
18.479: PCI: 00:1c.1 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 02 prefmem
18.479: PCI: 00:1c.1 20 <- [0x00e4200000 - 0x00e42fffff] size 0x00100000 gran 0x14 bus 02 mem
18.479: PCI: 02:00.0 10 <- [0x00e4200000 - 0x00e4200fff] size 0x00001000 gran 0x0c mem
18.479: PCI: 00:1c.2 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 gran 0x0c bus 03 io
18.479: PCI: 00:1c.2 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 03 prefmem
18.479: PCI: 00:1c.2 20 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 03 mem
18.479: PCI: 00:1c.3 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 gran 0x0c bus 04 io
18.479: PCI: 00:1c.3 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 04 prefmem
18.479: PCI: 00:1c.3 20 <- [0x00efffffff - 0x00effffffe] size 0x00000000 gran 0x14 bus 04 mem
18.479: PCI: 00:1d.0 20 <- [0x0000005000 - 0x000000501f] size 0x00000020 gran 0x05 io
18.479: PCI: 00:1d.1 20 <- [0x0000005020 - 0x000000503f] size 0x00000020 gran 0x05 io
18.479: PCI: 00:1d.2 20 <- [0x0000005040 - 0x000000505f] size 0x00000020 gran 0x05 io
18.479: PCI: 00:1d.3 20 <- [0x0000005060 - 0x000000507f] size 0x00000020 gran 0x05 io
18.479: PCI: 00:1d.7 10 <- [0x00e4444000 - 0x00e44443ff] size 0x00000400 gran 0x0a mem
18.479: PCI: 00:1e.0 1c <- [0x0000002000 - 0x0000003fff] size 0x00002000 gran 0x0c bus 05 io
18.479: PCI: 00:1e.0 24 <- [0x00e2100000 - 0x00e40fffff] size 0x02000000 gran 0x14 bus 05 prefmem
18.479: PCI: 00:1e.0 20 <- [0x00e0000000 - 0x00e20fffff] size 0x02100000 gran 0x14 bus 05 mem
18.479: PCI: 05:00.0 In set resources
18.479: PCI: 05:00.0 10 <- [0x00e2000000 - 0x00e2000fff] size 0x00001000 gran 0x0c mem
18.479: PCI: 05:00.0 2c <- [0x0000002000 - 0x0000002fff] size 0x00001000 gran 0x02 io
18.479: PCI: 05:00.0 34 <- [0x0000003000 - 0x0000003fff] size 0x00001000 gran 0x02 io
18.480: PCI: 05:00.0 1c <- [0x00e2100000 - 0x00e40fffff] size 0x02000000 gran 0x0c prefmem
18.480: PCI: 05:00.0 24 <- [0x00e0000000 - 0x00e1ffffff] size 0x02000000 gran 0x0c mem
18.480: PCI: 05:00.1 10 <- [0x00e2001000 - 0x00e20017ff] size 0x00000800 gran 0x0b mem
18.480: PCI: 05:00.2 10 <- [0x00e2002000 - 0x00e20020ff] size 0x00000100 gran 0x08 mem
18.480: PNP: 00ff.1 missing set_resources
18.480: PNP: 00ff.2 missing set_resources
18.480: PNP: 164e.2 60 <- [0x00000002f8 - 0x00000002ff] size 0x00000008 gran 0x03 io
18.480: ERROR: PNP: 164e.2 70 irq size: 0x0000000001 not assigned
18.480: ERROR: PNP: 164e.2 74 drq size: 0x0000000001 not assigned
18.480: ERROR: PNP: 164e.2 75 drq size: 0x0000000001 not assigned
18.480: PNP: 164e.3 60 <- [0x0000000200 - 0x0000000207] size 0x00000008 gran 0x03 io
18.480: PNP: 164e.3 29 <- [0x00000000b0 - 0x00000000af] size 0x00000000 gran 0x00 irq
18.480: PNP: 164e.3 70 <- [0x0000000005 - 0x0000000005] size 0x00000001 gran 0x00 irq
18.480: PNP: 164e.3 f0 <- [0x0000000082 - 0x0000000081] size 0x00000000 gran 0x00 irq
18.480: PNP: 164e.7 60 <- [0x0000001680 - 0x000000168f] size 0x00000010 gran 0x04 io
18.480: ERROR: PNP: 164e.7 70 irq size: 0x0000000001 not assigned
18.480: PNP: 164e.19 60 <- [0x000000164c - 0x000000164d] size 0x00000002 gran 0x01 io
18.480: ERROR: PNP: 164e.19 70 irq size: 0x0000000001 not assigned
18.480: PNP: 002e.1 60 <- [0x00000003bc - 0x00000007bb] size 0x00000400 gran 0x0a io
18.480: PNP: 002e.1 70 <- [0x0000000007 - 0x0000000007] size 0x00000001 gran 0x00 irq
18.480: ERROR: PNP: 002e.1 74 drq size: 0x0000000001 not assigned
18.480: PNP: 002e.3 60 <- [0x00000003f8 - 0x00000003ff] size 0x00000008 gran 0x03 io
18.480: PNP: 002e.3 70 <- [0x0000000004 - 0x0000000004] size 0x00000001 gran 0x00 irq
18.480: PNP: 002e.7 60 <- [0x0000001620 - 0x0000001627] size 0x00000008 gran 0x03 io
18.480: ERROR: PNP: 002e.7 70 irq size: 0x0000000001 not assigned
18.480: PCI: 00:1f.1 10 <- [0x00000050b8 - 0x00000050bf] size 0x00000008 gran 0x03 io
18.480: PCI: 00:1f.1 14 <- [0x00000050d8 - 0x00000050db] size 0x00000004 gran 0x02 io
18.480: PCI: 00:1f.1 18 <- [0x00000050c0 - 0x00000050c7] size 0x00000008 gran 0x03 io
18.480: PCI: 00:1f.1 1c <- [0x00000050dc - 0x00000050df] size 0x00000004 gran 0x02 io
18.480: PCI: 00:1f.1 20 <- [0x00000050a0 - 0x00000050af] size 0x00000010 gran 0x04 io
18.480: PCI: 00:1f.2 10 <- [0x00000050c8 - 0x00000050cf] size 0x00000008 gran 0x03 io
18.480: PCI: 00:1f.2 14 <- [0x00000050e0 - 0x00000050e3] size 0x00000004 gran 0x02 io
18.480: PCI: 00:1f.2 18 <- [0x00000050d0 - 0x00000050d7] size 0x00000008 gran 0x03 io
18.480: PCI: 00:1f.2 1c <- [0x00000050e4 - 0x00000050e7] size 0x00000004 gran 0x02 io
18.480: PCI: 00:1f.2 20 <- [0x0000005080 - 0x000000509f] size 0x00000020 gran 0x05 io
18.480: PCI: 00:1f.2 24 <- [0x00e4445000 - 0x00e44453ff] size 0x00000400 gran 0x0a mem
18.480: Done setting resources.
18.480: Done allocating resources.
18.480: BS: BS_DEV_RESOURCES times (us): entry 0 run 539602 exit 0
18.480: Enabling resources...
18.480: PCI: 00:00.0 subsystem <- 17aa/2017
18.480: PCI: 00:00.0 cmd <- 06
18.480: PCI: 00:02.0 subsystem <- 17aa/201a
18.480: PCI: 00:02.0 cmd <- 03
18.480: PCI: 00:02.1 subsystem <- 17aa/201a
18.480: PCI: 00:02.1 cmd <- 02
18.480: PCI: 00:1b.0 subsystem <- 17aa/2010
18.480: PCI: 00:1b.0 cmd <- 102
18.480: PCI: 00:1c.0 bridge ctrl <- 0003
18.480: PCI: 00:1c.0 subsystem <- 8086/27d0
18.480: PCI: 00:1c.0 cmd <- 107
18.480: PCI: 00:1c.1 bridge ctrl <- 0003
18.480: PCI: 00:1c.1 subsystem <- 8086/27d2
18.480: PCI: 00:1c.1 cmd <- 106
18.480: PCI: 00:1c.2 bridge ctrl <- 0003
18.480: PCI: 00:1c.2 cmd <- 00
18.480: PCI: 00:1c.3 bridge ctrl <- 0003
18.480: PCI: 00:1c.3 cmd <- 00
18.480: PCI: 00:1d.0 subsystem <- 17aa/200a
18.480: PCI: 00:1d.0 cmd <- 01
18.480: PCI: 00:1d.1 subsystem <- 17aa/200a
18.480: PCI: 00:1d.1 cmd <- 01
18.480: PCI: 00:1d.2 subsystem <- 17aa/200a
18.480: PCI: 00:1d.2 cmd <- 01
18.480: PCI: 00:1d.3 subsystem <- 17aa/200a
18.480: PCI: 00:1d.3 cmd <- 01
18.480: PCI: 00:1d.7 subsystem <- 17aa/200b
18.480: PCI: 00:1d.7 cmd <- 102
18.480: PCI: 00:1e.0 bridge ctrl <- 0003
18.480: PCI: 00:1e.0 cmd <- 07
18.480: PCI: 00:1f.0 subsystem <- 17aa/2009
18.480: PCI: 00:1f.0 cmd <- 107
18.480: PCI: 00:1f.1 subsystem <- 17aa/200c
18.480: PCI: 00:1f.1 cmd <- 01
18.480: PCI: 00:1f.2 subsystem <- 17aa/200d
18.480: PCI: 00:1f.2 cmd <- 03
18.480: PCI: 00:1f.3 subsystem <- 17aa/200f
18.480: PCI: 00:1f.3 cmd <- 101
18.480: PCI: 01:00.0 cmd <- 03
18.480: PCI: 02:00.0 cmd <- 02
18.480: PCI: 05:00.0 bridge ctrl <- 0503
18.480: PCI: 05:00.0 cmd <- 03
18.480: PCI: 05:00.1 cmd <- 02
18.481: PCI: 05:00.2 cmd <- 06
18.481: done.
18.481: BS: BS_DEV_ENABLE times (us): entry 0 run 118104 exit 0
18.481: Initializing devices...
18.481: Root Device init ...
18.481: Root Device init finished in 2763 usecs
18.482: CPU_CLUSTER: 0 init ...
18.482: start_eip=0x00001000, code_size=0x00000031
18.482: Initializing SMM handler...
18.482: SMI_STS: MCSMI PM1 
18.482: PM1_STS: WAK PWRBTN 
18.482: GPE0_STS: GPIO15 GPIO14 GPIO13 GPIO12 GPIO11 GPIO10 GPIO7 GPIO6 GPIO5 GPIO4 GPIO3 GPIO2 GPIO1 GPIO0 
18.482: ALT_GP_SMI_STS: GPI15 GPI14 GPI13 GPI12 GPI11 GPI10 GPI7 GPI6 GPI5 GPI4 GPI3 GPI2 GPI1 GPI0 
18.483: TCO_STS: 
18.483: Initializing CPU #0
18.483: CPU: vendor Intel device 6ec
18.483: CPU: family 06, model 0e, stepping 0c
18.483: Enabling cache
18.483: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.483: CBFS: Locating 'cpu_microcode_blob.bin'
18.483: CBFS: Found @ offset d2c0 size 17000
18.483: microcode: sig=0x6ec pf=0x20 revision=0x0
18.485: microcode: updated to revision 0x54 date=2006-05-01
18.485: CPU: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz.
18.485: MTRR: Physical address space:
18.485: 0x0000000000000000 - 0x00000000000a0000 size 0x000a0000 type 6
18.485: 0x00000000000a0000 - 0x00000000000c0000 size 0x00020000 type 0
18.485: 0x00000000000c0000 - 0x000000007f800000 size 0x7f740000 type 6
18.485: 0x000000007f800000 - 0x00000000d0000000 size 0x50800000 type 0
18.485: 0x00000000d0000000 - 0x00000000e0000000 size 0x10000000 type 1
18.485: 0x00000000e0000000 - 0x0000000100000000 size 0x20000000 type 0
18.485: MTRR: Fixed MSR 0x250 0x0606060606060606
18.485: MTRR: Fixed MSR 0x258 0x0606060606060606
18.485: MTRR: Fixed MSR 0x259 0x0000000000000000
18.485: MTRR: Fixed MSR 0x268 0x0606060606060606
18.485: MTRR: Fixed MSR 0x269 0x0606060606060606
18.485: MTRR: Fixed MSR 0x26a 0x0606060606060606
18.485: MTRR: Fixed MSR 0x26b 0x0606060606060606
18.485: MTRR: Fixed MSR 0x26c 0x0606060606060606
18.485: MTRR: Fixed MSR 0x26d 0x0606060606060606
18.485: MTRR: Fixed MSR 0x26e 0x0606060606060606
18.485: MTRR: Fixed MSR 0x26f 0x0606060606060606
18.486: CPU physical address size: 32 bits
18.486: MTRR: default type WB/UC MTRR counts: 5/3.
18.486: MTRR: UC selected as default type.
18.486: MTRR: 0 base 0x0000000000000000 mask 0x0000000080000000 type 6
18.486: MTRR: 1 base 0x000000007f800000 mask 0x00000000ff800000 type 0
18.486: MTRR: 2 base 0x00000000d0000000 mask 0x00000000f0000000 type 1
18.487: 
18.487: MTRR check
18.487: Fixed MTRRs   : Enabled
18.487: Variable MTRRs: Enabled
18.487: 
18.487: Setting up local APIC... apic_id: 0x00 done.
18.487: VMX status: enabled, locked
18.487: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.487: CBFS: Locating 'cmos_layout.bin'
18.487: CBFS: Found @ offset 39100 size 6ac
18.488: CPU: 0 2 siblings
18.488: CPU: 0 has sibling 1
18.488: CPU #0 initialized
18.499: Initializing CPU #1
18.499: Waiting for 1 CPUS to stop
18.499: CPU: vendor Intel device 6ec
18.499: CPU: family 06, model 0e, stepping 0c
18.499: Enabling cache
18.499: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.499: CBFS: Locating 'cpu_microcode_blob.bin'
18.500: CBFS: Found @ offset d2c0 size 17000
18.500: microcode: sig=0x6ec pf=0x20 revision=0x0
18.502: microcode: updated to revision 0x54 date=2006-05-01
18.502: CPU: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz.
18.503: MTRR: Fixed MSR 0x250 0x0606060606060606
18.503: MTRR: Fixed MSR 0x258 0x0606060606060606
18.503: MTRR: Fixed MSR 0x259 0x0000000000000000
18.503: MTRR: Fixed MSR 0x268 0x0606060606060606
18.503: MTRR: Fixed MSR 0x269 0x0606060606060606
18.503: MTRR: Fixed MSR 0x26a 0x0606060606060606
18.503: MTRR: Fixed MSR 0x26b 0x0606060606060606
18.503: MTRR: Fixed MSR 0x26c 0x0606060606060606
18.504: MTRR: Fixed MSR 0x26d 0x0606060606060606
18.504: MTRR: Fixed MSR 0x26e 0x0606060606060606
18.504: MTRR: Fixed MSR 0x26f 0x0606060606060606
18.504: CPU physical address size: 32 bits
18.505: 
18.505: MTRR check
18.505: Fixed MTRRs   : Enabled
18.505: Variable MTRRs: Enabled
18.505: 
18.505: Setting up local APIC... apic_id: 0x01 done.
18.505: VMX status: enabled, locked
18.505: CPU: 1 2 siblings
18.505: CPU #1 initialized
18.505: CPU 1 going down...
18.505: All AP CPUs stopped (9737 loops)
18.505: CPU_CLUSTER: 0 init finished in 321825 usecs
18.505: PCI: 00:02.0 init ...
18.505: Initializing VGA without OPROM.
18.570: No display connected on slave 2
18.585: WARNING: EDID block does NOT fully conform to EDID 1.3.
18.585: <09>Missing name descriptor
18.585: <09>Missing monitor ranges
18.585: bringing up panel at resolution 1024 x 768
18.585: Borders 0 x 0
18.585: Blank 320 x 38
18.585: Sync 136 x 6
18.585: Front porch 24 x 3
18.585: Spread spectrum clock
18.585: Single channel
18.585: Polarities 1, 1
18.585: Pixel N=3, M1=15, M2=4, P1=2
18.585: Pixel clock 65000 kHz
18.585: VGA mode: text
18.592: waiting for panel powerup
18.592: panel powered up
18.592: gtt_setup is enabled.
18.592: 8M UMA
18.593: GTT PGETBL_CTL register: 0x7ffc0001
18.593: GTT Enabled
18.596: PCI: 00:02.0 init finished in 139580 usecs
18.596: PCI: 00:02.1 init ...
18.596: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.596: CBFS: Locating 'cmos_layout.bin'
18.596: CBFS: Found @ offset 39100 size 6ac
18.597: PCI: 00:02.1 init finished in 14413 usecs
18.597: PCI: 00:1b.0 init ...
18.598: Azalia: codec type: Azalia
18.598: Azalia: base = e4440000
18.600: Azalia: codec_mask = 03
18.600: Azalia: Initializing codec #1
18.600: Azalia: codec viddid: 14f12bfa
18.600: Azalia: No verb!
18.600: Azalia: Initializing codec #0
18.600: Azalia: codec viddid: 11d41981
18.600: Azalia: verb_size: 44
18.602: Azalia: verb loaded.
18.602: PCI: 00:1b.0 init finished in 30350 usecs
18.602: PCI: 00:1c.0 init ...
18.602: Initializing ICH7 PCIe bridge.
18.602: PCI: 00:1c.0 init finished in 4839 usecs
18.602: PCI: 00:1c.1 init ...
18.602: Initializing ICH7 PCIe bridge.
18.602: PCI: 00:1c.1 init finished in 4839 usecs
18.602: PCI: 00:1c.2 init ...
18.602: Initializing ICH7 PCIe bridge.
18.602: PCI: 00:1c.2 init finished in 4838 usecs
18.602: PCI: 00:1c.3 init ...
18.602: Initializing ICH7 PCIe bridge.
18.602: PCI: 00:1c.3 init finished in 4838 usecs
18.602: PCI: 00:1d.0 init ...
18.602: UHCI: Setting up controller.. done.
18.602: PCI: 00:1d.0 init finished in 5272 usecs
18.602: PCI: 00:1d.1 init ...
18.602: UHCI: Setting up controller.. done.
18.602: PCI: 00:1d.1 init finished in 5273 usecs
18.602: PCI: 00:1d.2 init ...
18.602: UHCI: Setting up controller.. done.
18.602: PCI: 00:1d.2 init finished in 5272 usecs
18.602: PCI: 00:1d.3 init ...
18.603: UHCI: Setting up controller.. done.
18.603: PCI: 00:1d.3 init finished in 5272 usecs
18.602: PCI: 00:1d.7 init ...
18.602: EHCI: Setting up controller.. done.
18.603: PCI: 00:1d.7 init finished in 5281 usecs
18.603: PCI: 00:1e.0 init ...
18.603: PCI: 00:1e.0 init finished in 2031 usecs
18.603: PCI: 00:1f.0 init ...
18.603: i82801gx: lpc_init
18.603: IOAPIC: Initializing IOAPIC at 0xfec00000
18.603: IOAPIC: Bootstrap Processor Local APIC = 0x00
18.603: IOAPIC: ID = 0x02
18.603: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.603: CBFS: Locating 'cmos_layout.bin'
18.603: CBFS: Found @ offset 39100 size 6ac
18.604: WARNING: No CMOS option 'power_on_after_fail'.
18.604: Set power on after power failure.
18.604: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
18.604: CBFS: Locating 'cmos_layout.bin'
18.604: CBFS: Found @ offset 39100 size 6ac
18.604: NMI sources enabled.
18.604: rtc_failed = 0x0
18.604: S3 wakeup, enabling ACPI via APMC
18.605: Locking SMM.
18.605: PCI: 00:1f.0 init finished in 53320 usecs
18.605: PCI: 00:1f.1 init ...
18.605: i82801gx_ide: initializing... IDE0
18.605: PCI: 00:1f.1 init finished in 5203 usecs
18.605: PCI: 00:1f.2 init ...
18.605: i82801gx_sata: initializing...
18.605: SATA controller in AHCI mode.
18.605: PCI: 00:1f.2 init finished in 7553 usecs
18.605: PCI: 01:00.0 init ...
18.605: PCI: 01:00.0 init finished in 2018 usecs
18.605: PCI: 02:00.0 init ...
18.605: PCI: 02:00.0 init finished in 2018 usecs
18.605: PCI: 05:00.0 init ...
18.605: Ricoh RL5c476: Initializing.
18.605: CF Base = 0
18.605: CF boot not enabled.
18.605: PCI: 05:00.0 init finished in 7726 usecs
18.605: PCI: 05:00.1 init ...
18.605: PCI: 05:00.1 init finished in 2020 usecs
18.605: PCI: 05:00.2 init ...
18.605: PCI: 05:00.2 init finished in 2018 usecs
18.605: PNP: 00ff.2 init ...
18.605: PNP: 00ff.2 init finished in 1931 usecs
18.605: PNP: 164e.2 init ...
18.605: PNP: 164e.2 init finished in 1932 usecs
18.605: PNP: 164e.3 init ...
18.605: PNP: 164e.3 init finished in 1931 usecs
18.605: PNP: 164e.7 init ...
18.605: PNP: 164e.7 init finished in 1932 usecs
18.605: PNP: 164e.19 init ...
18.605: PNP: 164e.19 init finished in 2018 usecs
18.605: PNP: 002e.1 init ...
18.605: PNP: 002e.1 init finished in 1931 usecs
18.605: PNP: 002e.3 init ...
18.605: PNP: 002e.3 init finished in 1932 usecs
18.605: PNP: 002e.7 init ...
18.605: PNP: 002e.7 init finished in 1932 usecs
18.605: smbus: PCI: 00:1f.3[0]->I2C: 01:69 init ...
18.619: Changing 12 of the 12 ck505 config bytes.
18.632: I2C: 01:69 init finished in 33851 usecs
18.632: smbus: PCI: 00:1f.3[0]->I2C: 01:54 init ...
18.631: I2C: 01:54 init finished in 3939 usecs
18.632: smbus: PCI: 00:1f.3[0]->I2C: 01:55 init ...
18.632: I2C: 01:55 init finished in 3941 usecs
18.632: smbus: PCI: 00:1f.3[0]->I2C: 01:56 init ...
18.632: I2C: 01:56 init finished in 3941 usecs
18.632: smbus: PCI: 00:1f.3[0]->I2C: 01:57 init ...
18.632: I2C: 01:57 init finished in 3939 usecs
18.632: smbus: PCI: 00:1f.3[0]->I2C: 01:5c init ...
18.632: Locking EEPROM RFID
18.653: init EEPROM done
18.653: I2C: 01:5c init finished in 28970 usecs
18.653: smbus: PCI: 00:1f.3[0]->I2C: 01:5d init ...
18.653: I2C: 01:5d init finished in 3941 usecs
18.653: smbus: PCI: 00:1f.3[0]->I2C: 01:5e init ...
18.653: I2C: 01:5e init finished in 3941 usecs
18.653: smbus: PCI: 00:1f.3[0]->I2C: 01:5f init ...
18.653: I2C: 01:5f init finished in 3940 usecs
18.653: Devices initialized
18.653: BS: BS_DEV_INIT times (us): entry 7 run 894011 exit 0
18.653: Finalize devices...
18.654: Devices finalized
18.653: BS: BS_POST_DEVICE times (us): entry 0 run 3507 exit 0
18.653: Trying to find the wakeup vector...
18.654: Looking on 000f0800 for valid checksum
18.654: Checksum 1 passed
18.654: Checksum 2 passed all OK
18.654: RSDP found at 000f0800
18.654: RSDT found at 7f70d030 ends at 7f70d06c
18.654: FADT found at 7f7102a0
18.654: FACS found at 7f70d240
18.654: OS waking vector is 0009c090
18.654: BS: BS_OS_RESUME_CHECK times (us): entry 0 run 23173 exit 0
18.655: [  163.759004] ACPI: Low-level resume complete
18.655: [  163.759004] ACPI: EC: EC started
18.655: [  163.759004] PM: Restoring platform NVS memory
18.655: [  163.759004] PM: Calling bsp_resume+0x0/0x30
18.655: [  163.759004] PM: Calling lapic_resume+0x0/0x4c0
18.655: [  163.759004] PM: Calling acpi_restore_bm_rld+0x0/0x60
18.655: [  163.759004] PM: Calling irqrouter_resume+0x0/0x60
18.655: [  163.759004] PM: Calling i8259A_resume+0x0/0x30
18.655: [  163.759004] PM: Calling i8237A_resume+0x0/0xc0
18.655: [  163.759004] PM: Calling ioapic_resume+0x0/0x1e0
18.655: [  163.759004] PM: Calling irq_gc_resume+0x0/0x90
18.655: [  163.759004] PM: Calling irq_pm_syscore_resume+0x0/0x20
18.655: [  163.759004] PM: Calling timekeeping_resume+0x0/0x420
18.655: [  163.759004] PM: Calling ledtrig_cpu_syscore_resume+0x0/0x20
18.655: [  163.759004] PM: Calling mce_syscore_resume+0x0/0x30
18.655: [  163.759004] PM: Calling mc_bp_resume+0x0/0x140
18.656: [  163.759004] PM: Calling kvm_resume+0x0/0x40 [kvm]
18.656: [  183.346657] Enabling non-boot CPUs ...
18.656: [  183.350589] x86: Booting SMP configuration:
18.656: [  183.354809] smpboot: Booting Node 0 Processor 1 APIC 0x1
18.657: [  163.728008] Initializing CPU#1
18.657: [  163.728008] Disabled fast string operations
18.657: [  183.368517]  cache: parent cpu1 should not be sleeping
18.658: [  183.374036] CPU1 is up
18.659: [  183.378067] ACPI: Waking up from system sleep state S3
18.666: [  183.390193] calling  0000:00:00.0+ @ 119, parent: pci0000:00
18.666: [  183.390316] calling  PNP0C09:00+ @ 690, parent: device:22
18.666: [  183.395927] call 0000:00:00.0+ returned 0 after 48 usecs
18.666: [  183.401303] ACPI: EC: interrupt unblocked
18.666: [  183.406646] calling  0000:00:02.0+ @ 707, parent: pci0000:00
18.666: [  183.410647] call PNP0C09:00+ returned 0 after 9125 usecs
18.666: [  183.416333] calling  0000:00:02.1+ @ 119, parent: pci0000:00
18.666: [  183.421655] calling  0000:00:1b.0+ @ 713, parent: pci0000:00
18.667: [  183.427369] call 0000:00:02.1+ returned 0 after 38 usecs
18.667: [  183.433109] calling  0000:00:1c.0+ @ 117, parent: pci0000:00
18.667: [  183.438377] call 0000:00:02.0+ returned 0 after 21536 usecs
18.667: [  183.444197] call 0000:00:1c.0+ returned 0 after 178 usecs
18.667: [  183.449607] calling  0000:00:1c.1+ @ 707, parent: pci0000:00
18.667: [  183.455026] calling  0000:00:1c.2+ @ 120, parent: pci0000:00
18.667: [  183.460875] call 0000:00:1c.1+ returned 0 after 173 usecs
18.667: [  183.466550] call 0000:00:1c.2+ returned 0 after 175 usecs
18.667: [  183.471794] calling  0000:00:1c.3+ @ 119, parent: pci0000:00
18.667: [  183.477212] calling  0000:00:1d.0+ @ 706, parent: pci0000:00
18.667: [  183.483068] call 0000:00:1c.3+ returned 0 after 179 usecs
18.667: [  183.488617] call 0000:00:1d.0+ returned 0 after 58 usecs
18.667: [  183.493981] calling  0000:00:1d.1+ @ 707, parent: pci0000:00
18.667: [  183.499310] calling  0000:00:1d.2+ @ 709, parent: pci0000:00
18.667: [  183.505048] call 0000:00:1d.1+ returned 0 after 64 usecs
18.667: [  183.510714] call 0000:00:1d.2+ returned 0 after 58 usecs
18.667: [  183.515989] calling  0000:00:1d.3+ @ 119, parent: pci0000:00
18.667: [  183.521311] calling  0000:00:1d.7+ @ 710, parent: pci0000:00
18.667: [  183.521444] call 0000:00:1b.0+ returned 0 after 86365 usecs
18.667: [  183.527075] call 0000:00:1d.3+ returned 0 after 63 usecs
18.667: [  183.532688] calling  0000:00:1e.0+ @ 709, parent: pci0000:00
18.667: [  183.532759] call 0000:00:1e.0+ returned 0 after 66 usecs
18.667: [  183.538293] calling  0000:00:1f.0+ @ 714, parent: pci0000:00
18.667: [  183.543621] calling  0000:00:1f.1+ @ 716, parent: pci0000:00
18.667: [  183.549367] call 0000:00:1f.0+ returned 0 after 72 usecs
18.667: [  183.554683] call 0000:00:1f.1+ returned 0 after 54 usecs
18.667: [  183.560346] calling  0000:00:1f.2+ @ 707, parent: pci0000:00
18.667: [  183.565990] calling  0000:01:00.0+ @ 715, parent: 0000:00:1c.0
18.668: [  183.571327] calling  0000:02:00.0+ @ 118, parent: 0000:00:1c.1
18.668: [  183.576740] call 0000:00:1d.7+ returned 0 after 54125 usecs
18.668: [  183.582348] calling  0000:05:00.0+ @ 712, parent: 0000:00:1e.0
18.668: [  183.588186] calling  0000:05:00.1+ @ 706, parent: 0000:00:1e.0
18.668: [  183.588199] calling  0000:05:00.2+ @ 713, parent: 0000:00:1e.0
18.668: [  183.594172] yenta_cardbus 0000:05:00.0: calling  ricoh_mmc_fixup_rl5c476+0x0/0x110 @ 712
18.668: [  183.599794] call 0000:00:1f.2+ returned 0 after 27814 usecs
18.668: [  183.605495] yenta_cardbus 0000:05:00.0: ricoh_mmc_fixup_rl5c476+0x0/0x110 took 3 usecs
18.668: [  183.611514] call 0000:01:00.0+ returned 0 after 34056 usecs
18.668: [  183.617186] yenta_cardbus 0000:05:00.0: calling  quirk_cardbus_legacy+0x0/0x20 @ 712
18.668: [  183.617195] yenta_cardbus 0000:05:00.0: quirk_cardbus_legacy+0x0/0x20 took 2 usecs
18.668: [  183.625402] call 0000:05:00.1+ returned 0 after 36340 usecs
18.668: [  183.630928] call 0000:05:00.0+ returned 0 after 36019 usecs
18.668: [  183.638892] call 0000:05:00.2+ returned 0 after 38341 usecs
18.668: [  183.644425] calling  PNP0C0B:00+ @ 690, parent: platform
18.668: [  183.652622] call 0000:02:00.0+ returned 0 after 68648 usecs
18.668: [  183.659761] call PNP0C0B:00+ returned 0 after 1 usecs
18.668: [  183.692499] calling  BOOT0000:00+ @ 690, parent: platform
18.668: [  183.697916] call BOOT0000:00+ returned 0 after 1 usecs
18.668: [  183.703125] calling  i8042+ @ 690, parent: platform
18.668: [  183.708022] call i8042+ returned 0 after 2 usecs
18.668: [  183.712725] calling  pcmcia_socket0+ @ 690, parent: 0000:05:00.0
18.669: [  183.718872] call pcmcia_socket0+ returned 0 after 118 usecs
18.669: [  183.724462] calling  iTCO_wdt.0.auto+ @ 690, parent: 0000:00:1f.0
18.669: [  183.730570] call iTCO_wdt.0.auto+ returned 0 after 1 usecs
18.669: [  183.736243] pciehp 0000:00:1c.0:pcie004: Slot(0): Link Up
18.669: [  183.741673] calling  0000:00:02.0+ @ 707, parent: pci0000:00
18.669: [  183.741812] calling  PNP0C0B:00+ @ 690, parent: platform
18.669: [  183.747396] call 0000:00:02.0+ returned 0 after 37 usecs
18.670: [  183.759470] call PNP0C0B:00+ returned 0 after 6623 usecs
18.670: [  183.764802] calling  BOOT0000:00+ @ 690, parent: platform
18.670: [  183.770217] call BOOT0000:00+ returned 0 after 1 usecs
18.671: [  183.775651] calling  PNP0C09:00+ @ 690, parent: device:22
18.671: [  183.775690] calling  0000:00:00.0+ @ 119, parent: pci0000:00
18.671: [  183.781070] ACPI: EC: event unblocked
18.671: [  183.786744] call 0000:00:00.0+ returned 0 after 2 usecs
18.671: [  183.790421] call PNP0C09:00+ returned 0 after 9131 usecs
18.671: [  183.795657] calling  0000:00:1d.0+ @ 713, parent: pci0000:00
18.671: [  183.800984] calling  ACPI0003:00+ @ 690, parent: PNP0C09:00
18.671: [  183.801051] calling  0000:00:1d.7+ @ 716, parent: pci0000:00
18.671: [  183.807143] usb usb1: root hub lost power or was reset
18.671: [  183.812273] calling  0000:00:1c.2+ @ 715, parent: pci0000:00
18.671: [  183.817952] call 0000:00:1d.0+ returned 0 after 10851 usecs
18.671: [  183.823122] call 0000:00:1c.2+ returned 0 after 18 usecs
18.671: [  183.828775] calling  0000:00:1e.0+ @ 119, parent: pci0000:00
18.671: [  183.834368] calling  0000:00:1c.3+ @ 706, parent: pci0000:00
18.671: [  183.839702] call 0000:00:1e.0+ returned 0 after 10 usecs
18.671: [  183.845387] call 0000:00:1c.3+ returned 0 after 16 usecs
18.671: [  183.851046] calling  0000:00:1f.0+ @ 713, parent: pci0000:00
18.671: [  183.851052] call 0000:00:1f.0+ returned 0 after 1 usecs
18.671: [  183.856396] calling  0000:00:1f.1+ @ 118, parent: pci0000:00
18.671: [  183.861706] calling  0000:00:1f.2+ @ 119, parent: pci0000:00
18.671: [  183.861749] call 0000:00:1f.2+ returned 0 after 38 usecs
18.672: [  183.867393] call 0000:00:1f.1+ returned 0 after 1 usecs
18.672: [  183.872660] calling  0000:00:02.0+ @ 710, parent: pci0000:00
18.672: [  183.878445] calling  0000:05:00.0+ @ 118, parent: 0000:00:1e.0
18.672: [  183.884047] calling  0000:05:00.1+ @ 709, parent: 0000:00:1e.0
18.672: [  183.889320] call 0000:05:00.0+ returned 0 after 1 usecs
18.672: [  183.894568] calling  0000:00:1c.1+ @ 708, parent: pci0000:00
18.672: [  183.900289] calling  0000:05:00.2+ @ 706, parent: 0000:00:1e.0
18.672: [  183.906094] call 0000:00:1c.1+ returned 0 after 10 usecs
18.672: [  183.911941] sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
18.672: [  183.917181] calling  0000:00:1c.0+ @ 120, parent: pci0000:00
18.672: [  183.922867] sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
18.672: [  183.928708] calling  0000:00:1d.2+ @ 711, parent: pci0000:00
18.672: [  183.934100] calling  ata1+ @ 718, parent: 0000:00:1f.2
18.672: [  183.943437] calling  0000:00:1d.1+ @ 714, parent: pci0000:00
18.672: [  183.943541] usb usb3: root hub lost power or was reset
18.672: [  183.949134] call ata1+ returned 0 after 9 usecs
18.672: [  183.958513] call 0000:00:1d.1+ returned 0 after 14719 usecs
18.672: [  183.964227] calling  0000:00:1b.0+ @ 712, parent: pci0000:00
18.672: [  183.969337] calling  0000:00:1d.3+ @ 117, parent: pci0000:00
18.672: [  183.969440] usb usb5: root hub lost power or was reset
18.672: [  183.975041] calling  0000:00:02.1+ @ 6, parent: pci0000:00
18.672: [  183.980164] call 0000:00:1d.3+ returned 0 after 10569 usecs
18.672: [  183.984713] call 0000:00:02.1+ returned 0 after 2 usecs
18.672: [  183.990297] calling  0000:02:00.0+ @ 119, parent: 0000:00:1c.1
18.672: [  183.996039] call ACPI0003:00+ returned 0 after 190478 usecs
18.672: [  184.001666] call 0000:02:00.0+ returned 0 after 19 usecs
18.672: [  184.006852] calling  ata2+ @ 707, parent: 0000:00:1f.2
18.672: [  184.015779] usb usb4: root hub lost power or was reset
18.672: [  184.017927] call ata2+ returned 0 after 8 usecs
18.673: [  184.023167] call 0000:00:1d.2+ returned 0 after 77864 usecs
18.673: [  184.029014] calling  ata3+ @ 719, parent: 0000:00:1f.2
18.673: [  184.034622] call 0000:00:1d.7+ returned 0 after 217141 usecs
18.673: [  184.039924] call ata3+ returned 0 after 7 usecs
18.673: [  184.045341] pciehp 0000:00:1c.0:pcie004: Timeout on hotplug command 0x1038 (issued 163980 msec ago)
18.673: [  184.050420] calling  PNP0C0A:00+ @ 690, parent: PNP0C09:00
18.673: [  184.054817] calling  ata4+ @ 716, parent: 0000:00:1f.2
18.673: [  184.060420] calling  host0+ @ 720, parent: ata1
18.673: [  184.065557] call ata4+ returned 0 after 7 usecs
18.673: [  184.071230] call host0+ returned 0 after 2 usecs
18.673: [  184.075849] calling  host1+ @ 721, parent: ata2
18.673: [  184.084906] calling  host2+ @ 118, parent: ata3
18.673: [  184.090505] call host1+ returned 0 after 3 usecs
18.673: [  184.095518] call host2+ returned 0 after 2 usecs
18.673: [  184.100119] call 0000:05:00.1+ returned 0 after 200744 usecs
18.673: [  184.104643] call PNP0C0A:00+ returned 0 after 43209 usecs
18.673: [  184.113805] calling  host3+ @ 117, parent: ata4
18.673: [  184.118367] calling  target0:0:0+ @ 719, parent: host0
18.673: [  184.122990] call host3+ returned 0 after 1 usecs
18.673: [  184.123168] calling  usb1+ @ 714, parent: 0000:00:1d.0
18.673: [  184.127629] call target0:0:0+ returned 0 after 1 usecs
18.673: [  184.127668] call 0000:00:1b.0+ returned 0 after 149074 usecs
18.673: [  184.133342] calling  0:0:0:0+ @ 708, parent: target0:0:0
18.673: [  184.138735] calling  hdaudioC0D0+ @ 707, parent: 0000:00:1b.0
18.673: [  184.139505] call hdaudioC0D0+ returned 0 after 746 usecs
18.673: [  184.143302] BUG: unable to handle kernel NULL pointer dereference at 000000f4
18.673: [  184.143306] *pde = 00000000 
18.673: [  184.143312] Oops: 0002 [#1] SMP
18.674: [  184.148479] calling  usb2+ @ 720, parent: 0000:00:1d.7
18.674: [  184.148471] Modules linked in: i915 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm drm_panel_orientation_quirks i2c_algo_bit serport binfmt_misc
18.674: [  184.158340] calling  PNP0C0A:01+ @ 690, parent: PNP0C09:00
18.674: [  184.148471]  mousedev iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm irqbypass psmouse snd_pcsp arc4 pcmcia sdhci_pci cqhci iwl3945 lpc_ich mfd_core iwlegacy
18.674: [  184.169352] call 0000:05:00.2+ returned 0 after 251381 usecs
18.674: [  184.169336]  i2c_i801 sdhci mmc_core mac80211 snd_hda_codec_analog snd_hda_codec_generic firewire_ohci yenta_socket pcmcia_rsrc firewire_core crc_itu_t pcmcia_core rng_core cfg80211 snd_hda_intel ehci_pci e1000e thinkpad_acpi snd_hda_codec uhci_hcd snd_hda_core snd_hwdep snd_pcm snd_timer
18.674: [  184.180378] calling  phy0+ @ 727, parent: 0000:02:00.0
18.674: [  184.180362]  ehci_hcd nvram rfkill battery snd soundcore usbcore video button shpchp ac acpi_cpufreq ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto cbc dm_crypt dm_mod sd_mod ahci
18.674: [  184.192683] call PNP0C0A:01+ returned 0 after 23063 usecs
18.674: [  184.180362]  libahci evdev libata serio_raw scsi_mod fan thermal
18.674: [  184.180362] CPU: 0 PID: 708 Comm: kworker/u4:7 Not tainted 4.17.0-rc2+ #14
18.674: [  184.198715] calling  PNP0C0E:00+ @ 690, parent: PNP0C09:00
18.674: [  184.198705] Hardware name: LENOVO 636338U/636338U, BIOS CBET4000 TIMELESS 01/01/1970
18.674: [  184.198705] Workqueue: events_unbound async_run_entry_fn
18.674: [  184.198705] EIP: blk_set_runtime_active+0x4f/0xc0
18.674: [  184.198705] EFLAGS: 00010013 CPU: 0
18.674: [  184.198705] EAX: 00000000 EBX: f665f740 ECX: f665f838 EDX: 00000000
18.674: [  184.198705] ESI: 00000000 EDI: ffff7bbe EBP: f1afde38 ESP: f1afde24
18.674: [  184.218335] call PNP0C0E:00+ returned 0 after 2 usecs
18.674: [  184.198705]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
18.674: [  184.198705] CR0: 80050033 CR2: 000000f4 CR3: 0e40a000 CR4: 000006d0
18.674: [  184.198705] Call Trace:
18.674: [  184.198705]  ? async_sdev_thaw+0x20/0x20 [scsi_mod]
18.674: [  184.198705]  scsi_bus_resume_common+0x79/0x180 [scsi_mod]
18.674: [  184.238364] call phy0+ returned 0 after 44664 usecs
18.674: [  184.198705]  scsi_bus_resume+0x12/0x20 [scsi_mod]
18.674: [  184.198705]  dpm_run_callback+0x47/0x1b0
18.674: [  184.198705]  ? scsi_bus_thaw+0x20/0x20 [scsi_mod]
18.674: [  184.198705]  device_resume+0x97/0x190
18.674: [  184.269566] calling  usb3+ @ 727, parent: 0000:00:1d.1
18.674: [  184.198705]  ? device_resume+0x190/0x190
18.674: [  184.198705]  async_resume+0x1e/0x50
18.675: [  184.198705]  async_run_entry_fn+0x61/0x3a0
18.675: [  184.198705]  ? __schedule+0x2f5/0xcf0
18.675: [  184.198705]  ? try_to_wake_up+0x4d/0x790
18.675: [  184.198705]  ? __switch_to_asm+0x33/0x4c
18.675: [  184.291885] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
18.675: [  184.198705]  ? pwq_dec_nr_in_flight+0x7c/0x150
18.675: [  184.198705]  process_one_work+0x235/0x690
18.675: [  184.198705]  worker_thread+0x19d/0x6a0
18.675: [  184.198705]  kthread+0x14a/0x1f0
18.675: [  184.198705]  ? process_one_work+0x690/0x690
18.675: [  184.198705]  ? kthread_create_worker_on_cpu+0x30/0x30
18.675: [  184.198705]  ret_from_fork+0x2e/0x38
18.675: [  184.198705] Code: 
18.675: [  184.303294] call usb2+ returned 0 after 141649 usecs
18.675: [  184.198705] 7e 8b 83 fc 00 00 00 e8 e0 32 53 00 8b b3 50 01 
18.675: [  184.315689] calling  usb4+ @ 118, parent: 0000:00:1d.2
18.675: [  184.198705] 00 00 31 c0 8b 3d 20 7d ea cd 89 83 54 01 00 00 81 fe 0c 
18.675: [  184.328767] call usb1+ returned 0 after 190866 usecs
18.675: [  184.198705] ff ff ff 89 7d ec 74 46 <89> be f4 00 00 00 ba 09 00 00 00 8b 83 50 01 00 00 e8 0b 25 24 
18.675: [  184.198705] EIP: blk_set_runtime_active+0x4f/0xc0 SS:ESP: 0068:f1afde24
18.675: [  184.198705] CR2: 00000000000000f4
18.675: [  184.336955] calling  2-6+ @ 6, parent: usb2
18.675: [  184.198705] ---[ end trace 94bb43426dd6105a ]---
18.675: [  184.343340] call 0000:00:1c.0+ returned 0 after 404919 usecs
18.675: [  184.349517] calling  usb5+ @ 723, parent: 0000:00:1d.3
18.675: [  184.354584] calling  0000:01:00.0+ @ 713, parent: 0000:00:1c.0
18.675: [  184.360799] calling  PNP0C0D:00+ @ 690, parent: PNP0C09:00
18.676: [  184.452298] call 0000:01:00.0+ returned 0 after 84007 usecs
18.676: [  184.460343] ACPI: button: The lid device is not compliant to SW_LID.
18.676: [  184.460356] call PNP0C0D:00+ returned 0 after 5020 usecs
18.676: [  184.480163] call usb4+ returned 0 after 147900 usecs
18.676: [  184.481794] calling  dock.0+ @ 690, parent: platform
18.676: [  184.488250] call usb3+ returned 0 after 191822 usecs
18.676: [  184.493212] call dock.0+ returned 0 after 1 usecs
18.676: [  184.502478] usb 2-6: reset high-speed USB device number 2 using ehci-pci
18.676: [  184.509138] calling  LNXTHERM:00+ @ 690, parent: LNXSYBUS:01
18.676: [  184.512409] call usb5+ returned 0 after 148844 usecs
18.676: [  184.527198] call 0000:00:02.0+ returned 0 after 628135 usecs
18.676: [  184.532128] call LNXTHERM:00+ returned 0 after 38 usecs
18.690: [  184.608716] calling  LNXTHERM:01+ @ 690, parent: LNXSYBUS:01
18.693: [  184.608722] call LNXTHERM:01+ returned 0 after 3 usecs
18.696: [  184.608742] calling  PNP0C09:00+ @ 690, parent: 0000:00:1f.0
18.699: [  184.608746] call PNP0C09:00+ returned 0 after 1 usecs
18.702: [  184.608748] calling  IBM0068:00+ @ 690, parent: PNP0C09:00
18.705: [  184.608752] call IBM0068:00+ returned 0 after 1 usecs
18.709: [  184.608755] calling  ACPI0003:00+ @ 690, parent: PNP0C09:00
18.712: [  184.608758] call ACPI0003:00+ returned 0 after 1 usecs
18.715: [  184.608761] calling  PNP0C0A:00+ @ 690, parent: PNP0C09:00
18.718: [  184.608764] call PNP0C0A:00+ returned 0 after 1 usecs
18.722: [  184.608767] calling  PNP0C0A:01+ @ 690, parent: PNP0C09:00
18.725: [  184.608770] call PNP0C0A:01+ returned 0 after 1 usecs
18.728: [  184.608773] calling  PNP0C0E:00+ @ 690, parent: PNP0C09:00
18.731: [  184.608776] call PNP0C0E:00+ returned 0 after 1 usecs
18.735: [  184.608779] calling  PNP0C0D:00+ @ 690, parent: PNP0C09:00
18.738: [  184.608782] call PNP0C0D:00+ returned 0 after 1 usecs
18.741: [  184.608785] calling  INT0800:00+ @ 690, parent: 0000:00:1f.0
18.744: [  184.608788] call INT0800:00+ returned 0 after 1 usecs
18.748: [  184.608791] calling  PNP0C04:00+ @ 690, parent: 0000:00:1f.0
18.751: [  184.608795] call PNP0C04:00+ returned 0 after 1 usecs
18.754: [  184.608798] calling  PNP0C0B:00+ @ 690, parent: platform
18.757: [  184.608827] call PNP0C0B:00+ returned 0 after 25 usecs
18.761: [  184.608831] calling  LNXPWRBN:00+ @ 690, parent: LNXSYSTM:00
18.764: [  184.608835] call LNXPWRBN:00+ returned 0 after 1 usecs
18.767: [  184.608843] calling  00:00+ @ 690, parent: pnp0
18.771: [  184.608848] call 00:00+ returned 0 after 2 usecs
18.774: [  184.608850] calling  00:01+ @ 690, parent: pnp0
18.777: [  184.608854] call 00:01+ returned 0 after 1 usecs
18.780: [  184.608856] calling  00:02+ @ 690, parent: pnp0
18.784: [  184.608860] call 00:02+ returned 0 after 1 usecs
18.787: [  184.608862] calling  00:03+ @ 690, parent: pnp0
18.790: [  184.608948] call 00:03+ returned 0 after 80 usecs
18.793: [  184.608950] calling  00:04+ @ 690, parent: pnp0
18.797: [  184.608954] call 00:04+ returned 0 after 1 usecs
18.800: [  184.608956] calling  00:05+ @ 690, parent: pnp0
18.803: [  184.608960] call 00:05+ returned 0 after 1 usecs
18.806: [  184.608962] calling  00:06+ @ 690, parent: pnp0
18.810: [  184.609084] call 00:06+ returned 0 after 116 usecs
18.813: [  184.609099] calling  00:07+ @ 690, parent: pnp0
18.816: [  184.609122] call 00:07+ returned 0 after 19 usecs
18.819: [  184.609181] calling  pcspkr+ @ 690, parent: platform
18.823: [  184.609185] call pcspkr+ returned 0 after 1 usecs
18.826: [  184.609187] calling  platform-framebuffer.0+ @ 690, parent: platform
18.829: [  184.609191] call platform-framebuffer.0+ returned 0 after 1 usecs
18.832: [  184.609196] calling  alarmtimer+ @ 690, parent: platform
18.836: [  184.609202] call alarmtimer+ returned 0 after 2 usecs
18.839: [  184.609216] calling  serial8250+ @ 690, parent: platform
18.842: [  184.609221] call serial8250+ returned 0 after 2 usecs
18.845: [  184.609228] calling  i8042+ @ 690, parent: platform
18.848: [  184.611708] call i8042+ returned 0 after 2419 usecs
18.851: [  184.611710] calling  serio0+ @ 690, parent: i8042
18.854: [  184.611719] call serio0+ returned 0 after 6 usecs
18.857: [  184.611737] calling  serio1+ @ 690, parent: i8042
18.860: [  184.611745] call serio1+ returned 0 after 5 usecs
18.863: [  184.611752] calling  rtc0+ @ 690, parent: 00:03
18.866: [  184.611756] call rtc0+ returned 0 after 1 usecs
18.869: [  184.611760] calling  memconsole+ @ 690, parent: platform
18.872: [  184.611763] call memconsole+ returned 0 after 1 usecs
18.875: [  184.611766] calling  input1+ @ 690, parent: serio0
18.877: [  184.611772] call input1+ returned 0 after 3 usecs
18.880: [  184.611774] calling  input1::numlock+ @ 690, parent: input1
18.883: [  184.611778] call input1::numlock+ returned 0 after 1 usecs
18.886: [  184.611781] calling  input1::capslock+ @ 690, parent: input1
18.889: [  184.611784] call input1::capslock+ returned 0 after 1 usecs
18.892: [  184.611787] calling  input1::scrolllock+ @ 690, parent: input1
18.895: [  184.611790] call input1::scrolllock+ returned 0 after 1 usecs
18.898: [  184.611795] calling  microcode+ @ 690, parent: platform
18.901: [  184.611798] call microcode+ returned 0 after 1 usecs
18.904: [  184.747087] ata1.00: configured for UDMA/100
18.907: [  184.755391] firewire_core 0000:05:00.1: rediscovered device fw0
19.024: [  185.308592] call 2-6+ returned 0 after 936609 usecs
21.020: [  187.309066] e1000e: eth8 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
21.023: [  187.319869] IPv6: ADDRCONF(NETDEV_CHANGE): eth8: link becomes ready

--------------1D77A5019546E2FD3B843EA9--
