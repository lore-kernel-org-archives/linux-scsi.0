From: Alan Stern <stern@rowland.harvard.edu>
Subject: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 14 Jun 2005 17:27:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506141714530.4698-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:3987 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261343AbVFNV1W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 17:27:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

Can you or anyone else please explain what scsi_target_reap() and
especially what scsi_target.reap_ref are for?  What's the point of this
home-brewed reference counting scheme when there's already a perfectly
useful embedded struct device inside scsi_target?  Why isn't
scsi_target_reap() simply the release routine for the embedded device?

In addition, can someone please explain how long a scsi_target structure 
and a scsi_device structure are supposed to remain linked into the host's 
__targets and __devices lists once they have been removed?  The 
scsi_device link isn't severed until the release routine runs, which can 
be quite a long time after the device has been removed.  The scsi_target 
link is severed in scsi_target_reap(), which should be thought of as a
kind of release routine as well.

Won't this cause trouble in a hotplug environment?  A target or a LUN can 
be removed, and while it's still on the host's list a new target or LUN 
could be discovered with the same ID.  Having multiple entries on a list 
with the same ID sounds like a bad idea.  Is there some reason why these 
things aren't taken off their list as soon as they are removed?

Alan Stern

