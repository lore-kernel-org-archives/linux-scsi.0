From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 00/13] mpt3sas driver NVMe support:
Date: Sat, 5 Aug 2017 06:53:53 -0700
Message-ID: <20170805135353.GA7526@infradead.org>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <e679a449-90c3-d2e1-2b31-1387cf414e09@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e679a449-90c3-d2e1-2b31-1387cf414e09@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 02, 2017 at 10:14:40AM +0200, Hannes Reinecke wrote:
> I'm not happy with this approach.
> NVMe devices should _not_ appear as SCSI devices; this will just confuse
> matters _and_ will be incompatible with 'normal' NVMe devices.
> 
> Rather I would like to see the driver to hook into the existing NVMe
> framework (which essentially means to treat the mpt3sas as a weird
> NVMe-over-Fabrics HBA), and expose the NVMe devices like any other NVMe HBA.

That doesn't make any sense.  The devices behind the mpt adapter don't
look like NVMe devices at all for the hosts - there are no NVMe commands
or queues involved at all, they hide behind the same somewhat leaky
scsi abstraction as other devices behind the mpt controller.

The only additional leak is that the controller now supports NVMe-like
PRPs in additions to its existing two SGL formats.
