Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD0614A4E0;
	Wed,  3 Apr 2024 15:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712158092; cv=none; b=lwlBPVCY08BmDenYcbdwOZVzgRzxSr8JPv6BJvlkktwWhsPz4Z+qjeUql8GK8zir0LTZTE7FMHd2yaG29X8UyMSEyngUEGOnFEbu+jKyu1IsBWrwm7U3q7OhDFzltil1YX8nZsA1gmySiXDGeopdTkGiN+TJeOJ959E5+b/WmOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712158092; c=relaxed/simple;
	bh=cATIjMK3aumD/SpEKnqqVEZrsX5ySTg0KoSuAKsm2Zs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dWRy27YRqOUsia8trmAaP5Ff0qBWsgvnfnLDG5Y2ZOWgCucuBukqLi75n+zqN17wixL1bztQVsKdOhEZcKnoBS+fhf6/D1qw3aF8+oZazTqB/iSpzZFq4zxTx3Nlg7CgOHEKhbX5mb0GDVCvWfEkiOaSrccQAnKsqgtfFEnxQRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QW07L4L2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PsClbm1g; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QW07L4L2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PsClbm1g"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA5323720E;
	Wed,  3 Apr 2024 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712158088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0irQ8tS4A/FZFoI6eW6Nr7AOJ80BlvhlW3CE1jxJ+pQ=;
	b=QW07L4L2J+XUJvwomyATIPF48zQMieOFlTOFemqn26gZpRb3AhamG1NjrliPAvWRfipNpK
	IJfJr055H+lLqwAk/cwS9SJkE2vyYFUlqBcgE/9QbuzT7g+HKciTFunWw7qr8nvXJ8BTRf
	QCOOH5OYHkEEP7H9YJlMyulhPVcbF4Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712158088;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0irQ8tS4A/FZFoI6eW6Nr7AOJ80BlvhlW3CE1jxJ+pQ=;
	b=PsClbm1grC4Xdca5ju5oNq0Y7NeyhUVhDz41AgYGVdYV23XFQ7F80qYrJY0SNAG5dGkUXK
	l9rQCXyGP9CjqFBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 582CF13357;
	Wed,  3 Apr 2024 15:28:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id fMdgEoh1DWaMdAAAn2gu4w
	(envelope-from <hare@suse.de>); Wed, 03 Apr 2024 15:28:08 +0000
Message-ID: <5c89baf3-68f1-4e91-8fa9-efa183297ca8@suse.de>
Date: Wed, 3 Apr 2024 17:28:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/28] block: Introduce zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org>
 <20240403084247.856481-8-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240403084247.856481-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA5323720E
X-Spamd-Result: default: False [-3.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_SHORT(-0.19)[-0.970];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	R_DKIM_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:98:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap2.dmz-prg2.suse.org:rdns,imap2.dmz-prg2.suse.org:helo]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Score: -3.29
X-Spam-Level: 
X-Spam-Flag: NO

On 4/3/24 10:42, Damien Le Moal wrote:
> Zone write plugging implements a per-zone "plug" for write operations
> to control the submission and execution order of write operations to
> sequential write required zones of a zoned block device. Per-zone
> plugging guarantees that at any time there is at most only one write
> request per zone being executed. This mechanism is intended to replace
> zone write locking which implements a similar per-zone write throttling
> at the scheduler level, but is implemented only by mq-deadline.
> 
> Unlike zone write locking which operates on requests, zone write
> plugging operates on BIOs. A zone write plug is simply a BIO list that
> is atomically manipulated using a spinlock and a kblockd submission
> work. A write BIO to a zone is "plugged" to delay its execution if a
> write BIO for the same zone was already issued, that is, if a write
> request for the same zone is being executed. The next plugged BIO is
> unplugged and issued once the write request completes.
> 
> This mechanism allows to:
>   - Untangle zone write ordering from block IO schedulers. This allows
>     removing the restriction on using mq-deadline for writing to zoned
>     block devices. Any block IO scheduler, including "none" can be used.
>   - Zone write plugging operates on BIOs instead of requests. Plugged
>     BIOs waiting for execution thus do not hold scheduling tags and thus
>     are not preventing other BIOs from executing (reads or writes to
>     other zones). Depending on the workload, this can significantly
>     improve the device use (higher queue depth operation) and
>     performance.
>   - Both blk-mq (request based) zoned devices and BIO-based zoned devices
>     (e.g.  device mapper) can use zone write plugging. It is mandatory
>     for the former but optional for the latter. BIO-based drivers can
>     use zone write plugging to implement write ordering guarantees, or
>     the drivers can implement their own if needed.
>   - The code is less invasive in the block layer and is mostly limited to
>     blk-zoned.c with some small changes in blk-mq.c, blk-merge.c and
>     bio.c.
> 
> Zone write plugging is implemented using struct blk_zone_wplug. This
> structure includes a spinlock, a BIO list and a work structure to
> handle the submission of plugged BIOs. Zone write plugs structures are
> managed using a per-disk hash table.
> 
> Plugging of zone write BIOs is done using the function
> blk_zone_write_plug_bio() which returns false if a BIO execution does
> not need to be delayed and true otherwise. This function is called
> from blk_mq_submit_bio() after a BIO is split to avoid large BIOs
> spanning multiple zones which would cause mishandling of zone write
> plugs. This ichange enables by default zone write plugging for any mq
> request-based block device. BIO-based device drivers can also use zone
> write plugging by expliclty calling blk_zone_write_plug_bio() in their
> ->submit_bio method. For such devices, the driver must ensure that a
> BIO passed to blk_zone_write_plug_bio() is already split and not
> straddling zone boundaries.
> 
> Only write and write zeroes BIOs are plugged. Zone write plugging does
> not introduce any significant overhead for other operations. A BIO that
> is being handled through zone write plugging is flagged using the new
> BIO flag BIO_ZONE_WRITE_PLUGGING. A request handling a BIO flagged with
> this new flag is flagged with the new RQF_ZONE_WRITE_PLUGGING flag.
> The completion of BIOs and requests flagged trigger respectively calls
> to the functions blk_zone_write_bio_endio() and
> blk_zone_write_complete_request(). The latter function is used to
> trigger submission of the next plugged BIO using the zone plug work.
> blk_zone_write_bio_endio() does the same for BIO-based devices.
> This ensures that at any time, at most one request (blk-mq devices) or
> one BIO (BIO-based devices) is being executed for any zone. The
> handling of zone write plugs using a per-zone plug spinlock maximizes
> parallelism and device usage by allowing multiple zones to be writen
> simultaneously without lock contention.
> 
> Zone write plugging ignores flush BIOs without data. Hovever, any flush
> BIO that has data is always plugged so that the write part of the flush
> sequence is serialized with other regular writes.
> 
> Given that any BIO handled through zone write plugging will be the only
> BIO in flight for the target zone when it is executed, the unplugging
> and submission of a BIO will have no chance of successfully merging with
> plugged requests or requests in the scheduler. To overcome this
> potential performance degradation, blk_mq_submit_bio() calls the
> function blk_zone_write_plug_attempt_merge() to try to merge other
> plugged BIOs with the one just unplugged and submitted. Successful
> merging is signaled using blk_zone_write_plug_bio_merged(), called from
> bio_attempt_back_merge(). Furthermore, to avoid recalculating the number
> of segments of plugged BIOs to attempt merging, the number of segments
> of a plugged BIO is saved using the new struct bio field
> __bi_nr_segments. To avoid growing the size of struct bio, this field is
> added as a union with the bio_cookie field. This is safe to do as
> polling is always disabled for plugged BIOs.
> 
> When BIOs are plugged in a zone write plug, the device request queue
> usage counter is always incremented. This reference is kept and reused
> for blk-mq devices when the plugged BIO is unplugged and submitted
> again using submit_bio_noacct_nocheck(). For this case, the unplugged
> BIO is already flagged with BIO_ZONE_WRITE_PLUGGING and
> blk_mq_submit_bio() proceeds directly to allocating a new request for
> the BIO, re-using the usage reference count taken when the BIO was
> plugged. This extra reference count is dropped in
> blk_zone_write_plug_attempt_merge() for any plugged BIO that is
> successfully merged. Given that BIO-based devices will not take this
> path, the extra reference is dropped after a plugged BIO is unplugged
> and submitted.
> 
> Zone write plugs are dynamically allocated and managed using a hash
> table (an array of struct hlist_head) with RCU protection.
> A zone write plug is allocated when a write BIO is received for the
> zone and not freed until the zone is fully written, reset or finished.
> To detect when a zone write plug can be freed, the write state of each
> zone is tracked using a write pointer offset which corresponds to the
> offset of a zone write pointer relative to the zone start. Write
> operations always increment this write pointer offset. Zone reset
> operations set it to 0 and zone finish operations set it to the zone
> size.
> 
> If a write error happens, the wp_offset value of a zone write plug may
> become incorrect and out of sync with the device managed write pointer.
> This is handled using the zone write plug flag BLK_ZONE_WPLUG_ERROR.
> The function blk_zone_wplug_handle_error() is called from the new disk
> zone write plug work when this flag is set. This function executes a
> report zone to update the zone write pointer offset to the current
> value as indicated by the device. The disk zone write plug work is
> scheduled whenever a BIO flagged with BIO_ZONE_WRITE_PLUGGING completes
> with an error or when bio_zone_wplug_prepare_bio() detects an unaligned
> write. Once scheduled, the disk zone write plugs work keeps running
> until all zone errors are handled.
> 
> To match the new data structures used for zoned disks, the function
> disk_free_zone_bitmaps() is renamed to the more generic
> disk_free_zone_resources(). The function disk_init_zone_resources() is
> also introduced to initialize zone write plugs resources when a gendisk
> is allocated.
> 
> In order to guarantee that the user can simultaneously write up to a
> number of zones equal to a device max active zone limit or max open zone
> limit, zone write plugs are allocated using a mempool sized to the
> maximum of these 2 device limits. For a device that does not have
> active and open zone limits, 128 is used as the default mempool size.
> 
> If a change to the device active and open zone limits is detected, the
> disk mempool is resized when blk_revalidate_disk_zones() is executed.
> 
> This commit contains contributions from Christoph Hellwig <hch@lst.de>.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/bio.c               |    6 +
>   block/blk-merge.c         |   11 +
>   block/blk-mq.c            |   32 +-
>   block/blk-zoned.c         | 1090 ++++++++++++++++++++++++++++++++++++-
>   block/blk.h               |   47 +-
>   block/genhd.c             |    3 +-
>   include/linux/blk-mq.h    |    2 +
>   include/linux/blk_types.h |    8 +-
>   include/linux/blkdev.h    |   12 +
>   9 files changed, 1200 insertions(+), 11 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

