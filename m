From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] lk 2.5.31 sg version 3.5.27 re-adds dio
Date: Tue, 13 Aug 2002 00:05:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D588573.AB261C7A@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dial1.torque.net [204.138.244.11])
	by gear.torque.net (8.9.3/8.9.3) with ESMTP id AAA04253
	for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2002 00:04:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This version of sg for the lk 2.5 series re-adds direct IO
support using work done by Kai Makisara (on st driver, posted
2002/7/29).

Changelog:
    Changes since 3.5.26 (20020708)
        - re-add direct IO using Kai Makisara's work
        - re-tab to 8, start using C99-isms
        - simplify memory management

Like Kai's patch, this one needs kernel/ksyms.c altered
to export get_user_pages(). Kai's worker routines
st_map_user_pages() and st_unmap_user_pages() are duplicated
as is. Hopefully these routines will find a home in
a library soon.

The re-tabbing makes the patches rather large so here
are 2 urls:
This tarball contains sg.h and sg.c 
	http://www.torque.net/sg/p/sg3527.tgz
This gzipped patch is against lk 2.5.31 and touches
kernel/ksyms.c as well
	http://www.torque.net/sg/p/sg_3527_lk2531.diff.gz

Testing is ongoing, everything works apart from "zero
copy" copy. That uses mmap-ed IO on the read side and
direct IO on the write side. Not too many people would
be using that I suspect.

Doug Gilbert
