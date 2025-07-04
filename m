Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEB22F2C73
	for <linux-scsi@vger.kernel.org>; Fri,  4 Jul 2025 10:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751624934; cv=none; b=NMObfBNpbcyKSjn9D6ZkjPwEaeo3kFiQuyTXOPLB5dCvqCC+cCsW0AWwcWSuQKSypJBt/qTsx7iICWvjwDKsJJtLK9YQvDB7YWKG6Tfg4vracc3Zyu05LiMMaNOnqeI/b9Xu8AwPaysy93LF0TkG/9skpnc7g+uR+5N6NB7gC20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751624934; c=relaxed/simple;
	bh=HWc+E+Y+oEvX6KCOwYd7QdbU5fnDf3kJeZgNpg+MTSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PnkMlF/lYdvm6VqcYGYg6afEss0/gQyZoolDoRbTTjLzqyX7E1Y16sStoFOyqd0YFsanRWkeC5w+t84SMDYb0EJ+EjAF8hbzK9xNBlZnlFj1Rot+6vF1HzZiPewtem3Rt+ooq3OfcqyJpatYG12fH97KH8KuUgCiJWDKYa5364M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D27C821197;
	Fri,  4 Jul 2025 10:28:50 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F4CE13A71;
	Fri,  4 Jul 2025 10:28:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SWmdEuKsZ2gINwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 04 Jul 2025 10:28:50 +0000
Message-ID: <c06d0ef2-6bd2-4f5d-895f-0255415b2a24@suse.de>
Date: Fri, 4 Jul 2025 12:28:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/10] scsi: Use block layer helpers to constrain queue
 affinity
To: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>,
 Aaron Tomlin <atomlin@atomlin.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin
 <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, storagedev@microchip.com,
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-5-557aa7eacce4@kernel.org>
 <d95de280-8cd7-4697-933a-37dc53f4c552@suse.de>
 <2e7576e4-442f-4000-817d-6253374f5818@flourine.local>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <2e7576e4-442f-4000-817d-6253374f5818@flourine.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: D27C821197
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00

On 7/4/25 11:37, Daniel Wagner wrote:
> On Thu, Jul 03, 2025 at 08:43:01AM +0200, Hannes Reinecke wrote:
>> All of these drivers are not aware of CPU hotplug, and as such
>> will not be notified when the number of CPUs changes.
> 
> Ah, this explains this part.
> 
>> But you use 'blk_mq_online_queue_affinity()' for all of these
>> drivers.
> 
> All these drivers are also using blk_mq_num_online_queue. When I only
> used cpu_possible_mask the resulting mapping was not usable.
> 
Yeah, I'd imagine so. Quite some drivers have 'interesting' ideas how
the firmware interface should look like.

But it also means that there is a very high likelyhood that these
drivers become inoperable under CPU hotplug.
Is there a way of disabling CPU hotplug when these drivers are in use?

>> Wouldn't 'blk_mq_possible_queue_affinit()' a better choice here
>> to insulate against CPU hotplug effects?
> 
> With this mask the queues will be distributed to all possible CPUs and
> some of the hardware queues could be assigned to offline CPUs. I think
> this would work but the question is, is this okay to leave some of the
> perfomance on the road?
> 
It really shouldn't be an issue when the cpus are distributed 
'correctly' :-)
We have several possibilities:
-> #hwq > num_possible_cpus: easy, 1:1 mapping, no problem
-> num_online_cpu < #hwq < num_possible_cpus: Not as easy, but if we
    ensure that each online cpu is mapped to a different hwq we don't
    have a performance impact.
-> #hwq < num_online_cpu: If we ensure that a) the number of online cpus
    per hwq is (roughly) identical we won't have a performance impact.
    As a bonus we should strive to have the number of offline cpus
    distributed equally on each hwq.

Of course, that doesn't take into accound NUMA locality; with NUMA 
locality you would need to ensure to have at least one CPU per NUMA node
mapped to each hwq. Which actually would impose a lower limit on the
number (and granularity!) of hwqs (namely the number of NUMA nodes), but 
that's fair, I guess.

But this really can be delegated to later patches; initially we really
should identify which drivers might have issues with CPU hotplug,
and at the very least issue a warning for these drivers.

> I am not against this, just saying it would change the existing
> behavior.
> 

Oh, sure. No-one (except lpfc on Power) is testing CPU hotplug actively.

>> Also some drivers which are using irq affinity (eg aacraid, lpfc) are
>> missing from these conversions. Why?
> 
> I was not aware of aacraid. I started to work on lpfc and well let's put
> it this way, it's complicated. lpfc needs a lot of work to make it
> isolcpus aware.

Yeah, I know. Sorry ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
