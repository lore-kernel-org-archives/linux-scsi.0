From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] block: add protocol discriminators to requests and
	queues
Date: Thu, 02 Aug 2007 13:59:40 -0500
Message-ID: <1186081180.3449.24.camel@localhost.localdomain>
References: <1186076845.3449.22.camel@localhost.localdomain>
	 <20070802185128.GL21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45574 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753901AbXHBS7z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 14:59:55 -0400
In-Reply-To: <20070802185128.GL21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>

On Thu, 2007-08-02 at 12:51 -0600, Matthew Wilcox wrote:
> On Thu, Aug 02, 2007 at 12:47:25PM -0500, James Bottomley wrote:
> > This looks small and innocuous, but it's actually the beginning of
> > moving the upper layer drivers into block and adding a filtering layer.
> > The idea is that the queue contains a queue_protocol parameter which
> > details what the device actually speaks.  The requests are likewise
> > filled in with a cmd_protocol parameter by the ULDs (or bsg if it's a
> > user initiated command, using the existing sgv4 protocol fields).
> > 
> > Now we have the capability of adding say native ATA pass through to BSG,
> > but also we can add things like an ATAPI filter:  sr creates SCSI
> > requests, but these could be sent through a PACKET_COMMAND wrapper and
> > emerge as BLK_PROTOCOL_ATAPI before being sent to the device.  Likewise,
> > sd requests going to BLK_PROTOCOL_ATA devices would have to go through
> > SATL filters.  
> 
> Will it also add the ability to add device-specific filters?  For
> example, the CD burners that have manufacturer specific opcodes to turn
> on various features that are safe for users to use ... but have to be
> limited to root-only currently as we can't know what kind of device the
> command is going to.

I wasn't planning on doing this ... the idea is basically a protocol
conversion filter.  Device quirks don't quite fit into this model.

James


