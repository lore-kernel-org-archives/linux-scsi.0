From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: swiotlb default size (64 MB) too small?
Date: Wed, 21 Jan 2009 07:44:02 +0900
Message-ID: <20090121074339N.fujita.tomonori@lab.ntt.co.jp>
References: <49762FC8.7000208@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35934 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbZATWoa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2009 17:44:30 -0500
In-Reply-To: <49762FC8.7000208@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 20 Jan 2009 21:10:48 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> somebody reported frequent "Out of SW-IOMMU space" failures when copying
> between a FireWire and a USB disk.  swiotlb=512M on the kernel command
> line fixes it for him. https://bugzilla.redhat.com/show_bug.cgi?id=478567
> 
> Should the default be raised?

I don't think so. Reserving large memory like 512MB for swiotlb? It
means that you waste 512MB if you use decent HBAs (having no dma mask
limit) or fast storage, or when there is few I/O activity.

The bug reporter said that copying stooped but it should not
happen. It doesn't happen with SCSI (copying can continue a bit
slowly). dma mapping errors are transient so SCSI retries.

I guess that it would be better to remove the misleading error
message. Sane IOMMUs don't do that.

If the bug report is true, then the FireWire stack or the driver (or
both) has problems. Make sure that FireWire can work even with dma
mapping failures. My dma mapping debug patchset might be useful:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git dmafault

You can inject dma mapping failures per device:

vine:/debug/pci/0000:00:1d.1# ls
interval  probability  space  task-filter  times  verbose
