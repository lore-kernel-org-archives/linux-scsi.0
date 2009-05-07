From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patchset 0/4] osd: Stop usage of blk_rq_append_bio
Date: Thu, 07 May 2009 19:10:28 +0300
Message-ID: <4A0307F4.50205@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:18653 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753725AbZEGQKm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2009 12:10:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>


Osd library needs to submit pre-allocated bios, form several sources.
osdblk exofs and pNFS-layout driver all have prepared bios for IO submission.
On top of that the osd library needs to append additional segments to the
IO memory, for get/set attributes and more.

All these are done today by use of a temporary hack - blk_rq_append_bio.
This is bad on few accounts.
1. blk_rq_append_bio was not meant to be exported and is very specific to its users.
2. blk_rq_append_bio does not support chained bios.
3. blk_rq_append_bio does not bounce the bio and therefore current osd implementation
   has a bug.

The proposed solution adds two new fixtures to the block layer, and a corresponding
fixing patch to osd. These are:

[PATCH 1/4] allow blk_rq_map_kern to append to requests
[PATCH 2/4] libosd: Use new blk_rq_map_kern

  This is originally a James patch and it's used, to let blk_rq_map_kern append it's buffer
  to existing bio, and there for is able to be called multiple times in a loop, to append
  multiple segments. This API can also be useful for scsi/block targets that have segment
  information in some other memory structure (like scatterlist) and wants to set it into
  a request. Until such time that they have a proper support for mapping scatterlists directly.
  (Since above called on long lists might not be good for performance)

  Here in osd it makes tons of sense, and should be considered for inclusion.
  (The patches are based on linus-tip but should patch on block tree)

[RFC 3/4] New blk_make_request(), takes bio, returns a request
[RFC 4/4] libosd: Use of new blk_make_request
  
  Here I propose a new block API, that will support proper delegation of a bio
  to a full request. Please read inside the patch descriptions for details.
  After this patch both osd and block layer will have the proper support for osdblk
  driver as well as future needs.
  These patches also eliminate the last use of blk_rq_append_bio which can be now un-exported.

  These two patches conflic with Tejun's branch and are based on linus-tip. Upon positive review
  I will serialize them with Tejun and submit them properly. But first they must be agreed upon.
  Jens, I specially need your opinion on this?

Cheers
Boaz

