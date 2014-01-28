From: Dan Williams <dan.j.williams@intel.com>
Subject: [LSF/MM TOPIC][ATTEND] Plumbing I/O Cache / Tiered Storage Hints
Date: Tue, 28 Jan 2014 14:57:01 -0800
Message-ID: <CAPcyv4hLT8GfueboyOwi5Rf+A++RmJU3LrmV4ZePTbSzfZf0rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:44109 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaA1W5D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jan 2014 17:57:03 -0500
Received: by mail-ve0-f180.google.com with SMTP id db12so721122veb.11
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2014 14:57:01 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: dm-devel@redhat.com, linux-bcache@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jason B Akers <jason.b.akers@intel.com>

In addition to disk drives with internally tiered-storage (solid-state
+ magnetic media) the kernel has also grown native I/O-caching /
tiered-storage implementations in bcache and dm-cache.

Currently, all these solutions depend on heuristics to determine what
tier the data referenced in an I/O belongs.  However, the presence of
hinting proposals from SCSI [1], ATA [2], and bcache [3] indicate that
these devices (hardware or virtual) want to consume explicit hints
indicating the value of caching data in a higher performing tier.

At LSF I want to discuss options and opportunities for plumbing cache
hints from userspace, through the I/O stack to devices.  My colleague,
Jason Akers, is also interested in this discussion as he is
investigating how to exploit these hints from userspace.  I
participated in the LSF 2012 discussion of this topic, see that it was
raised again at LSF 2013, and note that we have not settled on an
enabling path.  What's new for this year is an effort to set aside,
for now, the deeper complexities of the device specification proposals
and focus on a minimal set of hints that can be specified per-process
(ionice) and maybe per-file (fadvise).

My suspicion is that AIO attributes is useful for applications that
want access to the full range of access hints exposed by a device.
However, for the general buffered-I/O / tiered-storage case, a small
set of hints achieves the bulk of the value.

I am also interested in:
Volatile ranges
SMR Enabling
Integrity passthrough

--
Dan

[1] T10 LBA Access Hints
[2] T13 Hybrid Information Feature
[3] AIO Attributes: http://marc.info/?l=linux-aio&m=136580574523674&w=2
