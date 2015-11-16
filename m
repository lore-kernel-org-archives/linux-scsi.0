From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Mon, 16 Nov 2015 13:03:27 -0600
Message-ID: <003801d120a1$799338d0$6cb9aa70$@opengridcomputing.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-4-git-send-email-hch@lst.de> <564851BB.1020004@dev.mellanox.co.il> <564A067B.8030504@opengridcomputing.com> <003001d1209c$ecb70760$c6251620$@opengridcomputing.com> <564A2270.1040004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564A2270.1040004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sagi Grimberg
> Sent: Monday, November 16, 2015 12:38 PM
> To: Steve Wise; 'Christoph Hellwig'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org; axboe-b10kYP2dOMg@public.gmane.org; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
> 
> 
> > After looking at the nes driver, I don't see any common way to support drain w/o some serious driver mods.  Since SRP is the
only
> > user, perhaps we can ignore iWARP for this function...
> 
> But iser/isert essentially does it too (and I think xprtrdma will have
> it soon)...
> 
> the modify_qp is invoked from rdma_disconnect() and we do post
> an 'empty' wr to wait for all the flushes to drain (see
> iser_conn_terminate).

That won't work for iWARP.  Is this code new?  I didn't see any errors that would result from this code when I tested iSER over
cxgb4 with the old iwarp support patches.   

Perhaps we need another way to do this?  Like a completion object in the QP that gets triggered when the SQ and RQ become empty
after a transition to ERROR (and CLOSING for iwarp).  Then a core service that just waits until the QP is empty.  Implementation of
this design would hit the providers though since only they know when the flush is completed.

Alternatively, I could enable post-while-in-error support in cxgb4 and ignore the spec in this regard.  But I'd rather not do that.
:)

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
