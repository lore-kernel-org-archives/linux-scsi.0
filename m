From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 0/3] varlen extended and vendor-specific cdbs
Date: Tue, 18 Dec 2007 15:33:50 +0200
Message-ID: <4767CC3E.8000309@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20624 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753720AbXLRNfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Dec 2007 08:35:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Benny Halevy <bhalevy@panasas.com>, Matthew Wilcox <matthew@wil.cx>

Submitted is a patchset for adding support for variable-length, extended, and 
vendor specific CDBs. It should now cover the entire range of the
SCSI standard.

They are based on scsi-misc + the submitted bidi patches.

Difference from last time, is at struct request. I did a smallish
hack to save the extra pointer space. The pointer now shares it's
space with the request->cmd, as they are mutual exclusive. The
flag to switch between them is when cmd_len == 0 and varlen_cdb_len != 0
I've added 2 accessors to hide the mess. I think this approach
should be safe. I can easily go back to the separate pointer,
but I figured a little hack is better then a bloat.

This is on top of the size shrink to struct scsi_cmnd gained
in the first patch. We save upto 12 bytes on 32 bit ARCHs

So over all, this cleans things up, and add fixtures with out
any extra cost.

[1/4] Let scsi_cmnd->cmnd use request->cmd buffer
  Here I let scsi_cmnd->cmnd point to the space allocated by
  request->cmd, instead of copying the data. The scsi_cmnd->cmd_len
  is guaranteed to contain the right length of the command.
  I have tried to go over every single place in the kernel that uses
  scsi_cmnd->cmnd and make sure it looks sane. Surprisingly to me,
  that was not at all bad. I hope I did not miss anything.

  I've tested on an x86_64 machine booting from a sata disk and
  ran the iscsi regression tests as well as my bidi and varlen tests
  on top of the complete patchset and all tests passed.

[2/4] block layer varlen-cd
   Here I added an option to use a user supplied buffer for an arbitrary
   large command. Buffer must be kept valid until execution of request
   ends. The pointer to the buffer shares it's space with the fixed
   length command, so the size of struct request does not change.

[3/4] scsi: varlen extended and vendor-specific cdbs
  Adds support for variable length, extended, and vendor-specific
  cdbs at the scsi mid-layer.

I will send a patch to iscsi once the pending iscsi patchset gets
committed into scsi-misc.

Boaz


