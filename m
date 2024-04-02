Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8AB15AAC7;
	Tue,  2 Apr 2024 18:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712081102; cv=none; b=S427S4cGD5Vi4DHclB8Od7zKeGWcXGv0biSGNmPe5JolXEtRE9sbyw13EuZIcg3SkBhAYU/mSRi7Cxc9ikgb587Z6GyBaPBa8ITZXKd1jfPJZrjjp3yxVue/VvaRJAPqVpyV93n0g4Xrfdcu9+VHHcqc+xI1ESO75xY3oHE6tzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712081102; c=relaxed/simple;
	bh=mdG+l3vtPmocX6jZiGJjU95PFnIAcgR4kd6bb5sBz5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gOMAI8Cu9SolkK2Ev1S/Nf0S5XEO8zXdwwKrwtRVJVLhpGxTZPbgsJUsvOiwl41AiLdlZ0I2rRvnLpJPMLm8TITQ14dHPD4pR0PSrQLDGIN7QVpUR037557E9c5xQLYlSiOWP9tsD+HQPBHIWm8j63woFk7XkoEiO3q5cvVhTiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bsn5Zk8V; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H+ef85c8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bsn5Zk8V";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H+ef85c8"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE64C5C0EC;
	Tue,  2 Apr 2024 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712081098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FPQkd5zu6C1/+k4GfuvHQdVyB/R8CdMAIKEzldm7abw=;
	b=bsn5Zk8VgLt72aCAhN5unPjcE2081lTCngz4plimtsJNixERSgMloCO5iAxG1OuzTrvJW/
	SQ8Lyg29lFuPvlqgHS02jZI8KINxweUoLzoVO+1+KhE4OoRBT3mNRzvCKT+sDzI9DUNJKU
	vSKkkV/ltiRt/wZrT64GoXo/5lB488I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712081098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FPQkd5zu6C1/+k4GfuvHQdVyB/R8CdMAIKEzldm7abw=;
	b=H+ef85c8crymYbZjEYw/y+a0iP991AZDJgJ8NI1nXTqpz2kZvCIJeOKQVi4Ui/bZxYJ3o3
	1it2yRMI7kGx3TAw==
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A70913A90;
	Tue,  2 Apr 2024 18:04:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id ocGyD8pIDGbwMAAAn2gu4w
	(envelope-from <hare@suse.de>); Tue, 02 Apr 2024 18:04:58 +0000
Message-ID: <4bfe5995-2607-45b7-a104-0a01e27c28bf@suse.de>
Date: Tue, 2 Apr 2024 20:04:57 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/28] block: Remember zone capacity when revalidating
 zones
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-7-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240402123907.512027-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Score: -3.29
X-Spam-Level: 
X-Spam-Flag: NO

On 4/2/24 14:38, Damien Le Moal wrote:
> In preparation for adding zone write plugging, modify
> blk_revalidate_disk_zones() to get the capacity of zones of a zoned
> block device. This capacity value as a number of 512B sectors is stored
> in the gendisk zone_capacity field.
> 
> Given that host-managed SMR disks (including zoned UFS drives) and all
> known NVMe ZNS devices have the same zone capacity for all zones
> blk_revalidate_disk_zones() returns an error if different capacities are
> detected for different zones.
> 
> This also adds check to verify that the values reported by the device
> for zone capacities are correct, that is, that the zone capacity is
> never 0, does not exceed the zone size and is equal to the zone size for
> conventional zones.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-zoned.c      | 26 ++++++++++++++++++++++++++
>   include/linux/blkdev.h |  1 +
>   2 files changed, 27 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

