From: Michael Stone <mstone@mathom.us>
Subject: Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Thu, 23 Mar 2006 13:09:11 -0500
Message-ID: <20060323180909.GD15140@mathom.us>
References: <20051114224512.GF9905@mathom.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vms046pub.verizon.net ([206.46.252.46]:20450 "EHLO
	vms046pub.verizon.net") by vger.kernel.org with ESMTP
	id S1751446AbWCWSJn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Mar 2006 13:09:43 -0500
Received: from osgiliath.mathom.us ([151.200.254.241])
 by vms046.mailsrvcs.net (Sun Java System Messaging Server 6.2-4.02 (built Sep
 9 2005)) with ESMTPA id <0IWL00KPAEFERWA1@vms046.mailsrvcs.net> for
 linux-scsi@vger.kernel.org; Thu, 23 Mar 2006 12:09:15 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
	by osgiliath.mathom.us (Postfix) with ESMTP id DBB7D6E66B	for
 <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2006 13:09:12 -0500 (EST)
Received: from osgiliath.mathom.us ([127.0.0.1])
	by localhost (osgiliath.home.mathom.us [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 23833-01-14 for <linux-scsi@vger.kernel.org>; Thu,
 23 Mar 2006 13:09:12 -0500 (EST)
In-reply-to: <20051114224512.GF9905@mathom.us>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The negotiation for this configuration is still broken in 2.6.16.

On Mon, Nov 14, 2005 at 05:45:12PM -0500, you wrote:
>At some point between 2.6.11 and 2.6.14 something seems to have killed
>the scsi performance for one of our disk arrays. Prior to the upgrade it
>could transfer a full 120MB/s to cache and sustain upwards of 100MB/s
>from disk. On 2.6.14 I saw more like 2.5MB/s to/from the array. From the
>array side the key difference was that the speed was reported as "async"
>rather than "160". The bootup messages from the kernel are different
>also:
>
>2.6.11:
>
>Nov 14 21:40:07 ormal kernel: ACPI: PCI interrupt 0000:03:06.0[A] -> GSI 24 
>(level, low) -> IRQ 24          Nov 14 21:40:07 ormal kernel: ACPI: PCI 
>interrupt 0000:03:06.1[B] -> GSI 25 (level, low) -> IRQ 25          Nov 14 
>21:40:07 ormal kernel: scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 
>1.3.11                     Nov 14 21:40:07 ormal kernel:         <Adaptec 
>39320A Ultra320 SCSI adapter>                                Nov 14 
>21:40:07 ormal kernel:         aic7902: Ultra320 Wide Channel A, SCSI Id=7, 
>PCI-X 101-133Mhz, 512    SCBs                                               
>Nov 14 21:40:07 ormal kernel:                                               
>Nov 14 21:40:07 ormal kernel: scsi3 : Adaptec AIC79XX PCI-X SCSI HBA 
>DRIVER, Rev 1.3.11                     Nov 14 21:40:07 ormal kernel:        
><Adaptec 39320A Ultra320 SCSI adapter>                                Nov 
>14 21:40:07 ormal kernel:         aic7902: Ultra320 Wide Channel B, SCSI 
>Id=7, PCI-X 101-133Mhz, 512    SCBs                                         
>Nov 14 21:40:07 ormal kernel:                                               
>Nov 14 21:40:07 ormal kernel: (scsi3:A:0): 160.000MB/s transfers (80.000MHz 
>DT, 16bit)                      Nov 14 21:40:07 ormal kernel:   Vendor: IFT 
>Model: IFT-7250F Rev: 231T                        Nov 14 21:40:07 ormal 
>kernel:   Type:   Direct-Access ANSI SCSI revision: 04           Nov 14 
>21:40:07 ormal kernel: scsi3:A:0:0: Tagged Queuing enabled.  Depth 32       
>Nov 14 21:40:07 ormal kernel: SCSI device sdf: 2938208256 512-byte hdwr 
>sectors (1504363 MB)                Nov 14 21:40:07 ormal kernel: SCSI 
>device sdf: drive cache: write through                                   
>
>2.6.14:
>
>Nov 14 20:50:52 ormal kernel: ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 24 
>(level, low) -> IRQ 23          Nov 14 20:50:52 ormal kernel: scsi2 : 
>Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11                     Nov 
>14 20:50:52 ormal kernel:         <Adaptec 39320A Ultra320 SCSI adapter>    
>Nov 14 20:50:52 ormal kernel:         aic7902: Ultra320 Wide Channel A, 
>SCSI Id=7, PCI-X 101-133Mhz, 512    SCBs                                    
>Nov 14 20:50:52 ormal kernel:                                               
>Nov 14 20:50:52 ormal kernel:   Vendor: IFT       Model: IFT-7250F Rev: 
>231T                        Nov 14 20:50:52 ormal kernel:   Type:   
>Direct-Access ANSI SCSI revision: 04           Nov 14 20:50:52 ormal 
>kernel:  target2:0:0: asynchronous.                                         
>Nov 14 20:50:52 ormal kernel: scsi2:A:0:0: Tagged Queuing enabled.  Depth 
>32                                Nov 14 20:50:52 ormal kernel:  
>target2:0:0: Beginning Domain Validation                                    
>Nov 14 20:50:52 ormal kernel:  target2:0:0: wide asynchronous.              
>Nov 14 20:50:52 ormal kernel:  target2:0:0: Domain Validation skipping 
>write tests                          Nov 14 20:50:52 ormal kernel:  
>target2:0:0: Ending Domain Validation                                       
>Nov 14 20:50:52 ormal kernel: SCSI device sdf: 2938208256 512-byte hdwr 
>sectors (1504363 MB)                Nov 14 20:50:52 ormal kernel: SCSI 
>device sdf: drive cache: write through                                   
>Note that there's no "160.000MB/s transfers" message in 2.6.14, instead
>there's an "asynchronous".  (In the course of diagnosing this I switched
>from one port on the scsi controller to the other, but the results were
>the same.) Is this a known issue? Is there a workaround? 
>
>Mike Stone
