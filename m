From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 0/3] Is it time for varlen extended and vendor-specific
 cdbs
Date: Tue, 25 Mar 2008 17:57:57 +0200
Message-ID: <47E92105.2060703@panasas.com>
References: <20080209193224.GA21448@Chamillionaire.breakpoint.cc> <200802100006.11086.bzolnier@gmail.com> <20080210052621.GA22257@infradead.org> <200802101438.46698.bzolnier@gmail.com> <20080210144352.GA3537@infradead.org> <47AF1321.7000107@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:45562 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbYCYP7u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 11:59:50 -0400
In-Reply-To: <47AF1321.7000107@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org

Submitted is a patchset for adding support for variable-length, extended,
and vendor specific CDBs. It should now cover the entire range of the 
SCSI standard. (and/or any other use of command packets in block devices)

They are based on scsi-misc/scsi-rc-fixes/linux-block. They are aimed
for the 2.6.26 merge window. Andrew please also include them in -mm
for testing.

Difference from last time, is at struct request. I did a smallish
hack to save the extra pointer space. The pointer now shares it's
space with the request->cmd, as they are mutual exclusive. The
flag to switch between them is when cmd_len == 0 and varlen_cdb_len != 0
I've added 2 accessors to hide the mess. I think this approach
should be safe with legacy drivers.

This is on top of the size shrink to struct scsi_cmnd gained
in the first patch. We save upto 12 bytes on 32 bit ARCHs

So over all, this cleans things up, and add fixtures without
*any extra cost*.

[1/3] Let scsi_cmnd->cmnd use request->cmd buffer
  Here I let scsi_cmnd->cmnd point to the space allocated by
  request->cmd, instead of copying the data. The scsi_cmnd->cmd_len
  is guaranteed to contain the right length of the command.
  I have tried to go over every single place in the kernel that uses
  scsi_cmnd->cmnd and make sure it looks sane. Surprisingly to me,
  that was not at all bad. I hope I did not miss anything.

  I've tested on an x86_64 machine booting from a sata disk and
  ran the iscsi regression tests as well as my bidi and varlen tests
  on top of the complete patchset and all tests passed.

[2/3] block layer varlen-cd
   Here I added an option to use a user supplied buffer for an arbitrary
   large command. Buffer must be kept valid until execution of request
   ends. The pointer to the buffer shares it's space with the fixed
   length command, so the size of struct request does not change.

[3/3] scsi: varlen extended and vendor-specific cdbs
  Adds support for variable length, extended, and vendor-specific
  cdbs at the scsi mid-layer.

Boaz



