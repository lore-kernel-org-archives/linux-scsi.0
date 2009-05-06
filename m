From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/8] fcoe: reduces lock cost when adding a new skb to
	fcoe_pending_queue
Date: Wed, 06 May 2009 13:09:24 -0500
Message-ID: <1241633364.3322.39.camel@mulgrave.int.hansenpartnership.com>
References: <20090506175206.26695.19457.stgit@fritz>
	 <20090506175234.26695.38431.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60287 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755335AbZEFSJ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 14:09:26 -0400
In-Reply-To: <20090506175234.26695.38431.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@intel.com>

On Wed, 2009-05-06 at 10:52 -0700, Robert Love wrote:
> From: Vasu Dev <vasu.dev@intel.com>
> 
> Currently fcoe_pending_queue.lock held twice for every new skb
> adding to this queue when already least one pkt is pending in this
> queue and that is not uncommon once skb pkts starts getting queued
> here upon fcoe_start_io => dev_queue_xmit failure.
> 
> This patch moves most fcoe_pending_queue logic to fcoe_check_wait_queue
> function, this new logic grabs fcoe_pending_queue.lock only once to
> add a new skb instead twice as used to be.
> 
> I think after this patch call flow around fcoe_check_wait_queue
> calling in fcoe_xmit is bit simplified with modified
> fcoe_check_wait_queue function taking care of adding and
> removing pending skb in one function.

This isn't really a -rc4 bug fix, is it?  It reads a lot more like a
feature enhancement that was given a bug like description.

James


