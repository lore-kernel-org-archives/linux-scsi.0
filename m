From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patchset 0/33] scsi_data_buffer for after the last driver is converted
Date: Wed, 17 Oct 2007 19:14:46 +0200
Message-ID: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13413 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754566AbXJQRPx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 13:15:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Jeff Garzik <jeff@garzik.org>, Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>

This is a resend of all the remaining drivers rebased
to latest code. And once the entire tree is converted,
move to scsi_data_buffer in scsi_cmnd.

The work is on top of Jens's for-linus branch which
is effectively sglist-arch (+ last minute fixes)
This is because sglist-arch was already rebased to
latest scsi-misc through linus tree, merged with 
the extra work done there on scsi-ml (and the drivers)
(Thanks Jens)

summery of patches:

left over from scsi_eh last change
  [PATCH 01/32] arm: fas216 Use scsi_eh API for REQUEST_SENSE invocation

lots and lots of drivers left:
  [PATCH 02/32] isd200.c: use one-element sg list in issuing commands
  [PATCH 03/32] usb: transport - convert to accessors and !use_sg code path removal
  [PATCH 04/32] usb: protocol.c - convert to accessors and !use_sg code path removal
  [PATCH 05/32] usb: shuttle_usbat.c - convert to accessors and !use_sg code path removal
  [PATCH 06/32] usb: freecom.c & sddr09.c - convert to accessors and !use_sg cleanup
  [PATCH 07/32] NCR5380 familly convert to accessors & !use_sg cleanup
  [PATCH 08/32] arm: scsi convert to accessors and !use_sg cleanup
  [PATCH 09/32] nsp_cs.c convert to data accessors and !use_sg cleanup
  [PATCH 10/32] eata_pio.c: convert to accessors and !use_sg cleanup
  [PATCH 11/32] a2091.c: convert to accessors and !use_sg cleanup
  [PATCH 12/32] a3000.c: convert to accessors and !use_sg cleanup
  [PATCH 13/32] aha1542.c: convert to accessors and !use_sg cleanup
  [PATCH 14/32] atp870u.c: convert to accessors and !use_sg cleanup
  [PATCH 15/32] fd_mcs.c: convert to accessors and !use_sg cleanup
  [PATCH 16/32] imm.c: convert to accessors and !use_sg cleanup
  [PATCH 17/32] ppa.c: convert to accessors and !use_sg cleanup
  [PATCH 18/32] wd32c93.c: convert to accessors and !use_sg cleanup
  [PATCH 19/32] qlogicpti.c: convert to accessors and !use_sg cleanup
  [PATCH 20/32] in2000.c: convert to accessors and !use_sg cleanup
  [PATCH 21/32] scsi_debug: convert to use the data buffer accessors

Tomo's patch cleaned up:
   [PATCH 22/32] qla1280: convert to use the data buffer accessors
   [PATCH 23/32] qla1280: Indentation fix

 I separated the indentation from the real change make
 the patch humanly readable.

A small fix:
  [PATCH 24/32] wd7000.c - proper fix for boards without sg support
  
Remove broken drivers:
  [PATCH 25/32] Remove psi240i driver from kernel
  [PATCH 26/32] Remove of seagate.c driver
  (pluto/fc was removed by Matthew.)

Move to scsi_data_buffer:

  [PATCH 27/32] scsi_data_buffer
  [PATCH 28/32] scsi_data_buffer - scsi_error.c
  [PATCH 29/32] scsi_data_buffer - sd.c and sr.c
  [PATCH 30/32] tgt: convert to use scsi_data_buffer
  [PATCH 31/32] tgt: convert ibmvstgt and libsrp to use scsi_data_buffer
  [PATCH 32/32] isd200.c - use of scsi_data_buffer

 It used to be that the tgt was broken between scsi_data_buffer patch
 and the patch to tgt, because of the API change to scsi_alloc/free_sgtable().
 I have added a shim in scsi_tgt_lib.c so it can compile and run. The shim is 
 later removed in the tgt patch.

 Did I miss any maintainers in the To: fields?

Boaz


