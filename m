From: Jos van der Ende <seraph@xs4all.nl>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with
 udev
Date: Tue, 1 Apr 2008 16:47:40 +0200
Message-ID: <20080401164740.c4a5ec3f.seraph@xs4all.nl>
References: <bug-10374-10286@http.bugzilla.kernel.org/>
	<20080401011518.eb683cff.akpm@linux-foundation.org>
	<1207059115.3100.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pearlgates.net ([82.92.180.13]:36458 "EHLO mail.pearlgates.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779AbYDAOrn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Apr 2008 10:47:43 -0400
In-Reply-To: <1207059115.3100.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org

On Tue, 01 Apr 2008 09:11:55 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2008-04-01 at 01:15 -0700, Andrew Morton wrote:
> > 
> > I'd suggest that the next step would be to send us the `dmesg -s 1000000'
> > output for both good and bad kernels.  A comparison might show where things
> > went bad.
> 
> Yes, that would be my guess too ... although I don't see anything amiss
> in the dmesg   I note you have two ethernet interfaces:
> 
> eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:03:ba:08:61:7c
> eth1394: eth1: IPv4 over IEEE 1394 (fw-host0)
> 
> I'm assuming eth0 is the problem?

Yes, the Sun GEM interface is the problem. Ethernet over FireWire (a direct link between the webserver and database server) works just fine. In a minimal config with no devices enabled except the SU serial line (needed for console), the dual SCSI adapter and the Sun GEM nic, the problem still remained the same.

> Could you also send us the output of /proc/interrupts, /proc/iomem
> and /proc/ioports just to see if we have a problem.  Also, if eth0 is on
> its own interrupt line, does the interrupt count rise even while the
> interface is non functional?

Here goes:

seraphim ~ # cat /proc/interrupts                                               
           CPU0                                                                 
  0:       7259     <NULL>  timer                                               
  8:          0      sun4u  power                                               
  9:        405      sun4u  su(serial)                                          
 11:          1      sun4u  eth0                                                
 12:         95      sun4u  ohci1394                                            
 13:          0      sun4u  ohci_hcd:usb1                                       
 14:          0      sun4u  ALI 5451                                            
 15:       2265      sun4u  ide0                                                
 16:        293      sun4u  sym53c8xx                                           
 17:         69      sun4u  sym53c8xx

seraphim ~ # cat /proc/iomem                                                    
1fe020002e8-1fe020002ef : su                                                    
1fe020003f8-1fe020003ff : su                                                    
1fe02000800-1fe02000803 : power                                                 
1ff00000000-1ffffffffff : /pci@1f,0                                             
  1ff000a0000-1ff000bffff : Video RAM area                                      
  1ff000c0000-1ff000c7fff : Video ROM                                           
  1ff000f0000-1ff000fffff : System ROM                                          
  1ff00400000-1ff0041ffff : sungem                                              
  1ff00420000-1ff004207ff : ohci1394                                            
  1ff00424000-1ff00425fff : ALI 5451                                            
  1ff02000000-1ff02ffffff : ohci_hcd                                            
  1ff03000000-1ff03001fff : sym53c8xx                                           
  1ff03002000-1ff03003fff : sym53c8xx                                           
  1ff03004000-1ff03005fff : sym53c8xx                                           
  1ff03006000-1ff03007fff : sym53c8xx                                           
  1ffc0000000-1ffdfffffff : IOMMU                                               
  1fff1000000-1fff1001fff : clock

seraphim ~ # cat /proc/ioports                                                  
00000600-0000061f : ali1535_smbus                                               
1fe02000000-1fe02ffffff : /pci@1f,0                                             
  1fe02000600-1fe0200061f : 0000:00:03.0                                        
  1fe02000800-1fe0200083f : 0000:00:03.0                                        
  1fe02000900-1fe020009ff : ALI 5451                                            
  1fe02000a00-1fe02000a07 : ide0                                                
  1fe02000a1a-1fe02000a1a : ide0                                                
  1fe02000a20-1fe02000a27 : ide0                                                
  1fe02000a28-1fe02000a2f : ide1                                                
  1fe02001000-1fe020010ff : sym53c8xx                                           
  1fe02001100-1fe020011ff : sym53c8xx


-- 
Jos van der Ende <seraph@xs4all.nl>
