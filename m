From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Tue, 5 May 2015 17:27:17 +0200
Message-ID: <5548E155.70007@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
	 <1430410094.102408.71.camel@redhat.com> <55488BAE.7070006@sandisk.com>
	 <1430835029.2407.187.camel@redhat.com> <5548D2FF.7030501@sandisk.com>
 <1430838637.2407.209.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0083.outbound.protection.outlook.com ([157.56.110.83]:54272
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993387AbbEEP1Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 May 2015 11:27:24 -0400
In-Reply-To: <1430838637.2407.209.camel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/05/15 17:10, Doug Ledford wrote:
> On Tue, 2015-05-05 at 16:26 +0200, Bart Van Assche wrote:
>> On 05/05/15 16:10, Doug Ledford wrote:
>>> However, while looking through the driver to research this, I noticed
>>> something else that seems more important if you ask me.  With this patch
>>> we now implement individual channel connection tracking.  However, in
>>> srp_queuecommand() you pick the channel based on the tag, and the blk
>>> layer has no idea of these disconnects, so the blk layer is free to
>>> assign a tag/channel to a channel that's disconnected, and then as best
>>> I can tell, you will simply try to post a work request to a channel
>>> that's already disconnected, which I would expect to fail if we have
>>> already disconnected this particular qp and not brought up a new one
>>> yet.  So it seems to me there is a race condition between new incoming
>>> SCSI commands and this disconnect/reconnect window, and that maybe we
>>> should be sending these commands back to the mid layer for requeueing
>>> when the channel the blk_mq tag points to is disconnected.  Or am I
>>> missing something in there?
>>
>> Hello Doug,
>>
>> Around the time a cable disconnect or other link layer failure is
>> detected by the SRP initiator or any other SCSI LLD it is unavoidable
>> that one or more SCSI requests fail. It is up to a higher layer (e.g.
>> dm-multipath + multipathd) to decide what to do with such requests, e.g.
>> queue these requests and resend these over another path.
>
> Sure, but that wasn't my point.  My point was that if you know the
> channel is disconnected, then why don't you go immediately to the
> correct action in queuecommand (where correct action could be requeue
> waiting on reconnect or return with error, whatever is appropriate)?
> Instead you attempt to post a command to a known disconnected queue
> pair.
>
>> The SRP initiator driver has been tested thoroughly with the multipath
>> queue_if_no_path policy, with a fio job with I/O verification enabled
>> running on top of a dm device while concurrently repeatedly simulating
>> link layer failures (via ibportstate).
>
> Part of my questions here are because I don't know how the blk_mq
> handles certain conditions.  However, your testing above only handles
> one case: all channels get dropped.  As unlikely it may be, what if
> resource constraints caused just one channel to be dropped out of the
> bunch and the others stayed alive?  Then the blk_mq would see requests
> on just one queue come back errored, while the others finished
> successfully.  Does it drop that one queue out of rotation, or does it
> fail over the entire connection?

Hello Doug,

Sorry but I don't think that a SCSI LLD is the appropriate layer to 
choose between requeuing or failing a request. If multiple paths are 
available between an initiator system and a SAN and if one path fails 
only the multipath layer knows whether there are other working paths 
available. If a working path is still available then the request should 
be resent as soon as possible over another path. The multipath layer can 
only take such a decision after a SCSI LLD has failed a request.

If only one channel fails all other channels are disconnected and the 
transport layer error handling mechanism is started.

Bart.
