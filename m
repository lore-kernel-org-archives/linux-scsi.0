From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: qla2xxx tcq question/bug
Date: Fri, 9 Jul 2004 16:46:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040709234644.GB14787@praka.san.rr.com>
References: <40EF2697.20804@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:2180 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S265977AbUGIX6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 19:58:00 -0400
Content-Disposition: inline
In-Reply-To: <40EF2697.20804@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: andrew.vasquez@qlogic.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 09 Jul 2004, Mike Christie wrote:

> For the qla2xxx driver in 2.6.7 there is this code:
> 
> /* Update tagged queuing modifier */
> cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
> if (cmd->device->tagged_supported) {
> 	switch (cmd->tag) {
> 		case HEAD_OF_QUEUE_TAG:
> 			cmd_pkt->control_flags =
> 			__constant_cpu_to_le16(CF_HEAD_TAG);
> 			break;
> 		case ORDERED_QUEUE_TAG:
> 			cmd_pkt->control_flags =
> 			__constant_cpu_to_le16(CF_ORDERED_TAG);
> 			break;
> 	}
> }
> 
> but do you know where/how cmd->tag gets set? It looks like it gets
> copied from req->tag in the scsi_prep_fn, but for drivers that do not
> call scsi_actiavte_tcq that value never gets touched by the block
> layer. Even for drivers that do call scsi_activate_tcq, the req->tag
> value is just the tag nr, and those drivers will use scsi_populate_msg
> to get the task attribute. req->tag gets copied in the prep_fn and
> does not get set until after the request_fn has prepared the request so
> really cmd->tag looks like it is junk for every case.
> 

The driver's slave_configure() call back will issue a
scsi_adjust_queue_depth() call for all sdev->tagged_supported devices,
relevant code:

	...
	if (sdev->tagged_supported) {
		if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
			queue_depth = ql2xmaxqdepth;

		ql2xmaxqdepth = queue_depth;

		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
		   queue_depth);
		...

Which is similar to the implementation of scsi_activate_tcq():

	if (sdev->tagged_supported) {
		if (!blk_queue_tagged(sdev->request_queue))
			blk_queue_init_tags(sdev->request_queue,
			   depth, NULL);
		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
	}

What's missing of course is the blk_queue_init_tags() call.

> Is this usage from 2.4? 
>

Yes, the code can be traced back to our 4.x driver from 2+ years ago.

> Should the qla2xx driver be calling
> scsi_activate_tcq/scsi_populate_msg for devices that support tags,

Could I get a definitive answer on this from the group?  It certainly
does appear that we are missing the block-layer allocation of the tag
map.

> or is that a waste becuase you never use the tag number and all you
> really want is the attribute?
> 

I've taken a look through the ipr code (the only visible caller of
scsi_populate_tag_msg()) -- looks like the qla driver has some
problems here.

--
Andrew Vasquez
