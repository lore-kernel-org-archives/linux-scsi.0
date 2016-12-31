From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Sat, 31 Dec 2016 15:19:03 -0800
Message-ID: <1483226343.2518.32.camel@linux.vnet.ibm.com>
References: <1482985824-7270-1-git-send-email-jbaron@akamai.com>
         <20161229080250.GA11605@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161229080250.GA11605@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@akamai.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-12-29 at 00:02 -0800, Christoph Hellwig wrote:
> On Wed, Dec 28, 2016 at 11:30:24PM -0500, Jason Baron wrote:
> > Add a new parameter to scsi_internal_device_block() to decide 
> > whether or not to invoke scsi_wait_for_queuecommand().
> 
> We'll also need to deal with the blk-mq wait path that Bart has been
> working on (I think it's already in the scsi tree, but I'd have to
> check).
> 
> Also adding a bool flag for the last call in a function is style 
> that's a little annoying.
> 
> I'd prefer to add a scsi_internal_device_block_nowait that contains
> all the code except for the waiting, and then make
> scsi_internal_device_block_nowait a wrapper around it.  Or drop the
> annoying internal for both while we're at it :)

OK, I know it's new year, but this is an unpatched regression in -rc1
that's causing serious issues.  I would like this fixed by -rc3 so we
have 3 options

   1. revert all the queuecommand wait stuff until it proves it's actually
      working without regressions
   2. apply this patch and fix the style issues later
   3. someone else supplies the correctly styled fix patch

The conservative in me says that 1. is probably the most correct thing
to do because it gives us time to get the queuecommand wait stuff
right; that's what I'll probably do if there's no movement next week. 
 However, since we're reasonably early in the -rc cycle, so either 2 or
3 are viable provided no further regressions caused by the queuecommand
wait stuff pop up.

James
