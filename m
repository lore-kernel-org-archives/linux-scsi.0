Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795858008;
	b=q8hY/JzsnMhYPQbpdGmfnhHdqsZnyNG15OjrhO/ijsmhgZM/OvU8ddbO777pFHvmDyK1
	 Glk+0xLl329zXK1QDoxwBPOnrovYw3RwN1caaG+9+Kb7Uv/3XiZOmP72rK32SUaxVHC9v
	 G0gJ5DfFywZwTN+Cns1iIGVTDahRtA9rFbR7R4ZlORg1ZjEL7ZfuWaUcw2IIyKOYGNVRD
	 UMqvNXmmQOHfvr4ipT34ksI9JO4f12wFwPDQk1J/dvqRxqV/v7SA37QCt8JsrSWCu3kQn
	 0DmOZ3BQ0fSTqrGNak1JwOoCskzgwtgMWktvqYLXHWVr2zVZGARJYy8Jsg2I7VkAmcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795858008;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:User-Agent;
	bh=FGlvqIex45DiqLn3rsPpN4duJ1MiIAw9VO0j2DhNuqs=;
	b=ui/cqeLM21IOZ+iFos5J9ucJocV0GWIWMQpqIIYzAiH5+br/8BHZqb9gKHg9215fX7gB
	 ZsSG/d/cT8WiUa9Blg47nYz5BWJNPlQ9i4jLFnJZdWWYpcXAL007UPbpVM/i77ZCBeR98
	 QTYLVziwegOAgfUdhbg62D02zBYAXpCZ6Sp2UQpIZ3/MwXO7O6F3G68U/eS6rt/ew1rO9
	 2A4I+vsdyy2GhwXOi5k7mJ9nVTXU7U6NjRFPk4g6g4YzrMDDuylBRgC0dM7Muizz2kWHq
	 HvxV6IhiHkuFQlV8HbDk6Dd3LvcRnbwXQ0TjRV5a0LW/xjqdgodwDUlP0nkQJh/m9cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=HAJHm62J;
	arc=none smtp.remote-ip=74.125.224.44
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0F9606A6B9
	for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 09:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA0F9606A6B9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=HAJHm62J
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67daffde88dso5186393d50.2
        for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 01:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795858007; x=1796462807; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FGlvqIex45DiqLn3rsPpN4duJ1MiIAw9VO0j2DhNuqs=;
        b=HAJHm62JmBAlu2F4/yF7GuT15nWvDDE5mLSPRLD0O9KIUWqYXg7UvzIslafojr6GJc
         EAv2HjGtfI+B4QF3UKOll41x404gBsziajeZAlV8ck/8coJxk/LGR30IdxFnKHL3hzqC
         uwek4LxEIHZvtgHoxt+oeKiPNDRt8YM1bY5yg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795858007; x=1796462807;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FGlvqIex45DiqLn3rsPpN4duJ1MiIAw9VO0j2DhNuqs=;
        b=0tIhoKVQ/Vg42kE0+S2NnZ4nabM7eJrdsq3FpKmPesF+sC6xhMkcAU6S+xDz/hn84M
         SROEE3LNp2Q7UDMksYrXTh71wuI96UEXXIWvfomZw/5J55XTNKbBvgf91FoVWpCo3E1s
         WR7DCfi7fyRNIb5t22XkdIiWC+hnkGfyqZHdIJI1h6t6wAziihyVdT3YUL5tWUd5+aME
         lueSbIwegr8P7OcqDh3T10Kovk6NGZW2lKo8TjH/ylSOzGO6rrLxbcTCLFkOo8coGNaJ
         nfw+qTA7NXawvMtqJR6ONoAyEPHUwJpm9ZeC5rhX2Ad5mD8l/z1WA964Rasfrtf+u5f2
         S46Q==
X-Forwarded-Encrypted: i=1; AL+hErHlkilBvLIGyg4hAK8WhblpXEZyEqaeEZDnum9jKWfbS/Wm7U9UXjPmj808XKK30QZh6w5QONhMhBPl@vger.kernel.org
X-Gm-Message-State: APuU4Z/wYP3lhii9Xp2Vw3XNIxnbuwpcN16mCiDjRBx+WjdDG2a8is/h
	7y2r0WeN1RltPRkKKg2Mjt/jZcJav2FZL1YnRWf7Y4awdmYVw2Wfz2396BrrK45xCuo=
X-Gm-Gg: AZFdTZc9Coc2sCYP4eIKIm2/bKXZFawiYRNEAaBWQqK76cRdc3tReUqDIowrfixQ1xA
	2tK+4pfgRBD5cgNGpV+9ZApx4Lfwxj5LD/OnvLkY+QZilKf9XJnMOPOkemN+Q3bYakFK5PiszbX
	aHG8Vijd0VicVhd+xQg5TryI24ErL4Gy1hK3IT1qBdZr9rqFUDsX4prPniQtNaANEo3P6anXvyc
	/AmypRXCpN9sxLDOEWxRWlXeDbSMD2FeabPEsOcGPIFkl7/e8OQ33GV7jBA1Bk7s3WgGrbyfwde
	jxD8ZDglsRAVmsbghcTUGXLBx/dfUzZ3+CqNjDJKGZb0k3ai9OdV6D+8U/ou97VR01UymCj8HCv
	bjW5HsKjqOGOdy9XS+UUzJYOnB6xbNg6O3CKGxDJIYiE9NMG2C23GQ6M84DsKiSrhtpWNGB0F2Y
	zW/OZwOar8NZE20iuOre+fXRjiB1k6Kv2iWrR68xCgKq4TW5wRSaST2eilvjPh8vwTxEutJ6o8t
	a9QY/uxwenKxSZUIHYHOoaVzM3LjQqranB545DpUacklr34XC4W4bu3xqc8KLd6AKW0Q5ifqZfF
	RKR7hhOzim3RqfCvlzw6dgtZRqhLyvozIawOysCvy4W8D0CNZTfG83R0S+M1jYlbWb1QA0Jm4j9
	nBbJXh+3Z46z78xNALn6U9LbG7XkOa4wckNqUpMmXOq22a55j4M9sK35QpCpoWoi6HLESZIg43U
	+ScKTDdev3t1ASjPFaTRt16WpsbnysQVHm005izgf3zlbIyJ3SW8XwxlLb0AXd7rktfepllffWo
	lH7KqZFue4HAu11+Gd5Yf8D
X-Received: by 2002:a05:690e:12c7:b0:679:2c7b:de5f with SMTP id 956f58d0204a3-67e314d4c18mr6074694d50.159.1795858006809;
        Sat, 28 Nov 2026 01:26:46 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b5202b09c6sm106779637b3.17.2026.11.28.01.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:26:45 -0800 (PST)
Date: Sat, 28 Nov 2026 01:26:44 -0800
From: Chris Down <chris@chrisdown.name>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 2/2] scsi: sd: Fix data corruption in WRITE SAME(10)
	discards
In-Reply-To: <20261111164705.GC18355@lst.de>
References: <cover.1794069087.git.chris@chrisdown.name>
	<c58578f870580f92d1acd6cb73b59b7a7867d80b.1794069087.git.chris@chrisdown.name>
	<20261111164705.GC18355@lst.de>
Message-ID: <awqeVFzX-t35Vvs4@chrisdown.name>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christoph,

Christoph Hellwig writes:
>Nah, that's not really how things work.  See my reply to patch 1
>for the suggested proper fix.

Sure, I'll do the same for writesame_10 and writesame_zero in v2.

Even with that, a discard can still reach sd_setup_write_same10_cmnd()
with a count that doesn't fit, though.

One case is a discard that is already queued when the mode changes. sd
sets provisioning_mode before it freezes the queue to commit the new
limits, so that request is still sized for the old mode. For that one
I'll set the mode with the queue frozen instead, as
nvme_update_ns_info_block() does for its own state.

The other is that __bio_split_discard() doesn't split a discard at all
when max_discard_sectors is zero or below the discard granularity. With
scsi_debug, 512-byte blocks and an unmap granularity of 0x10000 blocks,
a 64 MiB discard in writesame_10 mode goes out as a single WRITE
SAME(10) with a count of zero. sd can avoid that one by disabling
discard when the granularity is above its limit, as drbd does. But
writing 0 to discard_max_bytes while a large discard is running also
sends the rest of the bio to sd unsplit, and I don't see how sd can
prevent that with its limits.

An LBA that doesn't fit can still get there as well. bio_check_eod()
only checks a bio against the partition it was submitted to. If a disk
shrinks to 2^32 blocks or fewer while a partition on it still ends
above that, a discard to the end of that partition is sent as WRITE
SAME(10) with its LBA truncated. sd_setup_read_write_cmnd() fails reads
and writes there with "access beyond end of device", but discards and
write zeroes have no such check.

Would you rather I fix those in the block layer, or have sd check the
LBA and count before it builds the command?

Chris
