From: Keith Busch <keith.busch@intel.com>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
 support optional
Date: Mon, 8 Feb 2016 15:12:58 +0000
Message-ID: <20160208151258.GB25111@localhost.localdomain>
References: <1454783624.2809.6.camel@HansenPartnership.com>
 <20160207092241.GA15331@lst.de>
 <1454861040.2329.4.camel@HansenPartnership.com>
 <56B7C527.6050300@kernel.dk>
 <1454886441.2329.27.camel@HansenPartnership.com>
 <56B8448A.3000106@suse.de>
 <56B8676C.20600@dev.mellanox.co.il>
 <20160208101350.GA32632@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160208101350.GA32632@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 08, 2016 at 11:13:50AM +0100, Christoph Hellwig wrote:
> On Mon, Feb 08, 2016 at 12:01:16PM +0200, Sagi Grimberg wrote:
> >
> >> Do we have defined sysfs attributes for NVMe devices nowadays?
> >
> > /sys/block/nvme0n1/uuid
> 
> That's only supported for NVMe 1.1 and higher devices, and optional.
> For older or stupid devices we need to support the algorithm based
> on the serial attribute from nvme_fill_device_id_scsi_string() in
> drivers/nvme/host/scsi.c.

It's even worse. NGUID was defined for 1.2 devices and higher. 1.1
devices should have EUI-64 at:
 
  /sys/block/nvmeXnY/eui

1.2 devices will have either uuid or eui (or both).

The majority of devices in circulation today are 1.0, and need to concat
these three entries to make a unique identifier:

  /sys/block/nvmeXnY/device/serial
  /sys/block/nvmeXnY/device/model
  /sys/block/nvmeXnY/nsid
