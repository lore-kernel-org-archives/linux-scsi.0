From: Bart Van Assche <bvanassche@acm.org>
Subject: sysfs attributes of SCSI hosts
Date: Sun, 28 Aug 2011 15:08:23 +0200
Message-ID: <CAO+b5-q=yyuoeBCZFzpTDWpsr8KGQQDJ-B3s6X68=BoDD1=2Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41618 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1H1NIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2011 09:08:44 -0400
Received: by vws1 with SMTP id 1so4014416vws.19
        for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2011 06:08:43 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

Recently I had a closer look at how SCSI host sysfs attributes are
created. As far as I can see the attributes that apply to all SCSI
hosts are declared in the scsi_sdev_attrs array in
drivers/scsi_sysfs.c (device_blocked, type, scsi_level, vendor, model,
...). These are created by the driver core before the KOBJ_ADD event
is generated. However, the driver-specific attributes defined in
scsi_host_template.shost_attrs are instantiated by the
scsi_sysfs_add_sdev() function by invoking device_create_file() after
the KOBJ_ADD event has been generated.

A popular way to set default values for sysfs attributes is by
defining a udev rule that sets the proper value. As an example, years
ago the following rules were present in 50-udev-default.rules:

SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*",ACTION=="add",
ATTR{type}=="0|7|14", ATTR{timeout}="60"
SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*",ACTION=="add",
ATTR{type}=="1", ATTR{timeout}="900"

Does that mean that udev rules similar to the above will work for
setting the value of the default SCSI host attributes but that any
attempt to use a similar rule for any attribute defined via
shost_attrs is racy ? Has anyone been looking into this before ?

Thanks,

Bart.
