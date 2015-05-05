From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Tue, 5 May 2015 16:26:07 +0200
Message-ID: <5548D2FF.7030501@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
	 <1430410094.102408.71.camel@redhat.com> <55488BAE.7070006@sandisk.com>
 <1430835029.2407.187.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0065.outbound.protection.outlook.com ([65.55.169.65]:16752
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993176AbbEEO0P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 May 2015 10:26:15 -0400
In-Reply-To: <1430835029.2407.187.camel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/05/15 16:10, Doug Ledford wrote:
> However, while looking through the driver to research this, I noticed
> something else that seems more important if you ask me.  With this patch
> we now implement individual channel connection tracking.  However, in
> srp_queuecommand() you pick the channel based on the tag, and the blk
> layer has no idea of these disconnects, so the blk layer is free to
> assign a tag/channel to a channel that's disconnected, and then as best
> I can tell, you will simply try to post a work request to a channel
> that's already disconnected, which I would expect to fail if we have
> already disconnected this particular qp and not brought up a new one
> yet.  So it seems to me there is a race condition between new incoming
> SCSI commands and this disconnect/reconnect window, and that maybe we
> should be sending these commands back to the mid layer for requeueing
> when the channel the blk_mq tag points to is disconnected.  Or am I
> missing something in there?

Hello Doug,

Around the time a cable disconnect or other link layer failure is 
detected by the SRP initiator or any other SCSI LLD it is unavoidable 
that one or more SCSI requests fail. It is up to a higher layer (e.g. 
dm-multipath + multipathd) to decide what to do with such requests, e.g. 
queue these requests and resend these over another path. The SRP 
initiator driver has been tested thoroughly with the multipath 
queue_if_no_path policy, with a fio job with I/O verification enabled 
running on top of a dm device while concurrently repeatedly simulating 
link layer failures (via ibportstate).

Bart.

