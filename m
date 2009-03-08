From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Getting TRIM working
Date: Sun, 08 Mar 2009 16:32:36 -0500
Message-ID: <1236547956.4861.17.camel@localhost.localdomain>
References: <20090303190700.GD20511@parisc-linux.org>
	 <49AE47DB.4030200@panasas.com> <20090306191620.GA25995@parisc-linux.org>
	 <49B39DCB.3040203@panasas.com>
	 <1236547480.4861.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1236547480.4861.12.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2009-03-08 at 16:24 -0500, James Bottomley wrote:
> The problem in the prepare is you need to set up a command with data.
> What I'm not quite clear on is why blk_rq_map_kern() on a kmalloc'd
> buffer can't be used.  You'd end up with a dual bio request (one for the
> discard, one for the data), but they should tear down correctly using
> the separate bio teardowns and pass correctly into blk_rq_map_sg() which
> was the original point.

Actually, found the reason, blk_rq_map_kern will blast the original bio
from the request.  You could fix this by chaining it back again at the
beginning.  If that works, we could just wrap it into a block API to
prevent users from having to muck with bios.

James


