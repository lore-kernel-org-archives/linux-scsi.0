From: Roland Dreier <rolandd@cisco.com>
Subject: I want scsi_target_block() in interrupt context
Date: Wed, 29 Jun 2005 10:27:40 -0700
Message-ID: <52fyv1dqer.fsf@topspin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:57705 "EHLO
	sj-iport-3.cisco.com") by vger.kernel.org with ESMTP
	id S262294AbVF2R1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2005 13:27:41 -0400
Received: from mira-sjc5-b.cisco.com (IDENT:mirapoint@mira-sjc5-b.cisco.com [171.71.163.14])
	by sj-core-1.cisco.com (8.12.10/8.12.6) with ESMTP id j5THRdvM002442
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2005 10:27:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm working on an implementation of SCSI RDMA Protocol (SRP) on
InfiniBand, and I'm running into an issue managing the number of
commands that get queued.

The setup is like this: each SRP scsi_host can connect to multiple
target ports.  Each target port can have multiple LUNs behind it.  To
support this, for each connection, I create a device, set its parent
to the scsi_host's shost_gendev, and then call scsi_scan_target to
discover the LUNs behind the target port.

This mostly works fine, except the number of outstanding commands is
limited per connection.  This doesn't fit that well with the Linux
SCSI stack -- can_queue for the scsi_host doesn't work, since a single
scsi_host can have multiple connections, and cmd_per_lun doesn't work
since a single connection can have many LUNs.

What seems like it _would_ be exactly what I need would be calling
scsi_target_block() on the device representing the connection.
Unfortunately, scsi_target_block() uses all sorts of device model
stuff that takes semaphores and hence potentially sleeps.  This means
that I can't block a connection while holding a lock to prevent races.

So I don't see a race-free way I can ensure that I never queue up too
many commands on a given connection.

Any advice?

Thanks a lot,
  Roland
