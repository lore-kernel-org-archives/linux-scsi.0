From: Matthew Wilcox <matthew@wil.cx>
Subject: target_alloc is noisy on failure
Date: Sun, 18 Dec 2005 12:29:25 -0700
Message-ID: <20051218192925.GM2361@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:9706 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S965248AbVLRT30
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Dec 2005 14:29:26 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I'm looking at moving this code from slave_alloc to target_alloc:

        tp->starget = sdev->sdev_target;
        if (tp->usrflags & SYM_SCAN_BOOT_DISABLED) {
		tp->usrflags &= ~SYM_SCAN_BOOT_DISABLED;
		starget_printk(KERN_INFO, tp->starget,
				"Scan at boot disabled in NVRAM\n");
		return -ENXIO;
	}

However, returning an error from target_alloc is noisy:

        int error = shost->hostt->target_alloc(starget);

	if(error) {
		dev_printk(KERN_ERR, dev,
			"target allocation failed, error %d\n", error);

so I don't really want to do this.  Any thoughts on defining some
'quiet' return values from target_alloc?

