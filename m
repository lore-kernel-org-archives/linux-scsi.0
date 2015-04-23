From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH v4 19/43] hpsa: add ioaccel sg chaining for the ioaccel2
 path
Date: Thu, 23 Apr 2015 00:39:12 -0700
Message-ID: <20150423073912.GA11985@infradead.org>
References: <20150416134224.30238.66082.stgit@brunhilda>
 <20150416134827.30238.67380.stgit@brunhilda>
 <55310729.1040304@suse.de>
 <07F70BBF6832E34FA1C923241E8833AB4869FBD3@BBYEXM01.pmc-sierra.internal>
 <55388831.90109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbbDWHjT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 03:39:19 -0400
Content-Disposition: inline
In-Reply-To: <55388831.90109@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: brace <brace@pmcs.com>, Scott Teel <Scott.Teel@pmcs.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, Justin Lindley <Justin.Lindley@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Apr 23, 2015 at 07:50:41AM +0200, Hannes Reinecke wrote:
> Yes, that's okay with me.
> 
> Personally I would be using mempools when you need lots of small,
> frequently changed allocations (like sg elements), and kzalloc() for
> large or infrequently changed bits of memory.

The array lookup is a small O(1) cost, so it's aways cheaper than
a mempool for this case where we allocate on object per tag.

Even better would be to use the command private data, but that needs
the patches that allow the driver to initializse it that Jens is working
on first.
