From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 17:18:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021026001854.GG1514@beaverton.ibm.com>
References: <200210252223.g9PMN9a17551@eng2.beaverton.ibm.com> <200210260013.g9Q0DP105454@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210260013.g9Q0DP105454@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>, Doug Ledford <dledford@redhat.com>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> pbadari@us.ibm.com said:
> > I Just tried the patch. No Luck. I get same panic as before... I am
> > using qla2x00src-v6.03.00b6 driver on qla2200 fc controllers. 
> 
> Well, yours may be a qla bug.
> 
> However, I've tracked down my hang problem:  If a command is pushed back into 
> the block queue as a REQ_SPECIAL using the blk_insert_request() API, it never 
> has REQ_CMD cleared.  Eventually it comes back into scsi_request_fn() with 
> both REQ_CMD and REQ_SPECIAL set.  This causes the I/O to be initialised again.
> 
> The fix is to clear REQ_CMD in blk_insert_request().
> 
> This may also be the cause of Patrick's Incorrect number of segments error.

Once we kicked the console log level up Badari's system also showed
segment errors prior to the panic, but there still maybe other issues here.

-andmike
--
Michael Anderson
andmike@us.ibm.com

