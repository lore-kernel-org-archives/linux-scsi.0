From: Meelis Roos <mroos@linux.ee>
Subject: Re: Sym2 scsi hang on boot on sparc64
Date: Tue, 19 Aug 2014 16:13:52 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1408191613100.7767@math.ut.ee>
References: <alpine.SOC.1.00.1408191420150.4929@math.ut.ee> <1408451668.2645.2.camel@jarvis>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:38571 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaHSNPE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2014 09:15:04 -0400
In-Reply-To: <1408451668.2645.2.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

> > 3.16 scsi worked fine, 3.17-rc1 misbehaves on 3 of my sparc64 test 
> > machines. E220R and E420R are with onboard 5c3875, V210 is with onboarc 
> > 53c1010 and all behave the same. Any ideas whre to dig deeper? bisection 
> > might be nontrivial, because of sparc64 changes that are OK on 3.17-rc1 
> > again - but is possible if nothing else helps.
> 
> We've got a parisc with an 875 as a root SCSI bus ... I haven't got
> around to building for it yet, but I might find time to try today.

Come to think of it, I have couple parsisc with 875 too, will try.

> > [  164.639697] PCI: Enabling device: (0000:00:03.0), cmd 147                                         
> > [  164.705076] sym0: <875> rev 0x14 at pci 0000:00:03.0 irq 13                                       
> > [  164.858446] sym0: No NVRAM, ID 7, Fast-20, SE, parity checking                                    
> > [  164.935031] sym0: SCSI BUS has been reset.                                                        
> > [  164.983113] scsi host0: sym-2.2.3                                                                 
> > [  165.026358] PCI: Enabling device: (0000:00:03.1), cmd 3                                           
> > [  165.089634] sym1: <875> rev 0x14 at pci 0000:00:03.1 irq 14                                       
> > [  165.242820] sym1: No NVRAM, ID 7, Fast-20, SE, parity checking                                    
> > [  165.319227] sym1: SCSI BUS has been reset.                                                        
> > [  165.367281] scsi host1: sym-2.2.3                                                                 
> 
> Does it detect drives in the bit you cut?  I ask because one of the
> symptoms of a misrouted irq is random problems with bring up.  However,
> if anything is detected, then the irq must be OK.

No, nothing scsi related - rtc detection etc.

> 
> James
> 
> > [  388.835999] INFO: task swapper/0:1 blocked for more than 120 seconds.                             
> > [  388.912181]       Not tainted 3.17.0-rc1 #46                                                      
> > [  388.963187] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.             
> > [  389.056953] swapper/0       D 0000000000483958  7584     1      0 0x200000001000000               
> > [  389.148575] Call Trace:                                                                           
> > [  389.177747]  [000000000082e5fc] schedule+0x1c/0x80                                                
> > [  389.235024]  [0000000000483958] async_synchronize_cookie_domain+0x58/0x100                        
> > [  389.317301]  [0000000000483a28] async_synchronize_full+0x8/0x20                                   
> > [  389.388133]  [00000000006ebe04] wait_for_device_probe+0x64/0x80                                   
> > [  389.458938]  [00000000009dcffc] prepare_namespace+0x4/0x1b8                                       
> > [  389.525590]  [00000000009dcbac] kernel_init_freeable+0x1c0/0x1d8                                  
> > [  389.597450]  [00000000008298e4] kernel_init+0x4/0x100                                             
> > [  389.657868]  [00000000004060c4] ret_from_fork+0x1c/0x2c                                           
> > [  389.720324]  [0000000000000000]           (null)                                                  
> > [  389.775518] no locks held by swapper/0/1.                                                         
> > 
> > 
> > 
> > -- 
> > Meelis Roos (mroos@linux.ee)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 

-- 
Meelis Roos (mroos@linux.ee)
