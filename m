From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 06 Oct 2003 14:21:23 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065471683.5185.52.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
	 <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2>
	 <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2>
	 <1065463946.5185.8.camel@patehci2>  <20031006182223.GF972@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:25079 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261664AbTJFUVd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 16:21:33 -0400
In-Reply-To: <20031006182223.GF972@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

> CDC_DVD_RAM ...
> the only thing the kernel supports out of the box.

Do we understand this choice?  I'm new to linux, new to t10 mmc, old to
unix, old to t10 scsi.  I think I see:

1) In mmc, seven of the standard profiles imply feature x0020
random_writable, specifically profiles x 0001 0002 0003 0005 0012 001A
0022 i.e. non_removable_disk, removable_disk, magneto_optical_erasable,
as_mo, dvd_ram, dvd+rw, ddcd_rw.

2) In sr_mod.ko and ide-cd.ko, we conservatively fetch only mode page
x2A Capabilities.  Specifically we do not yet try the op x46 Get
Configuration of 1999 mmc 2, not even after we see mode page x2A.

3) Omitting op x46 by definition precludes linux from distinguishing
from legacy cd_rom all the new writable kinds of pdt x05 dvd/cd,
excepting only the 1997 mmc 1 choices that /proc/sys/dev/cdrom already
offers i.e. cd_r, cd_rw, dvd, dvd_r, and dvd_ram.

How wrong am I?

Pat LaVarre


