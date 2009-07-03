From: Joe Jin <joe.jin@oracle.com>
Subject: Re: kexec kernel failed to restart aacraid device
Date: Fri, 3 Jul 2009 09:33:58 +0800
Message-ID: <20090703013358.GA19596@joejin-pc.cn.oracle.com>
References: <20090701005404.GA29923@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:49484 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZGCBeF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 21:34:05 -0400
Content-Disposition: inline
In-Reply-To: <20090701005404.GA29923@joejin-pc.cn.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Jin <joe.jin@oracle.com>
Cc: aacraid@adaptec.com, mark_salyzyn@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi, 

Checked aacraid drivers, initialzing and reset device at _aac_rx_init(), 
at the begin of function, set @adapter_enable_int to aac_rx_disable_interrupt(),
when device status it KERNEL_PANIC, driver will try to reset device,
before reset device, it will check device health or no by call 
aac_rx_check_health(), then aac_rx_check_health()->rx_sync_cmd() will use the
aac_rx_disable_interrupt() to restore interrupt mask, is that the right
action? if need to replace it to aac_rx_enable_interrupt_producer() before call
aac_rx_check_health()?

Have attached the patch, please review it.

Thanks,
Joe

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index f70d9f8..07142a6 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -556,7 +556,12 @@ int _aac_rx_init(struct aac_dev *dev)
 	 */
 	status = rx_readl(dev, MUnit.OMRx[0]);
 	if (status & KERNEL_PANIC) {
-		if (aac_rx_restart_adapter(dev, aac_rx_check_health(dev)))
+		int health;
+
+		dev->a_ops.adapter_enable_int = aac_rx_enable_interrupt_producer;
+		health = aac_rx_check_health(dev);
+		dev->a_ops.adapter_enable_int = aac_rx_disable_interrupt;
+		if (aac_rx_restart_adapter(dev, health))
 			goto error_iounmap;
 		++restart;
 	}
@@ -594,7 +599,12 @@ int _aac_rx_init(struct aac_dev *dev)
 		  ((startup_timeout > 60)
 		    ? (startup_timeout - 60)
 		    : (startup_timeout / 2))))) {
-			if (likely(!aac_rx_restart_adapter(dev, aac_rx_check_health(dev))))
+			int health;
+
+			dev->a_ops.adapter_enable_int = aac_rx_enable_interrupt_producer;
+			health = aac_rx_check_health(dev);
+			dev->a_ops.adapter_enable_int = aac_rx_disable_interrupt;
+			if (likely(!aac_rx_restart_adapter(dev, health)))
 				start = jiffies;
 			++restart;
 		}




On 2009-07-01 08:54, Joe Jin wrote:
> Hi,
> 
> When try to kdump via sysrq-trigger, found kernel hung when 
> try to restart aacraid device, kernel print below messages:
> 
>   Loading aacraid.ko
>   AAC0:  adapter kernel faile to start, init status = 0.
> 
> Normally startup, got following message what related the devices:
> 
>   Adaptec aacraid driver 1.1-5[2461]
>   AAC0: kernel 4.2-0[8208] Jul  6 2006
>   AAC0: monitor 4.2-0[8208]
>   AAC0: bios 4.2-0[8208]
>   AAC0: serial C36FA5
>   AAC0: Non-DASD support enabled.
> 
> 
> Device info from lspci:
>      
> 02:03.0 0104: 9005:0285 (rev 01)                                                            
>         Subsystem: 9005:0286
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- 
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- 
>         Latency: 64 (250ns min, 250ns max), Cache Line Size: 64 bytes                       
>         Interrupt: pin A routed to IRQ 177                                                  
>         Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
>         Expansion ROM at fc9f0000 [disabled] [size=32K]                                     
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)  
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 
> Readed driver's codes found if ignore restart device at _aac_rx_init():
> 
> Changed
> 	if ((((status & 0x0c) != 0x0c) || aac_reset_devices || reset_devices) && 
> 		!aac_rx_restart_adapter(dev, 0))
> 
> to 
> 	if ((aac_reset_devices || reset_devices) && 
> 		!aac_rx_restart_adapter(dev, 0))
> 
> and get rid of reset_devices from kdump command line, kexec kernel could
> bootup kernel normally, kdump would dump vmcore, looked like it caused by 
> aac_rx_restart_adapter() could not restart devices, it made kdump kernel 
> could not go on.
> 
> Any idea will appreciate~
> 
> Thanks,
> Joe


