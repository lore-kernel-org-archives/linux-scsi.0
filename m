From: Hans de Goede <hdegoede@redhat.com>
Subject: [REGRESSION 3.17] scsi (uas) disks no longer using tagged command
 queuing
Date: Tue, 09 Sep 2014 11:15:24 +0200
Message-ID: <540EC52C.3000804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbaIIJP1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2014 05:15:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi All,

While working on making error handling in the uas driver more robust,
I noticed that all the commands being send to a sata ssd hooked up
over uas were untagged, where I would expect tcq to be used, as that
is the big advantage of uas over usb-storage / bot.

Taking the uas.c file from 3.17, and building it for 3.16 restores
the use of tcq (debugged by adding a printk blk_rq_tagged + request->tag).

So either uas is doing something wrong which happened to work in
3.16, or something has broken in 3.17.

I've already added debug printk-s of scsi_device->tagged_supported,
queue_depth, ordered_tags and simple_tags and those all look good
(1, 29, 1, 1).

I've also tried setting disable_blk_mq and that does not help.

Any hints to help debugging this further (other then a bisect) are
appreciated. If no-one has any smart ideas I guess I'll end up doing
a full bisect.

Regards,

Hans
