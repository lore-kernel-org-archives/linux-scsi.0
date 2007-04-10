From: David Miller <davem@davemloft.net>
Subject: scsi_set_tag_type()
Date: Tue, 10 Apr 2007 00:30:11 -0700 (PDT)
Message-ID: <20070410.003011.48528785.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51129
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbXDJHaM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Apr 2007 03:30:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by sunset.davemloft.net (Postfix) with ESMTP id 6F39BAE41FD
	for <linux-scsi@vger.kernel.org>; Tue, 10 Apr 2007 00:30:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I don't believe this function behaves as some call sites intend.

For example, if the driver implements the ->change_queue_type()
method, and I say to use simple tags in sysfs, and sdev->ordered_tags
is already set, I am not going to get simple tags since
sdev->ordered_tags will stay set and scsi_get_tag_type() always
returns MSG_ORDERED_TAG when sdev->ordered_tags is set.

It's not "setting" the tag type, it's accumulating binary states
until "0" is given which clears them all.

Also, what is the thinking about what drivers should use as the
default tag type via these interfaces?  There appears to be a lot of
inconsistency here.  For example, unless overridden by the user, the
aic7xxx driver uses orderred tags by default.  On the other hand,
libsas uses simple tags by default.

Wouldn't we want to use simple tags by default to allow the target to
reorder tagged requests as much as possible?  Regardless of the
thinking, I don't think this policy does not belong in the drivers at
all.

I'm trying to figure out what I should do in a driver I'm hacking
on which is why I'm noticing all of this stuff :-)
