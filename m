From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: -test4 detects scsi hdds in another order than -test2 does
Date: 29 Aug 2003 13:36:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062178592.1807.314.camel@mulgrave>
References: <m33cfm19ar.fsf@bzzz.home.net> <3F4E4605.6040706@wmich.edu>
	<m3vfshrola.fsf@bzzz.home.net> <3F4F7129.1050506@wmich.edu>
	<m3vfsgpj8b.fsf@bzzz.home.net> <20030829091135.559a121f.akpm@osdl.org>
	<m3d6eopfvt.fsf_-_@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:51974 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261269AbTH2Rgs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2003 13:36:48 -0400
In-Reply-To: <m3d6eopfvt.fsf_-_@bzzz.home.net>
List-Id: linux-scsi@vger.kernel.org
To: Alex Tomas <bzzz@tmi.comex.ru>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

I think this is due to the hotplug fixes for the Sym2 driver.  I've cc'd
Mathew Wilcox to confirm,  but basically, I think the test4 order will
be definitive from now on.

James



On Fri, 2003-08-29 at 12:50, Alex Tomas wrote:
> 
> $subj
> 
> 
> output for -test4:
> 
> sym.1.3.0: 53c1010-33 detected                                             
> sym0: <1010-33> rev 0x1 on pci bus 1 device 3 function 0 irq 23
> sym0: using 64 bit DMA addressing                              
> sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
> sym0: open drain IRQ line driver, using on-chip SRAM    
> sym0: using LOAD/STORE-based firmware.              
> sym0: handling phase mismatch from SCRIPTS.
> sym0: SCAN AT BOOT disabled for targets 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
> sym0: SCAN FOR LUNS disabled for targets 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
> sym0: SCSI BUS has been reset.                                             
> scsi0 : sym-2.1.16a           
> Using anticipatory scheduling elevator
> sym.1.3.1: 53c1010-33 detected        
> sym1: <1010-33> rev 0x1 on pci bus 1 device 3 function 1 irq 24
> sym1: using 64 bit DMA addressing                              
> sym1: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
> sym1: open drain IRQ line driver, using on-chip SRAM   
> sym1: using LOAD/STORE-based firmware.              
> sym1: handling phase mismatch from SCRIPTS.
> sym1: SCAN AT BOOT disabled for targets 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
> sym1: SCAN FOR LUNS disabled for targets 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
> sym1: SCSI BUS has been reset.                                             
> sym1: SCSI BUS mode change from SE to SE.
> scsi1 : sym-2.1.16a                      
> sym1: SCSI BUS has been reset.
> sym.1.6.0: 53c1010-33 detected
> sym2: <1010-33> rev 0x1 on pci bus 1 device 6 function 0 irq 29
> sym2: using 64 bit DMA addressing                              
> sym2: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
> sym2: open drain IRQ line driver, using on-chip SRAM    
> sym2: using LOAD/STORE-based firmware.              
> sym2: handling phase mismatch from SCRIPTS.
> sym2: SCSI BUS has been reset.             
> scsi2 : sym-2.1.16a           
>   Vendor: QUANTUM   Model: ATLAS_V__9_WLS    Rev: 0200
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> sym2:0:0: tagged command queuing enabled, command queue depth 16.  
> sym2:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)     
> sym.1.6.1: 53c1010-33 detected                              
> sym3: <1010-33> rev 0x1 on pci bus 1 device 6 function 1 irq 28
> sym3: using 64 bit DMA addressing                              
> sym3: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
> sym3: open drain IRQ line driver, using on-chip SRAM   
> sym3: using LOAD/STORE-based firmware.              
> sym3: handling phase mismatch from SCRIPTS.
> sym3: SCSI BUS has been reset.             
> scsi3 : sym-2.1.16a           
>   Vendor: IBM       Model: DNES-318350W      Rev: SA30
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> sym3:0:0: tagged command queuing enabled, command queue depth 16.  
> sym3:0:0:phase change 2-3 12@1fd19f60 resid=11.                  
> sym3:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 31)
> 3ware Storage Controller device driver for Linux v1.02.00.032.
> 3w-xxxx: No cards found.                                      
> SCSI device sda: 17930694 512-byte hdwr sectors (9181 MB)
> SCSI device sda: drive cache: write back                 
>  sda: unknown partition table           
> Attached scsi disk sda at scsi2, channel 0, id 0, lun 0
> SCSI device sdb: 35843670 512-byte hdwr sectors (18352 MB)
> SCSI device sdb: drive cache: write back                  
>  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 >      
> Attached scsi disk sdb at scsi3, channel 0, id 0, lun 0
> Attached scsi generic sg0 at scsi2, channel 0, id 0, lun 0,  type 0
> Attached scsi generic sg1 at scsi3, channel 0, id 0, lun 0,  type 0
> 
> 
> output for -test2:
> 
> sym0: <1010-33> rev 0x1 on pci bus 1 device 6 function 1 irq 28
> sym0: using 64 bit DMA addressing
> sym0: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
> sym0: open drain IRQ line driver, using on-chip SRAM
> sym0: using LOAD/STORE-based firmware.
> sym0: handling phase mismatch from SCRIPTS.
> sym0: SCSI BUS has been reset.
> sym1: <1010-33> rev 0x1 on pci bus 1 device 6 function 0 irq 29
> sym1: using 64 bit DMA addressing
> sym1: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
> sym1: open drain IRQ line driver, using on-chip SRAM
> sym1: using LOAD/STORE-based firmware.
> sym1: handling phase mismatch from SCRIPTS.
> sym1: SCSI BUS has been reset.
> sym2: <1010-33> rev 0x1 on pci bus 1 device 3 function 1 irq 24
> sym2: using 64 bit DMA addressing
> sym2: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
> sym2: open drain IRQ line driver, using on-chip SRAM
> sym2: using LOAD/STORE-based firmware.
> sym2: handling phase mismatch from SCRIPTS.
> sym2: SCAN AT BOOT disabled for targets 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
> sym2: SCAN FOR LUNS disabled for targets 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
> sym2: SCSI BUS has been reset.
> sym2: SCSI BUS mode change from SE to SE.
> sym2: SCSI BUS has been reset.
> sym3: <1010-33> rev 0x1 on pci bus 1 device 3 function 0 irq 23
> sym3: using 64 bit DMA addressing
> sym3: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
> sym3: open drain IRQ line driver, using on-chip SRAM
> sym3: using LOAD/STORE-based firmware.
> sym3: handling phase mismatch from SCRIPTS.
> sym3: SCAN AT BOOT disabled for targets 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
> sym3: SCAN FOR LUNS disabled for targets 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
> sym3: SCSI BUS has been reset.
> scsi0 : sym-2.1.16a
> Using deadline elevator
>   Vendor: IBM       Model: DNES-318350W      Rev: SA30
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> sym0:0:0: tagged command queuing enabled, command queue depth 16.
> sym0:0:0:phase change 2-3 12@1fd36f60 resid=11.
> sym0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 31)
> scsi1 : sym-2.1.16a
>   Vendor: QUANTUM   Model: ATLAS_V__9_WLS    Rev: 0200
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> sym1:0:0: tagged command queuing enabled, command queue depth 16.
> sym1:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
> scsi2 : sym-2.1.16a
> scsi3 : sym-2.1.16a
> 3ware Storage Controller device driver for Linux v1.02.00.032.
> 3w-xxxx: No cards found.
> SCSI device sda: 35843670 512-byte hdwr sectors (18352 MB)
> SCSI device sda: drive cache: write back
>  sda: sda1 sda2 sda3 < sda5 sda6 >
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> SCSI device sdb: 17930694 512-byte hdwr sectors (9181 MB)
> SCSI device sdb: drive cache: write back
>  sdb: unknown partition table
> Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
> Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
> Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
> 
> 
> 
> lspci -v output:
> 
> 01:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 Ultra3 SCSI Adapter (rev 01)
>         Subsystem: LSI Logic / Symbios Logic: Unknown device 1040
>         Flags: bus master, medium devsel, latency 64, IRQ 23
>         I/O ports at e400 [size=256]
>         Memory at febe8000 (64-bit, non-prefetchable) [size=1K]
>         Memory at febe0000 (64-bit, non-prefetchable) [size=8K]
>         Expansion ROM at feba0000 [disabled] [size=128K]
>         Capabilities: [40] Power Management version 2
> 
> 01:03.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 Ultra3 SCSI Adapter (rev 01)
>         Subsystem: LSI Logic / Symbios Logic: Unknown device 1040
>         Flags: bus master, medium devsel, latency 72, IRQ 24
>         I/O ports at e800 [size=256]
>         Memory at febf8000 (64-bit, non-prefetchable) [size=1K]
>         Memory at febf0000 (64-bit, non-prefetchable) [size=8K]
>         Expansion ROM at febc0000 [disabled] [size=128K]
>         Capabilities: [40] Power Management version 2
> 
> 01:06.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 Ultra3 SCSI Adapter (rev 01)
>         Subsystem: LSI Logic / Symbios Logic: Unknown device 1000
>         Flags: bus master, medium devsel, latency 72, IRQ 29
>         I/O ports at ee00 [size=256]
>         Memory at feb80000 (64-bit, non-prefetchable) [size=1K]
>         Memory at feb78000 (64-bit, non-prefetchable) [size=8K]
>         Expansion ROM at feb88000 [disabled] [size=16K]
>         Capabilities: [40] Power Management version 2
> 
> 01:06.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 Ultra3 SCSI Adapter (rev 01)
>         Subsystem: LSI Logic / Symbios Logic: Unknown device 1000
>         Flags: bus master, medium devsel, latency 72, IRQ 28
>         I/O ports at e000 [size=256]
>         Memory at feb98000 (64-bit, non-prefetchable) [size=1K]
>         Memory at feb90000 (64-bit, non-prefetchable) [size=8K]
>         Expansion ROM at feb8c000 [disabled] [size=16K]
>         Capabilities: [40] Power Management version 2
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


