From: 'Christoph Hellwig' <hch@lst.de>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Mon, 23 Nov 2015 15:33:37 +0100
Message-ID: <20151123143337.GA11253@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-4-git-send-email-hch@lst.de> <564851BB.1020004@dev.mellanox.co.il> <564A067B.8030504@opengridcomputing.com> <003001d1209c$ecb70760$c6251620$@opengridcomputing.com> <564A2270.1040004@dev.mellanox.co.il> <003801d120a1$799338d0$6cb9aa70$@opengridcomputing.com> <5652EA67.1000707@dev.mellanox.co.il> <5652EC00.8010705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5652EC00.8010705@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>, 'Christoph Hellwig' <hch@lst.de>, linux-rdma@vger.kernel.org, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 23, 2015 at 12:35:44PM +0200, Sagi Grimberg wrote:
>
>> So Maybe we should have:
>> void ib_drain_qp(struct ib_qp *qp)
>
> Christoph suggested that this flushing would be taken care
> of by rdma_disconnect which sounds even better I think..

Note that will only work once we've converted all drivers to
the new CQ API under development.  Without that every completion
handlers needs a special case for the drain WC.
