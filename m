From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 0/4 ver2] Is it time for varlen extended and vendor-specific
 cdbs
Date: Sun, 13 Apr 2008 19:30:30 +0300
Message-ID: <48023526.5050709@panasas.com>
References: <47E92672.1040208@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18447 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755174AbYDMQbY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Apr 2008 12:31:24 -0400
In-Reply-To: <47E92672.1040208@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mike

Yet another iteration with James's suggestions and the 3rd patch
converted to the new block API. Also a small patch for iscsi_tcp.c

---
Submitted is a patchset for adding support for variable-length, extended,
and vendor specific CDBs. It should now cover the entire range of the 
SCSI standard, and/or any other use of command packets in block devices.

They are based on scsi-misc. They are aimed for the 2.6.26 merge window. 

Andrew !
Please include them in -mm for testing. Atleast the first patch
that no one had any comments and is the theoretically dangerous cleanup.

Difference from last time, is at struct request. I did a smallish
hack to save the extra pointer space. The pointer now shares it's
space with the request->cmd, as they are mutual exclusive. The
flag to switch between them is when cmd_len == 0 and varlen_cdb_len != 0
I've added 3 accessors to hide the mess. I think this approach
should be safe with legacy drivers.

This is on top of the size shrink to struct scsi_cmnd gained
in the first patch. We save upto 12 bytes on 32 bit ARCHs

So over all, this cleans things up, and add fixtures without
*any extra cost*.

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

[4/4] iscsi_tcp: iscsi_tcp: Enable large commands
  just a one liner, Mike I need your Sign-off-by on this one.

Boaz
