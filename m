From: Gerd Knorr <kraxel@bytesex.org>
Subject: Re: [patch] add scsi changer driver
Date: Mon, 7 Mar 2005 09:21:07 +0100
Message-ID: <20050307082107.GC17704@bytesex>
References: <20050215164245.GA13352@bytesex> <20050215175431.GA2896@infradead.org> <20050216143936.GA23892@bytesex> <1110131725.9206.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from hirsch.in-berlin.de ([192.109.42.6]:47068 "EHLO
	hirsch.in-berlin.de") by vger.kernel.org with ESMTP id S261688AbVCGIZT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 03:25:19 -0500
Content-Disposition: inline
In-Reply-To: <1110131725.9206.25.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, Mar 06, 2005 at 07:55:25PM +0200, James Bottomley wrote:
> Looking through this, the only things I really noticed that need work
> are:
> 
> ch_do_scsi():  It looks like this has an effective reimplementation of
> scsi_wait_req.  We're trying to deprecate the usage of scsi_do_req so we
> can make it private eventually.  What's the reason you can't use
> scsi_wait_req?

Probably historical reasons, I havn't tracked the scsi layer changes for
quite some time, so this might simply be a 2.6 cleanup I've missed
because of that.  Will check ...

> ch_ioctl() (and the compat): since this is a new driver, can't this all
> be done via sysfs?  That way, the user would be able to manipulate it
> from the command line, and we'd no longer need any of the 32->64 compat
> glue.

Well, it isn't new, it already exists for many years, just not living in
mainline (which I finally want to change now ...).

  Gerd

-- 
#define printk(args...) fprintf(stderr, ## args)
