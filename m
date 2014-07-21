From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] sd: Handle ZBC drives correctly
Date: Mon, 21 Jul 2014 08:01:09 -0700
Message-ID: <20140721150109.GB15433@infradead.org>
References: <1405931241-92015-1-git-send-email-hare@suse.de>
 <1405931241-92015-5-git-send-email-hare@suse.de>
 <20140721112904.GB15455@infradead.org>
 <53CCFEBE.8080400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaGUPBJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jul 2014 11:01:09 -0400
Content-Disposition: inline
In-Reply-To: <53CCFEBE.8080400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomely <jbottomley@parallels.com>

On Mon, Jul 21, 2014 at 01:51:26PM +0200, Hannes Reinecke wrote:
> Yes, I have.

How well does the SCSI layer recover when you write outside the write
pointer?  ZBC defeinds new sense codes that we don't handle, so I'd
expect we'd get long loops of unrecovered errors.

> I was actually considering implementing a module option for sd
> (eg attach_zbc) to allow zac/zbc devices to be attached to the sd driver.
> Which will be off per default, so your concern should be addressed.

That sounds fine to.

> However, zbc devices _are_ similar to normal 'sd' devices; it's only that
> some commands might fail unexpectedly.
> But all the usual commands from sbc are supported, so I found it a bit odd
> having to implement my own device driver (which would be a clone of 'sd'
> anyway).

They are similar in some ways and very different in others.  I
defintively agree we should share as much code as possible, but I'm not
sure exposing them as plain sd devices is a good idea.  I'm defintively
fine with an optional attachment to sd to start playing around with
different ways to make use of them.

