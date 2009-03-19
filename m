From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFD] [PATCHSETS 0/2 0/2 0/5] Remove of blk_rq_append_bio usage
Date: Thu, 19 Mar 2009 16:21:49 +0200
Message-ID: <49C254FD.7020202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:6472 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834AbZCSOXE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:23:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scs

Hi all

In an effort to remove blk_rq_append_bio() and only use well published
block API, I would like to propose the below solution for OSD and exofs.

Current discussion has two sides:
* blk_make_request():
   exofs and other non-block-based filesystems can use a bio, in which
   case a well established block API should allow of allocating a request
   given a bio.

* blk_rq_map_pages():
   Let filesystems submit an array of page-pointers, and refrain from using
   bio(s). bio(s) is a privilege of block-based filesystems only.

The first solution is trivial, robust, safe with minimum changes and impact.
It will allow any future directions easily.

I have also implemented a second approach with the use of a new
blk_rq_map_pages. It works, all exofs tests pass successfully just
as with today's code. But I hate it because:
* Jeff Garzik is working on a block-over-osd-object block-device.
  I'm not sure of his plans, but sitting under block-layer at it's
  prepare_fn routine, the most trivial solution is to pass the bio
  as is to libosd. Otherwise he will need to copy and recopy all these
  pages information.
  Jeff please comment.
* Use of the in-kernel raid engines.
  Current dm-raid engines are heavily bio based. If we want to tap into-that
  (And we must) from exofs and pNFS-objects-layout we have no choice but to
  use bio(s) and be able to submit bios.
* For any none trivial usage, even today. bio is more stable, robust
  faster. and less code since it is already there.

Here is some code:
[PATCHSET 0/2] Allow append of kernel pointers to request
    [PATCH 1/4] allow blk_rq_map_kern to append to requests
    [PATCH 2/4] libosd: Use new blk_rq_map_kern

    These two patches are not disputable and safe and should go in as is
    even to 2.6.30. They remove one usage of blk_rq_append_bio from the
    osd_initiator.

[PROPOSAL_1 0/2] blk_make_request()
    [PATCH 3/4] [RFC] Export new blk_make_request() which takes bio and returns request
    [PATCH 4/4] libosd: Use of new blk_make_request

    This is option one above. Trivial, cosmetic, no core changes.

[PROPOSAL_2 0/5] blk_rq_map_pages()
    [RFC 1/5] blk_rq_map_pages() new API                                        
    [RFC 2/5] libosd: Rename osd_req_write/read to osd_req_write/read_old       
    [RFC 3/5] libosd: No bio for you
    [RFC 4/5] exofs: No bio for you
    [RFC 5/5] libosd: Remove deprecated bio based API

    This is option two above. Needs lots of core changes to exofs.
    After patch 5/5 code runs well, all tests pass. There is 
    runtime bisectability problem, the exofs will not run between
    [3/5]-[4/5].

Please advise
Boaz
