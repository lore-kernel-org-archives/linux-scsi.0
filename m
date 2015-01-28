From: Nate Dailey <nate.dailey@stratus.com>
Subject: raid1 narrow_write_error with 4K disks, sd "bad block number requested"
 messages
Date: Wed, 28 Jan 2015 10:29:46 -0500
Message-ID: <54C9006A.2030807@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o148.mxlogic.net ([208.65.145.81]:50823 "EHLO
	p02c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760664AbbA2JTg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 04:19:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

I'm writing about something that appears to be an issue with raid1's 
narrow_write_error, particular to non-512-byte-sector disks. Here's what 
I'm doing:

- 2 disk raid1, 4K disks, each connected to a different SAS HBA
- mount a filesystem on the raid1, run a test that writes to it
- remove one of the SAS HBAs (echo 1 > 
/sys/bus/pci/devices/0000\:45\:00.0/remove)

At this point, writes fail and narrow_write_error breaks them up and 
retries, one sector at a time. But these are 512-byte sectors, and sd 
doesn't like it:

[ 2645.310517] sd 3:0:1:0: [sde] Bad block number requested
[ 2645.310610] sd 3:0:1:0: [sde] Bad block number requested
[ 2645.310690] sd 3:0:1:0: [sde] Bad block number requested
...

There appears to be no real harm done, but there can be a huge number of 
these messages in the log.

I can avoid this by disabling bad block tracking, but it looks like 
maybe the superblock's bblog_shift is intended to address this exact 
issue. However, I don't see a way to change it. Presumably this is 
something mdadm should be setting up? I don't see bblog_shift ever set 
to anything other than 0.

This is on a RHEL 7.1 kernel, version 3.10.0-221.el7. I took a look at 
upstream sd and md changes and nothing jumps out at me that would have 
affected this (but I have not tested to see if the bad block messages do 
or do not happen on an upstream kernel).

I'd appreciate any advice re: how to handle this. Thanks!

Nate Dailey
Stratus Technologies

