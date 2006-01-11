From: Andrew Morton <akpm@osdl.org>
Subject: Re: aic7xxx timer handling bug
Date: Tue, 10 Jan 2006 19:30:25 -0800
Message-ID: <20060110193025.1e37ad77.akpm@osdl.org>
References: <20060109040606.118a0d33.akpm@osdl.org>
	<1136916702.3509.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:54178 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932612AbWAKDan (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 22:30:43 -0500
In-Reply-To: <1136916702.3509.29.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> On Mon, 2006-01-09 at 04:06 -0800, Andrew Morton wrote:
>  > While doing a binary search for a buggy patch (it was
>  > gregkh-pci-x86-pci-domain-support-the-meat.patch, reported on
>  > linux-kernel), I hit the below.
> 
>  OK, try this; it should pull out all of the aic7xxx timer handling and
>  replace it with proper mechanisms (I had to rework the locking a bit to
>  get this to happen correctly, so caveat emptor).

It fixes the oops.  With this +
gregkh-pci-x86-pci-domain-support-the-meat.patch:


 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]               
 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]               
 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]               
 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]               
 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]               
 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]               
Pending list:                                     
  2 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] 
Kernel Free SCB list: 1 0                         
Untagged Q(0): 2          
                 
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:0: Cmd aborted from QINFIFO                    
aic7xxx_abort returns 0x2002         
 0:0:0:0: scsi: Device offlined - not ready after error recovery
 0:0:1:0: Attempting to queue an ABORT message                  
CDB: 0x12 0x0 0x0 0x0 0x24 0x0                
 0:0:1:0: Command already completed
aic7xxx_abort returns 0x2002       
 0:0:1:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0                  
scsi0: At time of recovery, card was paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State in Message-in phase, at SEQADDR 0x103
Card was paused                                                
ACCUM = 0x0, SINDEX = 0x71, DINDEX = 0xe4, ARG_2 = 0x0
HCNT = 0x0 SCBPTR = 0x0                               
SCSIPHASE[0x8]:(MSG_IN_PHASE) SCSISIGI[0xe6]:(REQI|BSYI|MSGI|IOI|CDI) 
ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0xe0]:(MSGI|IOI|CDI)               
SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) SBLKCTL[0xa]:(SELWIDE|SELBUSB) 
SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0]              
SSTAT0[0x2]:(SPIORDY) SSTAT1[0x11]:(REQINIT|PHASEMIS) 
SSTAT2[0x10]:(EXP_ACTIVE) SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP) 
SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)     
SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD 
STACK: 0x0 0x164 0x179 0x102                                                   
SCB count = 4               
Kernel NEXTQSCB = 3
Card NEXTQSCB = 2  
QINFIFO entries: 2 
Waiting Queue entries: 
Disconnected Queue entries: 
QOUTFIFO entries:           
Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 2 
Sequencer SCB Info:                                                            
  0 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) SCB_SCSIID[0x17] 
SCB_LUN[0x0] SCB_TAG[0xff]                                  
  1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]               
  2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]               
  3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]               
  4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]               


That all took about one minute per disk.  I have 10 SCSI disks in this
thing.

Then we get a few minutes of:

scsi0:0:5:0: Cmd aborted from QINFIFO                    
aic7xxx_abort returns 0x2002         
 0:0:5:0: scsi: Device offlined - not ready after error recovery
 0:0:6:0: Attempting to queue an ABORT message                  
CDB: 0x12 0x0 0x0 0x0 0x24 0x0                
 0:0:6:0: Command already completed
aic7xxx_abort returns 0x2002       
 0:0:6:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0                  
 0:0:6:0: Command already completed
aic7xxx_abort returns 0x2002       
 0:0:6:0: Attempting to queue a TARGET RESET message
CDB: 0x12 0x0 0x0 0x0 0x24 0x0                      
 0:0:6:0: Command not found   
aic7xxx_dev_reset returns 0x2002
 0:0:6:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0                  
 0:0:6:0: Command already completed
aic7xxx_abort returns 0x2002       
 0:0:6:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0                  
 0:0:6:0: Command already completed
aic7xxx_abort returns 0x2002       
 0:0:6:0: scsi: Device offlined - not ready after error recovery
 0:0:8:0: Attempting to queue an ABORT message                  
CDB: 0x12 0x0 0x0 0x0 0x24 0x0                
 0:0:8:0: Command already completed
aic7xxx_abort returns 0x2002       
 0:0:8:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0                  
 0:0:8:0: Command already completed
aic7xxx_abort returns 0x2002       
 0:0:8:0: Attempting to queue a TARGET RESET message
CDB: 0x12 0x0 0x0 0x0 0x24 0x0                      
 0:0:8:0: Command not found   



After about 20 minutes, initscripts ran and it almost booted.  (This
machine has everything installed on the IDE disk).

Perhaps those timeouts are a bit too long??
