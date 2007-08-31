From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 0/5] tgt: add target mode support to fc transport and
 qla2xxx
Date: Sat, 01 Sep 2007 02:02:03 +0900
Message-ID: <200708311702.l7VH238n015718@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:46967 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358AbXHaRC2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2007 13:02:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, James.Smart@Emulex.Com, andrew.vasquez@qlogic.com, hare@suse.de, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

This patchset adds target mode support to fc transport class and
qla2xxx driver. The pathset is against scsi-misc.

The target mode support for fc transport class works in the same way
as srp transport class. fc_remote_port_{rolechg,delete} calls
scsi_tgt_it_nexus_{create,destroy} for target drivers.

This patchset includes one major change to the mid layer. srp
initiator-mode drivers don't find initiator remote ports (i.e. it
finds only target ports) so srp transport class always creates tgt's
I_T nexus when it finds an initiator remoto port. However, both
initiator-mode and target-mode fc drivers find initiator remote ports
so fc transport class needs to know which mode the driver runs in (or
a driver can run in dual mode too). That is, fc transport class
creates tgt's I_T nexus only when target-mode-enabled drivers find an
initiator remote port.

To solve the above issue, the second patch adds supported_mode and
active_mode attributes to /sys/class/sys_host/hostX/ for specifying
the mode that a lld supports and the currently activated mode. The
supported_mode attribute looks at a scsi_host_template and the
active_mode attribute looks at a scsi_host. We would add a hook to a
scsi_host_template to change the active_mode attribute
dynamically. But now there is no hook since no lld supports that
feature.
