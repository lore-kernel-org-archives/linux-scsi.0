From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: lots and lots of disks again
Date: Tue, 10 Feb 2004 21:10:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210211002.A1534@pclin040.win.tue.nl>
References: <20040204024512.5bf68428.akpm@osdl.org> <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210155203.A5238@infradead.org> <20040210160803.GL4010@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.tue.nl ([131.155.2.7]:39432 "EHLO mailhost.tue.nl")
	by vger.kernel.org with ESMTP id S265478AbUBJUKQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 15:10:16 -0500
Content-Disposition: inline
In-Reply-To: <20040210160803.GL4010@tpkurt.garloff.de>; from garloff@suse.de on Tue, Feb 10, 2004 at 05:08:03PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>

Kurt Garloff writes:

+/* Major / minor to disk mapping, from Matthew Wilcox, corrected
+ * (mail to linux-scsi@vger.kernel.org from 2003-10-16)
+ *
+ *       major     p2    disc2   disc  p1
+ *   |............|..|..........|....|....| <- dev_t
+ *    31        20    17       8 7  4 3  0
+ *
+ * We allow 64 partitions per disk, by adding two more bits.
+ * Inside a major, we have 16k disks, however mapped non-
+ * contiguously. The first 16 disks are for major0, the next
+ * ones with major1, ... Disk 256 is for major0 again, disk 272
+ * for major1, ...
+ * We can't currently use the partitions beyond 16, as the
+ * genhd infrastructure expects contiguous minors.
+ */

It is true that the first step needed is some agreement on
how to assign device numbers to disks and their partitions.

The above suggestion is really ugly, however.
I can hardly imagine that we would like to start such crap
while still in the design phase.

Andries
