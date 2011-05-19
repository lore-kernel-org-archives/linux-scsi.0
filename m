From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt
 merge
Date: Thu, 19 May 2011 11:44:20 -0600
Message-ID: <20110519174420.GD12525@obsidianresearch.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
 <20110518170556.GB2595@obsidianresearch.com>
 <BANLkTikOCeNcDvoCM=BOSxQaSECFhJ05Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTikOCeNcDvoCM=BOSxQaSECFhJ05Gg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rmda <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 19, 2011 at 07:29:21PM +0200, Bart Van Assche wrote:
> Regarding APM: the Linux kernel already has multipath support and
> duplicate functionality is in general not welcomed. So you will have
> to come up with a very good reason before APM support in ib_srp or
> ib_srpt would be considered for acceptance.

APM is a feature of IB's tranport layerthat provides disruption free
lossless failover to a backup network path completely transparently to
the application (eg SRP in this case).

This plays a similar role in the IB stack to the realtime spanning
tree protocol that ethernet uses, or the multipath IP routing that is
already in the net stack. I don't see it duplicating SCSI multipath at
all. On very large IB networks (eg > 1000 switches) the rate of link
failures is high enough that taking an application level recovery on
hundreds of nodes due to a link failure is troublesome.

If ib_srpt is implemented properly it may already support APM because
APM is supported by the IB CM that it relies on to setup connections,
and any SRP client could already request APM functionality during
connection setup.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
