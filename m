From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 0/3] convert IOMMUs to use iova
Date: Sat, 3 Nov 2007 02:05:39 +0900
Message-ID: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60990 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757806AbXKBRHW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Nov 2007 13:07:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, jeff@garzik.org, anil.s.keshavamurthy@intel.com, muli@il.ibm.com, paulus@samba.org, anton@samba.org, olof@lixom.net, tony.luck@intel.com, davem@davemloft.net, kyle@parisc-linux.org, fujita.tomonori@lab.ntt.co.jp

This patchset convert the PPC64 IOMMU to use the iova code for free
area management.

The IOMMUs ignores low level drivers' restrictions, the maximum
segment size and segment boundary.

I fixed the former:

http://thread.gmane.org/gmane.linux.scsi/35602

The latter makes the free area management complicated. I'd like to
convert IOMMUs to use the iova code (that intel-iommu introduced) for
free area management and enable iova to handle segment boundary
restrictions, rather than fixing all the IOMMUs' free area management,

I converted the PPC64 IOMMU to see how things work. The patchset was
slightly tested with a pSeries box and seems to work.

This is against the latest Linus' git tree with David Miller's
genericizing iova patch:

http://www.ussg.iu.edu/hypermail/linux/kernel/0710.2/2910.html

This patchset is also available:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git iova
