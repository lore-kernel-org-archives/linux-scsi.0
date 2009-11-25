From: Neil Brown <neilb@suse.de>
Subject: Re: BUG at scsi_lib.c:1108 [Was: mmotm 2009-11-24-16-47 uploaded]
Date: Thu, 26 Nov 2009 08:13:59 +1100
Message-ID: <20091126081359.414c8216@notabene.brown>
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>
	<4B0D4949.4090109@gmail.com>
	<1259162399.2535.8.camel@mulgrave.site>
	<4B0D9221.2050103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759861AbZKYWpo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Nov 2009 17:45:44 -0500
In-Reply-To: <4B0D9221.2050103@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>

On Wed, 25 Nov 2009 21:22:57 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> It doesn't make sense at all. How can empty merge cause a regression?
> And md/for-next doesn't produce the BUG.

I've hit that situation before.  Two separate changes in separate
branches conspire to cause a problem.

md/for-next contains code to handle barriers properly for all levels,
not just RAID1.
It is possible I got this wrong in some way, and some new sanity check
in a separate branch is firing, or it is possible some other bug in
barrier handling has been added and now that MD sends barriers, it is
being triggered.

What I did to find the actual offending patches is to got to one of the
heads just before the merge, and cherry-pick all the patches from the
other branch, and then bisect that.

NeilBrown
