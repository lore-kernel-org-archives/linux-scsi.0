From: Ben Collins <bcollins@debian.org>
Subject: Re: sbp2: modprobe -r fails, module allegedly in use
Date: Sun, 10 Jul 2005 13:37:32 -0400
Message-ID: <20050710173732.GF14956@phunnypharm.org>
References: <42D133EE.9090204@s5r6.in-berlin.de> <1121016562.5078.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:23780 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261986AbVGJRhd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:37:33 -0400
Content-Disposition: inline
In-Reply-To: <1121016562.5078.15.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>

> Actually, I think your error is the opposite of this: you should never
> have to do a scsi_host_put() unless you did a corresponding
> scsi_host_get(), which, as far as I can see, sbp2 never does, so the
> extra put should be meaningless.
> 
> Except, I notice that you don't do a scsi_device_put() after
> scsi_add_device().  I think this is probably the source of the
> refcounting errors: scsi_add_device returns an sdev with the refcount
> incremented by one, so you need to decrement the count after you've
> finished with it (in your case, you do nothing with it, so just
> decrement after you've checked it's not an error pointer).

Thanks. Stefan, can you test with that change? I've already put it in the
repo.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
