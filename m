From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC] Remove of ISA pools, and Lazy sense allocation.
Date: Wed, 07 May 2008 13:57:40 +0300
Message-ID: <48218B24.4000507@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10006 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753813AbYEGK6P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2008 06:58:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Benny Halevy <bhalevy@panasas.com>

Let me please explain a bit on my sense_buffer patchset and where I was going 
with these:

Currently every ULD/Initiator that pushes request to block devices puts a sense
buffer of SCSI_SENSE_BUFFERSIZE size onto request->sense pointer. scsi-midlayer
shadows that buffer, for what it thought as a DMAable buffer for drivers, and at
completion of request copies the shadow buffer back into ULD's buffer.

I have observed three uses of sense_buffer handling in scsi drivers:

1. Driver has internal sense data, which is copied if needed into scsi-ml shadow
   by use of memcpy.
   This group is by far the biggest with more than 66% of drivers. For this 
   group the scsi shadow is a waste of resources and cycles, the ULD's buffer 
   could be used directly.

   In my patchset I've introduced a new API for these drivers to use:
   scsi_eh_cpy_sense() - And have converted all drivers to use this API.
   (Few drivers had bugs here where they would overrun internal buffers which
    was fixed)

2. The second group is those drivers that use the scsi_eh_prep/restore_cmnd()
   API, to hijack the failing command, convert it to a REQUEST_SENSE scsi
   command. Put it directly at drivers head of Q and restore original command
   when done.
   In this group also fall the drivers that do nothing in regard to sense
   handling. That is, the scsi-ml will call the scsi_eh_prep/restore_cmnd()
   (See scsi_error.c) and will use the .queuecommand() to issue the 
   REQUEST_SENSE. This can happen synchronously or asynchronously on the scsi
   watchdog.

   In my patchset I have a bunch of drivers that I've converted to use this API
   as currently, they where doing the same thing, home cooked.  These patches
   are a good cleanup and should be accepted into the tree what ever the
   out come of the rest of the patches.

   A regular sense_buffer kmem_cache is kept at scsi.c for the regular use.
   This cache is only allocated from, when needed at actual error, and not at
   every command allocation. One reserved buffer is kept for forward progress
   in low memory conditions. Special drivers like ISA or drivers that can not
   fail the REQUEST_SENSE allocation, can supply an external, driver allocated,
   sense_buffer and are supported that way.

3. The third group
   This group is those few drivers that DMA-map the sense buffer, before
   execution of each command, for direct/automatic HW sense handling.

   What I have done with these drivers in my patchset is to allocate a DMAable 
   sense buffer in each driver's private host data, though converting them to 
   group 1. At completion of command, sense buffer is then copied using the new
   API. Usually there is already a host's per-command-info that is allocated,
   mostly as part of the hostdata. Since host data has the proper mask already,
   and since mask allocation is done in full pages only, the sense buffers are
   used out of wasted (Allocated but not used) memory.

Lets see some numbers:
Group 1: For which sense_buffer is a complete waste.
 patch 1
	arch/ia64/hp/sim/simscsi.c           
	drivers/block/cciss_scsi.c           
	drivers/infiniband/ulp/srp/ib_srp.c  
	drivers/message/fusion/mptscsih.c    
	drivers/message/i2o/i2o_scsi.c       
	drivers/scsi/3w-9xxx.c               
	drivers/scsi/a100u2w.c               
	drivers/scsi/aha1542.c               
	drivers/scsi/aha1740.c               
	drivers/scsi/atp870u.c               
	drivers/scsi/hptiop.c                
	drivers/scsi/ibmvscsi/ibmvscsi.c     
	drivers/scsi/ibmvscsi/ibmvstgt.c     
	drivers/scsi/ide-scsi.c              
	drivers/scsi/libiscsi.c              
	drivers/scsi/libsas/sas_scsi_host.c  
	drivers/scsi/lpfc/lpfc_scsi.c        
	drivers/scsi/megaraid.c              
	drivers/scsi/megaraid/megaraid_sas.c 
	drivers/scsi/ncr53c8xx.c             
	drivers/scsi/qlogicpti.c             
	drivers/scsi/scsi_debug.c            
	drivers/scsi/sym53c8xx_2/sym_glue.c  
 patch 2
	drivers/s390/scsi/zfcp_fsf.c          
	drivers/scsi/3w-xxxx.c                
	drivers/scsi/aacraid/aachba.c         
	drivers/scsi/aic7xxx/aic79xx_osm.c    
	drivers/scsi/aic7xxx/aic7xxx_osm.c    
	drivers/scsi/arcmsr/arcmsr_hba.c      
	drivers/scsi/arm/fas216.c             
	drivers/scsi/ipr.c                    
	drivers/scsi/ips.c                    
	drivers/scsi/megaraid/megaraid_mbox.c 
	drivers/scsi/ps3rom.c                 
	drivers/scsi/qla1280.c                
	drivers/scsi/qla4xxx/ql4_isr.c        
	drivers/scsi/stex.c                   
more patches
	drivers/firewire/fw-sbp2.c
	drivers/ieee1394/sbp2.c
	drivers/scsi/dpt_i2o.c
	drivers/scsi/qla2xxx/qla_isr.c
	drivers/scsi/aacraid/aachba.c
	drivers/usb/storage/isd200.c
	drivers/usb/storage/transport.c
	drivers/usb/storage/cypress_atacb.c
Total 45 Drivers

Group 2:
	drivers/scsi/NCR5380.c
	drivers/scsi/aha152x.c - ISA  not DMA
	drivers/scsi/arm/fas216.c
	drivers/scsi/atari_NCR5380.c
	drivers/scsi/sun3_NCR5380.c
	drivers/usb/storage/cypress_atacb.c
	drivers/usb/storage/transport.c
	drivers/ata/libata-eh.c
	drivers/ata/libata-scsi.c
	drivers/scsi/53c700.c
	drivers/scsi/aic7xxx_old.c
	drivers/scsi/dc395x.c
	drivers/scsi/tmscsim.c
	drivers/usb/image/microtek.c
	drivers/scsi/wd7000.c - ISA does nothing (private pool set)
	drivers/scsi/NCR53c406a.c - ISA not DMA does nothing
	drivers/scsi/sym53c416.c - ISA not DMA does nothing
Total 17

Group 3:
	drivers/scsi/initio.c	- PCI (sglist is mapped unaligned already)
	drivers/scsi/BusLogic.c	- ISA & PCI
	drivers/scsi/advansys.c	- ISA & PCI
	drivers/scsi/eata.c	- ISA & PCI
	drivers/scsi/u14-34f.c	- ISA EISA & VLB
	drivers/scsi/ultrastor.c- ISA EISA & VLB
	drivers/scsi/gdth.c	- ISA PCI (sglist is mapped unaligned already)
Total 7:

So we can see that there is only one driver served with current model the other
6 in group 3 are ISA and need special consideration.

I might have got lazy with BusLogic, advansys, eata, and gdth in respect
to cache_line alignment in none cache coherent systems with a PCI bus. But this
is because I have identified that this problem already exist in those drivers.
If requested this can easily be fixed.

I have arranged the patches as follows

Preliminary preparations
	bb719b8 scsi_free_command API change - Don't support GFP_DMA
	b12fd37 isd200: Use new scsi_allocate_command()
	a6da5e5 gdth: consolidate __gdth_execute && gdth_execute
	3802c90 gdth: Use scsi_allocate_command for private command allocation

  Change API of scsi_free_command/scsi_allocate_command to not support GFP_DMA
  since it will be dropped.

Define new/changed API for sense handling
	8956f1f scsi_eh: Define new API for sense handling
	6aab5ea scsi_eh: Change scsi_eh_prep_cmnd API
	b649a7f scsi_eh: Define API for driver private sense allocation

  Define all new APIs drivers will need for sense handling

ISA Drivers
	da99dcc BusLogic: Remove unchecked_isa
	364e3fa advansys: Remove unchecked_isa_dma
	0886e54 eata: Remove unchecked_isa_dma
	1534919 wd7000: Remove unchecked_isa_dma
	c0096b7 u14-34f: Remove unchecked_isa_dma
	f5a7f8f gdth: Remove unchecked_isa_dma
	1945ffa aha1542: Remove unchecked_isa_dma
	f8fecfc NCR53c406a: Remove unseported isa USE_DMA
	496871b sym53c416: Remove unchecked_isa_dma
	c75180b ultrastor: Remove unchecked_isa_dma and bugfix for isa allocation

  Each driver with it's specific needs. Perhaps I have miss-read the code or got
  lazy on some of these, so please help me review them.

Define mask allocator and export queue's device mask
	8bc7d56 Add blk_q_mask
	c6433b7 Add the alloc/get_pages_mask calls

Remove unchecked_isa_dma from scsi-midlayer
	595e755 Remove GFP_DMA uses in st/osst
	a4a3e63 Remove unchecked_isa_dma checks in sg.c
	711dc32 Convert sr driver over the mask allocator
	8148074 Convert DMA buffers in ch.c to allocate via mask allocator
	c46c837 Use mask allocator in scsi_scan
	cb913a8 Remove unchecked_isa_dma from scsi-midlayer && sysfs
	a83a9fe scsi: Remove ISA support

  Use mask allocators where appropriate.

More drivers of Group 2 that needed cleaning up
	bc09919 libata: Use scsi_eh API for REQUEST_SENSE invocation
	62e9aa6 53c700: Use scsi_eh API for REQUEST_SENSE invocation
	2b6d4e1 aic7xxx_old: Use scsi_eh API for REQUEST_SENSE invocation
	0818baa dc395x: Use scsi_eh API for REQUEST_SENSE invocation
	2a34756 tmscsim: Use scsi_eh API for REQUEST_SENSE invocation
	e6b3e04 usb/microtek: No special handling for REQUEST_SENSE command please

  These patches should go in, any which way things turn out.

Group 3
	39b3972 initio: Use Internal DMA-able sense buffer

Group 1 convert to sense accessors
	8b93670 scsi-drivers: Move to new sense API. The Trivial case
	6984356 scsi-drivers: more drivers use new scsi_eh_cpy_sense()
	08abffc firewire & ieee1394: Simple convert to new scsi_eh_cpy_sense.
	06c182b dpt_i2o: Use new scsi_eh_cpy_sense()
	c59995f qla2xxx: convert to new scsi_eh_cpy_sense API
	0867463 aacraid: use scsi_eh_cpy_sense
	c8e02bf isd200, transport: Use scsi_eh_cpy_sense API
	4e988cf cypress_atacb: convert to sense accecors

Block layer changes
	98ab428 block: Minor changes to sense handling

Scsi upper layer use of accessors
	d935e33 scsi_tgt: use of sense accessors
	dc84b8c scsi: Use of sense accessors

Finally the new system
	960e208 scsi: New sense handling

Out of tree patch that let me debug all this code
	1c78e9d scsi_debug: Try all error path APIs

So at the end of this patchset a sense buffer is never-to-rarely allocated, only
when an actual error occurs. The shadow buffer at scsi_cmnd is removed. Few
drivers do their own shadowing. GFP_DMA is not used anywhere. ISA special pools
and handling are removed.

The main idea behind this patchset, as was explained by Andi, is that the driver 
knows best, and has all the infrastructure already, to take care of itself, properly.
There is no longer a silver bullet that can fit all drivers/platforms. For example look
at the ISA drivers that allocate the sense_buffer as part of their host data. This space
cost 0 memory, since they already had a full page of masked allocation but only used a 
fraction of it.

I will not spam the list with the 40 something patches. As it seems I'm already wasting
my time with these. I would like to say that I had no agenda or motivation with these
patches. I went in to fix an issue, and saw that the current model serves very few drivers
and is a complete waste of effort and resources for the big majority of drivers. Combined
with Andi's changes to ISA drivers, I have observed that current model only serves one
driver, initio. So I thought: that is too much I must do something. Well here it is. I will
do any work requested from me by Andi or others, but I will probably not volunteer any
of my own. I might keep them rebased for a kernel or 2, just for fun.

Find all these patches on the gitweb here:
http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=boaz_sense_effort

and in git form here:
git://git.open-osd.org/open-osd boaz_sense_effort

Boaz

