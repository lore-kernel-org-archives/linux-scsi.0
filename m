From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] add scsi changer driver
Date: Sun, 06 Mar 2005 19:55:25 +0200
Message-ID: <1110131725.9206.25.camel@mulgrave>
References: <20050215164245.GA13352@bytesex>
	 <20050215175431.GA2896@infradead.org>  <20050216143936.GA23892@bytesex>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:42139 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261453AbVCFR5A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Mar 2005 12:57:00 -0500
In-Reply-To: <20050216143936.GA23892@bytesex>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerd Knorr <kraxel@bytesex.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Looking through this, the only things I really noticed that need work
are:

ch_do_scsi():  It looks like this has an effective reimplementation of
scsi_wait_req.  We're trying to deprecate the usage of scsi_do_req so we
can make it private eventually.  What's the reason you can't use
scsi_wait_req?

ch_ioctl() (and the compat): since this is a new driver, can't this all
be done via sysfs?  That way, the user would be able to manipulate it
from the command line, and we'd no longer need any of the 32->64 compat
glue.

James



