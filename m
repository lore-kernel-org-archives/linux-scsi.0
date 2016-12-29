From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Thu, 29 Dec 2016 00:02:50 -0800
Message-ID: <20161229080250.GA11605@infradead.org>
References: <1482985824-7270-1-git-send-email-jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482985824-7270-1-git-send-email-jbaron@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Sagi Grimberg <sagi@grimberg.me>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 28, 2016 at 11:30:24PM -0500, Jason Baron wrote:
> Add a new parameter to scsi_internal_device_block() to decide whether
> or not to invoke scsi_wait_for_queuecommand().

We'll also need to deal with the blk-mq wait path that Bart has been
working on (I think it's already in the scsi tree, but I'd have to
check).

Also adding a bool flag for the last call in a function is style that's
a little annoying.

I'd prefer to add a scsi_internal_device_block_nowait that contains
all the code except for the waiting, and then make
scsi_internal_device_block_nowait a wrapper around it.  Or drop the
annoying internal for both while we're at it :)
