From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 09:35:33 -0500
Message-ID: <5177EDB5.5000105@tributary.com>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike> <5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de> <5177CB23.5090802@redhat.com> <5177CFB6.9070105@redhat.com> <5177D6C2.6080705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.57]:31680 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab3DXOfj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 10:35:39 -0400
In-Reply-To: <5177D6C2.6080705@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Black, David" <david.black@emc.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>

On 4/24/2013 7:57 AM, Paolo Bonzini wrote:
>> If the device can promise this, we don't care (and don't know) how it 
>> manages that promise. It can leave the data on battery backed DRAM, can 
>> archive it to flash or any other scheme that works.
> 
> That's exactly the point of SYNC_NV=1.

	Well its the point, but the specification is written such that the vendors can
choose to implement it any way they wish, especially for split cache
systems where there is both volatile and non volatile cache.

	Flushing the NV cache to medium (as is the current behavior) may not be a bad
idea anyway.

	Thats because I know of a large vendors array where the non-volatile cache
might be better described as the "sometimes" non-volatile cache. That is because
a failure to flush the volatile portions results in the non-volatile portions
being considered invalid when power is restored. This fences the volume, and the
usual method for recovering the array is to call support and have them
invalidate the NV portions of the cache. Thereby negating the whole reason for
having a NV cache. I'm sure they don't tell customers this fact when they sell
the array, when it happened in our lab I was in a state of shock for about a week.


	






