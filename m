From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: [patch 2/4] ibmvscsi.c: limit size of I/O requests
Date: Tue, 30 Nov 2004 09:29:16 -0600
Message-ID: <20041130152916.GA7639@cs.umn.edu>
References: <20041129203107.GB31011@cs.umn.edu> <20041130075457.GD10450@suse.de>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.35.202]:51597 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S262124AbUK3P3Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 10:29:24 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 5213E5C385
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2004 09:29:20 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (augustus [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 03400-01 for <linux-scsi@vger.kernel.org>;
 Tue, 30 Nov 2004 09:29:18 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id 9AF915C37C
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2004 09:29:16 -0600 (CST)
Content-Disposition: inline
In-Reply-To: <20041130075457.GD10450@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Nov 30, 2004 at 08:54:58AM +0100, Jens Axboe wrote:
> On Mon, Nov 29 2004, Dave C Boutcher wrote:
> > Description: Limit the size of I/O requests sent by the 
> > ibmvscsi adapter.  With better I/O scheduling (and thus larger
> > requests) we were breaking some servers.
> 
> Nack, why can't you use /dev/block/xxx/queue/max_sectors_kb to control
> this?

The basic function of this patch is to set host->max_sectors based
on information from the SCSI target.

There is a default value because two of the existing target implementations
(there are three) don't set the value.

I confess to making the default value a module parameter because I
took a SWAG at the correct value.  I COULD remove the module
parameter part of this patch, though if someone actually cares enough
about performance to tweak it, modprobe.conf seems like a nice place to
set it.

-- 
Dave Boutcher
