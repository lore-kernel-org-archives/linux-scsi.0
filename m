From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC/RFT 0/4] convert st and sg to always use scatterlists
Date: Wed, 14 Sep 2005 17:19:40 -0500
Message-ID: <1126736380.16778.23.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:196 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030199AbVINWTn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 18:19:43 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8EMJf3w021619
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2005 17:19:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches convert sg and st to always use scatterlists. The
patches were made against scsi-rc-fixes, but I am not asking for them to
merged there as they need a lot of testing. The only thing that is not
supported is HighMem with st DIO (sg does not look like it supported
HighMem with DIO). You do get bounce buffer capabilities for all other
cases though so the upper layer drivers do not have to worry about some
queue limits.

These patches are not the great cleanups I had planned to do originally.
I have wanted to:
1. convert ULDs to always use scatterlists
2. cleanup scsi_request usage.
3. move the ULDs to use block layer functions for buffer creation and
copy_to_user or direct io functionality since they duplicate it in the
drivers.

The problem is that  sg and st do large requests by allocating a
contigous block of pages (they also will reserve these buffers). To
support this the patches allow them to continue to allocating their
large buffers then pass them to a block layer helper blk_rq_map_kern_iov
which adds the pages to bios, then if needed adds multiple bios to a
request. The reason for the mutliple bios code is becuase a bio is
limited by the queue limits but also the BIO_MAX_PAGES.

In the end, I would like to consolodate the sg and st's buffer/iovec
management code and convert them to use the block layer's
blk_rq_map_usr* functions (sg's mmap code would still have to use this
new blk_rq_map_kern_iov helper as far as I can tell so that function and
these patches are somewhat useful).

The sg patch has been lightly tested by running the sg_utils programs
over it. I need to do some more testing. I am posting becuase I am
not sure if this incremental update is better, or if you guys want
all the answers solved at once? With these patches, just cpqfc, gdth and
osst need to be cleaned up.

