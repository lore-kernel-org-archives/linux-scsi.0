From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] virtio_scsi: Enable new EH timeout handler
Date: Fri, 30 Aug 2013 05:45:42 -0700
Message-ID: <20130830124541.GA4107@infradead.org>
References: <1377783140-57191-1-git-send-email-hare@suse.de>
 <1377783140-57191-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3H3Mpt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Aug 2013 08:45:49 -0400
Content-Disposition: inline
In-Reply-To: <1377783140-57191-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

>  
> +static enum blk_eh_timer_return virtscsi_timedout(struct scsi_cmnd *scmd)
> +{
> +	scsi_abort_command(scmd);
> +	return BLK_EH_SCHEDULED;
> +}

just set the method vector to scsi_abort_command here and in all the
other trivial conversions instead of having all those pointless
wrappers.

