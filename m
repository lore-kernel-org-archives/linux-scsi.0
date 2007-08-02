From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] block: add protocol discriminators to requests and queues
Date: Thu, 2 Aug 2007 12:51:28 -0600
Message-ID: <20070802185128.GL21219@parisc-linux.org>
References: <1186076845.3449.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1186076845.3449.22.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 02, 2007 at 12:47:25PM -0500, James Bottomley wrote:
> This looks small and innocuous, but it's actually the beginning of
> moving the upper layer drivers into block and adding a filtering layer.
> The idea is that the queue contains a queue_protocol parameter which
> details what the device actually speaks.  The requests are likewise
> filled in with a cmd_protocol parameter by the ULDs (or bsg if it's a
> user initiated command, using the existing sgv4 protocol fields).
> 
> Now we have the capability of adding say native ATA pass through to BSG,
> but also we can add things like an ATAPI filter:  sr creates SCSI
> requests, but these could be sent through a PACKET_COMMAND wrapper and
> emerge as BLK_PROTOCOL_ATAPI before being sent to the device.  Likewise,
> sd requests going to BLK_PROTOCOL_ATA devices would have to go through
> SATL filters.  

Will it also add the ability to add device-specific filters?  For
example, the CD burners that have manufacturer specific opcodes to turn
on various features that are safe for users to use ... but have to be
limited to root-only currently as we can't know what kind of device the
command is going to.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
