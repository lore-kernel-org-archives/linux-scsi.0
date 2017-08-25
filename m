From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi_transport_sas: Fix error handling in
        sas_smp_request()
Date: Fri, 25 Aug 2017 17:35:29 +0200
Message-ID: <20170825153529.GB18440@lst.de>
References: <20170823182558.15370-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170823182558.15370-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

I looked a bit more at the history of this, and it seems like the only
issue with commit 17d5363b83f8 here is using the blk_status_t type for the
ret variable.  Even before that the negative error code leaked out
to userspace.  We can try to just turn that back into an int, but I'll
also send out an RFC patch to use bsg-lib for the SAS transport in a bit.
