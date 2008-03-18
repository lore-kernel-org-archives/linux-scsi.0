From: Bill Nottingham <notting@redhat.com>
Subject: race between SCSI uevents and media detection
Date: Tue, 18 Mar 2008 13:21:13 -0400
Message-ID: <20080318172113.GB3089@nostromo.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbYCSVgm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 17:36:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org

For a typical livecd boot using udev, you'd check for the root device
with a udev rule like:

KERNEL=="sr[0-9]", PROGRAM=="/lib/udev/vol_id -l %N", RESULT="<some label>",
	SYMLINK+="root"

This creates a /dev/root symlink to whichever CD device holds the proper
CD/DVD.

However, this currently fails repeatedly on some machines, as the run
of vol_id gets ENOMEDIUM attempting to open the CD device. I suspect
this is because the initial medium scan is actually done after the
uevent for /dev/sr0 is emitted.

Can the open path be fixed to block until the medium state is initially
known? I don't see how this can be worked around from userspace - you
don't get another uevent for the media detection.

Bill
