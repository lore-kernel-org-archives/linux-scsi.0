From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Mon, 16 Nov 2015 20:37:36 +0200
Message-ID: <564A2270.1040004@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-4-git-send-email-hch@lst.de>
 <564851BB.1020004@dev.mellanox.co.il>
 <564A067B.8030504@opengridcomputing.com>
 <003001d1209c$ecb70760$c6251620$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <003001d1209c$ecb70760$c6251620$@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'Christoph Hellwig' <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> After looking at the nes driver, I don't see any common way to support drain w/o some serious driver mods.  Since SRP is the only
> user, perhaps we can ignore iWARP for this function...

But iser/isert essentially does it too (and I think xprtrdma will have
it soon)...

the modify_qp is invoked from rdma_disconnect() and we do post
an 'empty' wr to wait for all the flushes to drain (see
iser_conn_terminate).
