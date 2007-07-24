From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO
 sg-chaining
Date: Tue, 24 Jul 2007 11:47:50 +0300
Message-ID: <46A5BCB6.9050102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13671 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440AbXGXIsk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 04:48:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

As Jens said, there is nothing common to scsi_sgtable and 
sglists. Save the fact that it is a massive conflict at 
scsi-ml. They touch all the same places.

Proposed is a simple way out. Two patchsets That produce the
same output at the end.

One: scsi_sgtable_than_sg-chaining
Two: sg-chaining_than_scsi_sgtable

They are layed out like this

common to both
  [PATCH AB1/5] SCSI: SG pools allocation cleanup

scsi_sgtable_than_sg-chaining:
  [PATCH A2/5] SCSI: scsi_sgtable implementation
  [PATCH A3/5] SCSI: sg-chaining over scsi_sgtable

sg-chaining_than_scsi_sgtable:
  [PATCH B2/5] SCSI: support for allocating large scatterlists
  [PATCH B3/5] SCSI: scsi_sgtable over sg-chainning

Both patchsets are based on linux-2.6-block sglist-drivers (or sglist-arch)
on top of a:
  git-revert 630cfe6f8a137a3d494aefda1e62bc4b9ba02f58.
  Revert of "SCSI: support for allocating large scatterlists"

First patch will not apply on scsi-misc-2.6 because there
is a missing NULL in the call to kmem_cache_create(). (linux-2.6.23-rcx)
(If any one need a patchset for that please ask)

What we need to do first is agree on the outcome of both sgtable 
and sglist chaining combined. The easiest way is to look at the 
1st patchset AB1/5, A2/5, A3/5. It is the most incremental 
and easy to read.
 
(Note: This patchset is part of a larger patchset as I sent in my
last RFC "scsi-ml: scsi_sgtable implementation". You can find a
revised set here: www.bhalevy.com/open-osd/downloads/scsi_sgtable)

If we all agree on the combined outcome, than we can proceed to decide 
which route to take.

What I would like to ask of Jens is: please review the first 2 patches
from the B patchset. AB1/5, B2/5. These together are almost exactly like
your reverted patch above, but are a bit more friendly to the scsi_sgtable 
at the end.

For James the first patch [AB1/5] is a good patch that solves real
world problems today, like HIGHME64G=y. And maximizes allocations
for all kind of ARCHs. Maybe it could be applied to the tree now
for the next merge window, regardless of what is done with the
rest.

I'm just starting to test large IO's ontop of iSCSI. So probably some 
bugs will be found.

Thanks everybody
Boaz

