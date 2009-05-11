From: Thomas Horsten <thomas@horsten.com>
Subject: MegaRAID issue with multiple logical drives with separate I/O queues
Date: Mon, 11 May 2009 13:48:39 +0100
Message-ID: <5d932cdc0905110548w77aee181o2071e28aca588756@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37256 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbZEKMsk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2009 08:48:40 -0400
Received: by fxm2 with SMTP id 2so2642344fxm.37
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2009 05:48:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a server with a MegaRAID SATA 300-8X. The controller has 5*1TB
drives attached.

Previously I had 5*250GB drives on the controller all configured as a
single logical RAID5 drive. But the controller only supports up to 2TB
logical drives so after upgrading I had to configure 3 logical drives
(sda, sdb, sdc) in order to make use of all the space. These are in
turn configured into logical volumes with LVM.

However, the performance seems to suffer very badly when accessing
several of the logical drives concurrently.

I'm guessing that this is because the IO scheduler maintains separate
queues for each of the drives and assumes they can be accessed in
parallel, causing lots of inefficient seeks across the array,
degrading performance (and potentially wearing out the disks faster)
int he process. Switching the IO scheduler to noop seems to help a
little but by no means cures the issue.

I wonder if it would be possible/desirable to somehow force all the
logical drives to share the same I/O queue. Has this been done before
for any other drivers? And is it even the right approach to resolve
this issue?

Although don't have much experience with SCSI drivers I would be happy
to try to work on a solution if someone with knowledge of the LSI
driver could offer me guidance. I'm not sure where it should be done,
either in the MegaRAID driver itself, by exposing the logical drives
as one joint SCSI drive to the kernel - or a more generic solution at
a higher level by somehow joining the drives with a kind of
master/slave setting using the /sys interface (e.g.: echo sda >
/sys/block/sdb/master, telling the kernel that sdb is in fact a part
of the same disk as sda and thus should share it's I/O queue etc.).

I would welcome any insights in this matter.

Best regards,
Thomas
