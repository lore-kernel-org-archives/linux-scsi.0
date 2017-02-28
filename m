From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 09:16:07 -0800
Message-ID: <20170228091607.724d1883@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
        <20170227171931.30b9f619@xeon-e3>
        <20170228140812.GC20197@lst.de>
        <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:35293 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdCABF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 20:05:26 -0500
Received: by mail-pg0-f54.google.com with SMTP id b129so13224742pgc.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 17:04:34 -0800 (PST)
In-Reply-To: <1488301573.3046.9.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org

On Tue, 28 Feb 2017 09:06:13 -0800
James Bottomley <jejb@linux.vnet.ibm.com> wrote:

> On Tue, 2017-02-28 at 08:32 -0700, Jens Axboe wrote:
> > On 02/28/2017 07:08 AM, Christoph Hellwig wrote:  
> > > On Mon, Feb 27, 2017 at 05:19:31PM -0800, Stephen Hemminger wrote:  
> > > > Fixes: ee5242360424 ("scsi: zero per-cmd driver data before each
> > > > I/O")
> > > > 
> > > > but that is already in linux-next.
> > > > 
> > > > Noticed another place where memset(of the data was being done not
> > > > the extra bits.
> > > > Tried this, but didn't fix it either...  
> > > 
> > > Are you using blk-mq or the legacy request code?  
> > 
> > Stephen doesn't have MQ set in the config he posted, I'm assuming he 
> > didn't boot with scsi_mod.use_blk_mq=true. In a previous email, I 
> > asked if turning on MQ makes a difference.  
> 
> OK, since we're not making much progress, Stephen, could you insert
> some debugging into the storvsc driver?  The trace clearly shows we're
> getting zeros back in the buffer when we should have data from the
> initial scan.  Firstly, does the vmbus think it's transferring any data
> for the INQUIRY and READ_CAPACITY commands (looks like
> storvsc_command_completion() data_transfer_length)?  If it does,
> there's probably an issue initialising the sg list.  If it doesn't,
> we're probably sending bogus commands.
> 
> James

I tried booting with scsi_mod.use_blk_mq=true and that did nothing.
Rebuilding now with 
CONFIG_SCSI_MQ_DEFAULT=y

Sure, can instrument. after that test.
