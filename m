From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] add SMP passthrough support via bsg
Date: Mon, 09 Jul 2007 12:52:03 +0900
Message-ID: <20070709125203F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:60502 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723AbXGIDwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jul 2007 23:52:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, Eric.Moore@lsi.com, jens.axboe@oracle.com

This is an updated version of the patchset to add SMP passthrough
support via bsg:

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg06350.html

- I added mptsas support

- I updated the patch for libsas to use the new block-layer bidi
support (the previous version uses sense buffer for bidi hacky). The
change is trivial.

This patchset can be applied cleanly to scsi-misc and the latest
Linus' tree (2.6.23) however it depends on bsg and the block-layer
bidi patcheset.

I setup a tree based on 2.6.23 including bsg, the block-layer bidi,
and this patchest:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git smp

You also need my makeshift bsg tool:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/sgv4-tools.git


Here's an example:

nice:/home/fujita# ls  /sys/class/bsg/
end_device-0:0  end_device-0:1  sas_host0  sda  sdb

nice:/home/fujita# ./sgv4-tools/smp_rep_manufacturer /sys/class/bsg/sas_host0
  SAS-1.1 format: 0
  vendor identification: LSI
  product identification: Virtual SMP Port
  product revision level:


I've not tested this with aic94xx or expanders since I don't have the
hardware.
