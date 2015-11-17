From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Tue, 17 Nov 2015 10:54:01 +0200
Message-ID: <564AEB29.4080304@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-4-git-send-email-hch@lst.de>
 <564851BB.1020004@dev.mellanox.co.il>
 <564A067B.8030504@opengridcomputing.com>
 <003001d1209c$ecb70760$c6251620$@opengridcomputing.com>
 <564A2270.1040004@dev.mellanox.co.il>
 <003801d120a1$799338d0$6cb9aa70$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003801d120a1$799338d0$6cb9aa70$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


> That won't work for iWARP.  Is this code new?  I didn't see any errors that would result from this code when I tested iSER over
> cxgb4 with the old iwarp support patches.

It's there since ~3.17 I think...

>
> Perhaps we need another way to do this?  Like a completion object in the QP that gets triggered when the SQ and RQ become empty
> after a transition to ERROR (and CLOSING for iwarp).  Then a core service that just waits until the QP is empty.  Implementation of
> this design would hit the providers though since only they know when the flush is completed.

ULPs need a drain functionality, so ib_drain_qp() is the way to go...

How about we add a drain_qp() callout and have:

	if (qp->device->drain_qp) {
		qp->device->drain_qp();
		return;
	}

	IB drain qp logic...

This way iWARP devices can have their own magic on how to implement this
functionality.

Thoughts?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
