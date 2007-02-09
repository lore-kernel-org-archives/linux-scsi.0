From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/2] convert sg to use block layer helpers
Date: Fri, 09 Feb 2007 03:34:23 -0500
Message-ID: <1171010063.3713.26.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35460 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946264AbXBIJew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 04:34:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, dougg@torque.net, linux-scsi@vger.kernel.org

sg duplicates a lot of block layer dio and copying code. The block layer
is missing some things like mmap helpers and a way to support sg and
st's reserve buffer. The next two patches move move functionality from
sg to the block layer so later st and osst can use it, and then coverts
sg to use the block layer helper.

The goal is to kill scsi_execute_async and friends and covert the ULDs
to use the block layer functions directly. This is nice because
scsi_execute_async sucks and it actually duplicates block layer code,
and in the end the scsi layer does not have to do any bio processing
(which irks Jens :)), and we have common code for all ULDs.

The patches were made over Jens's bsg branch in his block layer git tree
on kernel.org. Sorry for the large patches. The sg conversion patch rips
out alot of code duplicated in the block layer and the patch to add some
missing functionality to the block layer has conversions to bsg, tgt,
etc so git bisect works on it.

