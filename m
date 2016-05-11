From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libfc: replace 'rp_mutex' with 'rp_lock'
Date: Wed, 11 May 2016 07:49:25 +0200
Message-ID: <5732C7E5.3000709@suse.de>
References: <1461571293-953-1-git-send-email-hare@suse.de>
 <57322963.7040507@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbcEKFt1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2016 01:49:27 -0400
In-Reply-To: <57322963.7040507@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 05/10/2016 08:33 PM, Bart Van Assche wrote:
> On 04/25/2016 01:01 AM, Hannes Reinecke wrote:
>> We cannot use an embedded mutex in a structure with reference
>> counting, as mutex unlock might be delayed, and the waiters
>> might then access an already freed memory area.
>> So convert it to a spinlock.
>>
>> For details cf https://lkml.org/lkml/2015/2/11/245
>=20
> Hello Hannes,
>=20
> Is what you describe a theoretical concern or have you observed any
> issues that could have been caused by the rport mutex? I'm asking
> this because my interpretation of the thread you refer to is
> different. My conclusion is that it is safe to embed a mutex in a
> structure that uses reference counting but that the mutex_unlock()
> call may trigger a spurious wakeup. I think that the conclusion of
> that thread was that glibc and kernel code should tolerate such
> spurious wakeups.
>=20
We have several bugzillas referring to that specific code.
Most notably triggered when removing target ports with and open-fcoe
HBA.

And this patch seems to resolve it.
Read: with this patch the issue doesn't occur anymore.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
