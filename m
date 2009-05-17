From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patchset 0/5 version 2] osd: Stop usage of blk_rq_append_bio
Date: Sun, 17 May 2009 18:52:16 +0300
Message-ID: <4A1032B0.5000003@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:19580 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750878AbZEQPxa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 May 2009 11:53:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

[Version 2]
- Update to axboe/linux-2.6-block.git for-2.6.31 branch
- Added 5th patch that removes the export of blk_rq_append_bio()

[Version 1]
Osd library needs to submit pre-allocated bios, form several sources.
osdblk exofs and pNFS-layout driver all have prepared bios for IO submission.
On top of that the osd library needs to append additional segments to the
IO memory, for get/set attributes and more.

All these are done today by use of a temporary hack - blk_rq_append_bio().
This is bad on few accounts.
1. blk_rq_append_bio was not meant to be exported and is very specific to its users.
2. blk_rq_append_bio does not support chained bios.
3. blk_rq_append_bio does not bounce the bio and therefore current osd implementation
   has a bug.

The proposed solution adds two new fixtures to the block layer, and a corresponding
fixing patch to osd. These are:

[PATCH 1/5] allow blk_rq_map_kern to append to requests
[PATCH 2/5] libosd: Use new blk_rq_map_kern

  This is originally a James patch. It is used, to let blk_rq_map_kern append it's buffer
  to existing bio, and therefor is able to be called multiple times in a loop, to append
  multiple segments. This API can also be useful for scsi/block targets that have segment
  information in some other memory structure (like scatterlist) and wants to set it into
  a request. Until such time that they have a proper support for mapping scatterlists directly.
  (Above called on long lists might not be good for performance)

  Here in osd it makes tons of sense.

[PATCH 3/5] New blk_make_request(), takes bio, returns a request
[PATCH 4/5] libosd: Use of new blk_make_request
  
  Here I propose a new block API, that will support proper delegation of a bio
  to a full request. Please read inside the patch descriptions for details.
  After this patch both osd and block layer will have the proper support for osdblk
  driver as well as future needs.
  These patches also eliminate the last use of blk_rq_append_bio which can be finally un-exported.

[PATCH 5/5] Un-export blk_rq_append_bio

Thank you
Boaz
