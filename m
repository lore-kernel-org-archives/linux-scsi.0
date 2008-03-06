From: Kay Sievers <kay.sievers@novell.com>
Subject: media change events for polled devices broken with current
	sdev_evt_send()
Date: Thu, 06 Mar 2008 10:29:22 +0100
Message-ID: <1204795762.3136.27.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:59432 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755824AbYCFJ2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 04:28:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: kristen accardi <kaccardi@gmail.com>, scsi <linux-scsi@vger.kernel.org>

Hi Jeff,
  a341cd0f (SCSI: add asynchronous event notification API)
introduces an event filter like:
  +       if (!test_bit(evt->evt_type, sdev->supported_events)) {
  +               kfree(evt);
  +               return;
  +       }

which breaks:
  285e9670 (sr,sd: send media state change modification events)

Why are events sent through sdev_evt_send() filtered? In which case does
code send an event which we don't want to deliver?


Side note: introduced with a341cd0f is the sysfs file:
"evt_media_change", which has a store() method, but has the permission
0444. It should either have no store() method assigned, by introducing
something like DECLARE_EVT_RO(), or the file permission should be
changed to 0644.

Thanks,
Kay

