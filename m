From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/2] bsg: ring buffer interface
Date: Tue, 06 Feb 2007 08:54:04 +0900
Message-ID: <20070206085404O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:42941 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbXBEXxU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 18:53:20 -0500
Received: from mfs3.rdh.ecl.ntt.co.jp (mfs3.rdh.ecl.ntt.co.jp [129.60.39.112])
	by tama5.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l15NrIWH019392
	for <linux-scsi@vger.kernel.org>; Tue, 6 Feb 2007 08:53:18 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp (nttmail3.ecl.ntt.co.jp [129.60.39.100])
	by mfs3.rdh.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l15NrIOZ011503
	for <linux-scsi@vger.kernel.org>; Tue, 6 Feb 2007 08:53:18 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l15NrIHV029603
	for <linux-scsi@vger.kernel.org>; Tue, 6 Feb 2007 08:53:18 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patchset adds a generic ring buffer interface and converts bsg to
use it.

The scsi target infrastructure invented its own mmap ring buffer
interface. It seems that kevent would use a slightly different ring
buffer interface. I think it would be nice to have common ring buffer
code rather than inventing another ring buffer interface for bsg.

I use a modified version of kevent's user interface
(sys_kevent_commit, sys_kevent_wait, etc). So we can send and receive
sg_io_v4 structures to/from kernel via new system calls while kevent
only receives ukevent structures from kernel.

kevent dropped the mmap ring buffer at take 23. The current version
uses a ring buffer that isn't shared between kernel and user space
(kernel simply does copy_from_user/to_user from/to a ring buffer in
user space). This is mainly because the mmap ring buffer leads to lots
of unswappable memory (and processes can create it freely). I adopted
the current kevent scheme because we could have tons of bsg devices
(means lots of unswappable memory). sg_io_v4 structures are larger than 
ukevent structures so we need to see the performance.

The patchset is for discussion not for inclusion. I'd like to remove
the scsi target's ring buffer code but the generic ring buffer scheme
might be over-designed stuff. Simple ring buffer interfaces like
producer/consumer pointers might be good enough for the block layer
and scsi-ml stuff. Or we could duplicate various ring buffer code
since the code is small.

It's against Jens' bsg tree and it's only lightly tested.
