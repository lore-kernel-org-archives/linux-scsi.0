From: Helge Deller <deller@gmx.de>
Subject: Undefined behaviour in drivers/scsi/sym53c8xx_2/sym_hipd.c:762:24
Date: Sat, 5 Aug 2017 00:12:11 +0200
Message-ID: <d030f03a-0ccf-324b-32d6-002dfb408c16@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-parisc-owner@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-parisc <linux-parisc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On the parisc platform I noticed the UBSAN warning below.
Maybe nr_divisor isn't correctly initialized ?
Helge

[   18.555455] sym0: <896> rev 0x7 at pci 0000:00:0f.0 irq 68
[   18.625415] ================================================================================
[   18.726489] UBSAN: Undefined behaviour in ./drivers/scsi/sym53c8xx_2/sym_hipd.c:762:24
[   18.864911] index -1903078336 is out of range for type 'u32 [7]'
[   18.936779] CPU: 0 PID: 1 Comm: swapper Not tainted 4.13.0-rc3-32bit+ #427
[   19.019138] Backtrace:
[   19.047353]  [<10191eb4>] show_stack+0x3c/0x50
[   19.100577]  [<10ce82fc>] dump_stack+0x28/0x38
[   19.153826]  [<10771b3c>] ubsan_epilogue+0x1c/0x60
[   19.211229]  [<107722ec>] __ubsan_handle_out_of_bounds+0x68/0x80
[   19.283194]  [<10924074>] sym_hcb_attach+0xc2c/0x3204
[   19.343724]  [<107aaa38>] sba_dma_supported+0x4c/0x208
[   19.405291]  [<10911984>] sym2_probe+0xd64/0x122c
[   19.461661]  [<10501c64>] kernfs_add_one+0x328/0x354
[   19.521134] 
[   19.538916] ================================================================================
[   19.640086] sym0: PA-RISC Firmware, ID 7, Fast-40, SE, parity checking
[   19.725169] sym0: SCSI BUS has been reset.
[   19.774192] sym0: SCSI BUS mode change from SE to SE.
[   19.837034] sym0: SCSI BUS has been reset.
[   19.886092] scsi host0: sym-2.2.3
[   25.154088] sym1: <896> rev 0x7 at pci 0000:00:0f.1 irq 68
[   25.222639] sym1: PA-RISC Firmware, ID 7, Fast-40, LVD, parity checking
[   25.308775] sym1: SCSI BUS has been reset.
[   25.357840] scsi host1: sym-2.2.3
