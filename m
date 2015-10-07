From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/36] scsi_dh_alua: Make stpg synchronous
Date: Wed, 7 Oct 2015 22:48:45 +0200
Message-ID: <5615852D.9060205@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <1443523658-87622-16-git-send-email-hare@suse.de>
 <560EBFFA.8010300@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbbJGUst (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Oct 2015 16:48:49 -0400
In-Reply-To: <560EBFFA.8010300@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 10/02/2015 07:33 PM, Bart Van Assche wrote:
> On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
>> The 'activate_complete' function needs to be executed after
>> stpg has finished, so we can as well execute stpg synchronously
>> and call the function directly.
>
> Hello Hannes,
>
> Another patch in this series moves invocation of the STPG commands to
> the context of a workqueue. The setup on which I have been testing th=
is
> patch series consists of an initiator system with four ports and a
> target system with eight ports and 100 LUNs. As a result, 4*8*100=3D3=
200
> /dev/sd* devices are created on the initiator system and monitored by
> the scsi_dh_alua handler. How many kernel threads will be needed to
> monitor all these paths concurrently and how much memory will be
> required for all these kernel threads ? What if the number of LUNs wo=
uld
> be even higher, e.g. 1000 ? Sorry but because of scalability concerns=
 my
> preference is that the RTPG and STPG commands are invoked asynchronou=
sly.
>
The paths are not 'monitored' in the normal sense, ie the workqueue is=20
not always active. The workqueue items is active only if a state change=
=20
needs to be handled.
I doubt that the overall resource usage will increase here, as=20
originally we would need to execute '->activate' for every path.
With the new design we will be starting a workqueue item _per port grou=
p=20
and LUN_, which will run until the new state could be successfully=20
retrieved.

I have considered using an asynchronous implementation, but sadly=20
scsi_execute() and friends doesn't have an asynchronous version.
Also we would need to handle quite a substantial bulk of computation
from within an interrupt handler, which would make the operation
really tricky.

We should be doing some analysis here to figure out if there really is=20
an increased memory usage and if this would turn out to be an issue.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
