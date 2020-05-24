Return-Path: <SRS0=1EFY=7G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A26C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 601132086A
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387701AbgEXP60 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 May 2020 11:58:26 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43412 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387625AbgEXP6Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 May 2020 11:58:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B44BE20425A;
        Sun, 24 May 2020 17:58:23 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3ZHTnB5Ie3Wq; Sun, 24 May 2020 17:58:17 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id BF473204165;
        Sun, 24 May 2020 17:58:16 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC v2 0/6] scsi: rework mid-layer with xarrays
Date:   Sun, 24 May 2020 11:58:08 -0400
Message-Id: <20200524155814.5895-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI subsystem uses a "hctl" topological tuple that stands for
"host,channel,target,lun". It implies that the SCSI mid-layer (or
mid-level) has a four level (inverted) object tree, or five level if
the root and leaf levels are both counted. Actually it is implemented
as a three level object tree in which the channel level is merged into
the target level.

The leaf level of the object tree (i.e. the "lun" part of the tuple)
derives its name from SCSI Logical Units (LUs) identified by LU Numbers
(LUNs). For historical reasons Linux terms LUs as "devices" and the
corresponding object in the subsystem's API is of type struct
scsi_device. Somewhat confusingly Linux also terms the host as a
"device". LUs are typically block storage while SCSI hosts are usually
associated with Host Bus Adapters (HBAs). To complete the confusion
in SCSI terminology the target is known as a "device". 

This series replaces the doubly linked lists that bind together the SCSI
subsystem's object tree with xarrays. At the top of that object tree is
an idr/ida virtual array which holds a collection of SCSI hosts that are
active in the system. The idr/ida implementation already uses xarrays,
so the collection of SCSI hosts is not altered by this patchset.

Each SCSI host object (shost) holds two collections: one of scsi_target
objects (starg(s)), the other of scsi_device objects (sdev(s)). That
second collection is technically redundant since each starg has a
collection of sdevs. Currently these three collections are implemented
using doubly linked lists (see: include/linux/list.h). This patchset
replaces those linked lists collections with xarrays. That replacement
is done in the first patch. In the remaining 5 patches, some advantage
is taken of xarray features. Also some inefficient iterations are
reworked.


Why xarrays?
------------
  - xarrays have built-in locking: spinlocks for modifying operations
    and rcu (locks) for non-modifying operations. With list_head you
    are on your own.
  - the name xarray suggests O(1) indexing (but it isn't that fast) and
    feels like it should be faster than doubly linked lists. [And
    xarrays are not true arrays, they just have a similar interface.]
  - struct list_head seems too clever. Looking at a group of related
    structures used to build an object tree (e.g. struct scsi_target,
    it is difficult to distinguish the collections from the elements of
    a collection. There are just lots of:
        struct list_head <name_obscures_whether_collector_or_collectee>;
  - struct list_head evenly distributes its storage overhead between the
    collection holder and the elements of a collection: 2 pointers each,
    16 bytes on 64 bit machines. xarray imposes an overhead on the
    collection holder but a smaller overhead on its elements, perhaps we
    can restrict it to 2 bytes: [0..USHRT_MAX]? Failing that, a 4 byte
    overhead per element.
  - linked lists don't scale very well on multi-core machines
  - any decisions that can be made on the basis of xarray marks is a
    cache(line) win, as there is no need to pull in the corresponding
    element (e.g. see: SCSI_XA_NON_SDEV_DEL)
  - xarray is well instrumented and will warn (once) at run time if it
    doesn't like what it finds with regard to locking.

At several points in the code changes are comments starting with
"XARRAY: ". These are typically where list manipulations have been
changed out for xarray operations. There might be subtle changes in
semantics (e.g. if an addition racing with a deletion is permitted).

Locking
-------
xarrays have inbuilt locking. Since the collection is held in the
parent, they are inherently safer than doubly linked lists. Lists can
crash within an iteration if either the current or next element is
deleted. As long as the parent doesn't get deleted, then a xarray
iteration will produce a pointer (or NULL) without crashing. The rcu
lock on the xarray iteration guarantees that. Dereferencing that
pointer is where the fun begins (i.e. it may crash). The caller may
know that (scsi_device) object must exist because it holds a reference
to it.

This patchset does _not_ weaken the existing locking structures in the
SCSI mid-layer. It just adds another locking layer underneath it. So it
is "over-locked" especially on modifying operations.

Performance
===========
It is a real struggle to measure anything meaningful on the creation and
deletion side. The problem is systemd and udev which conspire to show
the tester that they own 99.9% of all available cores during major
disruptions (e.g. adding 6000 SCSI devices). Using mask and stop on
systemd-udevd and systemd-journald helps (but they must be unmasked
before a reboot otherwise problems will follow).

It is hard to beat a linked list when iterating through a collection.
A possible win is on the lookup side, if that is required (and it may
not be). A xarray could be maintained in ascending order so a binary
search could be done (e.g. order shost->__targets with the channel
combined with target_id).


Douglas Gilbert (6):
  scsi: xarray hctl
  scsi: xarray, iterations on scsi_target
  scsi: xarray mark sdev_del state
  scsi: improve scsi_device_lookup
  scsi: add __scsi_target_lookup
  scsi: count number of targets

 drivers/scsi/hosts.c               |   8 +-
 drivers/scsi/scsi.c                | 194 +++++++++++++++++++++++------
 drivers/scsi/scsi_error.c          |  34 ++---
 drivers/scsi/scsi_lib.c            |  38 +++++-
 drivers/scsi/scsi_scan.c           |  70 +++++++----
 drivers/scsi/scsi_sysfs.c          |  56 ++++++---
 drivers/target/target_core_pscsi.c |   2 +-
 include/scsi/scsi_device.h         | 148 ++++++++++++++++++++--
 include/scsi/scsi_host.h           |  15 ++-
 include/scsi/scsi_transport.h      |   3 +-
 10 files changed, 448 insertions(+), 120 deletions(-)

-- 
2.25.1

