From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/4] bidi support: block layer bidirectional io.
Date: Mon, 16 Apr 2007 14:03:02 -0400
Message-ID: <4623BA56.8090706@torque.net>
References: <46225E18.7070404@panasas.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46225E18.7070404@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-ide <linux-ide@vger.kernel.org>, Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> Following are 4 (large) patches for support of bidirectional
> block I/O in kernel. (not including SCSI-ml or iSCSI)
> 
> The submitted work is against linux-2.6-block tree as of
> 2007/04/15, and will only cleanly apply in succession.
> 
> The patches are based on the RFC I sent 3 months ago. They only
> cover the block layer at this point. I suggest they get included
> in Morton's tree until they reach the kernel so they can get
> compiled on all architectures/platforms. There is still a chance
> that architectures I did not compile were not fully converted.
> (FWIW, my search for use of struct request members failed to find
> them). If you find such a case, please send me the file
> name and I will fix it ASAP.
> 
> Patches summary:
> 1. [PATCH 1/4] bidi support: request dma_data_direction
> 	- Convert REQ_RW bit flag to a dma_data_direction member like in SCSI-ml use.
> 	- removed rq_data_dir() and added other APIs for querying request's direction.
> 	- fix usage of rq_data_dir() and peeking at req->cmd_flags & REQ_RW to using
> 	  new api.
> 	- clean-up bad usage of DMA_BIDIRECTIONAL and bzero of none-queue requests,
> 	  to use the new blk_rq_init_unqueued_req()
> 
> 2. [PATCH 2/4] bidi support: fix req->cmd == INT cases
> 	- Digging into all these old drivers, I have found traces of past life
> 	  where request->cmd was the command type. This patch fixes some of these
> 	  places. All drivers touched by this patch are clear indication of drivers
> 	  that were not used for a while. Should we removed them from Kernel? 
> 	  These Are:
> 		drivers/acorn/block/fd1772.c, drivers/acorn/block/mfmhd.c,
> 		drivers/block/nbd.c, drivers/cdrom/aztcd.c, drivers/cdrom/cm206.c
> 		drivers/cdrom/gscd.c, drivers/cdrom/mcdx.c, drivers/cdrom/optcd.c
> 		drivers/cdrom/sjcd.c, drivers/ide/legacy/hd.c, drivers/block/amiflop.c
> 
> 2. [PATCH 3/4] bidi support: request_io_part
> 	- extract io related fields in struct request into struct request_io_part
> 	  in preparation to full bidi support.
> 	- new rq_uni() API to access the sub-structure. (Please read below comment
> 	  on why an API and not open code the access)
> 	- Convert All users to new API.
> 
> 3. [PATCH 4/4] bidi support: bidirectional block layer
> 	- add one more request_io_part member for bidi support in struct request.
> 	- add block layer API functions for mapping and accessing bidi data buffers
> 	  and for ending a block request as a whole (end_that_request_block())
> 
> --------------------------------------------------------------------------------------------
> Developer comments:
> 
> patch 1/4: Borrow from struct scsi_cmnd use of enum dma_data_direction. Further work (in
> progress) is the removal of the corresponding member from struct scsi_cmnd and converting
> all users to directly access rq_dma_dir(sc->req).
> 
> patch 3/4: The reasons for introducing the rq_uni(req) API rather than directly accessing
> req->uni are:
> 
> * WARN(!bidi_dir(req)) is life saving when developing bidi enabled paths.  Once we, bidi
>   users, start to push bidi requests down the kernel paths, we immediately get warned of
>   paths we did not anticipate. Otherwise, they will be very hard to find, and will hurt
>   kernel stability.
> 
> * A cleaner and saner future implementation could be in/out members rather than
>   uni/bidi_read.  This way the dma_direction member can deprecated and the uni sub-
>   structure can be maintained using a pointer in struct req.
>   With this API we are free to change the implementation in the future without
>   touching any users of the API. We can also experiment with what's best. Also, with the
>   API it is much easier to convert uni-directional drivers for bidi (look in
>   ll_rw_block.c in patch 4/4).
> 
> * Note, that internal uses inside the block layer access req->uni directly, as they will
>   need to be changed if the implementation of req->{uni, bidi_read} changes.

Boaz,
Recently I have been looking at things from the perspective
of a SAS target and thinking about bidi commands. Taking
XDWRITEREAD(10) in sbc3r09.pdf (section 5.44) as an example,
with DISABLE_WRITE=0, the "device server" in the target should
do the following:
  a) decode the cdb **
  b) read from storage [lba, transfer_length]
  c) fetch data_out from initiator [transfer_length] ***
  d) XOR data from (b) and (c) and place result in (z)
  e) write the data from (c) to storage [lba, transfer_length]
  f) send (z) in data_in to initiator [transfer_length]
  g) send SCSI completion status to initiator

Logically a) must occur first and g) last. The b) to f)
sequence could be repeated (perhaps) by the device server
subdividing the transfer_length (i.e. it may not be
reasonable for the OS to assume that the data_out transfer
will be complete before there is any data_in transfer).
With this command (and with most other bidi commands I
suspect) there is little opportunity for full duplex data
movement within this command (i.e. little or no data
associated with this command moving both ways "on the wire"
at the same time).


Seen from sgv4 and the initiator we basically set up
the resources that the target's device server uses
during the execution of that command:
  0) cdb [XDWRITEREAD(lba,transfer_length)]
  1) data_out buffer ("write" out to device)
  2) data_in buffer ("read" in from device)
  3) sense buffer (in case of problems)
  4) SCSI (and transport) completion status

After setting up 1), 2) and 3), the initiator pushes 0) to
the target (lu) and then waits until it is told 4) is
finished. The order in which 1) and 2) are used is dictated
by the device server in the target. [Pushing 0) and 1) can
be partially combined in the ** case, see below.]

I assume 1) and 2) will have their own scatter gather lists in
the "request" layer. Describing that as DMA_BIDIR makes me
feel a bit uneasy. It is definitely better that a binary "rw"
flag. Couldn't the HBA have different inbound and outbound DMA
engines associated with different PCI devices?

My concern stated a different way is that a "bidi" SCSI command
using two scatter gather lists at the initiator end looks very
similar to two queued SCSI commands: typically a READ queued
behind a WRITE. We don't consider the latter pair
(PCI_)DMA_BIDIRECTIONAL.


On rereading your comments above, are you planning to
retire the DMA_BIDIRECTIONAL flag in the future?


** various SCSI transports have a mechanism for sending
   some data_out with the cdb. Some transports allow
   the device server to control that via the "first burst
   size" field in the disconnect-reconnect mode page.
   I have been told that all known SAS implementations
   set that field to zero (and some want the capability
   removed from the standard). FCP?

***Both SAS and FCP control data_out transfers indirectly
   via the XFER_RDY (t->i) frame.

Doug Gilbert
