From: Boaz Harrosh <bharrosh@panasas.com>
Subject: new scsi sense handling
Date: Mon, 04 Feb 2008 17:08:47 +0200
Message-ID: <47A72A7F.1050301@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:45091 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYBDPLT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 10:11:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J

There are 3 usages of sense handling in drivers

1. sense is available in driver internal structure and is mem-copied to upper level
2. A CHECK_CONDITION status was returned and the driver uses the scsi_eh_prep_cmnd()
   for a REQUEST_SENSE invocation to the target. Then returning the sense in 
   scsi_eh_return_cmnd(). A variation on this is when the driver does nothing the queue
   is frozen an the scsi watchdog timer does the above.
3. The underline host adapter does the REQUEST_SENSE and a pre-allocated and DMA mapped
   sense buffer receives the sense information from HW.

Now since all IO requests come with a sense set at request->sense the buffer at 
scsi_cmnd->sense_buffer can go away, and case 1 above can copy it's bits directly
into it.
Inspection of all users of blk_execute_rq_nowait() shows that all users setup a sense
buffer, but submitted code puts a BUG_ON to make sure new code does not break that.

for cases 2 and 3 above two new members in scsi host template will tell scsi-midlayer
what the driver wants to do.

.sense_buffsize  - will instruct a mempool_t to be allocated per host with sense buffers 
                   of ".sense_buffsize" size.

.pre_allocate_sense - If set tells the midlayer to pre-allocate a sense buffer for each
                      command. When set the code will behave like today. If the sense 
                      allocation fails the command allocation also fails. (With one extra
                      sense at mempool)
                      If .pre_allocate_sense is not set, then mempool_t is resized to
                      accommodate one reserved buffer for each target. So a call to
                      scsi_eh_prep_cmnd() will not fail to allocate a sense buffer even
                      in low memory condition.

Case 1 drivers call - scsi_eh_cpy_sense() - to transfer their sense information to upper
  layer. The drivers are completely abstracted from any future changes at the scsi and block
  sense handling. 

Case 3 drivers call the new scsi_make_sense()/scsi_return_sense() API to retrieve
  a pointer to an extra DMAable sense buffer/return it to free store. scsi_return_sense()
  will call scsi_eh_cpy_sense() to set new sense information into upper layer before
  freeing the buffer back to the mempool. If the driver properly set the .pre_allocate_sense
  flag & .sense_buffsize at host template then these calls are guaranteed to succeed.

Case 2 drivers continue to call scsi_eh_prep_cmnd()/scsi_eh_restore_cmnd() to reuse the
  failing command for REQUEST_SENSE. Inside these functions scsi_error.c will call above
  scsi_make_sense()/scsi_return_sense() for the actual sense buffer allocation. In this 
  case there is a guarantied, one reserved buffer per scsi_device. (.pre_allocate_sense not set).
  Drivers need to set proper size at .sense_buffsize in host template, for this to work.

Upper layer and ULDs that need to inspect the sense information can get to it
  using the scsi_sense() accessor.

Submitted for Review and comments (RFC) a patcset for that effect.

- first patch will introduce the new API implemented over existing members:
	scsi_eh: Define  new API for sense handling

- first group of patches are the case 1 drivers:
	scsi-drivers: Move to new sense API. The Trevial case
	scsi-drivers: more drivers use new scsi_eh_cpy_sense()
	firewire & ieee1394: Simple convert to new scsi_eh_cpy_sense.
	dpt_i2o: Use new scsi_eh_cpy_sense()
	gdth: Use of scsi_eh API and sense accessors
	qla2xxx: convert to new scsi_eh_cpy_sense API
	isd200, transport: Use scsi_eh_cpy_sense API
	ultrastor: Use scsi_eh_cpy_sense() API
	usb/microtek: No special handling for REQUEST_SENSE command please

- second group are case 2 drivers:
	libata: Use scsi_eh API for REQUEST_SENSE invocation
	53c700: Use scsi_eh API for REQUEST_SENSE invocation
	aic7xxx_old: Use scsi_eh API for REQUEST_SENSE invocation
	dc395x: Use scsi_eh API for REQUEST_SENSE invocation
	tmscsim: Use scsi_eh API for REQUEST_SENSE invocation
	Add .sense_buffsize to drivers that use scsi_eh_prep_cmnd

- third group are case 3:
	BusLogic: Use of scsi_make_sense() API for DMA-able sense buffer
	eata: Use of scsi_make_sense() API for DMA-able sense buffer
	initio: Use of scsi_make_sense() API for DMA-able sense buffer
	u14-34f: Use of scsi_make_sense() API for DMA-able sense buffer

- Then, some patches for the upper layer:
	scsi_tgt: use of sense accessors
	scsi upper layer use of sense accessors

- And finally, block and scsi-midlayer switch to new handling.
	block: Minor changes to sense handling
	scsi: New sense handling

These patches are over latest scsi-misc. They are completely *untested* and are for discussion
only. I will debug and update in the near future but only if it is accepted in principle
first.

Lots of maintainers' ACKs are needed and a good deal of testing time in mm so I think this 
is only 2.6.26 at the earliest.

Comment away ;)
Volunteers for testing needed!

Boaz


