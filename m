From: Christoph Hellwig <hch@lst.de>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
	support optional
Date: Mon, 8 Feb 2016 11:13:50 +0100
Message-ID: <20160208101350.GA32632@lst.de>
References: <1454783624.2809.6.camel@HansenPartnership.com> <20160207092241.GA15331@lst.de> <1454861040.2329.4.camel@HansenPartnership.com> <56B7C527.6050300@kernel.dk> <1454886441.2329.27.camel@HansenPartnership.com> <56B8448A.3000106@suse.de> <56B8676C.20600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B8676C.20600@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 08, 2016 at 12:01:16PM +0200, Sagi Grimberg wrote:
>
>> Do we have defined sysfs attributes for NVMe devices nowadays?
>
> /sys/block/nvme0n1/uuid

That's only supported for NVMe 1.1 and higher devices, and optional.
=46or older or stupid devices we need to support the algorithm based
on the serial attribute from nvme_fill_device_id_scsi_string() in
drivers/nvme/host/scsi.c.

Which btw is =D1=96ncorrect as it doesn't identify namespaces properly,
and thus the associatation of 0 is an actively harmful lie.
