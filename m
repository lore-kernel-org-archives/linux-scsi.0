From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Fri, 28 Oct 2016 00:32:56 -0700
Message-ID: <20161028073256.GA9207@infradead.org>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
 <27d08f8f-bbf5-1298-1985-f0c3ee45d2d1@sandisk.com>
 <1477434237.3079.84.camel@linux.vnet.ibm.com>
 <1477437481.2385.7.camel@sandisk.com>
 <1477439413.3079.101.camel@linux.vnet.ibm.com>
 <e3531f72-596e-359c-93bd-3855291d7ba0@sandisk.com>
 <1477497160.2724.11.camel@linux.vnet.ibm.com>
 <1477498520.2550.1.camel@sandisk.com>
 <bec8981d-b061-928a-24f9-683dc7eaa936@linux.vnet.ibm.com>
 <4157cbe0-8110-49e2-ea18-ef6c76706338@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39205 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbcJ1HdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2016 03:33:01 -0400
Content-Disposition: inline
In-Reply-To: <4157cbe0-8110-49e2-ea18-ef6c76706338@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Brian King <brking@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "krisman@linux.vnet.ibm.com" <krisman@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gabriel@krisman.be" <gabriel@krisman.be>, Jens Axboe <axboe@fb.com>

On Thu, Oct 27, 2016 at 11:00:56AM +0200, Hannes Reinecke wrote:
> BLOCK_PC is currently used indiscriminately for all non-filesystem
> commands, ie for commands where the raw cdb is passed in via req->special.
> 
> As such, is has a dual meaning:
> - A pre-filled CDB
> - do not evaluate the sense code
> 
> If we could split this up in having one flag for a pre-filled CDB and
> another one for evaluating sense code we should be able to resolve this
> situation.

That sounds fine to me.  I just wish we could keep that flag inside
SCSI somehow, which isn't really doable with the current BLOCK_PC
passthrough architecture.  I have some work in progress to fix that
up but it will take a while to land.

If Jens is ok with it we can add a cmd_flags flag for now, though.
