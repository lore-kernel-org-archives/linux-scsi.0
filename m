From: Meelis Roos <mroos@linux.ee>
Subject: Sym2 scsi hang on boot on sparc64
Date: Tue, 19 Aug 2014 14:25:12 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1408191420150.4929@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

3.16 scsi worked fine, 3.17-rc1 misbehaves on 3 of my sparc64 test 
machines. E220R and E420R are with onboard 5c3875, V210 is with onboarc 
53c1010 and all behave the same. Any ideas whre to dig deeper? bisection 
might be nontrivial, because of sparc64 changes that are OK on 3.17-rc1 
again - but is possible if nothing else helps.

[  164.639697] PCI: Enabling device: (0000:00:03.0), cmd 147                                         
[  164.705076] sym0: <875> rev 0x14 at pci 0000:00:03.0 irq 13                                       
[  164.858446] sym0: No NVRAM, ID 7, Fast-20, SE, parity checking                                    
[  164.935031] sym0: SCSI BUS has been reset.                                                        
[  164.983113] scsi host0: sym-2.2.3                                                                 
[  165.026358] PCI: Enabling device: (0000:00:03.1), cmd 3                                           
[  165.089634] sym1: <875> rev 0x14 at pci 0000:00:03.1 irq 14                                       
[  165.242820] sym1: No NVRAM, ID 7, Fast-20, SE, parity checking                                    
[  165.319227] sym1: SCSI BUS has been reset.                                                        
[  165.367281] scsi host1: sym-2.2.3                                                                 
[...]
[  388.835999] INFO: task swapper/0:1 blocked for more than 120 seconds.                             
[  388.912181]       Not tainted 3.17.0-rc1 #46                                                      
[  388.963187] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.             
[  389.056953] swapper/0       D 0000000000483958  7584     1      0 0x200000001000000               
[  389.148575] Call Trace:                                                                           
[  389.177747]  [000000000082e5fc] schedule+0x1c/0x80                                                
[  389.235024]  [0000000000483958] async_synchronize_cookie_domain+0x58/0x100                        
[  389.317301]  [0000000000483a28] async_synchronize_full+0x8/0x20                                   
[  389.388133]  [00000000006ebe04] wait_for_device_probe+0x64/0x80                                   
[  389.458938]  [00000000009dcffc] prepare_namespace+0x4/0x1b8                                       
[  389.525590]  [00000000009dcbac] kernel_init_freeable+0x1c0/0x1d8                                  
[  389.597450]  [00000000008298e4] kernel_init+0x4/0x100                                             
[  389.657868]  [00000000004060c4] ret_from_fork+0x1c/0x2c                                           
[  389.720324]  [0000000000000000]           (null)                                                  
[  389.775518] no locks held by swapper/0/1.                                                         



-- 
Meelis Roos (mroos@linux.ee)
