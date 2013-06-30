From: David Dillow <dave@thedillows.org>
Subject: Re: [PATCH v2 07/15] IB/srp: Keep rport as long as the IB transport
 layer
Date: Sun, 30 Jun 2013 17:06:52 -0400
Message-ID: <1372626412.12468.35.camel@haswell.thedillows.org>
References: <51CD856A.3010102@acm.org> <51CD8706.5010101@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:51148 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3F3VHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jun 2013 17:07:01 -0400
In-Reply-To: <51CD8706.5010101@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@kernel.org>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On Fri, 2013-06-28 at 14:52 +0200, Bart Van Assche wrote:
> Keep the rport data structure around after srp_remove_host() has
> finished until cleanup of the IB transport layer has finished
> completely. This is necessary because later patches use the rport
> pointer inside the queuecommand callback. Without this patch
> accessing the rport from inside a queuecommand callback is racy
> because srp_remove_host() must be invoked before scsi_remove_host()
> and because the queuecommand callback may get invoked after
> srp_remove_host() has finished.

Assuming the patches that require this are eventually accepted,

Acked-by: David Dillow <dillowda@ornl.gov>

