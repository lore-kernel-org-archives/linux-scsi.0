From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Sun, 30 Aug 2009 13:21:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908301304550.10608-100000@netrider.rowland.org>
References: <200908301012.51126.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:40157 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753452AbZH3RV5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2009 13:21:57 -0400
In-Reply-To: <200908301012.51126.a.miskiewicz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Sun, 30 Aug 2009, Arkadiusz Miskiewicz wrote:

> with sleep
> 
> Aug 30 11:11:52 rhea kernel: [    6.950127] console [netcon0] enabled                                                                                        
> Aug 30 11:11:52 rhea kernel: [   13.116253] netconsole: network logging started                                                                              
> Aug 30 11:11:52 rhea kernel: [   13.145344] SCSI subsystem initialized                                                                                       
> Aug 30 11:11:52 rhea kernel: [   13.160103] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)                                              
> Aug 30 11:11:52 rhea kernel: [   13.187529] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)                                                  
> Aug 30 11:11:52 rhea kernel: [   13.209685] megaraid: probe new device 0x1000:0x0407:0x1000:0x0530: bus 2:slot 3:func 0                                      
> Aug 30 11:11:52 rhea kernel: [   13.241872]   alloc irq_desc for 27 on cpu 0 node 0                                                                          
> Aug 30 11:11:52 rhea kernel: [   13.241876]   alloc kstat_irqs on cpu 0 node 0                                                                               
> Aug 30 11:11:52 rhea kernel: [   13.241885] megaraid 0000:02:03.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27                                                
> Aug 30 11:11:52 rhea kernel: [   13.286708] megaraid: fw version:[414G] bios version:[A100]                                                                  
> Aug 30 11:11:52 rhea kernel: [   13.305284] scsi0 : LSI Logic MegaRAID driver                                                                                
> Aug 30 11:11:52 rhea kernel: [   13.322942] scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices                                                    
> Aug 30 11:11:52 rhea kernel: [   13.355882] Driver 'sd' needs updating - please use bus_type methods                                                         
> Aug 30 11:11:52 rhea kernel: [   13.379162] wait_scan_init: BEFORE wait_for_device_probe                                                                     
> Aug 30 11:11:52 rhea kernel: [   13.397928] wait_scan_init: AFTER wait_for_device_probe                                                                      
> Aug 30 11:11:52 rhea kernel: [   13.417739] wait_scan_init: BEFORE scsi_complete_async_scans                                                                 
> Aug 30 11:11:52 rhea kernel: [   13.438822] wait_scan_init: AFTER scsi_complete_async_scans                                                                  
> Aug 30 11:11:52 rhea kernel: [   13.459688] wait_scan_init: BEFORE async_synchronize_full                                                                    
> Aug 30 11:11:52 rhea kernel: [   13.479998] wait_scan_init: AFTER wait_for_device_probe                                                                      

Note here that the wait finished before most of the probing was done.

> Aug 30 11:11:52 rhea kernel: [   13.902193] scsi 0:0:6:0: Processor         ESG-SHV  SCA HSBP M29     1.08 PQ: 0 ANSI: 2                                     
> Aug 30 11:11:52 rhea kernel: [   15.930664] scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices                                                    
> Aug 30 11:11:52 rhea kernel: [   19.706530] scsi[0]: scanning scsi channel 2 [virtual] for logical drives                                                    
> Aug 30 11:11:52 rhea kernel: [   19.727104] scsi 0:2:0:0: Direct-Access     MegaRAID LD 0 RAID5  280G 414G PQ: 0 ANSI: 2                                     
> Aug 30 11:11:52 rhea kernel: [   19.757564] sd_probe: BEFORE async_schedule                                                                                  
> Aug 30 11:11:52 rhea kernel: [   19.770091] sd_probe: AFTER async_schedule                                                                                   
> Aug 30 11:11:52 rhea kernel: [   19.782507] sd_probe_async: ENTERED                                                                                          
> Aug 30 11:11:52 rhea kernel: [   19.793223] sd 0:2:0:0: [sda] 574218240 512-byte hardware sectors: (293 GB/273 GiB)                                          
> Aug 30 11:11:52 rhea kernel: [   19.816173] sd 0:2:0:0: [sda] Write Protect is off                                                                           
> Aug 30 11:11:52 rhea kernel: [   19.830525] sd 0:2:0:0: [sda] Mode Sense: 00 00 00 00                                                                        
> Aug 30 11:11:52 rhea kernel: [   19.830549] sd 0:2:0:0: [sda] Asking for cache data failed                                                                   
> Aug 30 11:11:52 rhea kernel: [   19.846978] sd 0:2:0:0: [sda] Assuming drive cache: write through                                                            
> Aug 30 11:11:52 rhea kernel: [   19.865496] sd 0:2:0:0: [sda] Asking for cache data failed                                                                   
> Aug 30 11:11:52 rhea kernel: [   19.881920] sd 0:2:0:0: [sda] Assuming drive cache: write through                                                            
> Aug 30 11:11:52 rhea kernel: [   19.900198]  sda: sda1 sda2 sda3                                                                                             
> Aug 30 11:11:52 rhea kernel: [   19.924019] sd 0:2:0:0: [sda] Attached SCSI disk                                                                             
> Aug 30 11:11:52 rhea kernel: [   23.113336] eth0: no IPv6 routers present                                                                                    
> Aug 30 11:11:52 rhea kernel: [   23.754010] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled                              
> Aug 30 11:11:52 rhea kernel: [   23.786463] SGI XFS Quota Management subsystem                                                                               
> Aug 30 11:11:52 rhea kernel: [   23.915852] XFS mounting filesystem sda2                                                                                     
> Aug 30 11:11:52 rhea kernel: [   24.050956] Ending clean XFS mount for filesystem: sda2                                                                      
> Aug 30 11:11:52 rhea kernel: [   24.051050] VFS: Mounted root (xfs filesystem) readonly on device 8:2.  

Okay, this problem is not the one that patch you found was intended to
solve.  It may be caused by excessively long delays in the megaraid
driver, or maybe megaraid uses extra kernel threads for its probing; I
can't tell.

Even more debugging info would help.  Keep the new printk statements
and try adding similar printks to the beginning and end of
scsi_prep_async_scan() and scsi_finish_async_scan() in scsi_scan.c.  
That should tell us the relative timing of the async routines and the
wait routines.

In the end, I suspect you'll need to ask the author or maintainer of
the megaraid driver for help solving this.

Alan Stern

