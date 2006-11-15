From: Matthew Wilcox <matthew@wil.cx>
Subject: Async scan changes -- now available as a git tree
Date: Wed, 15 Nov 2006 16:53:24 -0700
Message-ID: <20061115235324.GN19143@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:22436 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1162082AbWKOXxZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Nov 2006 18:53:25 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I've put the asynchronous scsi scanning patches that I've been
posting for a while into their own git tree, and split them in a way
that I hope makes sense.  Since git.kernel.org is experiencing some
trouble right now, it's all available here:

http://git.parisc-linux.org/?p=linux-2.6.git;a=shortlog;h=scsi-async-scan

It started as a clone of scsi-misc.  You can clone this tree via

git-fetch git://git.parisc-linux.org/git/linux-2.6.git \
scsi-async-scan:scsi-async-scan

I've had a bug report about the aic94xx, but:
<jejb> djwong, that can result because of the way libsas handles errors
<jejb> I have a patch for that I should post

So I'm gleefully ignoring that problem for the moment.

Here's the commits currently in the tree:

commit 9b039f5f7d3ac3a3f1c97f2ef0d8b13690dcab12
Author: Matthew Wilcox <willy@rowlf.int.wil.cx>
Date:   Wed Nov 15 18:19:29 2006 -0500

    [SCSI] Convert libata to use scsi_scan_host
    
    This is a very rough conversion; each of the scsi_host_templates should be
    converted to add the new methods, but this is a good initial hack to check
    the concept works
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit b83c4572a79bb143d1d71c06a9765486a5daeff0
Author: Matthew Wilcox <willy@rowlf.int.wil.cx>
Date:   Wed Nov 15 18:17:41 2006 -0500

    [SCSI] Convert aic94xx to use scsi_scan_host
    
    Split up the init functions into the new scan_start and scan_finished
    methods
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 114cf7c818ee1ba9104dbf0574c3b39e4f3ea5ef
Author: Matthew Wilcox <willy@rowlf.int.wil.cx>
Date:   Wed Nov 15 18:16:52 2006 -0500

    [SCSI] Convert qla2xxx to use scsi_scan_host
    
    Split up the init functions into the new scan_start and scan_finished
    methods
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit e7080cc397dc7f325c1d5154846f5bf071d5678c
Author: Matthew Wilcox <willy@rowlf.int.wil.cx>
Date:   Wed Nov 15 18:16:10 2006 -0500

    [SCSI] Convert lpfc to use scsi_scan_host
    
    Split up the init functions into the new scan_start and scan_finished
    methods
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 59d1b29d6560c7b561116aa1556ffb829dbd3cff
Author: Matthew Wilcox <willy@rowlf.int.wil.cx>
Date:   Wed Nov 15 18:13:34 2006 -0500

    [SCSI] Make scsi_scan_host work for drivers which find their own targets
    
    If a driver can find its own targets, it can now fill in scan_finished and
    (optionally) scan_start in the scsi_host_template.  Then, when it calls
    scsi_scan_host(), it will be called back (from a thread if asynchronous
    discovery is enabled), first to start the scan, and then at intervals to
    check if the scan is completed.
    
    Also make scsi_prep_async_scan and scsi_finish_async_scan static.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 122bc8b3efa531cfa45d18335748ed39480d5363
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Sun Oct 22 15:45:13 2006 -0600

    SCSI: Missing check for no scanning
    
    Drivers that called scsi_scan_tagrget() instead of scsi_scan_host() were
    still adding devices; this needs to be under the control of userspace,
    not the driver.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 9f752d4f48dbfe547cb7fe1a0e32dbd36a979137
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Sun Oct 22 10:40:47 2006 -0600

    Add Kconfig option for asynchronous SCSI scanning
    
    To this point, the user has to add a kernel command line parameter to
    get asynchronous SCSI scanning.  Now they can select the default at
    compile time and still override it at boot time if they need to.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

