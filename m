From: Yijing Wang <wangyijing@huawei.com>
Subject: Fail to probe qla2xxx fiber channel card while doing pci hotplug
Date: Sat, 15 Sep 2012 18:22:53 +0800
Message-ID: <505456FD.6040801@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, PCI <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,
   I encountered a very strange problem when I hot plug a fiber channel card(using qla2xxx driver).
I did the hotplug in arch x86 machine, using pciehp driver for hotplug, this platform supports pci hot-plug triggering from both
sysfs and attention button. If a hot-plug slot is empty when system boot-up, then hotplug FC card in this slot is ok.
If a hot-plug slot has been embeded a FC card when system boot-up, hot-remove this card is ok, but hot-add this card will fail.
I used
#modprobe qla2xxx ql2xextended_error_logging=0x7fffffff
to get all probe info. As bellow:

Can anyone give me any suggestion for this problem?
Thanks very much!

[  511.011780] pci 0000:06:00.0: [1077:2532] type 0 class 0x000c04
[  511.011803] pci 0000:06:00.0: reg 10: [io  0x0000-0x00ff]
[  511.011821] pci 0000:06:00.0: reg 14: [mem 0x00000000-0x00003fff 64bit]
[  511.011856] pci 0000:06:00.0: reg 30: [mem 0x00000000-0x0003ffff pref]
[  511.011922] pci 0000:06:00.1: [1077:2532] type 0 class 0x000c04
[  511.011937] pci 0000:06:00.1: reg 10: [io  0x0000-0x00ff]
[  511.011953] pci 0000:06:00.1: reg 14: [mem 0x00000000-0x00003fff 64bit]
[  511.011989] pci 0000:06:00.1: reg 30: [mem 0x00000000-0x0003ffff pref]
[  511.019751] pci 0000:06:00.0: BAR 6: assigned [mem 0xf1000000-0xf103ffff pref]
[  511.019759] pci 0000:06:00.1: BAR 6: assigned [mem 0xf1040000-0xf107ffff pref]
[  511.019765] pci 0000:06:00.0: BAR 1: assigned [mem 0xf8000000-0xf8003fff 64bit]
[  511.019775] pci 0000:06:00.0: BAR 1: set to [mem 0xf8000000-0xf8003fff 64bit] (PCI address [0xf8000000-0xf8003fff])
[  511.019781] pci 0000:06:00.1: BAR 1: assigned [mem 0xf8004000-0xf8007fff 64bit]
[  511.019791] pci 0000:06:00.1: BAR 1: set to [mem 0xf8004000-0xf8007fff 64bit] (PCI address [0xf8004000-0xf8007fff])
[  511.019797] pci 0000:06:00.0: BAR 0: assigned [io  0xc000-0xc0ff]
[  511.019804] pci 0000:06:00.0: BAR 0: set to [io  0xc000-0xc0ff] (PCI address [0xc000-0xc0ff])
[  511.019809] pci 0000:06:00.1: BAR 0: assigned [io  0xc400-0xc4ff]
[  511.019816] pci 0000:06:00.1: BAR 0: set to [io  0xc400-0xc4ff] (PCI address [0xc400-0xc4ff])
[  511.019822] pcieport 0000:00:07.0: PCI bridge to [bus 06-07]
[  511.019827] pcieport 0000:00:07.0:   bridge window [io  0xc000-0xcfff]
[  511.019834] pcieport 0000:00:07.0:   bridge window [mem 0xf8000000-0xf8ffffff]
[  511.019840] pcieport 0000:00:07.0:   bridge window [mem 0xf1000000-0xf1ffffff 64bit pref]
[  511.019856] pcieport 0000:00:07.0: setting latency timer to 64
[  511.020226] qla2xxx [0000:06:00.0]-0807: : Mem only adapter.
[  511.020232] qla2xxx [0000:06:00.0]-0808: : Bars=66.
[  511.020243] qla2xxx 0000:06:00.0: enabling device (0100 -> 0102)
[  511.020256] qla2xxx 0000:06:00.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
[  511.020270] qla2xxx [0000:06:00.0]-080a: : Memory allocated for ha=ffff88084c6ae000.
[  511.020281] qla2xxx [0000:06:00.0]-080b: : device_type=0x9c000800 port=1 fw_srisc_address=0000000000100000.
[  511.021139] qla2xxx [0000:06:00.0]-081c: : MSIX Count:2.
[  511.021142] qla2xxx [0000:06:00.0]-001d: : Found an ISP2532 irq 30 iobase 0xffffc900060c2000.
[  511.021147] qla2xxx [0000:06:00.0]-081e: : mbx_count=32, req_length=2048, rsp_length=512, max_loop_id=2047, init_cb_size=5252, gid_list_info_size=8, optrom_size=2097152, nvram_npiv_size=256, .
[  511.021152] qla2xxx [0000:06:00.0]-081f: : isp_ops=ffffffffa04745e0, flash_conf_off=2147287040, flash_data_off=2146435072, nvram_conf_off=2147418112, nvram_data_off=2147352576.
[  511.021164] qla2xxx [0000:06:00.0]-0820: : 64 Bit addressing is enable.
[  511.021207] qla2xxx [0000:06:00.0]-0822: : init_cb=ffff88084e48a000 gid_list=ffff88084ebd5000, srb_mempool=ffff88084b0b5440 s_dma_pool=ffff88084d9b5840.
[  511.021223] qla2xxx [0000:06:00.0]-0827: : ms_iocb=ffff88084e2a0000 ct_sns=ffff88084f132000.
[  511.021332] qla2xxx [0000:06:00.0]-082c: : req=ffff88084e720000 req->length=2048 req->ring=ffff88084b140000 rsp=ffff88084d9b5ac0 rsp->length=512 rsp->ring=ffff88084f300000.
[  511.021582] qla2xxx [0000:06:00.0]-0841:11: Allocated the host=ffff88084b3f4000 hw=ffff88084c6ae000 vha=ffff88084b3f4670 dev_name=0000:06:00.0
[  511.021594] qla2xxx [0000:06:00.0]-0832:11: can_queue=2176, req=ffff88084e720000, mgmt_svr_loop_id=10, sg_tablesize=1024.
[  511.021608] qla2xxx [0000:06:00.0]-0833:11: max_id=512 this_id=255 cmd_per_len=3 unique_id=11 max_cmd_len=16 max_channel=0 max_lun=65535 transportt=ffff88084d7ad000, vendor_id=4215.
[  511.021721] qla2xxx 0000:06:00.0: irq 83 for MSI/MSI-X
[  511.021749] qla2xxx 0000:06:00.0: irq 84 for MSI/MSI-X
[  511.021814] qla2xxx [0000:06:00.0]-c805:11: mqiobase=          (null), max_rsp_queues=1, max_req_queues=1.
[  511.021823] qla2xxx [0000:06:00.0]-0855:11: mqiobase=          (null), max_rsp_queues=1, max_req_queues=1.
[  511.021831] qla2xxx [0000:06:00.0]-0836:11: MSI-X: Enabled (0x0, 0x0).
[  511.021886] qla2xxx [0000:06:00.0]-c809:11: rsp_q_map=ffff88084d0176a0 req_q_map=ffff88084d017720 rsp->req=ffff88084e720000 req->rsp=ffff88084d9b5ac0.
[  511.021899] qla2xxx [0000:06:00.0]-c80a:11: req->req_q_in=ffffc900060c201c req->req_q_out=ffffc900060c2020 rsp->rsp_q_in=ffffc900060c2024 rsp->rsp_q_out=ffffc900060c2028.
[  511.021911] qla2xxx [0000:06:00.0]-083e:11: rsp_q_map=ffff88084d0176a0 req_q_map=ffff88084d017720 rsp->req=ffff88084e720000 req->rsp=ffff88084d9b5ac0.
[  511.021924] qla2xxx [0000:06:00.0]-083f:11: req->req_q_in=ffffc900060c201c req->req_q_out=ffffc900060c2020 rsp->rsp_q_in=ffffc900060c2024 rsp->rsp_q_out=ffffc900060c2028.
[  511.021934] qla2xxx [0000:06:00.0]-0040:11: Configuring PCI space...
[  511.021944] qla2xxx 0000:06:00.0: setting latency timer to 64
[  511.026501] qla2xxx [0000:06:00.0]-0846:11: FLTL[PCI] = 0x50400.
[  511.026512] qla2xxx [0000:06:00.0]-1809:11: Entered qla2x00_dump_ram.
[  511.026519] qla2xxx [0000:06:00.0]-1800:11: Entered qla2x00_mailbox_command.
[  511.026527] qla2xxx [0000:06:00.0]-1806:11: Prepare to issue mbox cmd=0xc.
[  511.026536] qla2xxx [0000:06:00.0]-1911:11: Loaded MBX registers (displayed in bytes) =.
[  511.026544] qla2xxx [0000:06:00.0]-1912:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.026552] qla2xxx [0000:06:00.0]-1912:11: --------------------------------------------------------------
[  511.026559] qla2xxx [0000:06:00.0]-1912:11: 0c  00  00  04  03  4d  00  c0  00  00  00  04  00  00  08  00
[  511.026588] qla2xxx [0000:06:00.0]-1913:11: .
[  511.026594] qla2xxx [0000:06:00.0]-1914:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.026602] qla2xxx [0000:06:00.0]-1914:11: --------------------------------------------------------------
[  511.026609] qla2xxx [0000:06:00.0]-1914:11: f5  7f  00  81  ff  ff  ff  ff  38  59  2f  4d  08  88  ff  ff
[  511.026636] qla2xxx [0000:06:00.0]-1915:11: .
[  511.026643] qla2xxx [0000:06:00.0]-1916:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.026651] qla2xxx [0000:06:00.0]-1916:11: --------------------------------------------------------------
[  511.026658] qla2xxx [0000:06:00.0]-1916:11: d0  00  00  00  00  00  00  00
[  511.026674] qla2xxx [0000:06:00.0]-1916:11:
[  511.026681] qla2xxx [0000:06:00.0]-1917:11: I/O Address = ffffc900060c20c0.
[  511.026687] qla2xxx [0000:06:00.0]-180e:11: Mailbox registers:
[  511.026695] qla2xxx [0000:06:00.0]-180e:11: mbox[0] 0x0000
[  511.026702] qla2xxx [0000:06:00.0]-180e:11: mbox[1] 0x4953
[  511.026710] qla2xxx [0000:06:00.0]-180e:11: mbox[2] 0x5020
[  511.026717] qla2xxx [0000:06:00.0]-180e:11: mbox[3] 0x2532
[  511.026724] qla2xxx [0000:06:00.0]-180e:11: mbox[4] 0x0002
[  511.026731] qla2xxx [0000:06:00.0]-180e:11: mbox[5] 0x000e
[  511.026738] qla2xxx [0000:06:00.0]-180f:11: Going to unlock irq & waiting for interrupts. jiffies=10000ce02.
[  511.029810] qla2xxx [0000:06:00.0]-584d:11: Got mailbox completion. cmd=c.
[  511.029818] qla2xxx [0000:06:00.0]-1814:11: Cmd=c completed.
[  511.029821] qla2xxx [0000:06:00.0]-1821:11: Done qla2x00_mailbox_command.
[  511.029824] qla2xxx [0000:06:00.0]-1807:11: Done qla2x00_dump_ram.
[  511.029830] qla2xxx [0000:06:00.0]-0849:11: FLT[07]: start=0x0 end=0xffff size=0x40000.
[  511.029834] qla2xxx [0000:06:00.0]-0849:11: FLT[11]: start=0x10000 end=0x1ffff size=0x40000.
[  511.029839] qla2xxx [0000:06:00.0]-0849:11: FLT[01]: start=0x20000 end=0x2ffff size=0x40000.
[  511.029842] qla2xxx [0000:06:00.0]-0849:11: FLT[12]: start=0x30000 end=0x3ffff size=0x40000.
[  511.029846] qla2xxx [0000:06:00.0]-0849:11: FLT[13]: start=0x40000 end=0x47fff size=0x20000.
[  511.029850] qla2xxx [0000:06:00.0]-0849:11: FLT[14]: start=0x48000 end=0x4807f size=0x200.
[  511.029853] qla2xxx [0000:06:00.0]-0849:11: FLT[15]: start=0x48080 end=0x480ff size=0x200.
[  511.029857] qla2xxx [0000:06:00.0]-0849:11: FLT[16]: start=0x48100 end=0x4817f size=0x200.
[  511.029861] qla2xxx [0000:06:00.0]-0849:11: FLT[17]: start=0x48180 end=0x481ff size=0x200.
[  511.029865] qla2xxx [0000:06:00.0]-0849:11: FLT[18]: start=0x48200 end=0x4bfff size=0xf800.
[  511.029869] qla2xxx [0000:06:00.0]-0849:11: FLT[19]: start=0x4c000 end=0x4ffff size=0x10000.
[  511.029873] qla2xxx [0000:06:00.0]-0849:11: FLT[1a]: start=0x50000 end=0x5001f size=0x80.
[  511.029876] qla2xxx [0000:06:00.0]-0849:11: FLT[1b]: start=0x50020 end=0x503ff size=0xf80.
[  511.029881] qla2xxx [0000:06:00.0]-0849:11: FLT[1c]: start=0x50400 end=0x507ff size=0x1000.
[  511.029885] qla2xxx [0000:06:00.0]-0849:11: FLT[26]: start=0x50800 end=0x50bff size=0x1000.
[  511.029889] qla2xxx [0000:06:00.0]-0849:11: FLT[08]: start=0x50c00 end=0x51fff size=0x5000.
[  511.029892] qla2xxx [0000:06:00.0]-0849:11: FLT[2b]: start=0x52000 end=0x53fff size=0x8000.
[  511.029896] qla2xxx [0000:06:00.0]-0849:11: FLT[1d]: start=0x54000 end=0x541ff size=0x800.
[  511.029900] qla2xxx [0000:06:00.0]-0849:11: FLT[1e]: start=0x54200 end=0x543ff size=0x800.
[  511.029904] qla2xxx [0000:06:00.0]-0849:11: FLT[1f]: start=0x54400 end=0x545ff size=0x800.
[  511.029907] qla2xxx [0000:06:00.0]-0849:11: FLT[20]: start=0x54600 end=0x547ff size=0x800.
[  511.029911] qla2xxx [0000:06:00.0]-0849:11: FLT[27]: start=0x54800 end=0x57fff size=0xe000.
[  511.029915] qla2xxx [0000:06:00.0]-0849:11: FLT[21]: start=0x58000 end=0x59fff size=0x8000.
[  511.029919] qla2xxx [0000:06:00.0]-0849:11: FLT[22]: start=0x5a000 end=0x5bfff size=0x8000.
[  511.029924] qla2xxx [0000:06:00.0]-0849:11: FLT[29]: start=0x5c000 end=0x5cfff size=0x4000.
[  511.029928] qla2xxx [0000:06:00.0]-0849:11: FLT[2a]: start=0x5d000 end=0x5dfff size=0x4000.
[  511.029931] qla2xxx [0000:06:00.0]-0849:11: FLT[28]: start=0x5e000 end=0x5ffff size=0x8000.
[  511.029935] qla2xxx [0000:06:00.0]-0849:11: FLT[23]: start=0x60000 end=0x6ffff size=0x40000.
[  511.029939] qla2xxx [0000:06:00.0]-0849:11: FLT[24]: start=0x70000 end=0x7ffff size=0x40000.
[  511.029943] qla2xxx [0000:06:00.0]-0849:11: FLT[30]: start=0x48000 end=0x4bfff size=0x10000.
[  511.029946] qla2xxx [0000:06:00.0]-0849:11: FLT[31]: start=0x54000 end=0x57fff size=0x10000.
[  511.029950] qla2xxx [0000:06:00.0]-0849:11: FLT[ff]: start=0x0 end=0x7ffff size=0x200000.
[  511.029955] qla2xxx [0000:06:00.0]-084a:11: FLT[FLT]: boot=0x0 fw=0x20000 vpd_nvram=0x48000 vpd=0x48000.
[  511.029960] qla2xxx [0000:06:00.0]-084b:11: nvram=0x48080 fdt=0x50000 flt=0x50400 npiv=0x5c000 fcp_prif_cfg=0x3c000.
[  511.029965] qla2xxx [0000:06:00.0]-1809:11: Entered qla2x00_dump_ram.
[  511.029969] qla2xxx [0000:06:00.0]-1800:11: Entered qla2x00_mailbox_command.
[  511.029973] qla2xxx [0000:06:00.0]-1806:11: Prepare to issue mbox cmd=0xc.
[  511.029978] qla2xxx [0000:06:00.0]-1911:11: Loaded MBX registers (displayed in bytes) =.
[  511.029982] qla2xxx [0000:06:00.0]-1912:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.029985] qla2xxx [0000:06:00.0]-1912:11: --------------------------------------------------------------
[  511.029988] qla2xxx [0000:06:00.0]-1912:11: 0c  00  00  00  03  4d  00  c0  00  00  00  04  00  00  08  00
[  511.030000] qla2xxx [0000:06:00.0]-1913:11: .
[  511.030003] qla2xxx [0000:06:00.0]-1914:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.030006] qla2xxx [0000:06:00.0]-1914:11: --------------------------------------------------------------
[  511.030010] qla2xxx [0000:06:00.0]-1914:11: f5  7f  00  81  ff  ff  ff  ff  f8  59  2f  4d  08  88  ff  ff
[  511.030023] qla2xxx [0000:06:00.0]-1915:11: .
[  511.030026] qla2xxx [0000:06:00.0]-1916:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.030030] qla2xxx [0000:06:00.0]-1916:11: --------------------------------------------------------------
[  511.030033] qla2xxx [0000:06:00.0]-1916:11: d0  00  00  00  00  00  00  00
[  511.030041] qla2xxx [0000:06:00.0]-1916:11:
[  511.030044] qla2xxx [0000:06:00.0]-1917:11: I/O Address = ffffc900060c20c0.
[  511.030047] qla2xxx [0000:06:00.0]-180e:11: Mailbox registers:
[  511.030051] qla2xxx [0000:06:00.0]-180e:11: mbox[0] 0x4000
[  511.030055] qla2xxx [0000:06:00.0]-180e:11: mbox[1] 0x4953
[  511.030059] qla2xxx [0000:06:00.0]-180e:11: mbox[2] 0x5020
[  511.030063] qla2xxx [0000:06:00.0]-180e:11: mbox[3] 0x2532
[  511.030066] qla2xxx [0000:06:00.0]-180e:11: mbox[4] 0x0002
[  511.030070] qla2xxx [0000:06:00.0]-180e:11: mbox[5] 0x000e
[  511.030073] qla2xxx [0000:06:00.0]-180f:11: Going to unlock irq & waiting for interrupts. jiffies=10000ce03.
[  511.033040] qla2xxx [0000:06:00.0]-584d:11: Got mailbox completion. cmd=c.
[  511.033047] qla2xxx [0000:06:00.0]-1814:11: Cmd=c completed.
[  511.033050] qla2xxx [0000:06:00.0]-1821:11: Done qla2x00_mailbox_command.
[  511.033052] qla2xxx [0000:06:00.0]-1807:11: Done qla2x00_dump_ram.
[  511.033057] qla2xxx [0000:06:00.0]-084d:11: FDT[a046bdcd]: (0xef/0x3015) erase=0x7ffd03d8 pr=0 upro=bc wrtd=0x10000 blk=0x0.
[  511.033922] qla2xxx [0000:06:00.0]-085b:11: Read BIOS 2.16.
[  511.034779] qla2xxx [0000:06:00.0]-085c:11: Read FCODE 2.0.
[  511.035860] qla2xxx [0000:06:00.0]-085b:11: Read BIOS 2.16.
[  511.036629] qla2xxx [0000:06:00.0]-085d:11: Read EFI 2.0.
[  511.036680] qla2xxx [0000:06:00.0]-0860:11: Firmware revision 4.4.0.128.
[  511.036683] qla2xxx [0000:06:00.0]-0061:11: Configure NVRAM parameters...
[  511.044365] qla2xxx [0000:06:00.0]-086a:11: Contents of NVRAM
[  511.044367] qla2xxx [0000:06:00.0]-090d:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.044370] qla2xxx [0000:06:00.0]-090d:11: --------------------------------------------------------------
[  511.044372] qla2xxx [0000:06:00.0]-090d:11: 49  53  50  20  01  00  00  00  01  00  00  00  00  08  ff  ff
[  511.044380] 00  00  00  00  21  00  00  24  ff  3e  9c  0e  00  00  00  00
[  511.044388] 00  00  00  00  08  00  00  00  00  00  00  00  06  20  00  00
[  511.044395] 20  10  00  00  08  40  00  00  00  00  00  00  00  00  00  00
[  511.044402] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044409] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044416] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044423] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044430] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044436] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044444] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044450] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044457] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044464] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044471] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044478] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044485] 02  0c  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044492] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044499] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044506] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044513] 00  00  00  00  00  00  00  00  05  00  00  00  00  00  00  00
[  511.044520] 00  01  00  00  2d  00  2d  00  00  00  00  00  00  00  00  00
[  511.044527] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044534] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044541] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044547] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044554] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044561] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044572] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044576] 00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044585] 51  4c  45  32  35  36  32  20  20  20  20  20  20  20  20  20
[  511.044598] 09  00  00  00  00  00  00  00  77  10  5d  01  e5  14  d2  18
[  511.044615] qla2xxx [0000:06:00.0]-0078:11: Verifying loaded RISC code...
[  511.044617] qla2xxx [0000:06:00.0]-087a:11: **** Load RISC code ****.
[  511.044620] qla2xxx [0000:06:00.0]-1832:11: Entered qla2x00_mbx_reg_test.
[  511.044622] qla2xxx [0000:06:00.0]-1800:11: Entered qla2x00_mailbox_command.
[  511.044624] qla2xxx [0000:06:00.0]-1806:11: Prepare to issue mbox cmd=0x6.
[  511.044628] qla2xxx [0000:06:00.0]-1911:11: Loaded MBX registers (displayed in bytes) =.
[  511.044630] qla2xxx [0000:06:00.0]-1912:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.044632] qla2xxx [0000:06:00.0]-1912:11: --------------------------------------------------------------
[  511.044634] qla2xxx [0000:06:00.0]-1912:11: 06  00  aa  aa  55  55  55  aa  aa  55  a5  a5  5a  5a  25  25
[  511.044649] qla2xxx [0000:06:00.0]-1913:11: .
[  511.044651] qla2xxx [0000:06:00.0]-1914:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.044653] qla2xxx [0000:06:00.0]-1914:11: --------------------------------------------------------------
[  511.044655] qla2xxx [0000:06:00.0]-1914:11: 00  00  00  00  00  00  00  00  20  00  00  00  08  88  ff  ff
[  511.044661] qla2xxx [0000:06:00.0]-1915:11: .
[  511.044663] qla2xxx [0000:06:00.0]-1916:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.044665] qla2xxx [0000:06:00.0]-1916:11: --------------------------------------------------------------
[  511.044667] qla2xxx [0000:06:00.0]-1916:11: c8  5a  2f  4d  08  88  ff  ff
[  511.044671] qla2xxx [0000:06:00.0]-1916:11:
[  511.044673] qla2xxx [0000:06:00.0]-1917:11: I/O Address = ffffc900060c20c0.
[  511.044675] qla2xxx [0000:06:00.0]-180e:11: Mailbox registers:
[  511.044677] qla2xxx [0000:06:00.0]-180e:11: mbox[0] 0x4000
[  511.044680] qla2xxx [0000:06:00.0]-180e:11: mbox[1] 0x4953
[  511.044682] qla2xxx [0000:06:00.0]-180e:11: mbox[2] 0x5020
[  511.044685] qla2xxx [0000:06:00.0]-180e:11: mbox[3] 0x2532
[  511.044687] qla2xxx [0000:06:00.0]-180e:11: mbox[4] 0x0002
[  511.044690] qla2xxx [0000:06:00.0]-180e:11: mbox[5] 0x000e
[  511.044692] qla2xxx [0000:06:00.0]-180f:11: Going to unlock irq & waiting for interrupts. jiffies=10000ce07.
[  511.044724] qla2xxx [0000:06:00.0]-584d:11: Got mailbox completion. cmd=6.
[  511.044732] qla2xxx [0000:06:00.0]-1814:11: Cmd=6 completed.
[  511.044735] qla2xxx [0000:06:00.0]-1821:11: Done qla2x00_mailbox_command.
[  511.044738] qla2xxx [0000:06:00.0]-1834:11: Done qla2x00_mbx_reg_test.
[  511.044743] qla2xxx [0000:06:00.0]-0092:11: Loading via request-firmware.
[  511.044746] qla2xxx [0000:06:00.0]-0897:11: Loading risc segment@ risc addr 100000 number of dwords 0x8000.
[  511.044808] qla2xxx [0000:06:00.0]-1822:11: Entered qla2x00_load_ram.
[  511.044811] qla2xxx [0000:06:00.0]-1800:11: Entered qla2x00_mailbox_command.
[  511.044813] qla2xxx [0000:06:00.0]-1806:11: Prepare to issue mbox cmd=0xb.
[  511.044817] qla2xxx [0000:06:00.0]-1911:11: Loaded MBX registers (displayed in bytes) =.
[  511.044819] qla2xxx [0000:06:00.0]-1912:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.044821] qla2xxx [0000:06:00.0]-1912:11: --------------------------------------------------------------
[  511.044823] qla2xxx [0000:06:00.0]-1912:11: 0b  00  00  00  14  4b  00  00  00  00  00  80  00  00  08  00
[  511.044832] qla2xxx [0000:06:00.0]-1913:11: .
[  511.044834] qla2xxx [0000:06:00.0]-1914:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.044837] qla2xxx [0000:06:00.0]-1914:11: --------------------------------------------------------------
[  511.044839] qla2xxx [0000:06:00.0]-1914:11: 10  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
[  511.044847] qla2xxx [0000:06:00.0]-1915:11: .
[  511.044849] qla2xxx [0000:06:00.0]-1916:11:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
[  511.044851] qla2xxx [0000:06:00.0]-1916:11: --------------------------------------------------------------
[  511.044853] qla2xxx [0000:06:00.0]-1916:11: 05  00  00  00  00  00  00  00
[  511.044859] qla2xxx [0000:06:00.0]-1916:11:
[  511.044861] qla2xxx [0000:06:00.0]-1917:11: I/O Address = ffffc900060c20c0.
[  511.044863] qla2xxx [0000:06:00.0]-180e:11: Mailbox registers:
[  511.044866] qla2xxx [0000:06:00.0]-180e:11: mbox[0] 0x4000
[  511.044868] qla2xxx [0000:06:00.0]-180e:11: mbox[1] 0xaaaa
[  511.044871] qla2xxx [0000:06:00.0]-180e:11: mbox[2] 0x5555
[  511.044874] qla2xxx [0000:06:00.0]-180e:11: mbox[3] 0xaa55
[  511.044876] qla2xxx [0000:06:00.0]-180e:11: mbox[4] 0x55aa
[  511.044879] qla2xxx [0000:06:00.0]-180e:11: mbox[5] 0xa5a5
[  511.044881] qla2xxx [0000:06:00.0]-180f:11: Going to unlock irq & waiting for interrupts. jiffies=10000ce07.

-- 
Thanks!
Yijing
