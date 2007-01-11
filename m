From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: IO transfer limits
Date: Thu, 11 Jan 2007 10:23:44 -0800
Message-ID: <1168539824.2983.11.camel@mulgrave.il.steeleye.com>
References: <8260533.post@talk.nabble.com> <45A53290.1060400@torque.net>
	 <8268682.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36691 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751349AbXAKSXr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 13:23:47 -0500
In-Reply-To: <8268682.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: john clyne <clyne@ucar.edu>
Cc: linux-scsi@vger.kernel.org

On Wed, 2007-01-10 at 15:07 -0800, john clyne wrote:
> So given that the HBA max_sectors_kb looks sufficiently large, my
> interpretation of your article is the next place I need to look is at
> ajusting SCSI_MAX_PHYS_SEGMENTS. Sounds like i can only increase this to
> 256. Does that than give me a max transfer size of 256 * page_size (4k) =
> 1MB? Is 1MB the limit or am I missing something?

Well ... that's not the maximum possible ... just the maximum number of
SG elements.  If the buffer is completely fragmented in physical memory,
then it will be 1MB ... however, linux does a reasonable job of getting
physically contiguous pages into a large memory allocation, so you could
get transfers that are larger than the 1MB limit by quite a way.  And,
of course, any system that has a larger page size or uses an iommu will
go over this 1MB as well.

Jmaes


