From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.4 use __dma_buffer in scsi.h
Date: Wed, 12 Jun 2002 22:17:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206130218.g5D2Hx302994@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id TAA21474
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2002 19:18:07 -0700
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@topspin.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> Use __dma_buffer macro to align sense_buffer member of Scsi_Cmnd.
[...]

> -       unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];              /* obtained by REQUEST SENSE
> +       unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE] __dma_buffer;         /* obtained by REQUEST SENSE

This is actually unnecessary.  We've already had this discussion on the parisc 
mailing lists (over a year ago, I think).

The SCSI subsystem is designed with this type of cache incoherency problem in 
mind.  The Scsi_Cmnd structure has an ownership model to forestall cache line 
bouncing.  The idea is that when you want to dma to/from components of a 
Scsi_Cmnd, you can only do it when the ownership is SCSI_OWNER_LOW_LEVEL, 
which guarantees that nothing in the mid layer will touch the command and 
trigger an incoherency (at least until it times out).  The low level driver is 
supposed to know about the cache incoherency problem, and so avoids touching 
the structure between cache line invalidation/writeback and DMA completion, 
thus, with a correctly implemented driver, there should be no possibility of 
DMA corruption.

Each of the Scsi_Cmnd blocks is individually allocated with kmalloc, so 
they're guaranteed to be non-interfering when it comes to DMA.

Incidentally, if you're really going to insist on padding the structure, some 
drivers also use the cmnd element to DMA the command from, so that should be 
aligned as well.  But I think the best course of action is to fix any low 
level drivers that are not following the cache rules rather than expanding 
Scsi_Cmnd.

James Bottomley


