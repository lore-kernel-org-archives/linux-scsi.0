From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/8] bsg-lib: handle bidi requests without block layer
 help
Date: Wed, 14 Nov 2018 16:48:57 +0100
Message-ID: <20181114154857.GA28985@lst.de>
References: <20181111133211.13926-1-hch@lst.de> <20181111133211.13926-7-hch@lst.de> <20181113143520.GB7222@w530-pk1mzal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181113143520.GB7222@w530-pk1mzal>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 13, 2018 at 03:35:20PM +0100, Benjamin Block wrote:
> This seems like a non-obvious user-breakage. So apart from removing the
> in-kernel stuff that uses bidirectional commands you also forbid
> userspace from every using them? That seems wrong to me.
> 
> There is other SCSI Command Sets than OSD that provide bidirectional
> commands, even SBC has some (i.e.  X*WRITE*, COMPARE AND WRITE).

Yes, there are a few.  But the only driver that even supports them
right now is iscsi_tcp to start with, and we have to drag a significant
amount of code around just to support this corner case.
