From: scameron@beardog.cce.hp.com
Subject: Re: [scsi:for-next 82/88] drivers/scsi/hpsa.c:3038 hpsa_update_scsi_devices() warn: impossible condition '(rescan_hba_mode < 0) => (0-255 < 0)'
Date: Wed, 21 May 2014 09:29:09 -0500
Message-ID: <20140521142909.GM6970@beardog.cce.hp.com>
References: <20140521071344.GH17724@mwanda> <20140521142650.GC1379@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:17010 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaEUOaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 10:30:03 -0400
Content-Disposition: inline
In-Reply-To: <20140521142650.GC1379@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org, Joe Handzik <joseph.t.handzik@hp.com>, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com

On Wed, May 21, 2014 at 04:26:50PM +0200, Christoph Hellwig wrote:
> Stephen, can you look at these warnings?

Yeah, I'm looking at it right now.

-- steve

> 
> If the answer is this is all fixes in the other pending patches we'll just
> need to find another reviewer for them.
> 
> On Wed, May 21, 2014 at 10:13:44AM +0300, Dan Carpenter wrote:
> > 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> > head:   0a8c8edf3a8c8c878c1e92ddb9c9df966b2fdefb
> > commit: 96444fbbbf3b55a9cd1e337cc5c8c7d04bb364b7 [82/88] hpsa: do not ignore failure of sense controller parameters command
> > 
> > New smatch warnings:
> > drivers/scsi/hpsa.c:3038 hpsa_update_scsi_devices() warn: impossible condition '(rescan_hba_mode < 0) => (0-255 < 0)'
> > 
> > Old smatch warnings:
> > drivers/scsi/hpsa.c:1042 hpsa_scsi_remove_entry() error: buffer overflow 'h->dev' 2081 <= 2081
> > drivers/scsi/hpsa.c:1192 hpsa_show_volume_status() warn: impossible condition '(sd->volume_offline == -1) => (0-255 == (-1))'
> > drivers/scsi/hpsa.c:2432 hpsa_get_device_id() warn: returning -1 instead of -ENOMEM is sloppy
> > 
> > git remote add scsi git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
> > git remote update scsi
> > git checkout 96444fbbbf3b55a9cd1e337cc5c8c7d04bb364b7
> > vim +3038 drivers/scsi/hpsa.c
> > 
> > 339b2b14 Stephen M. Cameron 2010-02-04  3022  	int raid_ctlr_position;
> > 316b221a Stephen M. Cameron 2014-02-21  3023  	u8 rescan_hba_mode;
> > aca4a520 Scott Teel         2012-01-19  3024  	DECLARE_BITMAP(lunzerobits, MAX_EXT_TARGETS);
> > edd16368 Stephen M. Cameron 2009-12-08  3025  
> > cfe5badc Scott Teel         2011-10-26  3026  	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_DEVICES, GFP_KERNEL);
> > edd16368 Stephen M. Cameron 2009-12-08  3027  	physdev_list = kzalloc(reportlunsize, GFP_KERNEL);
> > edd16368 Stephen M. Cameron 2009-12-08  3028  	logdev_list = kzalloc(reportlunsize, GFP_KERNEL);
> > edd16368 Stephen M. Cameron 2009-12-08  3029  	tmpdevice = kzalloc(sizeof(*tmpdevice), GFP_KERNEL);
> > edd16368 Stephen M. Cameron 2009-12-08  3030  
> > 0b0e1d6c Stephen M. Cameron 2011-08-09  3031  	if (!currentsd || !physdev_list || !logdev_list || !tmpdevice) {
> > edd16368 Stephen M. Cameron 2009-12-08  3032  		dev_err(&h->pdev->dev, "out of memory\n");
> > edd16368 Stephen M. Cameron 2009-12-08  3033  		goto out;
> > edd16368 Stephen M. Cameron 2009-12-08  3034  	}
> > edd16368 Stephen M. Cameron 2009-12-08  3035  	memset(lunzerobits, 0, sizeof(lunzerobits));
> > edd16368 Stephen M. Cameron 2009-12-08  3036  
> > 316b221a Stephen M. Cameron 2014-02-21  3037  	rescan_hba_mode = hpsa_hba_mode_enabled(h);
> > 96444fbb Joe Handzik        2014-05-15 @3038  	if (rescan_hba_mode < 0)
> > 96444fbb Joe Handzik        2014-05-15  3039  		goto out;
> > 316b221a Stephen M. Cameron 2014-02-21  3040  
> > 316b221a Stephen M. Cameron 2014-02-21  3041  	if (!h->hba_mode_enabled && rescan_hba_mode)
> > 316b221a Stephen M. Cameron 2014-02-21  3042  		dev_warn(&h->pdev->dev, "HBA mode enabled\n");
> > 316b221a Stephen M. Cameron 2014-02-21  3043  	else if (h->hba_mode_enabled && !rescan_hba_mode)
> > 316b221a Stephen M. Cameron 2014-02-21  3044  		dev_warn(&h->pdev->dev, "HBA mode disabled\n");
> > 316b221a Stephen M. Cameron 2014-02-21  3045  
> > 316b221a Stephen M. Cameron 2014-02-21  3046  	h->hba_mode_enabled = rescan_hba_mode;
> > 
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> ---end quoted text---
