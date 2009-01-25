From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH version2] bsg: Add support for submitting requests at
 tail of queue
Date: Sun, 25 Jan 2009 11:44:21 +0200
Message-ID: <497C3475.1060907@panasas.com>
References: <4976F067.8000501@panasas.com> <497C33D8.1060802@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:28755 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbZAYJoY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jan 2009 04:44:24 -0500
In-Reply-To: <497C33D8.1060802@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Boaz Harrosh wrote:
> Currently inherited from sg.c bsg will submit asynchronous request
> at the head-of-the-queue, (using "at_head" set in the call to
> blk_execute_rq_nowait()). This is bad in situation where the queues
> are full but requests need to execute in order. Failing to do that can
> cause the first submitted commands to never execute.
> 
> The sg_io_v4->flags member is used and a bit is allocated to denote the
> Q_AT_TAIL. Zero is to queue at_head as before, to be compatible with old
> code at the write/read path. SG_IO code path behavior was changed so to
> be the same as write/read behavior. SG_IO was very rarely used and breaking
> compatibility with it is OK at this stage.
> 
> sg_io_hdr at sg.h also has a flags member and uses 3 bits from the first
> nibble and one bit from the last nibble. Even though none of these bits
> are supported by bsg, The second nibble is allocated for use by bsg. Just
> in case.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> CC: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  block/bsg.c         |    9 +++++++--
>  include/linux/bsg.h |    8 ++++++++
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 

Sorrrrrrry bad patch, teach me to never send a patch in the morning
before coffee.

Will send a version 3
Boaz
