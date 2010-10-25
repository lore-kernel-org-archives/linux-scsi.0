From: Andi Kleen <andi@firstfloor.org>
Subject: pmcraid has duplicated structure members and fails build
Date: Tue, 26 Oct 2010 00:16:33 +0200
Message-ID: <20101025221633.GF17622@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:35794 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0JYWQe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2010 18:16:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil_ravindranath@pmc-sierra.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


A current Linus kernel built with a gcc 4.6 snapshot for allyesconfig
on x86-64 fails with

In file included from /home/lsrc/git/linux-2.6/drivers/scsi/pmcraid.c:57:0:
/home/lsrc/git/linux-2.6/drivers/scsi/pmcraid.h:601:8: error: duplicate member 'sense_buffer'

The error is correct: 

/* pmcraid_cmd - LLD representation of SCSI command */
struct pmcraid_cmd {

        /* Ptr and bus address of DMA.able control block for this command */
        struct pmcraid_control_block *ioa_cb;
        dma_addr_t ioa_cb_bus_addr;
        dma_addr_t dma_handle;
        u8 *sense_buffer;             <---------- no 1

	...

	 /* scratch used */
        union {
                /* during reset sequence */
                unsigned long time_left;
                struct pmcraid_resource_entry *res;
                int hrrq_index;

                /* used during IO command error handling. Sense buffer
                 * for REQUEST SENSE command if firmware is not sending
                 * auto sense data
                 */
                struct  {
                        u8 *sense_buffer;    <-------- no 2
                        dma_addr_t sense_buffer_dma;
                };
        };

};

I think older gccs didn't diagnose that correctly, but it's really broken.

Can someone please figure out which one is the correct sense_buffer
and delete the other one?

Thanks,

-Andi




-- 
ak@linux.intel.com -- Speaking for myself only.
