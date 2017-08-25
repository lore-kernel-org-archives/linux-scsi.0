From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] scsi_transport_sas: Fix error handling in
        sas_smp_request()
Date: Fri, 25 Aug 2017 17:57:36 +0200
Message-ID: <20170825155736.GB19091@lst.de>
References: <20170823182558.15370-1-bart.vanassche@wdc.com> <20170825153529.GB18440@lst.de> <1503675527.2680.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1503675527.2680.1.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 25, 2017 at 03:38:48PM +0000, Bart Van Assche wrote:
> On Fri, 2017-08-25 at 17:35 +0200, Christoph Hellwig wrote:
> > I looked a bit more at the history of this, and it seems like the only
> > issue with commit 17d5363b83f8 here is using the blk_status_t type for the
> > ret variable.  Even before that the negative error code leaked out
> > to userspace.  We can try to just turn that back into an int, but I'll
> > also send out an RFC patch to use bsg-lib for the SAS transport in a bit.
> 
> Hello Christoph,
> 
> Do you want me to split this patch in two patches - one that changes the type
> of 'ret' and another one that translates the Unix error code into a SCSI result?

The first one is obviously ok.  The second one looks wrong to me,
given that as far as I can tell we've always returned the Linux error
code for the SMP passthrough bsg node.  I'll try to find some more time
to read up the history on it, and check what the open source user space
tools expect.
