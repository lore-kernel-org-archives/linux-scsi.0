From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 14/34] iscsi-target: export symbols
Date: Mon, 07 Mar 2016 15:22:54 -0800
Message-ID: <1457392974.30747.45.camel@haakon3.risingtidesystems.com>
References: <cover.1455467089.git.varun@chelsio.com>
	 <4e5a7630ec492ff510404fb1ad0f011634518d04.1455467089.git.varun@chelsio.com>
	 <20160301144921.GC9738@infradead.org> <20160302120044.GB1755@chelsio.com>
	 <1457214847.28660.64.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54689 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156AbcCGXW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 18:22:57 -0500
In-Reply-To: <1457214847.28660.64.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: Christoph Hellwig <hch@infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "roland@kernel.org" <roland@kernel.org>, SWise OGC <swise@opengridcomputing.com>, Indranil Choudhury <indranil@chelsio.com>, Karen Xie <kxie@chelsio.com>, Hariprasad S <hariprasad@chelsio.com>

On Sat, 2016-03-05 at 13:54 -0800, Nicholas A. Bellinger wrote:
> Hi Varun & Co,
> 
> On Wed, 2016-03-02 at 17:30 +0530, Varun Prakash wrote:
> > On Tue, Mar 01, 2016 at 08:19:21PM +0530, Christoph Hellwig wrote:
> > > This looks like pretty random exports and not something like a well
> > > defined interface to me :(
> > 
> > I have exported functions which works on iscsi-target data structures
> > and can be reused by offload drivers.
> 
> The main point here for cxgbit, as-is it's duplicating a lot of code vs.
> existing TCP code-paths using Linux/NET.
> 
> Many of these symbols are related to ->iscsit_immediate_queue() and
> ->cxgbit_response_queue() support, which for cxgbit vs. existing TCP can
> both benefit using common code.
> 
> That is, to start cxgbit should avoid using these two specific callbacks
> originally intended for iser-target, and for supporting traditional
> iscsi hw offloads we'll need to pursue:
> 
>   - New iscsit_transport per PDU callbacks invoked from 
>     iscsit_immediate_queue() + iscsit_response_queue() in 
>     iscsi_target.c, or
> 
>   - New iscsit_transport per PDU callbacks invoked from
>     iscsi_send_$PDU() in iscsi_target.c.
>    

So obviously this is going to take longer to sort out, and likely not
end up being v4.6-rc1 material.  That is OK, as the end result will be
better code.  :)

That said, it would make sense do the initial merge of the
drivers/net/ethernet/chelsio/cxgb4/ + PPM prerequisites changes for
v4.6, and as many basic prerequisites for iscsi-target for ISO as
possible in the short time we have.

Wrt to drivers/net/ethernet/chelsio/cxgb4/ changes, please have person
from Chelsio give their 'Reviewed-by' and 'Signed-off-by' to this
initial series, and make sure they get posted as stand-alone patches
ASAP to net-dev w/ DaveM in the loop.

I'm still happy to push these via target-pending/for-next-merge to get
the ball rolling for post v4.6 development, as long as they have the
extra reviews + signed-off-by from Chelsio folks, and DaveM doesn't have
any objections.

