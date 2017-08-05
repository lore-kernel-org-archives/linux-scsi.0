From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 00/13] mpt3sas driver NVMe support:
Date: Sat, 05 Aug 2017 07:42:09 -0700
Message-ID: <1501944129.3649.9.camel@HansenPartnership.com>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
         <e679a449-90c3-d2e1-2b31-1387cf414e09@suse.de>
         <20170805135353.GA7526@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170805135353.GA7526@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2017-08-05 at 06:53 -0700, Christoph Hellwig wrote:
> On Wed, Aug 02, 2017 at 10:14:40AM +0200, Hannes Reinecke wrote:
> > 
> > I'm not happy with this approach.
> > NVMe devices should _not_ appear as SCSI devices; this will just
> > confuse matters _and_ will be incompatible with 'normal' NVMe
> > devices.
> > 
> > Rather I would like to see the driver to hook into the existing
> > NVMe framework (which essentially means to treat the mpt3sas as a
> > weird NVMe-over-Fabrics HBA), and expose the NVMe devices like any
> > other NVMe HBA.
> 
> That doesn't make any sense.  The devices behind the mpt adapter
> don't look like NVMe devices at all for the hosts - there are no NVMe
> commands or queues involved at all, they hide behind the same
> somewhat leaky scsi abstraction as other devices behind the mpt
> controller.

You might think about what we did for SAS: split the generic handler
into two pieces, libsas for driving the devices, which mpt didn't need
because of the fat firmware and the SAS transport class so mpt could at
least show the same sysfs files as everything else for SAS devices.

Fortunately for NVMe it's very simple at the moment its just a couple
of host files and wwid on the devices.

James


> The only additional leak is that the controller now supports NVMe-
> like PRPs in additions to its existing two SGL formats.
> 
