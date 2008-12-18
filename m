From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12163] mptsas driver cannot discover some hotplugged SATA/SAS disks
Date: Wed, 17 Dec 2008 20:31:24 -0800 (PST)
Message-ID: <20081218043124.3F698108041@picon.linux-foundation.org>
References: <bug-12163-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbYLREb5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2008 23:31:57 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBI4VOYI025784
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2008 20:31:25 -0800
In-Reply-To: <bug-12163-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12163


crquan@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |crquan@gmail.com




------- Comment #5 from crquan@gmail.com  2008-12-17 20:31 -------
This driver worked well in general situation,

1. use mptsas vendor driver 4.00.43 and this patch to let it work on 2.6.26.2;
2. all disks can be recognized when staticly booting or after hotplugged;

But today we found another severe hotplug problem:

Steps to reproduce:
1. use mdadm to create a soft RAID, e.g. create a md1 with level 5 on
sdm,sdn,sdo;
2. if plug the disks in a soft RAID, the disks(sdm,sdn,sdo) cannot be
recognized after inserted;
3. if these disks inserted into other slots, they can be recognized by mptsas;
4. if other disks inserted into these slots where (sdm,sdn,sdo) occupied, they
cannot be recognized, too.
5. At the same time, other disks not in the soft RAID still support hotplug
well;

To sum in one word, the slot which has been occupied by a disk in soft RAID
cannot support hotplug anymore (before rebooting).

I suspect this is a generic scsi-level problem, sometimes it reports
scsi_target alloc failed with -EEXIST;


Reproducible: always


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
