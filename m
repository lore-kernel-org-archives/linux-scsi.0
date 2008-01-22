From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 0/3] update bidirectional series to sit on top of
 sg_table
Date: Wed, 23 Jan 2008 01:31:58 +0900
Message-ID: <20080123012913Z.tomof@acm.org>
References: <1200107340.3286.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:58048 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbYAVQfd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 11:35:33 -0500
In-Reply-To: <1200107340.3286.79.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, dougg@torque.net
Cc: bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Jens.Axboe@oracle.comfujita.tomonori@lab.ntt.co.jp

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 0/3] update bidirectional series to sit on top of sg_table
Date: Fri, 11 Jan 2008 21:09:00 -0600

> OK, I suppose in the scheme of things, it's my turn to bear some of the
> pain.  the SCSI bidirectional series rejects pretty badly with sg_table,
> and since sg_table has to go in, I rebased the series on top of it.
> 
> Additionally, I tidied up the patches to take advantages of some of the
> features of sg_table.  I killed both use_sg and sg_count in favour of
> using sg_table.nseg for the count.
> 
> Just so you can test all of this to make sure I got it right, you can
> pull the patch series from
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-bidi-2.6.git

I've just started to look at the bidi tree.

I suppose that only panasas guys have tested the bidi tree with their
OSD target devices. To test the bidi tree, I added XDWRITEREAD_10
support to scsi_debug and sgv4_xdwriteread tool to my makeshift bsg
tool collections:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/sgv4-tools.git

It just sends XDWRITEREAD_10 commands like this:

tulip:~# sgv4_xdwriteread --length 16384 /sys/class/bsg/1:0:0:0
driver:0, transport:0, device:0, din_resid: 0, dout_resid: 0

No errors.

I'll send the patchset (over the bidi tree) to add XDWRITEREAD_10
support to scsi_debug though I'm not sure whether it's worth adding it
to mainline.
