From: Andrew Morton <akpm@osdl.org>
Subject: Fw: legacy megaraid driver bug in mm-series
Date: Wed, 7 Sep 2005 02:52:58 -0700
Message-ID: <20050907025258.35100c34.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19909 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932092AbVIGJyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 05:54:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Byer <ojbyer@usa.net>



Begin forwarded message:

Date: Mon, 05 Sep 2005 21:05:40 -0400
From: Jack Byer <ojbyer@usa.net>
To: linux-kernel@vger.kernel.org
Subject: legacy megaraid driver bug in mm-series


My AMI megaraid card no longer works with recent mm-series kernels. The
bug appears on mm- kernels newer than 2.6.12-rc6-mm1; mainline kernels
are not affected.

The driver will load and detect both devices on the card (sda and sdb).
It will scan each device and read the partition table successfully,
however the megaraid driver message will include the following errors:

sda: sector size 0 reported, assuming 512.
sda: asking for cache data failed.
sda: assuming drive cache: write through

When the kernel tries to mount the root file system, I get the following
error:

ReiserFS: sda3: warning: sh-2006: read_super_block: bread failed (dev
sda3, block 2, size 4096)
ReiserFS: sda3: warning: sh-2006: read_super_block: bread failed (dev
sda3, block 16, size 4096)
VFS: Cannot open root device "sda3" or unknown-block(0,3)

Here is a summary of the kernels I have tested for this bug:

2.6.11-mm1:	works
2.6.11-mm4:	works
2.6.12-rc5-mm1:	will not compile
2.6.12-rc6-mm1:	works
2.6.12-mm1:	will not compile megaraid driver
2.6.12-mm2:	broken
2.6.13-mm1:	broken

2.6.12:		works
2.6.13:		works

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
