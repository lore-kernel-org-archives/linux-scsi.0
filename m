From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large
 IO sg-chaining
Date: Tue, 24 Jul 2007 18:16:35 +0900
Message-ID: <20070724181635G.fujita.tomonori@lab.ntt.co.jp>
References: <46A5BCB6.9050102@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:48248 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191AbXGXJRx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 05:17:53 -0400
In-Reply-To: <46A5BCB6.9050102@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO sg-chaining
Date: Tue, 24 Jul 2007 11:47:50 +0300

> As Jens said, there is nothing common to scsi_sgtable and 
> sglists. Save the fact that it is a massive conflict at 
> scsi-ml. They touch all the same places.
> 
> Proposed is a simple way out. Two patchsets That produce the
> same output at the end.
> 
> One: scsi_sgtable_than_sg-chaining
> Two: sg-chaining_than_scsi_sgtable

Hmm, I thought that I've already posted a scsi_sgtable patch working
with sg-chaining together.

http://marc.info/?l=linux-scsi&m=118519987632758&w=2

I quoted from my mail:

---
I think that the main issue of integrating sgtable and sglist is how
to put scatterlist to scsi_sgtable structure.

If we allocate a scsi_sgtable structure and sglists separately, the
code is pretty simple. But probably it's not the best way from the
perspective of performance.

If we put sglists into the scsi_sgtable structure (like Boaz's patch
does) and allocate and chain sglists only for large I/Os, we would
have the better performance (especially for small I/Os). But we will
have more complicated code.
---

>From a quick look over your patchset, you chose the latter. And my
patch uses the former.
