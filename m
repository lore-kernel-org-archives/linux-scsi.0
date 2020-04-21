Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C272BC54FD0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9D942068F
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgDUPOj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:14:39 -0400
Received: from smtp.infotech.no ([82.134.31.41]:41929 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgDUPOj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 11:14:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B0F75204177;
        Tue, 21 Apr 2020 17:14:37 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WJHWhtyBf8Ie; Tue, 21 Apr 2020 17:14:31 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 60E14204148;
        Tue, 21 Apr 2020 17:14:29 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH v5 0/8] per_host_store+random parameters, compare
Date:   Tue, 21 Apr 2020 11:14:16 -0400
Message-Id: <20200421151424.32668-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset contains one large and several small improvements to the
scsi_debug driver. The large one is the new per_host_store parameter.
After it is set to 1, a following write to the add_host parameter will
cause each newly created host to get its own store (e.g. its own
ramdisk for user data). A host may contain 1 or more targets and each
target may contain 1 or more Logical Units (LUs). So every LU within
a host (by default there is only 1) will share the same store.

Since the scsi_debug driver is used mainly as a test vehicle, the
author found the addition of the random parameter very useful. Rather
than have fixed durations (set by the delay or ndelay parameters),
each issued command chooses from a uniformly distributed range
between 0 and the current delay parameter. Significantly this leads
to out-of-order completions which adds an extra dimension to testing.
For example it found a flaw in the implementation of the COMPARE AND
WRITE command.

With the ability to have multiple stores, the accuracy of copies can
be checked by comparing the source and destination after the copy.
Rather than read both sides into the user space buffers and comparing
them, one side can be read and that data sent with a VERIFY(BYTCHK=1)
command to the other side. The previously dummy VERIFY command is
enhanced in a patch to allow this alternate compare technique. And
speed can be (slightly) enhanced with the newly added PRE-FETCH
command as part of the compare sequence.

Updated documentation for this driver can be found at:
    http://sg.danny.cz/sg/scsi_debug.html

This patchset was previously presented as the first half of a
patchset titled:
    [PATCH v4 00/14] scsi_debug: host managed ZBC + doublestore
sent to the linux-scsi list on 20200225

Changes since v4:
  - the ZBC related patches have been removed and will be presented
    as a separate patchset
  - the doublestore parameter has been generalized and renamed to
    per_host_store=0|1 (bool). An xarray is used to track each
    store
  - the PRE-FETCH patch implementation now does something: it calls
    prefetch_range() on the indicated segment of the ramdisk

Changes since v3:
  - make enumeration constants of sdebug_z_cond upper case
  - move stray alphabetical re-order into correct patch
  - add some reviewed-by lines
  - meld 'zbc module parameter' and 'zbc parameter can be
    string' into single 'add zbc parameter' patch
  - make zbc= parameter read-only

Changes since v2 (RFC):
  - add support for host-managed zbc devices with
    conventional and "sequential write required"
    zones [DLM]

Changes since v1 (RFC):
  - testing with version 1 caused several strange crashes that
    turned out to be caused by a code trick to read in the
    data-out buffer but _not_ place it in the big fake_storep
    array. This approach failed badly when multiple threads
    were doing verifies at the same time.
  - replace the code trick with a new do_dout_fetch() function
  - since the code trick was borrowed from the COMPARE AND
    WRITE implementation [resp_comp_write()] using
    do_dout_fetch() fixes the same bug in the existing driver
    which hasn't been reported (yet).


Douglas Gilbert (8):
  scsi_debug: randomize command completion time
  scsi_debug: add per_host_store option
  scsi_debug: implement verify(10), add verify(16)
  scsi_debug: weaken rwlock around ramdisk access
  scsi_debug: improve command duration calculation
  scsi_debug: implement pre-fetch commands
  scsi_debug: re-arrange parameters alphabetically
  scsi_debug: bump to version 1.89

 drivers/scsi/scsi_debug.c | 1000 +++++++++++++++++++++++++++----------
 1 file changed, 744 insertions(+), 256 deletions(-)

-- 
2.26.1

