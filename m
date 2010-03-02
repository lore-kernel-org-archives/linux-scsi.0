From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: bug report: sd:  off by one in sd_read_block_limits()
Date: Tue, 02 Mar 2010 08:36:35 -0500
Message-ID: <yq1fx4i26cc.fsf@sermon.lab.mkp.net>
References: <20100302082135.GA6218@bicker>
	<yq1tysy27ft.fsf@sermon.lab.mkp.net>
	<yq1k4tu2716.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:64740 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0CBNit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2010 08:38:49 -0500
In-Reply-To: <yq1k4tu2716.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Tue, 02 Mar 2010 08:21:41 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Dan Carpenter <error27@gmail.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


James,

While I agree the original VPD code's double kmalloc() was a bit of a
wart at least it did the right thing because it allocated a suitably
sized buffer for page 0.

My concern with the interface you introduced in e3deec09 is that for
devices that support a large number of VPD pages we won't be able to fit
the page list in the allocated buffer.  And callers are likely to pick a
buffer size that makes sense for the VPD page they are interested in.
It's not a big deal in the block limits/block device characteristics
case because they are big enough.

But at the very minimum that interface should come with a big fat
warning in the comment section that describes that the page list must
also be able to fit.

-- 
Martin K. Petersen	Oracle Linux Engineering
