From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Thu, 19 Nov 2015 12:02:44 +1100
Message-ID: <1447894964.15206.0.camel@ellerman.id.au>
References: <1447838334.1564.2.camel@ellerman.id.au>
	 <1447855399.3974.24.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447855399.3974.24.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-11-18 at 09:03 -0500, Mark Salter wrote:
> On Wed, 2015-11-18 at 20:18 +1100, Michael Ellerman wrote:
> > Hi folks,
> > 
> > I'm intermittently seeing the following oops on at least one powerpc box.
> > 
> > The BUG_ON() is from:
> > 
> > static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
> > {
> > 	...
> > 	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
> > 	BUG_ON(count > sdb->table.nents);
> > 
> > Looking at the dump it looks like count was 2, I can't work out what nents was.
> > 
> > The machine's just a fairly boring bare metal setup, with a single IPR adapter:
> > 
> > 0001:08:00.0 RAID bus controller: IBM PCI-E IPR SAS Adapter (ASIC) (rev 02)
> > 	Subsystem: IBM PCIe3 x8 SAS RAID Internal Adapter 6Gb (57D7)
> > 	Flags: bus master, fast devsel, latency 0
> > 	Kernel driver in use: ipr
> > 
> > 
> > Anyone seen it before or have any ideas?
> 
> I'm also seeing it on arm64 in 4.4-rc1

Ah thanks, that's a good data point. I was assuming it was a driver bug, but I
assume you're not using IPR :)

> [    6.859003] Call trace:                                                                      
> [    6.861439] [<fffffe000074345c>] scsi_init_sgtable+0x84/0x88                                 
> [    6.867072] [<fffffe00007434ac>] scsi_init_io+0x4c/0x1ac                                     
> [    6.872358] [<fffffe000075004c>] sd_setup_read_write_cmnd+0x44/0x844                         
> [    6.878682] [<fffffe0000750884>] sd_init_command+0x38/0xb0                                   
> [    6.884141] [<fffffe00007436e4>] scsi_setup_cmnd+0xd8/0x13c                                  
> [    6.889686] [<fffffe000074397c>] scsi_prep_fn+0xc0/0x140                                     
> [    6.894973] [<fffffe00003bd0cc>] blk_peek_request+0x148/0x24c                                
> [    6.900692] [<fffffe0000744754>] scsi_request_fn+0x58/0x648                                  
> [    6.906237] [<fffffe00003b8e80>] __blk_run_queue+0x40/0x58                                   
> [    6.911696] [<fffffe00003b91a4>] blk_run_queue+0x30/0x48                                     
> [    6.916983] [<fffffe00007422e4>] scsi_run_queue+0x204/0x294                                  
> [    6.922528] [<fffffe000074321c>] scsi_end_request+0x13c/0x1a0                                
> [    6.928247] [<fffffe0000744ef4>] scsi_io_completion+0xf0/0x564                               
> [    6.934052] [<fffffe000073beb0>] scsi_finish_command+0xe4/0x144                              
> [    6.939943] [<fffffe00007446cc>] scsi_softirq_done+0x148/0x178                               
> [    6.945748] [<fffffe00003c39a4>] blk_done_softirq+0x7c/0x94                                  
> [    6.951295] [<fffffe00000c8f44>] __do_softirq+0x114/0x2a0                                    
> [    6.956667] [<fffffe00000c9340>] irq_exit+0x8c/0xe4                                          
> [    6.961522] [<fffffe000009cf00>] handle_IPI+0x170/0x228                                      
> [    6.966721] [<fffffe00000904e0>] gic_handle_irq+0xa0/0xb8                                    
> [    6.972093] Exception stack(0xfffffe03dc143de0 to 0xfffffe03dc143f00)                        

cheers
