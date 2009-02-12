From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFD] blk_rq_map_pages new API
Date: Thu, 12 Feb 2009 10:28:10 +0200
Message-ID: <4993DD9A.6070701@panasas.com>
References: <20090212010454J.fujita.tomonori@lab.ntt.co.jp>	<1234369838.3295.31.camel@localhost.localdomain>	<49931113.3090701@panasas.com> <20090212103112M.fujita.tomonori@lab.ntt.co.jp> <4993DCCA.8080508@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:4272 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751873AbZBLI2O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 03:28:14 -0500
In-Reply-To: <4993DCCA.8080508@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org


/**
 * blk_rq_map_pages - Receives an array of pages and appends them to a request structure 
 *
 * @rq:  The request to map
 * @pages_info: A structure that specifies the array of pages, offset and more that need to be
 *              map to the request. the @pages_info->null_mapped is assumed to be 1 and is ignored.
 * @length: Total bytes to map. Array of pages can be larger, stop mapping after @length bytes mapped.
 * @max_pages: When allocating the internal bio use @max_pages as an hint that says the amount of anticipated
 *             pages that will be mapped. This member is optional and can be zero.
 * 
 * blk_rq_map_pages can be called multiple times so the user does not need to allocate a contiguous array
 * of struct page pointers but can call this routine multiple times. In that case max_pages can be set
 * so no bio re-allocation occurs.
 * There is no unmap function for this mapping, the request is completed in the regular way.
 */

int blk_rq_map_pages(struct request rq, struct *rq_map_data pages_info, unsigned length, unsigned max_pages);


Implementation comments:
- Then when this member is available many places that call blk_rq_map_user() rq_map_data and null_mapped set,
  and buff == NULL, can be converted to this member.

- Internal block implementation is refactored to not duplicate any code with blk_rq_map_user().

Thanks for any comments
Boaz

