From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 0/2] Splitting sg chain allocation support from scsi
Date: Wed, 14 Nov 2007 12:46:20 +0100
Message-ID: <20071114114620.GA5064@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:25492 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbXKNLrX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2007 06:47:23 -0500
Received: from nelson.home.kernel.dk (nelson.home.kernel.dk [192.168.0.33])
	by kernel.dk (Postfix) with ESMTP id D4EAE2571E4
	for <linux-scsi@vger.kernel.org>; Wed, 14 Nov 2007 12:47:19 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Currently scsi_lib.c does its own sg chain allocation and freeing, as it
was proof of concept. But other drivers may want to take advantage of
that feature as well. These two patches add a lib/scatterlist.c and
moves most of the linux/scatterlist.h big include into that, and adds
helpers for allocating and initializing an sg list.

This adds a new kernel define SG_MAX_SINGLE_ALLOC that sets the boundary
for when sg_alloc_table() will return a chained list, that used to be a
scsi private thing.

The patch still needs a bit of cleaning up and documenting, but it's a
start. Boots and works here.

-- 
Jens Axboe

